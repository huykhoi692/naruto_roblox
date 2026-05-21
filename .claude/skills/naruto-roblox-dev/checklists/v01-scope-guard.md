# v0.1 Scope Guard

Quick-reference checklist for everything that is OUT of v0.1.
Use this before implementing ANY feature. If in doubt, check here first.

---

## Locked Systems (do NOT implement in v0.1)

| System | Status | Reason |
|--------|--------|--------|
| Arc 2 Chunin Exam content | OUT | Post-v0.1 |
| Arc 3 Sazuki Departure content | OUT | Post-v0.1 |
| Arc 4 Tsukade content | OUT | Post-v0.1 |
| Tier 3–5 jutsu (gameplay) | OUT | Data defined, gameplay locked |
| Secondary Chakra Affinity unlock | OUT | Hidden quest too complex for v0.1 |
| Faction War PvP | OUT | Needs population |
| Event System (scheduled boss) | OUT | Needs concurrent players |
| Villain / Wanderer ending path | OUT | Needs Arc 2+ for meaning |
| Ranked Arena | OUT | Design not finalized |
| Monetization | OUT | Design not finalized |
| Shippuden | OUT | Not yet brainstormed |
| Shop Tier 2–3 | OUT | No Tier 3+ jutsu to sell |
| Dune Village map | OUT | Arc 2 map |
| Echo Stronghold map | OUT | Arc 3 map |
| Tsukade Region map | OUT | Arc 4 map |
| Boss event: Garrek, Sazuki, Orokimaru | OUT | Outside Arc 1 |
| Cross-arc flag "tazuru_dead" effect in Arc 4 | OUT | Arc 4 only |
| Hero/Villain/Wanderer ending reveal | OUT | Arc 4 only |

---

## NPCs that must NOT appear in Arc 1

| NPC ID | arcUnlock | Why blocked |
|--------|-----------|-------------|
| npc_reimei_broker | 3 | Reimei Broker, Arc 3 |
| npc_anbu_contact | 2 | ANBU Contact, Arc 2 |

These will be absent from `DataLoader.getVendorsForArc(1)` — verify this in code review.

---

## Jutsu locked in v0.1 (defined in data, gameplay blocked)

| ID | Name | Reason locked |
|----|------|---------------|
| jutsu_e03 | Earth Spikes | arcUnlock=3 |
| jutsu_wi02 | Vacuum Blade | arcUnlock=2 |
| jutsu_l02 | Thunder Clap | arcUnlock=3 |
| jutsu_n06 | Shadow Clone Jutsu | arcUnlock=2 via item |
| All Tier 3–5 | (any) | maxLearnableTier=2 in v0.1 |

---

## How to enforce in code

```lua
-- JutsuSystem.canLearnJutsu: BOTH checks required
local jutsu = DataLoader.getJutsuById(jutsuId)
if not jutsu then return {success=false, reason="Unknown jutsu"} end
if (jutsu.arcUnlock or 1) > PlayerSystem.getCurrentArc(player) then
    return {success=false, reason="Not available in current arc"}
end
if not ChakraAffinity.canLearnTier(jutsu.tier or 1) then
    return {success=false, reason="Jutsu tier locked in current version"}
end

-- ShopSystem: filter NPCs
local vendors = DataLoader.getVendorsForArc(PlayerSystem.getCurrentArc(player))
-- vendors will automatically exclude arcUnlock>currentArc NPCs

-- QuestSystem: handle future questIds gracefully
local questData = DataLoader.getQuestById(questId)
if not questData then
    warn("[QuestSystem] Quest not found (future content?): " .. tostring(questId))
    return  -- skip silently
end
```

---

## Scope creep warning signs

If you find yourself about to:
- Add a system that's not in Phase 1–10 of SKILL.md
- Reference a boss ID outside `{zaborax, hakuren, demon_brothers, wave_bandits_*}`
- Add a shop NPC not in `{npc_kakashi_jonin, npc_third_hokage, npc_academy_teacher, npc_konohara_shop_owner, npc_wave_merchant}`
- Write logic for rep outcomes `hostile`, `unfriendly`, or `honored` (only `neutral` and `friendly` reachable in Arc 1)
- Implement any ending calculation

**STOP.** Ask the user if this is intentional scope expansion.
