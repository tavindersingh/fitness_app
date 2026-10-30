import 'package:drift/drift.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/plan_table.dart';

class DailySession extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get planId => integer().references(Plan, #id)();

  BoolColumn get isFinished => boolean().withDefault(const Constant(false))();

  DateTimeColumn get startedAt =>
      dateTime().nullable().withDefault(Constant(null))();

  DateTimeColumn get finishedAt =>
      dateTime().nullable().withDefault(Constant(null))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  IntColumn get workoutDurationInSeconds =>
      integer().nullable().withDefault(Constant(0))();
}
