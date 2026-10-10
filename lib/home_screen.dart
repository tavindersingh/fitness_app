import 'package:drift/drift.dart' hide Column;
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/select_session_screen.dart';
import 'package:fitness_app/widgets/app_button.dart';
import 'package:fitness_app/widgets/home_workout.dart';
import 'package:fitness_app/widgets/user_stat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlanData? selectedWorkout;
  DailySessionData? dailySession;
  List<SessionExerciseStatusData> sessionExerciseStatusList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodaysSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0b0d0f),
      appBar: AppBar(
        backgroundColor: Color(0xFF0b0d0f),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Monday, Sep 7",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "Good Morning, Alex",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  selectedWorkout != null
                      ? HomeWorkout(
                          planData: selectedWorkout!,
                          dailySessionData: dailySession!,
                          sessionExerciseStatusDataList:
                              sessionExerciseStatusList,
                          updateStatusFromDatabase: () {
                            fetchTodaysSession();
                          },
                        )
                      : AppButton(
                          label: "Select Workout Session",
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SelectSessionScreen(),
                              ),
                            );
                          },
                        ),
                  UserStat(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            value: 0.75,
                            strokeWidth: 6,
                            color: Colors.indigoAccent,
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("3 of 4 workouts this week"),
                            Text("5 day streak · keep it up"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> fetchTodaysSession() async {
    final databaseProvider = DatabaseProvider();
    final database = databaseProvider.database;

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    DailySessionData? data =
        await (database.select(
              database.dailySession,
            )..where((session) {
              return session.createdAt.date.equals(currentDate);
            }))
            .getSingleOrNull();

    if (data == null) {
      return;
    }

    List<SessionExerciseStatusData> sessionExerciseStatusDataList =
        await (database.select(
          database.sessionExerciseStatus,
        )..where((session) => session.dailySessionId.equals(data.id))).get();

    PlanData? planData = await (database.select(
      database.plan,
    )..where((session) => session.id.equals(data.planId))).getSingleOrNull();

    if (planData == null) {
      return;
    }

    await Future.delayed(Duration(milliseconds: 100));

    setState(() {
      dailySession = data;
      selectedWorkout = planData;
      sessionExerciseStatusList = sessionExerciseStatusDataList;
      isLoading = false;
    });
  }
}
