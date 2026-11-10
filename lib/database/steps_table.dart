import 'package:drift/drift.dart';

class Steps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get value => integer()();
  DateTimeColumn get loggedAt => dateTime().withDefault(currentDateAndTime)();
}
