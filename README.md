# FitDuel

**Ứng dụng ghép trận thể dục trực tuyến kết hợp mini-game**

Tập thể dục một mình (hít đất, squat, plank) dễ bị bỏ cuộc vì thiếu động lực. FitDuel biến buổi tập thành một trận đấu trực tuyến 1-1: camera điện thoại nhận diện chuyển động cơ thể theo thời gian thực và biến nó thành cần điều khiển của một mini-game (kiểu Flappy Bird) — bạn không chỉ thi ai làm được nhiều/lâu hơn, mà còn phải tập đúng nhịp để không thua ngay trong game.

> Đồ án môn học Nhập môn Công nghệ phần mềm.

## Trạng thái dự án

🚧 Đang phát triển — xem tiến độ chi tiết tại [`docs/Gantt_FitDuel_chi_tiet.xlsx`](docs/Gantt_FitDuel_chi_tiet.xlsx).

- [x] Môi trường dev (Flutter, Android SDK, emulator) + scaffold project
- [x] Camera + ML Kit pose detection chạy được, có lọc độ tin cậy (likelihood)
- [x] Cấu trúc code feature-first + README chi tiết từng thư mục (xem [`app/lib/README.md`](app/lib/README.md))
- [x] Hiệu chỉnh ngưỡng góc theo chuyển động thật (78°–176°, quay side-view)
- [ ] Mini-game, ghép trận, đồng bộ Firebase, màn hình chia đôi

Mã nguồn ứng dụng nằm trong [`app/`](app/).

## Thành viên nhóm

| STT | Họ và tên | Vai trò | MSSV | Email |
|-----|-----------|---------|------|-------|
| 1   | Võ Hoàng Phúc | Trưởng nhóm — Pose Estimation | 24120123 | 24120123@student.hcmus.edu.vn |
| 2   | Nguyễn Đức Duy Tân | Mini-game | 24120135 | 24120135@student.hcmus.edu.vn |
| 3   | Bùi Văn Thiên | Backend & đồng bộ | 24120138 | 24120138@student.hcmus.edu.vn |
| 4   | Nguyễn Lê Anh Tuấn | Giao diện | 24120153 | 24120153@student.hcmus.edu.vn |
| 5   | Cáp Hửu Duy | Kiểm thử & tài liệu | 24120177 | 24120177@student.hcmus.edu.vn |

## Tính năng chính (MVP)

- [ ] Đăng ký/Đăng nhập tài khoản
- [ ] Ghép trận trực tuyến 1-1
- [x] Nhận diện tư thế qua camera theo thời gian thực (hít đất) — hoạt động, đang hiệu chỉnh ngưỡng
- [ ] Mini-game điều khiển bằng chuyển động cơ thể
- [ ] Đồng bộ trạng thái trận đấu giữa 2 người chơi (Firebase Realtime Database)
- [ ] Màn hình chia đôi: xem game của mình và của đối thủ
- [ ] Chấm điểm, lưu và xem lại lịch sử trận đấu

Chi tiết đầy đủ (phạm vi, kiến trúc, nâng cao, rủi ro): xem [`docs/De_cuong_du_an_FitDuel.docx`](docs/De_cuong_du_an_FitDuel.docx).

## Công nghệ dự kiến

- **Mobile**: Flutter (Android)
- **Pose estimation**: Google ML Kit Pose Detection / MediaPipe Pose
- **Mini-game engine**: Flame (Flutter)
- **Backend / đồng bộ trận đấu**: Firebase Realtime Database + Firebase Authentication
- **Video call (nâng cao)**: WebRTC (flutter_webrtc)

## Cấu trúc thư mục

```
FitDuel/
├── app/                              # Mã nguồn ứng dụng Flutter
│   └── lib/
│       ├── README.md                 # Tổng quan cấu trúc mã nguồn
│       ├── core/                     # Logic thuần, test được không cần thiết bị thật
│       └── features/                 # Mỗi tính năng 1 thư mục riêng (feature-first)
├── docs/                             # Đề cương, đề xuất dự án, sơ đồ Gantt, spec kỹ thuật
└── .github/                          # Issue/PR template, CI (sẽ thêm khi cần)
```

Quy ước bắt buộc cho cấu trúc code và tài liệu: xem mục *"Quy ước cấu trúc thư mục & tài liệu"* trong [CONTRIBUTING.md](CONTRIBUTING.md).

## Tài liệu

- [Đề xuất dự án (1 trang)](docs/De_xuat_du_an_1_trang.pdf)
- [Đề cương chi tiết (SRS sơ bộ)](docs/De_cuong_du_an_FitDuel.docx)
- [Sơ đồ Gantt (Excel, có biểu đồ)](docs/Gantt_FitDuel_chi_tiet.xlsx)
- [Spec công thức đo độ sâu chuyển động](docs/pose_estimation_spec.md)
- [Spec cơ chế mini-game](docs/game_mechanics_spec.md)
- [Spec schema dữ liệu Firebase](docs/firebase_schema.md)

## Đóng góp

Xem [CONTRIBUTING.md](CONTRIBUTING.md) để biết quy ước nhánh, commit, và quy trình pull request.

## License

Phát hành theo giấy phép [MIT](LICENSE).
