# Phase Start Prompt Template

Copy this template, fill in the blanks, and paste it at the start of a new thread
(or when starting a new phase in an existing thread).

---

```
I'm working on the Naruto Roblox game project (naruto_roblox/).
Read the skill first: .claude/skills/naruto-roblox-dev/SKILL.md

=== PREFLIGHT ===

git status output:
[PASTE HERE]

python tools/validate-data.py output:
[PASTE HERE]

=== PHASE ===

Phase: [N] — [SystemName]
File to create: src/Server/Systems/[Name].lua
(or: src/Shared/[Name].lua)

Dependencies:
- DataLoader (src/Shared/DataLoader.lua) — [already done]
- ConfigLoader (src/Shared/ConfigLoader.lua) — [already done]
- ChakraAffinity (src/Shared/ChakraAffinity.lua) — [already done]
- PlayerSystem (src/Server/Systems/PlayerSystem.lua) — [already done]
- [Other deps if needed]

=== TASK ===

[Describe exactly what to implement. Reference the Phase N section of SKILL.md.]
[Example: "Implement JutsuSystem.lua with the API in Phase 4 of SKILL.md.
Focus on learnJutsu, canLearnJutsu, equipJutsu, unequipJutsu.
Do not implement castJutsu yet — that needs CombatCalculator."]

=== RULES ===

Mandatory for this phase (copy relevant rules from SKILL.md Section D):
- Rule 1: [e.g., "No Tier 3–5 — use ChakraAffinity.canLearnTier()"]
- Rule 2: [e.g., "No hardcode — SP cost from ConfigLoader.getJutsuLearnCost()"]
- Rule 3: [e.g., "Result object pattern — {success, reason?, data?}"]

v0.1 scope: Arc 1 only, Tier 1–2 only, no GitHub push without my request.
```
