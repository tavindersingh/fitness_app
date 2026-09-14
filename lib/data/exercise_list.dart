import 'package:fitness_app/models/exercise.dart';

List<Exercise> exercisesList = [
  Exercise(
    name: "Bench Press",
    bodyPart: "Chest",
    tool: "Barbell",
    imageUrl: "assets/images/benchpress.png",
  ),
  Exercise(
    name: "Squats",
    bodyPart: "Legs",
    tool: "Core",
    imageUrl: "assets/images/squats.png",
  ),
  Exercise(
    name: "DeadLift",
    bodyPart: "Back",
    tool: "Barbell",
    imageUrl: "assets/images/deadlift.png",
  ),
];

List<String> bodyParts = [
  "All",
  "Chest",
  "Legs",
  "Back",
  "Shoulder",
  "Arms",
  "Core",
];
