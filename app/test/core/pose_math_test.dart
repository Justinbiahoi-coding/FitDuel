import 'package:flutter_test/flutter_test.dart';
import 'package:fitduel/core/pose_math.dart';

void main() {
  group('angleAtElbow', () {
    test('tay duỗi thẳng -> góc ~180°', () {
      const shoulder = Point2D(0, 0);
      const elbow = Point2D(1, 0);
      const wrist = Point2D(2, 0);
      expect(angleAtElbow(shoulder, elbow, wrist), closeTo(180, 0.001));
    });

    test('tay gập vuông góc -> góc ~90°', () {
      const shoulder = Point2D(0, 0);
      const elbow = Point2D(0, 1);
      const wrist = Point2D(1, 1);
      expect(angleAtElbow(shoulder, elbow, wrist), closeTo(90, 0.001));
    });

    test('khuỷu tay trùng vai hoặc cổ tay -> trả về 0 thay vì chia cho 0', () {
      const shoulder = Point2D(0, 0);
      const elbow = Point2D(0, 0);
      const wrist = Point2D(1, 1);
      expect(angleAtElbow(shoulder, elbow, wrist), 0);
    });
  });

  group('duTinCay', () {
    test('cả 3 điểm đều rõ (giống camera thấy trọn cánh tay) -> hợp lệ', () {
      expect(duTinCay(0.95, 0.90, 0.88), isTrue);
    });

    test('chỉ thấy mặt, ML Kit vẫn đoán ra vai/khuỷu/cổ tay với độ tin cậy '
        'thấp -> phải bị từ chối', () {
      // Số mô phỏng đúng tình huống thực tế đã gặp: camera chỉ thấy mặt,
      // ML Kit vẫn trả về tọa độ cho vai/khuỷu/cổ tay nhưng độ tin cậy thấp.
      expect(duTinCay(0.22, 0.15, 0.31), isFalse);
    });

    test('chỉ 1 trong 3 điểm thấp -> vẫn bị từ chối (không được lấy trung bình)', () {
      expect(duTinCay(0.95, 0.95, 0.40), isFalse);
    });

    test('đúng tại ngưỡng mặc định -> được chấp nhận (>=, không phải >)', () {
      expect(duTinCay(nguongTinCayMacDinh, nguongTinCayMacDinh, nguongTinCayMacDinh), isTrue);
    });

    test('dưới ngưỡng mặc định một chút -> bị từ chối', () {
      expect(duTinCay(nguongTinCayMacDinh - 0.01, 0.95, 0.95), isFalse);
    });

    test('ngưỡng tùy chỉnh thấp hơn -> chấp nhận số mà ngưỡng mặc định sẽ từ chối', () {
      expect(duTinCay(0.4, 0.4, 0.4, nguong: 0.3), isTrue);
    });
  });

  group('depthFromAngle', () {
    test('góc tại ngưỡng tối thiểu -> độ cao = 0', () {
      expect(depthFromAngle(gocMinHitDatSau), 0);
    });

    test('góc tại ngưỡng tối đa -> độ cao = 1', () {
      expect(depthFromAngle(gocMaxTayDuoi), 1);
    });

    test('góc giữa khoảng -> độ cao = 0.5', () {
      final giua = (gocMinHitDatSau + gocMaxTayDuoi) / 2;
      expect(depthFromAngle(giua), closeTo(0.5, 0.001));
    });

    test('góc vượt ngoài khoảng vẫn bị kẹp trong [0, 1]', () {
      expect(depthFromAngle(0), 0);
      expect(depthFromAngle(180), 1);
    });
  });
}
