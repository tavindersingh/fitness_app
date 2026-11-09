import 'package:fitness_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class AddStepsWidget extends StatefulWidget {
  final double previousSteps;

  const new({
    super.key,
    required this.previousSteps,
  });

  @override
  State<AddStepsWidget> createState() => _AddStepsWidgetState();
}

class _AddStepsWidgetState extends State<AddStepsWidget> {
  late double newSteps;

  final double step = 100;

  @override
  void initState() {
    super.initState();

    newSteps = widget.previousSteps;
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
      newSteps -= step;
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
                    newSteps.toStringAsFixed(0),
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
