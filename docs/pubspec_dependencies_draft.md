# Draft: dependencies cho pubspec.yaml

Dán vào `app/pubspec.yaml` ngay sau khi chạy `flutter create .` xong (Bước 1):

```yaml
dependencies:
  flutter:
    sdk: flutter
  camera: ^0.11.0
  google_mlkit_pose_detection: ^0.14.1
  flame: ^1.18.0
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  firebase_database: ^11.1.4
```

Chạy `flutter pub add <tên-package>` cho từng cái thay vì gõ tay cũng được — tự lấy đúng version mới nhất tương thích. Số version trên chỉ là tham khảo tại thời điểm viết spec này (10/2026), kiểm tra lại trên pub.dev nếu cách đây đã lâu.
