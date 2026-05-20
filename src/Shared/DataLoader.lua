-- DataLoader.lua
-- ModuleScript: ReplicatedStorage.Shared.DataLoader
-- Đặt trong: ReplicatedStorage > Shared > DataLoader
--
-- Nhiệm vụ:
--   - Load tất cả game data từ ReplicatedStorage.GameData (Folder của StringValues)
--   - Parse JSON một lần, cache kết quả
--   - Cung cấp lookup API theo ID cho mọi system khác
--
-- Setup trong Studio (hoặc sync tự động qua Rojo — xem default.project.json):
--   ReplicatedStorage
--     GameData (Folder)
--       balance-config    (StringValue) ← dán nội dung balance-config.json
--       clan-data         (StringValue) ← dán nội dung clan-data.json
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
--   - getJutsuForArc() dùng field arcUnlock trong data, không suy luận từ source string
--   - loadAll() fail-fast nếu thiếu bất kỳ file bắt buộc nào
--   - buildIndex() fail-fast nếu duplicate id hoặc thiếu id field

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

-- Tất cả 6 file đều bắt buộc — thiếu 1 là error
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

-- Lấy folder GameData, error rõ ràng nếu chưa setup
local function requireGameDataFolder()
	local folder = ReplicatedStorage:FindFirstChild("GameData")
	if not folder then
		error(
			"[DataLoader] Không tìm thấy ReplicatedStorage.GameData\n" ..
			"Hãy tạo Folder tên 'GameData' trong ReplicatedStorage và thêm StringValues chứa nội dung JSON.\n" ..
			"Hoặc dùng Rojo (xem default.project.json) để sync tự động."
		)
	end
	return folder
end

-- Parse JSON từ 1 StringValue bắt buộc trong folder
-- Fail-fast: error ngay nếu thiếu hoặc rỗng — không warn rồi tiếp tục
local function loadAndParse(folder, fileName)
	local sv = folder:FindFirstChild(fileName)
	if not sv then
		error(
			"[DataLoader] Thiếu StringValue bắt buộc '" .. fileName .. "' trong GameData.\n" ..
			"Đây là file bắt buộc — game không thể chạy khi thiếu data này."
		)
	end
	if sv.Value == "" then
		error(
			"[DataLoader] StringValue '" .. fileName .. "' đang rỗng.\n" ..
			"Hãy dán nội dung JSON vào .Value của StringValue này."
		)
	end
	local ok, result = pcall(HttpService.JSONDecode, HttpService, sv.Value)
	if not ok then
		error("[DataLoader] Lỗi parse JSON [" .. fileName .. "]: " .. tostring(result))
	end
	return result
end

-- Build index {id → object} từ array
-- indexName: tên để hiện trong error message (ví dụ: "jutsu", "items")
-- Fail-fast: error nếu object thiếu id, hoặc id bị duplicate
local function buildIndex(array, indexName)
	local idx = {}
	for i, obj in ipairs(array) do
		-- Kiểm tra id tồn tại
		if not obj.id then
			error(
				"[DataLoader] buildIndex [" .. indexName .. "] index=" .. tostring(i) ..
				": object thiếu field 'id' — kiểm tra data JSON."
			)
		end
		-- Kiểm tra duplicate
		if idx[obj.id] then
			error(
				"[DataLoader] buildIndex [" .. indexName .. "]: duplicate id '" .. obj.id .. "'\n" ..
				"Chạy python tools/validate-data.py để tìm nguyên nhân."
			)
		end
		idx[obj.id] = obj
	end
	return idx
end

-- ============================================================
-- Public API
-- ============================================================

-- Load tất cả data, build indices, cache kết quả
-- Gọi 1 lần khi game khởi động (từ server init script)
-- Gọi nhiều lần an toàn — lần sau là no-op
-- Fail-fast: error nếu bất kỳ file bắt buộc nào thiếu/rỗng/lỗi JSON
function DataLoader.loadAll()
	if _loaded then return end

	local folder = requireGameDataFolder()

	-- Parse tất cả — mỗi file fail-fast bên trong loadAndParse
	for key, fileName in pairs(DATA_FILE_NAMES) do
		_cache[key] = loadAndParse(folder, fileName)
	end

	-- Build indices — mỗi index fail-fast bên trong buildIndex
	_idx.jutsu  = buildIndex(_cache.jutsu.jutsu   or {}, "jutsu")
	_idx.items  = buildIndex(_cache.items.items   or {}, "items")
	_idx.npcs   = buildIndex(_cache.npc.npcs      or {}, "npcs")
	_idx.quests = buildIndex(_cache.quests.quests or {}, "quests")
	_idx.clans  = buildIndex(_cache.clans.clans   or {}, "clans")

	_loaded = true
	print("[DataLoader] Load xong — jutsu:", #(_cache.jutsu.jutsu or {}),
		"| items:", #(_cache.items.items or {}),
		"| npc:", #(_cache.npc.npcs or {}),
		"| quest:", #(_cache.quests.quests or {}))
end

-- Kiểm tra đã load chưa (cho debug/test)
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
-- Lý do: QuestSystem và các system khác có thể query ID chưa tồn tại (future content)
-- ============================================================

-- Tra jutsu theo ID (ví dụ: "jutsu_f01")
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
-- Trả nil nếu quest chưa tồn tại — QuestSystem dùng để bỏ qua future quests, không crash
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

-- Jutsu accessible trong arc cho trước, với giới hạn tier tùy chọn
--
-- arcNumber: arc hiện tại của game (1–4)
-- maxTier:   tier tối đa được phép (nil = không giới hạn)
--            v0.1 dùng maxTier=2 để lock Tier 3–5 theo MVP spec
--
-- Dùng field arcUnlock trong jutsu-definitions.json — KHÔNG suy luận từ source string
-- Ví dụ: getJutsuForArc(1, 2) → đúng 11 jutsu v0.1
--        getJutsuForArc(2)    → tất cả jutsu arc 1–2, không giới hạn tier
function DataLoader.getJutsuForArc(arcNumber, maxTier)
	local result = {}
	if not _cache.jutsu then return result end

	for _, j in ipairs(_cache.jutsu.jutsu or {}) do
		-- Bỏ qua entry deferred (chưa implement)
		if j.status == "deferred_arc4" then continue end

		-- Kiểm tra arcUnlock — field bắt buộc, mặc định 1 nếu thiếu (backward compat)
		local arcOk = (j.arcUnlock or 1) <= arcNumber

		-- Kiểm tra maxTier nếu được chỉ định
		local tierOk = (not maxTier) or ((j.tier or 1) <= maxTier)

		if arcOk and tierOk then
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
-- v0.1 (arc 1): Reimei Broker (arcUnlock:3) và ANBU Contact (arcUnlock:2) sẽ KHÔNG có
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
