import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fitness_app/database/daily_session_table.dart';
import 'package:fitness_app/database/plan_table.dart';
import 'package:fitness_app/database/session_exercise_status_table.dart';
import 'package:fitness_app/database/workout_exercise_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Plan, WorkoutExercise, DailySession, SessionExerciseStatus])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;
}

// Helper function to open the connection
QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
