-- PlayerSystem.lua
-- ModuleScript: ServerScriptService.Systems.PlayerSystem
-- Đặt trong: ServerScriptService > Systems > PlayerSystem
--
-- Nhiệm vụ:
--   - Quản lý toàn bộ profile người chơi trong game (in-memory)
--   - Stat tính từ ConfigLoader — KHÔNG hardcode số nào
--   - Designed để swap DataStore vào Phase 8+ qua setProfileLoader/setProfileSaver
--   - ClanSystem (Phase 5) hook vào qua registerStatModifier
--
-- Dependency: DataLoader, ConfigLoader (phải loadAll() trước khi dùng)
--
-- Cách khởi động (từ server init script):
--   local DataLoader   = require(ReplicatedStorage.Shared.DataLoader)
--   local PlayerSystem = require(ServerScriptService.Systems.PlayerSystem)
--   DataLoader.loadAll()
--   PlayerSystem.init()

local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Lazy require: đợi Shared folder sẵn sàng trước khi require
local Shared        = ReplicatedStorage:WaitForChild("Shared")
local DataLoader    = require(Shared:WaitForChild("DataLoader"))
local ConfigLoader  = require(Shared:WaitForChild("ConfigLoader"))

local PlayerSystem = {}

-- ============================================================
-- Internal state
-- ============================================================

-- Profile in-memory: _profiles[player] = profileTable
local _profiles = {}

-- Stat modifiers: array of function(baseStats, profile) → modifiedStats
-- ClanSystem đăng ký vào đây ở Phase 5
-- Mỗi hàm nhận baseStats (copy) và profile, trả về stats đã chỉnh
local _statModifiers = {}

-- DataStore hooks (nil = in-memory only, Phase 8+ điền vào)
-- setProfileLoader(fn): fn(player) → profileData hoặc nil
-- setProfileSaver(fn): fn(player, profileData)
local _profileLoader = nil
local _profileSaver  = nil

-- ============================================================
-- Profile schema (default values)
-- ============================================================
-- Ghi chú: tất cả số lấy từ ConfigLoader khi cần,
-- chỉ level=1 được hardcode vì đây là điểm khởi đầu tuyệt đối

local function newProfile()
	return {
		-- Nhân vật
		characterName    = "",     -- đặt trong initCharacter
		clanId           = nil,    -- "clan_uchiha" / "clan_senju" / "clan_hyuga" / "clan_none"
		chakraAffinity   = nil,    -- "fire" / "water" / "earth" / "wind" / "lightning"
		isCharacterCreated = false,

		-- Level & EXP
		level            = 1,
		exp              = 0,

		-- Skill Points
		totalSP          = 0,      -- tổng SP đã nhận
		spSpent          = 0,      -- tổng SP đã tiêu

		-- HP / Chakra hiện tại (không vượt max)
		currentHP        = 0,      -- set đúng trong initCharacter
		currentChakra    = 0,      -- set đúng trong initCharacter

		-- Jutsu (6 slot)
		jutsuSlots       = {nil, nil, nil, nil, nil, nil},
		learnedJutsu     = {},     -- { [jutsuId] = true }

		-- Reputation
		reputation       = {
			village = 0,
			reimei  = 0,
		},

		-- Flags (quest/story state, e.g. "arc1_bridge_helped" = true)
		flags            = {},

		-- Quest progress { [questId] = { taskProgress = {...}, status = "active"/"completed" } }
		questProgress    = {},

		-- Permanent bonus stat từ quest/event (cộng vào base stat)
		permanentBonuses = {
			maxHP     = 0,
			maxChakra = 0,
			attack    = 0,
			defense   = 0,
		},

		-- Arc hiện tại (1–4)
		currentArc       = 1,

		-- Active buffs: array of { statKey, amount, expireTime }
		-- expireTime = tick() + duration
		activeBuffs      = {},
	}
end

-- ============================================================
-- Private helpers
-- ============================================================

-- Tính HP tối đa cho profile (gọi sau mỗi level up, sau khi thêm permanentBonus)
local function calcMaxHP(profile)
	return ConfigLoader.calcMaxHP(profile.level) + profile.permanentBonuses.maxHP
end

-- Tính Chakra tối đa cho profile
local function calcMaxChakra(profile)
	return ConfigLoader.calcMaxChakra(profile.level) + profile.permanentBonuses.maxChakra
end

-- Xử lý level up: tăng level, cộng SP, trả về số lần level up
-- Trả về số lần đã level up (có thể level up nhiều lần nếu EXP dư)
local function _doLevelUp(profile)
	local maxLevel   = ConfigLoader.getMaxLevel()
	local timesLevelUp = 0

	while profile.level < maxLevel do
		local needed = ConfigLoader.getExpRequired(profile.level)
		if profile.exp < needed then break end

		profile.exp   = profile.exp - needed
		profile.level = profile.level + 1
		timesLevelUp  = timesLevelUp + 1

		-- Cộng SP từ ConfigLoader
		local spGain = ConfigLoader.getSPPerLevel()
		-- No-clan bonus SP: chỉ cộng khi đang là no-clan
		if profile.clanId == "clan_none" then
			spGain = spGain + ConfigLoader.getNoClanBonusSP(profile.level)
		end
		profile.totalSP = profile.totalSP + spGain
	end

	return timesLevelUp
end

-- Áp dụng tất cả stat modifiers đã đăng ký lên baseStats
-- Trả về stats mới (copy), không thay đổi baseStats
local function _applyStatModifiers(baseStats, profile)
	local stats = {}
	for k, v in pairs(baseStats) do stats[k] = v end

	for _, modFn in ipairs(_statModifiers) do
		local ok, result = pcall(modFn, stats, profile)
		if ok and result then
			stats = result
		else
			warn("[PlayerSystem] stat modifier lỗi:", result)
		end
	end
	return stats
end

-- Xóa buff đã hết hạn khỏi activeBuffs
local function _cleanExpiredBuffs(profile)
	local now = tick()
	local fresh = {}
	for _, buff in ipairs(profile.activeBuffs) do
		if buff.expireTime > now then
			table.insert(fresh, buff)
		end
	end
	profile.activeBuffs = fresh
end

-- ============================================================
-- Public API — Lifecycle
-- ============================================================

-- Đăng ký stat modifier (dùng bởi ClanSystem Phase 5)
-- modFn(stats, profile) → stats
-- stats là copy của baseStats — modifier chỉnh sửa rồi trả về
function PlayerSystem.registerStatModifier(modFn)
	table.insert(_statModifiers, modFn)
end

-- Đăng ký hàm load profile từ DataStore (Phase 8+)
-- loaderFn(player) → profileData table hoặc nil (tạo mới nếu nil)
function PlayerSystem.setProfileLoader(loaderFn)
	_profileLoader = loaderFn
end

-- Đăng ký hàm save profile vào DataStore (Phase 8+)
-- saverFn(player, profileData)
function PlayerSystem.setProfileSaver(saverFn)
	_profileSaver = saverFn
end

-- Gọi khi player join: tạo hoặc load profile
-- init() tự hook vào Players.PlayerAdded nếu gọi sớm,
-- nhưng server init script có thể gọi onPlayerJoined thủ công nếu cần
function PlayerSystem.onPlayerJoined(player)
	if _profiles[player] then return end  -- đã có, bỏ qua

	local profile

	-- Thử load từ DataStore nếu có hook
	if _profileLoader then
		local ok, data = pcall(_profileLoader, player)
		if ok and data then
			profile = data
		else
			if not ok then
				warn("[PlayerSystem] profileLoader lỗi cho", player.Name, ":", data)
			end
		end
	end

	-- Không có DataStore hoặc load thất bại → tạo mới
	if not profile then
		profile = newProfile()
	end

	_profiles[player] = profile
	print("[PlayerSystem] Profile loaded:", player.Name, "| Lv", profile.level)
end

-- Gọi khi player leave: save và xóa khỏi memory
function PlayerSystem.onPlayerLeaving(player)
	local profile = _profiles[player]
	if not profile then return end

	-- Lưu vào DataStore nếu có hook
	if _profileSaver then
		local ok, err = pcall(_profileSaver, player, profile)
		if not ok then
			warn("[PlayerSystem] profileSaver lỗi cho", player.Name, ":", err)
		end
	end

	_profiles[player] = nil
	print("[PlayerSystem] Profile unloaded:", player.Name)
end

-- Khởi động PlayerSystem: hook Players events
function PlayerSystem.init()
	Players.PlayerAdded:Connect(PlayerSystem.onPlayerJoined)
	Players.PlayerRemoving:Connect(PlayerSystem.onPlayerLeaving)

	-- Xử lý player đã join trước khi init() được gọi
	for _, player in ipairs(Players:GetPlayers()) do
		PlayerSystem.onPlayerJoined(player)
	end

	print("[PlayerSystem] Initialized.")
end

-- ============================================================
-- Public API — Profile access
-- ============================================================

-- Lấy raw profile table (dùng nội bộ, đọc trực tiếp)
-- Trả nil nếu player chưa có profile
function PlayerSystem.getProfile(player)
	return _profiles[player]
end

-- ============================================================
-- Public API — Character creation
-- ============================================================

-- Khởi tạo nhân vật sau khi player chọn tên/clan/affinity
-- characterData = { name, clanId, chakraAffinity }
-- Trả false nếu nhân vật đã tồn tại hoặc data thiếu
function PlayerSystem.initCharacter(player, characterData)
	local profile = _profiles[player]
	if not profile then
		warn("[PlayerSystem] initCharacter: không tìm thấy profile cho", player.Name)
		return false
	end
	if profile.isCharacterCreated then
		warn("[PlayerSystem] initCharacter: nhân vật đã tạo rồi cho", player.Name)
		return false
	end

	-- Validate characterData
	if not characterData
		or type(characterData.name) ~= "string"
		or characterData.name == ""
		or not characterData.clanId
		or not characterData.chakraAffinity
	then
		warn("[PlayerSystem] initCharacter: characterData không hợp lệ")
		return false
	end

	-- Validate clanId tồn tại trong data
	local clanData = DataLoader.getClanById(characterData.clanId)
	if not clanData then
		warn("[PlayerSystem] initCharacter: clanId không hợp lệ:", characterData.clanId)
		return false
	end

	profile.characterName      = characterData.name
	profile.clanId             = characterData.clanId
	profile.chakraAffinity     = characterData.chakraAffinity
	profile.isCharacterCreated = true

	-- Đặt HP/Chakra về max khi tạo nhân vật
	profile.currentHP     = calcMaxHP(profile)
	profile.currentChakra = calcMaxChakra(profile)

	-- SP ban đầu: level 1 → spPerLevel (1 lần levelup tại lv1 = phần thưởng khởi đầu)
	profile.totalSP = ConfigLoader.getSPPerLevel()
	if profile.clanId == "clan_none" then
		profile.totalSP = profile.totalSP + ConfigLoader.getNoClanBonusSP(1)
	end

	print("[PlayerSystem] Nhân vật tạo xong:", player.Name,
		"| Clan:", profile.clanId,
		"| Affinity:", profile.chakraAffinity,
		"| HP:", profile.currentHP, "| Chakra:", profile.currentChakra)
	return true
end

-- ============================================================
-- Public API — Stats
-- ============================================================

-- Lấy stats hiện tại của player (sau khi áp modifiers và buffs)
-- Trả về table hoặc nil nếu chưa có profile
-- Stats: maxHP, maxChakra, attack, defense, level, currentHP, currentChakra
function PlayerSystem.getStats(player)
	local profile = _profiles[player]
	if not profile then return nil end

	-- Xóa buff hết hạn trước khi tính
	_cleanExpiredBuffs(profile)

	-- Base stats từ ConfigLoader + permanentBonus
	local base = {
		maxHP      = calcMaxHP(profile),
		maxChakra  = calcMaxChakra(profile),
		attack     = ConfigLoader.calcAttack(profile.level)  + profile.permanentBonuses.attack,
		defense    = ConfigLoader.calcDefense(profile.level) + profile.permanentBonuses.defense,
		level      = profile.level,
		currentHP  = profile.currentHP,
		currentChakra = profile.currentChakra,
	}

	-- Áp stat modifiers (ClanSystem, Phase 5)
	local stats = _applyStatModifiers(base, profile)

	-- Áp active buffs
	for _, buff in ipairs(profile.activeBuffs) do
		if stats[buff.statKey] then
			stats[buff.statKey] = stats[buff.statKey] + buff.amount
		end
	end

	-- Clamp currentHP/Chakra không vượt max (buffs có thể thay đổi max)
	stats.currentHP    = math.min(stats.currentHP,    stats.maxHP)
	stats.currentChakra = math.min(stats.currentChakra, stats.maxChakra)

	return stats
end

-- ============================================================
-- Public API — EXP & Level
-- ============================================================

-- Cộng EXP, xử lý level up, trả về số lần level up
function PlayerSystem.addEXP(player, amount)
	local profile = _profiles[player]
	if not profile then return 0 end

	local maxLevel = ConfigLoader.getMaxLevel()
	if profile.level >= maxLevel then return 0 end

	profile.exp = profile.exp + amount
	local timesUp = _doLevelUp(profile)

	if timesUp > 0 then
		-- Sau level up: HP/Chakra max tăng → full heal (tuỳ design; ở đây giữ delta)
		-- Hiện tại chỉ clamp để currentHP không vượt max mới
		local newMaxHP     = calcMaxHP(profile)
		local newMaxChakra = calcMaxChakra(profile)
		profile.currentHP     = math.min(profile.currentHP,     newMaxHP)
		profile.currentChakra = math.min(profile.currentChakra, newMaxChakra)

		print("[PlayerSystem]", player.Name, "level up ×" .. timesUp,
			"→ Lv", profile.level,
			"| SP tổng:", profile.totalSP)
	end

	return timesUp
end

-- ============================================================
-- Public API — Skill Points
-- ============================================================

-- SP tự do hiện tại (chưa tiêu)
function PlayerSystem.getFreeSP(player)
	local profile = _profiles[player]
	if not profile then return 0 end
	return profile.totalSP - profile.spSpent
end

-- Tiêu SP (dùng bởi JutsuSystem Phase 4)
-- Trả true nếu thành công, false nếu không đủ SP
function PlayerSystem.spendSP(player, amount)
	local profile = _profiles[player]
	if not profile then return false end

	if PlayerSystem.getFreeSP(player) < amount then
		return false
	end
	profile.spSpent = profile.spSpent + amount
	return true
end

-- Hoàn trả SP (dùng khi unlearn jutsu — Phase 4)
function PlayerSystem.refundSP(player, amount)
	local profile = _profiles[player]
	if not profile then return end
	profile.spSpent = math.max(0, profile.spSpent - amount)
end

-- ============================================================
-- Public API — Reputation
-- ============================================================

-- Thay đổi điểm rep cho faction ("village" | "reimei")
function PlayerSystem.modifyRep(player, faction, delta)
	local profile = _profiles[player]
	if not profile then return end
	if profile.reputation[faction] == nil then
		warn("[PlayerSystem] modifyRep: faction không hợp lệ:", faction)
		return
	end
	profile.reputation[faction] = profile.reputation[faction] + delta
end

-- Lấy tier reputation ("hostile"/"neutral"/"friendly"/v.v.)
-- Delegate sang ConfigLoader.getRepTier
function PlayerSystem.getRepTier(player, faction)
	local profile = _profiles[player]
	if not profile then return "neutral" end
	return ConfigLoader.getRepTier(faction, profile.reputation[faction] or 0)
end

-- ============================================================
-- Public API — Flags
-- ============================================================

function PlayerSystem.setFlag(player, flagKey, value)
	local profile = _profiles[player]
	if not profile then return end
	profile.flags[flagKey] = value
end

function PlayerSystem.getFlag(player, flagKey)
	local profile = _profiles[player]
	if not profile then return nil end
	return profile.flags[flagKey]
end

-- ============================================================
-- Public API — Permanent Bonuses
-- ============================================================

-- Cộng permanent stat bonus (từ quest reward, special event)
-- statKey: "maxHP" | "maxChakra" | "attack" | "defense"
function PlayerSystem.addPermanentBonus(player, statKey, amount)
	local profile = _profiles[player]
	if not profile then return end
	if profile.permanentBonuses[statKey] == nil then
		warn("[PlayerSystem] addPermanentBonus: statKey không hợp lệ:", statKey)
		return
	end
	profile.permanentBonuses[statKey] = profile.permanentBonuses[statKey] + amount
end

-- ============================================================
-- Public API — Jutsu Slots
-- ============================================================

-- Gán jutsuId vào slot (1–6), nil để xóa slot
-- JutsuSystem (Phase 4) gọi hàm này sau khi validate
function PlayerSystem.setJutsuSlot(player, slotIndex, jutsuId)
	local profile = _profiles[player]
	if not profile then return false end
	if slotIndex < 1 or slotIndex > 6 then
		warn("[PlayerSystem] setJutsuSlot: slotIndex không hợp lệ:", slotIndex)
		return false
	end
	profile.jutsuSlots[slotIndex] = jutsuId
	return true
end

-- ============================================================
-- Public API — HP / Chakra
-- ============================================================

-- Thay đổi HP hiện tại (delta âm = mất máu, dương = hồi máu)
-- Trả về HP sau khi thay đổi
function PlayerSystem.modifyHP(player, delta)
	local profile = _profiles[player]
	if not profile then return 0 end
	local stats = PlayerSystem.getStats(player)
	profile.currentHP = math.clamp(profile.currentHP + delta, 0, stats.maxHP)
	return profile.currentHP
end

-- Thay đổi Chakra hiện tại
-- Trả về Chakra sau khi thay đổi
function PlayerSystem.modifyChakra(player, delta)
	local profile = _profiles[player]
	if not profile then return 0 end
	local stats = PlayerSystem.getStats(player)
	profile.currentChakra = math.clamp(profile.currentChakra + delta, 0, stats.maxChakra)
	return profile.currentChakra
end

-- Full heal HP và Chakra về max (dùng sau respawn hoặc rest point)
function PlayerSystem.fullHeal(player)
	local profile = _profiles[player]
	if not profile then return end
	local stats = PlayerSystem.getStats(player)
	profile.currentHP     = stats.maxHP
	profile.currentChakra = stats.maxChakra
end

-- ============================================================
-- Public API — Buffs
-- ============================================================

-- Thêm temporary stat buff
-- statKey: "attack" | "defense" | "maxHP" | "maxChakra"
-- amount: giá trị cộng thêm
-- duration: thời gian (giây)
function PlayerSystem.applyBuff(player, statKey, amount, duration)
	local profile = _profiles[player]
	if not profile then return end
	table.insert(profile.activeBuffs, {
		statKey    = statKey,
		amount     = amount,
		expireTime = tick() + duration,
	})
end

-- ============================================================
-- Public API — Arc
-- ============================================================

function PlayerSystem.setCurrentArc(player, arcNumber)
	local profile = _profiles[player]
	if not profile then return end
	profile.currentArc = arcNumber
end

function PlayerSystem.getCurrentArc(player)
	local profile = _profiles[player]
	if not profile then return 1 end
	return profile.currentArc
end

return PlayerSystem
