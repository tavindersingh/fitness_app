import 'package:fitness_app/widgets/log_weight_widget.dart';
import 'package:fitness_app/widgets/quick_adjust_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets('chips show signed labels and report their amount', (
    tester,
  ) async {
    final tapped = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuickAdjustChips<int>(
            amounts: const [-1000, -500, 500, 1000],
            format: NumberFormat.decimalPattern().format,
            onAdjust: tapped.add,
          ),
        ),
      ),
    );

    for (final label in ['−1,000', '−500', '+500', '+1,000']) {
      expect(find.text(label), findsOneWidget);
    }

    await tester.tap(find.text('+500'));
    await tester.tap(find.text('−1,000'));
    expect(tapped, [500, -1000]);
  });

  group('log weight sheet', () {
    Future<void> pumpSheet(WidgetTester tester, double previousWeight) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LogWeightWidget(previousWeight: previousWeight),
          ),
        ),
      );
    }

    Future<void> tapChip(WidgetTester tester, String label) async {
      await tester.tap(find.text(label));
      await tester.pump();
    }

    testWidgets('chips adjust the weight', (tester) async {
      await pumpSheet(tester, 70);
      expect(find.text('70.0'), findsOneWidget);

      await tapChip(tester, '+1');
      expect(find.text('71.0'), findsOneWidget);

      await tapChip(tester, '−0.5');
      expect(find.text('70.5'), findsOneWidget);

      await tapChip(tester, '+0.5');
      await tapChip(tester, '+0.5');
      expect(find.text('71.5'), findsOneWidget);

      await tapChip(tester, '−1');
      expect(find.text('70.5'), findsOneWidget);
    });

    testWidgets('weight never drops below 1 kg', (tester) async {
      await pumpSheet(tester, 1.4);

      await tapChip(tester, '−1');
      await tapChip(tester, '−1');

      expect(find.text('1.0'), findsOneWidget);
    });
  });
}
