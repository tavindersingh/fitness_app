// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PlanTable extends Plan with TableInfo<$PlanTable, PlanData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $PlanTable createAlias(String alias) {
    return $PlanTable(attachedDatabase, alias);
  }
}

class PlanData extends DataClass implements Insertable<PlanData> {
  final int id;
  final String name;
  const PlanData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  PlanCompanion toCompanion(bool nullToAbsent) {
    return PlanCompanion(id: Value(id), name: Value(name));
  }

  factory PlanData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  PlanData copyWith({int? id, String? name}) =>
      PlanData(id: id ?? this.id, name: name ?? this.name);
  PlanData copyWithCompanion(PlanCompanion data) {
    return PlanData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanData && other.id == this.id && other.name == this.name);
}

class PlanCompanion extends UpdateCompanion<PlanData> {
  final Value<int> id;
  final Value<String> name;
  const PlanCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  PlanCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<PlanData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  PlanCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return PlanCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExerciseTable extends WorkoutExercise
    with TableInfo<$WorkoutExerciseTable, WorkoutExerciseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExerciseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, exerciseId, planId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercise';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExerciseData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExerciseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExerciseData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      )!,
    );
  }

  @override
  $WorkoutExerciseTable createAlias(String alias) {
    return $WorkoutExerciseTable(attachedDatabase, alias);
  }
}

class WorkoutExerciseData extends DataClass
    implements Insertable<WorkoutExerciseData> {
  final int id;
  final int exerciseId;
  final int planId;
  const WorkoutExerciseData({
    required this.id,
    required this.exerciseId,
    required this.planId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['plan_id'] = Variable<int>(planId);
    return map;
  }

  WorkoutExerciseCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExerciseCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      planId: Value(planId),
    );
  }

  factory WorkoutExerciseData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExerciseData(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      planId: serializer.fromJson<int>(json['planId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'planId': serializer.toJson<int>(planId),
    };
  }

  WorkoutExerciseData copyWith({int? id, int? exerciseId, int? planId}) =>
      WorkoutExerciseData(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        planId: planId ?? this.planId,
      );
  WorkoutExerciseData copyWithCompanion(WorkoutExerciseCompanion data) {
    return WorkoutExerciseData(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      planId: data.planId.present ? data.planId.value : this.planId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExerciseData(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('planId: $planId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exerciseId, planId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExerciseData &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.planId == this.planId);
}

class WorkoutExerciseCompanion extends UpdateCompanion<WorkoutExerciseData> {
  final Value<int> id;
  final Value<int> exerciseId;
  final Value<int> planId;
  const WorkoutExerciseCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.planId = const Value.absent(),
  });
  WorkoutExerciseCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseId,
    required int planId,
  }) : exerciseId = Value(exerciseId),
       planId = Value(planId);
  static Insertable<WorkoutExerciseData> custom({
    Expression<int>? id,
    Expression<int>? exerciseId,
    Expression<int>? planId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (planId != null) 'plan_id': planId,
    });
  }

  WorkoutExerciseCompanion copyWith({
    Value<int>? id,
    Value<int>? exerciseId,
    Value<int>? planId,
  }) {
    return WorkoutExerciseCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      planId: planId ?? this.planId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExerciseCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('planId: $planId')
          ..write(')'))
        .toString();
  }
}

class $DailySessionTable extends DailySession
    with TableInfo<$DailySessionTable, DailySessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySessionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFinishedMeta = const VerificationMeta(
    'isFinished',
  );
  @override
  late final GeneratedColumn<bool> isFinished = GeneratedColumn<bool>(
    'is_finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_finished" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, planId, isFinished, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_session';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailySessionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('is_finished')) {
      context.handle(
        _isFinishedMeta,
        isFinished.isAcceptableOrUnknown(data['is_finished']!, _isFinishedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailySessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySessionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      )!,
      isFinished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_finished'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DailySessionTable createAlias(String alias) {
    return $DailySessionTable(attachedDatabase, alias);
  }
}

class DailySessionData extends DataClass
    implements Insertable<DailySessionData> {
  final int id;
  final int planId;
  final bool isFinished;
  final DateTime createdAt;
  const DailySessionData({
    required this.id,
    required this.planId,
    required this.isFinished,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['is_finished'] = Variable<bool>(isFinished);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailySessionCompanion toCompanion(bool nullToAbsent) {
    return DailySessionCompanion(
      id: Value(id),
      planId: Value(planId),
      isFinished: Value(isFinished),
      createdAt: Value(createdAt),
    );
  }

  factory DailySessionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySessionData(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'isFinished': serializer.toJson<bool>(isFinished),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailySessionData copyWith({
    int? id,
    int? planId,
    bool? isFinished,
    DateTime? createdAt,
  }) => DailySessionData(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    isFinished: isFinished ?? this.isFinished,
    createdAt: createdAt ?? this.createdAt,
  );
  DailySessionData copyWithCompanion(DailySessionCompanion data) {
    return DailySessionData(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      isFinished: data.isFinished.present
          ? data.isFinished.value
          : this.isFinished,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySessionData(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('isFinished: $isFinished, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, isFinished, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySessionData &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.isFinished == this.isFinished &&
          other.createdAt == this.createdAt);
}

class DailySessionCompanion extends UpdateCompanion<DailySessionData> {
  final Value<int> id;
  final Value<int> planId;
  final Value<bool> isFinished;
  final Value<DateTime> createdAt;
  const DailySessionCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailySessionCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    this.isFinished = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : planId = Value(planId);
  static Insertable<DailySessionData> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<bool>? isFinished,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (isFinished != null) 'is_finished': isFinished,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailySessionCompanion copyWith({
    Value<int>? id,
    Value<int>? planId,
    Value<bool>? isFinished,
    Value<DateTime>? createdAt,
  }) {
    return DailySessionCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      isFinished: isFinished ?? this.isFinished,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (isFinished.present) {
      map['is_finished'] = Variable<bool>(isFinished.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySessionCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('isFinished: $isFinished, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SessionExerciseStatusTable extends SessionExerciseStatus
    with TableInfo<$SessionExerciseStatusTable, SessionExerciseStatusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionExerciseStatusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dailySessionIdMeta = const VerificationMeta(
    'dailySessionId',
  );
  @override
  late final GeneratedColumn<int> dailySessionId = GeneratedColumn<int>(
    'daily_session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFinishedMeta = const VerificationMeta(
    'isFinished',
  );
  @override
  late final GeneratedColumn<bool> isFinished = GeneratedColumn<bool>(
    'is_finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_finished" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailySessionId,
    exerciseId,
    isFinished,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_exercise_status';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionExerciseStatusData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_session_id')) {
      context.handle(
        _dailySessionIdMeta,
        dailySessionId.isAcceptableOrUnknown(
          data['daily_session_id']!,
          _dailySessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailySessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('is_finished')) {
      context.handle(
        _isFinishedMeta,
        isFinished.isAcceptableOrUnknown(data['is_finished']!, _isFinishedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionExerciseStatusData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionExerciseStatusData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailySessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      isFinished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_finished'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SessionExerciseStatusTable createAlias(String alias) {
    return $SessionExerciseStatusTable(attachedDatabase, alias);
  }
}

class SessionExerciseStatusData extends DataClass
    implements Insertable<SessionExerciseStatusData> {
  final int id;
  final int dailySessionId;
  final int exerciseId;
  final bool isFinished;
  final DateTime createdAt;
  const SessionExerciseStatusData({
    required this.id,
    required this.dailySessionId,
    required this.exerciseId,
    required this.isFinished,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_session_id'] = Variable<int>(dailySessionId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['is_finished'] = Variable<bool>(isFinished);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionExerciseStatusCompanion toCompanion(bool nullToAbsent) {
    return SessionExerciseStatusCompanion(
      id: Value(id),
      dailySessionId: Value(dailySessionId),
      exerciseId: Value(exerciseId),
      isFinished: Value(isFinished),
      createdAt: Value(createdAt),
    );
  }

  factory SessionExerciseStatusData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionExerciseStatusData(
      id: serializer.fromJson<int>(json['id']),
      dailySessionId: serializer.fromJson<int>(json['dailySessionId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailySessionId': serializer.toJson<int>(dailySessionId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'isFinished': serializer.toJson<bool>(isFinished),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SessionExerciseStatusData copyWith({
    int? id,
    int? dailySessionId,
    int? exerciseId,
    bool? isFinished,
    DateTime? createdAt,
  }) => SessionExerciseStatusData(
    id: id ?? this.id,
    dailySessionId: dailySessionId ?? this.dailySessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    isFinished: isFinished ?? this.isFinished,
    createdAt: createdAt ?? this.createdAt,
  );
  SessionExerciseStatusData copyWithCompanion(
    SessionExerciseStatusCompanion data,
  ) {
    return SessionExerciseStatusData(
      id: data.id.present ? data.id.value : this.id,
      dailySessionId: data.dailySessionId.present
          ? data.dailySessionId.value
          : this.dailySessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      isFinished: data.isFinished.present
          ? data.isFinished.value
          : this.isFinished,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionExerciseStatusData(')
          ..write('id: $id, ')
          ..write('dailySessionId: $dailySessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('isFinished: $isFinished, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dailySessionId, exerciseId, isFinished, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionExerciseStatusData &&
          other.id == this.id &&
          other.dailySessionId == this.dailySessionId &&
          other.exerciseId == this.exerciseId &&
          other.isFinished == this.isFinished &&
          other.createdAt == this.createdAt);
}

class SessionExerciseStatusCompanion
    extends UpdateCompanion<SessionExerciseStatusData> {
  final Value<int> id;
  final Value<int> dailySessionId;
  final Value<int> exerciseId;
  final Value<bool> isFinished;
  final Value<DateTime> createdAt;
  const SessionExerciseStatusCompanion({
    this.id = const Value.absent(),
    this.dailySessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionExerciseStatusCompanion.insert({
    this.id = const Value.absent(),
    required int dailySessionId,
    required int exerciseId,
    this.isFinished = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : dailySessionId = Value(dailySessionId),
       exerciseId = Value(exerciseId);
  static Insertable<SessionExerciseStatusData> custom({
    Expression<int>? id,
    Expression<int>? dailySessionId,
    Expression<int>? exerciseId,
    Expression<bool>? isFinished,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailySessionId != null) 'daily_session_id': dailySessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (isFinished != null) 'is_finished': isFinished,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionExerciseStatusCompanion copyWith({
    Value<int>? id,
    Value<int>? dailySessionId,
    Value<int>? exerciseId,
    Value<bool>? isFinished,
    Value<DateTime>? createdAt,
  }) {
    return SessionExerciseStatusCompanion(
      id: id ?? this.id,
      dailySessionId: dailySessionId ?? this.dailySessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      isFinished: isFinished ?? this.isFinished,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailySessionId.present) {
      map['daily_session_id'] = Variable<int>(dailySessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (isFinished.present) {
      map['is_finished'] = Variable<bool>(isFinished.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionExerciseStatusCompanion(')
          ..write('id: $id, ')
          ..write('dailySessionId: $dailySessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('isFinished: $isFinished, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlanTable plan = $PlanTable(this);
  late final $WorkoutExerciseTable workoutExercise = $WorkoutExerciseTable(
    this,
  );
  late final $DailySessionTable dailySession = $DailySessionTable(this);
  late final $SessionExerciseStatusTable sessionExerciseStatus =
      $SessionExerciseStatusTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    plan,
    workoutExercise,
    dailySession,
    sessionExerciseStatus,
  ];
}

typedef $$PlanTableCreateCompanionBuilder = PlanCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$PlanTableUpdateCompanionBuilder = PlanCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$PlanTableFilterComposer extends Composer<_$AppDatabase, $PlanTable> {
  $$PlanTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlanTableOrderingComposer extends Composer<_$AppDatabase, $PlanTable> {
  $$PlanTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanTable> {
  $$PlanTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$PlanTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanTable,
          PlanData,
          $$PlanTableFilterComposer,
          $$PlanTableOrderingComposer,
          $$PlanTableAnnotationComposer,
          $$PlanTableCreateCompanionBuilder,
          $$PlanTableUpdateCompanionBuilder,
          (PlanData, BaseReferences<_$AppDatabase, $PlanTable, PlanData>),
          PlanData,
          PrefetchHooks Function()
        > {
  $$PlanTableTableManager(_$AppDatabase db, $PlanTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => PlanCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => PlanCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanTable, PlanData>(table),
                  BaseReferences<_$AppDatabase, $PlanTable, PlanData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlanTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanTable,
      PlanData,
      $$PlanTableFilterComposer,
      $$PlanTableOrderingComposer,
      $$PlanTableAnnotationComposer,
      $$PlanTableCreateCompanionBuilder,
      $$PlanTableUpdateCompanionBuilder,
      (PlanData, BaseReferences<_$AppDatabase, $PlanTable, PlanData>),
      PlanData,
      PrefetchHooks Function()
    >;
typedef $$WorkoutExerciseTableCreateCompanionBuilder =
    WorkoutExerciseCompanion Function({
      Value<int> id,
      required int exerciseId,
      required int planId,
    });
typedef $$WorkoutExerciseTableUpdateCompanionBuilder =
    WorkoutExerciseCompanion Function({
      Value<int> id,
      Value<int> exerciseId,
      Value<int> planId,
    });

class $$WorkoutExerciseTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseTable> {
  $$WorkoutExerciseTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutExerciseTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseTable> {
  $$WorkoutExerciseTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutExerciseTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseTable> {
  $$WorkoutExerciseTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);
}

class $$WorkoutExerciseTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExerciseTable,
          WorkoutExerciseData,
          $$WorkoutExerciseTableFilterComposer,
          $$WorkoutExerciseTableOrderingComposer,
          $$WorkoutExerciseTableAnnotationComposer,
          $$WorkoutExerciseTableCreateCompanionBuilder,
          $$WorkoutExerciseTableUpdateCompanionBuilder,
          (
            WorkoutExerciseData,
            BaseReferences<
              _$AppDatabase,
              $WorkoutExerciseTable,
              WorkoutExerciseData
            >,
          ),
          WorkoutExerciseData,
          PrefetchHooks Function()
        > {
  $$WorkoutExerciseTableTableManager(
    _$AppDatabase db,
    $WorkoutExerciseTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExerciseTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExerciseTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExerciseTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> planId = const Value.absent(),
              }) => WorkoutExerciseCompanion(
                id: id,
                exerciseId: exerciseId,
                planId: planId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exerciseId,
                required int planId,
              }) => WorkoutExerciseCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                planId: planId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutExerciseTable, WorkoutExerciseData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $WorkoutExerciseTable,
                    WorkoutExerciseData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutExerciseTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExerciseTable,
      WorkoutExerciseData,
      $$WorkoutExerciseTableFilterComposer,
      $$WorkoutExerciseTableOrderingComposer,
      $$WorkoutExerciseTableAnnotationComposer,
      $$WorkoutExerciseTableCreateCompanionBuilder,
      $$WorkoutExerciseTableUpdateCompanionBuilder,
      (
        WorkoutExerciseData,
        BaseReferences<
          _$AppDatabase,
          $WorkoutExerciseTable,
          WorkoutExerciseData
        >,
      ),
      WorkoutExerciseData,
      PrefetchHooks Function()
    >;
typedef $$DailySessionTableCreateCompanionBuilder =
    DailySessionCompanion Function({
      Value<int> id,
      required int planId,
      Value<bool> isFinished,
      Value<DateTime> createdAt,
    });
typedef $$DailySessionTableUpdateCompanionBuilder =
    DailySessionCompanion Function({
      Value<int> id,
      Value<int> planId,
      Value<bool> isFinished,
      Value<DateTime> createdAt,
    });

class $$DailySessionTableFilterComposer
    extends Composer<_$AppDatabase, $DailySessionTable> {
  $$DailySessionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailySessionTableOrderingComposer
    extends Composer<_$AppDatabase, $DailySessionTable> {
  $$DailySessionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailySessionTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailySessionTable> {
  $$DailySessionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DailySessionTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailySessionTable,
          DailySessionData,
          $$DailySessionTableFilterComposer,
          $$DailySessionTableOrderingComposer,
          $$DailySessionTableAnnotationComposer,
          $$DailySessionTableCreateCompanionBuilder,
          $$DailySessionTableUpdateCompanionBuilder,
          (
            DailySessionData,
            BaseReferences<_$AppDatabase, $DailySessionTable, DailySessionData>,
          ),
          DailySessionData,
          PrefetchHooks Function()
        > {
  $$DailySessionTableTableManager(_$AppDatabase db, $DailySessionTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailySessionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailySessionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailySessionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> planId = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailySessionCompanion(
                id: id,
                planId: planId,
                isFinished: isFinished,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int planId,
                Value<bool> isFinished = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailySessionCompanion.insert(
                id: id,
                planId: planId,
                isFinished: isFinished,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailySessionTable, DailySessionData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailySessionTable,
                    DailySessionData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailySessionTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailySessionTable,
      DailySessionData,
      $$DailySessionTableFilterComposer,
      $$DailySessionTableOrderingComposer,
      $$DailySessionTableAnnotationComposer,
      $$DailySessionTableCreateCompanionBuilder,
      $$DailySessionTableUpdateCompanionBuilder,
      (
        DailySessionData,
        BaseReferences<_$AppDatabase, $DailySessionTable, DailySessionData>,
      ),
      DailySessionData,
      PrefetchHooks Function()
    >;
typedef $$SessionExerciseStatusTableCreateCompanionBuilder =
    SessionExerciseStatusCompanion Function({
      Value<int> id,
      required int dailySessionId,
      required int exerciseId,
      Value<bool> isFinished,
      Value<DateTime> createdAt,
    });
typedef $$SessionExerciseStatusTableUpdateCompanionBuilder =
    SessionExerciseStatusCompanion Function({
      Value<int> id,
      Value<int> dailySessionId,
      Value<int> exerciseId,
      Value<bool> isFinished,
      Value<DateTime> createdAt,
    });

class $$SessionExerciseStatusTableFilterComposer
    extends Composer<_$AppDatabase, $SessionExerciseStatusTable> {
  $$SessionExerciseStatusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailySessionId => $composableBuilder(
    column: $table.dailySessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionExerciseStatusTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionExerciseStatusTable> {
  $$SessionExerciseStatusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailySessionId => $composableBuilder(
    column: $table.dailySessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionExerciseStatusTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionExerciseStatusTable> {
  $$SessionExerciseStatusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dailySessionId => $composableBuilder(
    column: $table.dailySessionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SessionExerciseStatusTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionExerciseStatusTable,
          SessionExerciseStatusData,
          $$SessionExerciseStatusTableFilterComposer,
          $$SessionExerciseStatusTableOrderingComposer,
          $$SessionExerciseStatusTableAnnotationComposer,
          $$SessionExerciseStatusTableCreateCompanionBuilder,
          $$SessionExerciseStatusTableUpdateCompanionBuilder,
          (
            SessionExerciseStatusData,
            BaseReferences<
              _$AppDatabase,
              $SessionExerciseStatusTable,
              SessionExerciseStatusData
            >,
          ),
          SessionExerciseStatusData,
          PrefetchHooks Function()
        > {
  $$SessionExerciseStatusTableTableManager(
    _$AppDatabase db,
    $SessionExerciseStatusTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionExerciseStatusTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SessionExerciseStatusTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SessionExerciseStatusTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailySessionId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionExerciseStatusCompanion(
                id: id,
                dailySessionId: dailySessionId,
                exerciseId: exerciseId,
                isFinished: isFinished,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dailySessionId,
                required int exerciseId,
                Value<bool> isFinished = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionExerciseStatusCompanion.insert(
                id: id,
                dailySessionId: dailySessionId,
                exerciseId: exerciseId,
                isFinished: isFinished,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $SessionExerciseStatusTable,
                    SessionExerciseStatusData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SessionExerciseStatusTable,
                    SessionExerciseStatusData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionExerciseStatusTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionExerciseStatusTable,
      SessionExerciseStatusData,
      $$SessionExerciseStatusTableFilterComposer,
      $$SessionExerciseStatusTableOrderingComposer,
      $$SessionExerciseStatusTableAnnotationComposer,
      $$SessionExerciseStatusTableCreateCompanionBuilder,
      $$SessionExerciseStatusTableUpdateCompanionBuilder,
      (
        SessionExerciseStatusData,
        BaseReferences<
          _$AppDatabase,
          $SessionExerciseStatusTable,
          SessionExerciseStatusData
        >,
      ),
      SessionExerciseStatusData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlanTableTableManager get plan => $$PlanTableTableManager(_db, _db.plan);
  $$WorkoutExerciseTableTableManager get workoutExercise =>
      $$WorkoutExerciseTableTableManager(_db, _db.workoutExercise);
  $$DailySessionTableTableManager get dailySession =>
      $$DailySessionTableTableManager(_db, _db.dailySession);
  $$SessionExerciseStatusTableTableManager get sessionExerciseStatus =>
      $$SessionExerciseStatusTableTableManager(_db, _db.sessionExerciseStatus);
}
