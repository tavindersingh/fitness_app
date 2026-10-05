import 'package:drift/drift.dart';

class SessionExerciseStatus extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dailySessionId => integer()();
  IntColumn get exerciseId => integer()();
  BoolColumn get isFinished => boolean().withDefault(
    const Constant(false),
  )();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
