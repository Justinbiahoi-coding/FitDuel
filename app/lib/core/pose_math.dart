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

/// Ngưỡng độ tin cậy tối thiểu để chấp nhận 1 điểm khớp ML Kit trả về.
/// ML Kit luôn trả đủ 33 điểm kể cả khi không thực sự nhìn thấy (nó "đoán"
/// dựa trên phần thấy được) — nếu không lọc theo ngưỡng này, app sẽ tính
/// toán trên những điểm bịa, ví dụ chỉ thấy mặt nhưng vẫn ra số vai/tay.
const double nguongTinCayMacDinh = 0.6;

/// Cả 3 điểm (vai, khuỷu, cổ tay) đều phải đạt ngưỡng tin cậy mới được coi
/// là phát hiện hợp lệ.
bool duTinCay(
  double shoulderLikelihood,
  double elbowLikelihood,
  double wristLikelihood, {
  double nguong = nguongTinCayMacDinh,
}) {
  return shoulderLikelihood >= nguong &&
      elbowLikelihood >= nguong &&
      wristLikelihood >= nguong;
}

/// Ngưỡng mặc định — dựa trên nghiên cứu computer vision về đếm hít đất
/// (Baek et al., IEEE CASE 2020: đáy <90°, rep chuẩn đo 50-70°, đỉnh >150°;
/// Suraju et al. 2025: đáy <90-95°, đỉnh >160°), KHÔNG phải số tự đoán.
/// Xem docs/pose_estimation_spec.md mục "Nghiên cứu đối chiếu" để biết đầy
/// đủ nguồn và lý do.
///
/// Lưu ý quan trọng: đây là ngưỡng CHUNG tạm dùng cho mọi người, không phải
/// ngưỡng cá nhân hoá. Không có chuẩn khoa học/quân đội nào dùng 1 số độ cố
/// định cho mọi người — họ đều dùng mốc vật lý (ngực chạm sàn) vì tỉ lệ
/// tay/thân khác nhau cho góc khuỷu khác nhau ở cùng 1 độ sâu thật, và sai
/// số đo của ML Kit (~12-16°) còn lớn hơn khoảng cách giữa các ngưỡng "hợp
/// lý" khác nhau. Khi code tính năng F10 "Hướng dẫn chuẩn bị trước trận"
/// (xem Vision Document), BẮT BUỘC thêm bước hiệu chỉnh riêng từng người
/// (2-3 rep mẫu lúc vào trận, tính ngưỡng theo % biên độ chuyển động của
/// chính người đó) — hai số dưới đây chỉ là giá trị dự phòng khi chưa hiệu
/// chỉnh, không phải số cuối cùng dùng trong sản phẩm thật.
///
/// Số đo thực tế của 1 thành viên nhóm (Bước 3, quay side-view): 77.9°/
/// 172.8-178.1° — nằm trong khoảng hợp lý so với nghiên cứu trên, nhưng
/// mẫu n=1 nên không dùng làm chuẩn chung được.
const double gocMinHitDatSau = 90.0; // đáy -> độ cao = 0
const double gocMaxTayDuoi = 160.0; // đỉnh -> độ cao = 1

/// Chuẩn hóa góc khuỷu tay thành giá trị điều khiển 0-1.
double depthFromAngle(
  double goc, {
  double gocMin = gocMinHitDatSau,
  double gocMax = gocMaxTayDuoi,
}) {
  return ((goc - gocMin) / (gocMax - gocMin)).clamp(0.0, 1.0);
}
