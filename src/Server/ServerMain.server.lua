-- ServerMain.server.lua
-- Script: ServerScriptService.ServerMain
--
-- Minimal server bootstrap for v0.1 runtime foundation.
-- Khoi dong cac he thong co ban: DataLoader -> PlayerSystem -> JutsuSystem.
--
-- PHAM VI: chi bootstrap runtime foundation.
-- KHONG start gameplay loop, KHONG spawn NPC,
-- KHONG start quest/combat/inventory -- cac phase sau se them vao day.
--
-- De them system moi: require va goi init() trong ham bootstrap() ben duoi,
-- theo thu tu dependency (data -> player -> jutsu -> clan -> combat -> ...).

local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared  = ReplicatedStorage:WaitForChild("Shared")
local Systems = ServerScriptService:WaitForChild("Systems")

-- Require theo thu tu dependency: DataLoader <- ConfigLoader <- ChakraAffinity <- JutsuSystem
local DataLoader   = require(Shared:WaitForChild("DataLoader"))
local PlayerSystem = require(Systems:WaitForChild("PlayerSystem"))
local JutsuSystem  = require(Systems:WaitForChild("JutsuSystem"))

-- ============================================================
-- Bootstrap
-- ============================================================

local function bootstrap()
	print("[ServerMain] Bootstrapping Naruto Roblox server systems...")

	-- Buoc 1: Load toan bo game data vao cache (fail-fast neu thieu file)
	DataLoader.loadAll()

	-- Buoc 2: Khoi dong PlayerSystem (hook PlayerAdded/PlayerRemoving)
	PlayerSystem.init()

	-- Buoc 3: Hook JutsuSystem cleanup vao PlayerRemoving
	-- (PlayerSystem.init() da hook onPlayerLeaving cho PlayerSystem,
	--  nhung JutsuSystem can don _cooldowns rieng)
	Players.PlayerRemoving:Connect(function(player)
		JutsuSystem.onPlayerLeaving(player)
	end)

	-- PLACEHOLDER Phase 5+: them vao day khi san sang
	-- ClanSystem.init()
	-- CombatCalculator.init()  -- neu can init
	-- QuestSystem.init()
	-- NPCSpawner.init()

	print("[ServerMain] Server systems initialized successfully.")
	print("[ServerMain] Scope: v0.1 Arc 1 (Tide Province, Lv 1-15)")
end

-- pcall de error ro rang neu init fail -- khong silent-fail
local ok, err = pcall(bootstrap)
if not ok then
	error("[ServerMain] Failed to initialize server systems: " .. tostring(err))
end
