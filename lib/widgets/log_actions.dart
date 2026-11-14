import 'package:fitness_app/widgets/add_steps_widget.dart';
import 'package:fitness_app/widgets/log_weight_widget.dart';
import 'package:flutter/material.dart';

class LogActions extends StatelessWidget {
  /// The latest logged weight, used as the starting value in the sheet.
  final double? previousWeight;

  /// Called after a weight or step count has been saved.
  final VoidCallback? onLogged;

  const new({super.key, this.previousWeight, this.onLogged});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final saved = await showModalBottomSheet<bool>(
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  return LogWeightWidget(
                    previousWeight: previousWeight ?? 70,
                  );
                },
              );
              if (saved == true) onLogged?.call();
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
            onPressed: () async {
              final saved = await showModalBottomSheet<bool>(
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  return const AddStepsWidget();
                },
              );
              if (saved == true) onLogged?.call();
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
