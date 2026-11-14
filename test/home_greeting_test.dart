import 'package:fitness_app/widgets/home_greeting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('greetingFor', () {
    DateTime at(int hour, [int minute = 0]) =>
        DateTime(2026, 11, 14, hour, minute);

    test('picks the part of the day', () {
      expect(greetingFor(at(5), null), 'Good Morning');
      expect(greetingFor(at(11, 59), null), 'Good Morning');
      expect(greetingFor(at(12), null), 'Good Afternoon');
      expect(greetingFor(at(16, 59), null), 'Good Afternoon');
      expect(greetingFor(at(17), null), 'Good Evening');
      expect(greetingFor(at(23), null), 'Good Evening');
      expect(greetingFor(at(2), null), 'Good Evening');
    });

    test('adds the first name only', () {
      expect(greetingFor(at(9), 'Tavinder Singh'), 'Good Morning, Tavinder');
      expect(greetingFor(at(9), '  Sam  '), 'Good Morning, Sam');
    });

    test('leaves out an empty name', () {
      expect(greetingFor(at(9), ''), 'Good Morning');
      expect(greetingFor(at(9), '   '), 'Good Morning');
    });
  });

  testWidgets('shows the date and greeting', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeGreeting(now: DateTime(2026, 11, 14, 18), name: 'Sam'),
      ),
    );

    expect(find.text('Saturday, Nov 14'), findsOneWidget);
    expect(find.text('Good Evening, Sam'), findsOneWidget);
  });
}
