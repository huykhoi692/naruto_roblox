-- JutsuSystem.lua
-- ModuleScript: ServerScriptService.Systems.JutsuSystem
-- Dat trong: ServerScriptService > Systems > JutsuSystem
--
-- Nhiem vu:
--   - Quan ly hoc, trang bi va cast jutsu
--   - Doc data tu DataLoader -- khong hardcode SP/cost/cooldown/damage
--   - Tier gate: ChakraAffinity.canLearnTier() -- v0.1 chi mo Tier 1-2
--   - SP cost khi hoc: ConfigLoader.getJutsuLearnCost(tier, hasAffinity)
--   - Cooldown: server-side per player per jutsuId dung tick()
--   - Chakra cost khi cast: chakraCost la % cua maxChakra pool (theo data notes)
--       actualCost = maxChakra * (finalCost / 100)
--   - castJutsu KHONG apply damage -- CombatCalculator (Phase 6) lam viec do
--
-- Result object pattern (action functions):
--   Success: { success = true,  data = { ... } }
--   Failure: { success = false, reason = "string_key" }
--
-- Dependency order: DataLoader <- ConfigLoader <- ChakraAffinity <- JutsuSystem
-- Phai goi DataLoader.loadAll() va PlayerSystem.init() truoc khi dung module nay.
--
-- Lifecycle:
--   Server init goi: PlayerSystem.init() -- ket noi PlayerAdded/PlayerRemoving
--   Server init cung ket noi: Players.PlayerRemoving -> JutsuSystem.onPlayerLeaving(player)

local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared         = ReplicatedStorage:WaitForChild("Shared")
local DataLoader     = require(Shared:WaitForChild("DataLoader"))
local ConfigLoader   = require(Shared:WaitForChild("ConfigLoader"))
local ChakraAffinity = require(Shared:WaitForChild("ChakraAffinity"))

local PlayerSystem = require(
	ServerScriptService:WaitForChild("Systems"):WaitForChild("PlayerSystem")
)

local JutsuSystem = {}

-- ============================================================
-- Internal state
-- ============================================================

-- Cooldown registry: _cooldowns[player][jutsuId] = readyAtTick
-- Don dep trong onPlayerLeaving() de tranh memory leak
local _cooldowns = {}

-- ============================================================
-- Private: result object constructors
-- ============================================================

local function ok(data)
	return { success = true, data = data or {} }
end

local function fail(reason)
	return { success = false, reason = reason }
end

-- ============================================================
-- Private: data helpers
-- ============================================================

local function getJutsuData(jutsuId)
	return DataLoader.getJutsuById(jutsuId)
end

local function getUsableJutsu(jutsuId)
	local jutsu = getJutsuData(jutsuId)
	if not jutsu then return nil end
	if jutsu.status == "deferred_arc4" then return nil end
	return jutsu
end

local function getProfile(player)
	local profile = PlayerSystem.getProfile(player)
	if not profile then
		warn("[JutsuSystem] Khong tim thay profile cho", player.Name)
	end
	return profile
end

-- ============================================================
-- Public API -- Player lifecycle
-- ============================================================

function JutsuSystem.onPlayerLeaving(player)
	_cooldowns[player] = nil
end

-- ============================================================
-- Public API -- Cooldown
-- ============================================================

function JutsuSystem.getCooldownRemaining(player, jutsuId)
	local playerCDs = _cooldowns[player]
	if not playerCDs then return 0 end
	local readyAt = playerCDs[jutsuId]
	if not readyAt then return 0 end
	local remaining = readyAt - tick()
	return remaining > 0 and remaining or 0
end

function JutsuSystem.isOnCooldown(player, jutsuId)
	return JutsuSystem.getCooldownRemaining(player, jutsuId) > 0
end

function JutsuSystem.startCooldown(player, jutsuId, cooldownSeconds)
	if not _cooldowns[player] then
		_cooldowns[player] = {}
	end
	_cooldowns[player][jutsuId] = tick() + cooldownSeconds
end

-- ============================================================
-- Public API -- canLearnJutsu (dry-run, khong doi state)
-- ============================================================
-- Returns:
--   { success = true,  data = { spCost, hasAffinity, jutsu } }
--   { success = false, reason = "no_profile"|"jutsu_not_found"|"already_learned"
--                               |"tier_locked"|"arc_locked"|"not_enough_sp" }
function JutsuSystem.canLearnJutsu(player, jutsuId)
	local profile = getProfile(player)
	if not profile then return fail("no_profile") end

	local jutsu = getUsableJutsu(jutsuId)
	if not jutsu then return fail("jutsu_not_found") end

	if profile.learnedJutsu[jutsuId] then
		return fail("already_learned")
	end

	if not ChakraAffinity.canLearnTier(jutsu.tier or 1) then
		return fail("tier_locked")
	end

	if (jutsu.arcUnlock or 1) > profile.currentArc then
		return fail("arc_locked")
	end

	local hasAffinity = ChakraAffinity.isMatching(profile.chakraAffinity, jutsu.chakraType)
	local spCost = ConfigLoader.getJutsuLearnCost(jutsu.tier or 1, hasAffinity)
	if PlayerSystem.getFreeSP(player) < spCost then
		return fail("not_enough_sp")
	end

	return ok({ spCost = spCost, hasAffinity = hasAffinity, jutsu = jutsu })
end

-- ============================================================
-- Public API -- learnJutsu
-- ============================================================
-- Returns:
--   { success = true,  data = { jutsuId, spCost, remainingSP } }
--   { success = false, reason = "..." }
function JutsuSystem.learnJutsu(player, jutsuId)
	local check = JutsuSystem.canLearnJutsu(player, jutsuId)
	if not check.success then return check end

	local spCost      = check.data.spCost
	local hasAffinity = check.data.hasAffinity
	local jutsu       = check.data.jutsu

	local profile = PlayerSystem.getProfile(player)

	if not PlayerSystem.spendSP(player, spCost) then
		return fail("not_enough_sp")
	end

	profile.learnedJutsu[jutsuId] = true

	local remaining = PlayerSystem.getFreeSP(player)
	print("[JutsuSystem]", player.Name, "hoc:", jutsuId,
		"| Tier:", jutsu.tier,
		"| SP tieu:", spCost,
		"| Affinity:", hasAffinity,
		"| SP con:", remaining)

	return ok({ jutsuId = jutsuId, spCost = spCost, remainingSP = remaining })
end

-- ============================================================
-- Public API -- equipJutsu / unequipJutsu / unlearnJutsu
-- ============================================================
-- Returns: { success = true,  data = { jutsuId, slotIndex } }
--          { success = false, reason = "no_profile"|"jutsu_not_found"|"not_learned"|"invalid_slot" }
function JutsuSystem.equipJutsu(player, jutsuId, slotIndex)
	local profile = getProfile(player)
	if not profile then return fail("no_profile") end

	local jutsu = getUsableJutsu(jutsuId)
	if not jutsu then return fail("jutsu_not_found") end

	if not profile.learnedJutsu[jutsuId] then
		warn("[JutsuSystem] equipJutsu:", player.Name, "chua hoc", jutsuId)
		return fail("not_learned")
	end

	-- Scope guard: ngan equip neu jutsu vuot tier/arc (vi du: maxLearnableTier bi ha sau khi da hoc)
	if not ChakraAffinity.canLearnTier(jutsu.tier or 1) then
		warn("[JutsuSystem] equipJutsu: tier_locked --", jutsuId, "Tier", jutsu.tier)
		return fail("tier_locked")
	end
	if (jutsu.arcUnlock or 1) > profile.currentArc then
		warn("[JutsuSystem] equipJutsu: arc_locked --", jutsuId, "arcUnlock", jutsu.arcUnlock)
		return fail("arc_locked")
	end

	if type(slotIndex) ~= "number" or slotIndex < 1 or slotIndex > 6 then
		warn("[JutsuSystem] equipJutsu: slotIndex khong hop le:", slotIndex)
		return fail("invalid_slot")
	end

	for i = 1, 6 do
		if profile.jutsuSlots[i] == jutsuId and i ~= slotIndex then
			PlayerSystem.setJutsuSlot(player, i, nil)
		end
	end

	if not PlayerSystem.setJutsuSlot(player, slotIndex, jutsuId) then
		return fail("invalid_slot")
	end

	print("[JutsuSystem]", player.Name, "trang bi", jutsuId, "-> slot", slotIndex)
	return ok({ jutsuId = jutsuId, slotIndex = slotIndex })
end

-- Returns: { success = true,  data = { slotIndex, removed = jutsuId|nil } }
--          { success = false, reason = "no_profile"|"invalid_slot" }
function JutsuSystem.unequipJutsu(player, slotIndex)
	local profile = getProfile(player)
	if not profile then return fail("no_profile") end

	if type(slotIndex) ~= "number" or slotIndex < 1 or slotIndex > 6 then
		return fail("invalid_slot")
	end

	local previous = profile.jutsuSlots[slotIndex]
	PlayerSystem.setJutsuSlot(player, slotIndex, nil)
	print("[JutsuSystem]", player.Name, "thao slot", slotIndex,
		"| truoc:", tostring(previous))
	return ok({ slotIndex = slotIndex, removed = previous })
end

-- Returns: { success = true,  data = { jutsuId, spRefunded } }
--          { success = false, reason = "no_profile"|"jutsu_not_found"|"not_learned" }
function JutsuSystem.unlearnJutsu(player, jutsuId)
	local profile = getProfile(player)
	if not profile then return fail("no_profile") end

	local jutsu = getJutsuData(jutsuId)
	if not jutsu then return fail("jutsu_not_found") end

	if not profile.learnedJutsu[jutsuId] then
		return fail("not_learned")
	end

	local hasAffinity = ChakraAffinity.isMatching(profile.chakraAffinity, jutsu.chakraType)
	local spCost = ConfigLoader.getJutsuLearnCost(jutsu.tier or 1, hasAffinity)
	PlayerSystem.refundSP(player, spCost)

	profile.learnedJutsu[jutsuId] = nil

	for i = 1, 6 do
		if profile.jutsuSlots[i] == jutsuId then
			PlayerSystem.setJutsuSlot(player, i, nil)
		end
	end

	print("[JutsuSystem]", player.Name, "unlearn:", jutsuId, "| SP hoan tra:", spCost)
	return ok({ jutsuId = jutsuId, spRefunded = spCost })
end

-- ============================================================
-- Public API -- castJutsu
-- ============================================================
-- Cast jutsu tu slot (1-6).
-- chakraCost trong data = % cua maxChakra pool:
--   actualCost = maxChakra * (finalCost / 100)
-- Khong apply damage -- CombatCalculator (Phase 6) doc castInfo.
--
-- Returns (success): { success=true, data={ jutsuId, slotIndex, chakraSpent,
--                       cooldown, castTime, castInfo, targetData } }
-- Returns (failure): { success=false, reason = "no_profile"|"invalid_slot"|
--   "slot_empty"|"jutsu_not_found"|"not_learned"|"tier_locked"|"arc_locked"|
--   "on_cooldown"|"not_enough_chakra" }
function JutsuSystem.castJutsu(player, slotIndex, targetData)
	local profile = getProfile(player)
	if not profile then return fail("no_profile") end

	if type(slotIndex) ~= "number" or slotIndex < 1 or slotIndex > 6 then
		return fail("invalid_slot")
	end

	local jutsuId = profile.jutsuSlots[slotIndex]
	if not jutsuId then
		return fail("slot_empty")
	end

	local jutsu = getUsableJutsu(jutsuId)
	if not jutsu then
		warn("[JutsuSystem] castJutsu: slot", slotIndex, "tro toi jutsu khong hop le:", jutsuId)
		return fail("jutsu_not_found")
	end

	if not profile.learnedJutsu[jutsuId] then
		warn("[JutsuSystem] castJutsu:", player.Name, "slot", slotIndex,
			"-- jutsu chua duoc hoc:", jutsuId)
		return fail("not_learned")
	end

	if not ChakraAffinity.canLearnTier(jutsu.tier or 1) then
		warn("[JutsuSystem] castJutsu: tier_locked --", jutsuId, "Tier", jutsu.tier)
		return fail("tier_locked")
	end

	if (jutsu.arcUnlock or 1) > profile.currentArc then
		return fail("arc_locked")
	end

	if JutsuSystem.isOnCooldown(player, jutsuId) then
		local remaining = JutsuSystem.getCooldownRemaining(player, jutsuId)
		warn("[JutsuSystem]", player.Name, "cast", jutsuId,
			"-- on cooldown, con", string.format("%.1f", remaining) .. "s")
		return fail("on_cooldown")
	end

	local castInfo = JutsuSystem.getCastInfo(player, jutsuId)
	if not castInfo then return fail("jutsu_not_found") end

	local stats     = PlayerSystem.getStats(player)
	local maxChakra = stats and stats.maxChakra     or 0
	local curChakra = stats and stats.currentChakra or 0
	local actualCost = maxChakra * (castInfo.finalCost / 100)

	if curChakra < actualCost then
		warn("[JutsuSystem]", player.Name, "khong du chakra de cast", jutsuId,
			"(can:", string.format("%.1f", actualCost),
			"| co:", string.format("%.1f", curChakra) .. ")")
		return fail("not_enough_chakra")
	end

	PlayerSystem.modifyChakra(player, -actualCost)
	JutsuSystem.startCooldown(player, jutsuId, castInfo.cooldown)

	print("[JutsuSystem]", player.Name, "cast:", jutsuId,
		"| Slot:", slotIndex,
		"| Chakra tieu:", string.format("%.1f", actualCost),
		"| Cooldown:", tostring(castInfo.cooldown) .. "s",
		"| finalDamage:", string.format("%.1f", castInfo.finalDamage))

	return ok({
		jutsuId     = jutsuId,
		slotIndex   = slotIndex,
		chakraSpent = actualCost,
		cooldown    = castInfo.cooldown,
		castTime    = castInfo.castTime,
		castInfo    = castInfo,
		targetData  = targetData,
	})
end

-- ============================================================
-- Public API -- Query
-- ============================================================

function JutsuSystem.getLearnedJutsu(player)
	local profile = getProfile(player)
	if not profile then return {} end
	local result = {}
	for jutsuId in pairs(profile.learnedJutsu) do
		table.insert(result, jutsuId)
	end
	return result
end

function JutsuSystem.getEquippedSlots(player)
	local profile = getProfile(player)
	if not profile then return {} end
	local result = {}
	for i = 1, 6 do
		result[i] = profile.jutsuSlots[i]
	end
	return result
end

function JutsuSystem.getEquippedJutsu(player)
	return JutsuSystem.getEquippedSlots(player)
end

function JutsuSystem.getFreeSlotCount(player)
	local slots = JutsuSystem.getEquippedSlots(player)
	local count = 0
	for i = 1, 6 do
		if slots[i] == nil then count = count + 1 end
	end
	return count
end

function JutsuSystem.hasLearned(player, jutsuId)
	local profile = getProfile(player)
	if not profile then return false end
	return profile.learnedJutsu[jutsuId] == true
end

-- ============================================================
-- Public API -- getCastInfo (cho CombatCalculator Phase 6)
-- ============================================================
-- Low-level info helper: tinh castInfo voi affinity multiplier -- KHONG thay doi state.
-- KHONG enforce tier/arc scope -- scope enforcement la trach nhiem cua castJutsu()
-- va canCastJutsu() (tuong lai). Goi ham nay truc tiep chi de doc thong tin, khong de cast.
-- Returns table hoac nil.
-- Fields: jutsuId, tier, chakraType, baseDamage, finalDamage, baseCost, finalCost,
--         cooldown, castTime, range, aoeRadius, isAffinity, costMult, damageMult,
--         effects, pvpUsable
function JutsuSystem.getCastInfo(player, jutsuId)
	local profile = getProfile(player)
	if not profile then return nil end

	local jutsu = getUsableJutsu(jutsuId)
	if not jutsu then return nil end

	local bonuses    = ChakraAffinity.getBonuses(profile.chakraAffinity, jutsu.chakraType)
	local baseDamage = jutsu.baseDamage or 0
	local baseCost   = jutsu.chakraCost or 0

	return {
		jutsuId     = jutsuId,
		tier        = jutsu.tier       or 1,
		chakraType  = jutsu.chakraType or "none",
		baseDamage  = baseDamage,
		finalDamage = baseDamage * bonuses.damageMult,
		baseCost    = baseCost,
		finalCost   = baseCost  * bonuses.costMult,
		cooldown    = jutsu.cooldown   or 0,
		castTime    = jutsu.castTime   or 0,
		range       = jutsu.range      or "melee",
		aoeRadius   = jutsu.aoeRadius  or 0,
		isAffinity  = bonuses.costMult < 1.0,
		costMult    = bonuses.costMult,
		damageMult  = bonuses.damageMult,
		effects     = jutsu.effects    or {},
		pvpUsable   = jutsu.pvpUsable == true,
	}
end

return JutsuSystem
