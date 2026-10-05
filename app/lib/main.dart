import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'features/pose_estimation/pose_estimation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(FitDuelApp(cameras: cameras));
}

class FitDuelApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const FitDuelApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitDuel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: PoseEstimationScreen(cameras: cameras),
    );
  }
}
