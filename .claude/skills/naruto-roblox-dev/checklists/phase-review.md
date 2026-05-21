# Phase Review Checklist

Run after completing any phase. All boxes must be checked before declaring DONE.

---

## 1. Validator
```bash
python tools/validate-data.py
```
- [ ] 0 errors
- [ ] 0 blocking warnings (or user has approved warnings)

---

## 2. Data integrity
```bash
git diff Data/
```
- [ ] No unintended changes to `Data/*.json`
- [ ] If Data was intentionally changed: user explicitly approved it

---

## 3. No hardcoded balance numbers
Search the new file(s):
```bash
grep -n "[0-9]\+\." src/Server/Systems/NewSystem.lua | head -30
```
- [ ] Every number that represents a game balance value is read from ConfigLoader or DataLoader
- [ ] Magic numbers like `0.3`, `1.15`, `100`, `150` do not appear in Lua without coming from data

---

## 4. Scope guard — v0.1 only
- [ ] No Tier 3–5 jutsu can be accessed by any code path
- [ ] No NPC/shop/quest with `arcUnlock > 1` is spawnable or reachable
- [ ] No Arc 2/3/4 content referenced (maps, bosses, quest IDs)
- [ ] Reimei Broker and ANBU Contact absent from any Arc 1 query result

---

## 5. Nil safety
- [ ] Every `DataLoader.getXxx()` call checks for nil return before indexing
- [ ] Every `require()` module is expected to exist (no speculative requires)
- [ ] No `result.field` access without first checking `result` is not nil

---

## 6. Result object pattern (action systems only)
- [ ] All action functions (learn, equip, cast, buy, accept, etc.) return `{success, reason?, data?}`
- [ ] Callers can check `result.success` without crashing

---

## 7. API documentation
- [ ] Every public function has a comment block describing: purpose, inputs, outputs
- [ ] Module header comment includes: file name, service path, task summary, dependencies

---

## 8. Files changed
List every file created or modified:
```
Created:
  src/Server/Systems/[Name].lua

Modified:
  (none expected unless explicitly planned)
```

---

## 9. Manual test steps
Write out steps to verify in Roblox Studio:
```
1. Call DataLoader.loadAll()
2. Call PlayerSystem.init()
3. Simulate player join with initCharacter(...)
4. Call [NewSystem.someFunction()] with [inputs]
5. Expected output: [describe]
6. Check: no errors in output, no Tier 3+ access
```

---

## 10. Commit readiness
- [ ] All new Lua files have correct module header comment
- [ ] No TODO comments left in critical logic paths
- [ ] Proposed commit message written: `Phase N: SystemName — description`
- [ ] NOT pushed to GitHub (wait for user request)
