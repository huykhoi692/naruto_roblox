# Arc 2: Chunin Exam — Game Design Document

**Level range:** 15–30  
**Phe ảnh hưởng:** Làng Lá (Village rep), Reimei (indirect)  
**NPC chính:** Kakashi, Naruko, Sazuki, Sakuri, Garrek, Rock Lee, Orokimaru, Hokage Đệ Tam, Anko, Ibiki  

---

## Tổng Quan

Arc lớn nhất về quy mô. Người chơi tham gia Kỳ Thi Chunin cùng các genin từ nhiều làng khác nhau. Ba giai đoạn thi kiểm tra 3 thứ khác nhau: trí tuệ, sinh tồn, chiến đấu. Orokimaru xuất hiện như mối đe dọa ngầm xuyên suốt. Kết thúc bằng cuộc tấn công vào Konohara — người chơi phải chọn ưu tiên ai.

**Chủ đề cốt lõi:** Tham vọng và giới hạn bản thân. Người chơi lần đầu đối mặt với những ninja mạnh hơn nhiều — Garrek, Orokimaru — và phải quyết định: phấn đấu vượt lên hay chấp nhận thất bại có kiểm soát.

---

## Giai Đoạn 1 — Bài Thi Viết

### Q2-01 — Đăng Ký Thi Chunin
- **Level yêu cầu:** 15  
- **NPC giao:** Kakashi (Training Ground 7)  
- **Location:** Konohara — Tòa Nhà Hokage, Phòng Đăng Ký  
- **Mô tả:** Kakashi đề cử Team. Người chơi gặp các genin từ làng khác lần đầu tiên — Sand (Garrek, Temurai, Kankuro), Sound (Dosu, Zaku, Kin).  
- **Task:**
  - Nộp đơn đăng ký (interact NPC)
  - Quan sát đối thủ trong sảnh chờ — 3 NPC có thể nói chuyện để lấy intel
  - Gặp Rock Lee (unlock dialogue branch dài)
- **Reward:** 500 EXP

**⚑ CHOICE POINT 1: Rock Lee Thách Đấu**
> Rock Lee thách player đấu thử trước khi thi. "Tôi muốn biết sức mạnh của ngươi."

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Chấp nhận** | Đấu Lee (không thể thắng — scripted loss) | Lee tôn trọng player, xuất hiện hỗ trợ trong Q2-07; +5 Village Rep |
| **[B] Từ chối lịch sự** | Không đấu | Lee trung lập, không có hỗ trợ sau này |
| **[C] Từ chối kiêu ngạo** | Bỏ qua Lee | Lee tức giận, trong Q2-07 Lee không cứu player khi bị dồn góc |

---

### Q2-02 — Phòng Thi (Ibiki's Test)
- **Level yêu cầu:** 15  
- **NPC:** Ibiki Morino (Giám thị)  
- **Location:** Phòng thi lớn, Tầng 3 Tòa Nhà Hokage  
- **Mô tả:** Bài thi viết 10 câu hỏi cực khó — thực chất là bài test tâm lý và khả năng thu thập thông tin.  

**Cơ chế mini-game:**
- 10 câu hỏi ninja học thuật (hỏi về jutsu, địa lý, lịch sử làng)
- Player có 3 lần "nhìn bài" (cheat) — mỗi lần dùng tốn 1 điểm Reputation nhỏ (-2 Village Rep)
- Trả lời sai 3 câu → bị loại khỏi đội
- **Câu 11 — Câu hỏi tử thần:** Ibiki hỏi toàn đội: *"Nếu bỏ cuộc bây giờ, các ngươi không bao giờ được thi lại."*

**⚑ CHOICE POINT 2: Câu Hỏi Tử Thần**

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Ở lại** | Tiếp tục thi | Pass Giai Đoạn 1, vào rừng |
| **[B] Rút lui** | Bỏ cuộc | Arc 2 kết thúc sớm → "Đường tắt": nhận quest phụ riêng (không thi Chunin, làm nhiệm vụ bí mật cho ANBU trong khi kỳ thi diễn ra) |

*Lưu ý: Chọn [B] mở nhánh story đặc biệt — player không vào rừng mà làm undercover. Nhánh này có rep riêng và boss riêng (xem Appendix A).*

- **Reward (nếu pass):** 800 EXP, "Huy Hiệu Thi Chunin" (required item để vào Giai Đoạn 2)

---

## Giai Đoạn 2 — Rừng Chết

### Q2-03 — Vào Rừng Nguy Hiểm
- **Level yêu cầu:** 16  
- **NPC:** Anko Mitarashi (Giám thị Giai Đoạn 2)  
- **Location:** Cổng Rừng Chết — Khu Luyện Tập Số 44  
- **Mô tả:** Mỗi đội nhận 1 cuộn giấy (Thiên hoặc Địa), phải thu thập đủ cả hai trong 5 ngày. Rừng chứa nhiều mối nguy: thú dữ, bẫy, đội khác.  
- **Task:**
  - Nhận cuộn giấy (random: Thiên hoặc Địa)
  - Vào rừng — bản đồ mở (open exploration)
- **Reward:** Unlock map Rừng Chết

**Cơ chế Rừng Chết:**
- Timer 5 ngày thực tế (= 30 phút game time)
- Đội khác có thể tấn công player để cướp cuộn giấy
- 3 khu vực nguy hiểm: Khu A (thú dữ), Khu B (bẫy cơ học), Khu C (đội Sound)
- Tower ở trung tâm — nộp đủ 2 cuộn → pass

---

### Q2-04 — Đụng Độ Trong Rừng
- **Level yêu cầu:** 17  
- **Location:** Khu B — Rừng Chết  
- **Mô tả:** Đội Sound (Dosu, Zaku, Kin) phục kích — thực ra là đang thực hiện mệnh lệnh của Orokimaru để thử Sazuki.  
- **Task:**
  - Chiến đấu với Sound Three (Dosu, Zaku, Kin)
  - Sống sót cho đến khi Sazuki "thức tỉnh" (scripted event)

**Boss nhỏ: Sound Three**

| Kẻ địch | HP | Skill đặc biệt |
|---------|-----|----------------|
| Zaku | 800 | Air Cutter (AOE đường thẳng), Slicing Sound Wave (knockback) |
| Kin | 600 | Illusion Bells (confuse 3s), String Trap (root) |
| Dosu | 1,000 | Melody Arm (vibration damage xuyên guard), Sonic Punch |

**Cơ chế:** Kin ưu tiên debuff → Zaku AOE → Dosu finish. Player nên kill Kin trước.

**⚑ CHOICE POINT 3: Sazuki Nguyền Ấn Bùa**
> Orokimaru xuất hiện, cắn Sazuki, để lại Nguyền Ấn. Sazuki bán kiểm soát, tấn công Sound Three tàn bạo.

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Kéo Sazuki lại** | Cố ngăn Sazuki dùng Nguyền Ấn | Sazuki tỉnh lại, -30% damage output trận này nhưng Sazuki biết ơn; +10 Village Rep |
| **[B] Để Sazuki chiến đấu** | Không can thiệp | Sound Three bị đánh bại nhanh hơn, nhưng Sazuki mất kiểm soát hoàn toàn — cần dùng thêm lực để ghìm hắn sau; -5 Village Rep |
| **[C] Lợi dụng lúc hỗn loạn** | Cướp cuộn giấy của Sound Three trong lúc Sazuki đang điên | Lấy được cuộn Địa của Sound Three, nhưng Sazuki không tin tưởng player từ đây; -15 Village Rep, +5 Reimei Rep |

- **Reward:** 1,500 EXP, Sound Three Loot (ngẫu nhiên: Antidote, Senbon, Trap Kit)

---

### Q2-05 — Tìm Cuộn Giấy Còn Lại
- **Level yêu cầu:** 18  
- **Location:** Khu A & C — Rừng Chết  
- **Mô tả:** Cần tìm cuộn giấy còn thiếu. Có nhiều cách: chiến đấu, đánh đổi, tìm cuộn bị bỏ lại.  

**⚑ CHOICE POINT 4: Đội Sand Đề Nghị Liên Minh**
> Temurai tiếp cận: *"Chúng ta đổi thông tin — ngươi biết vị trí cuộn Thiên, ta biết vị trí đội yếu hơn."*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Chấp nhận liên minh** | Hợp tác với đội Sand | Lấy được cuộn giấy dễ hơn; Temurai/Kankuro trở nên trung lập (không tấn công) — Garrek vẫn nguy hiểm |
| **[B] Từ chối, tự làm** | Đi tìm độc lập | Khó hơn nhưng nhận thêm 20% EXP từ các trận chiến tự giải quyết |
| **[C] Nhận thông tin rồi phản bội** | Lấy intel của Sand rồi tấn công họ | Cướp cuộn Sand nếu thắng, nhưng Garrek ngay lập tức xuất hiện trả thù; -20 Village Rep |

- **Reward:** 1,200 EXP khi nộp đủ 2 cuộn, pass vào Giai Đoạn 3

---

### Q2-06 — Đêm Cuối Trong Rừng (Hidden Quest Trigger)
- **Level yêu cầu:** 19  
- **Location:** Khu vực an toàn trung tâm rừng  
- **Mô tả:** Đêm cuối trước khi rừng đóng. Một shinobi bị thương nặng kêu cứu — bẫy hay thật?  

**⚑ CHOICE POINT 5: Ninja Bị Thương**

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Cứu giúp** | Tiếp cận, chữa trị | Thật — ninja này là genin làng Mưa, cảm ơn bằng scroll nhỏ (+1 Jutsu Point); +10 Village Rep |
| **[B] Bỏ qua** | Tiếp tục | Ninja chết — không có hậu quả trực tiếp, nhưng NPC này xuất hiện trong Arc 3 nếu sống |
| **[C] Kiểm tra bẫy trước** | Perception check (≥20) | Phát hiện bẫy của đội khác — lật bẫy lại, nhận thêm EXP; neutral rep |

---

## Giai Đoạn 3 — Đấu Đài

### Q2-07 — Vòng Loại Đấu Đài (Preliminary Matches)
- **Level yêu cầu:** 20  
- **Location:** Đấu trường trong tòa nhà Chunin  
- **Mô tả:** Vòng đấu đơn loại trực tiếp — quá nhiều người pass Giai Đoạn 2, phải giảm xuống 10. Player được xếp ngẫu nhiên vào 1 trong 3 trận.  

**Trận của Player — 1 trong 3 (random seed theo Chakra Affinity):**

| Affinity chính | Đối thủ | Cơ chế đặc biệt |
|---------------|---------|-----------------|
| Lửa / Gió | Zaku Abumi (Sound) | Né AOE Air Cutter |
| Nước / Đất | Kin Tsuchi (Sound) | Phá illusion bell |
| Sét | Misumi Tsurugi (Konohara) | Counter grab-attack |

**⚑ CHOICE POINT 6: Rock Lee vs Garrek**
> Player được xem trận Lee vs Garrek. Lee dùng 8 Cổng. Garrek nghiền nát chân Lee.

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Chạy đến đỡ Lee** | Cố gắng can thiệp (fail — Garrek đã xong) | Lee biết player cố gắng — unlock dialogue Arc 3; +5 Village Rep |
| **[B] Đứng nhìn, không làm gì** | Không phản ứng | Neutral — không có gì thay đổi |
| **[C] Cổ vũ Garrek** | Thể hiện tán thưởng sức mạnh | -10 Village Rep; Garrek nhận ra player — trong boss fight Garrek có 1 dialogue đặc biệt |

- **Reward:** 2,000 EXP, "Huy Chương Sơ Vòng" (cosmetic)

---

### Q2-08 — Tháng Chuẩn Bị
- **Level yêu cầu:** 21  
- **Location:** Konohara — tự do khám phá  
- **Mô tả:** 1 tháng chuẩn bị trước vòng chung kết. Player có thể luyện tập, học jutsu mới, hoặc điều tra Orokimaru.  
- **Task:**
  - Chọn 1 trong 3 hướng luyện tập (ảnh hưởng buff nhỏ vào vòng chính):
    - Luyện Chakra Control: +10% Chakra pool
    - Luyện Taijutsu: +10% Physical damage
    - Luyện Ninjutsu mới: Unlock 1 jutsu tier thấp hơn affinity chính

**Optional — Điều Tra Orokimaru:**
- Nhận quest từ ANBU ẩn danh (cần Village Rep ≥ +30)
- Thu thập 3 manh mối về hoạt động bí ẩn trong làng
- Reward: +500 EXP, foreshadowing lore về Orokimaru, +15 Village Rep

---

### Q2-09 — Vòng Chung Kết: Trận Player
- **Level yêu cầu:** 25  
- **Location:** Đấu trường lớn ngoài trời — trước dân chúng  
- **Mô tả:** Vòng chung kết Chunin diễn ra công khai. Player đấu với đối thủ được bốc thăm.  

**Đối thủ vòng chung kết (dynamic — không phải Garrek ở đây):**
- Nếu Village Rep ≥ +20: Đấu với Shino Aburame (Konohara) — khó nhưng fair
- Nếu Village Rep < +20 hoặc Reimei Rep > 0: Đấu với Dosu (Sound) — Dosu đã được Orokimaru buff

**Boss: Shino Aburame**

| Stat | Giá trị |
|------|---------|
| HP | 3,500 |
| Chakra | Đất |
| Cơ chế | Kikaichū Bug — drain Chakra liên tục khi tiếp xúc |

- *Bug Clone:* Clone hút chakra thay vì damage
- *Insect Sphere:* Bao vây player, cần AOE jutsu phá vỡ
- *Bug Barrier:* Block đòn tấn công thường — phải dùng chakra-infused attack

**Boss: Dosu Kinuta** *(nếu rep thấp)*

| Stat | Giá trị |
|------|---------|
| HP | 3,000 |
| Chakra | Âm thanh (Sound) |
| Cơ chế | Melody Arm — ignore guard, damage tăng khi HP thấp |

**⚑ CHOICE POINT 7: Kết Quả Trận Đấu**

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Thắng** | Đánh bại đối thủ | Pass Chunin Exam; +20 Village Rep; unlock rank Chunin |
| **[B] Thua có kiểm soát** | Để thua nhưng chiến đấu đến cùng | Không được thăng Chunin nhưng được khen ngợi; +5 Village Rep; vẫn unlock Q2-10 |
| **[C] Nhường** | Bỏ cuộc giữa trận | -10 Village Rep; không thăng hạng; Orokimaru chú ý đến sự "khôn ngoan" này — +5 Reimei Rep |

---

### Q2-10 — Làng Bị Tấn Công
- **Level yêu cầu:** 27  
- **Location:** Đấu trường, đường phố Konohara  
- **Mô tả:** Giữa vòng chung kết, Orokimaru và Dune Village tấn công Konohara. Genjutsu ngủ tràn qua. Hokage Đệ Tam đối đầu Orokimaru.  
- **Task:**
  - Phá genjutsu ngủ (skill check — cần ≥ 10 Chakra Control hoặc dùng item)
  - Làm rõ: bảo vệ ai trước?

**⚑ CHOICE POINT 8 — QUAN TRỌNG NHẤT ARC 2: Ưu Tiên Ai?**
> Naruko đang đuổi theo Garrek. Dân thường đang bị tấn công ở khu chợ. Hokage cần hỗ trợ tại đấu trường. Chỉ có thể chọn một.

| Lựa chọn | Hành động | Hậu quả ngắn hạn | Hậu quả dài hạn |
|-----------|-----------|-----------------|----------------|
| **[A] Theo Naruko chống Garrek** | Hỗ trợ Naruko trong boss fight Garrek | Cùng Naruko chiến đấu — Garrek bị đánh bại nhanh hơn | +15 Village Rep; Naruko nhớ đến player trong Arc 3 |
| **[B] Bảo vệ dân thường** | Đánh đuổi Sound ninja khỏi khu chợ | Cứu ~20 NPC; không tham chiến Garrek | +25 Village Rep; unlock 3 NPC quest trong Arc 3 |
| **[C] Hỗ trợ Hokage** | Đánh Sand ninja xung quanh đấu trường | Hokage sống lâu hơn (nhưng vẫn hi sinh theo lore) | +10 Village Rep; Hokage để lại di thư cho player — unlock item đặc biệt |
| **[D] Không làm gì — trốn** | Ẩn náu chờ qua | An toàn cho bản thân | -30 Village Rep; +15 Reimei Rep; một NPC cụ thể chết |

---

### Q2-11 — Boss: Garrek

*(Chỉ nếu chọn [A] hoặc [B] ở Q2-10 — nếu [B] thì vào late phase)*

- **Level yêu cầu:** 28  
- **Location:** Rừng ngoài Konohara  

#### BOSS: Garrek của Cát

| Stat | Giá trị |
|------|---------|
| HP | 6,000 |
| Chakra | Đất + Cát (Sand) |
| Phase | 3 phase |

**Phase 1 — Garrek Bình Thường (6,000 → 4,000 HP)**
- *Sand Shield:* Auto-block đòn thường — cần jutsu nhanh hoặc Lightning (Sét xuyên cát)
- *Sand Coffin:* Root 4s, nếu không thoát → Sand Burial (instant kill nếu HP < 30%)
- *Sand Storm:* AOE quanh Garrek, giảm tầm nhìn

**Phase 2 — Một Vĩ Thức (4,000 → 2,000 HP)**
- Garrek bắt đầu partial transformation — cánh tay cát khổng lồ
- *Sand Tsunami:* AOE toàn màn hình, cần dodge timing chính xác
- *Shukaku Arm:* Grab — nếu bị bắt mất 40% HP tức thì
- Naruko hỗ trợ (nếu chọn [A]): Naruko dùng Rashougan tạo opening 3s mỗi 45s

**Phase 3 — Shukaku Bán Thức (2,000 → 0 HP)**
- Garrek ngủ, Shukaku chiếm quyền điều khiển
- *Shukaku Roar:* Knockback + stun 2s
- *Desert Avalanche:* Massive AOE — cần dùng địa hình để né (leo cây/leo đá)
- **Cơ chế kết thúc:** Naruko dùng Summoning Jutsu gọi Gamabunta → player cần deal đủ 500 damage để đánh thức Garrek trong lúc Shukaku bị phân tâm

**Loot Garrek:** 8,000 EXP, "Cát Từ Bình Của Garrek" (material đặc biệt, dùng cho jutsu Sand-type sau này), "Huy Hiệu Chunin Exam Finisher"

---

## Kết Thúc Arc 2

### Q2-12 — Sau Trận (Epilogue)
- **Level yêu cầu:** 29  
- **Location:** Konohara — bệnh viện, đường phố  
- **Mô tả:** Hokage Đệ Tam hi sinh. Làng bắt đầu tái thiết. Kết quả Chunin Exam được công bố.  
- **Task:**
  - Thăm Rock Lee ở bệnh viện
  - Nghe kết quả chính thức

**⚑ CHOICE POINT 9: Garrek Tìm Đến Player**
> Garrek, một mình, tìm đến player sau tất cả. Không thù địch — hắn muốn hiểu tại sao player chiến đấu.

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] "Tôi chiến đấu để bảo vệ người khác"** | Đồng cảm | Garrek thay đổi — NPC Garrek trở nên trung lập trong Arc 3+; +10 Village Rep |
| **[B] "Tôi chiến đấu để tồn tại"** | Thẳng thắn | Garrek tôn trọng sự thành thật; neutral |
| **[C] Không nói gì — đi bộ** | Im lặng | Garrek bỏ đi — nhưng có 1 điều kiện ẩn: nếu Reimei Rep ≥ +20, hắn để lại tin nhắn ngắn cho Reimei về player |

- **Reward:** 2,000 EXP, Arc 2 Completion Badge

---

## Appendix A — Nhánh ANBU (Rút Lui Ở Q2-02)

*Dành cho player chọn [B] Rút lui tại Câu hỏi tử thần của Ibiki.*

Player không vào rừng. Thay vào đó, một ANBU tiếp cận ngay sau khi rút lui:

**Quest đặc biệt: "Mắt Trong Bóng Tối"**
- Nhiệm vụ: Theo dõi hoạt động của Sound ninja trong Konohara trong khi kỳ thi diễn ra
- 5 nhiệm vụ nhỏ: theo dõi, thu thập, báo cáo
- Kết thúc: Phát hiện 1 kế hoạch nhỏ của Orokimaru → báo cáo cứu được 1 ANBU
- **Reward:** 4,000 EXP (tương đương arc), +20 Village Rep, "Dấu Hiệu ANBU" (cosmetic hiếm)
- **Trade-off:** Không có Chunin rank, không chiến đấu Garrek — bỏ lỡ loot và dialogue chain liên quan

---

## Hidden Quest — Scroll Tuyệt Mật Của Orokimaru

- **Trigger:** Hoàn thành "Điều Tra Orokimaru" trong Q2-08 + Village Rep ≥ +30
- **Location:** Địa điểm bí mật dưới Tòa Nhà Hokage
- **Mô tả:** Manh mối dẫn đến phòng thí nghiệm bỏ hoang của Orokimaru. Bên trong có tài liệu và 1 thí nghiệm thất bại còn sống.
- **Combat:** Boss phụ — "Experiment X" (sinh vật lai, HP 2,000, không có jutsu cụ thể — chỉ melee)
- **Reward:** 3,000 EXP, "Scroll Thực Nghiệm" (mở 1 jutsu forbidden Tier 2 nhưng -20 Village Rep nếu học), lore về Orokimaru's past

---

## Jutsu Unlock Sau Arc 2

| Jutsu | Tier | Hệ | Cách mở |
|-------|------|----|---------|
| Sand Manipulation (basic) | 2 | Đất | Loot từ Garrek |
| Insect Clone | 2 | Đất | Đánh bại Shino |
| Sound Wave Jutsu | 2 | Không hệ | Loot từ Dosu |
| Summoning Jutsu (Toad) | 3 | Không hệ | Quest Naruko trong Q2-10 (chỉ nếu chọn [A]) |
| Forbidden Experiment Jutsu | 2 | Lửa | Hidden Quest (mất rep) |
| Eight Trigrams: Basic | 3 | Không hệ | Gặp Hinata trong Q2-08 (optional dialogue) |

---

## Reputation Summary — Arc 2

| Hành động | Village Rep | Reimei Rep |
|-----------|-------------|--------------|
| Chấp nhận đấu Lee Q2-01 [A] | +5 | 0 |
| Từ chối kiêu ngạo Q2-01 [C] | 0 | +3 |
| Nhìn bài Ibiki Q2-02 | -2/lần | 0 |
| Kéo Sazuki lại Q2-04 [A] | +10 | 0 |
| Lợi dụng Sazuki Q2-04 [C] | -15 | +5 |
| Phản bội Sand Q2-05 [C] | -20 | 0 |
| Cổ vũ Garrek Q2-07 [C] | -10 | 0 |
| Nhường trận Q2-09 [C] | -10 | +5 |
| Bảo vệ dân thường Q2-10 [B] | +25 | 0 |
| Trốn tránh Q2-10 [D] | -30 | +15 |
| Đồng cảm Garrek Q2-12 [A] | +10 | 0 |

**Kết thúc Arc 2 — Phân Nhánh Reputation:**
- Village ≥ +50 tổng cộng (2 arc): Được thăng Chunin dù thua trận — Hokage công nhận trước khi hi sinh
- Village ≤ -30 tổng cộng: Bị gọi lên thẩm vấn sau Arc 2, thêm quest chuộc lỗi trước Arc 3
- Reimei ≥ +25 tổng cộng: Itachi Uchira xuất hiện lần đầu ở cổng làng — đặt nền Arc 3

---

## Ghi Chú Design

- **Cơ chế thời gian Rừng Chết (30 phút):** Cần test xem có phù hợp không — nếu player explore nhiều có thể không đủ thời gian; đề xuất add timer pause khi ở trong safe zone
- **Boss Garrek Phase 3:** Shukaku mechanic phức tạp — cần animation riêng cho Gamabunta; đây là asset tốn kém nhất arc này
- **Nhánh ANBU:** Chưa có số quest chính xác — 5 nhiệm vụ nhỏ là estimate, cần balance EXP so với arc chính
- **Balance Shino vs Dosu:** Chưa cân bằng sức mạnh 2 boss này — sẽ điều chỉnh sau khi có combat system hoàn chỉnh

---

## Quyết Định Đã Chốt

### Chunin Rank → Flavor & Difficulty, Không Phải Gate
Rank không mở/khóa quest Arc 3. Ảnh hưởng duy nhất là cách NPC đối xử và độ khó tiếp cận thông tin:
- **Chunin:** NPCs tin tưởng hơn, nhận bản đồ từ ANBU khi vào Echo Stronghold, được tham gia họp chiến lược
- **Genin:** Bị hoài nghi, phải tự tìm thông tin — nhưng có thể tiếp cận NPC nhỏ mà Chunin bỏ lỡ, phát hiện route tắt trong Echo Stronghold mà ANBU không biết
- **Nguyên tắc:** Hai con đường khác nhau, cùng đích đến — không có nhánh nào bị thiệt thòi về story

### Cách Lên Chunin (2 con đường)
1. Thắng trận Q2-09 (Choice Point 7 — [A])
2. Thua trận nhưng Village Rep ≥ +50 tổng 2 arc → Hokage công nhận trước khi hi sinh
