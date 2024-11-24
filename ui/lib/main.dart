import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'screens/homeScreen.dart';
import 'screens/reportScreen.dart';
import 'screens/menstrualCycleScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the cameras
  final cameras = await availableCameras();
  final firstCamera = cameras.first; // Use the first available camera

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    var baseTheme = ThemeData(brightness: Brightness.light);

    return MaterialApp(
      title: 'Team Dominos',
      theme: baseTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
      ),
      home: HomeScreen(camera: camera),
      // home: ReportScreen(
      //   report: {
      //     "heart": [0.5, "Sodium Nitrite", "Sulfur Dioxide"],
      //     "kidney": [-0.3, "Potassium Sorbate", "Propyl Paraben"],
      //     "skin": [0.7, "Propionic Acid", "Propyl Paraben"],
      //     "stomach": [-0.2, "Potassium Sorbate", "Sodium Erythorbate"]
      //   },
      // ),
      // home: MenstrualCycleScreen(),
    );
  }
}
