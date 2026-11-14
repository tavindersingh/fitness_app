import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/database/queries.dart';
import 'package:fitness_app/widgets/app_button.dart';
import 'package:fitness_app/widgets/quick_adjust_chips.dart';
import 'package:flutter/material.dart';

class LogWeightWidget extends StatefulWidget {
  final double previousWeight;

  const new({
    super.key,
    required this.previousWeight,
  });

  @override
  State<LogWeightWidget> createState() => _LogWeightWidgetState();
}

class _LogWeightWidgetState extends State<LogWeightWidget> {
  late double newWeight;

  final double step = 0.1;

  @override
  void initState() {
    super.initState();

    newWeight = _round(widget.previousWeight);
  }

  void increment() {
    setState(() {
      newWeight = _round(newWeight + step);
    });
  }

  void decrement() {
    if (newWeight <= step) {
      return;
    }

    setState(() {
      newWeight = _round(newWeight - step);
    });
  }

  double _round(double value) => (value * 10).roundToDouble() / 10;

  static const double minWeight = 1;
  static const double maxWeight = 500;

  /// Adds [amount] kg (negative to subtract), kept within a sensible range.
  void adjust(double amount) {
    setState(() {
      newWeight = _round(newWeight + amount).clamp(minWeight, maxWeight);
    });
  }

  bool isSaving = false;

  Future<void> logWeight() async {
    if (isSaving) return;
    setState(() => isSaving = true);

    try {
      await saveTodaysWeight(DatabaseProvider().database, newWeight);
    } catch (e) {
      if (!mounted) return;
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't save your weight.")),
      );
      return;
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: 34,
      ),
      color: Color(0xFF15181C),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Log Weight",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF5F6F7),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  decrement();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.06),
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(
                      width: 1,
                      color: Color.fromRGBO(255, 255, 255, 0.1),
                    ),
                  ),
                  child: Text(
                    '-',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color(0xFFF5F6F7),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    newWeight.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFF5F6F7),
                    ),
                  ),
                  Text(
                    'kg',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.45),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  increment();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.06),
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(
                      width: 1,
                      color: Color.fromRGBO(255, 255, 255, 0.1),
                    ),
                  ),
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color(0xFFF5F6F7),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          QuickAdjustChips<double>(
            amounts: const [-1, -0.5, 0.5, 1],
            format: (amount) => amount == amount.roundToDouble()
                ? amount.toStringAsFixed(0)
                : amount.toString(),
            onAdjust: adjust,
          ),
          SizedBox(
            height: 20,
          ),
          AppButton(
            label: 'Save',
            onPressed: isSaving ? null : logWeight,
          ),
        ],
      ),
    );
  }
}
