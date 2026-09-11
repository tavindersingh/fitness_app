import 'package:fitness_app/data/exercise_list.dart';
import 'package:fitness_app/widgets/exercise_list_item.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0b0d0f),
      appBar: AppBar(
        backgroundColor: Color(0xFF0b0d0f),
        title: Text(
          "Exercise Library",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: exercisesList.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                return ExerciseListItem(
                  exercise: exercisesList[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
