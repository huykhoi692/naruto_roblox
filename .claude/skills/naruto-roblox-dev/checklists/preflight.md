# Preflight Checklist

Run this at the START of every thread and every phase.
Copy-paste the commands, paste the outputs into the phase-start prompt.

---

## Step 1 — Git state
```bash
git status
git diff --stat
```

Expected clean state:
- `On branch main`
- Modified: only the files you expect from previous session
- Untracked: `src/Shared/ChakraAffinity.lua` (not yet committed as of 2026-05-21)

If unexpected files are modified -> STOP. Ask user before continuing.

---

## Step 2 — Validator
```bash
python tools/validate-data.py
```

Expected:
```
Validation PASSED.
No errors!
No warnings.
```

If errors exist -> fix them first. Do NOT start a new phase with a broken validator.
If warnings exist -> review with user before proceeding.

---

## Step 3 — Summarize before coding

After running preflight, write a brief summary:

```
Preflight summary:
- Branch: main | Modified: [list] | Untracked: [list]
- Validator: [0 errors / N errors — describe]
- Phase intent: [what I'm about to implement]
- Rules in play: [list relevant D-rules from SKILL.md]
- Blockers: [none / describe]
```

Do NOT write code until this summary is written and the user has not objected.

---

## Step 4 — Read relevant files

Before writing Phase N code, always read:
- The new system's target data in `Data/*.json`
- The modules this system depends on
- The relevant section in `SKILL.md` (Phase N spec)

Minimum reads per phase:
| Phase | Must read |
|-------|-----------|
| 4 JutsuSystem | jutsu-definitions.json, balance-config (skillPointSystem), ChakraAffinity.lua, PlayerSystem.lua |
| 5 ClanSystem | clan-data.json, PlayerSystem.lua |
| 6 CombatCalculator | balance-config (damageFormula), ChakraAffinity.lua, JutsuSystem.lua |
| 7 ItemRegistry/Inventory | item-definitions.json, JutsuSystem.lua |
| 8 ShopSystem/LootSystem | npc-data.json, balance-config (economySystem, bossStats), item-definitions.json |
| 9 QuestSystem | quest-definitions.json, npc-data.json, PlayerSystem.lua |
| 10 NPCSpawner | npc-data.json (locationDirectory), balance-config (bossSchedule) |
