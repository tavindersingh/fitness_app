import 'package:drift/drift.dart' hide Column;
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/widgets/app_button.dart';
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

    newWeight = widget.previousWeight;
  }

  void increment() {
    setState(() {
      newWeight += step;
    });
  }

  void decrement() {
    if (newWeight <= 0) {
      return;
    }

    setState(() {
      newWeight -= step;
    });
  }

  Future<void> logWeight() async {
    final databaseProvider = DatabaseProvider();
    final database = databaseProvider.database;

    DateTime now = DateTime.now();

    DateTime onlyDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final existingTodaysWeight =
        await (database.select(
              database.weight,
            )..where(
              (weight) => weight.loggedAt.isBiggerOrEqualValue(onlyDate),
            ))
            .getSingleOrNull();

    if (existingTodaysWeight != null) {
      await (database.update(database.weight)
            ..where((weight) => weight.loggedAt.isBiggerOrEqualValue(onlyDate)))
          .write(
            WeightCompanion(
              value: Value(newWeight),
            ),
          );
    } else {
      await database
          .into(database.weight)
          .insert(
            WeightCompanion(
              value: Value(newWeight),
            ),
          );
    }
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
          SizedBox(
            height: 20,
          ),
          AppButton(
            label: 'Save',
            onPressed: logWeight,
          ),
        ],
      ),
    );
  }
}
