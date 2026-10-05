# Spec: Schema dữ liệu Firebase Realtime Database

## 1. Hàng đợi ghép trận — `queue/`

```
queue/
  {userId}: {
    joinedAt: <timestamp>,
    exercise: "pushup"
  }
```

- Client tự lắng nghe `queue/`, nếu thấy có đúng 2 người (kể cả mình) cùng `exercise` → người vào sau tạo match, cả 2 xoá mình khỏi `queue`.
- Cơ chế đơn giản (FIFO), không cần thuật toán ghép theo trình độ cho MVP.

## 2. Trận đấu — `matches/{matchId}/`

```
matches/{matchId}/
  exercise: "pushup"
  status: "playing" | "finished"
  startedAt: <timestamp>
  players/
    {userId_A}: {
      score: 0,
      birdY: 0.5,
      alive: true,
      lastUpdate: <timestamp>
    }
    {userId_B}: { ... cùng cấu trúc ... }
  winner: {userId} | null
```

- Mỗi client chỉ được ghi vào đúng node `players/{chính mình}` (ràng buộc qua Firebase Security Rules — xem mục 4).
- Mỗi client lắng nghe toàn bộ `players/` để vẽ lại nửa màn hình đối thủ.
- Tần suất ghi: 10-15 lần/giây (trùng tần suất xử lý pose ở spec kia) — không ghi nếu giá trị không đổi nhiều so với lần trước, để giảm số lần ghi không cần thiết.

## 3. Lịch sử trận đấu — `history/{userId}/{matchId}`

```
history/{userId}/{matchId}: {
  exercise: "pushup",
  result: "win" | "lose",
  score: 12,
  opponentId: {userId},
  playedAt: <timestamp>
}
```

- Ghi 1 lần duy nhất khi trận đấu kết thúc (status chuyển "finished").

## 4. Security Rules (nguyên tắc, viết chi tiết khi code Bước 6)

- Chỉ user đã đăng nhập mới đọc/ghi được.
- Mỗi user chỉ ghi được node `players/{uid}` của chính mình trong `matches/`, không ghi được node của đối thủ.
- `history/{userId}` chỉ chính user đó đọc được.

## 5. Xử lý mất kết nối (nâng cao, chưa cần cho MVP)

Dùng `onDisconnect()` của Firebase gắn vào `players/{uid}/alive = false` — nếu client mất mạng đột ngột, Firebase tự động cập nhật giúp, đối thủ biết ngay mà không cần chờ timeout.
