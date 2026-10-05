import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'pose_math.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const FitDuelApp());
}

class FitDuelApp extends StatelessWidget {
  const FitDuelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitDuel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: const PoseTestScreen(),
    );
  }
}

/// Bước 2: màn hình chứng minh pipeline camera -> pose estimation -> công
/// thức góc khuỷu tay (xem docs/pose_estimation_spec.md). Chưa có game.
class PoseTestScreen extends StatefulWidget {
  const PoseTestScreen({super.key});

  @override
  State<PoseTestScreen> createState() => _PoseTestScreenState();
}

class _PoseTestScreenState extends State<PoseTestScreen> {
  CameraController? _controller;
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _isDetecting = false;
  String _debugText = 'Đang khởi động camera...';

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final camera = _cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras.first,
    );
    final controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup:
          Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    await controller.initialize();
    if (!mounted) return;
    setState(() => _controller = controller);
    await controller.startImageStream(_processImage);
  }

  void _processImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;
    try {
      final inputImage = _buildInputImage(image);
      if (inputImage == null) return;

      final poses = await _poseDetector.processImage(inputImage);
      if (poses.isEmpty) {
        setState(() => _debugText = 'Không phát hiện người trong khung hình.');
        return;
      }

      final pose = poses.first;
      final shoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
      final elbow = pose.landmarks[PoseLandmarkType.leftElbow];
      final wrist = pose.landmarks[PoseLandmarkType.leftWrist];

      final hopLe = shoulder != null &&
          elbow != null &&
          wrist != null &&
          duTinCay(shoulder.likelihood, elbow.likelihood, wrist.likelihood);

      if (!hopLe) {
        setState(() => _debugText =
            'Chưa thấy đủ rõ vai/khuỷu tay/cổ tay bên trái.\n'
            'Lùi camera ra để thấy trọn cánh tay, không chỉ mặt.\n'
            '(độ tin cậy: vai ${shoulder?.likelihood.toStringAsFixed(2) ?? "-"}, '
            'khuỷu ${elbow?.likelihood.toStringAsFixed(2) ?? "-"}, '
            'cổ tay ${wrist?.likelihood.toStringAsFixed(2) ?? "-"})');
        return;
      }

      final goc = angleAtElbow(
        Point2D(shoulder.x, shoulder.y),
        Point2D(elbow.x, elbow.y),
        Point2D(wrist.x, wrist.y),
      );
      final doCao = depthFromAngle(goc);

      setState(() {
        _debugText = 'Vai:     (${shoulder.x.toStringAsFixed(0)}, ${shoulder.y.toStringAsFixed(0)})\n'
            'Khuỷu:   (${elbow.x.toStringAsFixed(0)}, ${elbow.y.toStringAsFixed(0)})\n'
            'Cổ tay:  (${wrist.x.toStringAsFixed(0)}, ${wrist.y.toStringAsFixed(0)})\n'
            'Góc khuỷu tay: ${goc.toStringAsFixed(1)}°\n'
            'Độ cao (0-1): ${doCao.toStringAsFixed(2)}\n'
            'Độ tin cậy: vai ${shoulder.likelihood.toStringAsFixed(2)}, '
            'khuỷu ${elbow.likelihood.toStringAsFixed(2)}, '
            'cổ tay ${wrist.likelihood.toStringAsFixed(2)}';
      });
    } catch (e) {
      setState(() => _debugText = 'Lỗi: $e');
    } finally {
      _isDetecting = false;
    }
  }

  InputImage? _buildInputImage(CameraImage image) {
    final camera = _controller!.description;
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('FitDuel — Test Pose Estimation')),
      body: Stack(
        children: [
          CameraPreview(controller),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _debugText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
