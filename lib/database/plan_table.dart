import 'package:drift/drift.dart';

class Plan extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 6, max: 32)();
}

// class DailySession {
//   // id
//   // planId = UpperChest
//   // isFinished = false
//   // Date
// }

// class SessionExerciseStatus {
//   // id
//   // dailySessionId
//   // exerciseId = Bench Press
//   // Date
//   // isFinished
// }
