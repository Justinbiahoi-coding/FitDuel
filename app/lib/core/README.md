# core/ — Logic thuần, dùng chung, test được không cần camera/thiết bị thật

## Quy tắc của thư mục này

Code ở đây **không được phép** import `camera`, `google_mlkit_pose_detection`,
`firebase_*`, hay bất cứ package nào cần chạy trên thiết bị thật/emulator.
Chỉ chứa hàm/class thuần Dart (nhận số vào, trả số ra). Lý do: nhờ vậy mọi
thứ trong `core/` đều viết unit test bằng giá trị giả lập được, chạy trong
vài giây (`flutter test`), không cần mở emulator hay tự pose trước camera
(xem lại hội thoại commit `f4854fa` — lúc đầu quên tách, phải sửa lại).

Nếu thấy mình cần `import 'package:camera/...'` ngay trong file ở `core/` —
dấu hiệu cho thấy code đó **không thuộc về đây**, nên chuyển vào
`features/<tên_feature>/` thay vì để ở `core/`.

## File hiện có

### `pose_math.dart`

Toàn bộ công thức toán học cho việc đo chuyển động cơ thể qua pose
estimation. Xem `docs/pose_estimation_spec.md` ở gốc repo để biết bối cảnh
đầy đủ (vì sao chọn công thức này). Tóm tắt từng hàm:

- **`Point2D`** — 1 điểm tọa độ (x, y) đơn giản. Tồn tại để các hàm dưới đây
  không phải phụ thuộc kiểu `PoseLandmark` của ML Kit — nhờ vậy test được mà
  không cần cài package ML Kit vào file test.

- **`angleAtElbow(shoulder, elbow, wrist)`** — Tính góc tại khuỷu tay (độ,
  0-180°) bằng công thức góc giữa 2 vector: vector từ khuỷu→vai và vector từ
  khuỷu→cổ tay, dùng `acos` của tích vô hướng chia cho tích độ dài 2 vector.
  Trả về `0` nếu 1 trong 2 vector có độ dài bằng 0 (tránh chia cho 0 — xảy ra
  nếu ML Kit trả về 2 điểm trùng nhau).

- **`gocMinHitDatSau` / `gocMaxTayDuoi`** — 2 hằng số ngưỡng góc: dưới
  `gocMinHitDatSau` (90°) coi là "hít đất sâu nhất", trên `gocMaxTayDuoi`
  (160°) coi là "tay duỗi thẳng nhất". Số này lấy từ đối chiếu nghiên cứu CV
  về đếm hít đất (Baek et al. IEEE CASE 2020, Suraju et al. 2025 — xem đầy đủ
  nguồn ở `docs/pose_estimation_spec.md`), **không phải số tự đoán**.
  **Vẫn chỉ là ngưỡng chung tạm dùng, không phải ngưỡng cá nhân hoá** — không
  chuẩn thể lực chính thức nào (quân đội, ACSM) dùng 1 số độ cố định cho mọi
  người, vì tỉ lệ tay/thân khác nhau cho góc khác nhau ở cùng 1 độ sâu thật.
  Khi code tính năng F10 (hướng dẫn chuẩn bị trước trận), bắt buộc thêm bước
  hiệu chỉnh riêng từng người bằng vài rep mẫu — xem spec để biết chi tiết.

- **`depthFromAngle(goc, {gocMin, gocMax})`** — Chuẩn hóa góc thành giá trị
  điều khiển 0-1 (dùng công thức nội suy tuyến tính, kẹp trong khoảng [0,1]
  bằng `.clamp()`). Giá trị này sau sẽ dùng làm tọa độ Y của nhân vật trong
  mini-game (xem `docs/game_mechanics_spec.md`).

- **`nguongTinCayMacDinh`** — Ngưỡng độ tin cậy tối thiểu (0.6) để chấp nhận
  1 điểm khớp ML Kit trả về là "thật", không phải đoán mò.

- **`duTinCay(shoulderLikelihood, elbowLikelihood, wristLikelihood, {nguong})`**
  — Trả `true` chỉ khi **cả 3** điểm đều đạt ngưỡng tin cậy. Hàm này tồn tại
  vì phát hiện thực tế: ML Kit luôn trả đủ tọa độ cho 33 điểm khớp kể cả khi
  camera chỉ thấy mặt (không thấy tay) — nếu không lọc theo độ tin cậy, app
  sẽ tính toán trên tọa độ bịa ra, dẫn tới góc/độ cao sai hoàn toàn mà không
  có dấu hiệu báo lỗi gì.

## Test tương ứng

`test/core/pose_math_test.dart` — chạy `flutter test` để xem toàn bộ, bao
gồm cả test mô phỏng đúng ca lỗi "chỉ thấy mặt" bằng số độ tin cậy thấp,
không cần camera thật.
