import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fitness_app/database/daily_session_table.dart';
import 'package:fitness_app/database/plan_table.dart';
import 'package:fitness_app/database/session_exercise_status_table.dart';
import 'package:fitness_app/database/steps_table.dart';
import 'package:fitness_app/database/user_profile_table.dart';
import 'package:fitness_app/database/weight_table.dart';
import 'package:fitness_app/database/workout_exercise_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Plan,
    WorkoutExercise,
    DailySession,
    SessionExerciseStatus,
    Weight,
    Steps,
    UserProfile,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Used by tests to run against an in-memory database.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Earlier versions added tables and columns without always bumping
      // schemaVersion, so an existing install may be missing any of them.
      // Create whatever is missing instead of relying on the version number.
      await _createMissingTablesAndColumns(m);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _createMissingTablesAndColumns(Migrator m) async {
    for (final table in allTables) {
      final existingColumns = await customSelect(
        'PRAGMA table_info("${table.actualTableName}")',
      ).map((row) => row.read<String>('name')).get();

      if (existingColumns.isEmpty) {
        await m.createTable(table);
        continue;
      }

      for (final column in table.$columns) {
        if (!existingColumns.contains(column.name)) {
          await m.addColumn(table, column);
        }
      }
    }
  }
}

// Helper function to open the connection
QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
