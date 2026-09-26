import 'package:fitness_app/select_session_screen.dart';
import 'package:fitness_app/widgets/app_button.dart';
import 'package:fitness_app/widgets/home_workout.dart';
import 'package:fitness_app/widgets/user_stat.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        child: Column(
          children: [
            AppButton(
              label: "Select Workout Session",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectSessionScreen(),
                  ),
                );
              },
            ),
            HomeWorkout(),
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
}
