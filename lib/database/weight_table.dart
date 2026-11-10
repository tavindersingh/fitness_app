import 'package:drift/drift.dart';

class Weight extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get value => real()();
  DateTimeColumn get loggedAt => dateTime().withDefault(currentDateAndTime)();
}
