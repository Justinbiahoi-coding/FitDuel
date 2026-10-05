import 'package:flutter_test/flutter_test.dart';
import 'package:fitduel/pose_math.dart';

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
