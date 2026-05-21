-- JutsuSystem.lua
-- ModuleScript: ServerScriptService.Systems.JutsuSystem
-- Đặt trong: ServerScriptService > Systems > JutsuSystem
--
-- Nhiệm vụ:
--   - Quản lý học, trang bị và cast jutsu
--   - Đọc data từ DataLoader — không hardcode SP/cost/cooldown/damage
--   - Tier gate: ChakraAffinity.canLearnTier() — v0.1 chỉ mở Tier 1-2
--   - SP cost khi học: ConfigLoader.getJutsuLearnCost(tier, hasAffinity)
--   - Cooldown: server-side per player per jutsuId dùng tick()
--   - Chakra cost khi cast: chakraCost là % của maxChakra pool (theo data notes)
--       actualCost = maxChakra * (finalCost / 100)
--   - castJutsu KHÔNG apply damage — CombatCalculator (Phase 6) làm việc đó
--
-- Result object pattern (action functions):
--   Success: { success = true,  data = { ... } }
--   Failure: { success = false, reason = "string_key" }
--
-- Dependency order: DataLoader ← ConfigLoader ← ChakraAffinity ← JutsuSystem
-- Phải gọi DataLoader.loadAll() và PlayerSystem.init() trước khi dùng module này.
--
-- Lifecycle:
--   Server init gọi: PlayerSystem.init() — kết nối PlayerAdded/PlayerRemoving
--   Server init cũng kết nối: Players.PlayerRemoving → JutsuSystem.onPlayerLeaving(player)

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
-- Dọn dẹp trong onPlayerLeaving() để tránh memory leak
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

-- Trả về jutsu data hoặc nil (không warn — caller quyết định)
local function getJutsuData(jutsuId)
	return DataLoader.getJutsuById(jutsuId)
end

-- Trả về jutsu data nếu tồn tại VÀ không bị deferred
local function getUsableJutsu(jutsuId)
	local jutsu = getJutsuData(jutsuId)
	if not jutsu then return nil end
	if jutsu.status == "deferred_arc4" then return nil end
	return jutsu
end

-- Trả về profile hoặc nil (có warn)
local function getProfile(player)
	local profile = PlayerSystem.getProfile(player)
	if not profile then
		warn("[JutsuSystem] Không tìm thấy profile cho", player.Name)
	end
	return profile
end

-- ============================================================
-- Public API — Player lifecycle
-- ============================================================

-- Dọn cooldown khi player rời game (tránh memory leak)
-- Gọi từ server init: Players.PlayerRemoving:Connect(JutsuSystem.onPlayerLeaving)
function JutsuSystem.onPlayerLeaving(player)
	_cooldowns[player] = nil
end

-- ============================================================
-- Public API — Cooldown
-- ============================================================

-- Giây còn lại trên cooldown (0 nếu sẵn sàng)
function JutsuSystem.getCooldownRemaining(player, jutsuId)
	local playerCDs = _cooldowns[player]
	if not playerCDs then return 0 end
	local readyAt = playerCDs[jutsuId]
	if not readyAt then return 0 end
	local remaining = readyAt - tick()
	return remaining > 0 and remaining or 0
end

-- Trả về true nếu jutsu đang trên cooldown
function JutsuSystem.isOnCooldown(player, jutsuId)
	return JutsuSystem.getCooldownRemaining(player, jutsuId) > 0
end

-- Bắt đầu cooldown (gọi nội bộ sau cast thành công)
function JutsuSystem.startCooldown(player, jutsuId, cooldownSeconds)
	if not _cooldowns[player] then
		_cooldowns[player] = {}
	end
	_cooldowns[player][jutsuId] = tick() + cooldownSeconds
end

-- ============================================================
-- Public API — canLearnJutsu (dry-run, không đổi state)
-- ============================================================

-- Kiểm tra điều kiện học jutsu mà KHÔNG thay đổi bất kỳ state nào.
-- Dùng để hiển thị tooltip UI, hoặc để learnJutsu() tái sử dụng.
--
-- Returns:
--   { success = true,  data = { spCost, hasAffinity, jutsu } }
--   { success = false, reason = "no_profile" | "jutsu_not_found" | "already_learned"
--                               | "tier_locked" | "arc_locked" | "not_enough_sp" }
function JutsuSystem.canLearnJutsu(player, jutsuId)
	local profile = getProfile(player)
	if not profile then return fail("no_profile") end

	local jutsu = getUsableJutsu(jutsuId)
	if not jutsu then return fail("jutsu_not_found") end

	-- Check đã học rồi chưa
	if profile.learnedJutsu[jutsuId] then
		return fail("already_learned")
	end

	-- Tier gate: v0.1 chỉ mở Tier 1-2 — đọc từ balance-config qua ConfigLoader
	if not ChakraAffinity.canLearnTier(jutsu.tier or 1) then
		return fail("tier_locked")
	end

	-- Arc gate: jutsu.arcUnlock phải <= arc hiện tại của player
	if (jutsu.arcUnlock or 1) > profile.currentArc then
		return fail("arc_locked")
	end

	-- SP check (chỉ đọc, không trừ)
	local hasAffinity = ChakraAffinity.isMatching(profile.chakraAffinity, jutsu.chakraType)
	local spCost = ConfigLoader.getJutsuLearnCost(jutsu.tier or 1, hasAffinity)
	if PlayerSystem.getFreeSP(player) < spCost then
		return fail("not_enough_sp")
	end

	return ok({ spCost = spCost, hasAffinity = hasAffinity, jutsu = jutsu })
end

-- ============================================================
-- Public API — learnJutsu
-- ============================================================

-- Học jutsu: chạy canLearnJutsu() để validate, trừ SP, đánh dấu learned.
--
-- Returns:
--   { success = true,  data = { jutsuId, spCost, remainingSP } }
--   { success = false, reason = "..." }  (xem canLearnJutsu cho danh sách reason)
function JutsuSystem.learnJutsu(player, jutsuId)
	-- Tái sử dụng canLearnJutsu — không lặp validation logic
	local check = JutsuSystem.canLearnJutsu(player, jutsuId)
	if not check.success then return check end

	local spCost      = check.data.spCost
	local hasAffinity = check.data.hasAffinity
	local jutsu       = check.data.jutsu

	-- Profile guaranteed non-nil sau canLearnJutsu
	local profile = PlayerSystem.getProfile(player)

	-- Trừ SP (spendSP là authority — guard thêm phòng race condition)
	if not PlayerSystem.spendSP(player, spCost) then
		return fail("not_enough_sp")
	end

	-- Đánh dấu đã học
	profile.learnedJutsu[jutsuId] = true

	local remaining = PlayerSystem.getFreeSP(player)
	print("[JutsuSystem]", player.Name, "học:", jutsuId,
		"| Tier:", jutsu.tier,
		"| SP tiêu:", spCost,
		"| Affinity:", hasAffinity,
		"| SP còn:", remaining)

	return ok({ jutsuId = jutsuId, spCost = spCost, remainingSP = remaining })
end

-- ============================================================
-- Public API — equipJutsu / unequipJutsu / unlearnJutsu
-- ============================================================

-- Trang bị jutsu đã học vào slot (1-6)
-- Replace nếu slot đã có jutsu khác.
-- Tự xóa slot cũ nếu jutsu này đang equipped ở chỗ khác (tránh duplicate slot).
--
-- Returns: { success = true,  data = { jutsuId, slotIndex } }
--          { success = false, reason = "no_profile"|"jutsu_not_found"|"not_learned"|"invalid_slot" }
function JutsuSystem.equipJutsu(player, jutsuId, slotIndex)
	local profile = getProfile(player)
	if not profile then return fail("no_profile") end

	local jutsu = getUsableJutsu(jutsuId)
	if not jutsu then return fail("jutsu_not_found") end

	if not profile.learnedJutsu[jutsuId] then
		warn("[JutsuSystem] equipJutsu:", player.Name, "chưa học", jutsuId)
		return fail("not_learned")
	end

	if type(slotIndex) ~= "number" or slotIndex < 1 or slotIndex > 6 then
		warn("[JutsuSystem] equipJutsu: slotIndex không hợp lệ:", slotIndex)
		return fail("invalid_slot")
	end

	-- Xóa slot cũ nếu jutsu đang equipped ở nơi khác
	-- Dùng for số (không ipairs) để không bỏ qua slot nil ở giữa
	for i = 1, 6 do
		if profile.jutsuSlots[i] == jutsuId and i ~= slotIndex then
			PlayerSystem.setJutsuSlot(player, i, nil)
		end
	end

	if not PlayerSystem.setJutsuSlot(player, slotIndex, jutsuId) then
		return fail("invalid_slot")
	end

	print("[JutsuSystem]", player.Name, "trang bị", jutsuId, "→ slot", slotIndex)
	return ok({ jutsuId = jutsuId, slotIndex = slotIndex })
end

-- Tháo jutsu khỏi slot (slotIndex: 1-6), đặt về nil
--
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
	print("[JutsuSystem]", player.Name, "tháo slot", slotIndex,
		"| trước:", tostring(previous))
	return ok({ slotIndex = slotIndex, removed = previous })
end

-- Xóa jutsu đã học: hoàn trả SP, xóa khỏi learnedJutsu và tất cả slot đang dùng
--
-- Returns: { success = true,  data = { jutsuId, spRefunded } }
--          { success = false, reason = "no_profile"|"jutsu_not_found"|"not_learned" }
function JutsuSystem.unlearnJutsu(player, jutsuId)
	local profile = getProfile(player)
	if not profile then return fail("no_profile") end

	-- Dùng getJutsuData (không cần usable check — cho phép unlearn jutsu deferred nếu đã học)
	local jutsu = getJutsuData(jutsuId)
	if not jutsu then return fail("jutsu_not_found") end

	if not profile.learnedJutsu[jutsuId] then
		return fail("not_learned")
	end

	-- Hoàn trả SP theo cost có affinity
	local hasAffinity = ChakraAffinity.isMatching(profile.chakraAffinity, jutsu.chakraType)
	local spCost = ConfigLoader.getJutsuLearnCost(jutsu.tier or 1, hasAffinity)
	PlayerSystem.refundSP(player, spCost)

	-- Xóa khỏi learnedJutsu
	profile.learnedJutsu[jutsuId] = nil

	-- Xóa khỏi tất cả slot đang dùng
	-- Dùng for số để không bỏ qua slot nil ở giữa
	for i = 1, 6 do
		if profile.jutsuSlots[i] == jutsuId then
			PlayerSystem.setJutsuSlot(player, i, nil)
		end
	end

	print("[JutsuSystem]", player.Name, "unlearn:", jutsuId, "| SP hoàn trả:", spCost)
	return ok({ jutsuId = jutsuId, spRefunded = spCost })
end

-- ============================================================
-- Public API — castJutsu
-- ============================================================

-- Cast jutsu từ slot (1-6).
-- Validate đầy đủ → trừ chakra → bắt đầu cooldown → trả kết quả cho CombatCalculator.
-- Không apply damage — CombatCalculator (Phase 6) đọc castInfo và tính damage.
--
-- chakraCost trong data = % của maxChakra pool:
--   actualCost = maxChakra * (finalCost / 100)
--   ví dụ: jutsu.chakraCost = 12, affinity costMult = 0.7
--          finalCost = 12 * 0.7 = 8.4%
--          actualCost = 1200 * 0.084 = 100.8 chakra
--
-- targetData: table tự do từ client/AI (position, targetId, v.v.)
--             JutsuSystem không parse — chỉ forward cho CombatCalculator
--
-- Returns (success):
--   {
--     success = true,
--     data = {
--       jutsuId, slotIndex, chakraSpent, cooldown, castTime,
--       castInfo,   ← full getCastInfo() result (damage chưa tính, để Phase 6 làm)
--       targetData  ← forwarded as-is
--     }
--   }
-- Returns (failure):
--   { success = false, reason = "no_profile"|"invalid_slot"|"slot_empty"|
--                               "jutsu_not_found"|"not_learned"|"tier_locked"|
--                               "arc_locked"|"on_cooldown"|"not_enough_chakra" }
function JutsuSystem.castJutsu(player, slotIndex, targetData)
	local profile = getProfile(player)
	if not profile then return fail("no_profile") end

	-- Validate slot index
	if type(slotIndex) ~= "number" or slotIndex < 1 or slotIndex > 6 then
		return fail("invalid_slot")
	end

	-- Slot phải có jutsu
	local jutsuId = profile.jutsuSlots[slotIndex]
	if not jutsuId then
		return fail("slot_empty")
	end

	-- Jutsu phải tồn tại và không deferred
	local jutsu = getUsableJutsu(jutsuId)
	if not jutsu then
		warn("[JutsuSystem] castJutsu: slot", slotIndex, "trỏ tới jutsu không hợp lệ:", jutsuId)
		return fail("jutsu_not_found")
	end

	-- Phải đã học (guard: tránh trường hợp slot có jutsu nhưng profile bị corrupt)
	if not profile.learnedJutsu[jutsuId] then
		warn("[JutsuSystem] castJutsu:", player.Name, "slot", slotIndex,
			"— jutsu chưa được học:", jutsuId)
		return fail("not_learned")
	end

	-- Tier gate (scope guard — tránh leak nếu maxLearnableTier bị hạ)
	if not ChakraAffinity.canLearnTier(jutsu.tier or 1) then
		warn("[JutsuSystem] castJutsu: tier_locked —", jutsuId, "Tier", jutsu.tier)
		return fail("tier_locked")
	end

	-- Arc gate
	if (jutsu.arcUnlock or 1) > profile.currentArc then
		return fail("arc_locked")
	end

	-- Cooldown check
	if JutsuSystem.isOnCooldown(player, jutsuId) then
		local remaining = JutsuSystem.getCooldownRemaining(player, jutsuId)
		warn("[JutsuSystem]", player.Name, "cast", jutsuId,
			"— on cooldown, còn", string.format("%.1f", remaining) .. "s")
		return fail("on_cooldown")
	end

	-- Lấy cast info (bao gồm affinity multipliers)
	local castInfo = JutsuSystem.getCastInfo(player, jutsuId)
	if not castInfo then return fail("jutsu_not_found") end

	-- Tính chakra thực tế phải trừ
	-- finalCost = % của maxChakra (ví dụ 8.4 = 8.4%)
	local stats     = PlayerSystem.getStats(player)
	local maxChakra = stats and stats.maxChakra    or 0
	local curChakra = stats and stats.currentChakra or 0
	local actualCost = maxChakra * (castInfo.finalCost / 100)

	if curChakra < actualCost then
		warn("[JutsuSystem]", player.Name, "không đủ chakra để cast", jutsuId,
			"(cần:", string.format("%.1f", actualCost),
			"| có:", string.format("%.1f", curChakra) .. ")")
		return fail("not_enough_chakra")
	end

	-- Trừ chakra
	PlayerSystem.modifyChakra(player, -actualCost)

	-- Bắt đầu cooldown
	JutsuSystem.startCooldown(player, jutsuId, castInfo.cooldown)

	print("[JutsuSystem]", player.Name, "cast:", jutsuId,
		"| Slot:", slotIndex,
		"| Chakra tiêu:", string.format("%.1f", actualCost),
		"| Cooldown:", castInfo.cooldown .. "s",
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
-- Public API — Query
-- ============================================================

-- Lấy danh sách jutsuId đã học (array, thứ tự không cố định)
function JutsuSystem.getLearnedJutsu(player)
	local profile = getProfile(player)
	if not profile then return {} end

	local result = {}
	for jutsuId in pairs(profile.learnedJutsu) do
		table.insert(result, jutsuId)
	end
	return result
end

-- Lấy mảng 6 slot đang trang bị (index 1-6, nil = trống)
-- Trả về copy để tránh mutation ngoài ý muốn
function JutsuSystem.getEquippedSlots(player)
	local profile = getProfile(player)
	if not profile then return {} end

	local result = {}
	for i = 1, 6 do
		result[i] = profile.jutsuSlots[i]
	end
	return result
end

-- Alias của getEquippedSlots — tên theo SKILL.md spec
-- Giữ getEquippedSlots cho backward compatibility
function JutsuSystem.getEquippedJutsu(player)
	return JutsuSystem.getEquippedSlots(player)
end

-- Lấy số slot còn trống (0-6)
function JutsuSystem.getFreeSlotCount(player)
	local slots = JutsuSystem.getEquippedSlots(player)
	local count = 0
	for i = 1, 6 do
		if slots[i] == nil then count = count + 1 end
	end
	return count
end

-- Kiểm tra player đã học jutsu chưa
function JutsuSystem.hasLearned(player, jutsuId)
	local profile = getProfile(player)
	if not profile then return false end
	return profile.learnedJutsu[jutsuId] == true
end

-- ============================================================
-- Public API — getCastInfo (cho CombatCalculator Phase 6)
-- ============================================================

-- Lấy thông tin cast đã áp affinity multiplier — KHÔNG thay đổi state.
-- CombatCalculator Phase 6 gọi hàm này để lấy finalDamage và tính damage thực tế.
--
-- Returns table hoặc nil nếu jutsu/profile không hợp lệ.
-- Fields:
--   jutsuId, tier, chakraType
--   baseDamage, finalDamage   ← finalDamage = baseDamage * damageMult
--   baseCost,   finalCost     ← finalCost   = baseCost   * costMult  (% of maxChakra)
--   cooldown, castTime, range, aoeRadius
--   isAffinity, costMult, damageMult
--   effects, pvpUsable
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
