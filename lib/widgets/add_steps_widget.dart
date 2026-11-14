import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/database/queries.dart';
import 'package:fitness_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class AddStepsWidget extends StatefulWidget {
  const new({super.key});

  @override
  State<AddStepsWidget> createState() => _AddStepsWidgetState();
}

class _AddStepsWidgetState extends State<AddStepsWidget> {
  int newSteps = 0;
  bool isSaving = false;

  final int step = 100;

  @override
  void initState() {
    super.initState();
    loadTodaysSteps();
  }

  /// Starts from today's saved count, so saving again updates it.
  Future<void> loadTodaysSteps() async {
    final today = await findTodaysSteps(DatabaseProvider().database);
    if (!mounted || today == null) return;
    setState(() {
      newSteps = today.value;
    });
  }

  Future<void> saveSteps() async {
    if (isSaving) return;
    setState(() => isSaving = true);

    try {
      await saveTodaysSteps(DatabaseProvider().database, newSteps);
    } catch (e) {
      if (!mounted) return;
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't save your steps.")),
      );
      return;
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  void increment() {
    setState(() {
      newSteps += step;
    });
  }

  void decrement() {
    if (newSteps <= 0) {
      return;
    }

    setState(() {
      newSteps = newSteps < step ? 0 : newSteps - step;
    });
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
                "Add Steps",
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
                    newSteps.toString(),
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFF5F6F7),
                    ),
                  ),
                  Text(
                    'steps',
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
            onPressed: isSaving ? null : saveSteps,
          ),
        ],
      ),
    );
  }
}
