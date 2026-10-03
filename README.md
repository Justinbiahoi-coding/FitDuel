# FitDuel

**Ứng dụng ghép trận thể dục trực tuyến kết hợp mini-game**

Tập thể dục một mình (hít đất, squat, plank) dễ bị bỏ cuộc vì thiếu động lực. FitDuel biến buổi tập thành một trận đấu trực tuyến 1-1: camera điện thoại nhận diện chuyển động cơ thể theo thời gian thực và biến nó thành cần điều khiển của một mini-game (kiểu Flappy Bird) — bạn không chỉ thi ai làm được nhiều/lâu hơn, mà còn phải tập đúng nhịp để không thua ngay trong game.

> Đồ án môn học Nhập môn Công nghệ phần mềm.

## Trạng thái dự án

🚧 Đang ở giai đoạn lập kế hoạch — xem tài liệu trong [`docs/`](docs/). Mã nguồn ứng dụng sẽ được phát triển trong [`app/`](app/).

## Thành viên nhóm

| STT | Họ và tên | Vai trò | MSSV |
|-----|-----------|---------|------|
| 1   |           | Pose Estimation |      |
| 2   |           | Mini-game       |      |
| 3   |           | Backend & đồng bộ |    |
| 4   |           | Giao diện       |      |
| 5   |           | Kiểm thử & tài liệu |  |

## Tính năng chính (MVP)

- [ ] Đăng ký/Đăng nhập tài khoản
- [ ] Ghép trận trực tuyến 1-1
- [ ] Nhận diện tư thế qua camera theo thời gian thực (hít đất)
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
├── app/        # Mã nguồn ứng dụng Flutter (sẽ thêm khi bắt đầu code)
├── docs/       # Đề cương, đề xuất dự án, sơ đồ Gantt
└── .github/    # Issue/PR template, CI (sẽ thêm khi có code)
```

## Tài liệu

- [Đề xuất dự án (1 trang)](docs/De_xuat_du_an_1_trang.pdf)
- [Đề cương chi tiết (SRS sơ bộ)](docs/De_cuong_du_an_FitDuel.docx)
- [Sơ đồ Gantt (Excel, có biểu đồ)](docs/Gantt_FitDuel_chi_tiet.xlsx)

## Đóng góp

Xem [CONTRIBUTING.md](CONTRIBUTING.md) để biết quy ước nhánh, commit, và quy trình pull request.

## License

Phát hành theo giấy phép [MIT](LICENSE).
