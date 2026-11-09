import 'package:fitness_app/widgets/add_steps_widget.dart';
import 'package:fitness_app/widgets/log_weight_widget.dart';
import 'package:flutter/material.dart';

class LogActions extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              showModalBottomSheet(
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  return LogWeightWidget(
                    previousWeight: 70,
                  );
                },
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Color.fromRGBO(59, 91, 219, 0.14),
              foregroundColor: Color(0xFFA9B9F5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(14),
                side: BorderSide(
                  color: Color.fromRGBO(123, 147, 240, 0.25),
                ),
              ),
            ),
            child: Text(
              "+ Log Weight",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              showModalBottomSheet(
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  return AddStepsWidget(
                    previousSteps: 0,
                  );
                },
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Color.fromRGBO(61, 190, 142, 0.12),
              foregroundColor: Color(0xFF6FD6AE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(14),
                side: BorderSide(
                  color: Color.fromRGBO(61, 190, 142, 0.25),
                ),
              ),
            ),
            child: Text(
              "+ Add Steps",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
