import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/widgets/app_checkbox.dart';
import 'package:flutter/material.dart';

class SelectExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final bool isSelected;
  final Function(int id) onExerciseSelected;
  final Function(int id) onExerciseUnselected;

  const SelectExerciseListItem({
    super.key,
    required this.exercise,
    this.isSelected = false,
    required this.onExerciseSelected,
    required this.onExerciseUnselected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xFF15181c),
        border: Border.all(
          color: Color(0xFF272a2e),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFF272a2e),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              exercise.imageUrl,
              // color: Colors.white,
              width: 48,
              height: 48,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Row(
                  spacing: 6,
                  children: [
                    Text(
                      exercise.bodyPart,
                      style: TextStyle(
                        color: Color(0xFF737477),
                      ),
                    ),
                    Text(
                      "·",
                      style: TextStyle(
                        color: Color(0xFF737477),
                      ),
                    ),
                    Text(
                      exercise.tool,
                      style: TextStyle(
                        color: Color(0xFF737477),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppCheckbox(
            isSelected: isSelected,
            onClick: (value) {
              if (isSelected) {
                onExerciseUnselected(exercise.id);
              } else {
                onExerciseSelected(exercise.id);
              }
            },
          ),
          // GestureDetector(
          //   onTap: () {
          //     if (isSelected) {
          //       onExerciseUnselected(exercise.id);
          //     } else {
          //       onExerciseSelected(exercise.id);
          //     }
          //   },
          //   child: Container(
          //     width: 28,
          //     height: 28,
          //     decoration: BoxDecoration(
          //       color: isSelected ? Colors.green : Colors.transparent,
          //       borderRadius: BorderRadius.circular(100),
          //       border: Border.all(
          //         color: isSelected ? Colors.green : Colors.grey,
          //         width: 2,
          //       ),
          //     ),
          //     child: isSelected
          //         ? Center(
          //             child: Icon(
          //               Icons.check_rounded,
          //               color: Color(0xFF15181c),
          //               fontWeight: FontWeight.bold,
          //             ),
          //           )
          //         : null,
          //   ),
          // ),
        ],
      ),
    );
  }
}
