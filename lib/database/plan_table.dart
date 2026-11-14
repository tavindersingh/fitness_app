import 'package:drift/drift.dart';

class Plan extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
}

// class DailySession {
//   // id
//   // planId = UpperChest
//   // isFinished = false
//   // Date = 05/10/2026
// }

// class SessionExerciseStatus {
//   // id
//   // dailySessionId
//   // exerciseId = Bench Press
//   // Date = 05/10/2026
//   // isFinished
// }
