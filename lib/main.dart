import 'package:fitness_app/branding/fittrack_logo.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseProvider();

  // Startup work (mock data, onboarding check) runs on the splash screen.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.indigoAccent),
        scaffoldBackgroundColor: FitTrackColors.background,
      ),
      home: const SplashScreen(),
    );
  }
}
