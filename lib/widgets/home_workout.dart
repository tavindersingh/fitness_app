import 'package:flutter/material.dart';

class HomeWorkout extends StatelessWidget {
  const HomeWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(Icons.sports_gymnastics_outlined, color: Colors.white),
              // SizedBox(width: 8),
              Text(
                "Today's Workout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          Text(
            "Upper Body Strength",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          Row(
            spacing: 4,
            children: [
              Text(
                "6 exercises",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text("·", style: TextStyle(color: Colors.white, fontSize: 16)),
              Text(
                "~45 min",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),

          ElevatedButton(onPressed: () {}, child: Text("Start Workout")),
        ],
      ),
    );
  }
}
