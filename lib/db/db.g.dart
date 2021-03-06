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
    return Org(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      inn: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}inn']),
      activeGroupId: const IntType()
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
  bool operator ==(Object other) =>
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
    return Org.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
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
    return Schedule(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      code: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}code']),
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
  bool operator ==(Object other) =>
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
    return Schedule.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
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
    return ScheduleDay(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      scheduleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}scheduleId']),
      dayNumber: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dayNumber']),
      hoursNorm: const RealType()
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
  bool operator ==(Object other) =>
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
    return ScheduleDay.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  ScheduleDays createAlias(String alias) {
    return ScheduleDays(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Holiday extends DataClass implements Insertable<Holiday> {
  final int id;
  final DateTime date;
  final DateTime workday;
  Holiday({@required this.id, @required this.date, this.workday});
  factory Holiday.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Holiday(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date']),
      workday: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}workday']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || workday != null) {
      map['workday'] = Variable<DateTime>(workday);
    }
    return map;
  }

  HolidaysCompanion toCompanion(bool nullToAbsent) {
    return HolidaysCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      workday: workday == null && nullToAbsent
          ? const Value.absent()
          : Value(workday),
    );
  }

  factory Holiday.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Holiday(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      workday: serializer.fromJson<DateTime>(json['workday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'workday': serializer.toJson<DateTime>(workday),
    };
  }

  Holiday copyWith({int id, DateTime date, DateTime workday}) => Holiday(
        id: id ?? this.id,
        date: date ?? this.date,
        workday: workday ?? this.workday,
      );
  @override
  String toString() {
    return (StringBuffer('Holiday(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('workday: $workday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(date.hashCode, workday.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Holiday &&
          other.id == this.id &&
          other.date == this.date &&
          other.workday == this.workday);
}

class HolidaysCompanion extends UpdateCompanion<Holiday> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<DateTime> workday;
  const HolidaysCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.workday = const Value.absent(),
  });
  HolidaysCompanion.insert({
    this.id = const Value.absent(),
    @required DateTime date,
    this.workday = const Value.absent(),
  }) : date = Value(date);
  static Insertable<Holiday> custom({
    Expression<int> id,
    Expression<DateTime> date,
    Expression<DateTime> workday,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (workday != null) 'workday': workday,
    });
  }

  HolidaysCompanion copyWith(
      {Value<int> id, Value<DateTime> date, Value<DateTime> workday}) {
    return HolidaysCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      workday: workday ?? this.workday,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (workday.present) {
      map['workday'] = Variable<DateTime>(workday.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HolidaysCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('workday: $workday')
          ..write(')'))
        .toString();
  }
}

class Holidays extends Table with TableInfo<Holidays, Holiday> {
  final GeneratedDatabase _db;
  final String _alias;
  Holidays(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn('date', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _workdayMeta = const VerificationMeta('workday');
  GeneratedDateTimeColumn _workday;
  GeneratedDateTimeColumn get workday => _workday ??= _constructWorkday();
  GeneratedDateTimeColumn _constructWorkday() {
    return GeneratedDateTimeColumn('workday', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns => [id, date, workday];
  @override
  Holidays get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'holidays';
  @override
  final String actualTableName = 'holidays';
  @override
  VerificationContext validateIntegrity(Insertable<Holiday> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('workday')) {
      context.handle(_workdayMeta,
          workday.isAcceptableOrUnknown(data['workday'], _workdayMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Holiday map(Map<String, dynamic> data, {String tablePrefix}) {
    return Holiday.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Holidays createAlias(String alias) {
    return Holidays(_db, alias);
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
    return Group(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      orgId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}orgId']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      scheduleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}scheduleId']),
      meals: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}meals']),
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
  bool operator ==(Object other) =>
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
    return Group.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
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
    return Person(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      family: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}family']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      middleName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}middleName']),
      birthday: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}birthday']),
      phone: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}phone']),
      phone2: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}phone2']),
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
  bool operator ==(Object other) =>
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
    return Person.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
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
    return GroupPerson(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      groupId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}groupId']),
      personId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}personId']),
      beginDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}beginDate']),
      endDate: const DateTimeType()
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
  bool operator ==(Object other) =>
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
    return GroupPerson.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
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
    return Attendance(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      groupPersonId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}groupPersonId']),
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date']),
      hoursFact: const RealType()
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
  bool operator ==(Object other) =>
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
    return Attendance.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
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
  final ValueType valueType;
  final String textValue;
  final bool boolValue;
  final int intValue;
  final double realValue;
  final DateTime dateValue;
  final bool isUserSetting;
  Setting(
      {@required this.id,
      @required this.name,
      @required this.valueType,
      this.textValue,
      this.boolValue,
      this.intValue,
      this.realValue,
      this.dateValue,
      @required this.isUserSetting});
  factory Setting.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Setting(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      valueType: Settings.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}valueType'])),
      textValue: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}textValue']),
      boolValue: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}boolValue']),
      intValue: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}intValue']),
      realValue: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}realValue']),
      dateValue: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dateValue']),
      isUserSetting: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}isUserSetting']),
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
    if (!nullToAbsent || valueType != null) {
      final converter = Settings.$converter0;
      map['valueType'] = Variable<int>(converter.mapToSql(valueType));
    }
    if (!nullToAbsent || textValue != null) {
      map['textValue'] = Variable<String>(textValue);
    }
    if (!nullToAbsent || boolValue != null) {
      map['boolValue'] = Variable<bool>(boolValue);
    }
    if (!nullToAbsent || intValue != null) {
      map['intValue'] = Variable<int>(intValue);
    }
    if (!nullToAbsent || realValue != null) {
      map['realValue'] = Variable<double>(realValue);
    }
    if (!nullToAbsent || dateValue != null) {
      map['dateValue'] = Variable<DateTime>(dateValue);
    }
    if (!nullToAbsent || isUserSetting != null) {
      map['isUserSetting'] = Variable<bool>(isUserSetting);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      valueType: valueType == null && nullToAbsent
          ? const Value.absent()
          : Value(valueType),
      textValue: textValue == null && nullToAbsent
          ? const Value.absent()
          : Value(textValue),
      boolValue: boolValue == null && nullToAbsent
          ? const Value.absent()
          : Value(boolValue),
      intValue: intValue == null && nullToAbsent
          ? const Value.absent()
          : Value(intValue),
      realValue: realValue == null && nullToAbsent
          ? const Value.absent()
          : Value(realValue),
      dateValue: dateValue == null && nullToAbsent
          ? const Value.absent()
          : Value(dateValue),
      isUserSetting: isUserSetting == null && nullToAbsent
          ? const Value.absent()
          : Value(isUserSetting),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      valueType: serializer.fromJson<ValueType>(json['valueType']),
      textValue: serializer.fromJson<String>(json['textValue']),
      boolValue: serializer.fromJson<bool>(json['boolValue']),
      intValue: serializer.fromJson<int>(json['intValue']),
      realValue: serializer.fromJson<double>(json['realValue']),
      dateValue: serializer.fromJson<DateTime>(json['dateValue']),
      isUserSetting: serializer.fromJson<bool>(json['isUserSetting']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'valueType': serializer.toJson<ValueType>(valueType),
      'textValue': serializer.toJson<String>(textValue),
      'boolValue': serializer.toJson<bool>(boolValue),
      'intValue': serializer.toJson<int>(intValue),
      'realValue': serializer.toJson<double>(realValue),
      'dateValue': serializer.toJson<DateTime>(dateValue),
      'isUserSetting': serializer.toJson<bool>(isUserSetting),
    };
  }

  Setting copyWith(
          {int id,
          String name,
          ValueType valueType,
          String textValue,
          bool boolValue,
          int intValue,
          double realValue,
          DateTime dateValue,
          bool isUserSetting}) =>
      Setting(
        id: id ?? this.id,
        name: name ?? this.name,
        valueType: valueType ?? this.valueType,
        textValue: textValue ?? this.textValue,
        boolValue: boolValue ?? this.boolValue,
        intValue: intValue ?? this.intValue,
        realValue: realValue ?? this.realValue,
        dateValue: dateValue ?? this.dateValue,
        isUserSetting: isUserSetting ?? this.isUserSetting,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('valueType: $valueType, ')
          ..write('textValue: $textValue, ')
          ..write('boolValue: $boolValue, ')
          ..write('intValue: $intValue, ')
          ..write('realValue: $realValue, ')
          ..write('dateValue: $dateValue, ')
          ..write('isUserSetting: $isUserSetting')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              valueType.hashCode,
              $mrjc(
                  textValue.hashCode,
                  $mrjc(
                      boolValue.hashCode,
                      $mrjc(
                          intValue.hashCode,
                          $mrjc(
                              realValue.hashCode,
                              $mrjc(dateValue.hashCode,
                                  isUserSetting.hashCode)))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.name == this.name &&
          other.valueType == this.valueType &&
          other.textValue == this.textValue &&
          other.boolValue == this.boolValue &&
          other.intValue == this.intValue &&
          other.realValue == this.realValue &&
          other.dateValue == this.dateValue &&
          other.isUserSetting == this.isUserSetting);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> name;
  final Value<ValueType> valueType;
  final Value<String> textValue;
  final Value<bool> boolValue;
  final Value<int> intValue;
  final Value<double> realValue;
  final Value<DateTime> dateValue;
  final Value<bool> isUserSetting;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.valueType = const Value.absent(),
    this.textValue = const Value.absent(),
    this.boolValue = const Value.absent(),
    this.intValue = const Value.absent(),
    this.realValue = const Value.absent(),
    this.dateValue = const Value.absent(),
    this.isUserSetting = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required ValueType valueType,
    this.textValue = const Value.absent(),
    this.boolValue = const Value.absent(),
    this.intValue = const Value.absent(),
    this.realValue = const Value.absent(),
    this.dateValue = const Value.absent(),
    this.isUserSetting = const Value.absent(),
  })  : name = Value(name),
        valueType = Value(valueType);
  static Insertable<Setting> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<ValueType> valueType,
    Expression<String> textValue,
    Expression<bool> boolValue,
    Expression<int> intValue,
    Expression<double> realValue,
    Expression<DateTime> dateValue,
    Expression<bool> isUserSetting,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (valueType != null) 'valueType': valueType,
      if (textValue != null) 'textValue': textValue,
      if (boolValue != null) 'boolValue': boolValue,
      if (intValue != null) 'intValue': intValue,
      if (realValue != null) 'realValue': realValue,
      if (dateValue != null) 'dateValue': dateValue,
      if (isUserSetting != null) 'isUserSetting': isUserSetting,
    });
  }

  SettingsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<ValueType> valueType,
      Value<String> textValue,
      Value<bool> boolValue,
      Value<int> intValue,
      Value<double> realValue,
      Value<DateTime> dateValue,
      Value<bool> isUserSetting}) {
    return SettingsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      valueType: valueType ?? this.valueType,
      textValue: textValue ?? this.textValue,
      boolValue: boolValue ?? this.boolValue,
      intValue: intValue ?? this.intValue,
      realValue: realValue ?? this.realValue,
      dateValue: dateValue ?? this.dateValue,
      isUserSetting: isUserSetting ?? this.isUserSetting,
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
    if (valueType.present) {
      final converter = Settings.$converter0;
      map['valueType'] = Variable<int>(converter.mapToSql(valueType.value));
    }
    if (textValue.present) {
      map['textValue'] = Variable<String>(textValue.value);
    }
    if (boolValue.present) {
      map['boolValue'] = Variable<bool>(boolValue.value);
    }
    if (intValue.present) {
      map['intValue'] = Variable<int>(intValue.value);
    }
    if (realValue.present) {
      map['realValue'] = Variable<double>(realValue.value);
    }
    if (dateValue.present) {
      map['dateValue'] = Variable<DateTime>(dateValue.value);
    }
    if (isUserSetting.present) {
      map['isUserSetting'] = Variable<bool>(isUserSetting.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('valueType: $valueType, ')
          ..write('textValue: $textValue, ')
          ..write('boolValue: $boolValue, ')
          ..write('intValue: $intValue, ')
          ..write('realValue: $realValue, ')
          ..write('dateValue: $dateValue, ')
          ..write('isUserSetting: $isUserSetting')
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

  final VerificationMeta _valueTypeMeta = const VerificationMeta('valueType');
  GeneratedIntColumn _valueType;
  GeneratedIntColumn get valueType => _valueType ??= _constructValueType();
  GeneratedIntColumn _constructValueType() {
    return GeneratedIntColumn('valueType', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _textValueMeta = const VerificationMeta('textValue');
  GeneratedTextColumn _textValue;
  GeneratedTextColumn get textValue => _textValue ??= _constructTextValue();
  GeneratedTextColumn _constructTextValue() {
    return GeneratedTextColumn('textValue', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _boolValueMeta = const VerificationMeta('boolValue');
  GeneratedBoolColumn _boolValue;
  GeneratedBoolColumn get boolValue => _boolValue ??= _constructBoolValue();
  GeneratedBoolColumn _constructBoolValue() {
    return GeneratedBoolColumn('boolValue', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _intValueMeta = const VerificationMeta('intValue');
  GeneratedIntColumn _intValue;
  GeneratedIntColumn get intValue => _intValue ??= _constructIntValue();
  GeneratedIntColumn _constructIntValue() {
    return GeneratedIntColumn('intValue', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _realValueMeta = const VerificationMeta('realValue');
  GeneratedRealColumn _realValue;
  GeneratedRealColumn get realValue => _realValue ??= _constructRealValue();
  GeneratedRealColumn _constructRealValue() {
    return GeneratedRealColumn('realValue', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _dateValueMeta = const VerificationMeta('dateValue');
  GeneratedDateTimeColumn _dateValue;
  GeneratedDateTimeColumn get dateValue => _dateValue ??= _constructDateValue();
  GeneratedDateTimeColumn _constructDateValue() {
    return GeneratedDateTimeColumn('dateValue', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _isUserSettingMeta =
      const VerificationMeta('isUserSetting');
  GeneratedBoolColumn _isUserSetting;
  GeneratedBoolColumn get isUserSetting =>
      _isUserSetting ??= _constructIsUserSetting();
  GeneratedBoolColumn _constructIsUserSetting() {
    return GeneratedBoolColumn('isUserSetting', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT FALSE',
        defaultValue: const CustomExpression<bool>('FALSE'));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        valueType,
        textValue,
        boolValue,
        intValue,
        realValue,
        dateValue,
        isUserSetting
      ];
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
    context.handle(_valueTypeMeta, const VerificationResult.success());
    if (data.containsKey('textValue')) {
      context.handle(_textValueMeta,
          textValue.isAcceptableOrUnknown(data['textValue'], _textValueMeta));
    }
    if (data.containsKey('boolValue')) {
      context.handle(_boolValueMeta,
          boolValue.isAcceptableOrUnknown(data['boolValue'], _boolValueMeta));
    }
    if (data.containsKey('intValue')) {
      context.handle(_intValueMeta,
          intValue.isAcceptableOrUnknown(data['intValue'], _intValueMeta));
    }
    if (data.containsKey('realValue')) {
      context.handle(_realValueMeta,
          realValue.isAcceptableOrUnknown(data['realValue'], _realValueMeta));
    }
    if (data.containsKey('dateValue')) {
      context.handle(_dateValueMeta,
          dateValue.isAcceptableOrUnknown(data['dateValue'], _dateValueMeta));
    }
    if (data.containsKey('isUserSetting')) {
      context.handle(
          _isUserSettingMeta,
          isUserSetting.isAcceptableOrUnknown(
              data['isUserSetting'], _isUserSettingMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String tablePrefix}) {
    return Setting.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Settings createAlias(String alias) {
    return Settings(_db, alias);
  }

  static TypeConverter<ValueType, int> $converter0 =
      const EnumIndexConverter<ValueType>(ValueType.values);
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
  Holidays _holidays;
  Holidays get holidays => _holidays ??= Holidays(this);
  Index _holidaysIndex;
  Index get holidaysIndex => _holidaysIndex ??= Index('holidays_index',
      'CREATE UNIQUE INDEX holidays_index ON holidays (date);');
  Index _holidaysWorkdayIndex;
  Index get holidaysWorkdayIndex => _holidaysWorkdayIndex ??= Index(
      'holidays_workday_index',
      'CREATE UNIQUE INDEX holidays_workday_index ON holidays (workday);');
  Groups _groups;
  Groups get groups => _groups ??= Groups(this);
  Index _groupsIndex;
  Index get groupsIndex => _groupsIndex ??= Index('groups_index',
      'CREATE UNIQUE INDEX groups_index ON "groups" (orgId, name);');
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
  HolidaysDao _holidaysDao;
  HolidaysDao get holidaysDao => _holidaysDao ??= HolidaysDao(this as Db);
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
        variables: [Variable<int>(scheduleId)],
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
        variables: [Variable<String>(orgName)],
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
        variables: [Variable<String>(scheduleCode)],
        readsFrom: {schedules}).map(schedules.mapFromRow);
  }

  Selectable<Holiday> _holidaysWorkdays() {
    return customSelect('SELECT *\n  FROM holidays\n WHERE workday IS NOT NULL',
        variables: [], readsFrom: {holidays}).map(holidays.mapFromRow);
  }

  Selectable<Group> _firstGroup(int orgId) {
    return customSelect(
        'SELECT *\n  FROM "groups"\n WHERE orgId = :orgId\n   AND name =\n       (\n         SELECT MIN(name)\n           FROM "groups"\n          WHERE orgId = :orgId\n       )',
        variables: [Variable<int>(orgId)],
        readsFrom: {groups}).map(groups.mapFromRow);
  }

  Selectable<Group> _previousGroup(int orgId, String groupName) {
    return customSelect(
        'SELECT *\n  FROM "groups"\n WHERE orgId = :orgId\n   AND name =\n       (\n         SELECT MAX(name)\n           FROM "groups"\n          WHERE name < :groupName\n       )',
        variables: [Variable<int>(orgId), Variable<String>(groupName)],
        readsFrom: {groups}).map(groups.mapFromRow);
  }

  Selectable<OrgsViewResult> _orgsView() {
    return customSelect(
        'SELECT O.id,\n       O.name,\n       O.inn,\n       O.activeGroupId,\n       CAST((SELECT COUNT(*) FROM "groups" WHERE orgId = O.id) AS INT) AS groupCount\n  FROM orgs O\n ORDER BY\n       O.name,\n       O.inn',
        variables: [],
        readsFrom: {orgs, groups}).map((QueryRow row) {
      return OrgsViewResult(
        id: row.read<int>('id'),
        name: row.read<String>('name'),
        inn: row.read<String>('inn'),
        activeGroupId: row.read<int>('activeGroupId'),
        groupCount: row.read<int>('groupCount'),
      );
    });
  }

  Selectable<SchedulesViewResult> _schedulesView() {
    return customSelect(
        'SELECT S.id,\n       S.code,\n       CAST((SELECT COUNT(*) FROM "groups" WHERE scheduleId = S.id) AS INT) AS groupCount\n  FROM schedules S\n ORDER BY\n       S.code',
        variables: [],
        readsFrom: {schedules, groups}).map((QueryRow row) {
      return SchedulesViewResult(
        id: row.read<int>('id'),
        code: row.read<String>('code'),
        groupCount: row.read<int>('groupCount'),
      );
    });
  }

  Selectable<GroupsViewResult> _groupsView(int orgId) {
    return customSelect(
        'SELECT G.id,\n       G.orgId,\n       G.name,\n       G.scheduleId,\n       S.code AS scheduleCode,\n       G.meals,\n       CAST((SELECT COUNT(*) FROM group_persons WHERE groupId = G.id) AS INT) AS personCount\n  FROM "groups" G\n INNER JOIN schedules S ON S.id = G.scheduleId\n WHERE G.orgId = :orgId\n ORDER BY\n       G.name,\n       S.code',
        variables: [Variable<int>(orgId)],
        readsFrom: {groups, schedules, groupPersons}).map((QueryRow row) {
      return GroupsViewResult(
        id: row.read<int>('id'),
        orgId: row.read<int>('orgId'),
        name: row.read<String>('name'),
        scheduleId: row.read<int>('scheduleId'),
        scheduleCode: row.read<String>('scheduleCode'),
        meals: row.read<int>('meals'),
        personCount: row.read<int>('personCount'),
      );
    });
  }

  Selectable<OrgMealsResult> _orgMeals(int orgId) {
    return customSelect(
        'SELECT G.orgId,\n       G.meals\n  FROM "groups" G\n WHERE G.orgId = :orgId\n GROUP BY\n       G.orgId,\n       G.meals\n ORDER BY\n       G.orgId,\n       G.meals',
        variables: [Variable<int>(orgId)],
        readsFrom: {groups}).map((QueryRow row) {
      return OrgMealsResult(
        orgId: row.read<int>('orgId'),
        meals: row.read<int>('meals'),
      );
    });
  }

  Selectable<PersonsViewResult> _personsView() {
    return customSelect(
        'SELECT P.id,\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday,\n       P.phone,\n       P.phone2,\n       CAST((SELECT COUNT(*) FROM group_persons WHERE personId = P.id) AS INT) AS groupCount\n  FROM persons P\n ORDER BY\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday',
        variables: [],
        readsFrom: {persons, groupPersons}).map((QueryRow row) {
      return PersonsViewResult(
        id: row.read<int>('id'),
        family: row.read<String>('family'),
        name: row.read<String>('name'),
        middleName: row.read<String>('middleName'),
        birthday: row.read<DateTime>('birthday'),
        phone: row.read<String>('phone'),
        phone2: row.read<String>('phone2'),
        groupCount: row.read<int>('groupCount'),
      );
    });
  }

  Selectable<Person> _findPerson(
      String family, String name, String middleName, DateTime birthday) {
    return customSelect(
        'SELECT P.id,\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday,\n       P.phone,\n       P.phone2\n  FROM persons P\n WHERE P.family = :family\n   AND P.name = :name\n   AND (:middleName IS NULL OR :middleName = \'\' OR P.middleName = :middleName)\n   AND (:birthday IS NULL OR P.birthday = :birthday)',
        variables: [
          Variable<String>(family),
          Variable<String>(name),
          Variable<String>(middleName),
          Variable<DateTime>(birthday)
        ],
        readsFrom: {
          persons
        }).map(persons.mapFromRow);
  }

  Selectable<PersonsInGroupResult> _personsInGroup(int groupId) {
    return customSelect(
        'SELECT L.id,\n       L.groupId,\n       L.personId,\n       L.beginDate,\n       L.endDate,\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday,\n       P.phone,\n       P.phone2,\n       CAST((SELECT COUNT(*) FROM attendances T WHERE T.groupPersonId = L.id) AS INT) AS attendanceCount\n  FROM group_persons L\n INNER JOIN persons P ON P.id = L.personId\n WHERE L.groupId = :groupId\n ORDER BY\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday',
        variables: [Variable<int>(groupId)],
        readsFrom: {groupPersons, persons, attendances}).map((QueryRow row) {
      return PersonsInGroupResult(
        id: row.read<int>('id'),
        groupId: row.read<int>('groupId'),
        personId: row.read<int>('personId'),
        beginDate: row.read<DateTime>('beginDate'),
        endDate: row.read<DateTime>('endDate'),
        family: row.read<String>('family'),
        name: row.read<String>('name'),
        middleName: row.read<String>('middleName'),
        birthday: row.read<DateTime>('birthday'),
        phone: row.read<String>('phone'),
        phone2: row.read<String>('phone2'),
        attendanceCount: row.read<int>('attendanceCount'),
      );
    });
  }

  Selectable<PersonsInGroupPeriodResult> _personsInGroupPeriod(
      int groupId, DateTime periodBegin, DateTime periodEnd) {
    return customSelect(
        'SELECT L.id,\n       L.groupId,\n       L.personId,\n       L.beginDate,\n       L.endDate,\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday,\n       P.phone,\n       P.phone2,\n       CAST((SELECT COUNT(*) FROM attendances T WHERE T.groupPersonId = L.id) AS INT) AS attendanceCount\n  FROM group_persons L\n INNER JOIN persons P ON P.id = L.personId\n WHERE L.groupId = :groupId\n   AND (L.endDate IS NULL OR L.endDate >= :periodBegin)\n   AND (L.beginDate IS NULL OR L.beginDate <= :periodEnd)\n ORDER BY\n       P.family,\n       P.name,\n       P.middleName,\n       P.birthday',
        variables: [
          Variable<int>(groupId),
          Variable<DateTime>(periodBegin),
          Variable<DateTime>(periodEnd)
        ],
        readsFrom: {
          groupPersons,
          persons,
          attendances
        }).map((QueryRow row) {
      return PersonsInGroupPeriodResult(
        id: row.read<int>('id'),
        groupId: row.read<int>('groupId'),
        personId: row.read<int>('personId'),
        beginDate: row.read<DateTime>('beginDate'),
        endDate: row.read<DateTime>('endDate'),
        family: row.read<String>('family'),
        name: row.read<String>('name'),
        middleName: row.read<String>('middleName'),
        birthday: row.read<DateTime>('birthday'),
        phone: row.read<String>('phone'),
        phone2: row.read<String>('phone2'),
        attendanceCount: row.read<int>('attendanceCount'),
      );
    });
  }

  Selectable<Attendance> _groupPersonAttendances(
      int groupId, DateTime periodBegin, DateTime periodEnd) {
    return customSelect(
        'SELECT T.*\n  FROM group_persons L\n INNER JOIN attendances T ON T.groupPersonId = L.id\n WHERE L.groupId = :groupId\n   AND (L.endDate IS NULL OR L.endDate >= :periodBegin)\n   AND (L.beginDate IS NULL OR L.beginDate <= :periodEnd)\n   AND T.date >= :periodBegin\n   AND T.date <= :periodEnd',
        variables: [
          Variable<int>(groupId),
          Variable<DateTime>(periodBegin),
          Variable<DateTime>(periodEnd)
        ],
        readsFrom: {
          groupPersons,
          attendances
        }).map(attendances.mapFromRow);
  }

  Selectable<OrgAttendancesResult> _orgAttendances(
      int orgId, DateTime periodBegin, DateTime periodEnd) {
    return customSelect(
        'SELECT L.groupId,\n       G.meals,\n       T.*\n  FROM "groups" G\n INNER JOIN group_persons L ON L.groupId = G.id\n INNER JOIN attendances T ON T.groupPersonId = L.id\n WHERE G.orgId = :orgId\n   AND (L.endDate IS NULL OR L.endDate >= :periodBegin)\n   AND (L.beginDate IS NULL OR L.beginDate <= :periodEnd)\n   AND T.date >= :periodBegin\n   AND T.date <= :periodEnd',
        variables: [
          Variable<int>(orgId),
          Variable<DateTime>(periodBegin),
          Variable<DateTime>(periodEnd)
        ],
        readsFrom: {
          groupPersons,
          groups,
          attendances
        }).map((QueryRow row) {
      return OrgAttendancesResult(
        groupId: row.read<int>('groupId'),
        meals: row.read<int>('meals'),
        id: row.read<int>('id'),
        groupPersonId: row.read<int>('groupPersonId'),
        date: row.read<DateTime>('date'),
        hoursFact: row.read<double>('hoursFact'),
      );
    });
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
      variables: [Variable<int>(id)],
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
      variables: [Variable<int>(id)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
  }

  Selectable<ActiveGroupResult> _activeGroup(int orgId) {
    return customSelect(
        'SELECT G.id,\n       G.orgId,\n       G.name,\n       G.scheduleId,\n       S.code AS scheduleCode,\n       G.meals,\n       CAST((SELECT COUNT(*) FROM group_persons WHERE groupId = G.id) AS INT) AS personCount\n  FROM orgs O\n INNER JOIN "groups" G ON G.id = O.activeGroupId\n INNER JOIN schedules S ON S.id = G.scheduleId\n WHERE O.id = :orgId',
        variables: [Variable<int>(orgId)],
        readsFrom: {groups, schedules, groupPersons, orgs}).map((QueryRow row) {
      return ActiveGroupResult(
        id: row.read<int>('id'),
        orgId: row.read<int>('orgId'),
        name: row.read<String>('name'),
        scheduleId: row.read<int>('scheduleId'),
        scheduleCode: row.read<String>('scheduleCode'),
        meals: row.read<int>('meals'),
        personCount: row.read<int>('personCount'),
      );
    });
  }

  Future<int> _setActiveGroup(int activeGroupId, int orgId) {
    return customUpdate(
      'UPDATE orgs SET activeGroupId = :activeGroupId WHERE id = :orgId',
      variables: [Variable<int>(activeGroupId), Variable<int>(orgId)],
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
        }).map((QueryRow row) => row.read<DateTime>('dateValue'));
  }

  Future<int> _setActivePeriod(DateTime activePeriod) {
    return customUpdate(
      'UPDATE settings SET dateValue = :activePeriod WHERE name = \'activePeriod\'',
      variables: [Variable<DateTime>(activePeriod)],
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
        holidays,
        holidaysIndex,
        holidaysWorkdayIndex,
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
    @required this.id,
    @required this.name,
    this.inn,
    this.activeGroupId,
    @required this.groupCount,
  });
}

class SchedulesViewResult {
  final int id;
  final String code;
  final int groupCount;
  SchedulesViewResult({
    @required this.id,
    @required this.code,
    @required this.groupCount,
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
    @required this.id,
    @required this.orgId,
    @required this.name,
    @required this.scheduleId,
    @required this.scheduleCode,
    this.meals,
    @required this.personCount,
  });
}

class OrgMealsResult {
  final int orgId;
  final int meals;
  OrgMealsResult({
    @required this.orgId,
    this.meals,
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
    @required this.id,
    @required this.family,
    @required this.name,
    this.middleName,
    this.birthday,
    this.phone,
    this.phone2,
    @required this.groupCount,
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
    @required this.id,
    @required this.groupId,
    @required this.personId,
    this.beginDate,
    this.endDate,
    @required this.family,
    @required this.name,
    this.middleName,
    this.birthday,
    this.phone,
    this.phone2,
    @required this.attendanceCount,
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
    @required this.id,
    @required this.groupId,
    @required this.personId,
    this.beginDate,
    this.endDate,
    @required this.family,
    @required this.name,
    this.middleName,
    this.birthday,
    this.phone,
    this.phone2,
    @required this.attendanceCount,
  });
}

class OrgAttendancesResult {
  final int groupId;
  final int meals;
  final int id;
  final int groupPersonId;
  final DateTime date;
  final double hoursFact;
  OrgAttendancesResult({
    @required this.groupId,
    this.meals,
    @required this.id,
    @required this.groupPersonId,
    @required this.date,
    @required this.hoursFact,
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
    @required this.id,
    @required this.orgId,
    @required this.name,
    @required this.scheduleId,
    @required this.scheduleCode,
    this.meals,
    @required this.personCount,
  });
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$OrgsDaoMixin on DatabaseAccessor<Db> {}
mixin _$SchedulesDaoMixin on DatabaseAccessor<Db> {}
mixin _$ScheduleDaysDaoMixin on DatabaseAccessor<Db> {}
mixin _$HolidaysDaoMixin on DatabaseAccessor<Db> {}
mixin _$GroupsDaoMixin on DatabaseAccessor<Db> {}
mixin _$PersonsDaoMixin on DatabaseAccessor<Db> {}
mixin _$GroupPersonsDaoMixin on DatabaseAccessor<Db> {}
mixin _$AttendancesDaoMixin on DatabaseAccessor<Db> {}
mixin _$SettingsDaoMixin on DatabaseAccessor<Db> {}
