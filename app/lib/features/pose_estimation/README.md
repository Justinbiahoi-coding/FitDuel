# features/pose_estimation/ — Camera + ML Kit pose detection

**Trạng thái:** Bước 2 trong kế hoạch (xem `docs/Gantt_FitDuel_chi_tiet.xlsx`)
— màn hình chứng minh pipeline camera → ML Kit → công thức tính độ sâu chạy
đúng. Chưa có game, chưa có ghép trận. Đây là màn hình sẽ được build tiếp
thành màn hình thi đấu thật ở Bước 5, không phải code vứt đi.

## File hiện có

### `pose_estimation_screen.dart` — `PoseEstimationScreen`

Nhận `cameras` (danh sách camera của máy) qua constructor — **không** đọc
biến toàn cục, để widget này test/dùng lại được dễ dàng (truyền danh sách
camera giả khi viết widget test sau này).

Luồng xử lý từng bước, theo đúng thứ tự trong file:

1. **`initState()` → `_initCamera()`**: chọn camera sau (back camera) nếu
   có, không thì lấy camera đầu tiên trong danh sách. Khởi tạo
   `CameraController` với độ phân giải `medium` (đủ cho pose detection,
   không cần full HD — tốn hiệu năng vô ích). Định dạng ảnh khác nhau theo
   hệ điều hành: `nv21` cho Android, `bgra8888` cho iOS — vì đây là 2 định
   dạng ML Kit đọc được trực tiếp trên từng nền tảng, tránh phải tự chuyển
   đổi định dạng ảnh (tốn CPU, chậm).

2. **`startImageStream(_processImage)`**: mỗi khung hình camera bắt được sẽ
   gọi `_processImage`.

3. **`_processImage(image)`**: có cờ `_isDetecting` để **bỏ qua khung hình
   mới nếu khung trước chưa xử lý xong** — nếu không có cờ này, các khung
   hình sẽ xếp hàng chờ xử lý và app sẽ bị trễ (lag) dần theo thời gian.

   - Gọi `_buildInputImage()` để chuyển `CameraImage` (định dạng riêng của
     plugin `camera`) sang `InputImage` (định dạng ML Kit hiểu được).
   - Chạy `_poseDetector.processImage()` — đây là bước gọi model AI, chạy
     bất đồng bộ (`await`).
   - Lấy 3 điểm `leftShoulder`, `leftElbow`, `leftWrist` — **chỉ dùng tay
     trái** cho bản MVP (đơn giản hóa có chủ đích, chưa hỗ trợ chọn tay
     thuận).
   - Gọi `duTinCay()` (từ `core/pose_math.dart`) để lọc bỏ kết quả không
     đáng tin — xem lý do chi tiết ở `core/README.md`.
   - Nếu hợp lệ: gọi `angleAtElbow()` + `depthFromAngle()`, hiển thị lên
     `_debugText`.

4. **`_buildInputImage(image)`**: chuyển đổi định dạng ảnh. Có 2 chỗ trả về
   `null` (bỏ qua khung hình đó) nếu không xác định được hướng xoay camera
   hoặc định dạng ảnh — những trường hợp hiếm nhưng có thể xảy ra ở vài dòng
   máy, bỏ qua 1 khung hình an toàn hơn là làm app crash.

5. **`dispose()`**: đóng camera và pose detector khi rời màn hình — bắt buộc
   phải có, nếu quên sẽ rò rỉ bộ nhớ/camera (camera bị giữ, màn hình khác mở
   camera sẽ lỗi).

## Hạn chế đã biết (sẽ xử lý ở bước sau, không phải quên)

- Ngưỡng góc (`gocMinHitDatSau`, `gocMaxTayDuoi` trong `core/pose_math.dart`)
  là số khởi điểm, chưa hiệu chỉnh theo người dùng thật.
- Chỉ test bằng tay trái, chưa xử lý trường hợp tay trái bị che khuất nhưng
  tay phải thấy rõ.
- UI hiện tại chỉ hiện chữ debug, chưa có giao diện đẹp (không phải mục tiêu
  của Bước 2).

## Test

Phần logic toán (góc, độ cao, độ tin cậy) được test riêng ở
`test/core/pose_math_test.dart`, không test ở đây. Phần camera/ML Kit trong
file này hiện **chưa có test tự động** vì cần hạ tầng giả lập camera/ML Kit
(integration test trên emulator) — xác minh bằng cách tự chạy
`flutter run -d <emulator>` và quan sát, cho tới khi nhóm quyết định đầu tư
viết integration test (chưa cấp thiết ở quy mô 1 feature nhỏ này).
