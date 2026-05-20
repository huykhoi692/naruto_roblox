-- DataLoader.lua
-- ModuleScript: ReplicatedStorage.Shared.DataLoader
-- Đặt trong: ReplicatedStorage > Shared > DataLoader
--
-- Nhiệm vụ:
--   - Load tất cả game data từ ReplicatedStorage.GameData (Folder của StringValues)
--   - Parse JSON một lần, cache kết quả
--   - Cung cấp lookup API theo ID cho mọi system khác
--
-- Setup trong Studio:
--   ReplicatedStorage
--     GameData (Folder)
--       balance-config   (StringValue) ← dán nội dung balance-config.json
--       clan-data        (StringValue) ← dán nội dung clan-data.json
--       jutsu-definitions (StringValue) ← dán nội dung jutsu-definitions.json
--       item-definitions  (StringValue) ← dán nội dung item-definitions.json
--       npc-data          (StringValue) ← dán nội dung npc-data.json
--       quest-definitions (StringValue) ← dán nội dung quest-definitions.json
--
-- Nguyên tắc:
--   - Không hardcode số balance — mọi số đọc từ JSON
--   - getQuestById() trả nil thay vì crash khi questId chưa tồn tại
--   - getVendorsForArc() tôn trọng arcUnlock → Reimei Broker (arc3), ANBU Contact (arc2)
--     không xuất hiện trong v0.1 (arc 1)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")

local DataLoader = {}

-- ============================================================
-- Internal state
-- ============================================================

-- Cache dữ liệu đã parse
local _cache = {
	balance = nil,  -- balance-config.json
	clans   = nil,  -- clan-data.json
	jutsu   = nil,  -- jutsu-definitions.json
	items   = nil,  -- item-definitions.json
	npc     = nil,  -- npc-data.json
	quests  = nil,  -- quest-definitions.json
}

-- Index tra cứu nhanh theo ID (O(1) lookup)
local _idx = {
	jutsu  = {},  -- jutsuId  → jutsu object
	items  = {},  -- itemId   → item object
	npcs   = {},  -- npcId    → npc object
	quests = {},  -- questId  → quest object
	clans  = {},  -- clanId   → clan object
}

-- Đã load chưa (tránh load nhiều lần)
local _loaded = false

-- Mapping key → tên StringValue trong GameData folder
local DATA_FILE_NAMES = {
	balance = "balance-config",
	clans   = "clan-data",
	jutsu   = "jutsu-definitions",
	items   = "item-definitions",
	npc     = "npc-data",
	quests  = "quest-definitions",
}

-- ============================================================
-- Private helpers
-- ============================================================

-- Lấy folder GameData, báo lỗi rõ ràng nếu chưa setup
local function requireGameDataFolder()
	local folder = ReplicatedStorage:FindFirstChild("GameData")
	if not folder then
		error(
			"[DataLoader] Không tìm thấy ReplicatedStorage.GameData\n" ..
			"Hãy tạo Folder tên 'GameData' trong ReplicatedStorage và thêm StringValues chứa nội dung JSON."
		)
	end
	return folder
end

-- Parse JSON từ 1 StringValue trong folder
local function loadAndParse(folder, fileName)
	local sv = folder:FindFirstChild(fileName)
	if not sv then
		warn("[DataLoader] Không tìm thấy StringValue '" .. fileName .. "' trong GameData — bỏ qua")
		return nil
	end
	if sv.Value == "" then
		warn("[DataLoader] StringValue '" .. fileName .. "' trống — bỏ qua")
		return nil
	end
	local ok, result = pcall(HttpService.JSONDecode, HttpService, sv.Value)
	if not ok then
		error("[DataLoader] Lỗi parse JSON [" .. fileName .. "]: " .. tostring(result))
	end
	return result
end

-- Build index {id → object} từ array
local function buildIndex(array)
	local idx = {}
	for _, obj in ipairs(array) do
		if obj.id then
			idx[obj.id] = obj
		end
	end
	return idx
end

-- ============================================================
-- Public API
-- ============================================================

-- Load tất cả data, build indices, cache kết quả
-- Gọi 1 lần khi game khởi động (từ server init script)
-- Gọi nhiều lần an toàn — lần sau là no-op
function DataLoader.loadAll()
	if _loaded then return end

	local folder = requireGameDataFolder()

	-- Parse từng file
	for key, fileName in pairs(DATA_FILE_NAMES) do
		_cache[key] = loadAndParse(folder, fileName)
	end

	-- Build index jutsu
	if _cache.jutsu then
		_idx.jutsu = buildIndex(_cache.jutsu.jutsu or {})
	end

	-- Build index items
	if _cache.items then
		_idx.items = buildIndex(_cache.items.items or {})
	end

	-- Build index NPCs
	if _cache.npc then
		_idx.npcs = buildIndex(_cache.npc.npcs or {})
	end

	-- Build index quests
	if _cache.quests then
		_idx.quests = buildIndex(_cache.quests.quests or {})
	end

	-- Build index clans
	if _cache.clans then
		_idx.clans = buildIndex(_cache.clans.clans or {})
	end

	_loaded = true
	print("[DataLoader] Load xong — jutsu:", #(_cache.jutsu and _cache.jutsu.jutsu or {}),
		"| items:", #(_cache.items and _cache.items.items or {}),
		"| npc:", #(_cache.npc and _cache.npc.npcs or {}),
		"| quest:", #(_cache.quests and _cache.quests.quests or {}))
end

-- Kiểm tra đã load chưa (cho debug)
function DataLoader.isLoaded()
	return _loaded
end

-- ============================================================
-- Raw data access
-- ============================================================

-- Trả về raw table theo category: "balance", "clans", "jutsu", "items", "npc", "quests"
function DataLoader.getData(category)
	return _cache[category]
end

-- ============================================================
-- ID Lookups — tất cả trả nil thay vì crash khi không tìm thấy
-- ============================================================

-- Tra jutsu theo ID (ví dụ: "jutsu_f01")
-- Trả nil nếu không tồn tại — KHÔNG crash
function DataLoader.getJutsuById(id)
	return _idx.jutsu[id] or nil
end

-- Tra item theo ID (ví dụ: "kunai", "ryo_100")
function DataLoader.getItemById(id)
	return _idx.items[id] or nil
end

-- Tra NPC theo ID (ví dụ: "npc_kakashi", "npc_enemy_wave_bandit")
function DataLoader.getNPCById(id)
	return _idx.npcs[id] or nil
end

-- Tra quest theo ID (ví dụ: "q101", "qh101")
-- Trả nil nếu questId chưa tồn tại — QuestSystem dùng để bỏ qua future quests không crash
function DataLoader.getQuestById(id)
	return _idx.quests[id] or nil
end

-- Tra clan theo ID (ví dụ: "clan_uchiha", "clan_none")
function DataLoader.getClanById(id)
	return _idx.clans[id] or nil
end

-- ============================================================
-- Filtered queries
-- ============================================================

-- Tất cả jutsu có source accessible trong arc cho trước
-- Logic: jutsu accessible nếu ít nhất 1 source KHÔNG yêu cầu arc cao hơn arcNumber
-- VD: getJutsuForArc(1) trả về 11 jutsu tier 1–2 của Arc 1
function DataLoader.getJutsuForArc(arcNumber)
	local result = {}
	if not _cache.jutsu then return result end

	for _, j in ipairs(_cache.jutsu.jutsu or {}) do
		-- Bỏ qua entry deferred (không có tier = chưa implement)
		if j.status == "deferred_arc4" then continue end

		local accessible = false
		for _, src in ipairs(j.source or {}) do
			-- Extract arc number từ source string: "boss_drop_garrek_arc2" → 2
			local srcArc = tonumber(src:match("_arc(%d)"))
			if not srcArc or srcArc <= arcNumber then
				-- Nguồn không mention arc cụ thể = tier 1 shop/reward → accessible
				accessible = true
				break
			end
		end
		if accessible then
			table.insert(result, j)
		end
	end
	return result
end

-- Tất cả enemy NPC được unlock trong arc (tôn trọng arcUnlock)
function DataLoader.getEnemiesForArc(arcNumber)
	local result = {}
	if not _cache.npc then return result end

	for _, npc in ipairs(_cache.npc.npcs or {}) do
		if npc.type == "enemy" then
			local unlock = npc.arcUnlock or 1
			if unlock <= arcNumber then
				table.insert(result, npc)
			end
		end
	end
	return result
end

-- Vendor và questGiver NPC được unlock trong arc (tôn trọng arcUnlock)
-- v0.1 (arc 1): Reimei Broker (arcUnlock:3) và ANBU Contact (arcUnlock:2) sẽ KHÔNG có trong list
function DataLoader.getVendorsForArc(arcNumber)
	local result = {}
	if not _cache.npc then return result end

	for _, npc in ipairs(_cache.npc.npcs or {}) do
		if npc.type == "vendor" or npc.type == "questGiver" then
			local unlock = npc.arcUnlock or 1
			if unlock <= arcNumber then
				table.insert(result, npc)
			end
		end
	end
	return result
end

-- Tất cả quest thuộc arc nhất định
function DataLoader.getQuestsForArc(arcNumber)
	local result = {}
	if not _cache.quests then return result end

	for _, q in ipairs(_cache.quests.quests or {}) do
		if q.arc == arcNumber then
			table.insert(result, q)
		end
	end
	return result
end

-- Location directory (dùng để validate hoặc spawn NPC đúng vị trí)
function DataLoader.getLocationDirectory()
	if _cache.npc then
		return _cache.npc.locationDirectory or {}
	end
	return {}
end

-- Lấy info location theo key (ví dụ: "konohara_hub", "tide_province")
function DataLoader.getLocationInfo(locationKey)
	local dir = DataLoader.getLocationDirectory()
	return dir[locationKey] or nil
end

return DataLoader
