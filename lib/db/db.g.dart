// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Org extends DataClass implements Insertable<Org> {
  final int id;
  final String name;
  final String inn;
  final int activeGroupId;
  Org({@required this.id, @required this.name, this.inn, this.activeGroupId});
  factory Org.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Org(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      inn: stringType.mapFromDatabaseResponse(data['${effectivePrefix}inn']),
      activeGroupId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}activeGroupId']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || inn != null) {
      map['inn'] = Variable<String>(inn);
    }
    if (!nullToAbsent || activeGroupId != null) {
      map['activeGroupId'] = Variable<int>(activeGroupId);
    }
    return map;
  }

  OrgsCompanion toCompanion(bool nullToAbsent) {
    return OrgsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      inn: inn == null && nullToAbsent ? const Value.absent() : Value(inn),
      activeGroupId: activeGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeGroupId),
    );
  }

  factory Org.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Org(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      inn: serializer.fromJson<String>(json['inn']),
      activeGroupId: serializer.fromJson<int>(json['activeGroupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'inn': serializer.toJson<String>(inn),
      'activeGroupId': serializer.toJson<int>(activeGroupId),
    };
  }

  Org copyWith({int id, String name, String inn, int activeGroupId}) => Org(
        id: id ?? this.id,
        name: name ?? this.name,
        inn: inn ?? this.inn,
        activeGroupId: activeGroupId ?? this.activeGroupId,
      );
  @override
  String toString() {
    return (StringBuffer('Org(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('inn: $inn, ')
          ..write('activeGroupId: $activeGroupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(inn.hashCode, activeGroupId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Org &&
          other.id == this.id &&
          other.name == this.name &&
          other.inn == this.inn &&
          other.activeGroupId == this.activeGroupId);
}

class OrgsCompanion extends UpdateCompanion<Org> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> inn;
  final Value<int> activeGroupId;
  const OrgsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.inn = const Value.absent(),
    this.activeGroupId = const Value.absent(),
  });
  OrgsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.inn = const Value.absent(),
    this.activeGroupId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Org> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> inn,
    Expression<int> activeGroupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (inn != null) 'inn': inn,
      if (activeGroupId != null) 'activeGroupId': activeGroupId,
    });
  }

  OrgsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> inn,
      Value<int> activeGroupId}) {
    return OrgsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      inn: inn ?? this.inn,
      activeGroupId: activeGroupId ?? this.activeGroupId,
    );
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
    if (inn.present) {
      map['inn'] = Variable<String>(inn.value);
    }
    if (activeGroupId.present) {
      map['activeGroupId'] = Variable<int>(activeGroupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrgsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('inn: $inn, ')
          ..write('activeGroupId: $activeGroupId')
          ..write(')'))
        .toString();
  }
}

class Orgs extends Table with TableInfo<Orgs, Org> {
  final GeneratedDatabase _db;
  final String _alias;
  Orgs(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _innMeta = const VerificationMeta('inn');
  GeneratedTextColumn _inn;
  GeneratedTextColumn get inn => _inn ??= _constructInn();
  GeneratedTextColumn _constructInn() {
    return GeneratedTextColumn('inn', $tableName, true, $customConstraints: '');
  }

  final VerificationMeta _activeGroupIdMeta =
      const VerificationMeta('activeGroupId');
  GeneratedIntColumn _activeGroupId;
  GeneratedIntColumn get activeGroupId =>
      _activeGroupId ??= _constructActiveGroupId();
  GeneratedIntColumn _constructActiveGroupId() {
    return GeneratedIntColumn('activeGroupId', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, inn, activeGroupId];
  @override
  Orgs get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'orgs';
  @override
  final String actualTableName = 'orgs';
  @override
  VerificationContext validateIntegrity(Insertable<Org> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('inn')) {
      context.handle(
          _innMeta, inn.isAcceptableOrUnknown(data['inn'], _innMeta));
    }
    if (data.containsKey('activeGroupId')) {
      context.handle(
          _activeGroupIdMeta,
          activeGroupId.isAcceptableOrUnknown(
              data['activeGroupId'], _activeGroupIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Org map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Org.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Orgs createAlias(String alias) {
    return Orgs(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Schedule extends DataClass implements Insertable<Schedule> {
  final int id;
  final String code;
  Schedule({@required this.id, @required this.code});
  factory Schedule.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Schedule(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      code: stringType.mapFromDatabaseResponse(data['${effectivePrefix}code']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    return map;
  }

  SchedulesCompanion toCompanion(bool nullToAbsent) {
    return SchedulesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
    );
  }

  factory Schedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Schedule(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
    };
  }

  Schedule copyWith({int id, String code}) => Schedule(
        id: id ?? this.id,
        code: code ?? this.code,
      );
  @override
  String toString() {
    return (StringBuffer('Schedule(')
          ..write('id: $id, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, code.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Schedule && other.id == this.id && other.code == this.code);
}

class SchedulesCompanion extends UpdateCompanion<Schedule> {
  final Value<int> id;
  final Value<String> code;
  const SchedulesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
  });
  SchedulesCompanion.insert({
    this.id = const Value.absent(),
    @required String code,
  }) : code = Value(code);
  static Insertable<Schedule> custom({
    Expression<int> id,
    Expression<String> code,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
    });
  }

  SchedulesCompanion copyWith({Value<int> id, Value<String> code}) {
    return SchedulesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }
}

class Schedules extends Table with TableInfo<Schedules, Schedule> {
  final GeneratedDatabase _db;
  final String _alias;
  Schedules(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _codeMeta = const VerificationMeta('code');
  GeneratedTextColumn _code;
  GeneratedTextColumn get code => _code ??= _constructCode();
  GeneratedTextColumn _constructCode() {
    return GeneratedTextColumn('code', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  @override
  List<GeneratedColumn> get $columns => [id, code];
  @override
  Schedules get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'schedules';
  @override
  final String actualTableName = 'schedules';
  @override
  VerificationContext validateIntegrity(Insertable<Schedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code'], _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Schedule map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Schedule.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Schedules createAlias(String alias) {
    return Schedules(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ScheduleDay extends DataClass implements Insertable<ScheduleDay> {
  final int id;
  final int scheduleId;
  final int dayNumber;
  final double hoursNorm;
  ScheduleDay(
      {@required this.id,
      @required this.scheduleId,
      @required this.dayNumber,
      @required this.hoursNorm});
  factory ScheduleDay.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    return ScheduleDay(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      scheduleId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}scheduleId']),
      dayNumber:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}dayNumber']),
      hoursNorm: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}hoursNorm']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || scheduleId != null) {
      map['scheduleId'] = Variable<int>(scheduleId);
    }
    if (!nullToAbsent || dayNumber != null) {
      map['dayNumber'] = Variable<int>(dayNumber);
    }
    if (!nullToAbsent || hoursNorm != null) {
      map['hoursNorm'] = Variable<double>(hoursNorm);
    }
    return map;
  }

  ScheduleDaysCompanion toCompanion(bool nullToAbsent) {
    return ScheduleDaysCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      scheduleId: scheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleId),
      dayNumber: dayNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(dayNumber),
      hoursNorm: hoursNorm == null && nullToAbsent
          ? const Value.absent()
          : Value(hoursNorm),
    );
  }

  factory ScheduleDay.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ScheduleDay(
      id: serializer.fromJson<int>(json['id']),
      scheduleId: serializer.fromJson<int>(json['scheduleId']),
      dayNumber: serializer.fromJson<int>(json['dayNumber']),
      hoursNorm: serializer.fromJson<double>(json['hoursNorm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scheduleId': serializer.toJson<int>(scheduleId),
      'dayNumber': serializer.toJson<int>(dayNumber),
      'hoursNorm': serializer.toJson<double>(hoursNorm),
    };
  }

  ScheduleDay copyWith(
          {int id, int scheduleId, int dayNumber, double hoursNorm}) =>
      ScheduleDay(
        id: id ?? this.id,
        scheduleId: scheduleId ?? this.scheduleId,
        dayNumber: dayNumber ?? this.dayNumber,
        hoursNorm: hoursNorm ?? this.hoursNorm,
      );
  @override
  String toString() {
    return (StringBuffer('ScheduleDay(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('dayNumber: $dayNumber, ')
          ..write('hoursNorm: $hoursNorm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          scheduleId.hashCode, $mrjc(dayNumber.hashCode, hoursNorm.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ScheduleDay &&
          other.id == this.id &&
          other.scheduleId == this.scheduleId &&
          other.dayNumber == this.dayNumber &&
          other.hoursNorm == this.hoursNorm);
}

class ScheduleDaysCompanion extends UpdateCompanion<ScheduleDay> {
  final Value<int> id;
  final Value<int> scheduleId;
  final Value<int> dayNumber;
  final Value<double> hoursNorm;
  const ScheduleDaysCompanion({
    this.id = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.dayNumber = const Value.absent(),
    this.hoursNorm = const Value.absent(),
  });
  ScheduleDaysCompanion.insert({
    this.id = const Value.absent(),
    @required int scheduleId,
    @required int dayNumber,
    @required double hoursNorm,
  })  : scheduleId = Value(scheduleId),
        dayNumber = Value(dayNumber),
        hoursNorm = Value(hoursNorm);
  static Insertable<ScheduleDay> custom({
    Expression<int> id,
    Expression<int> scheduleId,
    Expression<int> dayNumber,
    Expression<double> hoursNorm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleId != null) 'scheduleId': scheduleId,
      if (dayNumber != null) 'dayNumber': dayNumber,
      if (hoursNorm != null) 'hoursNorm': hoursNorm,
    });
  }

  ScheduleDaysCompanion copyWith(
      {Value<int> id,
      Value<int> scheduleId,
      Value<int> dayNumber,
      Value<double> hoursNorm}) {
    return ScheduleDaysCompanion(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      dayNumber: dayNumber ?? this.dayNumber,
      hoursNorm: hoursNorm ?? this.hoursNorm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scheduleId.present) {
      map['scheduleId'] = Variable<int>(scheduleId.value);
    }
    if (dayNumber.present) {
      map['dayNumber'] = Variable<int>(dayNumber.value);
    }
    if (hoursNorm.present) {
      map['hoursNorm'] = Variable<double>(hoursNorm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleDaysCompanion(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('dayNumber: $dayNumber, ')
          ..write('hoursNorm: $hoursNorm')
          ..write(')'))
        .toString();
  }
}

class ScheduleDays extends Table with TableInfo<ScheduleDays, ScheduleDay> {
  final GeneratedDatabase _db;
  final String _alias;
  ScheduleDays(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _scheduleIdMeta = const VerificationMeta('scheduleId');
  GeneratedIntColumn _scheduleId;
  GeneratedIntColumn get scheduleId => _scheduleId ??= _constructScheduleId();
  GeneratedIntColumn _constructScheduleId() {
    return GeneratedIntColumn('scheduleId', $tableName, false,
        $customConstraints:
            'NOT NULL REFERENCES schedules (id) ON DELETE CASCADE');
  }

  final VerificationMeta _dayNumberMeta = const VerificationMeta('dayNumber');
  GeneratedIntColumn _dayNumber;
  GeneratedIntColumn get dayNumber => _dayNumber ??= _constructDayNumber();
  GeneratedIntColumn _constructDayNumber() {
    return GeneratedIntColumn('dayNumber', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _hoursNormMeta = const VerificationMeta('hoursNorm');
  GeneratedRealColumn _hoursNorm;
  GeneratedRealColumn get hoursNorm => _hoursNorm ??= _constructHoursNorm();
  GeneratedRealColumn _constructHoursNorm() {
    return GeneratedRealColumn('hoursNorm', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  @override
  List<GeneratedColumn> get $columns => [id, scheduleId, dayNumber, hoursNorm];
  @override
  ScheduleDays get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'schedule_days';
  @override
  final String actualTableName = 'schedule_days';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduleDay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('scheduleId')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['scheduleId'], _scheduleIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('dayNumber')) {
      context.handle(_dayNumberMeta,
          dayNumber.isAcceptableOrUnknown(data['dayNumber'], _dayNumberMeta));
    } else if (isInserting) {
      context.missing(_dayNumberMeta);
    }
    if (data.containsKey('hoursNorm')) {
      context.handle(_hoursNormMeta,
          hoursNorm.isAcceptableOrUnknown(data['hoursNorm'], _hoursNormMeta));
    } else if (isInserting) {
      context.missing(_hoursNormMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleDay map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ScheduleDay.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  ScheduleDays createAlias(String alias) {
    return ScheduleDays(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final int orgId;
  final String name;
  final int scheduleId;
  final int meals;
  Group(
      {@required this.id,
      @required this.orgId,
      @required this.name,
      @required this.scheduleId,
      this.meals});
  factory Group.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Group(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      orgId: intType.mapFromDatabaseResponse(data['${effectivePrefix}orgId']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      scheduleId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}scheduleId']),
      meals: intType.mapFromDatabaseResponse(data['${effectivePrefix}meals']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || orgId != null) {
      map['orgId'] = Variable<int>(orgId);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || scheduleId != null) {
      map['scheduleId'] = Variable<int>(scheduleId);
    }
    if (!nullToAbsent || meals != null) {
      map['meals'] = Variable<int>(meals);
    }
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      orgId:
          orgId == null && nullToAbsent ? const Value.absent() : Value(orgId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      scheduleId: scheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleId),
      meals:
          meals == null && nullToAbsent ? const Value.absent() : Value(meals),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      orgId: serializer.fromJson<int>(json['orgId']),
      name: serializer.fromJson<String>(json['name']),
      scheduleId: serializer.fromJson<int>(json['scheduleId']),
      meals: serializer.fromJson<int>(json['meals']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orgId': serializer.toJson<int>(orgId),
      'name': serializer.toJson<String>(name),
      'scheduleId': serializer.toJson<int>(scheduleId),
      'meals': serializer.toJson<int>(meals),
    };
  }

  Group copyWith({int id, int orgId, String name, int scheduleId, int meals}) =>
      Group(
        id: id ?? this.id,
        orgId: orgId ?? this.orgId,
        name: name ?? this.name,
        scheduleId: scheduleId ?? this.scheduleId,
        meals: meals ?? this.meals,
      );
  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('name: $name, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('meals: $meals')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(orgId.hashCode,
          $mrjc(name.hashCode, $mrjc(scheduleId.hashCode, meals.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.name == this.name &&
          other.scheduleId == this.scheduleId &&
          other.meals == this.meals);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<int> orgId;
  final Value<String> name;
  final Value<int> scheduleId;
  final Value<int> meals;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.name = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.meals = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    @required int orgId,
    @required String name,
    @required int scheduleId,
    this.meals = const Value.absent(),
  })  : orgId = Value(orgId),
        name = Value(name),
        scheduleId = Value(scheduleId);
  static Insertable<Group> custom({
    Expression<int> id,
    Expression<int> orgId,
    Expression<String> name,
    Expression<int> scheduleId,
    Expression<int> meals,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'orgId': orgId,
      if (name != null) 'name': name,
      if (scheduleId != null) 'scheduleId': scheduleId,
      if (meals != null) 'meals': meals,
    });
  }

  GroupsCompanion copyWith(
      {Value<int> id,
      Value<int> orgId,
      Value<String> name,
      Value<int> scheduleId,
      Value<int> meals}) {
    return GroupsCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      scheduleId: scheduleId ?? this.scheduleId,
      meals: meals ?? this.meals,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orgId.present) {
      map['orgId'] = Variable<int>(orgId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (scheduleId.present) {
      map['scheduleId'] = Variable<int>(scheduleId.value);
    }
    if (meals.present) {
      map['meals'] = Variable<int>(meals.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('name: $name, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('meals: $meals')
          ..write(')'))
        .toString();
  }
}

class Groups extends Table with TableInfo<Groups, Group> {
  final GeneratedDatabase _db;
  final String _alias;
  Groups(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  GeneratedIntColumn _orgId;
  GeneratedIntColumn get orgId => _orgId ??= _constructOrgId();
  GeneratedIntColumn _constructOrgId() {
    return GeneratedIntColumn('orgId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES orgs (id)');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _scheduleIdMeta = const VerificationMeta('scheduleId');
  GeneratedIntColumn _scheduleId;
  GeneratedIntColumn get scheduleId => _scheduleId ??= _constructScheduleId();
  GeneratedIntColumn _constructScheduleId() {
    return GeneratedIntColumn('scheduleId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES schedules (id)');
  }

  final VerificationMeta _mealsMeta = const VerificationMeta('meals');
  GeneratedIntColumn _meals;
  GeneratedIntColumn get meals => _meals ??= _constructMeals();
  GeneratedIntColumn _constructMeals() {
    return GeneratedIntColumn('meals', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns => [id, orgId, name, scheduleId, meals];
  @override
  Groups get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'groups';
  @override
  final String actualTableName = 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('orgId')) {
      context.handle(
          _orgIdMeta, orgId.isAcceptableOrUnknown(data['orgId'], _orgIdMeta));
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scheduleId')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['scheduleId'], _scheduleIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('meals')) {
      context.handle(
          _mealsMeta, meals.isAcceptableOrUnknown(data['meals'], _mealsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Group.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Groups createAlias(String alias) {
    return Groups(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Person extends DataClass implements Insertable<Person> {
  final int id;
  final String family;
  final String name;
  final String middleName;
  final DateTime birthday;
  final String phone;
  final String phone2;
  Person(
      {@required this.id,
      @required this.family,
      @required this.name,
      this.middleName,
      this.birthday,
      this.phone,
      this.phone2});
  factory Person.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Person(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      family:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}family']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      middleName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}middleName']),
      birthday: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}birthday']),
      phone:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}phone']),
      phone2:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}phone2']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || family != null) {
      map['family'] = Variable<String>(family);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || middleName != null) {
      map['middleName'] = Variable<String>(middleName);
    }
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<DateTime>(birthday);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || phone2 != null) {
      map['phone2'] = Variable<String>(phone2);
    }
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      family:
          family == null && nullToAbsent ? const Value.absent() : Value(family),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      middleName: middleName == null && nullToAbsent
          ? const Value.absent()
          : Value(middleName),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      phone2:
          phone2 == null && nullToAbsent ? const Value.absent() : Value(phone2),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<int>(json['id']),
      family: serializer.fromJson<String>(json['family']),
      name: serializer.fromJson<String>(json['name']),
      middleName: serializer.fromJson<String>(json['middleName']),
      birthday: serializer.fromJson<DateTime>(json['birthday']),
      phone: serializer.fromJson<String>(json['phone']),
      phone2: serializer.fromJson<String>(json['phone2']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'family': serializer.toJson<String>(family),
      'name': serializer.toJson<String>(name),
      'middleName': serializer.toJson<String>(middleName),
      'birthday': serializer.toJson<DateTime>(birthday),
      'phone': serializer.toJson<String>(phone),
      'phone2': serializer.toJson<String>(phone2),
    };
  }

  Person copyWith(
          {int id,
          String family,
          String name,
          String middleName,
          DateTime birthday,
          String phone,
          String phone2}) =>
      Person(
        id: id ?? this.id,
        family: family ?? this.family,
        name: name ?? this.name,
        middleName: middleName ?? this.middleName,
        birthday: birthday ?? this.birthday,
        phone: phone ?? this.phone,
        phone2: phone2 ?? this.phone2,
      );
  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('family: $family, ')
          ..write('name: $name, ')
          ..write('middleName: $middleName, ')
          ..write('birthday: $birthday, ')
          ..write('phone: $phone, ')
          ..write('phone2: $phone2')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          family.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  middleName.hashCode,
                  $mrjc(birthday.hashCode,
                      $mrjc(phone.hashCode, phone2.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.family == this.family &&
          other.name == this.name &&
          other.middleName == this.middleName &&
          other.birthday == this.birthday &&
          other.phone == this.phone &&
          other.phone2 == this.phone2);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> family;
  final Value<String> name;
  final Value<String> middleName;
  final Value<DateTime> birthday;
  final Value<String> phone;
  final Value<String> phone2;
  const PersonsCompanion({
    this.id = const Value.absent(),
    this.family = const Value.absent(),
    this.name = const Value.absent(),
    this.middleName = const Value.absent(),
    this.birthday = const Value.absent(),
    this.phone = const Value.absent(),
    this.phone2 = const Value.absent(),
  });
  PersonsCompanion.insert({
    this.id = const Value.absent(),
    @required String family,
    @required String name,
    this.middleName = const Value.absent(),
    this.birthday = const Value.absent(),
    this.phone = const Value.absent(),
    this.phone2 = const Value.absent(),
  })  : family = Value(family),
        name = Value(name);
  static Insertable<Person> custom({
    Expression<int> id,
    Expression<String> family,
    Expression<String> name,
    Expression<String> middleName,
    Expression<DateTime> birthday,
    Expression<String> phone,
    Expression<String> phone2,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (family != null) 'family': family,
      if (name != null) 'name': name,
      if (middleName != null) 'middleName': middleName,
      if (birthday != null) 'birthday': birthday,
      if (phone != null) 'phone': phone,
      if (phone2 != null) 'phone2': phone2,
    });
  }

  PersonsCompanion copyWith(
      {Value<int> id,
      Value<String> family,
      Value<String> name,
      Value<String> middleName,
      Value<DateTime> birthday,
      Value<String> phone,
      Value<String> phone2}) {
    return PersonsCompanion(
      id: id ?? this.id,
      family: family ?? this.family,
      name: name ?? this.name,
      middleName: middleName ?? this.middleName,
      birthday: birthday ?? this.birthday,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (family.present) {
      map['family'] = Variable<String>(family.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (middleName.present) {
      map['middleName'] = Variable<String>(middleName.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<DateTime>(birthday.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (phone2.present) {
      map['phone2'] = Variable<String>(phone2.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('id: $id, ')
          ..write('family: $family, ')
          ..write('name: $name, ')
          ..write('middleName: $middleName, ')
          ..write('birthday: $birthday, ')
          ..write('phone: $phone, ')
          ..write('phone2: $phone2')
          ..write(')'))
        .toString();
  }
}

class Persons extends Table with TableInfo<Persons, Person> {
  final GeneratedDatabase _db;
  final String _alias;
  Persons(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _familyMeta = const VerificationMeta('family');
  GeneratedTextColumn _family;
  GeneratedTextColumn get family => _family ??= _constructFamily();
  GeneratedTextColumn _constructFamily() {
    return GeneratedTextColumn('family', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _middleNameMeta = const VerificationMeta('middleName');
  GeneratedTextColumn _middleName;
  GeneratedTextColumn get middleName => _middleName ??= _constructMiddleName();
  GeneratedTextColumn _constructMiddleName() {
    return GeneratedTextColumn('middleName', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _birthdayMeta = const VerificationMeta('birthday');
  GeneratedDateTimeColumn _birthday;
  GeneratedDateTimeColumn get birthday => _birthday ??= _constructBirthday();
  GeneratedDateTimeColumn _constructBirthday() {
    return GeneratedDateTimeColumn('birthday', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _phoneMeta = const VerificationMeta('phone');
  GeneratedTextColumn _phone;
  GeneratedTextColumn get phone => _phone ??= _constructPhone();
  GeneratedTextColumn _constructPhone() {
    return GeneratedTextColumn('phone', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _phone2Meta = const VerificationMeta('phone2');
  GeneratedTextColumn _phone2;
  GeneratedTextColumn get phone2 => _phone2 ??= _constructPhone2();
  GeneratedTextColumn _constructPhone2() {
    return GeneratedTextColumn('phone2', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, family, name, middleName, birthday, phone, phone2];
  @override
  Persons get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'persons';
  @override
  final String actualTableName = 'persons';
  @override
  VerificationContext validateIntegrity(Insertable<Person> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('family')) {
      context.handle(_familyMeta,
          family.isAcceptableOrUnknown(data['family'], _familyMeta));
    } else if (isInserting) {
      context.missing(_familyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('middleName')) {
      context.handle(
          _middleNameMeta,
          middleName.isAcceptableOrUnknown(
              data['middleName'], _middleNameMeta));
    }
    if (data.containsKey('birthday')) {
      context.handle(_birthdayMeta,
          birthday.isAcceptableOrUnknown(data['birthday'], _birthdayMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone'], _phoneMeta));
    }
    if (data.containsKey('phone2')) {
      context.handle(_phone2Meta,
          phone2.isAcceptableOrUnknown(data['phone2'], _phone2Meta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Person.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Persons createAlias(String alias) {
    return Persons(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class GroupPerson extends DataClass implements Insertable<GroupPerson> {
  final int id;
  final int groupId;
  final int personId;
  final DateTime beginDate;
  final DateTime endDate;
  GroupPerson(
      {@required this.id,
      @required this.groupId,
      @required this.personId,
      this.beginDate,
      this.endDate});
  factory GroupPerson.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return GroupPerson(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      groupId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}groupId']),
      personId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}personId']),
      beginDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}beginDate']),
      endDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}endDate']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || groupId != null) {
      map['groupId'] = Variable<int>(groupId);
    }
    if (!nullToAbsent || personId != null) {
      map['personId'] = Variable<int>(personId);
    }
    if (!nullToAbsent || beginDate != null) {
      map['beginDate'] = Variable<DateTime>(beginDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['endDate'] = Variable<DateTime>(endDate);
    }
    return map;
  }

  GroupPersonsCompanion toCompanion(bool nullToAbsent) {
    return GroupPersonsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      beginDate: beginDate == null && nullToAbsent
          ? const Value.absent()
          : Value(beginDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory GroupPerson.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return GroupPerson(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      personId: serializer.fromJson<int>(json['personId']),
      beginDate: serializer.fromJson<DateTime>(json['beginDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'personId': serializer.toJson<int>(personId),
      'beginDate': serializer.toJson<DateTime>(beginDate),
      'endDate': serializer.toJson<DateTime>(endDate),
    };
  }

  GroupPerson copyWith(
          {int id,
          int groupId,
          int personId,
          DateTime beginDate,
          DateTime endDate}) =>
      GroupPerson(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        personId: personId ?? this.personId,
        beginDate: beginDate ?? this.beginDate,
        endDate: endDate ?? this.endDate,
      );
  @override
  String toString() {
    return (StringBuffer('GroupPerson(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('personId: $personId, ')
          ..write('beginDate: $beginDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          groupId.hashCode,
          $mrjc(personId.hashCode,
              $mrjc(beginDate.hashCode, endDate.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is GroupPerson &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.personId == this.personId &&
          other.beginDate == this.beginDate &&
          other.endDate == this.endDate);
}

class GroupPersonsCompanion extends UpdateCompanion<GroupPerson> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> personId;
  final Value<DateTime> beginDate;
  final Value<DateTime> endDate;
  const GroupPersonsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.personId = const Value.absent(),
    this.beginDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  GroupPersonsCompanion.insert({
    this.id = const Value.absent(),
    @required int groupId,
    @required int personId,
    this.beginDate = const Value.absent(),
    this.endDate = const Value.absent(),
  })  : groupId = Value(groupId),
        personId = Value(personId);
  static Insertable<GroupPerson> custom({
    Expression<int> id,
    Expression<int> groupId,
    Expression<int> personId,
    Expression<DateTime> beginDate,
    Expression<DateTime> endDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'groupId': groupId,
      if (personId != null) 'personId': personId,
      if (beginDate != null) 'beginDate': beginDate,
      if (endDate != null) 'endDate': endDate,
    });
  }

  GroupPersonsCompanion copyWith(
      {Value<int> id,
      Value<int> groupId,
      Value<int> personId,
      Value<DateTime> beginDate,
      Value<DateTime> endDate}) {
    return GroupPersonsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      personId: personId ?? this.personId,
      beginDate: beginDate ?? this.beginDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['groupId'] = Variable<int>(groupId.value);
    }
    if (personId.present) {
      map['personId'] = Variable<int>(personId.value);
    }
    if (beginDate.present) {
      map['beginDate'] = Variable<DateTime>(beginDate.value);
    }
    if (endDate.present) {
      map['endDate'] = Variable<DateTime>(endDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupPersonsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('personId: $personId, ')
          ..write('beginDate: $beginDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }
}

class GroupPersons extends Table with TableInfo<GroupPersons, GroupPerson> {
  final GeneratedDatabase _db;
  final String _alias;
  GroupPersons(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  GeneratedIntColumn _groupId;
  GeneratedIntColumn get groupId => _groupId ??= _constructGroupId();
  GeneratedIntColumn _constructGroupId() {
    return GeneratedIntColumn('groupId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES "groups" (id)');
  }

  final VerificationMeta _personIdMeta = const VerificationMeta('personId');
  GeneratedIntColumn _personId;
  GeneratedIntColumn get personId => _personId ??= _constructPersonId();
  GeneratedIntColumn _constructPersonId() {
    return GeneratedIntColumn('personId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES persons (id)');
  }

  final VerificationMeta _beginDateMeta = const VerificationMeta('beginDate');
  GeneratedDateTimeColumn _beginDate;
  GeneratedDateTimeColumn get beginDate => _beginDate ??= _constructBeginDate();
  GeneratedDateTimeColumn _constructBeginDate() {
    return GeneratedDateTimeColumn('beginDate', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _endDateMeta = const VerificationMeta('endDate');
  GeneratedDateTimeColumn _endDate;
  GeneratedDateTimeColumn get endDate => _endDate ??= _constructEndDate();
  GeneratedDateTimeColumn _constructEndDate() {
    return GeneratedDateTimeColumn('endDate', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, groupId, personId, beginDate, endDate];
  @override
  GroupPersons get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'group_persons';
  @override
  final String actualTableName = 'group_persons';
  @override
  VerificationContext validateIntegrity(Insertable<GroupPerson> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('groupId')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['groupId'], _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('personId')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['personId'], _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('beginDate')) {
      context.handle(_beginDateMeta,
          beginDate.isAcceptableOrUnknown(data['beginDate'], _beginDateMeta));
    }
    if (data.containsKey('endDate')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['endDate'], _endDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupPerson map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return GroupPerson.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  GroupPersons createAlias(String alias) {
    return GroupPersons(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Attendance extends DataClass implements Insertable<Attendance> {
  final int id;
  final int groupPersonId;
  final DateTime date;
  final double hoursFact;
  Attendance(
      {@required this.id,
      @required this.groupPersonId,
      @required this.date,
      @required this.hoursFact});
  factory Attendance.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Attendance(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      groupPersonId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}groupPersonId']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      hoursFact: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}hoursFact']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || groupPersonId != null) {
      map['groupPersonId'] = Variable<int>(groupPersonId);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || hoursFact != null) {
      map['hoursFact'] = Variable<double>(hoursFact);
    }
    return map;
  }

  AttendancesCompanion toCompanion(bool nullToAbsent) {
    return AttendancesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      groupPersonId: groupPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupPersonId),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      hoursFact: hoursFact == null && nullToAbsent
          ? const Value.absent()
          : Value(hoursFact),
    );
  }

  factory Attendance.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Attendance(
      id: serializer.fromJson<int>(json['id']),
      groupPersonId: serializer.fromJson<int>(json['groupPersonId']),
      date: serializer.fromJson<DateTime>(json['date']),
      hoursFact: serializer.fromJson<double>(json['hoursFact']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupPersonId': serializer.toJson<int>(groupPersonId),
      'date': serializer.toJson<DateTime>(date),
      'hoursFact': serializer.toJson<double>(hoursFact),
    };
  }

  Attendance copyWith(
          {int id, int groupPersonId, DateTime date, double hoursFact}) =>
      Attendance(
        id: id ?? this.id,
        groupPersonId: groupPersonId ?? this.groupPersonId,
        date: date ?? this.date,
        hoursFact: hoursFact ?? this.hoursFact,
      );
  @override
  String toString() {
    return (StringBuffer('Attendance(')
          ..write('id: $id, ')
          ..write('groupPersonId: $groupPersonId, ')
          ..write('date: $date, ')
          ..write('hoursFact: $hoursFact')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(groupPersonId.hashCode, $mrjc(date.hashCode, hoursFact.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Attendance &&
          other.id == this.id &&
          other.groupPersonId == this.groupPersonId &&
          other.date == this.date &&
          other.hoursFact == this.hoursFact);
}

class AttendancesCompanion extends UpdateCompanion<Attendance> {
  final Value<int> id;
  final Value<int> groupPersonId;
  final Value<DateTime> date;
  final Value<double> hoursFact;
  const AttendancesCompanion({
    this.id = const Value.absent(),
    this.groupPersonId = const Value.absent(),
    this.date = const Value.absent(),
    this.hoursFact = const Value.absent(),
  });
  AttendancesCompanion.insert({
    this.id = const Value.absent(),
    @required int groupPersonId,
    @required DateTime date,
    @required double hoursFact,
  })  : groupPersonId = Value(groupPersonId),
        date = Value(date),
        hoursFact = Value(hoursFact);
  static Insertable<Attendance> custom({
    Expression<int> id,
    Expression<int> groupPersonId,
    Expression<DateTime> date,
    Expression<double> hoursFact,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupPersonId != null) 'groupPersonId': groupPersonId,
      if (date != null) 'date': date,
      if (hoursFact != null) 'hoursFact': hoursFact,
    });
  }

  AttendancesCompanion copyWith(
      {Value<int> id,
      Value<int> groupPersonId,
      Value<DateTime> date,
      Value<double> hoursFact}) {
    return AttendancesCompanion(
      id: id ?? this.id,
      groupPersonId: groupPersonId ?? this.groupPersonId,
      date: date ?? this.date,
      hoursFact: hoursFact ?? this.hoursFact,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupPersonId.present) {
      map['groupPersonId'] = Variable<int>(groupPersonId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (hoursFact.present) {
      map['hoursFact'] = Variable<double>(hoursFact.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendancesCompanion(')
          ..write('id: $id, ')
          ..write('groupPersonId: $groupPersonId, ')
          ..write('date: $date, ')
          ..write('hoursFact: $hoursFact')
          ..write(')'))
        .toString();
  }
}

class Attendances extends Table with TableInfo<Attendances, Attendance> {
  final GeneratedDatabase _db;
  final String _alias;
  Attendances(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _groupPersonIdMeta =
      const VerificationMeta('groupPersonId');
  GeneratedIntColumn _groupPersonId;
  GeneratedIntColumn get groupPersonId =>
      _groupPersonId ??= _constructGroupPersonId();
  GeneratedIntColumn _constructGroupPersonId() {
    return GeneratedIntColumn('groupPersonId', $tableName, false,
        $customConstraints:
            'NOT NULL REFERENCES group_persons (id) ON DELETE CASCADE');
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn('date', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _hoursFactMeta = const VerificationMeta('hoursFact');
  GeneratedRealColumn _hoursFact;
  GeneratedRealColumn get hoursFact => _hoursFact ??= _constructHoursFact();
  GeneratedRealColumn _constructHoursFact() {
    return GeneratedRealColumn('hoursFact', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  @override
  List<GeneratedColumn> get $columns => [id, groupPersonId, date, hoursFact];
  @override
  Attendances get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'attendances';
  @override
  final String actualTableName = 'attendances';
  @override
  VerificationContext validateIntegrity(Insertable<Attendance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('groupPersonId')) {
      context.handle(
          _groupPersonIdMeta,
          groupPersonId.isAcceptableOrUnknown(
              data['groupPersonId'], _groupPersonIdMeta));
    } else if (isInserting) {
      context.missing(_groupPersonIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('hoursFact')) {
      context.handle(_hoursFactMeta,
          hoursFact.isAcceptableOrUnknown(data['hoursFact'], _hoursFactMeta));
    } else if (isInserting) {
      context.missing(_hoursFactMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attendance map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Attendance.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Attendances createAlias(String alias) {
    return Attendances(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String name;
  final String textValue;
  final int intValue;
  final DateTime dateValue;
  Setting(
      {@required this.id,
      @required this.name,
      this.textValue,
      this.intValue,
      this.dateValue});
  factory Setting.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Setting(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      textValue: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}textValue']),
      intValue:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}intValue']),
      dateValue: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}dateValue']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || textValue != null) {
      map['textValue'] = Variable<String>(textValue);
    }
    if (!nullToAbsent || intValue != null) {
      map['intValue'] = Variable<int>(intValue);
    }
    if (!nullToAbsent || dateValue != null) {
      map['dateValue'] = Variable<DateTime>(dateValue);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      textValue: textValue == null && nullToAbsent
          ? const Value.absent()
          : Value(textValue),
      intValue: intValue == null && nullToAbsent
          ? const Value.absent()
          : Value(intValue),
      dateValue: dateValue == null && nullToAbsent
          ? const Value.absent()
          : Value(dateValue),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      textValue: serializer.fromJson<String>(json['textValue']),
      intValue: serializer.fromJson<int>(json['intValue']),
      dateValue: serializer.fromJson<DateTime>(json['dateValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'textValue': serializer.toJson<String>(textValue),
      'intValue': serializer.toJson<int>(intValue),
      'dateValue': serializer.toJson<DateTime>(dateValue),
    };
  }

  Setting copyWith(
          {int id,
          String name,
          String textValue,
          int intValue,
          DateTime dateValue}) =>
      Setting(
        id: id ?? this.id,
        name: name ?? this.name,
        textValue: textValue ?? this.textValue,
        intValue: intValue ?? this.intValue,
        dateValue: dateValue ?? this.dateValue,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('textValue: $textValue, ')
          ..write('intValue: $intValue, ')
          ..write('dateValue: $dateValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(textValue.hashCode,
              $mrjc(intValue.hashCode, dateValue.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.name == this.name &&
          other.textValue == this.textValue &&
          other.intValue == this.intValue &&
          other.dateValue == this.dateValue);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> textValue;
  final Value<int> intValue;
  final Value<DateTime> dateValue;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.textValue = const Value.absent(),
    this.intValue = const Value.absent(),
    this.dateValue = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.textValue = const Value.absent(),
    this.intValue = const Value.absent(),
    this.dateValue = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Setting> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> textValue,
    Expression<int> intValue,
    Expression<DateTime> dateValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (textValue != null) 'textValue': textValue,
      if (intValue != null) 'intValue': intValue,
      if (dateValue != null) 'dateValue': dateValue,
    });
  }

  SettingsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> textValue,
      Value<int> intValue,
      Value<DateTime> dateValue}) {
    return SettingsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      textValue: textValue ?? this.textValue,
      intValue: intValue ?? this.intValue,
      dateValue: dateValue ?? this.dateValue,
    );
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
    if (textValue.present) {
      map['textValue'] = Variable<String>(textValue.value);
    }
    if (intValue.present) {
      map['intValue'] = Variable<int>(intValue.value);
    }
    if (dateValue.present) {
      map['dateValue'] = Variable<DateTime>(dateValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('textValue: $textValue, ')
          ..write('intValue: $intValue, ')
          ..write('dateValue: $dateValue')
          ..write(')'))
        .toString();
  }
}

class Settings extends Table with TableInfo<Settings, Setting> {
  final GeneratedDatabase _db;
  final String _alias;
  Settings(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _textValueMeta = const VerificationMeta('textValue');
  GeneratedTextColumn _textValue;
  GeneratedTextColumn get textValue => _textValue ??= _constructTextValue();
  GeneratedTextColumn _constructTextValue() {
    return GeneratedTextColumn('textValue', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _intValueMeta = const VerificationMeta('intValue');
  GeneratedIntColumn _intValue;
  GeneratedIntColumn get intValue => _intValue ??= _constructIntValue();
  GeneratedIntColumn _constructIntValue() {
    return GeneratedIntColumn('intValue', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _dateValueMeta = const VerificationMeta('dateValue');
  GeneratedDateTimeColumn _dateValue;
  GeneratedDateTimeColumn get dateValue => _dateValue ??= _constructDateValue();
  GeneratedDateTimeColumn _constructDateValue() {
    return GeneratedDateTimeColumn('dateValue', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, textValue, intValue, dateValue];
  @override
  Settings get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'settings';
  @override
  final String actualTableName = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('textValue')) {
      context.handle(_textValueMeta,
          textValue.isAcceptableOrUnknown(data['textValue'], _textValueMeta));
    }
    if (data.containsKey('intValue')) {
      context.handle(_intValueMeta,
          intValue.isAcceptableOrUnknown(data['intValue'], _intValueMeta));
    }
    if (data.containsKey('dateValue')) {
      context.handle(_dateValueMeta,
          dateValue.isAcceptableOrUnknown(data['dateValue'], _dateValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Setting.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Settings createAlias(String alias) {
    return Settings(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

abstract class _$Db extends GeneratedDatabase {
  _$Db(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  Orgs _orgs;
  Orgs get orgs => _orgs ??= Orgs(this);
  Index _orgsIndex;
  Index get orgsIndex => _orgsIndex ??=
      Index('orgs_index', 'CREATE UNIQUE INDEX orgs_index ON orgs (name);');
  Schedules _schedules;
  Schedules get schedules => _schedules ??= Schedules(this);
  Index _schedulesIndex;
  Index get schedulesIndex => _schedulesIndex ??= Index('schedules_index',
      'CREATE UNIQUE INDEX schedules_index ON schedules (code);');
  ScheduleDays _scheduleDays;
  ScheduleDays get scheduleDays => _scheduleDays ??= ScheduleDays(this);
  Index _scheduleDaysIndex;
  Index get scheduleDaysIndex => _scheduleDaysIndex ??= Index(
      'schedule_days_index',
      'CREATE UNIQUE INDEX schedule_days_index ON schedule_days (scheduleId, dayNumber);');
  Groups _groups;
  Groups get groups => _groups ??= Groups(this);
  Index _groupsIndex;
  Index get groupsIndex => _groupsIndex ??= Index('groups_index',
      'CREATE UNIQUE INDEX groups_index ON "groups" (orgId, name, scheduleId);');
  Index _groupsScheduleIndex;
  Index get groupsScheduleIndex => _groupsScheduleIndex ??= Index(
      'groups_schedule_index',
      'CREATE INDEX groups_schedule_index ON "groups" (scheduleId);');
  Persons _persons;
  Persons get persons => _persons ??= Persons(this);
  Index _personsIndex;
  Index get personsIndex => _personsIndex ??= Index('persons_index',
      'CREATE UNIQUE INDEX persons_index ON persons (family, name, middleName, birthday);');
  GroupPersons _groupPersons;
  GroupPersons get groupPersons => _groupPersons ??= GroupPersons(this);
  Index _groupPersonsIndex;
  Index get groupPersonsIndex => _groupPersonsIndex ??= Index(
      'group_persons_index',
      'CREATE UNIQUE INDEX group_persons_index ON group_persons (groupId, personId);');
  Attendances _attendances;
  Attendances get attendances => _attendances ??= Attendances(this);
  Index _attendancesIndex;
  Index get attendancesIndex => _attendancesIndex ??= Index('attendances_index',
      'CREATE UNIQUE INDEX attendances_index ON attendances (groupPersonId, date);');
  Settings _settings;
  Settings get settings => _settings ??= Settings(this);
  Index _settingsIndex;
  Index get settingsIndex => _settingsIndex ??= Index('settings_index',
      'CREATE UNIQUE INDEX settings_index ON settings (name);');
  OrgsDao _orgsDao;
  OrgsDao get orgsDao => _orgsDao ??= OrgsDao(this as Db);
  SchedulesDao _schedulesDao;
  SchedulesDao get schedulesDao => _schedulesDao ??= SchedulesDao(this as Db);
  ScheduleDaysDao _scheduleDaysDao;
  ScheduleDaysDao get scheduleDaysDao =>
      _scheduleDaysDao ??= ScheduleDaysDao(this as Db);
  GroupsDao _groupsDao;
  GroupsDao get groupsDao => _groupsDao ??= GroupsDao(this as Db);
  PersonsDao _personsDao;
  PersonsDao get personsDao => _personsDao ??= PersonsDao(this as Db);
  GroupPersonsDao _groupPersonsDao;
  GroupPersonsDao get groupPersonsDao =>
      _groupPersonsDao ??= GroupPersonsDao(this as Db);
  AttendancesDao _attendancesDao;
  AttendancesDao get attendancesDao =>
      _attendancesDao ??= AttendancesDao(this as Db);
  SettingsDao _settingsDao;
  SettingsDao get settingsDao => _settingsDao ??= SettingsDao(this as Db);
  Selectable<ScheduleDay> _daysInSchedule(int scheduleId) {
    return customSelect(
        'SELECT *\n  FROM schedule_days\n WHERE scheduleId = :scheduleId',
        variables: [Variable.withInt(scheduleId)],
        readsFrom: {scheduleDays}).map(scheduleDays.mapFromRow);
  }

  Selectable<Org> _firstOrg() {
    return customSelect(
        'SELECT *\n  FROM orgs\n WHERE name =\n       (\n         SELECT MIN(name)\n           FROM orgs\n       )',
        variables: [],
        readsFrom: {orgs}).map(orgs.mapFromRow);
  }

  Selectable<Org> _previousOrg(String orgName) {
    return customSelect(
        'SELECT *\n  FROM orgs\n WHERE name =\n       (\n         SELECT MAX(name)\n           FROM orgs\n          WHERE name < :orgName\n       )',
        variables: [Variable.withString(orgName)],
        readsFrom: {orgs}).map(orgs.mapFromRow);
  }

  Selectable<Schedule> _firstSchedule() {
    return customSelect(
        'SELECT *\n  FROM schedules\n WHERE code =\n       (\n         SELECT MIN(code)\n           FROM schedules\n       )',
        variables: [],
        readsFrom: {schedules}).map(schedules.mapFromRow);
  }

  Selectable<Schedule> _previousSchedule(String scheduleCode) {
    return customSelect(
        'SELECT *\n  FROM schedules\n WHERE code =\n       (\n         SELECT MAX(code)\n           FROM schedules\n          WHERE code < :scheduleCode\n       )',
        variables: [Variable.withString(scheduleCode)],
        readsFrom: {schedules}).map(schedules.mapFromRow);
  }

  Selectable<Group> _firstGroup(int orgId) {
    return customSelect(
        'SELECT *\n  FROM "groups"\n WHERE orgId = :orgId\n   AND name =\n       (\n         SELECT MIN(name)\n           FROM "groups"\n          WHERE orgId = :orgId\n       )',
        variables: [Variable.withInt(orgId)],
        readsFrom: {groups}).map(groups.mapFromRow);
  }

  Selectable<Group> _previousGroup(int orgId, String groupName) {
    return customSelect(
        'SELECT *\n  FROM "groups"\n WHERE orgId = :orgId\n   AND name =\n       (\n         SELECT MAX(name)\n           FROM "groups"\n          WHERE name < :groupName\n       )',
        variables: [Variable.withInt(orgId), Variable.withString(groupName)],
        readsFrom: {groups}).map(groups.mapFromRow);
  }

  Selectable<OrgsViewResult> _orgsView() {
    return customSelect(
        'SELECT O.id,\n       O.name,\n       O.inn,\n       O.activeGroupId,\n       CAST((SELECT COUNT(*) FROM "groups" WHERE orgId = O.id) AS INT) AS groupCount\n  FROM orgs O\n ORDER BY\n       O.name,\n       O.inn',
        variables: [],
        readsFrom: {orgs, groups}).map((QueryRow row) {
      return OrgsViewResult(
        id: row.readInt('id'),
        name: row.readString('name'),
        inn: row.readString('inn'),
        activeGroupId: row.readInt('activeGroupId'),
        groupCount: row.readInt('groupCount'),
      );
    });
  }

  Selectable<SchedulesViewResult> _schedulesView() {
    return customSelect(
        'SELECT S.id,\n       S.code,\n       CAST((SELECT COUNT(*) FROM "groups" WHERE scheduleId = S.id) AS INT) AS groupCount\n  FROM schedules S\n ORDER BY\n       S.code',
        variables: [],
        readsFrom: {schedules, groups}).map((QueryRow row) {
      return SchedulesViewResult(
        id: row.readInt('id'),
        code: row.readString('code'),
        groupCount: row.readInt('groupCount'),
      );
    });
  }

  Selectable<GroupsViewResult> _groupsView(int orgId) {
    return customSelect(
        'SELECT G.id,\n       G.orgId,\n       G.name,\n       G.scheduleId,\n       S.code AS scheduleCode,\n       G.meals,\n       CAST((SELECT COUNT(*) FROM group_persons WHERE groupId = G.id) AS INT) AS personCount\n  FROM "groups" G\n INNER JOIN schedules S ON S.id = G.scheduleId\n WHERE G.orgId = :orgId\n ORDER BY\n       G.name,\n       S.code',
        variables: [Variable.withInt(orgId)],
        readsFrom: {groups, schedules, groupPersons}).map((QueryRow row) {
      return GroupsViewResult(
        id: row.readInt('id'),
        orgId: row.readInt('orgId'),
        name: row.readString('name'),
        scheduleId: row.readInt('scheduleId'),
        scheduleCode: row.readString('scheduleCode'),
        meals: row.readInt('meals'),
        personCount: row.readInt('personCount'),
      );
    });
  }

  Selectable<PersonsViewResult> _personsView() {
    return customSelect(
        'SELECT P.id,\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday,\n       P.phone,\n       P.phone2,\n       CAST((SELECT COUNT(*) FROM group_persons WHERE personId = P.id) AS INT) AS groupCount\n  FROM persons P\n ORDER BY\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday',
        variables: [],
        readsFrom: {persons, groupPersons}).map((QueryRow row) {
      return PersonsViewResult(
        id: row.readInt('id'),
        family: row.readString('family'),
        name: row.readString('name'),
        middleName: row.readString('middleName'),
        birthday: row.readDateTime('birthday'),
        phone: row.readString('phone'),
        phone2: row.readString('phone2'),
        groupCount: row.readInt('groupCount'),
      );
    });
  }

  Selectable<Person> _findPerson(
      String family, String name, String middleName, DateTime birthday) {
    return customSelect(
        'SELECT P.id,\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday,\n       P.phone,\n       P.phone2\n  FROM persons P\n WHERE P.family = :family\n   AND P.name = :name\n   AND (:middleName IS NULL OR :middleName = \'\' OR P.middleName = :middleName)\n   AND (:birthday IS NULL OR P.birthday = :birthday)',
        variables: [
          Variable.withString(family),
          Variable.withString(name),
          Variable.withString(middleName),
          Variable.withDateTime(birthday)
        ],
        readsFrom: {
          persons
        }).map(persons.mapFromRow);
  }

  Selectable<PersonsInGroupResult> _personsInGroup(int groupId) {
    return customSelect(
        'SELECT L.id,\n       L.groupId,\n       L.personId,\n       L.beginDate,\n       L.endDate,\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday,\n       P.phone,\n       P.phone2,\n       CAST((SELECT COUNT(*) FROM attendances T WHERE T.groupPersonId = L.id) AS INT) AS attendanceCount\n  FROM group_persons L\n INNER JOIN persons P ON P.id = L.personId\n WHERE L.groupId = :groupId\n ORDER BY\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday',
        variables: [Variable.withInt(groupId)],
        readsFrom: {groupPersons, persons, attendances}).map((QueryRow row) {
      return PersonsInGroupResult(
        id: row.readInt('id'),
        groupId: row.readInt('groupId'),
        personId: row.readInt('personId'),
        beginDate: row.readDateTime('beginDate'),
        endDate: row.readDateTime('endDate'),
        family: row.readString('family'),
        name: row.readString('name'),
        middleName: row.readString('middleName'),
        birthday: row.readDateTime('birthday'),
        phone: row.readString('phone'),
        phone2: row.readString('phone2'),
        attendanceCount: row.readInt('attendanceCount'),
      );
    });
  }

  Selectable<PersonsInGroupPeriodResult> _personsInGroupPeriod(
      int groupId, DateTime periodBegin, DateTime periodEnd) {
    return customSelect(
        'SELECT L.id,\n       L.groupId,\n       L.personId,\n       L.beginDate,\n       L.endDate,\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday,\n       P.phone,\n       P.phone2,\n       CAST((SELECT COUNT(*) FROM attendances T WHERE T.groupPersonId = L.id) AS INT) AS attendanceCount\n  FROM group_persons L\n INNER JOIN persons P ON P.id = L.personId\n WHERE L.groupId = :groupId\n   AND (L.endDate IS NULL OR L.endDate >= :periodBegin)\n   AND (L.beginDate IS NULL OR L.beginDate <= :periodEnd)\n ORDER BY\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday',
        variables: [
          Variable.withInt(groupId),
          Variable.withDateTime(periodBegin),
          Variable.withDateTime(periodEnd)
        ],
        readsFrom: {
          groupPersons,
          persons,
          attendances
        }).map((QueryRow row) {
      return PersonsInGroupPeriodResult(
        id: row.readInt('id'),
        groupId: row.readInt('groupId'),
        personId: row.readInt('personId'),
        beginDate: row.readDateTime('beginDate'),
        endDate: row.readDateTime('endDate'),
        family: row.readString('family'),
        name: row.readString('name'),
        middleName: row.readString('middleName'),
        birthday: row.readDateTime('birthday'),
        phone: row.readString('phone'),
        phone2: row.readString('phone2'),
        attendanceCount: row.readInt('attendanceCount'),
      );
    });
  }

  Selectable<Attendance> _attendancesView(
      int groupId, DateTime periodBegin, DateTime periodEnd) {
    return customSelect(
        'SELECT T.*\n  FROM group_persons L\n INNER JOIN attendances T ON T.groupPersonId = L.id\n WHERE L.groupId = :groupId\n   AND (L.endDate IS NULL OR L.endDate >= :periodBegin)\n   AND (L.beginDate IS NULL OR L.beginDate <= :periodEnd)\n   AND T.date >= :periodBegin\n   AND T.date <= :periodEnd',
        variables: [
          Variable.withInt(groupId),
          Variable.withDateTime(periodBegin),
          Variable.withDateTime(periodEnd)
        ],
        readsFrom: {
          groupPersons,
          attendances
        }).map(attendances.mapFromRow);
  }

  Selectable<Org> _activeOrg() {
    return customSelect(
        'SELECT O.*\n  FROM settings S\n INNER JOIN orgs O ON O.id = S.intValue\n WHERE S.name = \'activeOrg\'',
        variables: [],
        readsFrom: {settings, orgs}).map(orgs.mapFromRow);
  }

  Future<int> _setActiveOrg(int id) {
    return customUpdate(
      'UPDATE settings SET intValue = :id WHERE name = \'activeOrg\'',
      variables: [Variable.withInt(id)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
  }

  Selectable<Schedule> _activeSchedule() {
    return customSelect(
        'SELECT SCH.*\n  FROM settings S\n INNER JOIN schedules SCH ON SCH.id = S.intValue\n WHERE S.name = \'activeSchedule\'',
        variables: [],
        readsFrom: {settings, schedules}).map(schedules.mapFromRow);
  }

  Future<int> _setActiveSchedule(int id) {
    return customUpdate(
      'UPDATE settings SET intValue = :id WHERE name = \'activeSchedule\'',
      variables: [Variable.withInt(id)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
  }

  Selectable<ActiveGroupResult> _activeGroup(int orgId) {
    return customSelect(
        'SELECT G.id,\n       G.orgId,\n       G.name,\n       G.scheduleId,\n       S.code AS scheduleCode,\n       G.meals,\n       CAST((SELECT COUNT(*) FROM group_persons WHERE groupId = G.id) AS INT) AS personCount\n  FROM orgs O\n INNER JOIN "groups" G ON G.id = O.activeGroupId\n INNER JOIN schedules S ON S.id = G.scheduleId\n WHERE O.id = :orgId',
        variables: [Variable.withInt(orgId)],
        readsFrom: {groups, schedules, groupPersons, orgs}).map((QueryRow row) {
      return ActiveGroupResult(
        id: row.readInt('id'),
        orgId: row.readInt('orgId'),
        name: row.readString('name'),
        scheduleId: row.readInt('scheduleId'),
        scheduleCode: row.readString('scheduleCode'),
        meals: row.readInt('meals'),
        personCount: row.readInt('personCount'),
      );
    });
  }

  Future<int> _setActiveGroup(int activeGroupId, int orgId) {
    return customUpdate(
      'UPDATE orgs SET activeGroupId = :activeGroupId WHERE id = :orgId',
      variables: [Variable.withInt(activeGroupId), Variable.withInt(orgId)],
      updates: {orgs},
      updateKind: UpdateKind.update,
    );
  }

  Selectable<DateTime> _activePeriod() {
    return customSelect(
        'SELECT S.dateValue\n  FROM settings S\n WHERE S.name = \'activePeriod\'',
        variables: [],
        readsFrom: {
          settings
        }).map((QueryRow row) => row.readDateTime('dateValue'));
  }

  Future<int> _setActivePeriod(DateTime activePeriod) {
    return customUpdate(
      'UPDATE settings SET dateValue = :activePeriod WHERE name = \'activePeriod\'',
      variables: [Variable.withDateTime(activePeriod)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        orgs,
        orgsIndex,
        schedules,
        schedulesIndex,
        scheduleDays,
        scheduleDaysIndex,
        groups,
        groupsIndex,
        groupsScheduleIndex,
        persons,
        personsIndex,
        groupPersons,
        groupPersonsIndex,
        attendances,
        attendancesIndex,
        settings,
        settingsIndex
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('schedules',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('schedule_days', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('group_persons',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('attendances', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

class OrgsViewResult {
  final int id;
  final String name;
  final String inn;
  final int activeGroupId;
  final int groupCount;
  OrgsViewResult({
    this.id,
    this.name,
    this.inn,
    this.activeGroupId,
    this.groupCount,
  });
}

class SchedulesViewResult {
  final int id;
  final String code;
  final int groupCount;
  SchedulesViewResult({
    this.id,
    this.code,
    this.groupCount,
  });
}

class GroupsViewResult {
  final int id;
  final int orgId;
  final String name;
  final int scheduleId;
  final String scheduleCode;
  final int meals;
  final int personCount;
  GroupsViewResult({
    this.id,
    this.orgId,
    this.name,
    this.scheduleId,
    this.scheduleCode,
    this.meals,
    this.personCount,
  });
}

class PersonsViewResult {
  final int id;
  final String family;
  final String name;
  final String middleName;
  final DateTime birthday;
  final String phone;
  final String phone2;
  final int groupCount;
  PersonsViewResult({
    this.id,
    this.family,
    this.name,
    this.middleName,
    this.birthday,
    this.phone,
    this.phone2,
    this.groupCount,
  });
}

class PersonsInGroupResult {
  final int id;
  final int groupId;
  final int personId;
  final DateTime beginDate;
  final DateTime endDate;
  final String family;
  final String name;
  final String middleName;
  final DateTime birthday;
  final String phone;
  final String phone2;
  final int attendanceCount;
  PersonsInGroupResult({
    this.id,
    this.groupId,
    this.personId,
    this.beginDate,
    this.endDate,
    this.family,
    this.name,
    this.middleName,
    this.birthday,
    this.phone,
    this.phone2,
    this.attendanceCount,
  });
}

class PersonsInGroupPeriodResult {
  final int id;
  final int groupId;
  final int personId;
  final DateTime beginDate;
  final DateTime endDate;
  final String family;
  final String name;
  final String middleName;
  final DateTime birthday;
  final String phone;
  final String phone2;
  final int attendanceCount;
  PersonsInGroupPeriodResult({
    this.id,
    this.groupId,
    this.personId,
    this.beginDate,
    this.endDate,
    this.family,
    this.name,
    this.middleName,
    this.birthday,
    this.phone,
    this.phone2,
    this.attendanceCount,
  });
}

class ActiveGroupResult {
  final int id;
  final int orgId;
  final String name;
  final int scheduleId;
  final String scheduleCode;
  final int meals;
  final int personCount;
  ActiveGroupResult({
    this.id,
    this.orgId,
    this.name,
    this.scheduleId,
    this.scheduleCode,
    this.meals,
    this.personCount,
  });
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$OrgsDaoMixin on DatabaseAccessor<Db> {}
mixin _$SchedulesDaoMixin on DatabaseAccessor<Db> {}
mixin _$ScheduleDaysDaoMixin on DatabaseAccessor<Db> {}
mixin _$GroupsDaoMixin on DatabaseAccessor<Db> {}
mixin _$PersonsDaoMixin on DatabaseAccessor<Db> {}
mixin _$GroupPersonsDaoMixin on DatabaseAccessor<Db> {}
mixin _$AttendancesDaoMixin on DatabaseAccessor<Db> {}
mixin _$SettingsDaoMixin on DatabaseAccessor<Db> {}
