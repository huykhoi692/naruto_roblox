# Arc 3: Sazuki Rời Làng — Game Design Document

**Level range:** 28–40  
**Phe ảnh hưởng:** Làng Lá (Village rep), Reimei (rep mạnh hơn Arc trước)  
**NPC chính:** Sazuki, Naruko, Kakashi, Shikamura, Sound Four (Tayuya, Kidomaru, Sakon/Ukon, Jirobo), Orokimaru  

---

## Tổng Quan

Arc tối nhất về mặt cảm xúc. Sazuki rời làng theo Orokimaru — player là một trong những người được cử đi đuổi theo. Khác Arc 1 và 2, đây không phải nhiệm vụ được giao từ trên xuống — đây là lựa chọn cá nhân. Cảm giác cấp bách, không có backup, và câu hỏi cốt lõi: *trung thành với làng hay trung thành với bạn đồng đội?*

**Chunin rank ảnh hưởng:** Như đã chốt — không ảnh hưởng quest access, chỉ ảnh hưởng NPC dialogue và cách tiếp cận thông tin. Chi tiết theo từng quest bên dưới.

---

## Danh Sách Quest

### Q3-01 — Tin Xấu Lúc Bình Minh
- **Level yêu cầu:** 28  
- **NPC giao:** Shikamura (Cổng Konohara)  
- **Location:** Konohara — Cổng phía Nam  
- **Mô tả:** Sáng sớm, Shikamura tập hợp đội truy đuổi. Sazuki đã rời làng đêm qua. Naruko quyết tâm đuổi theo bằng mọi giá.  
- **Task:**
  - Nghe brief từ Shikamura (thông tin về Sound Four)
  - Chọn tham gia đội truy đuổi

**Chunin:** Shikamura chia sẻ bản đồ lộ trình dự đoán của Sazuki (ANBU intel) — biết trước vị trí Sound Four  
**Genin:** Không có bản đồ — phải track theo dấu vết trong rừng (Perception check theo từng checkpoint)

**⚑ CHOICE POINT 1: Lý Do Đi Theo**
> Shikamura hỏi player: *"Ngươi đi vì lệnh làng hay vì Sazuki?"*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] "Vì làng — Sazuki là tài sản cần thu hồi"** | Lạnh lùng, chuyên nghiệp | +10 Village Rep; Shikamura tôn trọng; Sazuki phản ứng lạnh khi gặp lại |
| **[B] "Vì Sazuki — hắn là đồng đội"** | Cảm xúc, trung thực | Neutral rep; Naruko tin tưởng player hơn; Sazuki có 1 dialogue đặc biệt |
| **[C] "Tôi có lý do riêng"** | Mơ hồ | Nếu Reimei Rep ≥ +20: Shikamura nhìn nghi ngờ — bắt đầu theo dõi player ngầm từ đây |

- **Reward:** 500 EXP, unlock map Rừng phía Nam

---

### Q3-02 — Truy Vết Qua Rừng
- **Level yêu cầu:** 28  
- **Location:** Rừng phía Nam Konohara → Biên Giới  
- **Mô tả:** Đội chạy đuổi theo. Sound Four đã chia nhau chặn đường — mỗi thành viên Sound Four chặn 1 nhóm nhỏ.  
- **Task:**
  - Di chuyển qua 3 checkpoint (combat + exploration)
  - Gặp Akamaru và Kiba — nhận thông tin thêm về hướng đi của Sazuki

**Chunin:** Bỏ qua được checkpoint 1 nhờ bản đồ ANBU — tiết kiệm thời gian, vào thẳng combat  
**Genin:** Phải tìm route tắt qua rừng (Perception ≥ 20 hoặc talk với NPC ẩn) — nếu tìm được thì phát hiện lối đi bí mật mà ANBU không biết, dẫn thẳng đến Q3-04 bỏ qua Q3-03

- **Reward:** 800 EXP

---

### Q3-03 — Sound Four: Jirobo
- **Level yêu cầu:** 29  
- **NPC:** Jirobo (Sound Four — Earth Release)  
- **Location:** Rừng phía Nam, Checkpoint 1  
- **Mô tả:** Jirobo chặn đường, bẫy cả đội trong Earth Dome. Chỉ có player và 1 đồng đội ở lại đánh trong khi người khác phá dome từ ngoài.  

#### BOSS: Jirobo

| Stat | Giá trị |
|------|---------|
| HP | 4,500 |
| Chakra | Đất |
| Cơ chế đặc biệt | Earth Dome Prison — arena đóng kín |

**Phase 1 — Seal Chakra (4,500 → 2,500 HP)**
- *Earth Dome Prison:* Jirobo hút chakra của player qua dome — mỗi 10s mất 5% chakra tối đa
- *Rock Fist:* Đòn melee mạnh, knockback lớn
- *Earth Spear:* Toàn thân cứng như đá — giảm 80% damage nhận vào, kéo dài 8s

**Phase 2 — Cấp 2 Nguyền Ấn (2,500 → 0 HP)**
- Jirobo to lớn hơn, mạnh hơn — mất khả năng Earth Spear nhưng damage tăng 40%
- *Boulder Throw:* AOE rộng, cần dodge về phía sau
- *Seismic Slam:* Đập tay xuống đất — AOE xung quanh Jirobo, cần nhảy lên tránh

**Cơ chế đặc biệt:** Dome sẽ vỡ sau khi Jirobo chết — nếu player hết chakra trước khi kill, bị debuff -30% attack trong Q3-04

- **Loot:** 3,000 EXP, "Đá Nguyền Ấn" (material), Jirobo's Beads (cosmetic)

---

### Q3-04 — Sound Four: Tayuya
- **Level yêu cầu:** 31  
- **NPC:** Tayuya (Sound Four — Genjutsu/Sound)  
- **Location:** Đèo núi phía Nam  
- **Mô tả:** Tayuya chặn đường bằng ảo thuật âm thanh — đây là trận khó nhất về mặt cơ chế.  

#### BOSS: Tayuya

| Stat | Giá trị |
|------|---------|
| HP | 4,000 |
| Chakra | Âm thanh + Genjutsu |
| Cơ chế đặc biệt | Flute Genjutsu — ảo giác liên tục |

**Phase 1 — Flute Control (4,000 → 2,000 HP)**
- *Demonic Flute:* Mỗi 15s Tayuya chơi nhạc — player thấy màn hình méo, controls đảo ngược 5s
- *Three Doki Summon:* Gọi 3 quỷ nhỏ (HP 500 mỗi con) — cần kill trước khi tấn công Tayuya
- *Sound Barrier:* Tayuya bất khả xâm phạm khi đang chơi đàn — phải ngắt bằng projectile

**Phase 2 — Cấp 2 Nguyền Ấn (2,000 → 0 HP)**
- *Celestial Flute:* Genjutsu mạnh hơn — controls đảo ngược 10s, thêm màn hình blur
- *Doki Fusion:* 3 quỷ hợp nhất thành 1 (HP 2,000) — ưu tiên kill fusion này trước
- **Phá genjutsu:** Dùng Kai (release jutsu) hoặc tự gây damage bản thân 10% HP

**⚑ CHOICE POINT 2: Temurai Xuất Hiện**
> Temurai (Sand) đột ngột xuất hiện, dùng fan wind để đánh Tayuya. "Chúng ta đang trả ơn Konohara."

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Để Temurai kết liễu** | Nhường cho Temurai | Tayuya chết nhanh; player mất loot nhưng tiết kiệm chakra cho Q3-06 |
| **[B] Xin Temurai chờ — tự kết liễu** | Cố tự finish | Lấy toàn bộ loot Tayuya; mất thêm 20% HP |
| **[C] Cùng đánh** | Hợp sức | Split loot, finish nhanh hơn một chút, Temurai +thân thiện |

- **Loot (nếu tự kill):** 3,500 EXP, "Sáo Nguyền Ấn" (cosmetic hiếm), Tayuya's Music Scroll

---

### Q3-05 — Sound Four: Kidomaru
- **Level yêu cầu:** 33  
- **NPC:** Kidomaru (Sound Four — Spider Web)  
- **Location:** Vách đá dọc theo sông  
- **Mô tả:** Kidomaru ưa bắn từ xa — player không thể tiếp cận trực tiếp. Neji đang chiến đấu ở đây.  

#### BOSS: Kidomaru

| Stat | Giá trị |
|------|---------|
| HP | 5,000 |
| Chakra | Không hệ (Spider/Web) |
| Cơ chế đặc biệt | Luôn ở xa — range combat bắt buộc |

**Phase 1 — Web Sniper (5,000 → 2,500 HP)**
- *Spider Web:* Phủ toàn bộ arena — di chuyển chậm 40% khi dẫm vào
- *Bone Arrow:* Tấn công tầm xa chính xác cao, xuyên qua obstacle
- *Sticky Gold:* Tạo hardpoint để leo lên — Kidomaru ở trên cao, khó tấn công
- **Cơ chế:** Cần dùng range jutsu hoặc leo lên cao mới đánh được

**Phase 2 — Eight Trigrams Spider (2,500 → 0 HP)**
- Kidomaru xuống gần hơn — melee hybrid
- *Bone Drill:* Spinning attack, xuyên block
- *Web Cocoon:* Bọc player trong tơ — cần spam button thoát trong 3s hoặc mất 30% HP

**Neji hỗ trợ:** Neji blind một mắt Kidomaru — Bone Arrow accuracy giảm 50% từ lúc đó

- **Loot:** 4,000 EXP, "Tơ Nhện Vàng" (material dùng cho trap jutsu), Kidomaru's Spider Badge

---

### Q3-06 — Sound Four: Sakon & Ukon
- **Level yêu cầu:** 35  
- **NPC:** Sakon / Ukon (Sound Four — Body Fusion)  
- **Location:** Khu vực hoang vu, gần biên giới Sound  
- **Mô tả:** Hai anh em trong cùng một cơ thể — boss khó nhất trong Sound Four.  

#### BOSS: Sakon & Ukon

| Stat | Giá trị |
|------|---------|
| HP | 6,000 (shared) |
| Chakra | Không hệ (Body Decomposition) |
| Cơ chế đặc biệt | Ukon ký sinh — damage player từ bên trong |

**Phase 1 — Sakon Solo (6,000 → 3,500 HP)**
- *Rapid Assault:* Combo 5 đòn cực nhanh — cần parry timing chính xác
- *Ukon Emerge:* Ukon xuất hiện từ lưng Sakon — tấn công từ phía sau đồng thời
- *Body Regeneration:* Tự heal 200 HP mỗi 20s

**Phase 2 — Fusion Mode (3,500 → 0 HP)**
- *Cell Decomposition:* Ukon cố ký sinh vào player — nếu dính, player mất 3% HP/s trong 10s
- *Twin Assault:* Hai người tách ra độc lập — cần chú ý cả hai hướng
- *Recombine:* Hợp nhất lại, heal 500 HP — phải interrupt bằng cách tấn công cả hai cùng lúc

**⚑ CHOICE POINT 3: Kiba Bị Hạ**
> Kiba ngã, Sakon chuẩn bị kết liễu.

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Cứu Kiba** | Nhảy vào đỡ đòn | Kiba sống — hỗ trợ nhỏ cuối trận (+200 damage); player mất 20% HP |
| **[B] Tiếp tục đánh boss** | Ưu tiên boss | Kiba bị thương nặng nhưng không chết (scripted); không mất HP; Kiba lạnh nhạt với player sau này |

- **Loot:** 5,000 EXP, "Mảnh Nguyền Ấn Kép" (material hiếm), Sakon's Ring (cosmetic)

---

### Q3-07 — Cổng Echo Stronghold
- **Level yêu cầu:** 36  
- **Location:** Biên giới Echo Stronghold  
- **Mô tả:** Player đến nơi — nhưng Sazuki đã vào bên trong. Cần thâm nhập mà không bị phát hiện hoặc đột phá thẳng vào.  

**⚑ CHOICE POINT 4: Vào Như Thế Nào?**

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Lén vào (Stealth)** | Dùng Henge hoặc đường tắt | Không bị alarm, tiếp cận Sazuki mà không bị cản; cần Chakra Control ≥ 20 hoặc Genin route tắt |
| **[B] Đột phá thẳng vào** | Chiến đấu qua cổng | Alarm toàn làng — thêm 2 wave enemy trước khi gặp Sazuki; nhưng không cần skill check |
| **[C] Giả vờ đầu hàng** | Để Sound ninja bắt, đưa vào trong | Vào được mà không tốn chakra; nhưng bị giam 10 phút game — mất một phần buff trước boss fight |

**Chunin:** Có thêm option [A+] — dùng bản đồ ANBU để tìm cống ngầm vào thẳng phòng giam  
**Genin (đã tìm route tắt ở Q3-02):** Option [A] không cần skill check — đã biết lối đi bí mật

---

### Q3-08 — Đối Mặt Sazuki
- **Level yêu cầu:** 37  
- **Location:** Sân trong của Echo Stronghold  
- **Mô tả:** Player tìm được Sazuki. Hắn không bị giam — hắn đang chờ Orokimaru. Cuộc đối thoại quan trọng nhất arc.  

**⚑ CHOICE POINT 5 — QUAN TRỌNG NHẤT ARC 3: Nói Gì Với Sazuki?**

> Sazuki: *"Ngươi đến đây để kéo ta về? Hãy thử đi."*

| Lựa chọn | Hành động | Hậu quả ngắn hạn | Hậu quả dài hạn |
|-----------|-----------|-----------------|----------------|
| **[A] "Hãy quay về — làng cần mày"** | Thuyết phục bằng nghĩa vụ | Sazuki lạnh lùng — không bị thuyết phục; nhưng hắn cho player 1 đòn trước khi tấn công (opening) | Village Rep +15; Sazuki nhớ đến câu này trong ending |
| **[B] "Tao đến vì mày — không phải vì làng"** | Thuyết phục bằng tình bạn | Sazuki dừng lại 3 giây — flashback ngắn; boss fight bắt đầu nhưng Sazuki có -10% damage | +Naruko friendship flag; Sazuki dialogue khác nhau ở ending |
| **[C] "Tao không cản mày — nhưng tao phải đánh"** | Thẳng thắn, không thuyết phục | Sazuki tôn trọng — boss fight bắt đầu bình thường; không có hậu quả đặc biệt | Neutral |
| **[D] "Tao cũng muốn sức mạnh đó — dẫn tao theo"** | Xin đi cùng Sazuki | Chỉ mở nếu Reimei Rep ≥ +30; Sazuki cười nhạt và từ chối — nhưng Orokimaru nghe thấy, xuất hiện offer riêng | -25 Village Rep; mở nhánh Orokimaru Offer (xem Appendix B) |

---

### Q3-09 — Boss: Sazuki Uchira

- **Level yêu cầu:** 37  
- **Location:** Sân trong Echo Stronghold  

#### BOSS: Sazuki Uchira (Nguyền Ấn Cấp 2)

| Stat | Giá trị |
|------|---------|
| HP | 7,000 |
| Chakra | Lửa + Sét (Raikousen) |
| Phase | 2 phase |

**Phase 1 — Sazuki Bình Thường (7,000 → 4,000 HP)**
- *Fireball Jutsu:* AOE tầm trung, damage cao
- *Kagami-me Copy:* Sazuki copy jutsu player vừa dùng và dùng lại — đừng dùng jutsu mạnh nhất liên tục
- *Raikousen:* Tấn công thẳng, damage rất cao — có 1s charge time để dodge
- *Substitution Jutsu:* Sazuki né 1 đòn mỗi 30s bằng cách swap vị trí với khúc gỗ

**Phase 2 — Nguyền Ấn Cấp 2 (4,000 → 0 HP)**
- Sazuki biến đổi — cánh đen, tốc độ tăng mạnh
- *Dark Raikousen:* Phiên bản Raikousen mạnh hơn, AOE nhỏ xung quanh điểm chạm
- *Cursed Flame:* Fire tối màu — gây burn DoT 5s
- *Kagami-me Genjutsu:* Nhìn vào mắt Sazuki khi HP < 20% → bị confuse 4s (tránh bằng cách không nhìn thẳng — mechanic hint qua dialogue)

**Modifier từ Choice Point 5:**
- [A]: Sazuki có 1 opening 2s ở đầu Phase 1
- [B]: Sazuki -10% damage toàn bộ trận
- [C]: Boss fight bình thường
- [D]: Không vào nhánh này — xem Appendix B

**Không thể kill Sazuki** — scripted: khi HP về 0, Orokimaru xuất hiện dừng trận.

- **Reward:** 8,000 EXP (dù không kill được)

---

### Q3-10 — Lựa Chọn Cuối
- **Level yêu cầu:** 39  
- **Location:** Echo Stronghold — cổng ra  
- **Mô tả:** Orokimaru xuất hiện, dừng trận. Sazuki nhìn player lần cuối trước khi đi vào bóng tối. Player kiệt sức — không thể tiếp tục chiến đấu.  

**⚑ CHOICE POINT 6 — KẾT THÚC ARC 3: Để Sazuki Đi?**

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Cố ngăn lần cuối** | Bước về phía Sazuki dù kiệt sức | Sazuki dừng lại — nói 1 câu cuối (khác nhau tùy Choice Point 5); sau đó đi; +10 Village Rep; Naruko cảm ơn player |
| **[B] Đứng yên nhìn** | Không làm gì | Sazuki đi trong im lặng; neutral rep; Naruko thất vọng nhẹ |
| **[C] "Tao sẽ tìm mày — theo cách của tao"** | Lời hứa mơ hồ | Nếu Reimei Rep ≥ +20: Orokimaru nghe thấy — gật đầu nhẹ; mở quest ẩn Arc 4 |

- **Reward:** Arc 3 Completion Badge, 3,000 EXP

---

### Q3-11 — Trở Về Konohara (Epilogue)
- **Level yêu cầu:** 40  
- **Location:** Bệnh viện Konohara  
- **Mô tả:** Player về đến nơi. Naruko được băng bó. Kakashi im lặng. Làng biết Sazuki đã mất.  
- **Task:**
  - Báo cáo với Kakashi (dialogue thay đổi theo rep)
  - Thăm Naruko ở bệnh viện
  - Gặp Shikamura — hắn hỏi player một câu cuối

**⚑ CHOICE POINT 7: Shikamura Hỏi Thật**
> *"Nếu lần sau ngươi gặp Sazuki — ngươi sẽ làm gì?"*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] "Kéo hắn về bằng mọi giá"** | Trung thành làng | +5 Village Rep; unlock quest phụ Arc 4 liên quan đến thông tin Sazuki |
| **[B] "Tôi không biết"** | Thành thật | Neutral; Shikamura gật đầu — *"Câu trả lời thật nhất tao nghe hôm nay"* |
| **[C] "Đó là việc của Naruko"** | Tránh né | Shikamura nhíu mày; không có hậu quả rep nhưng đóng 1 dialogue chain Arc 4 |

---

## Hidden Quest — Dấu Vết Itachi

- **Trigger:** Reimei Rep ≥ +15 + hoàn thành Q3-02 (với flag Reimei intel từ Arc 1/2)
- **Location:** Một quán trọ nhỏ giữa đường, giữa Q3-04 và Q3-05
- **Mô tả:** Player tìm thấy dấu vết của người đã ở đây — áo choàng đen viền đỏ, hoa tươi còn mới. Không có NPC, chỉ có manh mối.
- **Task:**
  - Thu thập 3 manh mối (item interact)
  - Kết hợp manh mối → nhận ra đây là Itachi Uchira
- **Không có combat**
- **Reward:** 2,000 EXP, "Báo Cáo Itachi" (lore item — foreshadowing Shippuden), +10 Reimei Rep
- **Lưu ý:** Quest này hoàn toàn là lore setup. Không ảnh hưởng gameplay Arc 4 trực tiếp.

---

## Appendix B — Nhánh Orokimaru Offer

*Mở khi: Chọn [D] ở Choice Point 5 (xin đi theo Sazuki) + Reimei Rep ≥ +30*

Orokimaru nghe được lời của player. Sau khi Sazuki đi, hắn tiếp cận riêng:

> *"Ngươi muốn sức mạnh? Ta có thể cho ngươi thứ Sazuki không có — sự lựa chọn."*

**⚑ CHOICE POINT B: Nhận Hay Từ Chối Offer Của Orokimaru**

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[B1] Nhận offer** | Theo Orokimaru về Sound | -40 Village Rep; +30 Reimei Rep; unlock ending Villain sớm; skip một phần Arc 4 và nhận story branch riêng |
| **[B2] Từ chối nhưng lắng nghe** | Nghe nhưng không đồng ý | -10 Village Rep; +15 Reimei Rep; Orokimaru để lại 1 item bí ẩn — mở quest ẩn Arc 4 |
| **[B3] Tấn công Orokimaru** | Cố đánh | Orokimaru biến mất (scripted — không thể damage); +15 Village Rep; Orokimaru ghi nhớ player là mối đe dọa |

*Nhánh [B1] là con đường duy nhất dẫn thẳng đến Villain ending mà không cần qua Arc 4 đầy đủ.*

---

## Jutsu Unlock Sau Arc 3

| Jutsu | Tier | Hệ | Cách mở |
|-------|------|----|---------|
| Raikousen (basic) | 3 | Sét | Đánh bại Sazuki Phase 1 mà không bị copy (không dùng jutsu Sét) |
| Branded Seal Technique | 3 | Lửa | Loot từ Sazuki Phase 2 (scroll rơi ra) |
| Spider Web Trap | 2 | Đất | Loot từ Kidomaru |
| Sound Wave Advanced | 3 | Không hệ | Loot từ Tayuya (nếu tự kill) |
| Demonic Illusion: Sound | 3 | Genjutsu | Tayuya's Music Scroll (cần Genjutsu unlock từ trước) |
| Orokimaru's Snake Jutsu | 4 | Không hệ | Appendix B — nhận offer Orokimaru [B1] hoặc [B2] |

---

## Reputation Summary — Arc 3

| Hành động | Village Rep | Reimei Rep |
|-----------|-------------|--------------|
| Đi vì làng Q3-01 [A] | +10 | 0 |
| Lý do riêng (Reimei) Q3-01 [C] | 0 | +5 |
| Cứu Kiba Q3-06 [A] | +5 | 0 |
| Bỏ Kiba Q3-06 [B] | -5 | 0 |
| Thuyết phục làng Q3-08 [A] | +15 | 0 |
| Xin theo Sazuki Q3-08 [D] | -25 | +10 |
| Cố ngăn lần cuối Q3-10 [A] | +10 | 0 |
| Lời hứa mơ hồ Q3-10 [C] | 0 | +10 |
| Nhận offer Orokimaru [B1] | -40 | +30 |
| Tấn công Orokimaru [B3] | +15 | 0 |
| Dấu vết Itachi (Hidden Quest) | 0 | +10 |

**Kết thúc Arc 3 — Phân Nhánh Reputation:**
- Village ≥ +70 tổng 3 arc: Kakashi đích thân gặp player — gợi ý player có thể được xem xét làm ANBU sau này
- Reimei ≥ +40 tổng 3 arc: Một thành viên Reimei (ẩn danh) liên lạc qua thư — mời gặp mặt ở Arc 4
- Nhánh [B1] active: Arc 4 chuyển sang story branch Villain riêng

---

## Ghi Chú Design

- **Sazuki không thể bị kill:** Scripted stop khi HP = 0 — cần animation đẹp cho moment Orokimaru xuất hiện; đây là khoảnh khắc dramatic nhất toàn game
- **Kagami-me Copy mechanic:** Cần system theo dõi jutsu player vừa dùng — nếu jutsu được copy mà player dùng lại trong 10s, Sazuki dùng jutsu đó với damage cao hơn 20%
- **Nhánh [B1] Villain:** Cần thiết kế riêng Arc 4 branch cho hướng này — phức tạp nhưng quan trọng cho replay value
- **Dialogue Kakashi Q3-11 (đã chốt):** Cùng nội dung, khác tone — dùng flag `is_chunin` khi viết dialogue script:
  - Chunin: ngang hàng, chuyên nghiệp — *"Ngươi đã làm đúng quy trình. Kết quả này không phải lỗi của ngươi."*
  - Genin: thầy-trò, ấm hơn — *"Ngươi đã cố hết sức. Đó là đủ rồi — cho hôm nay."*
