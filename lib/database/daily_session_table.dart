import 'package:drift/drift.dart';

class DailySession extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer()();
  BoolColumn get isFinished => boolean().withDefault(
    const Constant(false),
  )();
  DateTimeColumn get startedAt =>
      dateTime().nullable().withDefault(Constant(null))();

  DateTimeColumn get finishedAt =>
      dateTime().nullable().withDefault(Constant(null))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // int workoutDurationInSeconds =
}
