import 'package:fitness_app/models/exercise.dart';

List<Exercise> exercisesList = [
  Exercise(
    name: "Bench Press",
    bodyPart: "Chest",
    tool: "Barbell",
    imageUrl: "assets/images/benchpress.png",
    instructions: [
      "Lie on the bench with feet flat on the floor.",
      "Grip the bar slightly wider than shoulder-width.",
      "Lower the bar to mid-chest with control.",
      "Press back up until arms are fully extended.",
    ],
    featureImageUrl: "assets/images/benchpress.jpg",
  ),
  Exercise(
    name: "Squats",
    bodyPart: "Legs",
    tool: "Core",
    imageUrl: "assets/images/squats.png",
    instructions: [
      "Set the bar on your upper back, feet shoulder-width apart.",
      "Brace your core and bend your knees to lower down.",
      "Descend until thighs are parallel to the floor.",
      "Drive through your heels to stand back up.",
    ],
    featureImageUrl: "assets/images/squats.jpg",
  ),
  Exercise(
    name: "DeadLift",
    bodyPart: "Back",
    tool: "Barbell",
    imageUrl: "assets/images/deadlift.png",
    instructions: [
      "Stand with feet hip-width, bar over mid-foot.",
      "Hinge at the hips and grip the bar just outside your knees.",
      "Keep your back flat as you lift by extending hips and knees.",
      "Lower the bar back down with control.",
    ],
    featureImageUrl: "assets/images/deadlift.jpg",
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
