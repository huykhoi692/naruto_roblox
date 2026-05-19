# WORKFLOW.md — Cách Làm Việc Với Cowork

## Nguyên Tắc Cơ Bản

1. **Mỗi lệnh = 1 output cụ thể** (1 file, 1 document, 1 JSON)
2. **Luôn nói rõ lưu vào đâu** — Cowork cần biết path
3. **Đọc CLAUDE.md trước** khi bắt đầu session mới
4. **Không ra nhiều lệnh cùng lúc** — làm xong task này mới sang task kia

---

## Cách Bắt Đầu Session

Mỗi khi mở Cowork, lệnh đầu tiên luôn là:

```
Đọc file CLAUDE.md để hiểu context project, sau đó báo tóm tắt những gì đã có.
```

---

## Cấu Trúc Lệnh Chuẩn

```
[Hành động] + [Output cụ thể] + [Path lưu] + [Context nếu cần]
```

**Ví dụ tốt:**
```
Tạo file data/jutsu-definitions.json chứa 10 jutsu Tier 1 và 2,
dựa theo jutsu trong Arc 1 Tide Province của CLAUDE.md.
Mỗi jutsu có: id, name, tier, baseDamage, chakraCost, cooldown, effects.
```

**Ví dụ xấu (quá chung chung):**
```
Làm jutsu system cho tôi
```

---

## Danh Sách Task Theo Phase

Copy phần này vào Cowork Projects → dùng như checklist tiến độ.

### Phase 1 — Data & Design (làm trước)
```
[ ] docs/arc1-wave-country.md      — Chi tiết quest, choice, boss Arc 1
[ ] docs/arc2-chunin-exam.md       — Chi tiết quest, choice, boss Arc 2
[ ] docs/arc3-sasuke-pursuit.md    — Chi tiết quest, choice, boss Arc 3
[ ] docs/arc4-tsunade.md           — Chi tiết quest, choice, boss Arc 4
[ ] data/jutsu-definitions.json    — 20+ jutsu Tier 1–5
[ ] data/clan-data.json            — 4 clan + passive/active
[ ] data/balance-config.json       — Tất cả số liệu damage, cooldown
[ ] data/npc-data.json             — NPCs, location, reputation base
```

### Phase 2 — Core Systems
```
[ ] src/Core/PlayerSystem.lua      — Stats, level, exp
[ ] src/Core/JutsuSystem.lua       — Học, quên, dùng jutsu
[ ] src/Core/ChakraAffinity.lua    — 5 hệ chakra, unlock
[ ] src/Core/ClanSystem.lua        — Passive + active ability
[ ] src/Core/CombatCalculator.lua  — Tính damage
```

### Phase 3 — Story Systems
```
[ ] src/Story/ReputationManager.lua  — Village/Reimei rep
[ ] src/Story/QuestManager.lua       — Quest state, progress
[ ] src/Story/DialogueSystem.lua     — Branching dialogue
[ ] data/quest-data/arc1-quests.json
[ ] src/Story/Arcs/Arc1_WaveCountry.lua
[ ] data/quest-data/arc2-quests.json
[ ] src/Story/Arcs/Arc2_ChuninExam.lua
[ ] data/quest-data/arc3-quests.json
[ ] src/Story/Arcs/Arc3_SazukiPursuit.lua
[ ] data/quest-data/arc4-quests.json
[ ] src/Story/Arcs/Arc4_Tsukade.lua
```

### Phase 4 — Combat & UI
```
[ ] src/Combat/BossSystem.lua
[ ] src/Combat/DungeonManager.lua
[ ] src/UI/HUD.lua
[ ] src/UI/SkillTreeUI.lua
[ ] src/UI/InventoryUI.lua
```

---

## Template Lệnh Cho Từng Loại Task

### Viết GDD (Game Design Document)
```
Đọc CLAUDE.md.
Tạo file docs/[tên-arc].md với nội dung chi tiết cho [tên arc]:
- Danh sách quest (tên, level, NPC, location, mô tả ngắn)
- Với mỗi quest: task cần làm, choice point, hậu quả mỗi lựa chọn
- Boss: HP, jutsu dùng, cơ chế đặc biệt, loot
- Hidden quest (nếu có): trigger, reward
- Jutsu unlock sau arc này
Lưu vào docs/[tên-arc].md
```

### Tạo JSON Data
```
Đọc CLAUDE.md.
Tạo file data/[tên-file].json với cấu trúc sau:
[mô tả fields cần có]
Số lượng: [bao nhiêu records]
Dựa theo: [arc nào / context nào]
Validate JSON trước khi lưu.
```

### Viết Lua Script
```
Đọc CLAUDE.md.
Tạo file src/[path]/[tên].lua — ModuleScript cho Roblox:
- [Mô tả chức năng]
- Methods cần có: [list methods]
- Comment tiếng Việt
- Return module table ở cuối
```

### Brainstorm
```
Đọc CLAUDE.md.
Brainstorm [topic] cho game này.
Chỉ đề xuất những thứ chưa được chốt trong CLAUDE.md.
Đưa ra 2–3 hướng khác nhau, nêu pros/cons mỗi hướng.
```

---

## Cách Theo Dõi Tiến Độ

### Option 1: Dùng Cowork Projects
- Tạo 1 Project tên "Naruko Roblox"
- Mỗi Phase = 1 task group
- Tick vào checklist trên sau khi xong từng file

### Option 2: File progress.md
Yêu cầu Cowork tạo và cập nhật file này sau mỗi task:

```
Cập nhật file progress.md:
- Đánh dấu [x] vào task vừa xong
- Ghi ngày hoàn thành
- Ghi note nếu có thứ gì chưa làm
```

### Format progress.md
```markdown
# Tiến Độ Project

## Phase 1 — Data & Design
- [x] docs/arc1-wave-country.md        (15/05/2026)
- [ ] docs/arc2-chunin-exam.md
- [ ] data/jutsu-definitions.json

## Phase 2 — Core Systems
- [ ] src/Core/PlayerSystem.lua
...

## Ghi Chú
- Arc 1 chưa có hidden quest cho Chakra Nước
- Clan balance chưa chốt số liệu
```

---

## Xử Lý Khi Cowork Làm Sai

**Nếu output không đúng format:**
```
File [tên] vừa tạo chưa đúng. Cần sửa: [mô tả cụ thể].
Đọc lại CLAUDE.md phần [section liên quan] rồi tạo lại.
```

**Nếu Cowork tự thêm thứ không cần:**
```
Chỉ làm đúng những gì tôi yêu cầu.
Xóa [phần thừa] khỏi file vừa tạo.
```

**Nếu muốn tiếp tục từ session cũ:**
```
Đọc CLAUDE.md và progress.md.
Task tiếp theo cần làm là [task].
```

---

## Thứ Tự Khuyên Dùng

```
Ngày 1: Phase 1 toàn bộ (docs + data) — hiểu rõ game trước khi code
Ngày 2: Phase 2 Core Systems
Ngày 3: Phase 3 Story (Arc 1 + 2)
Ngày 4: Phase 3 Story (Arc 3 + 4)
Ngày 5: Phase 4 Combat + UI
```

Làm docs và data trước giúp Cowork có đủ context khi viết code — tránh phải sửa lại nhiều.
