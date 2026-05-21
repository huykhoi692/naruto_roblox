# naruto-roblox-dev — Claude Skill

> **Load this skill at the start of every thread working on this project.**
> Before doing anything else: run the preflight checklist, read relevant data files, then summarize scope before writing a single line of code.

---

## A. Claude's Role in This Project

Claude acts as **Roblox/Luau game engineer + technical game designer** for a Naruto-themed RPG.

Core priorities (in order):
1. **Data-driven first** — every balance number, jutsu, NPC, quest, item comes from `Data/*.json`. Never hardcode.
2. **Validate before code** — run `python tools/validate-data.py` before starting any phase. Never start if there are errors.
3. **Scope discipline** — v0.1 is Arc 1 only. Refuse to implement out-of-scope systems, even as "placeholder".
4. **No data corruption** — treat `Data/*.json` as source of truth. Do not modify JSON without explicit user instruction.
5. **Transparent changes** — after every phase: report changed files, validator result, manual test steps.

---

## B. Project Context

### What This Game Is
A Roblox multiplayer RPG set in the Naruto universe (called "Naruko" in-game). Players create their **own character** (not Naruto/Sasuke). Canon NPCs (Kakashi, Naruko, etc.) exist as story NPCs. Players choose: **protect the village** or **betray it**.

### Current Build: v0.1
**Scope: Arc 1 — Tide Province only.** Deliver a complete vertical slice for levels 1–15 (buffer to 20).

**Story arcs:**
| Arc | Levels | Status in v0.1 |
|-----|--------|----------------|
| Arc 1: Tide Province | 1–15 | IN |
| Arc 2: Chunin Exam | 15–30 | OUT |
| Arc 3: Sazuki Departure | 28–40 | OUT |
| Arc 4: Find Tsukade | 40–50 | OUT |

**Game systems (4 clans):** Uchira / Senjura / Hyuura / No Clan — each has 1 passive + 1 active (active unlocks at level 20).

**Jutsu:** 6 slots max, 5 tiers. v0.1 caps at Tier 2. 11 jutsu are in-scope for v0.1.

**Chakra Affinity:** 5 elements (fire/water/earth/wind/lightning). Fixed at character creation. Secondary affinity via hidden quest — OUT for v0.1.

**Reputation:** Track `village` and `reimei` points. Only `neutral` and `friendly` tiers reachable in Arc 1. Endings (Hero/Villain/Wanderer) not revealed in v0.1.

---

## C. Architecture & File Map

### Rojo Mapping (default.project.json)
```
src/Shared/          -> ReplicatedStorage.Shared
src/Server/Systems/  -> ServerScriptService.Systems
```

### Data (source of truth — do not modify without user approval)
```
Data/balance-config.json    — all numbers: stats, exp, SP, chakra, damage formula, boss HP
Data/clan-data.json         — clan passives, actives, noClanBonusSPCap
Data/item-definitions.json  — all items (62 items)
Data/jutsu-definitions.json — all jutsu (29 defined, 11 in-scope for v0.1), affinityRules
Data/npc-data.json          — NPCs, enemies, bosses, locationDirectory (20 npcs, 6 enemies, 9 bosses, 41 locations)
Data/quest-definitions.json — quest chain (11 quests: q101–q109 + qh101 hidden)
```

### Tools
```
tools/validate-data.py  — cross-reference validator, run before every phase
```

### Source (Lua modules)
```
src/Shared/DataLoader.lua      — [DONE Phase 1] loads & caches all JSON, ID lookup API
src/Shared/ConfigLoader.lua    — [DONE Phase 1] balance number access, stat calculation
src/Shared/ChakraAffinity.lua  — [DONE Phase 3] affinity matching, cost/damage multipliers, tier gate
src/Server/Systems/PlayerSystem.lua  — [DONE Phase 2] player profile, stats, EXP, SP, rep, flags
```

### Planned systems (future phases)
```
src/Server/Systems/JutsuSystem.lua        — Phase 4
src/Server/Systems/ClanSystem.lua         — Phase 5
src/Server/Systems/CombatCalculator.lua   — Phase 6
src/Server/Systems/ItemRegistry.lua       — Phase 7
src/Server/Systems/InventorySystem.lua    — Phase 7
src/Server/Systems/ShopSystem.lua         — Phase 8
src/Server/Systems/LootSystem.lua         — Phase 8
src/Server/Systems/QuestSystem.lua        — Phase 9
src/Server/Systems/NPCSpawner.lua         — Phase 10
```

---

## D. Non-Negotiable Rules

These rules are **absolute**. No exceptions, no workarounds.

1. **Run `python tools/validate-data.py` before writing any code.** Do not proceed if there are errors.
2. **Do not advance to the next phase while the validator has errors or blocking warnings.**
3. **Do not hardcode any balance number.** All numbers come from `Data/balance-config.json` via `ConfigLoader`.
4. **Do not infer arc unlock from source strings.** Use the `arcUnlock` field in `jutsu-definitions.json` directly.
5. **Do not unlock Tier 3–5 jutsu in v0.1.** `maxLearnableTier = 2` in `balance-config` is the gate.
6. **Do not spawn NPCs, shops, or quests with `arcUnlock > currentArc`.** Arc 1 only.
7. **Reimei Broker (`arcUnlock:3`) and ANBU Contact (`arcUnlock:2`) must NOT appear in Arc 1.**
8. **QuestSystem must silently skip unknown questIds — never crash.** `DataLoader.getQuestById()` returns nil for future quest IDs; handle nil gracefully.
9. **All shop items and loot table entries must use valid `itemId` from `item-definitions.json`.**
10. **All jutsu references must use valid `jutsuId` from `jutsu-definitions.json`.**
11. **All questGiver, enemy, and location IDs must resolve via `npc-data` / `quest-definitions`.**
12. **Do not push or pull to GitHub unless the user explicitly requests it.**
13. **Do not rename folder `Data` to `data`.** Case matters on Linux and in Rojo.
14. **Do not add data fields that no code or validator uses.** Dead fields pollute schema.
15. **Report all changed files + test result after every phase.**

---

## E. Phase Workflow

### Phase 0 — Preflight (ALWAYS do this first)
```bash
git status
python tools/validate-data.py
```
Then read the files relevant to the phase. Then write a short summary:
- What files are modified/untracked
- Validator result
- What this phase will implement
- Which D rules apply

**Do not start phase work until preflight is complete and approved.**

---

### Phase 1 — DataLoader + ConfigLoader (DONE)

**Files:** `src/Shared/DataLoader.lua`, `src/Shared/ConfigLoader.lua`

**Review checklist:**
- `loadAll()` is fail-fast for all 6 required data files
- `buildIndex()` is fail-fast for duplicate IDs and missing `id` fields
- All lookups return `nil` instead of crashing for unknown IDs
- `getJutsuForArc(1, 2)` returns exactly 11 jutsu (v0.1 scope)
- `getJutsuForArc()` uses `arcUnlock` field, NOT source string parsing
- `getVendorsForArc(1)` excludes Reimei Broker and ANBU Contact
- `ConfigLoader` exposes all numbers from balance-config — no hardcoding in Lua

---

### Phase 2 — PlayerSystem (DONE)

**File:** `src/Server/Systems/PlayerSystem.lua`

**Review checklist:**
- Profile lives in-memory (`_profiles[player]`)
- `initCharacter()` validates `chakraAffinity` against whitelist — `"none"` and `"playerChoice"` rejected
- `chakraAffinity` whitelist: `{fire, water, earth, wind, lightning}` only
- `calcSpeed()` returns `baseSpeed` constant — not level-scaled
- No-Clan SP bonus: `+1 SP/level` up to level `noClanBonusSPCap` (30), then 0
- HP/Chakra clamped to max after stat changes (`math.clamp`)
- `getStats()` writes clamped values back to profile (no stale profile)
- `registerStatModifier()` ready for ClanSystem (Phase 5)
- `setProfileLoader/setProfileSaver` hooks ready for DataStore (Phase 8)

---

### Phase 3 — ChakraAffinity (DONE — untracked in git)

**File:** `src/Shared/ChakraAffinity.lua`

**Status:** File exists, not yet committed. Include in Phase 4 commit or commit standalone.

**Review checklist:**
- `isValidAffinity(affinity)` — only accepts the 5 valid elements
- `isMatching()` — returns false if either arg is invalid or "none"
- `getCostMultiplier()` — reads `costReduction` from `jutsu-definitions.affinityRules`
- `getDamageMultiplier()` — reads `damageBonus` from `jutsu-definitions.affinityRules`
- `getBonuses()` — returns `{costMult, damageMult}` for one-call usage in CombatSystem
- `canLearnTier(tier)` — reads `maxLearnableTier` from `ConfigLoader`, not hardcoded
- `VALID_AFFINITIES` stays in sync with `PlayerSystem.initCharacter()`

---

### Phase 4 — JutsuSystem (NEXT)

**File:** `src/Server/Systems/JutsuSystem.lua`

**API surface:**
```lua
JutsuSystem.learnJutsu(player, jutsuId)                    -- {success, reason}
JutsuSystem.canLearnJutsu(player, jutsuId)                 -- {success, reason}
JutsuSystem.equipJutsu(player, jutsuId, slotIndex)         -- {success, reason}
JutsuSystem.unequipJutsu(player, slotIndex)                -- {success, reason}
JutsuSystem.castJutsu(player, slotIndex, targetData)       -- {success, reason, data}
JutsuSystem.getEquippedJutsu(player)                       -- table[6]
JutsuSystem.getLearnedJutsu(player)                        -- array
```

**Constraints:**
- Max 6 equipped slots (enforce slotIndex 1–6)
- Only Tier <= `ChakraAffinity.canLearnTier()` can be learned (v0.1: Tier 1–2)
- Learn cost via `ConfigLoader.getJutsuLearnCost(tier, hasAffinity)`
- `hasAffinity` determined by `ChakraAffinity.isMatching(playerAffinity, jutsu.chakraType)`
- Chakra cost on cast: `jutsuData.chakraCost * ChakraAffinity.getCostMultiplier()`
- Cooldown tracked per player per jutsuId, server-side
- v0.1: only jutsu with `arcUnlock <= 1` and `tier <= 2` can be learned
- `DataLoader.getJutsuById(jutsuId)` returning nil = invalid jutsu = reject

---

### Phase 5 — ClanSystem

**File:** `src/Server/Systems/ClanSystem.lua`

**Constraints:**
- Passive registered via `PlayerSystem.registerStatModifier()`
- Active: check `activeUnlockLevel` from clan-data (currently 20)
- Active has `cooldown` and `chakraCost` from clan-data
- `clan_none` players: no passive, no active (SP bonus handled by PlayerSystem)
- Cooldown tracked server-side per player

---

### Phase 6 — CombatCalculator

**File:** `src/Server/Systems/CombatCalculator.lua`

**Formula (all values via ConfigLoader):**
```
rawDamage = baseDamage * affinityMult * levelScaling * variance
netDamage = rawDamage * defenseMitigation
```
- `affinityMult` from `ChakraAffinity.getDamageMultiplier()`
- `levelScaling` clamped between `floor` and `cap` from `ConfigLoader.getLevelScalingConfig()`
- `variance` from `ConfigLoader.getVarianceConfig()`
- `defenseMitigation = 1 - defense / (defense + 100)` via `ConfigLoader.calcDefenseMitigation()`
- Result: `{success, damage, isCrit, reason?}`

---

### Phase 7 — ItemRegistry + InventorySystem

**Constraints:**
- `itemId` from `item-definitions.json` is the only valid source
- Respect `stackable` and `maxStack` fields
- Scroll items: on use, call `JutsuSystem.learnJutsu()` using `item.jutsuRef`
- No Tier 3–5 items accessible in Arc 1

---

### Phase 8 — ShopSystem + LootSystem

**ShopSystem constraints:**
- Filter NPC by `arcUnlock <= currentArc` — Reimei Broker (arc3), ANBU Contact (arc2) excluded
- `repRequirement` and `discountCondition` from npc-data respected
- Prices from `ConfigLoader.getShopPrices()`

**LootSystem constraints:**
- All loot table entries must be valid `itemId`
- No Tier 3–5 drops in Arc 1
- Drop rates from `ConfigLoader.getDropRates(enemyType)`

---

### Phase 9 — QuestSystem Arc 1

**Quest IDs in scope:** `q101`, `q102`, `q103`, `q104`, `q104b`, `q105`, `q106`, `q107`, `q108`, `q109`, `qh101`

**Constraints:**
- `getQuestById(id)` returning nil → skip silently, do not crash
- `prerequisiteQuests` (all) and `prerequisiteQuestsAny` (any one) respected
- `choicePoints` trigger rep changes via `PlayerSystem.modifyRep()`
- Flags set via `PlayerSystem.setFlag()`
- Hidden quest `qh101` triggered by flag from q106 explore task
- Q104/Q104b → Q105 branch: both paths lead safely to Q105
- Rewards via ItemRegistry / JutsuSystem, not directly in QuestSystem

---

### Phase 10 — NPCSpawner Arc 1

**Constraints:**
- Only spawn NPCs/enemies with `arcUnlock <= 1`
- Spawn positions from `DataLoader.getLocationDirectory()`
- No Reimei Broker or ANBU Contact in Arc 1
- Boss story spawns triggered by quest, not timer

---

## F. Luau Code Quality Rules

1. **ModuleScript returns a table.** No globals.
2. **Small, focused functions.** Single responsibility.
3. **Defensive checks at function entry.** Validate inputs before acting.
4. **No silent failure for required data.** Missing required data = `error()`. Optional = `warn()` + fallback.
5. **Public API documented by comments** (inputs, outputs, side effects).
6. **Avoid circular requires.** Dependency order: DataLoader <- ConfigLoader <- ChakraAffinity <- JutsuSystem <- CombatCalculator.
7. **Shared modules in `src/Shared`.** Server logic in `src/Server/Systems`.
8. **Result object pattern for action systems:**
   ```lua
   return { success = true, reason = nil,     data = {} }
   return { success = false, reason = "Not enough SP" }
   ```
9. **Comment business logic in Vietnamese; technical/API docs in either language.**
10. **Use `WaitForChild` for cross-service requires.**

---

## G. Post-Phase Review Checklist

After completing any phase:

- [ ] `git diff` reviewed — no accidental changes to `Data/*.json`
- [ ] `python tools/validate-data.py` -> 0 errors, 0 blocking warnings
- [ ] No Tier 3–5 jutsu accessible (tier gate enforced via `canLearnTier`)
- [ ] No hardcoded balance numbers in new/changed Lua files
- [ ] No missing dependency (all `require()` paths exist)
- [ ] No nil crash path (all data lookups handle nil return)
- [ ] Files changed list provided to user
- [ ] Manual test steps written

---

## H. Anti-Regression Checklist

| Check | What to verify |
|-------|---------------|
| `DataLoader.getJutsuForArc` | Uses `arcUnlock` field + `maxTier` param, NOT source string parsing |
| v0.1 call signature | `getJutsuForArc(1, 2)` — maxTier=2 always passed |
| `PlayerSystem.initCharacter` | Rejects `chakraAffinity = "none"` or `"playerChoice"` |
| `ShopSystem` | Filters out NPC with `arcUnlock > currentArc` |
| `QuestSystem` | Handles nil from `getQuestById()` gracefully — no index on nil |
| `LootSystem` | Does not drop Tier 3–5 items in Arc 1 |
| `ChakraAffinity.isMatching` | Returns false if either arg is `"none"` or invalid |
| Boss HP | Read from `bossStats.bosses.*.storyHP`, not hardcoded |
| Reimei Broker / ANBU Contact | Not in `getVendorsForArc(1)` result |
| `ConfigLoader.getMaxLearnableTier()` | Returns 2 for v0.1; this is the only source of truth for tier limit |

---

## I. Reusable Prompt Templates

### 1. Start a new phase
```
Phase [N] — [SystemName]

Preflight:
- git status: [paste output]
- validator: [paste output or "0 errors, 0 warnings"]

Scope:
- Implementing: [SystemName.lua]
- Dependencies: [DataLoader, ConfigLoader, etc.]
- v0.1 constraints: [list relevant D rules]

Task:
[specific requirement]

Please start by reading the relevant Data/*.json fields and existing modules before writing code.
```

### 2. Review a completed phase
```
Phase [N] review — [SystemName]

Files changed: [list]
Please review [SystemName.lua] for:
1. Hardcoded balance numbers (should come from ConfigLoader)
2. Nil crash paths (missing defensive checks)
3. Arc 1 scope violations (Tier 3-5 leak, wrong arcUnlock, Reimei Broker)
4. Result object pattern — all action functions return {success, reason?, data?}
5. Missing public API comments
6. Circular require risk

Also run: python tools/validate-data.py and report result.
```

### 3. Fix a validator error
```
Validator error to fix:

[paste exact validator output]

Context:
- The error references [file.json] -> [field]
- Related system: [name]

Do NOT modify other Data/*.json fields unless required.
Report exactly which lines changed and run the validator again to confirm 0 errors.
```

### 4. Check for Tier leak
```
Tier leak audit for [SystemName.lua]:

Check every code path that references jutsu tier or item tier and confirm:
1. No Tier 3-5 jutsu can be learned (JutsuSystem.canLearnJutsu uses ChakraAffinity.canLearnTier)
2. No Tier 3-5 items dropped by LootSystem in Arc 1
3. No Tier 3+ shop entries in getVendorsForArc(1)
4. getJutsuForArc called as getJutsuForArc(1, 2) — maxTier=2 always passed for v0.1

Report line numbers for any finding.
```

### 5. Prepare for commit
```
Pre-commit check for Phase [N]:

1. Run: git diff --stat
2. Run: python tools/validate-data.py
3. Confirm: no Data/*.json changed unintentionally
4. Confirm: all new Lua files have module comment header
5. Confirm: all public functions have doc comments
6. Confirm: result objects match {success, reason?, data?} pattern
7. Proposed commit message: "Phase [N]: [SystemName] — [one-line description]"

Do NOT git push unless I request it.
```

### 6. Handoff to a new thread
```
Handoff — Naruto Roblox Project

Read first: .claude/skills/naruto-roblox-dev/SKILL.md

Current state:
- Phases done: 1 (DataLoader/ConfigLoader), 2 (PlayerSystem), 3 (ChakraAffinity)
- Next phase: [N] — [SystemName]
- Last validator: 0 errors, 0 warnings
- Untracked/modified files: [git status output]

Preflight before starting:
  git status
  python tools/validate-data.py

v0.1 scope: Arc 1 only, Tier 1-2 only, no GitHub push without my request.
```

---

## J. Definition of Done

A phase is DONE only when ALL of the following are true:

- [ ] `python tools/validate-data.py` -> **0 errors, 0 blocking warnings**
- [ ] `git diff Data/` shows **no unintended data changes**
- [ ] **Files changed list** provided
- [ ] **Test evidence** provided: what to call in Studio + expected output
- [ ] **No v0.1 scope violation**: no Tier 3–5 access, no Arc 2+ content, no future NPC
- [ ] **No significant tech debt**: no TODOs in critical paths
- [ ] **User can review** the diff without reading source data to understand it

---

## K. Phase Progress Tracker

| Phase | System | Status |
|-------|--------|--------|
| 1 | DataLoader + ConfigLoader | Done |
| 2 | PlayerSystem | Done |
| 3 | ChakraAffinity | Done (untracked) |
| 4 | JutsuSystem | NEXT |
| 5 | ClanSystem | Pending |
| 6 | CombatCalculator | Pending |
| 7 | ItemRegistry + InventorySystem | Pending |
| 8 | ShopSystem + LootSystem | Pending |
| 9 | QuestSystem Arc 1 | Pending |
| 10 | NPCSpawner Arc 1 | Pending |

---

*Last updated: 2026-05-21 | Validator: 0 errors, 0 warnings | Branch: main*
