import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/models/exercise_set.dart';

class Workout {
  final Exercise exercise;
  final List<ExerciseSet> sets;

  Workout({
    required this.exercise,
    this.sets = const [],
  });
}
