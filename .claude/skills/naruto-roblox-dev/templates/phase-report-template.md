# Phase Report Template

Use this to structure the final report after completing a phase.
Claude should fill this out before declaring a phase DONE.

---

```
=== PHASE [N] COMPLETE — [SystemName] ===

Files changed:
  Created:
    - src/Server/Systems/[Name].lua  ([N] lines)
  Modified:
    - (none)  OR  list any modified files

Data changes:
  - Data/*.json: NO changes  (expected — data is source of truth)

Validator result:
  python tools/validate-data.py -> [0 errors, 0 warnings]

v0.1 scope:
  - Tier gate: enforced via ChakraAffinity.canLearnTier() [yes/no]
  - Arc gate: arcUnlock check present [yes/no]
  - Reimei Broker / ANBU Contact: absent from Arc 1 queries [yes/no]

Hardcode check:
  - No balance numbers hardcoded [yes/no]
  - All costs/multipliers read from ConfigLoader [yes/no]

Nil safety:
  - All DataLoader lookups check for nil [yes/no]
  - All action functions return result object [yes/no]

Manual test steps (run in Roblox Studio):
  1. DataLoader.loadAll()
  2. PlayerSystem.init()
  3. [call the new system with test inputs]
  4. Expected output: [describe]

Commit message:
  "Phase [N]: [SystemName] — [one-line summary]"

Blockers / known issues:
  - [none]  OR  [describe, e.g. "castJutsu deferred to Phase 6 — needs CombatCalculator"]

Next phase:
  Phase [N+1] — [SystemName]
  Read first: Phase [N+1] section in SKILL.md
```
