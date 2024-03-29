// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class Orgs extends Table with TableInfo<Orgs, Org> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Orgs(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _innMeta = const VerificationMeta('inn');
  late final GeneratedColumn<String> inn = GeneratedColumn<String>(
      'inn', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _activeGroupIdMeta =
      const VerificationMeta('activeGroupId');
  late final GeneratedColumn<int> activeGroupId = GeneratedColumn<int>(
      'activeGroupId', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _lastPayMeta =
      const VerificationMeta('lastPay');
  late final GeneratedColumn<DateTime> lastPay = GeneratedColumn<DateTime>(
      'lastPay', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _totalSumMeta =
      const VerificationMeta('totalSum');
  late final GeneratedColumn<double> totalSum = GeneratedColumn<double>(
      'totalSum', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, inn, activeGroupId, lastPay, totalSum];
  @override
  String get aliasedName => _alias ?? 'orgs';
  @override
  String get actualTableName => 'orgs';
  @override
  VerificationContext validateIntegrity(Insertable<Org> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('inn')) {
      context.handle(
          _innMeta, inn.isAcceptableOrUnknown(data['inn']!, _innMeta));
    }
    if (data.containsKey('activeGroupId')) {
      context.handle(
          _activeGroupIdMeta,
          activeGroupId.isAcceptableOrUnknown(
              data['activeGroupId']!, _activeGroupIdMeta));
    }
    if (data.containsKey('lastPay')) {
      context.handle(_lastPayMeta,
          lastPay.isAcceptableOrUnknown(data['lastPay']!, _lastPayMeta));
    }
    if (data.containsKey('totalSum')) {
      context.handle(_totalSumMeta,
          totalSum.isAcceptableOrUnknown(data['totalSum']!, _totalSumMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Org map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Org(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      inn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inn']),
      activeGroupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activeGroupId']),
      lastPay: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}lastPay']),
      totalSum: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}totalSum']),
    );
  }

  @override
  Orgs createAlias(String alias) {
    return Orgs(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Org extends DataClass implements Insertable<Org> {
  final int id;
  final String name;
  final String? inn;
  final int? activeGroupId;
  final DateTime? lastPay;
  final double? totalSum;
  const Org(
      {required this.id,
      required this.name,
      this.inn,
      this.activeGroupId,
      this.lastPay,
      this.totalSum});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || inn != null) {
      map['inn'] = Variable<String>(inn);
    }
    if (!nullToAbsent || activeGroupId != null) {
      map['activeGroupId'] = Variable<int>(activeGroupId);
    }
    if (!nullToAbsent || lastPay != null) {
      map['lastPay'] = Variable<DateTime>(lastPay);
    }
    if (!nullToAbsent || totalSum != null) {
      map['totalSum'] = Variable<double>(totalSum);
    }
    return map;
  }

  OrgsCompanion toCompanion(bool nullToAbsent) {
    return OrgsCompanion(
      id: Value(id),
      name: Value(name),
      inn: inn == null && nullToAbsent ? const Value.absent() : Value(inn),
      activeGroupId: activeGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeGroupId),
      lastPay: lastPay == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPay),
      totalSum: totalSum == null && nullToAbsent
          ? const Value.absent()
          : Value(totalSum),
    );
  }

  factory Org.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Org(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      inn: serializer.fromJson<String?>(json['inn']),
      activeGroupId: serializer.fromJson<int?>(json['activeGroupId']),
      lastPay: serializer.fromJson<DateTime?>(json['lastPay']),
      totalSum: serializer.fromJson<double?>(json['totalSum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'inn': serializer.toJson<String?>(inn),
      'activeGroupId': serializer.toJson<int?>(activeGroupId),
      'lastPay': serializer.toJson<DateTime?>(lastPay),
      'totalSum': serializer.toJson<double?>(totalSum),
    };
  }

  Org copyWith(
          {int? id,
          String? name,
          Value<String?> inn = const Value.absent(),
          Value<int?> activeGroupId = const Value.absent(),
          Value<DateTime?> lastPay = const Value.absent(),
          Value<double?> totalSum = const Value.absent()}) =>
      Org(
        id: id ?? this.id,
        name: name ?? this.name,
        inn: inn.present ? inn.value : this.inn,
        activeGroupId:
            activeGroupId.present ? activeGroupId.value : this.activeGroupId,
        lastPay: lastPay.present ? lastPay.value : this.lastPay,
        totalSum: totalSum.present ? totalSum.value : this.totalSum,
      );
  @override
  String toString() {
    return (StringBuffer('Org(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('inn: $inn, ')
          ..write('activeGroupId: $activeGroupId, ')
          ..write('lastPay: $lastPay, ')
          ..write('totalSum: $totalSum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, inn, activeGroupId, lastPay, totalSum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Org &&
          other.id == this.id &&
          other.name == this.name &&
          other.inn == this.inn &&
          other.activeGroupId == this.activeGroupId &&
          other.lastPay == this.lastPay &&
          other.totalSum == this.totalSum);
}

class OrgsCompanion extends UpdateCompanion<Org> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> inn;
  final Value<int?> activeGroupId;
  final Value<DateTime?> lastPay;
  final Value<double?> totalSum;
  const OrgsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.inn = const Value.absent(),
    this.activeGroupId = const Value.absent(),
    this.lastPay = const Value.absent(),
    this.totalSum = const Value.absent(),
  });
  OrgsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.inn = const Value.absent(),
    this.activeGroupId = const Value.absent(),
    this.lastPay = const Value.absent(),
    this.totalSum = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Org> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? inn,
    Expression<int>? activeGroupId,
    Expression<DateTime>? lastPay,
    Expression<double>? totalSum,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (inn != null) 'inn': inn,
      if (activeGroupId != null) 'activeGroupId': activeGroupId,
      if (lastPay != null) 'lastPay': lastPay,
      if (totalSum != null) 'totalSum': totalSum,
    });
  }

  OrgsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? inn,
      Value<int?>? activeGroupId,
      Value<DateTime?>? lastPay,
      Value<double?>? totalSum}) {
    return OrgsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      inn: inn ?? this.inn,
      activeGroupId: activeGroupId ?? this.activeGroupId,
      lastPay: lastPay ?? this.lastPay,
      totalSum: totalSum ?? this.totalSum,
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
    if (lastPay.present) {
      map['lastPay'] = Variable<DateTime>(lastPay.value);
    }
    if (totalSum.present) {
      map['totalSum'] = Variable<double>(totalSum.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrgsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('inn: $inn, ')
          ..write('activeGroupId: $activeGroupId, ')
          ..write('lastPay: $lastPay, ')
          ..write('totalSum: $totalSum')
          ..write(')'))
        .toString();
  }
}

class Schedules extends Table with TableInfo<Schedules, Schedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Schedules(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, code];
  @override
  String get aliasedName => _alias ?? 'schedules';
  @override
  String get actualTableName => 'schedules';
  @override
  VerificationContext validateIntegrity(Insertable<Schedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Schedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Schedule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
    );
  }

  @override
  Schedules createAlias(String alias) {
    return Schedules(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Schedule extends DataClass implements Insertable<Schedule> {
  final int id;
  final String code;
  const Schedule({required this.id, required this.code});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    return map;
  }

  SchedulesCompanion toCompanion(bool nullToAbsent) {
    return SchedulesCompanion(
      id: Value(id),
      code: Value(code),
    );
  }

  factory Schedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Schedule(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
    };
  }

  Schedule copyWith({int? id, String? code}) => Schedule(
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
  int get hashCode => Object.hash(id, code);
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
    required String code,
  }) : code = Value(code);
  static Insertable<Schedule> custom({
    Expression<int>? id,
    Expression<String>? code,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
    });
  }

  SchedulesCompanion copyWith({Value<int>? id, Value<String>? code}) {
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

class ScheduleDays extends Table with TableInfo<ScheduleDays, ScheduleDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ScheduleDays(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  late final GeneratedColumn<int> scheduleId = GeneratedColumn<int>(
      'scheduleId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES schedules(id)ON DELETE CASCADE');
  static const VerificationMeta _dayNumberMeta =
      const VerificationMeta('dayNumber');
  late final GeneratedColumn<int> dayNumber = GeneratedColumn<int>(
      'dayNumber', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _hoursNormMeta =
      const VerificationMeta('hoursNorm');
  late final GeneratedColumn<double> hoursNorm = GeneratedColumn<double>(
      'hoursNorm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, scheduleId, dayNumber, hoursNorm];
  @override
  String get aliasedName => _alias ?? 'schedule_days';
  @override
  String get actualTableName => 'schedule_days';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduleDay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scheduleId')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['scheduleId']!, _scheduleIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('dayNumber')) {
      context.handle(_dayNumberMeta,
          dayNumber.isAcceptableOrUnknown(data['dayNumber']!, _dayNumberMeta));
    } else if (isInserting) {
      context.missing(_dayNumberMeta);
    }
    if (data.containsKey('hoursNorm')) {
      context.handle(_hoursNormMeta,
          hoursNorm.isAcceptableOrUnknown(data['hoursNorm']!, _hoursNormMeta));
    } else if (isInserting) {
      context.missing(_hoursNormMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleDay(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scheduleId'])!,
      dayNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dayNumber'])!,
      hoursNorm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}hoursNorm'])!,
    );
  }

  @override
  ScheduleDays createAlias(String alias) {
    return ScheduleDays(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ScheduleDay extends DataClass implements Insertable<ScheduleDay> {
  final int id;
  final int scheduleId;
  final int dayNumber;
  final double hoursNorm;
  const ScheduleDay(
      {required this.id,
      required this.scheduleId,
      required this.dayNumber,
      required this.hoursNorm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scheduleId'] = Variable<int>(scheduleId);
    map['dayNumber'] = Variable<int>(dayNumber);
    map['hoursNorm'] = Variable<double>(hoursNorm);
    return map;
  }

  ScheduleDaysCompanion toCompanion(bool nullToAbsent) {
    return ScheduleDaysCompanion(
      id: Value(id),
      scheduleId: Value(scheduleId),
      dayNumber: Value(dayNumber),
      hoursNorm: Value(hoursNorm),
    );
  }

  factory ScheduleDay.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleDay(
      id: serializer.fromJson<int>(json['id']),
      scheduleId: serializer.fromJson<int>(json['scheduleId']),
      dayNumber: serializer.fromJson<int>(json['dayNumber']),
      hoursNorm: serializer.fromJson<double>(json['hoursNorm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scheduleId': serializer.toJson<int>(scheduleId),
      'dayNumber': serializer.toJson<int>(dayNumber),
      'hoursNorm': serializer.toJson<double>(hoursNorm),
    };
  }

  ScheduleDay copyWith(
          {int? id, int? scheduleId, int? dayNumber, double? hoursNorm}) =>
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
  int get hashCode => Object.hash(id, scheduleId, dayNumber, hoursNorm);
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
    required int scheduleId,
    required int dayNumber,
    required double hoursNorm,
  })  : scheduleId = Value(scheduleId),
        dayNumber = Value(dayNumber),
        hoursNorm = Value(hoursNorm);
  static Insertable<ScheduleDay> custom({
    Expression<int>? id,
    Expression<int>? scheduleId,
    Expression<int>? dayNumber,
    Expression<double>? hoursNorm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleId != null) 'scheduleId': scheduleId,
      if (dayNumber != null) 'dayNumber': dayNumber,
      if (hoursNorm != null) 'hoursNorm': hoursNorm,
    });
  }

  ScheduleDaysCompanion copyWith(
      {Value<int>? id,
      Value<int>? scheduleId,
      Value<int>? dayNumber,
      Value<double>? hoursNorm}) {
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

class Groups extends Table with TableInfo<Groups, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Groups(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  late final GeneratedColumn<int> orgId = GeneratedColumn<int>(
      'orgId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES orgs(id)');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  late final GeneratedColumn<int> scheduleId = GeneratedColumn<int>(
      'scheduleId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES schedules(id)');
  static const VerificationMeta _mealsMeta = const VerificationMeta('meals');
  late final GeneratedColumn<int> meals = GeneratedColumn<int>(
      'meals', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [id, orgId, name, scheduleId, meals];
  @override
  String get aliasedName => _alias ?? 'groups';
  @override
  String get actualTableName => 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orgId')) {
      context.handle(
          _orgIdMeta, orgId.isAcceptableOrUnknown(data['orgId']!, _orgIdMeta));
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scheduleId')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['scheduleId']!, _scheduleIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('meals')) {
      context.handle(
          _mealsMeta, meals.isAcceptableOrUnknown(data['meals']!, _mealsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orgId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orgId'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scheduleId'])!,
      meals: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meals']),
    );
  }

  @override
  Groups createAlias(String alias) {
    return Groups(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final int orgId;
  final String name;
  final int scheduleId;
  final int? meals;
  const Group(
      {required this.id,
      required this.orgId,
      required this.name,
      required this.scheduleId,
      this.meals});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orgId'] = Variable<int>(orgId);
    map['name'] = Variable<String>(name);
    map['scheduleId'] = Variable<int>(scheduleId);
    if (!nullToAbsent || meals != null) {
      map['meals'] = Variable<int>(meals);
    }
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      orgId: Value(orgId),
      name: Value(name),
      scheduleId: Value(scheduleId),
      meals:
          meals == null && nullToAbsent ? const Value.absent() : Value(meals),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      orgId: serializer.fromJson<int>(json['orgId']),
      name: serializer.fromJson<String>(json['name']),
      scheduleId: serializer.fromJson<int>(json['scheduleId']),
      meals: serializer.fromJson<int?>(json['meals']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orgId': serializer.toJson<int>(orgId),
      'name': serializer.toJson<String>(name),
      'scheduleId': serializer.toJson<int>(scheduleId),
      'meals': serializer.toJson<int?>(meals),
    };
  }

  Group copyWith(
          {int? id,
          int? orgId,
          String? name,
          int? scheduleId,
          Value<int?> meals = const Value.absent()}) =>
      Group(
        id: id ?? this.id,
        orgId: orgId ?? this.orgId,
        name: name ?? this.name,
        scheduleId: scheduleId ?? this.scheduleId,
        meals: meals.present ? meals.value : this.meals,
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
  int get hashCode => Object.hash(id, orgId, name, scheduleId, meals);
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
  final Value<int?> meals;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.name = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.meals = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    required int orgId,
    required String name,
    required int scheduleId,
    this.meals = const Value.absent(),
  })  : orgId = Value(orgId),
        name = Value(name),
        scheduleId = Value(scheduleId);
  static Insertable<Group> custom({
    Expression<int>? id,
    Expression<int>? orgId,
    Expression<String>? name,
    Expression<int>? scheduleId,
    Expression<int>? meals,
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
      {Value<int>? id,
      Value<int>? orgId,
      Value<String>? name,
      Value<int>? scheduleId,
      Value<int?>? meals}) {
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

class Persons extends Table with TableInfo<Persons, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Persons(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _familyMeta = const VerificationMeta('family');
  late final GeneratedColumn<String> family = GeneratedColumn<String>(
      'family', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _middleNameMeta =
      const VerificationMeta('middleName');
  late final GeneratedColumn<String> middleName = GeneratedColumn<String>(
      'middleName', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _birthdayMeta =
      const VerificationMeta('birthday');
  late final GeneratedColumn<DateTime> birthday = GeneratedColumn<DateTime>(
      'birthday', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _phone2Meta = const VerificationMeta('phone2');
  late final GeneratedColumn<String> phone2 = GeneratedColumn<String>(
      'phone2', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns =>
      [id, family, name, middleName, birthday, phone, phone2];
  @override
  String get aliasedName => _alias ?? 'persons';
  @override
  String get actualTableName => 'persons';
  @override
  VerificationContext validateIntegrity(Insertable<Person> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('family')) {
      context.handle(_familyMeta,
          family.isAcceptableOrUnknown(data['family']!, _familyMeta));
    } else if (isInserting) {
      context.missing(_familyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('middleName')) {
      context.handle(
          _middleNameMeta,
          middleName.isAcceptableOrUnknown(
              data['middleName']!, _middleNameMeta));
    }
    if (data.containsKey('birthday')) {
      context.handle(_birthdayMeta,
          birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('phone2')) {
      context.handle(_phone2Meta,
          phone2.isAcceptableOrUnknown(data['phone2']!, _phone2Meta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Person(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      family: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      middleName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}middleName']),
      birthday: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birthday']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      phone2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone2']),
    );
  }

  @override
  Persons createAlias(String alias) {
    return Persons(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Person extends DataClass implements Insertable<Person> {
  final int id;
  final String family;
  final String name;
  final String? middleName;
  final DateTime? birthday;
  final String? phone;
  final String? phone2;
  const Person(
      {required this.id,
      required this.family,
      required this.name,
      this.middleName,
      this.birthday,
      this.phone,
      this.phone2});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['family'] = Variable<String>(family);
    map['name'] = Variable<String>(name);
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
      id: Value(id),
      family: Value(family),
      name: Value(name),
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
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<int>(json['id']),
      family: serializer.fromJson<String>(json['family']),
      name: serializer.fromJson<String>(json['name']),
      middleName: serializer.fromJson<String?>(json['middleName']),
      birthday: serializer.fromJson<DateTime?>(json['birthday']),
      phone: serializer.fromJson<String?>(json['phone']),
      phone2: serializer.fromJson<String?>(json['phone2']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'family': serializer.toJson<String>(family),
      'name': serializer.toJson<String>(name),
      'middleName': serializer.toJson<String?>(middleName),
      'birthday': serializer.toJson<DateTime?>(birthday),
      'phone': serializer.toJson<String?>(phone),
      'phone2': serializer.toJson<String?>(phone2),
    };
  }

  Person copyWith(
          {int? id,
          String? family,
          String? name,
          Value<String?> middleName = const Value.absent(),
          Value<DateTime?> birthday = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> phone2 = const Value.absent()}) =>
      Person(
        id: id ?? this.id,
        family: family ?? this.family,
        name: name ?? this.name,
        middleName: middleName.present ? middleName.value : this.middleName,
        birthday: birthday.present ? birthday.value : this.birthday,
        phone: phone.present ? phone.value : this.phone,
        phone2: phone2.present ? phone2.value : this.phone2,
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
  int get hashCode =>
      Object.hash(id, family, name, middleName, birthday, phone, phone2);
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
  final Value<String?> middleName;
  final Value<DateTime?> birthday;
  final Value<String?> phone;
  final Value<String?> phone2;
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
    required String family,
    required String name,
    this.middleName = const Value.absent(),
    this.birthday = const Value.absent(),
    this.phone = const Value.absent(),
    this.phone2 = const Value.absent(),
  })  : family = Value(family),
        name = Value(name);
  static Insertable<Person> custom({
    Expression<int>? id,
    Expression<String>? family,
    Expression<String>? name,
    Expression<String>? middleName,
    Expression<DateTime>? birthday,
    Expression<String>? phone,
    Expression<String>? phone2,
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
      {Value<int>? id,
      Value<String>? family,
      Value<String>? name,
      Value<String?>? middleName,
      Value<DateTime?>? birthday,
      Value<String?>? phone,
      Value<String?>? phone2}) {
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

class GroupPersons extends Table with TableInfo<GroupPersons, GroupPerson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  GroupPersons(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'groupId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES "groups"(id)');
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'personId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES persons(id)');
  static const VerificationMeta _beginDateMeta =
      const VerificationMeta('beginDate');
  late final GeneratedColumn<DateTime> beginDate = GeneratedColumn<DateTime>(
      'beginDate', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'endDate', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns =>
      [id, groupId, personId, beginDate, endDate];
  @override
  String get aliasedName => _alias ?? 'group_persons';
  @override
  String get actualTableName => 'group_persons';
  @override
  VerificationContext validateIntegrity(Insertable<GroupPerson> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('groupId')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['groupId']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('personId')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['personId']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('beginDate')) {
      context.handle(_beginDateMeta,
          beginDate.isAcceptableOrUnknown(data['beginDate']!, _beginDateMeta));
    }
    if (data.containsKey('endDate')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['endDate']!, _endDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupPerson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupPerson(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}groupId'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}personId'])!,
      beginDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}beginDate']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}endDate']),
    );
  }

  @override
  GroupPersons createAlias(String alias) {
    return GroupPersons(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class GroupPerson extends DataClass implements Insertable<GroupPerson> {
  final int id;
  final int groupId;
  final int personId;
  final DateTime? beginDate;
  final DateTime? endDate;
  const GroupPerson(
      {required this.id,
      required this.groupId,
      required this.personId,
      this.beginDate,
      this.endDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['groupId'] = Variable<int>(groupId);
    map['personId'] = Variable<int>(personId);
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
      id: Value(id),
      groupId: Value(groupId),
      personId: Value(personId),
      beginDate: beginDate == null && nullToAbsent
          ? const Value.absent()
          : Value(beginDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory GroupPerson.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupPerson(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      personId: serializer.fromJson<int>(json['personId']),
      beginDate: serializer.fromJson<DateTime?>(json['beginDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'personId': serializer.toJson<int>(personId),
      'beginDate': serializer.toJson<DateTime?>(beginDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
    };
  }

  GroupPerson copyWith(
          {int? id,
          int? groupId,
          int? personId,
          Value<DateTime?> beginDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent()}) =>
      GroupPerson(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        personId: personId ?? this.personId,
        beginDate: beginDate.present ? beginDate.value : this.beginDate,
        endDate: endDate.present ? endDate.value : this.endDate,
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
  int get hashCode => Object.hash(id, groupId, personId, beginDate, endDate);
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
  final Value<DateTime?> beginDate;
  final Value<DateTime?> endDate;
  const GroupPersonsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.personId = const Value.absent(),
    this.beginDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  GroupPersonsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int personId,
    this.beginDate = const Value.absent(),
    this.endDate = const Value.absent(),
  })  : groupId = Value(groupId),
        personId = Value(personId);
  static Insertable<GroupPerson> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? personId,
    Expression<DateTime>? beginDate,
    Expression<DateTime>? endDate,
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
      {Value<int>? id,
      Value<int>? groupId,
      Value<int>? personId,
      Value<DateTime?>? beginDate,
      Value<DateTime?>? endDate}) {
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

class Attendances extends Table with TableInfo<Attendances, Attendance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Attendances(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _groupPersonIdMeta =
      const VerificationMeta('groupPersonId');
  late final GeneratedColumn<int> groupPersonId = GeneratedColumn<int>(
      'groupPersonId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES group_persons(id)ON DELETE CASCADE');
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _hoursFactMeta =
      const VerificationMeta('hoursFact');
  late final GeneratedColumn<double> hoursFact = GeneratedColumn<double>(
      'hoursFact', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _isNoShowMeta =
      const VerificationMeta('isNoShow');
  late final GeneratedColumn<bool> isNoShow = GeneratedColumn<bool>(
      'isNoShow', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT FALSE',
      defaultValue: const CustomExpression('FALSE'));
  static const VerificationMeta _dayTypeMeta =
      const VerificationMeta('dayType');
  late final GeneratedColumn<String> dayType = GeneratedColumn<String>(
      'dayType', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns =>
      [id, groupPersonId, date, hoursFact, isNoShow, dayType];
  @override
  String get aliasedName => _alias ?? 'attendances';
  @override
  String get actualTableName => 'attendances';
  @override
  VerificationContext validateIntegrity(Insertable<Attendance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('groupPersonId')) {
      context.handle(
          _groupPersonIdMeta,
          groupPersonId.isAcceptableOrUnknown(
              data['groupPersonId']!, _groupPersonIdMeta));
    } else if (isInserting) {
      context.missing(_groupPersonIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('hoursFact')) {
      context.handle(_hoursFactMeta,
          hoursFact.isAcceptableOrUnknown(data['hoursFact']!, _hoursFactMeta));
    } else if (isInserting) {
      context.missing(_hoursFactMeta);
    }
    if (data.containsKey('isNoShow')) {
      context.handle(_isNoShowMeta,
          isNoShow.isAcceptableOrUnknown(data['isNoShow']!, _isNoShowMeta));
    }
    if (data.containsKey('dayType')) {
      context.handle(_dayTypeMeta,
          dayType.isAcceptableOrUnknown(data['dayType']!, _dayTypeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attendance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attendance(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupPersonId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}groupPersonId'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      hoursFact: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}hoursFact'])!,
      isNoShow: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}isNoShow'])!,
      dayType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dayType']),
    );
  }

  @override
  Attendances createAlias(String alias) {
    return Attendances(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Attendance extends DataClass implements Insertable<Attendance> {
  final int id;
  final int groupPersonId;
  final DateTime date;
  final double hoursFact;
  final bool isNoShow;
  final String? dayType;
  const Attendance(
      {required this.id,
      required this.groupPersonId,
      required this.date,
      required this.hoursFact,
      required this.isNoShow,
      this.dayType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['groupPersonId'] = Variable<int>(groupPersonId);
    map['date'] = Variable<DateTime>(date);
    map['hoursFact'] = Variable<double>(hoursFact);
    map['isNoShow'] = Variable<bool>(isNoShow);
    if (!nullToAbsent || dayType != null) {
      map['dayType'] = Variable<String>(dayType);
    }
    return map;
  }

  AttendancesCompanion toCompanion(bool nullToAbsent) {
    return AttendancesCompanion(
      id: Value(id),
      groupPersonId: Value(groupPersonId),
      date: Value(date),
      hoursFact: Value(hoursFact),
      isNoShow: Value(isNoShow),
      dayType: dayType == null && nullToAbsent
          ? const Value.absent()
          : Value(dayType),
    );
  }

  factory Attendance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attendance(
      id: serializer.fromJson<int>(json['id']),
      groupPersonId: serializer.fromJson<int>(json['groupPersonId']),
      date: serializer.fromJson<DateTime>(json['date']),
      hoursFact: serializer.fromJson<double>(json['hoursFact']),
      isNoShow: serializer.fromJson<bool>(json['isNoShow']),
      dayType: serializer.fromJson<String?>(json['dayType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupPersonId': serializer.toJson<int>(groupPersonId),
      'date': serializer.toJson<DateTime>(date),
      'hoursFact': serializer.toJson<double>(hoursFact),
      'isNoShow': serializer.toJson<bool>(isNoShow),
      'dayType': serializer.toJson<String?>(dayType),
    };
  }

  Attendance copyWith(
          {int? id,
          int? groupPersonId,
          DateTime? date,
          double? hoursFact,
          bool? isNoShow,
          Value<String?> dayType = const Value.absent()}) =>
      Attendance(
        id: id ?? this.id,
        groupPersonId: groupPersonId ?? this.groupPersonId,
        date: date ?? this.date,
        hoursFact: hoursFact ?? this.hoursFact,
        isNoShow: isNoShow ?? this.isNoShow,
        dayType: dayType.present ? dayType.value : this.dayType,
      );
  @override
  String toString() {
    return (StringBuffer('Attendance(')
          ..write('id: $id, ')
          ..write('groupPersonId: $groupPersonId, ')
          ..write('date: $date, ')
          ..write('hoursFact: $hoursFact, ')
          ..write('isNoShow: $isNoShow, ')
          ..write('dayType: $dayType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupPersonId, date, hoursFact, isNoShow, dayType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attendance &&
          other.id == this.id &&
          other.groupPersonId == this.groupPersonId &&
          other.date == this.date &&
          other.hoursFact == this.hoursFact &&
          other.isNoShow == this.isNoShow &&
          other.dayType == this.dayType);
}

class AttendancesCompanion extends UpdateCompanion<Attendance> {
  final Value<int> id;
  final Value<int> groupPersonId;
  final Value<DateTime> date;
  final Value<double> hoursFact;
  final Value<bool> isNoShow;
  final Value<String?> dayType;
  const AttendancesCompanion({
    this.id = const Value.absent(),
    this.groupPersonId = const Value.absent(),
    this.date = const Value.absent(),
    this.hoursFact = const Value.absent(),
    this.isNoShow = const Value.absent(),
    this.dayType = const Value.absent(),
  });
  AttendancesCompanion.insert({
    this.id = const Value.absent(),
    required int groupPersonId,
    required DateTime date,
    required double hoursFact,
    this.isNoShow = const Value.absent(),
    this.dayType = const Value.absent(),
  })  : groupPersonId = Value(groupPersonId),
        date = Value(date),
        hoursFact = Value(hoursFact);
  static Insertable<Attendance> custom({
    Expression<int>? id,
    Expression<int>? groupPersonId,
    Expression<DateTime>? date,
    Expression<double>? hoursFact,
    Expression<bool>? isNoShow,
    Expression<String>? dayType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupPersonId != null) 'groupPersonId': groupPersonId,
      if (date != null) 'date': date,
      if (hoursFact != null) 'hoursFact': hoursFact,
      if (isNoShow != null) 'isNoShow': isNoShow,
      if (dayType != null) 'dayType': dayType,
    });
  }

  AttendancesCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupPersonId,
      Value<DateTime>? date,
      Value<double>? hoursFact,
      Value<bool>? isNoShow,
      Value<String?>? dayType}) {
    return AttendancesCompanion(
      id: id ?? this.id,
      groupPersonId: groupPersonId ?? this.groupPersonId,
      date: date ?? this.date,
      hoursFact: hoursFact ?? this.hoursFact,
      isNoShow: isNoShow ?? this.isNoShow,
      dayType: dayType ?? this.dayType,
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
    if (isNoShow.present) {
      map['isNoShow'] = Variable<bool>(isNoShow.value);
    }
    if (dayType.present) {
      map['dayType'] = Variable<String>(dayType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendancesCompanion(')
          ..write('id: $id, ')
          ..write('groupPersonId: $groupPersonId, ')
          ..write('date: $date, ')
          ..write('hoursFact: $hoursFact, ')
          ..write('isNoShow: $isNoShow, ')
          ..write('dayType: $dayType')
          ..write(')'))
        .toString();
  }
}

class Settings extends Table with TableInfo<Settings, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Settings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _valueTypeMeta =
      const VerificationMeta('valueType');
  late final GeneratedColumn<int> valueType = GeneratedColumn<int>(
      'valueType', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _textValueMeta =
      const VerificationMeta('textValue');
  late final GeneratedColumn<String> textValue = GeneratedColumn<String>(
      'textValue', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _boolValueMeta =
      const VerificationMeta('boolValue');
  late final GeneratedColumn<bool> boolValue = GeneratedColumn<bool>(
      'boolValue', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _intValueMeta =
      const VerificationMeta('intValue');
  late final GeneratedColumn<int> intValue = GeneratedColumn<int>(
      'intValue', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _realValueMeta =
      const VerificationMeta('realValue');
  late final GeneratedColumn<double> realValue = GeneratedColumn<double>(
      'realValue', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _dateValueMeta =
      const VerificationMeta('dateValue');
  late final GeneratedColumn<DateTime> dateValue = GeneratedColumn<DateTime>(
      'dateValue', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _isUserSettingMeta =
      const VerificationMeta('isUserSetting');
  late final GeneratedColumn<bool> isUserSetting = GeneratedColumn<bool>(
      'isUserSetting', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT FALSE',
      defaultValue: const CustomExpression('FALSE'));
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
  String get aliasedName => _alias ?? 'settings';
  @override
  String get actualTableName => 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('valueType')) {
      context.handle(_valueTypeMeta,
          valueType.isAcceptableOrUnknown(data['valueType']!, _valueTypeMeta));
    } else if (isInserting) {
      context.missing(_valueTypeMeta);
    }
    if (data.containsKey('textValue')) {
      context.handle(_textValueMeta,
          textValue.isAcceptableOrUnknown(data['textValue']!, _textValueMeta));
    }
    if (data.containsKey('boolValue')) {
      context.handle(_boolValueMeta,
          boolValue.isAcceptableOrUnknown(data['boolValue']!, _boolValueMeta));
    }
    if (data.containsKey('intValue')) {
      context.handle(_intValueMeta,
          intValue.isAcceptableOrUnknown(data['intValue']!, _intValueMeta));
    }
    if (data.containsKey('realValue')) {
      context.handle(_realValueMeta,
          realValue.isAcceptableOrUnknown(data['realValue']!, _realValueMeta));
    }
    if (data.containsKey('dateValue')) {
      context.handle(_dateValueMeta,
          dateValue.isAcceptableOrUnknown(data['dateValue']!, _dateValueMeta));
    }
    if (data.containsKey('isUserSetting')) {
      context.handle(
          _isUserSettingMeta,
          isUserSetting.isAcceptableOrUnknown(
              data['isUserSetting']!, _isUserSettingMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      valueType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}valueType'])!,
      textValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}textValue']),
      boolValue: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}boolValue']),
      intValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}intValue']),
      realValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}realValue']),
      dateValue: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}dateValue']),
      isUserSetting: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}isUserSetting'])!,
    );
  }

  @override
  Settings createAlias(String alias) {
    return Settings(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String name;
  final int valueType;
  final String? textValue;
  final bool? boolValue;
  final int? intValue;
  final double? realValue;
  final DateTime? dateValue;
  final bool isUserSetting;
  const Setting(
      {required this.id,
      required this.name,
      required this.valueType,
      this.textValue,
      this.boolValue,
      this.intValue,
      this.realValue,
      this.dateValue,
      required this.isUserSetting});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['valueType'] = Variable<int>(valueType);
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
    map['isUserSetting'] = Variable<bool>(isUserSetting);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      name: Value(name),
      valueType: Value(valueType),
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
      isUserSetting: Value(isUserSetting),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      valueType: serializer.fromJson<int>(json['valueType']),
      textValue: serializer.fromJson<String?>(json['textValue']),
      boolValue: serializer.fromJson<bool?>(json['boolValue']),
      intValue: serializer.fromJson<int?>(json['intValue']),
      realValue: serializer.fromJson<double?>(json['realValue']),
      dateValue: serializer.fromJson<DateTime?>(json['dateValue']),
      isUserSetting: serializer.fromJson<bool>(json['isUserSetting']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'valueType': serializer.toJson<int>(valueType),
      'textValue': serializer.toJson<String?>(textValue),
      'boolValue': serializer.toJson<bool?>(boolValue),
      'intValue': serializer.toJson<int?>(intValue),
      'realValue': serializer.toJson<double?>(realValue),
      'dateValue': serializer.toJson<DateTime?>(dateValue),
      'isUserSetting': serializer.toJson<bool>(isUserSetting),
    };
  }

  Setting copyWith(
          {int? id,
          String? name,
          int? valueType,
          Value<String?> textValue = const Value.absent(),
          Value<bool?> boolValue = const Value.absent(),
          Value<int?> intValue = const Value.absent(),
          Value<double?> realValue = const Value.absent(),
          Value<DateTime?> dateValue = const Value.absent(),
          bool? isUserSetting}) =>
      Setting(
        id: id ?? this.id,
        name: name ?? this.name,
        valueType: valueType ?? this.valueType,
        textValue: textValue.present ? textValue.value : this.textValue,
        boolValue: boolValue.present ? boolValue.value : this.boolValue,
        intValue: intValue.present ? intValue.value : this.intValue,
        realValue: realValue.present ? realValue.value : this.realValue,
        dateValue: dateValue.present ? dateValue.value : this.dateValue,
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
  int get hashCode => Object.hash(id, name, valueType, textValue, boolValue,
      intValue, realValue, dateValue, isUserSetting);
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
  final Value<int> valueType;
  final Value<String?> textValue;
  final Value<bool?> boolValue;
  final Value<int?> intValue;
  final Value<double?> realValue;
  final Value<DateTime?> dateValue;
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
    required String name,
    required int valueType,
    this.textValue = const Value.absent(),
    this.boolValue = const Value.absent(),
    this.intValue = const Value.absent(),
    this.realValue = const Value.absent(),
    this.dateValue = const Value.absent(),
    this.isUserSetting = const Value.absent(),
  })  : name = Value(name),
        valueType = Value(valueType);
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? valueType,
    Expression<String>? textValue,
    Expression<bool>? boolValue,
    Expression<int>? intValue,
    Expression<double>? realValue,
    Expression<DateTime>? dateValue,
    Expression<bool>? isUserSetting,
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
      {Value<int>? id,
      Value<String>? name,
      Value<int>? valueType,
      Value<String?>? textValue,
      Value<bool?>? boolValue,
      Value<int?>? intValue,
      Value<double?>? realValue,
      Value<DateTime?>? dateValue,
      Value<bool>? isUserSetting}) {
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
      map['valueType'] = Variable<int>(valueType.value);
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

abstract class _$Db extends GeneratedDatabase {
  _$Db(QueryExecutor e) : super(e);
  _$Db.connect(DatabaseConnection c) : super.connect(c);
  late final Orgs orgs = Orgs(this);
  late final Index orgsIndex =
      Index('orgs_index', 'CREATE UNIQUE INDEX orgs_index ON orgs (name)');
  late final Schedules schedules = Schedules(this);
  late final Index schedulesIndex = Index('schedules_index',
      'CREATE UNIQUE INDEX schedules_index ON schedules (code)');
  late final ScheduleDays scheduleDays = ScheduleDays(this);
  late final Index scheduleDaysIndex = Index('schedule_days_index',
      'CREATE UNIQUE INDEX schedule_days_index ON schedule_days (scheduleId, dayNumber)');
  late final Groups groups = Groups(this);
  late final Index groupsIndex = Index('groups_index',
      'CREATE UNIQUE INDEX groups_index ON "groups" (orgId, name)');
  late final Index groupsScheduleIndex = Index('groups_schedule_index',
      'CREATE INDEX groups_schedule_index ON "groups" (scheduleId)');
  late final Persons persons = Persons(this);
  late final Index personsIndex = Index('persons_index',
      'CREATE UNIQUE INDEX persons_index ON persons (family, name, middleName, birthday)');
  late final GroupPersons groupPersons = GroupPersons(this);
  late final Index groupPersonsIndex = Index('group_persons_index',
      'CREATE UNIQUE INDEX group_persons_index ON group_persons (groupId, personId)');
  late final Attendances attendances = Attendances(this);
  late final Index attendancesIndex = Index('attendances_index',
      'CREATE UNIQUE INDEX attendances_index ON attendances (groupPersonId, date)');
  late final Settings settings = Settings(this);
  late final Index settingsIndex = Index('settings_index',
      'CREATE UNIQUE INDEX settings_index ON settings (name)');
  late final OrgsDao orgsDao = OrgsDao(this as Db);
  late final SchedulesDao schedulesDao = SchedulesDao(this as Db);
  late final ScheduleDaysDao scheduleDaysDao = ScheduleDaysDao(this as Db);
  late final GroupsDao groupsDao = GroupsDao(this as Db);
  late final PersonsDao personsDao = PersonsDao(this as Db);
  late final GroupPersonsDao groupPersonsDao = GroupPersonsDao(this as Db);
  late final AttendancesDao attendancesDao = AttendancesDao(this as Db);
  late final SettingsDao settingsDao = SettingsDao(this as Db);
  Selectable<ScheduleDay> _daysInSchedule(int scheduleId) {
    return customSelect('SELECT * FROM schedule_days WHERE scheduleId = ?1',
        variables: [
          Variable<int>(scheduleId)
        ],
        readsFrom: {
          scheduleDays,
        }).asyncMap(scheduleDays.mapFromRow);
  }

  Selectable<Org> _firstOrg() {
    return customSelect(
        'SELECT * FROM orgs WHERE name = (SELECT MIN(name) FROM orgs)',
        variables: [],
        readsFrom: {
          orgs,
        }).asyncMap(orgs.mapFromRow);
  }

  Selectable<Org> _previousOrg(String orgName) {
    return customSelect(
        'SELECT * FROM orgs WHERE name = (SELECT MAX(name) FROM orgs WHERE name < ?1)',
        variables: [
          Variable<String>(orgName)
        ],
        readsFrom: {
          orgs,
        }).asyncMap(orgs.mapFromRow);
  }

  Selectable<Schedule> _firstSchedule() {
    return customSelect(
        'SELECT * FROM schedules WHERE code = (SELECT MIN(code) FROM schedules)',
        variables: [],
        readsFrom: {
          schedules,
        }).asyncMap(schedules.mapFromRow);
  }

  Selectable<Schedule> _previousSchedule(String scheduleCode) {
    return customSelect(
        'SELECT * FROM schedules WHERE code = (SELECT MAX(code) FROM schedules WHERE code < ?1)',
        variables: [
          Variable<String>(scheduleCode)
        ],
        readsFrom: {
          schedules,
        }).asyncMap(schedules.mapFromRow);
  }

  Selectable<Group> _firstGroup(int orgId) {
    return customSelect(
        'SELECT * FROM "groups" WHERE orgId = ?1 AND name = (SELECT MIN(name) FROM "groups" WHERE orgId = ?1)',
        variables: [
          Variable<int>(orgId)
        ],
        readsFrom: {
          groups,
        }).asyncMap(groups.mapFromRow);
  }

  Selectable<Group> _previousGroup(int orgId, String groupName) {
    return customSelect(
        'SELECT * FROM "groups" WHERE orgId = ?1 AND name = (SELECT MAX(name) FROM "groups" WHERE name < ?2)',
        variables: [
          Variable<int>(orgId),
          Variable<String>(groupName)
        ],
        readsFrom: {
          groups,
        }).asyncMap(groups.mapFromRow);
  }

  Selectable<OrgsViewResult> _orgsView() {
    return customSelect(
        'SELECT O.id, O.name, O.inn, O.activeGroupId, CAST((SELECT COUNT(*) FROM "groups" WHERE orgId = O.id) AS INT) AS groupCount FROM orgs AS O ORDER BY O.name, O.inn',
        variables: [],
        readsFrom: {
          orgs,
          groups,
        }).map((QueryRow row) {
      return OrgsViewResult(
        id: row.read<int>('id'),
        name: row.read<String>('name'),
        inn: row.readNullable<String>('inn'),
        activeGroupId: row.readNullable<int>('activeGroupId'),
        groupCount: row.read<int>('groupCount'),
      );
    });
  }

  Selectable<SchedulesViewResult> _schedulesView() {
    return customSelect(
        'SELECT S.id, S.code, CAST((SELECT COUNT(*) FROM "groups" WHERE scheduleId = S.id) AS INT) AS groupCount FROM schedules AS S ORDER BY S.code',
        variables: [],
        readsFrom: {
          schedules,
          groups,
        }).map((QueryRow row) {
      return SchedulesViewResult(
        id: row.read<int>('id'),
        code: row.read<String>('code'),
        groupCount: row.read<int>('groupCount'),
      );
    });
  }

  Selectable<GroupsViewResult> _groupsView(int orgId) {
    return customSelect(
        'SELECT G.id, G.orgId, G.name, G.scheduleId, S.code AS scheduleCode, G.meals, CAST((SELECT COUNT(*) FROM group_persons WHERE groupId = G.id) AS INT) AS personCount FROM "groups" AS G INNER JOIN schedules AS S ON S.id = G.scheduleId WHERE G.orgId = ?1 ORDER BY G.name, S.code',
        variables: [
          Variable<int>(orgId)
        ],
        readsFrom: {
          groups,
          schedules,
          groupPersons,
        }).map((QueryRow row) {
      return GroupsViewResult(
        id: row.read<int>('id'),
        orgId: row.read<int>('orgId'),
        name: row.read<String>('name'),
        scheduleId: row.read<int>('scheduleId'),
        scheduleCode: row.read<String>('scheduleCode'),
        meals: row.readNullable<int>('meals'),
        personCount: row.read<int>('personCount'),
      );
    });
  }

  Selectable<OrgMealsResult> _orgMeals(int orgId) {
    return customSelect(
        'SELECT G.orgId, G.meals FROM "groups" AS G WHERE G.orgId = ?1 GROUP BY G.orgId, G.meals ORDER BY G.orgId, G.meals',
        variables: [
          Variable<int>(orgId)
        ],
        readsFrom: {
          groups,
        }).map((QueryRow row) {
      return OrgMealsResult(
        orgId: row.read<int>('orgId'),
        meals: row.readNullable<int>('meals'),
      );
    });
  }

  Selectable<PersonsViewResult> _personsView() {
    return customSelect(
        'SELECT P.id, P.family, P.name, P.middleName, P.birthday, P.phone, P.phone2, CAST((SELECT COUNT(*) FROM group_persons WHERE personId = P.id) AS INT) AS groupCount FROM persons AS P ORDER BY P.family, P.name, P.middleName, P.birthday',
        variables: [],
        readsFrom: {
          persons,
          groupPersons,
        }).map((QueryRow row) {
      return PersonsViewResult(
        id: row.read<int>('id'),
        family: row.read<String>('family'),
        name: row.read<String>('name'),
        middleName: row.readNullable<String>('middleName'),
        birthday: row.readNullable<DateTime>('birthday'),
        phone: row.readNullable<String>('phone'),
        phone2: row.readNullable<String>('phone2'),
        groupCount: row.read<int>('groupCount'),
      );
    });
  }

  Selectable<Person> _findPerson(
      String family, String name, String? middleName, DateTime? birthday) {
    return customSelect(
        'SELECT P.id, P.family, P.name, P.middleName, P.birthday, P.phone, P.phone2 FROM persons AS P WHERE P.family = ?1 AND P.name = ?2 AND(?3 IS NULL OR ?3 = \'\' OR P.middleName = ?3)AND(?4 IS NULL OR P.birthday = ?4)',
        variables: [
          Variable<String>(family),
          Variable<String>(name),
          Variable<String>(middleName),
          Variable<DateTime>(birthday)
        ],
        readsFrom: {
          persons,
        }).asyncMap(persons.mapFromRow);
  }

  Selectable<PersonsInGroupResult> _personsInGroup(int groupId) {
    return customSelect(
        'SELECT L.id, L.groupId, L.personId, L.beginDate, L.endDate, P.family, P.name, P.middleName, P.birthday, P.phone, P.phone2, CAST((SELECT COUNT(*) FROM attendances AS T WHERE T.groupPersonId = L.id) AS INT) AS attendanceCount FROM group_persons AS L INNER JOIN persons AS P ON P.id = L.personId WHERE L.groupId = ?1 ORDER BY P.family, P.name, P.middleName, P.birthday',
        variables: [
          Variable<int>(groupId)
        ],
        readsFrom: {
          groupPersons,
          persons,
          attendances,
        }).map((QueryRow row) {
      return PersonsInGroupResult(
        id: row.read<int>('id'),
        groupId: row.read<int>('groupId'),
        personId: row.read<int>('personId'),
        beginDate: row.readNullable<DateTime>('beginDate'),
        endDate: row.readNullable<DateTime>('endDate'),
        family: row.read<String>('family'),
        name: row.read<String>('name'),
        middleName: row.readNullable<String>('middleName'),
        birthday: row.readNullable<DateTime>('birthday'),
        phone: row.readNullable<String>('phone'),
        phone2: row.readNullable<String>('phone2'),
        attendanceCount: row.read<int>('attendanceCount'),
      );
    });
  }

  Selectable<PersonsInGroupPeriodResult> _personsInGroupPeriod(
      int groupId, DateTime? periodBegin, DateTime? periodEnd) {
    return customSelect(
        'SELECT L.id, L.groupId, L.personId, L.beginDate, L.endDate, P.family, P.name, P.middleName, P.birthday, P.phone, P.phone2, CAST((SELECT COUNT(*) FROM attendances AS T WHERE T.groupPersonId = L.id) AS INT) AS attendanceCount FROM group_persons AS L INNER JOIN persons AS P ON P.id = L.personId WHERE L.groupId = ?1 AND(L.endDate IS NULL OR L.endDate >= ?2)AND(L.beginDate IS NULL OR L.beginDate <= ?3)ORDER BY P.family, P.name, P.middleName, P.birthday',
        variables: [
          Variable<int>(groupId),
          Variable<DateTime>(periodBegin),
          Variable<DateTime>(periodEnd)
        ],
        readsFrom: {
          groupPersons,
          persons,
          attendances,
        }).map((QueryRow row) {
      return PersonsInGroupPeriodResult(
        id: row.read<int>('id'),
        groupId: row.read<int>('groupId'),
        personId: row.read<int>('personId'),
        beginDate: row.readNullable<DateTime>('beginDate'),
        endDate: row.readNullable<DateTime>('endDate'),
        family: row.read<String>('family'),
        name: row.read<String>('name'),
        middleName: row.readNullable<String>('middleName'),
        birthday: row.readNullable<DateTime>('birthday'),
        phone: row.readNullable<String>('phone'),
        phone2: row.readNullable<String>('phone2'),
        attendanceCount: row.read<int>('attendanceCount'),
      );
    });
  }

  Selectable<Attendance> _groupPersonAttendances(
      int groupId, DateTime periodBegin, DateTime periodEnd) {
    return customSelect(
        'SELECT T.* FROM group_persons AS L INNER JOIN attendances AS T ON T.groupPersonId = L.id WHERE L.groupId = ?1 AND(L.endDate IS NULL OR L.endDate >= ?2)AND(L.beginDate IS NULL OR L.beginDate <= ?3)AND T.date >= ?2 AND T.date <= ?3',
        variables: [
          Variable<int>(groupId),
          Variable<DateTime>(periodBegin),
          Variable<DateTime>(periodEnd)
        ],
        readsFrom: {
          groupPersons,
          attendances,
        }).asyncMap(attendances.mapFromRow);
  }

  Selectable<OrgAttendancesResult> _orgAttendances(
      int orgId, DateTime periodBegin, DateTime periodEnd) {
    return customSelect(
        'SELECT L.groupId, G.meals, T.* FROM "groups" AS G INNER JOIN group_persons AS L ON L.groupId = G.id INNER JOIN attendances AS T ON T.groupPersonId = L.id WHERE G.orgId = ?1 AND(L.endDate IS NULL OR L.endDate >= ?2)AND(L.beginDate IS NULL OR L.beginDate <= ?3)AND T.date >= ?2 AND T.date <= ?3',
        variables: [
          Variable<int>(orgId),
          Variable<DateTime>(periodBegin),
          Variable<DateTime>(periodEnd)
        ],
        readsFrom: {
          groupPersons,
          groups,
          attendances,
        }).map((QueryRow row) {
      return OrgAttendancesResult(
        groupId: row.read<int>('groupId'),
        meals: row.readNullable<int>('meals'),
        id: row.read<int>('id'),
        groupPersonId: row.read<int>('groupPersonId'),
        date: row.read<DateTime>('date'),
        hoursFact: row.read<double>('hoursFact'),
        isNoShow: row.read<bool>('isNoShow'),
        dayType: row.readNullable<String>('dayType'),
      );
    });
  }

  Selectable<Org> _activeOrg() {
    return customSelect(
        'SELECT O.* FROM settings AS S INNER JOIN orgs AS O ON O.id = S.intValue WHERE S.name = \'activeOrg\'',
        variables: [],
        readsFrom: {
          settings,
          orgs,
        }).asyncMap(orgs.mapFromRow);
  }

  Future<int> _setActiveOrg(int? id) {
    return customUpdate(
      'UPDATE settings SET intValue = ?1 WHERE name = \'activeOrg\'',
      variables: [Variable<int>(id)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
  }

  Selectable<Schedule> _activeSchedule() {
    return customSelect(
        'SELECT SCH.* FROM settings AS S INNER JOIN schedules AS SCH ON SCH.id = S.intValue WHERE S.name = \'activeSchedule\'',
        variables: [],
        readsFrom: {
          settings,
          schedules,
        }).asyncMap(schedules.mapFromRow);
  }

  Future<int> _setActiveSchedule(int? id) {
    return customUpdate(
      'UPDATE settings SET intValue = ?1 WHERE name = \'activeSchedule\'',
      variables: [Variable<int>(id)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
  }

  Selectable<ActiveGroupResult> _activeGroup(int orgId) {
    return customSelect(
        'SELECT G.id, G.orgId, G.name, G.scheduleId, S.code AS scheduleCode, G.meals, CAST((SELECT COUNT(*) FROM group_persons WHERE groupId = G.id) AS INT) AS personCount FROM orgs AS O INNER JOIN "groups" AS G ON G.id = O.activeGroupId INNER JOIN schedules AS S ON S.id = G.scheduleId WHERE O.id = ?1',
        variables: [
          Variable<int>(orgId)
        ],
        readsFrom: {
          groups,
          schedules,
          groupPersons,
          orgs,
        }).map((QueryRow row) {
      return ActiveGroupResult(
        id: row.read<int>('id'),
        orgId: row.read<int>('orgId'),
        name: row.read<String>('name'),
        scheduleId: row.read<int>('scheduleId'),
        scheduleCode: row.read<String>('scheduleCode'),
        meals: row.readNullable<int>('meals'),
        personCount: row.read<int>('personCount'),
      );
    });
  }

  Future<int> _setActiveGroup(int? activeGroupId, int orgId) {
    return customUpdate(
      'UPDATE orgs SET activeGroupId = ?1 WHERE id = ?2',
      variables: [Variable<int>(activeGroupId), Variable<int>(orgId)],
      updates: {orgs},
      updateKind: UpdateKind.update,
    );
  }

  Selectable<DateTime?> _activePeriod() {
    return customSelect(
        'SELECT S.dateValue FROM settings AS S WHERE S.name = \'activePeriod\'',
        variables: [],
        readsFrom: {
          settings,
        }).map((QueryRow row) => row.readNullable<DateTime>('dateValue'));
  }

  Future<int> _setActivePeriod(DateTime? activePeriod) {
    return customUpdate(
      'UPDATE settings SET dateValue = ?1 WHERE name = \'activePeriod\'',
      variables: [Variable<DateTime>(activePeriod)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
  }

  Selectable<String?> _activeYearDayOff() {
    return customSelect(
        'SELECT S.textValue FROM settings AS S WHERE S.name = \'activeYearDayOff\'',
        variables: [],
        readsFrom: {
          settings,
        }).map((QueryRow row) => row.readNullable<String>('textValue'));
  }

  Future<int> _setActiveYearDayOff(String? activeYearDayOff) {
    return customUpdate(
      'UPDATE settings SET textValue = ?1 WHERE name = \'activeYearDayOff\'',
      variables: [Variable<String>(activeYearDayOff)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
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
  final String? inn;
  final int? activeGroupId;
  final int groupCount;
  OrgsViewResult({
    required this.id,
    required this.name,
    this.inn,
    this.activeGroupId,
    required this.groupCount,
  });
}

class SchedulesViewResult {
  final int id;
  final String code;
  final int groupCount;
  SchedulesViewResult({
    required this.id,
    required this.code,
    required this.groupCount,
  });
}

class GroupsViewResult {
  final int id;
  final int orgId;
  final String name;
  final int scheduleId;
  final String scheduleCode;
  final int? meals;
  final int personCount;
  GroupsViewResult({
    required this.id,
    required this.orgId,
    required this.name,
    required this.scheduleId,
    required this.scheduleCode,
    this.meals,
    required this.personCount,
  });
}

class OrgMealsResult {
  final int orgId;
  final int? meals;
  OrgMealsResult({
    required this.orgId,
    this.meals,
  });
}

class PersonsViewResult {
  final int id;
  final String family;
  final String name;
  final String? middleName;
  final DateTime? birthday;
  final String? phone;
  final String? phone2;
  final int groupCount;
  PersonsViewResult({
    required this.id,
    required this.family,
    required this.name,
    this.middleName,
    this.birthday,
    this.phone,
    this.phone2,
    required this.groupCount,
  });
}

class PersonsInGroupResult {
  final int id;
  final int groupId;
  final int personId;
  final DateTime? beginDate;
  final DateTime? endDate;
  final String family;
  final String name;
  final String? middleName;
  final DateTime? birthday;
  final String? phone;
  final String? phone2;
  final int attendanceCount;
  PersonsInGroupResult({
    required this.id,
    required this.groupId,
    required this.personId,
    this.beginDate,
    this.endDate,
    required this.family,
    required this.name,
    this.middleName,
    this.birthday,
    this.phone,
    this.phone2,
    required this.attendanceCount,
  });
}

class PersonsInGroupPeriodResult {
  final int id;
  final int groupId;
  final int personId;
  final DateTime? beginDate;
  final DateTime? endDate;
  final String family;
  final String name;
  final String? middleName;
  final DateTime? birthday;
  final String? phone;
  final String? phone2;
  final int attendanceCount;
  PersonsInGroupPeriodResult({
    required this.id,
    required this.groupId,
    required this.personId,
    this.beginDate,
    this.endDate,
    required this.family,
    required this.name,
    this.middleName,
    this.birthday,
    this.phone,
    this.phone2,
    required this.attendanceCount,
  });
}

class OrgAttendancesResult {
  final int groupId;
  final int? meals;
  final int id;
  final int groupPersonId;
  final DateTime date;
  final double hoursFact;
  final bool isNoShow;
  final String? dayType;
  OrgAttendancesResult({
    required this.groupId,
    this.meals,
    required this.id,
    required this.groupPersonId,
    required this.date,
    required this.hoursFact,
    required this.isNoShow,
    this.dayType,
  });
}

class ActiveGroupResult {
  final int id;
  final int orgId;
  final String name;
  final int scheduleId;
  final String scheduleCode;
  final int? meals;
  final int personCount;
  ActiveGroupResult({
    required this.id,
    required this.orgId,
    required this.name,
    required this.scheduleId,
    required this.scheduleCode,
    this.meals,
    required this.personCount,
  });
}

mixin _$OrgsDaoMixin on DatabaseAccessor<Db> {}
mixin _$SchedulesDaoMixin on DatabaseAccessor<Db> {}
mixin _$ScheduleDaysDaoMixin on DatabaseAccessor<Db> {}
mixin _$GroupsDaoMixin on DatabaseAccessor<Db> {}
mixin _$PersonsDaoMixin on DatabaseAccessor<Db> {}
mixin _$GroupPersonsDaoMixin on DatabaseAccessor<Db> {}
mixin _$AttendancesDaoMixin on DatabaseAccessor<Db> {}
mixin _$SettingsDaoMixin on DatabaseAccessor<Db> {}
