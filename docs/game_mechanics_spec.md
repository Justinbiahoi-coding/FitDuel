# Spec: Cơ chế mini-game (Flappy Bird-style)

## Trạng thái game

`menu` → `countdown` (3-2-1) → `playing` → `gameOver`

## Nhân vật (chim)

- Vị trí Y: nhận trực tiếp từ `do_cao` (0-1) ở `pose_estimation_spec.md` — **không dùng vật lý rơi tự do kiểu Flappy Bird gốc** (không bấm để nhảy), vì chuyển động cơ thể đã là input liên tục rồi.
- Vị trí X: cố định (chim luôn đứng yên theo chiều ngang, chướng ngại vật chạy qua).
- Làm mượt chuyển động: dùng nội suy (lerp) giữa giá trị cũ và mới mỗi khung hình thay vì nhảy khựng, để chim bay mượt dù pose estimation có nhiễu nhẹ.

## Chướng ngại vật (ống/cột)

| Thông số | Giá trị khởi điểm (hiệu chỉnh sau khi test) |
|---|---|
| Khoảng cách giữa 2 cột | 2.5 giây |
| Khe hở (gap) | 35% chiều cao màn hình |
| Tốc độ di chuyển | tăng dần nhẹ theo thời gian sống sót (khó dần) |

## Va chạm & kết thúc trận

- Chạm cột → **thua ngay lập tức**, không chờ hết giờ.
- Nếu không chạm, trận có **giới hạn 60 giây** — hết giờ, ai có điểm cao hơn thắng; bằng điểm → hòa.
- Điểm: +1 mỗi lần vượt qua 1 cặp cột.

## Đồng bộ với đối thủ (nối với `firebase_schema.md`)

Mỗi khung hình (hoặc mỗi khi giá trị đổi đủ nhiều): ghi `birdY`, `score`, `alive` vào `matches/{matchId}/players/{uid}`. Vẽ nửa màn hình đối thủ bằng cách đọc lại đúng 3 giá trị này — **không đồng bộ vị trí chướng ngại vật** (mỗi máy tự sinh chướng ngại vật của chính nó theo cùng 1 công thức/seed, không cần gửi qua mạng).

## Kết thúc trận đấu

Khi 1 trong 2 người `alive = false` hoặc hết 60 giây → cả 2 client tự tính ai thắng dựa trên dữ liệu đã đồng bộ, ghi kết quả vào `history/{userId}/{matchId}`.
