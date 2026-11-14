import 'package:drift/drift.dart';

/// The user's profile. The app keeps a single row (see `getProfile`).
class UserProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  IntColumn get age => integer().nullable()();
  RealColumn get heightCm => real().nullable()();

  /// One of `fitnessGoals` in queries.dart, or null if not chosen yet.
  TextColumn get goal => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
