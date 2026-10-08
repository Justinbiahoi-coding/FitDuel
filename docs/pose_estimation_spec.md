# Spec: Đo độ sâu chuyển động (hít đất)

## Landmark cần dùng (từ `google_mlkit_pose_detection`)

- `leftShoulder`, `leftElbow`, `leftWrist` (hoặc bên phải nếu bên trái bị che khuất)
- `leftHip` (để kiểm tra lưng có thẳng không — chống gian lận tư thế sai)

## Công thức tính góc khuỷu tay

Dùng công thức góc giữa 3 điểm (vai - khuỷu tay - cổ tay):

```
goc = acos( (v1 · v2) / (|v1| * |v2|) )
trong đó:
  v1 = vai - khuỷu_tay
  v2 = cổ_tay - khuỷu_tay
```

- Góc ~180° → tay duỗi thẳng (vị trí lên cao của hít đất)
- Góc ~90° hoặc nhỏ hơn → tay gập sâu (vị trí xuống thấp của hít đất)

## Chuẩn hóa thành giá trị điều khiển game (0-1)

```
do_cao = clamp( (goc - GOC_MIN) / (GOC_MAX - GOC_MIN), 0, 1 )
```

- `GOC_MAX` = 160° (đỉnh/duỗi thẳng — map thành độ_cao = 1, chim bay lên)
- `GOC_MIN` = 90° (đáy/hít đất sâu — map thành độ_cao = 0, chim bay xuống)

## Nghiên cứu đối chiếu (research trước khi làm Bước 4)

Số 160°/90° lấy từ đối chiếu 2 nguồn, không phải tự đoán:

| Nguồn | Đáy | Đỉnh | Độ uy tín |
|---|---|---|---|
| Baek et al., *IEEE CASE 2020* (OpenPose, 220 video, theo luật Quân đội Hàn Quốc) | <90° (rep chuẩn đo 50-70°) | >150° | Cao — hội nghị IEEE có phản biện |
| Suraju, Sahertian, Irawan, *INOTEK* 2025 (MediaPipe) | <90-95° | >160° | Trung bình — kỷ yếu hội nghị |

Nguồn: [Baek et al. (ResearchGate)](https://www.researchgate.net/publication/347268585), [Suraju et al. (INOTEK)](https://proceeding.unpkediri.ac.id/index.php/inotek/article/download/7325/4906/28912)

*Giới hạn khi trích dẫn: bản PDF gốc của Baek et al. (IEEE CASE 2020) bị chặn truy cập (lỗi 403) lúc research, số liệu trên lấy từ abstract/trích đoạn hiển thị trên ResearchGate. Nếu dùng làm trích dẫn chính thức trong báo cáo/bài nộp, nên tìm đọc bản đầy đủ trên IEEE Xplore để xác nhận lại trước.*

**Phát hiện quan trọng — không dùng 1 ngưỡng cố định cho mọi người:** các chuẩn thể lực chính thức (US Marine Corps PFT, US Army ACFT, ACSM, FITNESSGRAM) đều định nghĩa độ sâu hít đất bằng **mốc vật lý** (ngực/cằm chạm sàn, cánh tay song song mặt đất), không dùng số độ cố định — vì tỉ lệ chiều dài tay/thân khác nhau cho ra góc khuỷu khác nhau ở cùng 1 độ sâu thật. Thêm vào đó, sai số đo góc khuỷu của MediaPipe/ML Kit so với motion capture thật vào khoảng **12-16°** ([MDPI 2026](https://www.mdpi.com/2076-3417/16/3/1202)), lớn hơn cả khoảng cách giữa các ngưỡng "hợp lý" khác nhau tìm được. Một dự án mã nguồn mở tương tự ([ai-personal-trainer](https://github.com/AYMANE-SNOUSSI/ai-personal-trainer)) đo "tay duỗi hết" ra 141-171° tùy người/góc quay, nên đã bỏ ngưỡng tuyệt đối, chuyển sang tính theo % biên độ chuyển động (ROM) của từng người.

**Quyết định cho FitDuel:** 160°/90° ở trên là **ngưỡng dự phòng chung**, dùng tạm khi chưa hiệu chỉnh. Khi code tính năng F10 "Hướng dẫn chuẩn bị trước trận" (xem Vision Document), **bắt buộc** thêm bước hiệu chỉnh riêng từng người: cho người chơi tập mẫu 2-3 rep, ghi lại góc lớn nhất/nhỏ nhất thật của chính họ, rồi tính ngưỡng cá nhân theo % biên độ đó (ví dụ đỉnh ≥ min + 85% ROM, đáy ≤ min + 20% ROM) thay vì dùng số chung cho mọi người. Nên giữ thêm 1 ngưỡng sàn tuyệt đối ở đáy (~100-110°) để chống hiệu chỉnh gian lận (cố tình tập nông lúc calibrate để game dễ hơn).

**Về góc đặt camera:** nhóm tự test thực tế thấy quay **nghiêng/side-view** (vuông góc thân người, cách 1,5-2m) cho độ tin cậy rất cao (0.90-1.00 suốt cả nhịp). Một nghiên cứu khác ([Oliosi et al., *JMIR mHealth* 2026](https://pmc.ncbi.nlm.nih.gov/articles/PMC12978916/)) đo được góc **chéo 45°, cách 90-180cm** cho tỉ lệ phát hiện tốt nhất (85,7%) — có thể là hướng đáng thử thêm sau này, nhưng side-view đã đủ dùng cho MVP.

**Số đo thực tế của 1 thành viên nhóm** (Bước 3, quay side-view): đáy 77.9°, đỉnh 172.8-178.1° — nằm trong khoảng hợp lý so với nghiên cứu trên, nhưng mẫu chỉ n=1 nên không dùng làm chuẩn chung, chỉ để đối chiếu/tham khảo.

## Chống gian lận tư thế (kiểm tra lưng thẳng)

Tính góc giữa vai-hông theo phương ngang so với mặt đất — nếu lệch quá X độ (lưng cong/võng), coi lần đó là "không hợp lệ", không tính điểm dù tay có gập đúng.

## Tần suất xử lý

Mục tiêu ≥ 15 khung hình/giây — nếu máy yếu bị giật, cân nhắc xử lý cách 1 khung hình thay vì mọi khung hình (bỏ bớt 1/2 số khung) để giữ độ mượt của game.
