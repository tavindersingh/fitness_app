import 'package:fitness_app/data/fill_mock_data.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/main_screen.dart';
import 'package:fitness_app/onboarding/onboarding_preferences.dart';
import 'package:fitness_app/onboarding/onboarding_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseProvider();

  // Seed mock history in debug builds only. It runs once per install, and
  // finishes before the first screen loads so Home/Progress show it right away.
  if (kDebugMode) {
    try {
      await fillMockSessionsData();
    } catch (e) {
      debugPrint("Failed to seed mock data: $e");
    }
  }

  // Onboarding shows only until the user finishes or skips it once.
  final showOnboarding = !await OnboardingPreferences.isCompleted();

  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({super.key, this.showOnboarding = false});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.indigoAccent)),
      home: showOnboarding ? const OnboardingScreen() : const MainScreen(),
    );
  }
}
