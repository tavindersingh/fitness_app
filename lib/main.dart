import 'package:fitness_app/data/fill_mock_data.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/main_screen.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.indigoAccent)),
      home: MainScreen(),
    );
  }
}
