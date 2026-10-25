import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/widgets/workout_history_list_item.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DailySessionData> sessionsList = [];

  Future<void> fetchPreviousWorkoutSessionsList() async {
    // fetch all previous sessions
    final databaseProvider = DatabaseProvider();
    final database = databaseProvider.database;

    sessionsList = await database.select(database.dailySession).get();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    fetchPreviousWorkoutSessionsList();
  }

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
        children: [
          Text(
            'THIS WEEK',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ...sessionsList.map(
            (item) => WorkoutHistoryListItem(
              dailySession: item,
            ),
          ),
        ],
      ),
    );
  }
}
