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
  Group(
      {@required this.id,
      @required this.orgId,
      @required this.name,
      @required this.scheduleId});
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
    };
  }

  Group copyWith({int id, int orgId, String name, int scheduleId}) => Group(
        id: id ?? this.id,
        orgId: orgId ?? this.orgId,
        name: name ?? this.name,
        scheduleId: scheduleId ?? this.scheduleId,
      );
  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('name: $name, ')
          ..write('scheduleId: $scheduleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(orgId.hashCode, $mrjc(name.hashCode, scheduleId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.name == this.name &&
          other.scheduleId == this.scheduleId);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<int> orgId;
  final Value<String> name;
  final Value<int> scheduleId;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.name = const Value.absent(),
    this.scheduleId = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    @required int orgId,
    @required String name,
    @required int scheduleId,
  })  : orgId = Value(orgId),
        name = Value(name),
        scheduleId = Value(scheduleId);
  static Insertable<Group> custom({
    Expression<int> id,
    Expression<int> orgId,
    Expression<String> name,
    Expression<int> scheduleId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'orgId': orgId,
      if (name != null) 'name': name,
      if (scheduleId != null) 'scheduleId': scheduleId,
    });
  }

  GroupsCompanion copyWith(
      {Value<int> id,
      Value<int> orgId,
      Value<String> name,
      Value<int> scheduleId}) {
    return GroupsCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      scheduleId: scheduleId ?? this.scheduleId,
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
    return map;
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

  @override
  List<GeneratedColumn> get $columns => [id, orgId, name, scheduleId];
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
  Person(
      {@required this.id,
      @required this.family,
      @required this.name,
      this.middleName,
      this.birthday});
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
    };
  }

  Person copyWith(
          {int id,
          String family,
          String name,
          String middleName,
          DateTime birthday}) =>
      Person(
        id: id ?? this.id,
        family: family ?? this.family,
        name: name ?? this.name,
        middleName: middleName ?? this.middleName,
        birthday: birthday ?? this.birthday,
      );
  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('family: $family, ')
          ..write('name: $name, ')
          ..write('middleName: $middleName, ')
          ..write('birthday: $birthday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          family.hashCode,
          $mrjc(
              name.hashCode, $mrjc(middleName.hashCode, birthday.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.family == this.family &&
          other.name == this.name &&
          other.middleName == this.middleName &&
          other.birthday == this.birthday);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> family;
  final Value<String> name;
  final Value<String> middleName;
  final Value<DateTime> birthday;
  const PersonsCompanion({
    this.id = const Value.absent(),
    this.family = const Value.absent(),
    this.name = const Value.absent(),
    this.middleName = const Value.absent(),
    this.birthday = const Value.absent(),
  });
  PersonsCompanion.insert({
    this.id = const Value.absent(),
    @required String family,
    @required String name,
    this.middleName = const Value.absent(),
    this.birthday = const Value.absent(),
  })  : family = Value(family),
        name = Value(name);
  static Insertable<Person> custom({
    Expression<int> id,
    Expression<String> family,
    Expression<String> name,
    Expression<String> middleName,
    Expression<DateTime> birthday,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (family != null) 'family': family,
      if (name != null) 'name': name,
      if (middleName != null) 'middleName': middleName,
      if (birthday != null) 'birthday': birthday,
    });
  }

  PersonsCompanion copyWith(
      {Value<int> id,
      Value<String> family,
      Value<String> name,
      Value<String> middleName,
      Value<DateTime> birthday}) {
    return PersonsCompanion(
      id: id ?? this.id,
      family: family ?? this.family,
      name: name ?? this.name,
      middleName: middleName ?? this.middleName,
      birthday: birthday ?? this.birthday,
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
    return map;
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

  @override
  List<GeneratedColumn> get $columns =>
      [id, family, name, middleName, birthday];
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

class GroupPersonLink extends DataClass implements Insertable<GroupPersonLink> {
  final int id;
  final int groupId;
  final int personId;
  GroupPersonLink(
      {@required this.id, @required this.groupId, @required this.personId});
  factory GroupPersonLink.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return GroupPersonLink(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      groupId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}groupId']),
      personId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}personId']),
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
    return map;
  }

  GroupPersonLinksCompanion toCompanion(bool nullToAbsent) {
    return GroupPersonLinksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
    );
  }

  factory GroupPersonLink.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return GroupPersonLink(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      personId: serializer.fromJson<int>(json['personId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'personId': serializer.toJson<int>(personId),
    };
  }

  GroupPersonLink copyWith({int id, int groupId, int personId}) =>
      GroupPersonLink(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        personId: personId ?? this.personId,
      );
  @override
  String toString() {
    return (StringBuffer('GroupPersonLink(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('personId: $personId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(groupId.hashCode, personId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is GroupPersonLink &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.personId == this.personId);
}

class GroupPersonLinksCompanion extends UpdateCompanion<GroupPersonLink> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> personId;
  const GroupPersonLinksCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.personId = const Value.absent(),
  });
  GroupPersonLinksCompanion.insert({
    this.id = const Value.absent(),
    @required int groupId,
    @required int personId,
  })  : groupId = Value(groupId),
        personId = Value(personId);
  static Insertable<GroupPersonLink> custom({
    Expression<int> id,
    Expression<int> groupId,
    Expression<int> personId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'groupId': groupId,
      if (personId != null) 'personId': personId,
    });
  }

  GroupPersonLinksCompanion copyWith(
      {Value<int> id, Value<int> groupId, Value<int> personId}) {
    return GroupPersonLinksCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      personId: personId ?? this.personId,
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
    return map;
  }
}

class GroupPersonLinks extends Table
    with TableInfo<GroupPersonLinks, GroupPersonLink> {
  final GeneratedDatabase _db;
  final String _alias;
  GroupPersonLinks(this._db, [this._alias]);
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

  @override
  List<GeneratedColumn> get $columns => [id, groupId, personId];
  @override
  GroupPersonLinks get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'group_person_links';
  @override
  final String actualTableName = 'group_person_links';
  @override
  VerificationContext validateIntegrity(Insertable<GroupPersonLink> instance,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupPersonLink map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return GroupPersonLink.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  GroupPersonLinks createAlias(String alias) {
    return GroupPersonLinks(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Timesheet extends DataClass implements Insertable<Timesheet> {
  final int id;
  final int groupPersonLinkId;
  final DateTime attendanceDate;
  final double hoursNumber;
  Timesheet(
      {@required this.id,
      @required this.groupPersonLinkId,
      @required this.attendanceDate,
      @required this.hoursNumber});
  factory Timesheet.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Timesheet(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      groupPersonLinkId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}groupPersonLinkId']),
      attendanceDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}attendanceDate']),
      hoursNumber: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}hoursNumber']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || groupPersonLinkId != null) {
      map['groupPersonLinkId'] = Variable<int>(groupPersonLinkId);
    }
    if (!nullToAbsent || attendanceDate != null) {
      map['attendanceDate'] = Variable<DateTime>(attendanceDate);
    }
    if (!nullToAbsent || hoursNumber != null) {
      map['hoursNumber'] = Variable<double>(hoursNumber);
    }
    return map;
  }

  TimesheetsCompanion toCompanion(bool nullToAbsent) {
    return TimesheetsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      groupPersonLinkId: groupPersonLinkId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupPersonLinkId),
      attendanceDate: attendanceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(attendanceDate),
      hoursNumber: hoursNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(hoursNumber),
    );
  }

  factory Timesheet.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Timesheet(
      id: serializer.fromJson<int>(json['id']),
      groupPersonLinkId: serializer.fromJson<int>(json['groupPersonLinkId']),
      attendanceDate: serializer.fromJson<DateTime>(json['attendanceDate']),
      hoursNumber: serializer.fromJson<double>(json['hoursNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupPersonLinkId': serializer.toJson<int>(groupPersonLinkId),
      'attendanceDate': serializer.toJson<DateTime>(attendanceDate),
      'hoursNumber': serializer.toJson<double>(hoursNumber),
    };
  }

  Timesheet copyWith(
          {int id,
          int groupPersonLinkId,
          DateTime attendanceDate,
          double hoursNumber}) =>
      Timesheet(
        id: id ?? this.id,
        groupPersonLinkId: groupPersonLinkId ?? this.groupPersonLinkId,
        attendanceDate: attendanceDate ?? this.attendanceDate,
        hoursNumber: hoursNumber ?? this.hoursNumber,
      );
  @override
  String toString() {
    return (StringBuffer('Timesheet(')
          ..write('id: $id, ')
          ..write('groupPersonLinkId: $groupPersonLinkId, ')
          ..write('attendanceDate: $attendanceDate, ')
          ..write('hoursNumber: $hoursNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(groupPersonLinkId.hashCode,
          $mrjc(attendanceDate.hashCode, hoursNumber.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Timesheet &&
          other.id == this.id &&
          other.groupPersonLinkId == this.groupPersonLinkId &&
          other.attendanceDate == this.attendanceDate &&
          other.hoursNumber == this.hoursNumber);
}

class TimesheetsCompanion extends UpdateCompanion<Timesheet> {
  final Value<int> id;
  final Value<int> groupPersonLinkId;
  final Value<DateTime> attendanceDate;
  final Value<double> hoursNumber;
  const TimesheetsCompanion({
    this.id = const Value.absent(),
    this.groupPersonLinkId = const Value.absent(),
    this.attendanceDate = const Value.absent(),
    this.hoursNumber = const Value.absent(),
  });
  TimesheetsCompanion.insert({
    this.id = const Value.absent(),
    @required int groupPersonLinkId,
    @required DateTime attendanceDate,
    @required double hoursNumber,
  })  : groupPersonLinkId = Value(groupPersonLinkId),
        attendanceDate = Value(attendanceDate),
        hoursNumber = Value(hoursNumber);
  static Insertable<Timesheet> custom({
    Expression<int> id,
    Expression<int> groupPersonLinkId,
    Expression<DateTime> attendanceDate,
    Expression<double> hoursNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupPersonLinkId != null) 'groupPersonLinkId': groupPersonLinkId,
      if (attendanceDate != null) 'attendanceDate': attendanceDate,
      if (hoursNumber != null) 'hoursNumber': hoursNumber,
    });
  }

  TimesheetsCompanion copyWith(
      {Value<int> id,
      Value<int> groupPersonLinkId,
      Value<DateTime> attendanceDate,
      Value<double> hoursNumber}) {
    return TimesheetsCompanion(
      id: id ?? this.id,
      groupPersonLinkId: groupPersonLinkId ?? this.groupPersonLinkId,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      hoursNumber: hoursNumber ?? this.hoursNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupPersonLinkId.present) {
      map['groupPersonLinkId'] = Variable<int>(groupPersonLinkId.value);
    }
    if (attendanceDate.present) {
      map['attendanceDate'] = Variable<DateTime>(attendanceDate.value);
    }
    if (hoursNumber.present) {
      map['hoursNumber'] = Variable<double>(hoursNumber.value);
    }
    return map;
  }
}

class Timesheets extends Table with TableInfo<Timesheets, Timesheet> {
  final GeneratedDatabase _db;
  final String _alias;
  Timesheets(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _groupPersonLinkIdMeta =
      const VerificationMeta('groupPersonLinkId');
  GeneratedIntColumn _groupPersonLinkId;
  GeneratedIntColumn get groupPersonLinkId =>
      _groupPersonLinkId ??= _constructGroupPersonLinkId();
  GeneratedIntColumn _constructGroupPersonLinkId() {
    return GeneratedIntColumn('groupPersonLinkId', $tableName, false,
        $customConstraints:
            'NOT NULL REFERENCES group_person_links (id) ON DELETE CASCADE');
  }

  final VerificationMeta _attendanceDateMeta =
      const VerificationMeta('attendanceDate');
  GeneratedDateTimeColumn _attendanceDate;
  GeneratedDateTimeColumn get attendanceDate =>
      _attendanceDate ??= _constructAttendanceDate();
  GeneratedDateTimeColumn _constructAttendanceDate() {
    return GeneratedDateTimeColumn('attendanceDate', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _hoursNumberMeta =
      const VerificationMeta('hoursNumber');
  GeneratedRealColumn _hoursNumber;
  GeneratedRealColumn get hoursNumber =>
      _hoursNumber ??= _constructHoursNumber();
  GeneratedRealColumn _constructHoursNumber() {
    return GeneratedRealColumn('hoursNumber', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, groupPersonLinkId, attendanceDate, hoursNumber];
  @override
  Timesheets get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'timesheets';
  @override
  final String actualTableName = 'timesheets';
  @override
  VerificationContext validateIntegrity(Insertable<Timesheet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('groupPersonLinkId')) {
      context.handle(
          _groupPersonLinkIdMeta,
          groupPersonLinkId.isAcceptableOrUnknown(
              data['groupPersonLinkId'], _groupPersonLinkIdMeta));
    } else if (isInserting) {
      context.missing(_groupPersonLinkIdMeta);
    }
    if (data.containsKey('attendanceDate')) {
      context.handle(
          _attendanceDateMeta,
          attendanceDate.isAcceptableOrUnknown(
              data['attendanceDate'], _attendanceDateMeta));
    } else if (isInserting) {
      context.missing(_attendanceDateMeta);
    }
    if (data.containsKey('hoursNumber')) {
      context.handle(
          _hoursNumberMeta,
          hoursNumber.isAcceptableOrUnknown(
              data['hoursNumber'], _hoursNumberMeta));
    } else if (isInserting) {
      context.missing(_hoursNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Timesheet map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Timesheet.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Timesheets createAlias(String alias) {
    return Timesheets(_db, alias);
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
  Index get orgsIndex => _orgsIndex ??= Index(
      'orgs_index', 'CREATE UNIQUE INDEX orgs_index ON orgs (name, inn);');
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
  GroupPersonLinks _groupPersonLinks;
  GroupPersonLinks get groupPersonLinks =>
      _groupPersonLinks ??= GroupPersonLinks(this);
  Index _groupPersonLinksIndex;
  Index get groupPersonLinksIndex => _groupPersonLinksIndex ??= Index(
      'group_person_links_index',
      'CREATE UNIQUE INDEX group_person_links_index ON group_person_links (groupId, personId);');
  Timesheets _timesheets;
  Timesheets get timesheets => _timesheets ??= Timesheets(this);
  Index _timesheetsIndex;
  Index get timesheetsIndex => _timesheetsIndex ??= Index('timesheets_index',
      'CREATE UNIQUE INDEX timesheets_index ON timesheets (groupPersonLinkId, attendanceDate);');
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
  GroupPersonLinksDao _groupPersonLinksDao;
  GroupPersonLinksDao get groupPersonLinksDao =>
      _groupPersonLinksDao ??= GroupPersonLinksDao(this as Db);
  TimesheetsDao _timesheetsDao;
  TimesheetsDao get timesheetsDao =>
      _timesheetsDao ??= TimesheetsDao(this as Db);
  SettingsDao _settingsDao;
  SettingsDao get settingsDao => _settingsDao ??= SettingsDao(this as Db);
  ScheduleDay _rowToScheduleDay(QueryRow row) {
    return ScheduleDay(
      id: row.readInt('id'),
      scheduleId: row.readInt('scheduleId'),
      dayNumber: row.readInt('dayNumber'),
      hoursNorm: row.readDouble('hoursNorm'),
    );
  }

  Selectable<ScheduleDay> _daysInSchedule(int scheduleId) {
    return customSelect(
        'SELECT *\n  FROM schedule_days\n WHERE scheduleId = :scheduleId',
        variables: [Variable.withInt(scheduleId)],
        readsFrom: {scheduleDays}).map(_rowToScheduleDay);
  }

  Org _rowToOrg(QueryRow row) {
    return Org(
      id: row.readInt('id'),
      name: row.readString('name'),
      inn: row.readString('inn'),
      activeGroupId: row.readInt('activeGroupId'),
    );
  }

  Selectable<Org> _firstOrg() {
    return customSelect(
        'SELECT *\n  FROM orgs\n WHERE name =\n       (\n         SELECT MIN(name)\n           FROM orgs\n       )',
        variables: [],
        readsFrom: {orgs}).map(_rowToOrg);
  }

  Selectable<Org> _previousOrg(String orgName) {
    return customSelect(
        'SELECT *\n  FROM orgs\n WHERE name =\n       (\n         SELECT MAX(name)\n           FROM orgs\n          WHERE name < :orgName\n       )',
        variables: [Variable.withString(orgName)],
        readsFrom: {orgs}).map(_rowToOrg);
  }

  Schedule _rowToSchedule(QueryRow row) {
    return Schedule(
      id: row.readInt('id'),
      code: row.readString('code'),
    );
  }

  Selectable<Schedule> _firstSchedule() {
    return customSelect(
        'SELECT *\n  FROM schedules\n WHERE code =\n       (\n         SELECT MIN(code)\n           FROM schedules\n       )',
        variables: [],
        readsFrom: {schedules}).map(_rowToSchedule);
  }

  Selectable<Schedule> _previousSchedule(String scheduleCode) {
    return customSelect(
        'SELECT *\n  FROM schedules\n WHERE code =\n       (\n         SELECT MAX(code)\n           FROM schedules\n          WHERE code < :scheduleCode\n       )',
        variables: [Variable.withString(scheduleCode)],
        readsFrom: {schedules}).map(_rowToSchedule);
  }

  Group _rowToGroup(QueryRow row) {
    return Group(
      id: row.readInt('id'),
      orgId: row.readInt('orgId'),
      name: row.readString('name'),
      scheduleId: row.readInt('scheduleId'),
    );
  }

  Selectable<Group> _firstGroup(int orgId) {
    return customSelect(
        'SELECT *\n  FROM "groups"\n WHERE orgId = :orgId\n   AND name =\n       (\n         SELECT MIN(name)\n           FROM "groups"\n          WHERE orgId = :orgId\n       )',
        variables: [Variable.withInt(orgId)],
        readsFrom: {groups}).map(_rowToGroup);
  }

  Selectable<Group> _previousGroup(int orgId, String groupName) {
    return customSelect(
        'SELECT *\n  FROM "groups"\n WHERE orgId = :orgId\n   AND name =\n       (\n         SELECT MAX(name)\n           FROM "groups"\n          WHERE name < :groupName\n       )',
        variables: [Variable.withInt(orgId), Variable.withString(groupName)],
        readsFrom: {groups}).map(_rowToGroup);
  }

  OrgsViewResult _rowToOrgsViewResult(QueryRow row) {
    return OrgsViewResult(
      id: row.readInt('id'),
      name: row.readString('name'),
      inn: row.readString('inn'),
      activeGroupId: row.readInt('activeGroupId'),
      groupCount: row.readInt('groupCount'),
    );
  }

  Selectable<OrgsViewResult> _orgsView() {
    return customSelect(
        'SELECT O.id,\n       O.name,\n       O.inn,\n       O.activeGroupId,\n       CAST((SELECT COUNT(*) FROM "groups" WHERE orgId = O.id) AS INT) AS groupCount\n  FROM orgs O\n ORDER BY\n       O.name,\n       O.inn',
        variables: [],
        readsFrom: {orgs, groups}).map(_rowToOrgsViewResult);
  }

  SchedulesViewResult _rowToSchedulesViewResult(QueryRow row) {
    return SchedulesViewResult(
      id: row.readInt('id'),
      code: row.readString('code'),
      groupCount: row.readInt('groupCount'),
    );
  }

  Selectable<SchedulesViewResult> _schedulesView() {
    return customSelect(
        'SELECT S.id,\n       S.code,\n       CAST((SELECT COUNT(*) FROM "groups" WHERE scheduleId = S.id) AS INT) AS groupCount\n  FROM schedules S\n ORDER BY\n       S.code',
        variables: [],
        readsFrom: {schedules, groups}).map(_rowToSchedulesViewResult);
  }

  GroupsViewResult _rowToGroupsViewResult(QueryRow row) {
    return GroupsViewResult(
      id: row.readInt('id'),
      orgId: row.readInt('orgId'),
      name: row.readString('name'),
      scheduleId: row.readInt('scheduleId'),
      scheduleCode: row.readString('scheduleCode'),
      personCount: row.readInt('personCount'),
    );
  }

  Selectable<GroupsViewResult> _groupsView(int orgId) {
    return customSelect(
        'SELECT G.id,\n       G.orgId,\n       G.name,\n       G.scheduleId,\n       S.code AS scheduleCode,\n       CAST((SELECT COUNT(*) FROM group_person_links WHERE groupId = G.id) AS INT) AS personCount\n  FROM "groups" G\n INNER JOIN schedules S ON S.id = G.scheduleId\n WHERE orgId = :orgId\n ORDER BY\n       G.name,\n       S.code',
        variables: [
          Variable.withInt(orgId)
        ],
        readsFrom: {
          groups,
          schedules,
          groupPersonLinks
        }).map(_rowToGroupsViewResult);
  }

  PersonsInGroupResult _rowToPersonsInGroupResult(QueryRow row) {
    return PersonsInGroupResult(
      groupPersonLinkId: row.readInt('groupPersonLinkId'),
      personId: row.readInt('personId'),
      family: row.readString('family'),
      name: row.readString('name'),
      middleName: row.readString('middleName'),
      birthday: row.readDateTime('birthday'),
    );
  }

  Selectable<PersonsInGroupResult> _personsInGroup(int groupId) {
    return customSelect(
        'SELECT L.id AS groupPersonLinkId,\n       L.personId,\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday\n  FROM group_person_links L\n INNER JOIN persons P ON P.id = L.personId\n WHERE L.groupId = :groupId\n ORDER BY\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday',
        variables: [Variable.withInt(groupId)],
        readsFrom: {groupPersonLinks, persons}).map(_rowToPersonsInGroupResult);
  }

  Timesheet _rowToTimesheet(QueryRow row) {
    return Timesheet(
      id: row.readInt('id'),
      groupPersonLinkId: row.readInt('groupPersonLinkId'),
      attendanceDate: row.readDateTime('attendanceDate'),
      hoursNumber: row.readDouble('hoursNumber'),
    );
  }

  Selectable<Timesheet> _timesheetsView(int groupPersonLinkId, String period) {
    return customSelect(
        'SELECT *\n  FROM timesheets\n WHERE groupPersonLinkId = :groupPersonLinkId\n   AND attendanceDate BETWEEN date(:period, \'start of month\') AND :period',
        variables: [
          Variable.withInt(groupPersonLinkId),
          Variable.withString(period)
        ],
        readsFrom: {
          timesheets
        }).map(_rowToTimesheet);
  }

  Selectable<Org> _activeOrg() {
    return customSelect(
        'SELECT O.*\n  FROM settings S\n INNER JOIN orgs O ON O.id = S.intValue\n WHERE S.name = \'activeOrg\'',
        variables: [],
        readsFrom: {settings, orgs}).map(_rowToOrg);
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
        readsFrom: {settings, schedules}).map(_rowToSchedule);
  }

  Future<int> _setActiveSchedule(int id) {
    return customUpdate(
      'UPDATE settings SET intValue = :id WHERE name = \'activeSchedule\'',
      variables: [Variable.withInt(id)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
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
        groupPersonLinks,
        groupPersonLinksIndex,
        timesheets,
        timesheetsIndex,
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
            on: TableUpdateQuery.onTableName('group_person_links',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('timesheets', kind: UpdateKind.delete),
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
  final int personCount;
  GroupsViewResult({
    this.id,
    this.orgId,
    this.name,
    this.scheduleId,
    this.scheduleCode,
    this.personCount,
  });
}

class PersonsInGroupResult {
  final int groupPersonLinkId;
  final int personId;
  final String family;
  final String name;
  final String middleName;
  final DateTime birthday;
  PersonsInGroupResult({
    this.groupPersonLinkId,
    this.personId,
    this.family,
    this.name,
    this.middleName,
    this.birthday,
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
mixin _$GroupPersonLinksDaoMixin on DatabaseAccessor<Db> {}
mixin _$TimesheetsDaoMixin on DatabaseAccessor<Db> {}
mixin _$SettingsDaoMixin on DatabaseAccessor<Db> {}
