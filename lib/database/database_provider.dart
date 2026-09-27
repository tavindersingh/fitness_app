import 'package:fitness_app/database/database.dart';

class DatabaseProvider {
  // 1. Create a private named constructor to prevent external instantiation
  DatabaseProvider._internal() {
    print("Intializing database");
    database = AppDatabase();
  }

  // 2. Create a static final instance of the class
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  // 3. Use a factory constructor to return the single instance
  factory DatabaseProvider() => _instance;

  late AppDatabase database;

  void doSomething() {
    print("Singleton is working!");
  }
}
