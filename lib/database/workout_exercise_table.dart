import 'package:drift/drift.dart';

class WorkoutExercise extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exerciseId => integer()();
  IntColumn get planId => integer()();
}
