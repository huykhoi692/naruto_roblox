# Arc 4: Tìm Tsukade — Game Design Document

**Level range:** 40–50  
**Phe ảnh hưởng:** Làng Lá (Village rep — tổng kết), Reimei (rep — tổng kết)  
**NPC chính:** Jiruha, Naruko, Tsukade, Shizune, Orokimaru, Kabura  

---

## Tổng Quan

Arc cuối của Original Series. Nhịp độ chậm hơn Arc 3 — đây là arc về hồi phục, tìm kiếm, và quyết định cuối cùng trước khi câu chuyện kết thúc. Không còn đội, không còn cấu trúc nhiệm vụ rõ ràng — chỉ có Jiruha, Naruko, và player trên đường dài.

Orokimaru phục kích là climax chiến đấu. Nhưng climax thật sự là khoảnh khắc Tsukade quyết định quay về — và player đã làm gì để khiến điều đó xảy ra (hoặc không xảy ra).

**Cross-arc flags được apply trong arc này:**
- `tazuru_dead` → mở optional quest "Nợ Chưa Trả"
- Villain branch (Arc 3 Appendix B [B1]) → story riêng, xem Appendix C
- Reimei Rep ≥ +40 → nhận thư mời gặp mặt từ thành viên ẩn danh
- Village Rep ≥ +70 → Kakashi gợi ý ANBU → mở quest phụ trong arc này

---

## Danh Sách Quest

### Q4-01 — Lệnh Từ Hội Đồng
- **Level yêu cầu:** 40  
- **NPC giao:** Hội Đồng Làng / Jiruha (Cổng Konohara)  
- **Location:** Konohara — Phòng Họp Hội Đồng  
- **Mô tả:** Hokage Đệ Tam vừa mất. Làng cần Hokage mới. Jiruha được giao nhiệm vụ tìm Tsukade — Sanin huyền thoại — và thuyết phục bà về nhậm chức. Player được chọn đi cùng.  
- **Task:**
  - Nghe brief từ Hội Đồng
  - Nói chuyện với Jiruha trước khi xuất phát — nhận thông tin về Tsukade

**Chunin:** Được Hội Đồng giao thêm nhiệm vụ phụ — thu thập thông tin tình báo dọc đường về hoạt động của Orokimaru  
**Genin:** Jiruha nói thẳng: *"Tao không chắc mày có nên đi — nhưng Naruko tin tưởng mày."*

**⚑ CHOICE POINT 1: Lý Do Đi Cùng**
> Jiruha hỏi player: *"Ngươi muốn đi vì muốn giúp — hay vì không còn gì để làm ở đây?"*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] "Vì làng cần Hokage mới"** | Nhiệm vụ trước hết | +5 Village Rep; Jiruha hài lòng; Tsukade phản ứng tốt hơn khi gặp lần đầu |
| **[B] "Vì Naruko cần ai đó đi cùng"** | Trung thành bạn bè | Naruko nghe được, vui; neutral rep; unlock dialogue chain Naruko trong Q4-03 |
| **[C] "Tôi cần ra ngoài — cần không khí"** | Thành thật, mệt mỏi | Jiruha gật đầu hiểu — *"Tao cũng vậy."* Không có rep thay đổi nhưng mở dialogue riêng với Jiruha suốt arc |

- **Reward:** 1,000 EXP, unlock map Đường Lớn phía Tây

---

### Q4-02 — Trên Đường Đi
- **Level yêu cầu:** 40  
- **Location:** Thị trấn dọc đường, quán trọ  
- **Mô tả:** Ba người dừng chân qua đêm. Jiruha uống rượu, Naruko tập luyện, player tự do khám phá.  
- **Task:**
  - Explore thị trấn (3 điểm tương tác)
  - Tùy chọn: Luyện tập cùng Naruko (nhận buff nhỏ) hoặc ngồi nghe Jiruha kể chuyện (nhận lore)

**⚑ CHOICE POINT 2: Jiruha Hỏi Về Sazuki**
> Jiruha: *"Ngươi nghĩ Sazuki có thể cứu được không?"*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] "Được — chỉ cần thêm thời gian"** | Lạc quan | Naruko nghe thấy, động lực tăng — Naruko buff nhỏ trong Q4-06 |
| **[B] "Tôi không biết. Có lẽ không"** | Thành thật | Jiruha im lặng lâu — sau đó kể chuyện về Orokimaru ngày xưa; lore quan trọng |
| **[C] "Sazuki đã chọn con đường của hắn"** | Chấp nhận | -5 Village Rep; +5 Reimei Rep; Jiruha nhìn player khác đi từ đây |

---

### Q4-03 — Tìm Dấu Vết Tsukade
- **Level yêu cầu:** 41  
- **Location:** Thị trấn cờ bạc — phía Tây  
- **Mô tả:** Tin đồn Tsukade đang cờ bạc ở đâu đó trong vùng. Player và Naruko đi hỏi thông tin trong khi Jiruha "điều tra" theo cách riêng của ông.  
- **Task:**
  - Hỏi 4 NPC trong thị trấn về Tsukade
  - Tìm dấu vết (item interaction: tờ vé cược, dấu sake, biên lai thua cờ bạc)
  - Nhận thông tin từ Shizune — trợ lý của Tsukade

**Naruko dialogue chain (nếu chọn [B] Q4-01):**
- Naruko hỏi player về Hokage: *"Mày có muốn trở thành Hokage không?"*
- Player trả lời → ảnh hưởng dialogue Naruko trong ending slide

- **Reward:** 1,200 EXP, unlock vị trí Tsukade

---

### Q4-04 — Gặp Tsukade
- **Level yêu cầu:** 42  
- **Location:** Quán rượu ngoại ô  
- **Mô tả:** Tsukade say rượu, thua cờ bạc, không muốn nghe chuyện Hokage. Jiruha thuyết phục — thất bại. Naruko thách Tsukade đánh cược: nếu Naruko học được Rashougan trong 1 tuần, Tsukade quay về.  

**⚑ CHOICE POINT 3: Player Nói Gì Với Tsukade**
> Tsukade: *"Hokage chỉ là những thằng ngốc chết trẻ. Tao đã thấy đủ rồi."*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Im lặng — để Naruko nói** | Nhường sân cho Naruko | Naruko thách cược diễn ra bình thường; không có hậu quả đặc biệt |
| **[B] "Bà nói đúng — nhưng làng vẫn cần ai đó"** | Đồng ý một phần | Tsukade nhìn player chằm chằm — *"Ít nhất ngươi không nói dối tao."* Tsukade -10% hostile trong Q4-06 boss |
| **[C] "Tôi không quan tâm bà về hay không — nhưng Naruko tin bà"** | Thẳng thắn | Tsukade cười khẩy nhưng có gì đó thay đổi; unlock dialogue đặc biệt sau khi Naruko thắng cược |

---

### Q4-05 — Tuần Luyện Tập Của Naruko
- **Level yêu cầu:** 43  
- **Location:** Bãi đất trống ngoài thị trấn  
- **Mô tả:** Naruko tập Rashougan. Player có thể hỗ trợ hoặc tự luyện tập riêng trong 3 ngày game time.  

**Lựa chọn hoạt động (không phải choice point — tự do):**

| Hoạt động | Reward |
|-----------|--------|
| Luyện tập cùng Naruko mỗi ngày | +500 EXP/ngày, Naruko friendship +1 |
| Tự luyện Chakra Control | +10% Chakra pool vĩnh viễn |
| Điều tra thị trấn | Tìm NPC ẩn liên quan đến optional quest |
| Nói chuyện với Shizune | Lore về Tsukade, Dan, Nawaki |

**Optional Quest trigger:** Nếu `tazuru_dead = true` — người dân Tide Province xuất hiện ở thị trấn này, trigger quest "Nợ Chưa Trả" (xem Appendix D).

---

### Q4-06 — Orokimaru Xuất Hiện
- **Level yêu cầu:** 44  
- **Location:** Đường vắng ngoài thị trấn, đêm  
- **Mô tả:** Orokimaru và Kabura phục kích — không phải để giết Tsukade, mà để thuyết phục bà chữa tay cho hắn. Kabura đối đầu player trong khi Orokimaru nói chuyện với Tsukade và Jiruha.  

#### BOSS: Kabura Yakushi

| Stat | Giá trị |
|------|---------|
| HP | 5,500 |
| Chakra | Không hệ (Medical Ninjutsu) |
| Cơ chế đặc biệt | Heal bản thân — phải burst damage nhanh |

**Phase 1 — Medical Counter (5,500 → 3,000 HP)**
- *Chakra Scalpel:* Melee nhanh, cắt đứt chakra pathway — giảm player's chakra regen 30% trong 10s
- *Cell Regeneration:* Kabura tự heal 400 HP mỗi 25s — nếu không interrupt bằng stun
- *Senbon Volley:* Tầm trung, 5 kim — mỗi kim 80 damage, có thể dodge từng cái

**Phase 2 — Orokimaru's Data (3,000 → 0 HP)**
- Kabura dùng kiến thức thu thập được — copy stats của player (damage, speed) tăng 20%
- *Nervous System Strike:* Đánh vào điểm huyệt — stun 3s, không thể dùng jutsu
- *Dead Soul Technique:* Gọi 2 zombie NPC — HP thấp (300) nhưng gây distraction

**Cơ chế:** Mỗi lần Kabura heal, Orokimaru bên kia thêm 1 lần thuyết phục Tsukade — nếu Kabura heal đủ 3 lần, Tsukade bị lung lay (ảnh hưởng Q4-07)

- **Loot:** 5,000 EXP, "Sổ Tay Y Thuật Kabura" (lore item + +5% healing jutsu nếu có)

---

### Q4-07 — Tsukade Phải Chọn
- **Level yêu cầu:** 45  
- **Location:** Đường vắng — ngay sau Q4-06  
- **Mô tả:** Orokimaru đề nghị: chữa tay cho hắn đổi lấy việc hắn hồi sinh Dan và Nawaki. Tsukade bị lung lay. Jiruha cảnh báo. Naruko tức giận.  

**⚑ CHOICE POINT 4: Player Nói Gì Lúc Này**
> Tsukade đang do dự. Jiruha và Naruko đã nói. Đến lượt player.

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] "Bà biết Orokimaru đang nói dối"** | Lý trí | Tsukade tỉnh táo lại nhanh hơn; boss fight Q4-08 bắt đầu với Tsukade đã quyết định |
| **[B] "Dan và Nawaki sẽ không muốn bà làm vậy"** | Cảm xúc | Tsukade khóc — rồi tức giận; boss fight Q4-08 Tsukade damage +20% |
| **[C] Không nói gì — đứng cạnh Naruko** | Hành động thay lời nói | Naruko nhìn player gật đầu — cùng nhau bước lên đối mặt Orokimaru; unlock co-op attack nhỏ trong Q4-08 |
| **[D] "Nếu bà chữa tay cho hắn — tôi sẽ ngăn bà"** | Đối đầu trực tiếp | Tsukade tức giận với player trước — rồi nhận ra player đúng; +10 Village Rep; Tsukade respect flag |

---

### Q4-08 — Boss: Orokimaru

- **Level yêu cầu:** 46  
- **Location:** Đồng hoang ngoài thị trấn  
- **Mô tả:** Tsukade tấn công Orokimaru. Jiruha ghim Kabura. Player hỗ trợ Tsukade hoặc đối đầu Kabura round 2.  

**⚑ CHOICE POINT 5: Player Chiến Ở Đâu?**

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] Hỗ trợ Tsukade vs Orokimaru** | Đánh cùng Tsukade | Orokimaru HP thấp hơn; nhưng Kabura không bị ghim — tấn công player từ phía sau mỗi 30s |
| **[B] Ghim Kabura để Tsukade 1v1** | Đánh Kabura lần 2 | Tsukade 1v1 Orokimaru bình thường; player không tham chiến chính nhưng Kabura bị vô hiệu hóa |

#### BOSS: Orokimaru (Tay Bị Phong Ấn)

| Stat | Giá trị |
|------|---------|
| HP | 9,000 |
| Chakra | Không hệ (Snake) |
| Ghi chú | Tay bị Hokage Đệ Tam phong ấn — không dùng được Hand Seal đầy đủ |

**Phase 1 — Snake Fang (9,000 → 6,000 HP)**
- *Kusanagi Sword:* Kiếm thần từ miệng — tầm dài bất ngờ, xuyên block
- *Eight Branches Technique:* Biến thành rắn khổng lồ 8 đầu — AOE sweep
- *Snake Shed:* Orokimaru lột xác — heal 500 HP và reset debuff

**Phase 2 — True Body (6,000 → 3,000 HP)**
- Lột bỏ lớp da người — hình dạng thật
- *Binding Snake Glare Spell:* Gọi rắn khổng lồ bao vây — root 5s toàn arena
- *Oral Rebirth:* Tái sinh từ miệng rắn — tự hồi 1,000 HP một lần duy nhất (có thể interrupt nếu deal 500 damage trong 2s)

**Phase 3 — Giới Hạn Tay (3,000 → 0 HP)**
- Vì tay bị phong ấn, Orokimaru không thể dùng jutsu mạnh nhất — bù lại bằng tốc độ
- *Slithering Rush:* Dash nhanh liên tục, 5 đòn combo
- *Venom Spit:* Poison DoT 8s, giảm healing 50%
- Tsukade hỗ trợ (nếu chọn [A] Q4-05): Tsukade dùng Strength of a Hundred tạo opening 4s mỗi 60s

**Không thể kill Orokimaru** — scripted: khi HP = 0, Orokimaru rút lui vào bóng tối cùng Kabura. Tsukade dùng toàn lực một đòn cuối đẩy hắn đi.

- **Reward:** 12,000 EXP, "Vảy Rắn Orokimaru" (material cực hiếm), Arc 4 Boss Badge

---

### Q4-09 — Tsukade Quyết Định
- **Level yêu cầu:** 48  
- **Location:** Thị trấn — sáng hôm sau  
- **Mô tả:** Orokimaru đã rút. Tsukade ngồi một mình. Naruko đến và đưa bà xem Rashougan hoàn chỉnh — lời hứa của cược đã được giữ.  
- **Task:**
  - Chứng kiến cảnh Naruko dùng Rashougan (scripted)
  - Nói chuyện với Tsukade lần cuối trước khi bà quyết định

**⚑ CHOICE POINT 6: Lời Cuối Với Tsukade**
> Tsukade đang suy nghĩ. Bà nhìn player: *"Ngươi nghĩ tôi có nên về không?"*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] "Làng cần bà"** | Đơn giản, thẳng thắn | Tsukade gật đầu — quyết định về; +5 Village Rep |
| **[B] "Đó là quyết định của bà — không ai có thể trả lời thay"** | Tôn trọng | Tsukade im lặng rồi đứng dậy tự mình quyết định — *"Ngươi đúng."* Đây là response Tsukade thích nhất; unlock dialogue đặc biệt khi về đến Konohara |
| **[C] "Tôi không biết — nhưng Naruko tin bà"** | Thành thật | Tsukade cười nhẹ; neutral |

- **Reward:** 3,000 EXP

---

### Q4-10 — Đường Về Konohara
- **Level yêu cầu:** 49  
- **Location:** Đường lớn phía Tây → Konohara  
- **Mô tả:** Bốn người trở về. Không có combat — đây là quest đi bộ, dialogue, nhìn lại hành trình.  
- **Task:**
  - Di chuyển về Konohara (có thể nói chuyện với từng NPC trên đường)
  - Jiruha kể một câu chuyện ngắn — foreshadowing Shippuden (không đặt tên, chỉ gợi ý)

**Optional — Tide Province Epilogue:**  
Nếu `tazuru_dead = false`: Khi đi qua vùng gần Tide Province, có NPC đưa tin — cầu đã xây xong, Inaro gửi lời cảm ơn. Nhỏ nhặt nhưng closure tốt cho Arc 1.

**⚑ CHOICE POINT 7: Naruko Hỏi Về Tương Lai**
> Naruko: *"Mày sẽ làm gì tiếp theo? Sau tất cả chuyện này?"*

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[A] "Tiếp tục bảo vệ làng"** | Hero path | +10 Village Rep; ảnh hưởng ending Hero |
| **[B] "Tôi chưa biết — hỏi lại tôi sau"** | Wanderer path | Neutral; ảnh hưởng ending Wanderer |
| **[C] "Tôi muốn trở nên mạnh hơn — bằng mọi cách"** | Ambiguous | Nếu Reimei Rep ≥ +30: ảnh hưởng ending Villain; nếu không: neutral |

---

### Q4-11 — Về Đến Konohara (Epilogue + Ending)
- **Level yêu cầu:** 50  
- **Location:** Cổng Konohara → Đường phố → Đỉnh Núi Hokage  
- **Mô tả:** Tsukade được chào đón. Lễ nhậm chức Hokage Đệ Ngũ. Kết thúc Original Series.  
- **Task:**
  - Chứng kiến lễ nhậm chức (scripted — 2 phút)
  - Nói chuyện với Tsukade lần cuối
  - Đứng trên đỉnh núi Hokage — nhìn xuống làng

**Ending Slide** — được xác định bởi Village Rep và Reimei Rep tổng 4 arc:

---

## Ending System

### Điều Kiện Ending

| Ending | Điều kiện |
|--------|-----------|
| **Hero** | Village Rep ≥ +60 tổng 4 arc |
| **Villain** | Reimei Rep ≥ +50 tổng 4 arc (hoặc Villain branch Arc 3 active) |
| **Wanderer** | Không đủ điều kiện Hero hoặc Villain |

*Nếu đủ cả 2 điều kiện Hero và Villain → Wanderer (không thể commit hai phía).*

---

### Ending: Hero

> *"Ngươi đã chọn làng — và làng sẽ nhớ điều đó."*

**Ending Slide sequence:**
1. Player đứng cạnh Tsukade trên đỉnh núi Hokage
2. Naruko chạy qua, vẫy tay — *"Hẹn gặp lại!"*
3. Konohara bình yên — cảnh quay từ trên cao
4. Nếu `tazuru_dead = false`: Slide thêm — Cầu Tide Province, Inaro đứng nhìn ra biển
5. Nếu `tazuru_dead = true` + hoàn thành "Nợ Chưa Trả": Cầu được xây lại — muộn, nhưng đã xong
6. Nếu `tazuru_dead = true` + không làm "Nợ Chưa Trả": Tide Province trong bóng tối — không có slide cầu
7. Text cuối: *"Câu chuyện của ngươi chưa kết thúc."*

---

### Ending: Villain

> *"Ngươi đã chọn sức mạnh — cái giá là tất cả những gì ngươi từng có."*

**Ending Slide sequence:**
1. Player nhìn Konohara từ xa — đứng bên ngoài cổng, không vào
2. Bóng dáng áo choàng đen viền đỏ xuất hiện cạnh player
3. Naruko ở đằng xa — nhìn về phía player, không nói gì
4. Text cuối: *"Con đường này dài hơn ngươi nghĩ."*

---

### Ending: Wanderer

> *"Ngươi không thuộc về bên nào — và đó cũng là một câu trả lời."*

**Ending Slide sequence:**
1. Player đứng một mình trên đường lớn — không phải Konohara, không phải Sound
2. Nếu có Moral Flag tiêu cực (Tazuru chết, Kiba bị bỏ, etc.): Các hình ảnh flash ngắn — những người đã bị bỏ lại
3. Jiruha xuất hiện ngắn — ngồi cạnh player uống rượu, không nói gì
4. Text cuối: *"Có những người không cần thuộc về đâu để tiếp tục bước."*

---

## Appendix C — Villain Branch (từ Arc 3 Appendix B [B1])

*Active khi: Player chọn theo Orokimaru ở cuối Arc 3.*

Player không tham gia đội tìm Tsukade. Thay vào đó:

**Q4-V01 — Trong Echo Stronghold**
- Orokimaru giao nhiệm vụ thử thách đầu tiên: thu thập thông tin về Tsukade
- Player hoạt động như spy — đi các địa điểm bình thường nhưng với mục đích khác

**Q4-V02 — Sabotage**
- Orokimaru muốn Tsukade không về Konohara — player có thể can thiệp vào quá trình thuyết phục
- Gặp lại Naruko và Jiruha từ phía đối lập

**⚑ CHOICE POINT V: Phản Bội Orokimaru**
> Khi gặp lại Naruko, player có thể:

| Lựa chọn | Hành động | Hậu quả |
|-----------|-----------|---------|
| **[V1] Tiếp tục theo Orokimaru** | Hoàn thành nhiệm vụ sabotage | Villain Ending — Tsukade không về, Konohara không có Hokage mới trong ending slide |
| **[V2] Quay đầu — cảnh báo Naruko** | Phản bội Orokimaru | -30 Reimei Rep; +40 Village Rep; Wanderer Ending — Orokimaru coi player là kẻ thù; Naruko tha thứ |

---

## Appendix D — Optional Quest "Nợ Chưa Trả"

*(Xem thiết kế đầy đủ trong Arc 1 — Cross-Arc Flag section)*

**Trigger trong Arc 4:** Người dân Tide Province xuất hiện ở thị trấn trong Q4-05  
**Timing:** Có thể làm bất kỳ lúc nào trong Q4-05 đến Q4-09  
**Reward:** +50% Village Rep đã mất từ Arc 1, cosmetic "Dải Ruy Băng Wave Muộn Màng"  
**Ending slide:** Nếu hoàn thành → Tide Province slide xuất hiện trong Hero/Wanderer ending

---

## Hidden Quest — Thư Của Reimei

- **Trigger:** Reimei Rep ≥ +40 tổng 4 arc + flag "Dấu Vết Itachi" từ Arc 3 hidden quest
- **Location:** Quán trọ trong Q4-02 — thư để trong phòng player
- **Mô tả:** Thư không có chữ ký. Chỉ có địa điểm và giờ hẹn — một mình.
- **Task:** Đến địa điểm → gặp một thành viên Reimei (mặt che kín, không reveal danh tính)
- **Không có combat**
- **Dialogue:** Reimei offer thông tin về Sazuki đổi lấy một việc nhỏ trong tương lai
- **⚑ CHOICE POINT HQ:**
  - [A] Chấp nhận: +15 Reimei Rep, nhận "Thông Tin Sazuki" (lore item foreshadowing Shippuden)
  - [B] Từ chối: neutral; thành viên Reimei rời đi — *"Khi ngươi đổi ý, chúng ta sẽ tìm ngươi."*
  - [C] Cố nhìn mặt: fail — Reimei biến mất; không có reward

---

## Jutsu Unlock Sau Arc 4

| Jutsu | Tier | Hệ | Cách mở |
|-------|------|----|---------|
| Rashougan (basic) | 3 | Không hệ | Chứng kiến Naruko hoàn thành trong Q4-05 — học theo |
| Medical Ninjutsu: Basic | 2 | Không hệ | Loot "Sổ Tay Y Thuật Kabura" + 10h luyện tập (cooldown) |
| Snake Summoning | 4 | Không hệ | Villain Branch [V1] hoặc Reimei Hidden Quest [A] |
| Strength of a Hundred: Seal | 4 | Không hệ | Chọn [A] Q4-05 + Village Rep ≥ +60 — Tsukade dạy riêng |
| Nature Form: Incomplete | 5 | Không hệ | Post-game content — gặp Jiruha sau ending (chỉ Hero ending) |

---

## Reputation Summary — Arc 4

| Hành động | Village Rep | Reimei Rep |
|-----------|-------------|--------------|
| Lý do đi vì làng Q4-01 [A] | +5 | 0 |
| Sazuki đã chọn con đường Q4-02 [C] | -5 | +5 |
| Đối đầu Tsukade Q4-07 [D] | +10 | 0 |
| Tiếp tục theo Naruko Q4-10 [A] | +10 | 0 |
| Wanderer answer Q4-10 [B] | 0 | 0 |
| Ambiguous + Reimei Q4-10 [C] | 0 | +10 |
| Villain Branch sabotage [V1] | -30 | +20 |
| Phản bội Orokimaru [V2] | +40 | -30 |
| Reimei Hidden Quest [A] | 0 | +15 |

---

## Ending Slide Chi Tiết — Tất Cả Nhánh

| Flag | Hero Slide | Villain Slide | Wanderer Slide |
|------|-----------|---------------|----------------|
| `tazuru_dead = false` | Cầu Wave + Inaro | Không xuất hiện | Inaro đứng nhìn xa |
| `tazuru_dead = true` + quest done | Cầu xây lại (muộn) | Không xuất hiện | Cầu xây lại (muộn) |
| `tazuru_dead = true` + quest skip | Không có slide Wave | Không xuất hiện | Flash hình ảnh tối |
| Naruko friendship flag | Naruko vẫy tay | Naruko ở đằng xa | Naruko không xuất hiện |
| Chunin rank | Slide Hokage nhìn xuống | — | — |
| Itachi hidden quest done | — | Bóng Itachi rõ hơn | Bóng Itachi mờ |
| Reimei quest [A] | — | Thư Reimei thứ 2 xuất hiện | Thư Reimei xuất hiện |

---

## Ghi Chú Design

- **Orokimaru không thể bị kill:** Cùng pattern với Sazuki ở Arc 3 — scripted retreat khi HP = 0; cần animation Tsukade đẩy Orokimaru đi đủ epic cho climax toàn series
- **Ending Slide system:** Đây là điểm phức tạp nhất về mặt kỹ thuật — cần flag manager track tất cả cross-arc flags; đề xuất làm một EndingManager module riêng trong Phase 3
- **Sage Mode Incomplete:** Jutsu Tier 5 duy nhất trong Original Series — chỉ mở ở post-game, giữ lại làm mục tiêu dài hạn cho player
- **Villain Branch:** Cần thêm ~3 quest phụ để nhánh này có đủ content — hiện tại chỉ có 2 quest chính (Q4-V01, Q4-V02); đây là debt content cần giải quyết trước khi ship
