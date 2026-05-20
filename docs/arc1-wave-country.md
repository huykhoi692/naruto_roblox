# Arc 1: Tide Province — Game Design Document

**Level range:** 1–15  
**Phe ảnh hưởng:** Làng Lá (Village rep +/-)  
**NPC chính:** Kakashi, Naruko, Sazuki, Sakuri, Tazuru, Zaborax, Hakuren  

---

## Tổng Quan

Arc đầu tiên. Người chơi vừa tốt nghiệp Học Viện Ninja, được phân vào đội cùng các thành viên Team 7. Nhiệm vụ bảo vệ Tazuru — người thợ xây cầu — sang Tide Province. Trên đường đi gặp Zaborax và Hakuren, hai shinobi làm thuê cho Gato.

**Chủ đề cốt lõi:** Lòng dũng cảm khi đối mặt kẻ mạnh hơn nhiều lần. Lần đầu tiên người chơi phải chọn: chiến đấu hay bỏ chạy.

---

## Danh Sách Quest

### Q1-01 — Ngày Đầu Làm Genin
- **Level yêu cầu:** 1  
- **NPC giao:** Kakashi (Cổng làng Konohara)  
- **Location:** Konohara — Training Ground 7  
- **Mô tả:** Bài kiểm tra đầu tiên của đội. Kakashi kiểm tra kỹ năng cơ bản trước khi xuất phát.  
- **Task:**
  - Hoàn thành bài tập ném kunai (mini-game chính xác)
  - Thực hiện đúng 3 hand seal cơ bản (tutorial chakra)
  - Nói chuyện với Naruko, Sazuki, Sakuri để biết thông tin đội
- **Reward:** 200 EXP, Kunai x5, Shuriken x10  
- **Không có choice point**

---

### Q1-02 — Nhiệm Vụ C-Rank Đầu Tiên
- **Level yêu cầu:** 2  
- **NPC giao:** Hokage Đệ Tam (Phòng Hokage)  
- **Location:** Konohara → Đường về Tide Province  
- **Mô tả:** Đội được nhận nhiệm vụ bảo vệ Tazuru. Trên đường đi, Naruko làm ầm ĩ cả đoàn.  
- **Task:**
  - Đi cùng đoàn qua 3 checkpoint (tự động khi di chuyển)
  - Nghe Tazuru kể chuyện Tide Province bị Gato kiểm soát
- **Reward:** 300 EXP  
- **Không có choice point**

---

### Q1-03 — Phục Kích Trên Đường
- **Level yêu cầu:** 3  
- **NPC:** Demon Brothers (Gozu & Meizu)  
- **Location:** Rừng phía Đông Konohara  
- **Mô tả:** Hai Chunin làm thuê của Gato phục kích đoàn. Đây là trận chiến thật đầu tiên.  
- **Task:**
  - Chiến đấu với Demon Brothers (2 enemy, HP thấp, tutorial combat)
  - Bảo vệ Tazuru không bị hạ dưới 50% HP
- **Boss nhỏ:** Demon Brothers
  - HP: 300 mỗi người
  - Skill: Chain Slash (AOE ngắn), Poison Kunai (debuff chậm)
  - Cơ chế: Tấn công luân phiên — khi 1 người bị hạ, người còn lại tăng tốc độ

**⚑ CHOICE POINT 1: Chiến hay Rút?**
> Khi trận bắt đầu, Kakashi nói: *"Nhiệm vụ này đã vượt C-Rank. Chúng ta có thể rút lui."*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Chiến đấu** | Đối mặt Demon Brothers | +15 Village Rep, +10 EXP bonus, mở Q1-04 bình thường |
| **[B] Rút lui** | Bỏ nhiệm vụ, quay về Konohara | -20 Village Rep, mở Q1-04b (bị Kakashi thất vọng), Tazuru chết (ảnh hưởng ending) |

*Lưu ý: Chọn [B] không kết thúc arc — Kakashi cho cơ hội chuộc lỗi ở Q1-04b.*

- **Reward (nếu thắng):** 500 EXP, Reward Money 100 Ryo

---

### Q1-04 — Sương Mù Dày Đặc
- **Level yêu cầu:** 5  
- **Location:** Bến tàu → Tide Province  
- **Mô tả:** Đoàn vượt biển trong sương mù. Zaborax xuất hiện — lần đầu người chơi thấy Jonin-level shinobi thật sự.  
- **Task:**
  - Hộ tống Tazuru qua bản đồ sương mù (tầm nhìn giảm 60%)
  - Phát hiện Zaborax trước khi hắn tấn công (skill check — Perception)
- **Reward:** 400 EXP

*(Q1-04b — nếu chọn rút lui ở Q1-03)*  
- Kakashi kéo lại đội, nhiệm vụ tiếp tục nhưng Tazuru bị thương nhẹ
- -10 Village Rep bổ sung, Q1-05 khó hơn (Zaborax HP +20%)

---

### Q1-05 — Trận Đầu Với Zaborax
- **Level yêu cầu:** 6  
- **Location:** Rừng Tide Province, bên hồ sương mù  
- **Mô tả:** Kakashi đối đầu Zaborax. Người chơi phải bảo vệ Tazuru trong khi Kakashi chiến đấu.  
- **Task:**
  - Bảo vệ Tazuru khỏi 4 Wave Clone của Zaborax (mini-boss wave)
  - Giữ Tazuru còn sống — nếu Tazuru chết, arc kết thúc sớm theo nhánh đặc biệt
  - Sống sót 3 phút (timer) cho đến khi Hakuren can thiệp

**Boss phụ: Zaborax's Water Clones (x4)**
- HP: 150 mỗi clone
- Skill: Water Whip (đánh đơn mạnh), Mist Concealment (tàng hình ngắn)
- Cơ chế: Spawn lại 1 clone sau 30 giây — phải tiêu diệt đủ 4 cùng lúc để stop respawn

**⚑ CHOICE POINT 2: Hakuren Xuất Hiện**
> Hakuren (đội mặt nạ) xuất hiện và bắn kim vào Zaborax, "giải cứu" đoàn. Thực ra là để Zaborax nghỉ hồi phục.

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Tin tưởng Hakuren** | Để Hakuren rời đi, không truy đuổi | Q1-07 mở scene đặc biệt với Hakuren; Hakuren tiết lộ danh tính trước trận cuối |
| **[B] Truy đuổi Hakuren** | Cố chạy theo để điều tra | Hakuren đánh ngất trong 1 hit (buộc thất bại), nhưng player nhìn thấy khuôn mặt thật — được buff nhỏ trong boss fight |

- **Reward:** 800 EXP, unlock Q1-06

---

### Q1-06 — Sống Trong Làng Wave
- **Level yêu cầu:** 8  
- **Location:** Nhà Tazuru, Làng Tide Province  
- **Mô tả:** Đội nghỉ ngơi và luyện tập. Người chơi khám phá làng, gặp Inaro (cháu Tazuru) và nghe câu chuyện về Kaiza.  
- **Task:**
  - Nói chuyện với Inaro (unlock lore)
  - Luyện tập Chakra Control: leo cây không có ninja tool (mini-game)
  - Tìm vị trí bí mật trong rừng (dẫn đến Hidden Quest)
- **Reward:** 600 EXP, +5 Max Chakra vĩnh viễn (từ bài tập leo cây)

**⚑ CHOICE POINT 3: Inaro Bị Bắt Nạt**
> Bọn lính của Gato đang bắt nạt dân làng ở chợ.

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Can thiệp** | Đánh đuổi lính Gato | +20 Village Rep, +10 Wave Rep (phe thứ 3), Inaro kính phục → unlock dialogue đặc biệt |
| **[B] Bỏ qua** | Tiếp tục nhiệm vụ chính | Không thay đổi rep, nhưng Inaro coi thường → mất 1 dialogue branch ở Q1-08 |
| **[C] Mặc cả với lính** | Đưa thông tin về đoàn để đổi lấy việc thả dân | -30 Village Rep, +10 Reimei Intel (passive), lính báo cáo Zaborax — boss fight khó hơn |

---

### Q1-07 — Đêm Trước Trận Cuối
- **Level yêu cầu:** 10  
- **Location:** Rừng gần nhà Tazuru  
- **Mô tả:** Người chơi tình cờ gặp Hakuren đang hái thảo mộc. Cuộc trò chuyện ngắn nhưng quan trọng.  
- **Task:**
  - Nói chuyện với "người lạ" (Hakuren không đội mặt nạ)
  - Chia sẻ hoặc không chia sẻ về bản thân

**⚑ CHOICE POINT 4: Hakuren Hỏi Về Giấc Mơ**
> Hakuren: *"Ngươi có người quan trọng cần bảo vệ không? Đó là sức mạnh thật sự của ninja."*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] "Có — đó là lý do tôi chiến đấu"** | Đồng cảm với Hakuren | Trong boss fight: Hakuren do dự 1 giây trước khi tấn công (window để né dễ hơn) |
| **[B] "Tôi chiến đấu cho chính mình"** | Thẳng thắn, lạnh lùng | Không có hiệu ứng đặc biệt trong boss |
| **[C] "Tôi không cần lý do"** | Tỏ thái độ lạnh nhạt | Hakuren buồn, không có hiệu ứng — nhưng mở Reimei recruitment dialogue nếu rep đủ cao |

- **Reward (chỉ nếu [A]):** Buff "Người Quan Trọng" — +10% damage trong Arc 1 boss fight

---

### Q1-08 — Trận Cầu (Boss Fight Chính)
- **Level yêu cầu:** 12  
- **Location:** Cầu đang xây dựng, Tide Province  
- **Mô tả:** Gato dẫn quân tấn công. Zaborax và Hakuren cản đường. Trận quyết định Arc 1.  
- **Task:**
  - Phase 1: Chiến đấu với Hakuren — *Crystal Ice Mirrors dungeon*
  - Phase 2: Hỗ trợ Kakashi chống Zaborax (damage check)
  - Phase 3: Gato phản bội, dân làng nổi dậy — sự kiện scripted

---

#### BOSS: Hakuren

| Stat | Giá trị |
|------|---------|
| HP | `bossStats.bosses.hakuren.storyHP` — xem balance-config.json |
| Chakra | Băng (Ice Release — Kekkei Genkai) |
| Phase | 2 phase |

**Phase 1 — Gương Băng (60% HP đầu)**
- *Crystal Ice Mirrors:* Hakuren tạo 8 gương băng bao quanh người chơi — đứng trong vòng gương
- Hakuren di chuyển giữa các gương với tốc độ cao, tấn công từ mọi hướng
- **Cơ chế:** Phá 3 gương → Hakuren bị lộ 2 giây → window tấn công
- Skill: Ice Needle Barrage (AOE), Frozen Prison (root 3s), Mirror Dash (xuyên qua người chơi)

**Phase 2 — Hakuren Quyết Tử (40% HP còn lại)**
- Hakuren bỏ chiến lược, tấn công thẳng — nhanh hơn, mạnh hơn
- Xuất hiện mechanic mới: *Sacrifice* — Hakuren lao vào đỡ đòn cho Zaborax (heal Zaborax 6% maxHP Zaborax)
- Nếu player đã chọn [A] ở Q1-07: Hakuren có 20% chance không dùng Sacrifice

**Loot Hakuren:** 3,000 EXP, "Băng Châm" accessory (cosmetic), Hakuren's Mask (cosmetic)

---

#### BOSS: Zaborax Momochi

| Stat | Giá trị |
|------|---------|
| HP | `bossStats.bosses.zaborax.storyHP` — xem balance-config.json |
| Chakra | Nước |
| Giai đoạn | Sau khi Hakuren ngã |

- *Water Dragon Jutsu:* AOE lớn, 1.5s cast — có thể dodge
- *Hiding in Mist:* Tàng hình 10s, tấn công bất ngờ từ phía sau
- *Silent Killing:* Khi HP < 30%, tấn công liên tục không dừng

**Cơ chế đặc biệt:** Nếu Hakuren còn sống (player không kill Hakuren) → Zaborax nhận debuff -20% ATK vì phân tâm.

**Loot Zaborax:** 5,000 EXP, "Kubikiribocho Fragment" (material hiếm), Zaborax's Bandage (cosmetic)

---

**⚑ CHOICE POINT 5: Zaborax Hối Hận**
> Zaborax giết Gato, gục ngã bên cạnh Hakuren. Khoảnh khắc cuối arc.

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Để yên** | Nhìn Zaborax đi trong yên lặng | +10 Village Rep, Kakashi gật đầu tôn trọng |
| **[B] Nói lời cuối với Zaborax** | Bước đến nói chuyện | Unlock lore về Zaborax + Hakuren, +5 Insight point (currency mở dialogue tương lai) |
| **[C] Lấy Kubikiribocho** | Lấy kiếm trước khi Zaborax chết | +1 Unique Weapon fragment (chuỗi quest riêng), -15 Village Rep |

---

### Q1-09 — Cầu Hoàn Thành (Epilogue)
- **Level yêu cầu:** 14  
- **Location:** Cầu Tide Province (nay đặt tên "Cầu Naruko")  
- **Mô tả:** Dân làng ăn mừng. Đội trở về Konohara. Tazuru cảm ơn.  
- **Task:**
  - Nói chuyện với Inaro lần cuối
  - Nhận phần thưởng từ Tazuru
- **Reward:** 1,000 EXP, 500 Ryo, "Dải Ruy Băng Wave" (cosmetic), Arc 1 Completion Badge

**⚑ CHOICE POINT 6: Inaro Muốn Học Ninja**
> Inaro hỏi người chơi: *"Tôi có thể trở thành ninja không?"*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] "Được — nếu cậu quyết tâm"** | Khích lệ | Inaro NPC mở ở Arc 2 với dialogue đặc biệt |
| **[B] "Ninja không phải cho tất cả"** | Thực tế | Không có hậu quả ngay — Inaro tự cố gắng, xuất hiện Arc 3 |

---

## Hidden Quest — Kho Báu Trong Rừng

- **Trigger:** Tìm vị trí bí mật trong Q1-06 (cần Perception ≥ 15 hoặc có jutsu phát hiện)
- **Location:** Hang động phía Bắc rừng Tide Province
- **Mô tả:** Một nhóm ninja bỏ trốn khỏi Kirigakure đang trốn trong hang. Họ mang theo scroll jutsu đã bị cấm.
- **Task:**
  - Đánh bại 3 Kiri Rogue Ninja (combat)
  - Đọc scroll — chọn học hay đốt

**⚑ CHOICE POINT HQ: Scroll Jutsu Bị Cấm**

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Học jutsu** | Nhận "Phantom Mist Technique" (Jutsu Tier 2, hệ Nước) | -10 Village Rep (vi phạm quy định), unlock jutsu sớm |
| **[B] Nộp scroll về Konohara** | Báo cáo Kakashi | +15 Village Rep, nhận 200 Ryo thưởng |
| **[C] Đốt scroll** | Tiêu hủy | Không rep thay đổi, nhưng một NPC trong Arc 3 nhắc đến việc này |

- **Reward (chung):** 1,500 EXP, "Bản Đồ Kirigakure Cũ" (item mở quest Arc 3)

---

## Jutsu Unlock Sau Arc 1

Người chơi có thể học các jutsu sau khi hoàn thành arc (cần SP và đúng Chakra Affinity):

| Jutsu | Tier | Hệ | Cách mở |
|-------|------|----|---------|
| Fire Ball Jutsu | 1 | Lửa | Hoàn thành Q1-03 |
| Water Whip | 1 | Nước | Hoàn thành Q1-05 |
| Phantom Mist Technique | 2 | Nước | Hidden Quest [A] |
| Spirit Double Basic | 2 | Không hệ | Hoàn thành Q1-08 |

---

## Reputation Summary — Arc 1

| Hành động | Village Rep | Reimei Rep |
|-----------|-------------|--------------|
| Chọn chiến đấu Q1-03 | +15 | 0 |
| Bỏ nhiệm vụ Q1-03 | -20 | 0 |
| Can thiệp Q1-06 | +20 | 0 |
| Mặc cả với lính Q1-06 | -30 | +10 |
| Tin tưởng Hakuren Q1-05 | +5 | 0 |
| Lấy kiếm Zaborax Q1-08 | -15 | +5 |
| Học scroll cấm | -10 | +5 |
| Nộp scroll về Konohara | +15 | 0 |

**Kết thúc Arc 1 — Phân Nhánh Reputation:**
- Village ≥ +30: Kakashi viết báo cáo tốt → unlock quest Chunin Exam sớm hơn 1 level
- Village ≤ -20: Hokage gọi lên "nói chuyện" → thêm 1 quest phạt trước Arc 2
- Reimei ≥ +15: Một người bí ẩn để lại tin nhắn ở cổng làng (foreshadowing Arc 3)

---

## Ghi Chú Design

- **Balance lưu ý:** HP boss lấy từ `balance-config.json → bossStats.bosses.*.storyHP`. Phase transition tính theo %, không hardcode số tuyệt đối. Nếu cần tune độ khó thì sửa balance-config, không sửa file doc này.
- **Asset cần:** Bản đồ Tide Province, model cầu, music track "Sương Mù Kirigakure"

---

## Cross-Arc Flag — Tazuru Chết

**Trigger:** Player chọn [B] Rút Lui ở Q1-03 và không hoàn thành Q1-04b (không quay lại nhiệm vụ).

**Flag được set:** `tazuru_dead = true`

**Hậu quả tức thì (Arc 1):**
- Tazuru chết → cầu không được xây → Tide Province vẫn dưới quyền Gato
- Arc 1 kết thúc thiếu epilogue Q1-09 (không có scene ăn mừng)
- -30 Village Rep bổ sung

**Hậu quả Arc 4 — Optional Quest "Nợ Chưa Trả":**
- **Trigger:** Flag `tazuru_dead = true` + player đạt level 40 (bắt đầu Arc 4)
- **NPC giao:** Người dân Tide Province xuất hiện ở cổng Konohara, tìm đến player
- **Mô tả:** Gato đã chết (sự kiện canon) nhưng tay chân của hắn vẫn kiểm soát Tide Province sau khi không có ai giải phóng từ Arc 1. Người dân cầu xin giúp đỡ.
- **Đặc điểm:** Solo quest — không có Team 7, không có Kakashi hỗ trợ
- **Combat:** 3 boss nhỏ là tướng của Gato còn sót lại (level scale theo player)
- **Hoàn thành:**
  - Hoàn trả 50% Village Rep đã mất từ Arc 1
  - Cosmetic "Dải Ruy Băng Wave Muộn Màng" (màu xám — phân biệt với "Dải Ruy Băng Wave" bình thường màu xanh)
  - Ending slide Arc 4: Tide Province được giải phóng muộn, Inaro xây lại cầu
- **Không làm:**
  - Tide Province xuất hiện trong ending slide Arc 4 với kết thúc bi thảm
  - Inaro không xuất hiện trong bất kỳ arc nào nữa

**Lưu ý triển khai:** Quest này reuse map Tide Province từ Arc 1 — cần thêm state "post-Gato decay" (visual dirty/broken) nhưng không cần map mới hoàn toàn.
