import 'package:drift/drift.dart' hide Column;
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
  List<DailySessionData> previousSessionsList = [];

  Future<void> fetchPreviousWorkoutSessionsList() async {
    // fetch all previous sessions
    final databaseProvider = DatabaseProvider();
    final database = databaseProvider.database;

    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );

    final thisWeek =
        await (database.select(database.dailySession)
              ..where((s) => s.startedAt.isBiggerOrEqualValue(startOfWeek))
              ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
            .get();

    final previous =
        await (database.select(database.dailySession)
              ..where((s) => s.startedAt.isSmallerThanValue(startOfWeek))
              ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
              ..limit(50))
            .get();

    if (!mounted) return;
    setState(() {
      sessionsList = thisWeek;
      previousSessionsList = previous;
    });
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
      body: sessionsList.isEmpty && previousSessionsList.isEmpty
          ? Center(
              child: Text(
                "No sessions found.",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
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
                sessionsList.isEmpty
                    ? Center(
                        child: Text(
                          "No session this week.",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Column(
                        children: sessionsList
                            .map(
                              (item) => WorkoutHistoryListItem(
                                dailySession: item,
                              ),
                            )
                            .toList(),
                      ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'PREVIOUS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                previousSessionsList.isEmpty
                    ? Center(
                        child: Text(
                          "No session found.",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Column(
                        children: previousSessionsList
                            .map(
                              (item) => WorkoutHistoryListItem(
                                dailySession: item,
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),
    );
  }
}
