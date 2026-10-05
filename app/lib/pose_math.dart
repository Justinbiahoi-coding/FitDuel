import 'dart:math';

/// Một điểm 2D đơn giản, tách khỏi kiểu PoseLandmark của ML Kit để công thức
/// toán học ở đây không phụ thuộc camera/ML Kit — dễ test độc lập.
class Point2D {
  final double x;
  final double y;
  const Point2D(this.x, this.y);
}

/// Góc tại khuỷu tay (vai - khuỷu - cổ tay), tính bằng độ (0-180).
/// Xem docs/pose_estimation_spec.md.
double angleAtElbow(Point2D shoulder, Point2D elbow, Point2D wrist) {
  final v1x = shoulder.x - elbow.x;
  final v1y = shoulder.y - elbow.y;
  final v2x = wrist.x - elbow.x;
  final v2y = wrist.y - elbow.y;

  final mag1 = sqrt(v1x * v1x + v1y * v1y);
  final mag2 = sqrt(v2x * v2x + v2y * v2y);
  if (mag1 == 0 || mag2 == 0) return 0;

  final cosGoc = ((v1x * v2x + v1y * v2y) / (mag1 * mag2)).clamp(-1.0, 1.0);
  return acos(cosGoc) * 180 / pi;
}

/// Ngưỡng khởi điểm theo docs/pose_estimation_spec.md — cần hiệu chỉnh lại
/// bằng cách tự quay thử nhiều lần ở Bước 3.
const double gocMinHitDatSau = 70.0; // hít đất sâu -> độ cao = 0
const double gocMaxTayDuoi = 170.0; // tay duỗi thẳng -> độ cao = 1

/// Chuẩn hóa góc khuỷu tay thành giá trị điều khiển 0-1.
double depthFromAngle(
  double goc, {
  double gocMin = gocMinHitDatSau,
  double gocMax = gocMaxTayDuoi,
}) {
  return ((goc - gocMin) / (gocMax - gocMin)).clamp(0.0, 1.0);
}
