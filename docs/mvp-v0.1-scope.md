# MVP v0.1 — Scope Lock

> File này là nguồn sự thật duy nhất cho những gì **có mặt** trong build v0.1.  
> Mọi thứ không có trong danh sách IN đều là **OUT** — không implement, không để placeholder, không cần document thêm.

---

## Mục Tiêu v0.1

Deliver **Arc 1: Tide Province hoàn chỉnh** — người chơi có thể tạo nhân vật, học jutsu, hoàn thành toàn bộ quest chain Tide Province, đánh boss Zaborax + Hakuren, và nhận kết quả reputation đầu tiên.

**Đây là vertical slice**, không phải prototype. Combat, progression, và story phải cảm giác finished trong phạm vi level 1–15.

---

## IN — Có Trong v0.1

### Nhân Vật & Tạo Nhân Vật
- Chọn tên tự do
- Chọn 1 trong 4 clan: Uchira / Senjura / Hyuura / No Clan
- Chọn Chakra Affinity chính (1 hệ, cố định khi tạo)
- Clan passive active ngay từ đầu
- **Clan active** unlock tại level 20 — không thuộc story Arc 1 (kết thúc lv 15), nhưng nằm trong post-arc buffer của v0.1 để người chơi có mục tiêu grind thêm sau Tide Province

### Hệ Thống Jutsu
- 6 slot trang bị, thay thế tự do
- **Rule chọn jutsu v0.1**: một jutsu được IN nếu ít nhất 1 source của nó accessible trong Arc 1 (Konohara shop tier 1, drop Arc 1 enemy/boss, hidden quest Arc 1)
- Tier 3–5 locked toàn bộ — không xuất hiện trong shop hoặc drop
- Chakra Affinity discount (−30% cost) và damage bonus (+15%) hoạt động đầy đủ
- Học jutsu tốn SP theo bảng `skillPointSystem.jutsuLearnCost`

**Jutsu available trong v0.1** (11 jutsu, Tier 1–2):

| ID | Tên | Tier | Lý do IN |
|---|---|---|---|
| jutsu_f01 | Fireball Jutsu | 1 | shop_konohara_tier1 |
| jutsu_f02 | Phoenix Flower Jutsu | 1 | shop_konohara_tier1 |
| jutsu_f03 | Great Fireball | 2 | boss_drop_zaborax_rare |
| jutsu_w01 | Water Whip | 1 | shop_konohara_tier1 |
| jutsu_w02 | Phantom Mist Technique | 2 | hidden_quest_arc1_scroll_A |
| jutsu_e01 | Earth Wall | 1 | shop_konohara_tier1 |
| jutsu_e02 | Rock Fist | 1 | shop_konohara_tier1 |
| jutsu_wi01 | Wind Slash | 1 | shop_konohara_tier1 |
| jutsu_l01 | Static Charge | 1 | shop_konohara_tier1 |
| jutsu_n01 | Spirit Double Jutsu | 2 | quest_q108_reward |
| jutsu_n02 | Substitution Jutsu | 1 | shop_konohara_tier1 / quest_q101_reward |

**Jutsu Tier 2 bị lock** (source ngoài Arc 1): jutsu_e03 (Arc 3), jutsu_wi02 (Arc 2), jutsu_l02 (Arc 3), jutsu_n06 (item Arc 2)

### Map
- **Konohara Hub** — safe zone, shop tier 1, NPC giao quest
- **Tide Province Zone** — zone chính arc 1, không có respawn penalty

### Quest & Story Arc 1
- Toàn bộ quest chain Tide Province (cấp 1–15)
- NPC canon: Kakashi, Naruko, Sazuki, Sakuri (Team 7) — vai trò hỗ trợ quest
- NPC địch: Gatō's thuê binh, Zaborax, Hakuren
- **Lựa chọn đạo đức đầu tiên**: bảo vệ dân làng khi bị tấn công hay bỏ chạy → cộng/trừ Village rep

### Boss
- **Zaborax** — story boss, HP từ `storyHP` trong balance-config
- **Hakuren** — story boss, HP từ `storyHP`
- Loot table theo `bossStats` đã định nghĩa, chỉ tier 1–2 drops active

### Reputation
- Track `village` rep và `reimei` rep
- Threshold hiển thị (hostile / unfriendly / neutral / friendly / honored) — nhưng chỉ tier `neutral` và `friendly` có thể đạt được trong arc 1
- **Chưa reveal ending** — player chỉ thấy số điểm rep, không thấy Hero/Villain/Wanderer path

### Combat
- Melee cơ bản (auto-attack)
- Jutsu từ 6 slot
- Chakra regen (in-combat và out-of-combat)
- Damage formula đầy đủ (affinity, level scaling, defense mitigation, variance)
- Clan passive hoạt động
- Clan active (level 20) hoạt động

### Economy Cơ Bản
- Drop ryo từ enemy (theo `economySystem.dropRates`)
- Shop Konohara: bán tier 1 jutsu scroll + basic consumable
- **Không** có shop tier 2+ trong v0.1

---

## OUT — Không Có Trong v0.1

| Hạng mục | Lý do defer |
|---|---|
| Arc 2, 3, 4 | Chưa cần — v0.1 là Arc 1 only |
| Tier 3–5 jutsu (gameplay) | Defined trong data nhưng locked |
| Faction War PvP | Cần ≥2 faction có population, meaningless ở v0.1 |
| Event System (boss spawn schedule, bracket reward) | Cần nhiều player online cùng lúc |
| Secondary Chakra Affinity unlock (hidden quest) | Phức tạp, không ảnh hưởng core loop arc 1 |
| Villain / Wanderer ending path | Reimei rep cần arc 2+ content để có ý nghĩa |
| Boss event Garrek, Sazuki, Orokimaru | Ngoài phạm vi arc 1 |
| Shop tier 2–3 | Không có jutsu tier 3+ để bán |
| Dune Village zone | Map arc 2 |
| Echo Stronghold zone | Map arc 3 |
| Tsukade Region zone | Map arc 4 |
| Ranked Arena | Chưa chốt thiết kế |
| Monetization | Chưa chốt |
| Shippuden | Chưa brainstorm |

---

## Level Range & Tiến Độ

```
Level 1  ──► Tide Province quest bắt đầu
Level 5  ──► Gặp Zaborax lần đầu (scripted encounter)
Level 10 ──► Zaborax story boss fight
Level 12 ──► Hakuren fight
Level 14 ──► Lựa chọn cuối arc 1 (cứu Hakuren hay không)
Level 15 ──► Arc 1 kết thúc, cửa Arc 2 mở (locked trong v0.1)
Level 20 ──► Clan active unlock (trong phạm vi nếu người chơi grind thêm)
```

---

## Điều Kiện "Done" Của v0.1

- [ ] Người chơi tạo nhân vật → vào game không bị lỗi
- [ ] Hoàn thành toàn bộ quest chain arc 1 không bị block
- [ ] Zaborax và Hakuren có thể bị đánh bại (solo hoặc nhóm nhỏ)
- [ ] Village rep thay đổi đúng theo lựa chọn
- [ ] 6 jutsu slot hoạt động: learn, equip, swap, use trong combat
- [ ] Clan passive có effect rõ ràng trong combat
- [ ] EXP và level up hoạt động đến level 20 (buffer +5 sau arc 1)
- [ ] Không có content nào của arc 2+ accessible

---

## Số Liệu Cần Đạt (target, không phải spec cứng)

| Metric | Target |
|---|---|
| Thời gian hoàn thành arc 1 (casual) | 3–5 giờ |
| Thời gian hoàn thành arc 1 (focused) | ~2 giờ |
| Số quest arc 1 | 8–12 quest |
| Jutsu có thể học trong arc 1 | 10–15 jutsu (tier 1–2) |
| Số lần gặp Zaborax (story) trước boss fight | ≥2 lần |

---

*Cập nhật lần cuối: 2026-05-18*  
*Version tiếp theo: v0.2 sẽ include Arc 2 + PvP basic*
