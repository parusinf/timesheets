// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
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
        $customConstraints: 'NOT NULL REFERENCES schedules (id)');
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
  final String name;
  final int scheduleId;
  Group({@required this.id, @required this.name, @required this.scheduleId});
  factory Group.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Group(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
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
      name: serializer.fromJson<String>(json['name']),
      scheduleId: serializer.fromJson<int>(json['scheduleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'scheduleId': serializer.toJson<int>(scheduleId),
    };
  }

  Group copyWith({int id, String name, int scheduleId}) => Group(
        id: id ?? this.id,
        name: name ?? this.name,
        scheduleId: scheduleId ?? this.scheduleId,
      );
  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scheduleId: $scheduleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, scheduleId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.name == this.name &&
          other.scheduleId == this.scheduleId);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> scheduleId;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.scheduleId = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int scheduleId,
  })  : name = Value(name),
        scheduleId = Value(scheduleId);
  static Insertable<Group> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> scheduleId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (scheduleId != null) 'scheduleId': scheduleId,
    });
  }

  GroupsCompanion copyWith(
      {Value<int> id, Value<String> name, Value<int> scheduleId}) {
    return GroupsCompanion(
      id: id ?? this.id,
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
  List<GeneratedColumn> get $columns => [id, name, scheduleId];
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

class PersonGroupLink extends DataClass implements Insertable<PersonGroupLink> {
  final int id;
  final int personId;
  final int groupId;
  PersonGroupLink(
      {@required this.id, @required this.personId, @required this.groupId});
  factory PersonGroupLink.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return PersonGroupLink(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      personId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}personId']),
      groupId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}groupId']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || personId != null) {
      map['personId'] = Variable<int>(personId);
    }
    if (!nullToAbsent || groupId != null) {
      map['groupId'] = Variable<int>(groupId);
    }
    return map;
  }

  PersonGroupLinksCompanion toCompanion(bool nullToAbsent) {
    return PersonGroupLinksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
    );
  }

  factory PersonGroupLink.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PersonGroupLink(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['personId']),
      groupId: serializer.fromJson<int>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personId': serializer.toJson<int>(personId),
      'groupId': serializer.toJson<int>(groupId),
    };
  }

  PersonGroupLink copyWith({int id, int personId, int groupId}) =>
      PersonGroupLink(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        groupId: groupId ?? this.groupId,
      );
  @override
  String toString() {
    return (StringBuffer('PersonGroupLink(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(personId.hashCode, groupId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PersonGroupLink &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.groupId == this.groupId);
}

class PersonGroupLinksCompanion extends UpdateCompanion<PersonGroupLink> {
  final Value<int> id;
  final Value<int> personId;
  final Value<int> groupId;
  const PersonGroupLinksCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.groupId = const Value.absent(),
  });
  PersonGroupLinksCompanion.insert({
    this.id = const Value.absent(),
    @required int personId,
    @required int groupId,
  })  : personId = Value(personId),
        groupId = Value(groupId);
  static Insertable<PersonGroupLink> custom({
    Expression<int> id,
    Expression<int> personId,
    Expression<int> groupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'personId': personId,
      if (groupId != null) 'groupId': groupId,
    });
  }

  PersonGroupLinksCompanion copyWith(
      {Value<int> id, Value<int> personId, Value<int> groupId}) {
    return PersonGroupLinksCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['personId'] = Variable<int>(personId.value);
    }
    if (groupId.present) {
      map['groupId'] = Variable<int>(groupId.value);
    }
    return map;
  }
}

class PersonGroupLinks extends Table
    with TableInfo<PersonGroupLinks, PersonGroupLink> {
  final GeneratedDatabase _db;
  final String _alias;
  PersonGroupLinks(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _personIdMeta = const VerificationMeta('personId');
  GeneratedIntColumn _personId;
  GeneratedIntColumn get personId => _personId ??= _constructPersonId();
  GeneratedIntColumn _constructPersonId() {
    return GeneratedIntColumn('personId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES persons (id)');
  }

  final VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  GeneratedIntColumn _groupId;
  GeneratedIntColumn get groupId => _groupId ??= _constructGroupId();
  GeneratedIntColumn _constructGroupId() {
    return GeneratedIntColumn('groupId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES "groups" (id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, personId, groupId];
  @override
  PersonGroupLinks get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'person_group_links';
  @override
  final String actualTableName = 'person_group_links';
  @override
  VerificationContext validateIntegrity(Insertable<PersonGroupLink> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('personId')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['personId'], _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('groupId')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['groupId'], _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonGroupLink map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PersonGroupLink.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  PersonGroupLinks createAlias(String alias) {
    return PersonGroupLinks(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Timesheet extends DataClass implements Insertable<Timesheet> {
  final int id;
  final int personGroupLinkId;
  final DateTime attendanceDate;
  final double hoursNumber;
  Timesheet(
      {@required this.id,
      @required this.personGroupLinkId,
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
      personGroupLinkId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}personGroupLinkId']),
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
    if (!nullToAbsent || personGroupLinkId != null) {
      map['personGroupLinkId'] = Variable<int>(personGroupLinkId);
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
      personGroupLinkId: personGroupLinkId == null && nullToAbsent
          ? const Value.absent()
          : Value(personGroupLinkId),
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
      personGroupLinkId: serializer.fromJson<int>(json['personGroupLinkId']),
      attendanceDate: serializer.fromJson<DateTime>(json['attendanceDate']),
      hoursNumber: serializer.fromJson<double>(json['hoursNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personGroupLinkId': serializer.toJson<int>(personGroupLinkId),
      'attendanceDate': serializer.toJson<DateTime>(attendanceDate),
      'hoursNumber': serializer.toJson<double>(hoursNumber),
    };
  }

  Timesheet copyWith(
          {int id,
          int personGroupLinkId,
          DateTime attendanceDate,
          double hoursNumber}) =>
      Timesheet(
        id: id ?? this.id,
        personGroupLinkId: personGroupLinkId ?? this.personGroupLinkId,
        attendanceDate: attendanceDate ?? this.attendanceDate,
        hoursNumber: hoursNumber ?? this.hoursNumber,
      );
  @override
  String toString() {
    return (StringBuffer('Timesheet(')
          ..write('id: $id, ')
          ..write('personGroupLinkId: $personGroupLinkId, ')
          ..write('attendanceDate: $attendanceDate, ')
          ..write('hoursNumber: $hoursNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(personGroupLinkId.hashCode,
          $mrjc(attendanceDate.hashCode, hoursNumber.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Timesheet &&
          other.id == this.id &&
          other.personGroupLinkId == this.personGroupLinkId &&
          other.attendanceDate == this.attendanceDate &&
          other.hoursNumber == this.hoursNumber);
}

class TimesheetsCompanion extends UpdateCompanion<Timesheet> {
  final Value<int> id;
  final Value<int> personGroupLinkId;
  final Value<DateTime> attendanceDate;
  final Value<double> hoursNumber;
  const TimesheetsCompanion({
    this.id = const Value.absent(),
    this.personGroupLinkId = const Value.absent(),
    this.attendanceDate = const Value.absent(),
    this.hoursNumber = const Value.absent(),
  });
  TimesheetsCompanion.insert({
    this.id = const Value.absent(),
    @required int personGroupLinkId,
    @required DateTime attendanceDate,
    @required double hoursNumber,
  })  : personGroupLinkId = Value(personGroupLinkId),
        attendanceDate = Value(attendanceDate),
        hoursNumber = Value(hoursNumber);
  static Insertable<Timesheet> custom({
    Expression<int> id,
    Expression<int> personGroupLinkId,
    Expression<DateTime> attendanceDate,
    Expression<double> hoursNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personGroupLinkId != null) 'personGroupLinkId': personGroupLinkId,
      if (attendanceDate != null) 'attendanceDate': attendanceDate,
      if (hoursNumber != null) 'hoursNumber': hoursNumber,
    });
  }

  TimesheetsCompanion copyWith(
      {Value<int> id,
      Value<int> personGroupLinkId,
      Value<DateTime> attendanceDate,
      Value<double> hoursNumber}) {
    return TimesheetsCompanion(
      id: id ?? this.id,
      personGroupLinkId: personGroupLinkId ?? this.personGroupLinkId,
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
    if (personGroupLinkId.present) {
      map['personGroupLinkId'] = Variable<int>(personGroupLinkId.value);
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

  final VerificationMeta _personGroupLinkIdMeta =
      const VerificationMeta('personGroupLinkId');
  GeneratedIntColumn _personGroupLinkId;
  GeneratedIntColumn get personGroupLinkId =>
      _personGroupLinkId ??= _constructPersonGroupLinkId();
  GeneratedIntColumn _constructPersonGroupLinkId() {
    return GeneratedIntColumn('personGroupLinkId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES person_group_links (id)');
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
      [id, personGroupLinkId, attendanceDate, hoursNumber];
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
    if (data.containsKey('personGroupLinkId')) {
      context.handle(
          _personGroupLinkIdMeta,
          personGroupLinkId.isAcceptableOrUnknown(
              data['personGroupLinkId'], _personGroupLinkIdMeta));
    } else if (isInserting) {
      context.missing(_personGroupLinkIdMeta);
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

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$Database.connect(DatabaseConnection c) : super.connect(c);
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
      'CREATE UNIQUE INDEX groups_index ON "groups" (name, scheduleId);');
  Persons _persons;
  Persons get persons => _persons ??= Persons(this);
  Index _personsIndex;
  Index get personsIndex => _personsIndex ??= Index('persons_index',
      'CREATE UNIQUE INDEX persons_index ON persons (family, name, middleName, birthday);');
  PersonGroupLinks _personGroupLinks;
  PersonGroupLinks get personGroupLinks =>
      _personGroupLinks ??= PersonGroupLinks(this);
  Index _personGroupLinksIndex;
  Index get personGroupLinksIndex => _personGroupLinksIndex ??= Index(
      'person_group_links_index',
      'CREATE UNIQUE INDEX person_group_links_index ON person_group_links (personId, groupId);');
  Timesheets _timesheets;
  Timesheets get timesheets => _timesheets ??= Timesheets(this);
  Index _timesheetsIndex;
  Index get timesheetsIndex => _timesheetsIndex ??= Index('timesheets_index',
      'CREATE UNIQUE INDEX timesheets_index ON timesheets (personGroupLinkId, attendanceDate);');
  Settings _settings;
  Settings get settings => _settings ??= Settings(this);
  Index _settingsIndex;
  Index get settingsIndex => _settingsIndex ??= Index('settings_index',
      'CREATE UNIQUE INDEX settings_index ON settings (name);');
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

  GroupsExtrasResult _rowToGroupsExtrasResult(QueryRow row) {
    return GroupsExtrasResult(
      id: row.readInt('id'),
      name: row.readString('name'),
      scheduleId: row.readInt('scheduleId'),
      scheduleCode: row.readString('scheduleCode'),
      personsAmount: row.readInt('personsAmount'),
    );
  }

  Selectable<GroupsExtrasResult> _groupsExtras() {
    return customSelect(
        'SELECT G.id,\n       G.name,\n       G.scheduleId,\n       S.code AS scheduleCode,\n       COUNT(*) AS personsAmount\n  FROM "groups" G\n INNER JOIN schedules S ON S.id = G.scheduleId\n INNER JOIN person_group_links L ON L.groupId = G.id\n GROUP BY\n       G.id,\n       G.name,\n       G.scheduleId,\n       S.code',
        variables: [],
        readsFrom: {
          groups,
          schedules,
          personGroupLinks
        }).map(_rowToGroupsExtrasResult);
  }

  PersonsInGroupResult _rowToPersonsInGroupResult(QueryRow row) {
    return PersonsInGroupResult(
      personGroupLinkId: row.readInt('personGroupLinkId'),
      personId: row.readInt('personId'),
      family: row.readString('family'),
      name: row.readString('name'),
      middleName: row.readString('middleName'),
      birthday: row.readDateTime('birthday'),
    );
  }

  Selectable<PersonsInGroupResult> _personsInGroup(int groupId) {
    return customSelect(
        'SELECT L.id AS personGroupLinkId,\n       L.personId,\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday\n  FROM person_group_links L\n INNER JOIN persons P ON P.id = L.personId\n WHERE L.groupId = :groupId\n ORDER BY\n       P.family,\n       P.name,\n       P.middleName',
        variables: [Variable.withInt(groupId)],
        readsFrom: {personGroupLinks, persons}).map(_rowToPersonsInGroupResult);
  }

  Timesheet _rowToTimesheet(QueryRow row) {
    return Timesheet(
      id: row.readInt('id'),
      personGroupLinkId: row.readInt('personGroupLinkId'),
      attendanceDate: row.readDateTime('attendanceDate'),
      hoursNumber: row.readDouble('hoursNumber'),
    );
  }

  Selectable<Timesheet> _timesheetsOfPersonInGroupForPeriod(
      int personGroupLinkId, String period) {
    return customSelect(
        'SELECT *\n  FROM timesheets\n WHERE personGroupLinkId = :personGroupLinkId\n   AND attendanceDate BETWEEN date(:period, \'start of month\') AND :period',
        variables: [
          Variable.withInt(personGroupLinkId),
          Variable.withString(period)
        ],
        readsFrom: {
          timesheets
        }).map(_rowToTimesheet);
  }

  Group _rowToGroup(QueryRow row) {
    return Group(
      id: row.readInt('id'),
      name: row.readString('name'),
      scheduleId: row.readInt('scheduleId'),
    );
  }

  Selectable<Group> _activeGroup() {
    return customSelect(
        'SELECT G.*\n  FROM settings S\n INNER JOIN "groups" G ON G.id = S.intValue\n WHERE S.name = \'activeGroup\'',
        variables: [],
        readsFrom: {settings, groups}).map(_rowToGroup);
  }

  Future<int> _setActiveGroup(int groupId) {
    return customUpdate(
      'UPDATE settings SET intValue = :groupId WHERE name = \'activeGroup\'',
      variables: [Variable.withInt(groupId)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        schedules,
        schedulesIndex,
        scheduleDays,
        scheduleDaysIndex,
        groups,
        groupsIndex,
        persons,
        personsIndex,
        personGroupLinks,
        personGroupLinksIndex,
        timesheets,
        timesheetsIndex,
        settings,
        settingsIndex
      ];
}

class GroupsExtrasResult {
  final int id;
  final String name;
  final int scheduleId;
  final String scheduleCode;
  final int personsAmount;
  GroupsExtrasResult({
    this.id,
    this.name,
    this.scheduleId,
    this.scheduleCode,
    this.personsAmount,
  });
}

class PersonsInGroupResult {
  final int personGroupLinkId;
  final int personId;
  final String family;
  final String name;
  final String middleName;
  final DateTime birthday;
  PersonsInGroupResult({
    this.personGroupLinkId,
    this.personId,
    this.family,
    this.name,
    this.middleName,
    this.birthday,
  });
}
