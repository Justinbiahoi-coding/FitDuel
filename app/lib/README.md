# lib/ — Tổng quan cấu trúc mã nguồn

Dự án tổ chức theo kiểu **feature-first**: mỗi tính năng lớn (pose estimation,
mini-game, ghép trận, màn hình chia đôi...) nằm trong 1 thư mục riêng dưới
`features/`, không trộn lẫn code của nhiều người vào chung 1 file. Lý do chọn
cách này thay vì gom theo loại file (`screens/`, `widgets/`, `models/` dùng
chung cho cả app): **5 người làm song song** (xem `docs/Gantt_FitDuel_chi_tiet.xlsx`)
— mỗi người phụ trách 1 feature, sửa trong thư mục của mình sẽ ít đụng code
người khác, giảm xung đột merge.

## Cấu trúc

```
lib/
├── main.dart              # Chỉ có nhiệm vụ: khởi tạo camera list, runApp().
│                           # KHÔNG viết logic nghiệp vụ ở đây.
├── core/                  # Logic thuần (không phụ thuộc UI/camera/Firebase),
│                           # dùng chung cho nhiều feature. Xem core/README.md.
└── features/               # Mỗi feature 1 thư mục con, có README.md riêng.
    └── pose_estimation/     # (đã có) Bước 2 — camera + ML Kit pose detection.
    # Các feature sau sẽ thêm vào đây khi code, mỗi cái kèm README.md riêng:
    #   mini_game/, matchmaking/, duel/, auth/ ...
```

## Luật bắt buộc khi thêm feature mới

Xem mục "Quy ước cấu trúc thư mục & tài liệu" trong `CONTRIBUTING.md` ở gốc
repo — tóm tắt: **mỗi thư mục con trong `lib/` phải có 1 file `README.md`**
giải thích chi tiết code bên trong, viết cùng lúc với code chứ không để dành
viết sau.

## Vì sao tách `core/` riêng khỏi `features/`

Code trong `core/` không được import bất cứ thứ gì từ `features/` hay các
package như `camera`/`google_mlkit_pose_detection` — đây là ràng buộc có chủ
đích để logic trong `core/` luôn **test được bằng số/giá trị giả lập**, không
cần camera/emulator thật (xem ví dụ `core/pose_math.dart` và
`test/core/pose_math_test.dart`).
