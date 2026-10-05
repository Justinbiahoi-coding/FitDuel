# Quy ước đóng góp

## Quy ước nhánh (branch)

- `main` — nhánh ổn định, luôn chạy được, chỉ merge qua Pull Request.
- `feature/<ten-tinh-nang>` — nhánh phát triển tính năng mới. Ví dụ: `feature/pose-estimation`, `feature/mini-game-engine`.
- `fix/<ten-loi>` — nhánh sửa lỗi. Ví dụ: `fix/sync-delay`.
- `docs/<ten-tai-lieu>` — nhánh chỉ thay đổi tài liệu.

## Quy ước commit message

Theo chuẩn [Conventional Commits](https://www.conventionalcommits.org/):

```
<loại>: <mô tả ngắn gọn>

[nội dung chi tiết nếu cần]
```

Các loại thường dùng: `feat` (tính năng mới), `fix` (sửa lỗi), `docs` (tài liệu), `refactor`, `test`, `chore`.

Ví dụ:
```
feat: thêm module đo độ sâu chuyển động hít đất
fix: sửa lỗi đồng bộ điểm số bị trễ khi mất mạng
docs: cập nhật đề cương phần kiến trúc hệ thống
```

## Quy ước cấu trúc thư mục & tài liệu

Đồ án kéo dài 3 tháng, 5 người cùng code — không chấp nhận kiểu "vibecode"
(viết cho chạy được rồi thôi, không ai đọc lại hiểu nổi). Áp dụng bắt buộc
các luật sau cho mọi code mới:

1. **Tổ chức theo feature, không gom chung theo loại file.** Mỗi tính năng
   lớn (pose estimation, mini-game, ghép trận, màn hình chia đôi, đăng
   nhập...) nằm trong 1 thư mục riêng dưới `app/lib/features/<tên_feature>/`.
   Không tạo kiểu `screens/`, `widgets/` dùng chung cho mọi tính năng — lý do:
   5 người code song song (xem Gantt), gom theo feature giúp mỗi người sửa
   trong thư mục của mình, ít đụng code người khác khi merge.

2. **Logic thuần (không phụ thuộc camera/Firebase/UI) phải nằm trong
   `app/lib/core/`**, không được import package cần thiết bị thật. Mục đích:
   mọi thứ trong `core/` phải viết unit test bằng số/giá trị giả lập được,
   chạy trong vài giây, không cần mở emulator hay tự thao tác bằng tay mỗi
   lần kiểm tra lại.

3. **Mỗi thư mục con trong `app/lib/` (trừ thư mục chỉ chứa 1 file) phải có
   file `README.md` giải thích chi tiết code bên trong**, viết cùng lúc với
   code, không để dành viết sau. Nội dung README bắt buộc có:
   - Code này làm gì, thuộc bước nào trong kế hoạch.
   - Giải thích **từng hàm/class quan trọng**: nhận gì, trả gì, vì sao viết
     theo cách này (không phải chỉ lặp lại tên hàm).
   - Hạn chế đã biết / phần cố ý chưa làm (ghi rõ để người đọc sau không
     tưởng là bug hay bị quên).
   - File test tương ứng nằm ở đâu, test được gì / chưa test được gì.

   Xem `app/lib/core/README.md` và `app/lib/features/pose_estimation/README.md`
   làm ví dụ mẫu.

4. **Logic quan trọng (công thức tính toán, điều kiện quyết định thắng/thua,
   ngưỡng lọc dữ liệu...) bắt buộc có unit test**, không chờ đến lúc có lỗi
   mới viết. Tách phần logic đó ra khỏi code phụ thuộc camera/UI/Firebase
   (đặt trong `core/`) để test được bằng giá trị giả lập — xem
   `pose_math.dart` + `pose_math_test.dart` làm ví dụ.

5. **Trước khi commit, bắt buộc chạy sạch cả 3 lệnh:**
   ```bash
   flutter analyze   # không còn issue nào
   flutter test      # tất cả test pass
   flutter build apk --debug   # build thành công, không chỉ phân tích tĩnh suông
   ```

## Quy trình Pull Request

1. Tạo nhánh mới từ `main` theo đúng quy ước ở trên.
2. Code xong, tự kiểm tra lại trước khi tạo PR.
3. Mở Pull Request vào `main`, điền đầy đủ theo mẫu PR có sẵn.
4. Cần ít nhất 1 thành viên khác trong nhóm review và approve trước khi merge.
5. Dùng "Squash and merge" để giữ lịch sử commit trên `main` gọn gàng.

## Báo lỗi / đề xuất tính năng

Dùng mẫu có sẵn trong tab Issues của repo (Bug report / Feature request).
