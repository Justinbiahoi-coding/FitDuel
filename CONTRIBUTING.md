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

## Quy trình Pull Request

1. Tạo nhánh mới từ `main` theo đúng quy ước ở trên.
2. Code xong, tự kiểm tra lại trước khi tạo PR.
3. Mở Pull Request vào `main`, điền đầy đủ theo mẫu PR có sẵn.
4. Cần ít nhất 1 thành viên khác trong nhóm review và approve trước khi merge.
5. Dùng "Squash and merge" để giữ lịch sử commit trên `main` gọn gàng.

## Báo lỗi / đề xuất tính năng

Dùng mẫu có sẵn trong tab Issues của repo (Bug report / Feature request).
