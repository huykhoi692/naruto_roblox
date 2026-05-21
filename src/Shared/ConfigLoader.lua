-- ConfigLoader.lua
-- ModuleScript: ReplicatedStorage.Shared.ConfigLoader
-- Đặt trong: ReplicatedStorage > Shared > ConfigLoader (cùng folder với DataLoader)
--
-- Nhiệm vụ:
--   - Wrapper chuyên biệt cho balance-config.json
--   - Mọi system cần số liệu balance đọc qua đây — KHÔNG hardcode trong Lua
--   - Expose các hàm tính toán stat, EXP, SP, damage config
--
-- Dependency: DataLoader (cùng folder, phải loadAll() trước)

local DataLoader = require(script.Parent.DataLoader)

local ConfigLoader = {}

-- ============================================================
-- Helper nội bộ
-- ============================================================

-- Lấy balance data, warn nếu chưa load
local function getBalance()
	local data = DataLoader.getData("balance")
	if not data then
		warn("[ConfigLoader] balance-config chưa được load — gọi DataLoader.loadAll() trước")
	end
	return data
end

-- ============================================================
-- Player Stats
-- ============================================================

-- Trả về toàn bộ playerStats table từ balance-config
function ConfigLoader.getPlayerStatConfig()
	local data = getBalance()
	return data and data.playerStats or {}
end

-- Tính HP tối đa theo level
-- Công thức: baseHP + hpPerLevel * level
function ConfigLoader.calcMaxHP(level)
	local ps = ConfigLoader.getPlayerStatConfig()
	return (ps.baseHP or 100) + (ps.hpPerLevel or 18) * level
end

-- Tính Chakra tối đa theo level
-- Công thức: baseChakra + chakraPerLevel * level
function ConfigLoader.calcMaxChakra(level)
	local ps = ConfigLoader.getPlayerStatConfig()
	return (ps.baseChakra or 100) + (ps.chakraPerLevel or 8) * level
end

-- Tính Attack theo level
-- Công thức: baseAttack + attackPerLevel * level
function ConfigLoader.calcAttack(level)
	local ps = ConfigLoader.getPlayerStatConfig()
	return (ps.baseAttack or 10) + (ps.attackPerLevel or 2.5) * level
end

-- Tính Defense theo level
-- Công thức: baseDefense + defensePerLevel * level
function ConfigLoader.calcDefense(level)
	local ps = ConfigLoader.getPlayerStatConfig()
	return (ps.baseDefense or 5) + (ps.defensePerLevel or 1.2) * level
end

-- Tính tốc độ di chuyển (studs/giây)
-- Speed không scale theo level — baseSpeed là hằng số (16 studs/s = mặc định Roblox)
-- Buff/quest có thể cộng thêm qua permanentBonuses.speed
function ConfigLoader.calcSpeed()
	local ps = ConfigLoader.getPlayerStatConfig()
	return ps.baseSpeed or 16
end

-- Max level của game
function ConfigLoader.getMaxLevel()
	local ps = ConfigLoader.getPlayerStatConfig()
	return ps.maxLevel or 50
end

-- Tier jutsu tối đa có thể học trong phiên bản hiện tại
-- v0.1 = 2 (Tier 1–2 only). Tăng số này trong balance-config khi mở thêm content.
function ConfigLoader.getMaxLearnableTier()
	local data = getBalance()
	if not data then return 2 end
	return (data.skillPointSystem and data.skillPointSystem.maxLearnableTier) or 2
end

-- ============================================================
-- EXP System
-- ============================================================

-- EXP cần để lên level tiếp theo từ level hiện tại
-- Công thức: baseExpToLevel * (expScalingFactor ^ level)
function ConfigLoader.getExpRequired(level)
	local data = getBalance()
	if not data then return 150 end
	local exp = data.expSystem
	if not exp then return 150 end
	return math.floor((exp.baseExpToLevel or 150) * ((exp.expScalingFactor or 1.15) ^ level))
end

-- EXP nhận được khi kill NPC (tính bonus/penalty chênh lệch level)
-- attackerLevel, defenderLevel: level của người tấn công và NPC
function ConfigLoader.getKillNPCExp(attackerLevel, defenderLevel)
	local data = getBalance()
	if not data then return 20 end
	local src = data.expSystem and data.expSystem.expSources and data.expSystem.expSources.killNPC
	if not src then return 20 end

	local base = src.base or 20
	local diff = attackerLevel - defenderLevel
	if diff == 0 then
		return math.floor(base * (src.levelMatchBonus or 1.5))
	elseif diff > 0 then
		-- Người chơi cấp cao hơn NPC → penalty
		return math.floor(base * (src.levelMismatchPenalty or 0.3))
	else
		-- Người chơi cấp thấp hơn NPC → bonus match
		return math.floor(base * (src.levelMatchBonus or 1.5))
	end
end

-- EXP nhận được khi kill boss theo arc
-- arcIndex: 1–4
function ConfigLoader.getKillBossExp(arcIndex)
	local data = getBalance()
	if not data then return 500 end
	local src = data.expSystem and data.expSystem.expSources and data.expSystem.expSources.killBoss
	if not src then return 500 end
	local mult = (src.arcMultiplier or {})[arcIndex] or 1.0
	return math.floor((src.base or 500) * mult)
end

-- EXP nhận được khi hoàn thành quest theo tier (1–5)
function ConfigLoader.getQuestExp(questTier)
	local data = getBalance()
	if not data then return 200 end
	local src = data.expSystem and data.expSystem.expSources and data.expSystem.expSources.completeQuest
	if not src then return 200 end
	local mult = (src.tierMultiplier or {})[questTier] or 1.0
	return math.floor((src.base or 200) * mult)
end

-- ============================================================
-- Skill Point System
-- ============================================================

-- SP nhận được mỗi lần level up (cơ bản)
function ConfigLoader.getSPPerLevel()
	local data = getBalance()
	if not data then return 2 end
	return (data.skillPointSystem and data.skillPointSystem.spPerLevel) or 2
end

-- SP bonus của No Clan per level (có giới hạn ở noClanBonusSPCap đầu tiên)
-- Trả về 0 nếu currentLevel > cap
function ConfigLoader.getNoClanBonusSP(currentLevel)
	local data = getBalance()
	if not data then return 0 end
	local sp = data.skillPointSystem
	if not sp then return 0 end
	local cap = sp.noClanBonusSPCap or 30
	if currentLevel <= cap then
		return sp.noClanBonusSP or 1
	end
	return 0
end

-- Chi phí SP để học jutsu theo tier, tính affinity discount nếu có
-- tier: 1–5
-- hasAffinity: boolean (player có đúng Chakra Affinity không)
-- Theo spec: làm tròn LÊN sau khi áp discount
function ConfigLoader.getJutsuLearnCost(tier, hasAffinity)
	local data = getBalance()
	if not data then return tier end  -- fallback đơn giản
	local sp = data.skillPointSystem
	if not sp or not sp.jutsuLearnCost then return tier end

	local tierKey = "tier" .. tostring(tier)
	local baseCost = sp.jutsuLearnCost[tierKey]
	if not baseCost then
		warn("[ConfigLoader] Không có jutsu learn cost cho tier " .. tostring(tier))
		return tier
	end

	if hasAffinity then
		local discount = sp.affinityDiscount or 0.3
		return math.ceil(baseCost * (1 - discount))
	end
	return baseCost
end

-- ============================================================
-- Chakra System
-- ============================================================

-- Trả về toàn bộ chakraSystem config
function ConfigLoader.getChakraConfig()
	local data = getBalance()
	return (data and data.chakraSystem) or {}
end

-- Chakra regen mỗi giây (theo trạng thái combat)
-- inCombat: boolean
function ConfigLoader.getChakraRegen(inCombat)
	local cfg = ConfigLoader.getChakraConfig()
	local base = cfg.regenPerSecond or 3
	if inCombat then
		return base * (cfg.regenInCombatMultiplier or 0.4)
	else
		return base * (cfg.regenOutOfCombatMultiplier or 1.0)
	end
end

-- Thời gian cooldown để thoát trạng thái combat (giây)
function ConfigLoader.getCombatCooldown()
	local cfg = ConfigLoader.getChakraConfig()
	return cfg.combatCooldownSeconds or 5
end

-- ============================================================
-- Damage Formula
-- ============================================================

-- Trả về toàn bộ damage formula components từ balance-config
-- CombatCalculator sẽ dùng để tính damage — không hardcode số ở đây
function ConfigLoader.getDamageFormulaComponents()
	local data = getBalance()
	if not data or not data.damageFormula then return {} end
	return data.damageFormula.components or {}
end

-- Affinity multiplier khi dùng jutsu đúng/sai hệ
-- isMatching: true nếu jutsu.chakraType == player.chakraAffinity
function ConfigLoader.getAffinityMultiplier(isMatching)
	local comp = ConfigLoader.getDamageFormulaComponents()
	local aff  = comp.affinityMult or { matching = 1.15, nonMatching = 1.0 }
	return isMatching and (aff.matching or 1.15) or (aff.nonMatching or 1.0)
end

-- Level scaling config (cap, floor, formula)
-- finalScaling = clamp(1 + (attackerLv - defenderLv) * 0.02, floor, cap)
function ConfigLoader.getLevelScalingConfig()
	local comp = ConfigLoader.getDamageFormulaComponents()
	return comp.levelScaling or { cap = 1.3, floor = 0.7 }
end

-- Damage variance config (±5% random)
function ConfigLoader.getVarianceConfig()
	local comp = ConfigLoader.getDamageFormulaComponents()
	return comp.randomVariance or { min = 0.95, max = 1.05 }
end

-- Defense mitigation formula: 1 - (def / (def + 100))
-- Trả về hệ số nhân (0–1), không phải % giảm
function ConfigLoader.calcDefenseMitigation(defenseValue)
	-- Công thức diminishing returns từ balance-config
	-- Không hardcode — luôn dùng công thức này
	return 1 - (defenseValue / (defenseValue + 100))
end

-- ============================================================
-- Boss Stats
-- ============================================================

-- Stats của boss theo context
-- bossId: key trong bossStats.bosses (ví dụ: "zaborax", "hakuren")
-- context: "story" (solo/small group, dùng storyHP) | "event" (toàn server, dùng eventHP)
-- Trả về {hp, defense, attack, lootTable} hoặc nil nếu boss không tồn tại
function ConfigLoader.getBossStats(bossId, context)
	local data = getBalance()
	if not data then return nil end

	local bosses = data.bossStats and data.bossStats.bosses
	if not bosses then return nil end

	local boss = bosses[bossId]
	if not boss then
		warn("[ConfigLoader] Boss không tồn tại trong bossStats: " .. tostring(bossId))
		return nil
	end

	local hpKey = (context == "event") and "eventHP" or "storyHP"
	return {
		hp        = boss[hpKey],
		defense   = boss.baseDefense,
		attack    = boss.baseAttack,
		lootTable = boss.lootTable,
	}
end

-- ============================================================
-- Economy
-- ============================================================

-- Giá cả trong shop (tier1JutsuScroll, tier2JutsuScroll, v.v.)
function ConfigLoader.getShopPrices()
	local data = getBalance()
	return (data and data.economySystem and data.economySystem.shopPrices) or {}
end

-- Drop rate Ryo từ enemy (normalEnemy, eliteEnemy, boss)
-- enemyType: "normalEnemy" | "eliteEnemy" | "boss"
-- Trả về {ryoMin, ryoMax}
function ConfigLoader.getDropRates(enemyType)
	local data = getBalance()
	if not data or not data.economySystem then return { ryoMin = 10, ryoMax = 50 } end
	local rates = data.economySystem.dropRates
	if enemyType then
		return rates[enemyType] or { ryoMin = 10, ryoMax = 50 }
	end
	return rates or {}
end

-- ============================================================
-- Reputation System
-- ============================================================

-- Trả về tier reputation của player trong faction
-- faction: "village" | "reimei"
-- repPoints: điểm rep hiện tại (số nguyên, có thể âm)
-- Trả về tên tier: "hostile"/"unfriendly"/"neutral"/"friendly"/"honored" (village)
--                  hoặc "unknown"/"noticed"/"respected"/"member" (reimei)
function ConfigLoader.getRepTier(faction, repPoints)
	local data = getBalance()
	if not data then return "neutral" end

	local factions = data.reputationSystem and data.reputationSystem.factions
	if not factions or not factions[faction] then return "neutral" end

	local thresholds = factions[faction].thresholds
	if not thresholds then return "neutral" end

	for tier, info in pairs(thresholds) do
		-- Dạng {max: N}: rep ≤ N
		if info.max ~= nil and repPoints <= info.max then
			return tier
		end
		-- Dạng {min: N}: rep ≥ N
		if info.min ~= nil and repPoints >= info.min then
			return tier
		end
		-- Dạng {range: [lo, hi]}: lo ≤ rep ≤ hi
		if info.range then
			local lo, hi = info.range[1], info.range[2]
			if repPoints >= lo and repPoints <= hi then
				return tier
			end
		end
	end

	-- Fallback
	return "neutral"
end

-- Trả về effects của tier (NPC reaction, quest unlock, v.v.)
function ConfigLoader.getRepTierEffect(faction, repPoints)
	local data = getBalance()
	if not data then return nil end

	local factions = data.reputationSystem and data.reputationSystem.factions
	if not factions or not factions[faction] then return nil end

	local thresholds = factions[faction].thresholds
	if not thresholds then return nil end

	local tier = ConfigLoader.getRepTier(faction, repPoints)
	return thresholds[tier] and thresholds[tier].effect or nil
end

-- Ending thresholds (dùng khi check Hero/Villain/Wanderer ở arc 4+)
function ConfigLoader.getEndingThresholds()
	local data = getBalance()
	return (data and data.reputationSystem and data.reputationSystem.endingThresholds) or {}
end

-- ============================================================
-- PvP System (v0.1 chưa dùng — expose để future phases không cần sửa interface)
-- ============================================================

-- Level gap tối đa trong PvP
function ConfigLoader.getPvPLevelGap()
	local data = getBalance()
	return (data and data.pvpSystem and data.pvpSystem.levelGap and data.pvpSystem.levelGap.maxGap) or 15
end

return ConfigLoader
