# Code Review Prompt Template

Use when asking Claude to review a Lua file before committing.
Paste this + the file path (or file contents) into the thread.

---

```
Please review [filename.lua] for the naruto_roblox project.

Context:
- Phase: [N] — [SystemName]
- This file is a [ModuleScript / LocalScript / Script]
- Located at: [src/Server/Systems/ or src/Shared/]

Review for the following (in priority order):

1. SCOPE VIOLATIONS
   - Any Tier 3–5 jutsu accessible? (should be gated by ChakraAffinity.canLearnTier)
   - Any arcUnlock > currentArc content reachable?
   - Reimei Broker / ANBU Contact appearing in Arc 1?

2. HARDCODED NUMBERS
   - Any balance value not read from ConfigLoader or DataLoader?
   - Examples to watch: 0.3, 1.15, 2, 100, 150, 30, 16

3. NIL CRASH PATHS
   - Any `DataLoader.getXxx()` result indexed without nil check?
   - Any `result.field` without checking result is not nil?

4. RESULT OBJECT PATTERN (action systems)
   - All action functions return {success, reason?, data?}?

5. DATA ACCESS
   - Any jutsu not looked up via DataLoader.getJutsuById()?
   - Any item not looked up via DataLoader.getItemById()?
   - Any NPC not looked up via DataLoader.getNPCById()?

6. CIRCULAR REQUIRES
   - Does this module require anything that might require it back?

7. MODULE QUALITY
   - Module header comment present? (file path, service path, task, dependencies)
   - All public functions documented?
   - Private helpers marked local?

After review, output:
- PASS / FAIL
- List of issues found (with line numbers)
- Suggested fixes for each issue
```
