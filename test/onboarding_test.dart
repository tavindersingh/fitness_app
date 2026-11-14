import 'package:fitness_app/onboarding/onboarding_preferences.dart';
import 'package:fitness_app/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpOnboarding(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          nextScreenBuilder: (_) => const Scaffold(body: Text('Main')),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('onboarding is not completed on a fresh install', () async {
    expect(await OnboardingPreferences.isCompleted(), isFalse);

    await OnboardingPreferences.markCompleted();

    expect(await OnboardingPreferences.isCompleted(), isTrue);
  });

  testWidgets('going through every page finishes onboarding', (tester) async {
    await pumpOnboarding(tester);
    expect(find.text('Welcome to your fitness tracker'), findsOneWidget);

    for (final title in [
      'Build your workout plans',
      'Track weight and steps',
      'See your progress',
    ]) {
      await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
    }

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Main'), findsOneWidget);
    expect(await OnboardingPreferences.isCompleted(), isTrue);
  });

  testWidgets('skipping also finishes onboarding', (tester) async {
    await pumpOnboarding(tester);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Main'), findsOneWidget);
    expect(await OnboardingPreferences.isCompleted(), isTrue);
  });
}
