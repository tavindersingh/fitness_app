import 'package:fitness_app/models/exercise.dart';

List<Exercise> exercisesList = [
  Exercise(
    name: "Bench Press",
    bodyPart: "Chest",
    tool: "Barbell",
    imageUrl: "assets/images/benchpress.png",
  ),
  Exercise(name: "Squats", bodyPart: "Legs", tool: "Core"),
  Exercise(name: "DeadLift", bodyPart: "Back", tool: "Barbell"),
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
