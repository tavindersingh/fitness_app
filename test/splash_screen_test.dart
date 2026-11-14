import 'dart:async';

import 'package:fitness_app/onboarding/onboarding_screen.dart';
import 'package:fitness_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpSplash(
    WidgetTester tester,
    Future<bool> Function() prepare,
  ) {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    return tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(
          minimumDuration: const Duration(milliseconds: 1500),
          prepare: prepare,
        ),
      ),
    );
  }

  testWidgets('shows the brand, then onboarding after the delay', (
    tester,
  ) async {
    await pumpSplash(tester, () async => true);

    expect(find.text('FitTrack'), findsOneWidget);
    expect(find.text('Train. Track. Progress.'), findsOneWidget);

    // Startup work is already done, but the splash stays for the minimum time.
    await tester.pump(const Duration(milliseconds: 1400));
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  testWidgets('waits for slow startup work before leaving', (tester) async {
    final prepared = Completer<bool>();
    await pumpSplash(tester, () => prepared.future);

    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(SplashScreen), findsOneWidget);

    prepared.complete(true);
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
