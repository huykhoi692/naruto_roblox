<!-- CLAUDE INSTRUCTIONS — READ THIS FIRST -->
# Claude Entry Point

> This file is the entry point for every Claude thread working on this project.
> Do not skip the steps below — they prevent scope drift and data corruption.

## Step 1 — Load the skill
Read: `.claude/skills/naruto-roblox-dev/SKILL.md`

That file contains the full project context, architecture, non-negotiable rules, phase specs, and reusable prompts.

## Step 2 — Run preflight
```bash
git status
python tools/validate-data.py
```
Do NOT write any code if the validator has errors.

## Step 3 — Respect v0.1 scope
- Arc 1 (Tide Province, levels 1–15) only.
- Tier 1–2 jutsu only (`maxLearnableTier = 2` in balance-config).
- No Tier 3–5, no Arc 2/3/4 content, no Faction War, no Events, no Monetization.
- Check `.claude/skills/naruto-roblox-dev/checklists/v01-scope-guard.md` when in doubt.

## Step 4 — Current phase status
| Phase | System | Status |
|-------|--------|--------|
| 1 | DataLoader + ConfigLoader | Done |
| 2 | PlayerSystem | Done |
| 3 | ChakraAffinity | Done |
| 4 | JutsuSystem | Done |

## Step 5 — Rules that are never optional
1. Run validator before coding.
2. No hardcoded balance numbers — use ConfigLoader.
3. No GitHub push/pull unless the user explicitly asks.
4. Data/*.json is source of truth — do not modify without user approval.
5. Report files changed + validator result after every phase.

---
<!-- END CLAUDE INSTRUCTIONS -->

## Quick Start (TL;DR)
```
1. Read .claude/skills/naruto-roblox-dev/SKILL.md
2. git status
3. python tools/validate-data.py   ← 0 errors required before any code
4. Follow phase-based workflow in SKILL.md Section E
5. Do NOT git push/pull unless explicitly requested
```

## GameData Runtime Setup (Roblox Studio)

`DataLoader.lua` requires a **Folder** named `GameData` inside `ReplicatedStorage`, containing one `StringValue` per JSON file:

```
ReplicatedStorage
  GameData (Folder)
    balance-config    (StringValue)  ← paste contents of Data/balance-config.json
    clan-data         (StringValue)  ← paste contents of Data/clan-data.json
    jutsu-definitions (StringValue)  ← paste contents of Data/jutsu-definitions.json
    item-definitions  (StringValue)  ← paste contents of Data/item-definitions.json
    npc-data          (StringValue)  ← paste contents of Data/npc-data.json
    quest-definitions (StringValue)  ← paste contents of Data/quest-definitions.json
```

**Manual setup (current v0.1 workflow):**
1. In Studio, create a `Folder` named `GameData` under `ReplicatedStorage`.
2. For each JSON file in `Data/`, create a `StringValue` with the matching name (no `.json` extension).
3. Paste the full JSON text into `.Value` of each `StringValue`.
4. Re-paste whenever a `Data/*.json` file changes.

**Future automation (proposed — do NOT implement yet):**
`tools/generate-gamedata.lua` or `tools/export-to-studio.py` — a script that reads `Data/*.json`
and generates a Roblox model file (`.rbxmx`) that can be drag-dropped into Studio to replace
all `StringValues` at once. Implement in Phase 8+ when data changes become frequent.

**Note:** With Rojo (`default.project.json`), `src/Shared` and `src/Server/Systems` sync automatically.
`Data/*.json` → `GameData` StringValues does **not** sync via Rojo — manual paste required until
the generate script is built.

---

# Naruko Roblox Game — Ý Tưởng & Vision

## Game Là Gì

Game Roblox nhập vai thế giới Naruko. Người chơi **không chơi Naruko hay Sazuki** — họ tạo nhân vật riêng và sống trong thế giới đó. Các nhân vật canon (Naruko, Sazuki, Kakashi, Orokimaru,...) tồn tại như NPC và ảnh hưởng đến cốt truyện.

Toàn bộ cốt truyện **Naruko hồi nhỏ (Original Series)** được tái hiện lại, nhưng nhân vật người chơi có thể chọn:
- **Bảo vệ làng** → con đường anh hùng
- **Phản bội làng** → gia nhập Reimei, trở thành phản diện

---

## Những Thứ Cốt Lõi

### Nhân Vật Tự Tạo
- Chọn tên, gia tộc, Chakra chính
- Gia tộc ảnh hưởng passive và 1 kỹ năng đặc biệt
- Không bị ép theo một build cụ thể

### Hệ Thống Nhẫn Thuật
- Học tự do nhưng **tối đa 6 jutsu** cùng lúc
- Muốn học jutsu mới → phải quên jutsu cũ
- Jutsu chia 5 tầng: càng mạnh càng khó học, càng tốn SP
- Học theo Chakra Affinity: jutsu đúng hệ học rẻ hơn, mạnh hơn

### Hệ Chakra (5 loại)
Lửa / Nước / Đất / Gió / Sét — mỗi loại có lợi thế riêng.
Người chơi bắt đầu với 1 hệ, mở thêm bằng **hidden quest** (không mua được).

### Gia Tộc & Huyết Kế Giới Hạn
- Uchira, Senjura, Hyuura, hoặc không clan
- Mỗi clan có 1 passive (buff nhỏ) + 1 active ability (cooldown dài)
- Không clan → +1 skill point tự do mỗi level

### Hệ Danh Tiếng (Reputation)
- Mỗi hành động cộng/trừ điểm với 2 phe: **Làng** và **Reimei**
- Điểm rep ảnh hưởng NPC phản ứng thế nào, quest nào mở ra
- Dẫn đến 3 kết thúc: Hero / Villain / Wanderer

---

## Cốt Truyện — 4 Arc Chính (Original Series)

### Arc 1: Tide Province (Level 1–15)
Nhiệm vụ đầu tiên cùng Team 7, gặp Zaborax và Hakuren.
Lựa chọn đầu tiên: bảo vệ dân làng khi bị tấn công hay bỏ chạy.

### Arc 2: Chunin Exam (Level 15–30)
Thi Chunin qua 3 giai đoạn: bài thi viết → rừng chết → đấu đài.
Gặp Garrek, Orokimaru xuất hiện. Làng bị tấn công — chọn ưu tiên ai.

### Arc 3: Sazuki Rời Làng (Level 28–40)
Sazuki bị Orokimaru dụ dỗ, bỏ trốn.
Đuổi theo, thâm nhập Echo Stronghold, đối mặt Sound Four.
Lựa chọn: thuyết phục Sazuki quay về hay để hắn đi.

### Arc 4: Tìm Tsukade (Level 40–50)
Cùng Jiruha và Naruko tìm Tsukade — Sanin huyền thoại.
Orokimaru phục kích trên đường về. Kết thúc Original Series.

---

## Định Hướng Gameplay (Đã Chốt)

Game hướng đến mô hình **multiplayer competitive** tương tự Blox Fruits nhưng có chiều sâu hơn — story arc làm progression gate, PvP có faction context, grind có mục tiêu rõ ràng.

### Map — Hub & Spoke
Konohara là trung tâm, 4 zone tỏa ra các hướng:
```
              Tide Province (Arc 1, Lv 1–15)
                      |
Dune Village ──── KONOHA ──── Echo Stronghold (Arc 3, Lv 28–40)
                      |
               Chunin Zone (Arc 2, Lv 15–30)
                      |
              Tsukade Region (Arc 4, Lv 40–50)
```
- Player cấp cao vẫn có lý do quay lại zone thấp (boss event, faction territory, material farming)
- Konohara là safe zone và social hub

### PvP — Faction War Territory
- 2 faction: **Làng (Village)** vs **Reimei**
- Mỗi zone có "control meter" — faction farm boss/NPC nhiều hơn trong tuần thì control zone đó
- Zone bị control: faction địch bị debuff nhỏ khi vào
- Contested zone: drop rate +20%, PvP bật full
- Reset hàng tuần — faction thắng nhận reward (jutsu material, cosmetic, rep bonus)
- Cùng faction **không thể** đánh nhau

### PvP Level Gap — Cứng 15 Level
- Chênh lệch > 15 level → không thể gây damage cho nhau
- Áp dụng **tuyệt đối** — không ngoại lệ kể cả trong event
- Lý do: tránh snowball, bảo vệ người mới, không tạo ra "người mạnh càng mạnh"

### Event System — 2 Lớp Thắng/Thua
Boss event (Zaborax, Garrek, Orokimaru...) spawn theo lịch cố định, toàn server tham gia:

**Lớp 1 — Faction thắng territory:**
Tổng damage Village vs tổng damage Reimei → faction cao hơn kiểm soát zone

**Lớp 2 — Cá nhân nhận reward:**
Tính % contribution trong **level bracket** của mình, không phải damage tuyệt đối
- Bracket ví dụ: 1–15 / 15–25 / 25–35 / 35–50
- Top contributor trong bracket → reward tier cao, dù damage thấp hơn player cấp cao

**Objective phụ trong event:**
Bảo vệ NPC, phá shield boss, dẫn dụ mob — không cần level cao, cần phối hợp
Hoàn thành objective cộng vào cả faction score lẫn cá nhân reward

---

## Những Thứ Chưa Chốt

- **Gia tộc balance**: Chưa quyết định số lượng clan, có nên thêm clan nhỏ không
- **Monetization**: Chỉ cosmetic hay có gì khác
- **Shippuden**: Sẽ brainstorm sau khi xong Original
- **Ranked Arena**: Có thêm 1v1 ranked riêng ngoài open-world PvP không
- **Bracket level cụ thể**: Con số bracket event cần test và điều chỉnh sau

---

## Mục Tiêu Khi Làm Việc Với File Này

Khi nhận yêu cầu liên quan đến game này:
- Dựa trên những gì đã có ở trên làm nền
- Không mâu thuẫn với design đã chốt
- Những thứ "chưa chốt" → đề xuất hướng, không tự quyết
- Shippuden chưa brainstorm → chưa đề cập
