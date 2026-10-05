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

- `GOC_MAX` ≈ 170° (tay duỗi thẳng — map thành độ_cao = 1, chim bay lên)
- `GOC_MIN` ≈ 70° (hít đất sâu — map thành độ_cao = 0, chim bay xuống)

**Ngưỡng cụ thể cần hiệu chỉnh bằng cách tự quay thử nhiều lần ở Bước 3** (tùy vóc dáng, góc đặt camera) — 2 số trên chỉ là điểm khởi đầu, không phải số cuối cùng.

## Chống gian lận tư thế (kiểm tra lưng thẳng)

Tính góc giữa vai-hông theo phương ngang so với mặt đất — nếu lệch quá X độ (lưng cong/võng), coi lần đó là "không hợp lệ", không tính điểm dù tay có gập đúng.

## Tần suất xử lý

Mục tiêu ≥ 15 khung hình/giây — nếu máy yếu bị giật, cân nhắc xử lý cách 1 khung hình thay vì mọi khung hình (bỏ bớt 1/2 số khung) để giữ độ mượt của game.
