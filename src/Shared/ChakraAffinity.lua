-- ChakraAffinity.lua
-- ModuleScript: ReplicatedStorage.Shared.ChakraAffinity
-- Đặt trong: ReplicatedStorage > Shared (cùng folder với ConfigLoader, DataLoader)
--
-- Nhiệm vụ:
--   - Tập trung toàn bộ logic Chakra Affinity — không lặp ở Combat hay JutsuSystem
--   - Đọc affinityRules (costReduction, damageBonus) từ jutsu-definitions.json
--   - Đọc maxLearnableTier từ ConfigLoader (balance-config) — v0.1 = 2
--   - Không hardcode hệ chakra: dùng VALID_AFFINITIES làm nguồn sự thật
--
-- Dependency: DataLoader, ConfigLoader (phải loadAll() trước)
--
-- Cách dùng (ví dụ trong CombatSystem Phase 6):
--   local bonuses = ChakraAffinity.getBonuses(profile.chakraAffinity, jutsuData.chakraType)
--   local finalCost   = jutsuData.chakraCost   * bonuses.costMult
--   local finalDamage = jutsuData.baseDamage   * bonuses.damageMult

local DataLoader   = require(script.Parent.DataLoader)
local ConfigLoader = require(script.Parent.ConfigLoader)

local ChakraAffinity = {}

-- ============================================================
-- Whitelist 5 hệ chakra hợp lệ
-- ĐỒNG BỘ với PlayerSystem.initCharacter — nếu thêm hệ mới, sửa cả 2 chỗ
-- "none" (jutsu trung lập) và giá trị lạ đều bị coi là non-matching
-- ============================================================
local VALID_AFFINITIES = {
	fire      = true,
	water     = true,
	earth     = true,
	wind      = true,
	lightning = true,
}

-- ============================================================
-- Private helper
-- ============================================================

-- Trả về affinityRules từ jutsu-definitions.json
-- Fallback về giá trị hardcode nếu DataLoader chưa sẵn (để unit test / early init)
local function getAffinityRules()
	local data = DataLoader.getData("jutsu")
	if not data then
		warn("[ChakraAffinity] jutsu-definitions chưa load — gọi DataLoader.loadAll() trước")
		return { costReduction = 0.3, damageBonus = 0.15 }
	end
	return data.affinityRules or { costReduction = 0.3, damageBonus = 0.15 }
end

-- ============================================================
-- Public API — Matching
-- ============================================================

-- Kiểm tra playerAffinity có khớp với jutsuChakraType không
-- Trả về false nếu một trong hai không hợp lệ hoặc là "none"
-- Jutsu chakraType "none" (phân thân, thay thế...) KHÔNG bao giờ matching
function ChakraAffinity.isMatching(playerAffinity, jutsuChakraType)
	if not VALID_AFFINITIES[playerAffinity]  then return false end
	if not VALID_AFFINITIES[jutsuChakraType] then return false end
	return playerAffinity == jutsuChakraType
end

-- Validate affinity string hợp lệ (dùng để guard trước khi gọi API khác)
function ChakraAffinity.isValidAffinity(affinity)
	return VALID_AFFINITIES[affinity] == true
end

-- ============================================================
-- Public API — Multipliers
-- ============================================================

-- Hệ số nhân chakraCost khi cast jutsu
-- Matching:     1 - costReduction  (mặc định 0.7 = giảm 30%)
-- Non-matching: 1.0 (không phạt theo design — spec nonAffinityPenalty = 0)
function ChakraAffinity.getCostMultiplier(playerAffinity, jutsuChakraType)
	if not ChakraAffinity.isMatching(playerAffinity, jutsuChakraType) then
		return 1.0
	end
	local rules = getAffinityRules()
	return 1.0 - (rules.costReduction or 0.3)
end

-- Hệ số nhân baseDamage khi cast jutsu
-- Matching:     1 + damageBonus  (mặc định 1.15 = tăng 15%)
-- Non-matching: 1.0
function ChakraAffinity.getDamageMultiplier(playerAffinity, jutsuChakraType)
	if not ChakraAffinity.isMatching(playerAffinity, jutsuChakraType) then
		return 1.0
	end
	local rules = getAffinityRules()
	return 1.0 + (rules.damageBonus or 0.15)
end

-- Convenience: trả cả hai multiplier trong một lần gọi
-- Dùng trong CombatSystem để tránh gọi hai hàm riêng
-- Returns: { costMult: number, damageMult: number }
function ChakraAffinity.getBonuses(playerAffinity, jutsuChakraType)
	return {
		costMult   = ChakraAffinity.getCostMultiplier(playerAffinity,  jutsuChakraType),
		damageMult = ChakraAffinity.getDamageMultiplier(playerAffinity, jutsuChakraType),
	}
end

-- ============================================================
-- Public API — Tier Gate (v0.1)
-- ============================================================

-- Kiểm tra tier jutsu có được phép học trong phiên bản hiện tại không
-- v0.1: maxLearnableTier = 2 (Tier 3–5 bị khóa)
-- Thay đổi giới hạn bằng cách sửa balance-config.skillPointSystem.maxLearnableTier
function ChakraAffinity.canLearnTier(tier)
	local maxTier = ConfigLoader.getMaxLearnableTier()
	return tier <= maxTier
end

-- ============================================================
-- Public API — Data access (cho UI tooltip, debug)
-- ============================================================

-- Trả về raw affinityRules (UI dùng để hiển thị tooltip bonus)
function ChakraAffinity.getAffinityRules()
	return getAffinityRules()
end

-- Trả về tier tối đa có thể học (dùng cho UI lock icon)
function ChakraAffinity.getMaxLearnableTier()
	return ConfigLoader.getMaxLearnableTier()
end

return ChakraAffinity
