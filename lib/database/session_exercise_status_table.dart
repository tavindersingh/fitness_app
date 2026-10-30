import 'package:drift/drift.dart';
import 'package:fitness_app/database/daily_session_table.dart';

class SessionExerciseStatus extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dailySessionId => integer().references(DailySession, #id)();
  IntColumn get exerciseId => integer()();
  BoolColumn get isFinished => boolean().withDefault(
    const Constant(false),
  )();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
