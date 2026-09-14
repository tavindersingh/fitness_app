import 'package:fitness_app/exercise_detail_screen.dart';
import 'package:fitness_app/models/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;

  const ExerciseListItem({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExerciseDetailScreen(
              exercise: exercise,
            ),
          ),
        );
      },
      child: Container(
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
                exercise.imageUrl ?? "",
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
            Icon(
              Icons.chevron_right,
              color: Color(0xFF737477),
            ),
          ],
        ),
      ),
    );
  }
}
