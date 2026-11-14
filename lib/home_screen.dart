import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/database/queries.dart';
import 'package:fitness_app/select_session_screen.dart';
import 'package:fitness_app/widgets/app_button.dart';
import 'package:fitness_app/widgets/home_workout.dart';
import 'package:fitness_app/widgets/log_actions.dart';
import 'package:fitness_app/widgets/user_stat.dart';
import 'package:fitness_app/widgets/weekly_progress_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlanData? selectedWorkout;
  DailySessionData? dailySession;
  List<SessionExerciseStatusData> sessionExerciseStatusList = [];
  WeightData? weightData;
  double? weeklyWeightChange;
  StepsData? todaysSteps;
  WorkoutProgress? workoutProgress;

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
            : SingleChildScrollView(
                child: Column(
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
                              fetchTodaysSession();
                            },
                          ),
                    SizedBox(
                      height: 16,
                    ),
                    UserStat(
                      weight: weightData?.value,
                      weeklyWeightChange: weeklyWeightChange,
                      steps: todaysSteps?.value,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LogActions(
                      previousWeight: weightData?.value,
                      onLogged: fetchTodaysSession,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    WeeklyProgressCard(
                      workoutsThisWeek: workoutProgress?.workoutsThisWeek ?? 0,
                      weeklyGoal: weeklyWorkoutGoal,
                      streakDays: workoutProgress?.streakDays ?? 0,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> fetchTodaysSession() async {
    final database = DatabaseProvider().database;

    final previousWeight = await findLatestWeight(database);
    final weightChange = await findWeeklyWeightChange(database);
    final steps = await findTodaysSteps(database);
    final data = await findTodaysSession(database);
    final progress = await findWorkoutProgress(database);

    List<SessionExerciseStatusData> sessionExerciseStatusDataList = [];
    PlanData? planData;

    if (data != null) {
      sessionExerciseStatusDataList = await (database.select(
        database.sessionExerciseStatus,
      )..where((status) => status.dailySessionId.equals(data.id))).get();

      planData = await (database.select(
        database.plan,
      )..where((plan) => plan.id.equals(data.planId))).getSingleOrNull();
    }

    if (!mounted) return;

    setState(() {
      dailySession = planData == null ? null : data;
      selectedWorkout = planData;
      sessionExerciseStatusList = sessionExerciseStatusDataList;
      weightData = previousWeight;
      weeklyWeightChange = weightChange;
      todaysSteps = steps;
      workoutProgress = progress;
      isLoading = false;
    });
  }
}
