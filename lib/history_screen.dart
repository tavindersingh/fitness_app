import 'package:fitness_app/widgets/workout_history_list_item.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0b0d0f),
      appBar: AppBar(
        title: Text("History"),
        backgroundColor: Color(0xFF0b0d0f),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [Text('THIS WEEK'), WorkoutHistoryListItem()],
      ),
    );
  }
}
