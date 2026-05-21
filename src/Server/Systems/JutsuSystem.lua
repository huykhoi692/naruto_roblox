-- JutsuSystem.lua
-- ModuleScript: ServerScriptService.Systems.JutsuSystem
-- Đặt trong: ServerScriptService > Systems > JutsuSystem
--
-- Nhiệm vụ:
--   - Quản lý việc học và trang bị jutsu cho player
--   - Đọc jutsu data từ DataLoader — không hardcode SP/cost/cooldown
--   - Tier gate: dùng ChakraAffinity.canLearnTier() — v0.1 chỉ mở Tier 1-2
--   - Affinity cost: dùng ConfigLoader.getJutsuLearnCost() với hasAffinity
--   - SP: gọi PlayerSystem.spendSP / refundSP
--   - Slot: gọi PlayerSystem.setJutsuSlot, max 6 slot (theo profile.jutsuSlots)
--
-- Dependency: DataLoader, PlayerSystem, ChakraAffinity, ConfigLoader
-- (phải DataLoader.loadAll() và PlayerSystem.init() trước khi dùng)
--
-- Khởi động: không cần init() riêng — dùng thẳng sau khi dependency sẵn sàng
--
-- Cách dùng (từ RemoteEvent handler hoặc QuestSystem):
--   JutsuSystem.learnJutsu(player, "jutsu_f01")    -- học jutsu
--   JutsuSystem.equipJutsu(player, "jutsu_f01", 1) -- trang bị vào slot 1
--   JutsuSystem.getCastInfo(player, "jutsu_f01")   -- lấy cost/damage đã tính affinity

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared           = ReplicatedStorage:WaitForChild("Shared")
local DataLoader       = require(Shared:WaitForChild("DataLoader"))
local ConfigLoader     = require(Shared:WaitForChild("ConfigLoader"))
local ChakraAffinity   = require(Shared:WaitForChild("ChakraAffinity"))

-- PlayerSystem nằm trong ServerScriptService — require qua absolute path
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerSystem = require(ServerScriptService:WaitForChild("Systems"):WaitForChild("PlayerSystem"))

local JutsuSystem = {}

-- ============================================================
-- Private helpers
-- ============================================================

-- Lấy jutsu data, warn nếu không tìm thấy
local function getJutsuData(jutsuId)
	local jutsu = DataLoader.getJutsuById(jutsuId)
	if not jutsu then
		warn("[JutsuSystem] jutsuId không tồn tại trong data:", jutsuId)
	end
	return jutsu
end

-- Lấy profile, warn nếu không có
local function getProfile(player)
	local profile = PlayerSystem.getProfile(player)
	if not profile then
		warn("[JutsuSystem] Không tìm thấy profile cho", player.Name)
	end
	return profile
end

-- ============================================================
-- Public API — Học Jutsu
-- ============================================================

-- Học jutsu: validate tier/affinity/SP, trừ SP, thêm vào learnedJutsu
--
-- jutsuId: ID từ jutsu-definitions.json (ví dụ: "jutsu_f01")
-- Trả về:
--   true                  nếu thành công
--   false, "reason"       nếu thất bại (reason là string mô tả lý do)
--
-- Các lý do fail có thể có:
--   "no_profile"          player chưa có profile
--   "jutsu_not_found"     jutsuId không hợp lệ
--   "already_learned"     đã học rồi
--   "tier_locked"         tier bị lock trong v0.1 (Tier 3-5)
--   "arc_locked"          jutsu yêu cầu arc cao hơn arc hiện tại
--   "not_enough_sp"       không đủ SP
function JutsuSystem.learnJutsu(player, jutsuId)
	local profile = getProfile(player)
	if not profile then return false, "no_profile" end

	local jutsu = getJutsuData(jutsuId)
	if not jutsu then return false, "jutsu_not_found" end

	-- Skip jutsu deferred (chưa implement trong data)
	if jutsu.status == "deferred_arc4" then
		return false, "jutsu_not_found"
	end

	-- Check đã học rồi chưa
	if profile.learnedJutsu[jutsuId] then
		return false, "already_learned"
	end

	-- Check tier gate (v0.1: Tier 1-2 only)
	-- ChakraAffinity.canLearnTier đọc từ balance-config — không hardcode
	if not ChakraAffinity.canLearnTier(jutsu.tier or 1) then
		warn("[JutsuSystem]", player.Name, "cố học jutsu Tier", jutsu.tier,
			"— bị lock trong v0.1 (maxLearnableTier =", ConfigLoader.getMaxLearnableTier() .. ")")
		return false, "tier_locked"
	end

	-- Check arc lock: jutsu.arcUnlock <= arc hiện tại của player
	local arcUnlock = jutsu.arcUnlock or 1
	if arcUnlock > profile.currentArc then
		warn("[JutsuSystem]", player.Name, "cố học jutsu arcUnlock=" .. arcUnlock,
			"nhưng đang ở arc", profile.currentArc)
		return false, "arc_locked"
	end

	-- Tính SP cost có tính affinity discount
	-- hasAffinity = true nếu jutsu.chakraType khớp với profile.chakraAffinity
	-- Jutsu chakraType "none" → không bao giờ matching → không được discount
	local hasAffinity = ChakraAffinity.isMatching(profile.chakraAffinity, jutsu.chakraType)
	local spCost = ConfigLoader.getJutsuLearnCost(jutsu.tier or 1, hasAffinity)

	-- Check và trừ SP
	if not PlayerSystem.spendSP(player, spCost) then
		warn("[JutsuSystem]", player.Name, "không đủ SP để học", jutsuId,
			"(cần:", spCost, "| có:", PlayerSystem.getFreeSP(player) .. ")")
		return false, "not_enough_sp"
	end

	-- Đánh dấu đã học
	profile.learnedJutsu[jutsuId] = true

	print("[JutsuSystem]", player.Name, "đã học:", jutsuId,
		"| Tier:", jutsu.tier, "| SP tiêu:", spCost,
		"| Affinity bonus:", hasAffinity,
		"| SP còn lại:", PlayerSystem.getFreeSP(player))

	return true
end

-- ============================================================
-- Public API — Trang bị / Tháo Jutsu
-- ============================================================

-- Trang bị jutsu đã học vào slot (1-6)
-- Nếu slot đã có jutsu khác → replace (không cần unequip trước)
--
-- Trả về true hoặc false, "reason"
-- Lý do fail: "no_profile" | "jutsu_not_found" | "not_learned" | "invalid_slot"
function JutsuSystem.equipJutsu(player, jutsuId, slotIndex)
	local profile = getProfile(player)
	if not profile then return false, "no_profile" end

	local jutsu = getJutsuData(jutsuId)
	if not jutsu then return false, "jutsu_not_found" end

	-- Phải học trước mới trang bị được
	if not profile.learnedJutsu[jutsuId] then
		warn("[JutsuSystem] equipJutsu:", player.Name, "chưa học", jutsuId)
		return false, "not_learned"
	end

	-- Validate slot (1-6) — PlayerSystem.setJutsuSlot đã validate nhưng ta check trước để có reason
	if type(slotIndex) ~= "number" or slotIndex < 1 or slotIndex > 6 then
		warn("[JutsuSystem] equipJutsu: slotIndex không hợp lệ:", slotIndex)
		return false, "invalid_slot"
	end

	-- Nếu jutsu này đã được trang bị ở slot khác → xóa slot cũ trước
	-- Tránh cùng jutsu xuất hiện ở 2 slot cùng lúc
	for i, existingId in ipairs(profile.jutsuSlots) do
		if existingId == jutsuId and i ~= slotIndex then
			PlayerSystem.setJutsuSlot(player, i, nil)
		end
	end

	local ok = PlayerSystem.setJutsuSlot(player, slotIndex, jutsuId)
	if ok then
		print("[JutsuSystem]", player.Name, "trang bị", jutsuId, "→ slot", slotIndex)
	end
	return ok or false, ok and nil or "invalid_slot"
end

-- Tháo jutsu khỏi slot (đặt về nil)
-- slotIndex: 1-6
-- Trả về true hoặc false, "reason"
function JutsuSystem.unequipJutsu(player, slotIndex)
	local profile = getProfile(player)
	if not profile then return false, "no_profile" end

	if type(slotIndex) ~= "number" or slotIndex < 1 or slotIndex > 6 then
		return false, "invalid_slot"
	end

	PlayerSystem.setJutsuSlot(player, slotIndex, nil)
	print("[JutsuSystem]", player.Name, "tháo jutsu khỏi slot", slotIndex)
	return true
end

-- ============================================================
-- Public API — Unlearn (hoàn trả SP)
-- ============================================================

-- Xóa jutsu đã học: hoàn trả SP, xóa khỏi learnedJutsu và tất cả slot đang dùng
-- Trả về true hoặc false, "reason"
-- Lý do fail: "no_profile" | "jutsu_not_found" | "not_learned"
function JutsuSystem.unlearnJutsu(player, jutsuId)
	local profile = getProfile(player)
	if not profile then return false, "no_profile" end

	local jutsu = getJutsuData(jutsuId)
	if not jutsu then return false, "jutsu_not_found" end

	if not profile.learnedJutsu[jutsuId] then
		return false, "not_learned"
	end

	-- Hoàn trả SP (dùng cost hiện tại với affinity)
	local hasAffinity = ChakraAffinity.isMatching(profile.chakraAffinity, jutsu.chakraType)
	local spCost = ConfigLoader.getJutsuLearnCost(jutsu.tier or 1, hasAffinity)
	PlayerSystem.refundSP(player, spCost)

	-- Xóa khỏi learned
	profile.learnedJutsu[jutsuId] = nil

	-- Xóa khỏi tất cả slot đang dùng
	for i, slotJutsuId in ipairs(profile.jutsuSlots) do
		if slotJutsuId == jutsuId then
			PlayerSystem.setJutsuSlot(player, i, nil)
		end
	end

	print("[JutsuSystem]", player.Name, "unlearn:", jutsuId, "| SP hoàn trả:", spCost)
	return true
end

-- ============================================================
-- Public API — Query
-- ============================================================

-- Lấy danh sách jutsuId đã học (array)
function JutsuSystem.getLearnedJutsu(player)
	local profile = getProfile(player)
	if not profile then return {} end

	local result = {}
	for jutsuId, _ in pairs(profile.learnedJutsu) do
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
		result[i] = profile.jutsuSlots[i]  -- nil nếu trống
	end
	return result
end

-- Lấy số slot còn trống (tối đa 6)
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
-- Public API — Cast Info (dùng bởi CombatSystem Phase 6)
-- ============================================================

-- Lấy thông tin cast jutsu đã áp affinity multiplier
-- Trả về table hoặc nil nếu jutsu/profile không hợp lệ
--
-- Kết quả:
--   jutsuId        string
--   tier           number (1-5)
--   chakraType     string ("fire"/"water"/..."none")
--   baseDamage     number  (từ data, trước affinity)
--   finalDamage    number  (baseDamage * damageMult)
--   baseCost       number  (chakraCost % pool, từ data)
--   finalCost      number  (baseCost * costMult)
--   cooldown       number  (giây, từ data — không nhân affinity)
--   castTime       number  (giây)
--   isAffinity     boolean (player có đúng hệ không)
--   costMult       number  (0.7 nếu matching, 1.0 nếu không)
--   damageMult     number  (1.15 nếu matching, 1.0 nếu không)
--   effects        table   (array effects từ data)
--   pvpUsable      boolean
function JutsuSystem.getCastInfo(player, jutsuId)
	local profile = getProfile(player)
	if not profile then return nil end

	local jutsu = getJutsuData(jutsuId)
	if not jutsu or jutsu.status == "deferred_arc4" then return nil end

	-- Tính affinity multipliers
	local bonuses = ChakraAffinity.getBonuses(profile.chakraAffinity, jutsu.chakraType)

	local baseDamage = jutsu.baseDamage or 0
	local baseCost   = jutsu.chakraCost or 0

	return {
		jutsuId     = jutsuId,
		tier        = jutsu.tier or 1,
		chakraType  = jutsu.chakraType or "none",
		baseDamage  = baseDamage,
		finalDamage = baseDamage * bonuses.damageMult,
		baseCost    = baseCost,
		finalCost   = baseCost * bonuses.costMult,
		cooldown    = jutsu.cooldown  or 0,
		castTime    = jutsu.castTime  or 0,
		range       = jutsu.range     or "melee",
		aoeRadius   = jutsu.aoeRadius or 0,
		isAffinity  = bonuses.costMult < 1.0,  -- true nếu có discount
		costMult    = bonuses.costMult,
		damageMult  = bonuses.damageMult,
		effects     = jutsu.effects   or {},
		pvpUsable   = jutsu.pvpUsable == true,
	}
end

return JutsuSystem
