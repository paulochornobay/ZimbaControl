// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PeopleTable extends People with TableInfo<$PeopleTable, PersonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeopleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    displayName,
    kind,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'people';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $PeopleTable createAlias(String alias) {
    return $PeopleTable(attachedDatabase, alias);
  }
}

class PersonRow extends DataClass implements Insertable<PersonRow> {
  final String id;
  final String householdId;
  final String displayName;
  final String kind;
  final bool active;
  const PersonRow({
    required this.id,
    required this.householdId,
    required this.displayName,
    required this.kind,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['display_name'] = Variable<String>(displayName);
    map['kind'] = Variable<String>(kind);
    map['active'] = Variable<bool>(active);
    return map;
  }

  PeopleCompanion toCompanion(bool nullToAbsent) {
    return PeopleCompanion(
      id: Value(id),
      householdId: Value(householdId),
      displayName: Value(displayName),
      kind: Value(kind),
      active: Value(active),
    );
  }

  factory PersonRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      kind: serializer.fromJson<String>(json['kind']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'displayName': serializer.toJson<String>(displayName),
      'kind': serializer.toJson<String>(kind),
      'active': serializer.toJson<bool>(active),
    };
  }

  PersonRow copyWith({
    String? id,
    String? householdId,
    String? displayName,
    String? kind,
    bool? active,
  }) => PersonRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    displayName: displayName ?? this.displayName,
    kind: kind ?? this.kind,
    active: active ?? this.active,
  );
  PersonRow copyWithCompanion(PeopleCompanion data) {
    return PersonRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      kind: data.kind.present ? data.kind.value : this.kind,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('displayName: $displayName, ')
          ..write('kind: $kind, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, householdId, displayName, kind, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.displayName == this.displayName &&
          other.kind == this.kind &&
          other.active == this.active);
}

class PeopleCompanion extends UpdateCompanion<PersonRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> displayName;
  final Value<String> kind;
  final Value<bool> active;
  final Value<int> rowid;
  const PeopleCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.kind = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PeopleCompanion.insert({
    required String id,
    required String householdId,
    required String displayName,
    required String kind,
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       displayName = Value(displayName),
       kind = Value(kind);
  static Insertable<PersonRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? displayName,
    Expression<String>? kind,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (displayName != null) 'display_name': displayName,
      if (kind != null) 'kind': kind,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PeopleCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? displayName,
    Value<String>? kind,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return PeopleCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      displayName: displayName ?? this.displayName,
      kind: kind ?? this.kind,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeopleCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('displayName: $displayName, ')
          ..write('kind: $kind, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BRL'),
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    provider,
    name,
    type,
    currencyCode,
    last4,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('last4')) {
      context.handle(
        _last4Meta,
        last4.isAcceptableOrUnknown(data['last4']!, _last4Meta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      last4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last4'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String householdId;
  final String provider;
  final String name;
  final String type;
  final String currencyCode;
  final String? last4;
  final bool active;
  const AccountRow({
    required this.id,
    required this.householdId,
    required this.provider,
    required this.name,
    required this.type,
    required this.currencyCode,
    this.last4,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['provider'] = Variable<String>(provider);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || last4 != null) {
      map['last4'] = Variable<String>(last4);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      provider: Value(provider),
      name: Value(name),
      type: Value(type),
      currencyCode: Value(currencyCode),
      last4: last4 == null && nullToAbsent
          ? const Value.absent()
          : Value(last4),
      active: Value(active),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      provider: serializer.fromJson<String>(json['provider']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      last4: serializer.fromJson<String?>(json['last4']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'provider': serializer.toJson<String>(provider),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'last4': serializer.toJson<String?>(last4),
      'active': serializer.toJson<bool>(active),
    };
  }

  AccountRow copyWith({
    String? id,
    String? householdId,
    String? provider,
    String? name,
    String? type,
    String? currencyCode,
    Value<String?> last4 = const Value.absent(),
    bool? active,
  }) => AccountRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    provider: provider ?? this.provider,
    name: name ?? this.name,
    type: type ?? this.type,
    currencyCode: currencyCode ?? this.currencyCode,
    last4: last4.present ? last4.value : this.last4,
    active: active ?? this.active,
  );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      provider: data.provider.present ? data.provider.value : this.provider,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      last4: data.last4.present ? data.last4.value : this.last4,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('provider: $provider, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('last4: $last4, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    provider,
    name,
    type,
    currencyCode,
    last4,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.provider == this.provider &&
          other.name == this.name &&
          other.type == this.type &&
          other.currencyCode == this.currencyCode &&
          other.last4 == this.last4 &&
          other.active == this.active);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> provider;
  final Value<String> name;
  final Value<String> type;
  final Value<String> currencyCode;
  final Value<String?> last4;
  final Value<bool> active;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.provider = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.last4 = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String householdId,
    required String provider,
    required String name,
    required String type,
    this.currencyCode = const Value.absent(),
    this.last4 = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       provider = Value(provider),
       name = Value(name),
       type = Value(type);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? provider,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? currencyCode,
    Expression<String>? last4,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (provider != null) 'provider': provider,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (last4 != null) 'last4': last4,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? provider,
    Value<String>? name,
    Value<String>? type,
    Value<String>? currencyCode,
    Value<String?>? last4,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      provider: provider ?? this.provider,
      name: name ?? this.name,
      type: type ?? this.type,
      currencyCode: currencyCode ?? this.currencyCode,
      last4: last4 ?? this.last4,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('provider: $provider, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('last4: $last4, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditCardsTable extends CreditCards
    with TableInfo<$CreditCardsTable, CreditCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billingDayMeta = const VerificationMeta(
    'billingDay',
  );
  @override
  late final GeneratedColumn<int> billingDay = GeneratedColumn<int>(
    'billing_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    provider,
    name,
    brand,
    last4,
    billingDay,
    dueDay,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditCardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('last4')) {
      context.handle(
        _last4Meta,
        last4.isAcceptableOrUnknown(data['last4']!, _last4Meta),
      );
    }
    if (data.containsKey('billing_day')) {
      context.handle(
        _billingDayMeta,
        billingDay.isAcceptableOrUnknown(data['billing_day']!, _billingDayMeta),
      );
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditCardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      last4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last4'],
      ),
      billingDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}billing_day'],
      ),
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $CreditCardsTable createAlias(String alias) {
    return $CreditCardsTable(attachedDatabase, alias);
  }
}

class CreditCardRow extends DataClass implements Insertable<CreditCardRow> {
  final String id;
  final String householdId;
  final String provider;
  final String name;
  final String? brand;
  final String? last4;
  final int? billingDay;
  final int? dueDay;
  final bool active;
  const CreditCardRow({
    required this.id,
    required this.householdId,
    required this.provider,
    required this.name,
    this.brand,
    this.last4,
    this.billingDay,
    this.dueDay,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['provider'] = Variable<String>(provider);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || last4 != null) {
      map['last4'] = Variable<String>(last4);
    }
    if (!nullToAbsent || billingDay != null) {
      map['billing_day'] = Variable<int>(billingDay);
    }
    if (!nullToAbsent || dueDay != null) {
      map['due_day'] = Variable<int>(dueDay);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  CreditCardsCompanion toCompanion(bool nullToAbsent) {
    return CreditCardsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      provider: Value(provider),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      last4: last4 == null && nullToAbsent
          ? const Value.absent()
          : Value(last4),
      billingDay: billingDay == null && nullToAbsent
          ? const Value.absent()
          : Value(billingDay),
      dueDay: dueDay == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDay),
      active: Value(active),
    );
  }

  factory CreditCardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditCardRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      provider: serializer.fromJson<String>(json['provider']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      last4: serializer.fromJson<String?>(json['last4']),
      billingDay: serializer.fromJson<int?>(json['billingDay']),
      dueDay: serializer.fromJson<int?>(json['dueDay']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'provider': serializer.toJson<String>(provider),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'last4': serializer.toJson<String?>(last4),
      'billingDay': serializer.toJson<int?>(billingDay),
      'dueDay': serializer.toJson<int?>(dueDay),
      'active': serializer.toJson<bool>(active),
    };
  }

  CreditCardRow copyWith({
    String? id,
    String? householdId,
    String? provider,
    String? name,
    Value<String?> brand = const Value.absent(),
    Value<String?> last4 = const Value.absent(),
    Value<int?> billingDay = const Value.absent(),
    Value<int?> dueDay = const Value.absent(),
    bool? active,
  }) => CreditCardRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    provider: provider ?? this.provider,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    last4: last4.present ? last4.value : this.last4,
    billingDay: billingDay.present ? billingDay.value : this.billingDay,
    dueDay: dueDay.present ? dueDay.value : this.dueDay,
    active: active ?? this.active,
  );
  CreditCardRow copyWithCompanion(CreditCardsCompanion data) {
    return CreditCardRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      provider: data.provider.present ? data.provider.value : this.provider,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      last4: data.last4.present ? data.last4.value : this.last4,
      billingDay: data.billingDay.present
          ? data.billingDay.value
          : this.billingDay,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('provider: $provider, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('last4: $last4, ')
          ..write('billingDay: $billingDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    provider,
    name,
    brand,
    last4,
    billingDay,
    dueDay,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditCardRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.provider == this.provider &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.last4 == this.last4 &&
          other.billingDay == this.billingDay &&
          other.dueDay == this.dueDay &&
          other.active == this.active);
}

class CreditCardsCompanion extends UpdateCompanion<CreditCardRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> provider;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> last4;
  final Value<int?> billingDay;
  final Value<int?> dueDay;
  final Value<bool> active;
  final Value<int> rowid;
  const CreditCardsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.provider = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.last4 = const Value.absent(),
    this.billingDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditCardsCompanion.insert({
    required String id,
    required String householdId,
    required String provider,
    required String name,
    this.brand = const Value.absent(),
    this.last4 = const Value.absent(),
    this.billingDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       provider = Value(provider),
       name = Value(name);
  static Insertable<CreditCardRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? provider,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? last4,
    Expression<int>? billingDay,
    Expression<int>? dueDay,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (provider != null) 'provider': provider,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (last4 != null) 'last4': last4,
      if (billingDay != null) 'billing_day': billingDay,
      if (dueDay != null) 'due_day': dueDay,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? provider,
    Value<String>? name,
    Value<String?>? brand,
    Value<String?>? last4,
    Value<int?>? billingDay,
    Value<int?>? dueDay,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return CreditCardsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      provider: provider ?? this.provider,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      billingDay: billingDay ?? this.billingDay,
      dueDay: dueDay ?? this.dueDay,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (billingDay.present) {
      map['billing_day'] = Variable<int>(billingDay.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('provider: $provider, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('last4: $last4, ')
          ..write('billingDay: $billingDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    parentId,
    name,
    kind,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String householdId;
  final String? parentId;
  final String name;
  final String kind;
  final int sortOrder;
  const CategoryRow({
    required this.id,
    required this.householdId,
    this.parentId,
    required this.name,
    required this.kind,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      kind: Value(kind),
      sortOrder: Value(sortOrder),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'parentId': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? householdId,
    Value<String?> parentId = const Value.absent(),
    String? name,
    String? kind,
    int? sortOrder,
  }) => CategoryRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, householdId, parentId, name, kind, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<String> kind;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String householdId,
    this.parentId = const Value.absent(),
    required String name,
    required String kind,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       name = Value(name),
       kind = Value(kind);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String?>? parentId,
    Value<String>? name,
    Value<String>? kind,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CostCentersTable extends CostCenters
    with TableInfo<$CostCentersTable, CostCenterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CostCentersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, householdId, name, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cost_centers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CostCenterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CostCenterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CostCenterRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $CostCentersTable createAlias(String alias) {
    return $CostCentersTable(attachedDatabase, alias);
  }
}

class CostCenterRow extends DataClass implements Insertable<CostCenterRow> {
  final String id;
  final String householdId;
  final String name;
  final bool active;
  const CostCenterRow({
    required this.id,
    required this.householdId,
    required this.name,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['name'] = Variable<String>(name);
    map['active'] = Variable<bool>(active);
    return map;
  }

  CostCentersCompanion toCompanion(bool nullToAbsent) {
    return CostCentersCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      active: Value(active),
    );
  }

  factory CostCenterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CostCenterRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      name: serializer.fromJson<String>(json['name']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'name': serializer.toJson<String>(name),
      'active': serializer.toJson<bool>(active),
    };
  }

  CostCenterRow copyWith({
    String? id,
    String? householdId,
    String? name,
    bool? active,
  }) => CostCenterRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    name: name ?? this.name,
    active: active ?? this.active,
  );
  CostCenterRow copyWithCompanion(CostCentersCompanion data) {
    return CostCenterRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CostCenterRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, householdId, name, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CostCenterRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.active == this.active);
}

class CostCentersCompanion extends UpdateCompanion<CostCenterRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> name;
  final Value<bool> active;
  final Value<int> rowid;
  const CostCentersCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CostCentersCompanion.insert({
    required String id,
    required String householdId,
    required String name,
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       name = Value(name);
  static Insertable<CostCenterRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? name,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CostCentersCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? name,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return CostCentersCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CostCentersCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MerchantsTable extends Merchants
    with TableInfo<$MerchantsTable, MerchantRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MerchantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedNameMeta = const VerificationMeta(
    'normalizedName',
  );
  @override
  late final GeneratedColumn<String> normalizedName = GeneratedColumn<String>(
    'normalized_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerHintsJsonMeta = const VerificationMeta(
    'providerHintsJson',
  );
  @override
  late final GeneratedColumn<String> providerHintsJson =
      GeneratedColumn<String>(
        'provider_hints_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    normalizedName,
    displayName,
    providerHintsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merchants';
  @override
  VerificationContext validateIntegrity(
    Insertable<MerchantRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('normalized_name')) {
      context.handle(
        _normalizedNameMeta,
        normalizedName.isAcceptableOrUnknown(
          data['normalized_name']!,
          _normalizedNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedNameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('provider_hints_json')) {
      context.handle(
        _providerHintsJsonMeta,
        providerHintsJson.isAcceptableOrUnknown(
          data['provider_hints_json']!,
          _providerHintsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MerchantRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MerchantRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      normalizedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_name'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      providerHintsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_hints_json'],
      ),
    );
  }

  @override
  $MerchantsTable createAlias(String alias) {
    return $MerchantsTable(attachedDatabase, alias);
  }
}

class MerchantRow extends DataClass implements Insertable<MerchantRow> {
  final String id;
  final String householdId;
  final String normalizedName;
  final String displayName;
  final String? providerHintsJson;
  const MerchantRow({
    required this.id,
    required this.householdId,
    required this.normalizedName,
    required this.displayName,
    this.providerHintsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['normalized_name'] = Variable<String>(normalizedName);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || providerHintsJson != null) {
      map['provider_hints_json'] = Variable<String>(providerHintsJson);
    }
    return map;
  }

  MerchantsCompanion toCompanion(bool nullToAbsent) {
    return MerchantsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      normalizedName: Value(normalizedName),
      displayName: Value(displayName),
      providerHintsJson: providerHintsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(providerHintsJson),
    );
  }

  factory MerchantRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MerchantRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      normalizedName: serializer.fromJson<String>(json['normalizedName']),
      displayName: serializer.fromJson<String>(json['displayName']),
      providerHintsJson: serializer.fromJson<String?>(
        json['providerHintsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'normalizedName': serializer.toJson<String>(normalizedName),
      'displayName': serializer.toJson<String>(displayName),
      'providerHintsJson': serializer.toJson<String?>(providerHintsJson),
    };
  }

  MerchantRow copyWith({
    String? id,
    String? householdId,
    String? normalizedName,
    String? displayName,
    Value<String?> providerHintsJson = const Value.absent(),
  }) => MerchantRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    normalizedName: normalizedName ?? this.normalizedName,
    displayName: displayName ?? this.displayName,
    providerHintsJson: providerHintsJson.present
        ? providerHintsJson.value
        : this.providerHintsJson,
  );
  MerchantRow copyWithCompanion(MerchantsCompanion data) {
    return MerchantRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      normalizedName: data.normalizedName.present
          ? data.normalizedName.value
          : this.normalizedName,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      providerHintsJson: data.providerHintsJson.present
          ? data.providerHintsJson.value
          : this.providerHintsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MerchantRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('displayName: $displayName, ')
          ..write('providerHintsJson: $providerHintsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    normalizedName,
    displayName,
    providerHintsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MerchantRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.normalizedName == this.normalizedName &&
          other.displayName == this.displayName &&
          other.providerHintsJson == this.providerHintsJson);
}

class MerchantsCompanion extends UpdateCompanion<MerchantRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> normalizedName;
  final Value<String> displayName;
  final Value<String?> providerHintsJson;
  final Value<int> rowid;
  const MerchantsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.normalizedName = const Value.absent(),
    this.displayName = const Value.absent(),
    this.providerHintsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MerchantsCompanion.insert({
    required String id,
    required String householdId,
    required String normalizedName,
    required String displayName,
    this.providerHintsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       normalizedName = Value(normalizedName),
       displayName = Value(displayName);
  static Insertable<MerchantRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? normalizedName,
    Expression<String>? displayName,
    Expression<String>? providerHintsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (normalizedName != null) 'normalized_name': normalizedName,
      if (displayName != null) 'display_name': displayName,
      if (providerHintsJson != null) 'provider_hints_json': providerHintsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MerchantsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? normalizedName,
    Value<String>? displayName,
    Value<String?>? providerHintsJson,
    Value<int>? rowid,
  }) {
    return MerchantsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      normalizedName: normalizedName ?? this.normalizedName,
      displayName: displayName ?? this.displayName,
      providerHintsJson: providerHintsJson ?? this.providerHintsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (normalizedName.present) {
      map['normalized_name'] = Variable<String>(normalizedName.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (providerHintsJson.present) {
      map['provider_hints_json'] = Variable<String>(providerHintsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MerchantsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('displayName: $displayName, ')
          ..write('providerHintsJson: $providerHintsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, FinanceTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewStatusMeta = const VerificationMeta(
    'reviewStatus',
  );
  @override
  late final GeneratedColumn<String> reviewStatus = GeneratedColumn<String>(
    'review_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duplicateStatusMeta = const VerificationMeta(
    'duplicateStatus',
  );
  @override
  late final GeneratedColumn<String> duplicateStatus = GeneratedColumn<String>(
    'duplicate_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postedAtMeta = const VerificationMeta(
    'postedAt',
  );
  @override
  late final GeneratedColumn<DateTime> postedAt = GeneratedColumn<DateTime>(
    'posted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _competenceMonthMeta = const VerificationMeta(
    'competenceMonth',
  );
  @override
  late final GeneratedColumn<String> competenceMonth = GeneratedColumn<String>(
    'competence_month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BRL'),
  );
  static const VerificationMeta _descriptionRawMeta = const VerificationMeta(
    'descriptionRaw',
  );
  @override
  late final GeneratedColumn<String> descriptionRaw = GeneratedColumn<String>(
    'description_raw',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _merchantIdMeta = const VerificationMeta(
    'merchantId',
  );
  @override
  late final GeneratedColumn<String> merchantId = GeneratedColumn<String>(
    'merchant_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costCenterIdMeta = const VerificationMeta(
    'costCenterId',
  );
  @override
  late final GeneratedColumn<String> costCenterId = GeneratedColumn<String>(
    'cost_center_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payerIdMeta = const VerificationMeta(
    'payerId',
  );
  @override
  late final GeneratedColumn<String> payerId = GeneratedColumn<String>(
    'payer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceConfidenceMeta = const VerificationMeta(
    'sourceConfidence',
  );
  @override
  late final GeneratedColumn<double> sourceConfidence = GeneratedColumn<double>(
    'source_confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _baseVersionMeta = const VerificationMeta(
    'baseVersion',
  );
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
    'base_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _serverVersionMeta = const VerificationMeta(
    'serverVersion',
  );
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
    'server_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    kind,
    reviewStatus,
    duplicateStatus,
    occurredAt,
    postedAt,
    competenceMonth,
    amountCents,
    currencyCode,
    descriptionRaw,
    accountId,
    merchantId,
    categoryId,
    costCenterId,
    payerId,
    sourceConfidence,
    baseVersion,
    serverVersion,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinanceTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('review_status')) {
      context.handle(
        _reviewStatusMeta,
        reviewStatus.isAcceptableOrUnknown(
          data['review_status']!,
          _reviewStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reviewStatusMeta);
    }
    if (data.containsKey('duplicate_status')) {
      context.handle(
        _duplicateStatusMeta,
        duplicateStatus.isAcceptableOrUnknown(
          data['duplicate_status']!,
          _duplicateStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_duplicateStatusMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('posted_at')) {
      context.handle(
        _postedAtMeta,
        postedAt.isAcceptableOrUnknown(data['posted_at']!, _postedAtMeta),
      );
    }
    if (data.containsKey('competence_month')) {
      context.handle(
        _competenceMonthMeta,
        competenceMonth.isAcceptableOrUnknown(
          data['competence_month']!,
          _competenceMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_competenceMonthMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('description_raw')) {
      context.handle(
        _descriptionRawMeta,
        descriptionRaw.isAcceptableOrUnknown(
          data['description_raw']!,
          _descriptionRawMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionRawMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('merchant_id')) {
      context.handle(
        _merchantIdMeta,
        merchantId.isAcceptableOrUnknown(data['merchant_id']!, _merchantIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('cost_center_id')) {
      context.handle(
        _costCenterIdMeta,
        costCenterId.isAcceptableOrUnknown(
          data['cost_center_id']!,
          _costCenterIdMeta,
        ),
      );
    }
    if (data.containsKey('payer_id')) {
      context.handle(
        _payerIdMeta,
        payerId.isAcceptableOrUnknown(data['payer_id']!, _payerIdMeta),
      );
    }
    if (data.containsKey('source_confidence')) {
      context.handle(
        _sourceConfidenceMeta,
        sourceConfidence.isAcceptableOrUnknown(
          data['source_confidence']!,
          _sourceConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('base_version')) {
      context.handle(
        _baseVersionMeta,
        baseVersion.isAcceptableOrUnknown(
          data['base_version']!,
          _baseVersionMeta,
        ),
      );
    }
    if (data.containsKey('server_version')) {
      context.handle(
        _serverVersionMeta,
        serverVersion.isAcceptableOrUnknown(
          data['server_version']!,
          _serverVersionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinanceTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinanceTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      reviewStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_status'],
      )!,
      duplicateStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duplicate_status'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      postedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}posted_at'],
      ),
      competenceMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}competence_month'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      descriptionRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_raw'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      merchantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      costCenterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cost_center_id'],
      ),
      payerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payer_id'],
      ),
      sourceConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}source_confidence'],
      )!,
      baseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_version'],
      )!,
      serverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class FinanceTransaction extends DataClass
    implements Insertable<FinanceTransaction> {
  final String id;
  final String householdId;
  final String kind;
  final String reviewStatus;
  final String duplicateStatus;
  final DateTime occurredAt;
  final DateTime? postedAt;
  final String competenceMonth;
  final int amountCents;
  final String currencyCode;
  final String descriptionRaw;
  final String? accountId;
  final String? merchantId;
  final String? categoryId;
  final String? costCenterId;
  final String? payerId;
  final double sourceConfidence;
  final int baseVersion;
  final int serverVersion;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const FinanceTransaction({
    required this.id,
    required this.householdId,
    required this.kind,
    required this.reviewStatus,
    required this.duplicateStatus,
    required this.occurredAt,
    this.postedAt,
    required this.competenceMonth,
    required this.amountCents,
    required this.currencyCode,
    required this.descriptionRaw,
    this.accountId,
    this.merchantId,
    this.categoryId,
    this.costCenterId,
    this.payerId,
    required this.sourceConfidence,
    required this.baseVersion,
    required this.serverVersion,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['kind'] = Variable<String>(kind);
    map['review_status'] = Variable<String>(reviewStatus);
    map['duplicate_status'] = Variable<String>(duplicateStatus);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || postedAt != null) {
      map['posted_at'] = Variable<DateTime>(postedAt);
    }
    map['competence_month'] = Variable<String>(competenceMonth);
    map['amount_cents'] = Variable<int>(amountCents);
    map['currency_code'] = Variable<String>(currencyCode);
    map['description_raw'] = Variable<String>(descriptionRaw);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || merchantId != null) {
      map['merchant_id'] = Variable<String>(merchantId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || costCenterId != null) {
      map['cost_center_id'] = Variable<String>(costCenterId);
    }
    if (!nullToAbsent || payerId != null) {
      map['payer_id'] = Variable<String>(payerId);
    }
    map['source_confidence'] = Variable<double>(sourceConfidence);
    map['base_version'] = Variable<int>(baseVersion);
    map['server_version'] = Variable<int>(serverVersion);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      kind: Value(kind),
      reviewStatus: Value(reviewStatus),
      duplicateStatus: Value(duplicateStatus),
      occurredAt: Value(occurredAt),
      postedAt: postedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(postedAt),
      competenceMonth: Value(competenceMonth),
      amountCents: Value(amountCents),
      currencyCode: Value(currencyCode),
      descriptionRaw: Value(descriptionRaw),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      merchantId: merchantId == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      costCenterId: costCenterId == null && nullToAbsent
          ? const Value.absent()
          : Value(costCenterId),
      payerId: payerId == null && nullToAbsent
          ? const Value.absent()
          : Value(payerId),
      sourceConfidence: Value(sourceConfidence),
      baseVersion: Value(baseVersion),
      serverVersion: Value(serverVersion),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory FinanceTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinanceTransaction(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      kind: serializer.fromJson<String>(json['kind']),
      reviewStatus: serializer.fromJson<String>(json['reviewStatus']),
      duplicateStatus: serializer.fromJson<String>(json['duplicateStatus']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      postedAt: serializer.fromJson<DateTime?>(json['postedAt']),
      competenceMonth: serializer.fromJson<String>(json['competenceMonth']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      descriptionRaw: serializer.fromJson<String>(json['descriptionRaw']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      merchantId: serializer.fromJson<String?>(json['merchantId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      costCenterId: serializer.fromJson<String?>(json['costCenterId']),
      payerId: serializer.fromJson<String?>(json['payerId']),
      sourceConfidence: serializer.fromJson<double>(json['sourceConfidence']),
      baseVersion: serializer.fromJson<int>(json['baseVersion']),
      serverVersion: serializer.fromJson<int>(json['serverVersion']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'kind': serializer.toJson<String>(kind),
      'reviewStatus': serializer.toJson<String>(reviewStatus),
      'duplicateStatus': serializer.toJson<String>(duplicateStatus),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'postedAt': serializer.toJson<DateTime?>(postedAt),
      'competenceMonth': serializer.toJson<String>(competenceMonth),
      'amountCents': serializer.toJson<int>(amountCents),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'descriptionRaw': serializer.toJson<String>(descriptionRaw),
      'accountId': serializer.toJson<String?>(accountId),
      'merchantId': serializer.toJson<String?>(merchantId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'costCenterId': serializer.toJson<String?>(costCenterId),
      'payerId': serializer.toJson<String?>(payerId),
      'sourceConfidence': serializer.toJson<double>(sourceConfidence),
      'baseVersion': serializer.toJson<int>(baseVersion),
      'serverVersion': serializer.toJson<int>(serverVersion),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  FinanceTransaction copyWith({
    String? id,
    String? householdId,
    String? kind,
    String? reviewStatus,
    String? duplicateStatus,
    DateTime? occurredAt,
    Value<DateTime?> postedAt = const Value.absent(),
    String? competenceMonth,
    int? amountCents,
    String? currencyCode,
    String? descriptionRaw,
    Value<String?> accountId = const Value.absent(),
    Value<String?> merchantId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> costCenterId = const Value.absent(),
    Value<String?> payerId = const Value.absent(),
    double? sourceConfidence,
    int? baseVersion,
    int? serverVersion,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => FinanceTransaction(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    kind: kind ?? this.kind,
    reviewStatus: reviewStatus ?? this.reviewStatus,
    duplicateStatus: duplicateStatus ?? this.duplicateStatus,
    occurredAt: occurredAt ?? this.occurredAt,
    postedAt: postedAt.present ? postedAt.value : this.postedAt,
    competenceMonth: competenceMonth ?? this.competenceMonth,
    amountCents: amountCents ?? this.amountCents,
    currencyCode: currencyCode ?? this.currencyCode,
    descriptionRaw: descriptionRaw ?? this.descriptionRaw,
    accountId: accountId.present ? accountId.value : this.accountId,
    merchantId: merchantId.present ? merchantId.value : this.merchantId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    costCenterId: costCenterId.present ? costCenterId.value : this.costCenterId,
    payerId: payerId.present ? payerId.value : this.payerId,
    sourceConfidence: sourceConfidence ?? this.sourceConfidence,
    baseVersion: baseVersion ?? this.baseVersion,
    serverVersion: serverVersion ?? this.serverVersion,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  FinanceTransaction copyWithCompanion(TransactionsCompanion data) {
    return FinanceTransaction(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      kind: data.kind.present ? data.kind.value : this.kind,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      duplicateStatus: data.duplicateStatus.present
          ? data.duplicateStatus.value
          : this.duplicateStatus,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      postedAt: data.postedAt.present ? data.postedAt.value : this.postedAt,
      competenceMonth: data.competenceMonth.present
          ? data.competenceMonth.value
          : this.competenceMonth,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      descriptionRaw: data.descriptionRaw.present
          ? data.descriptionRaw.value
          : this.descriptionRaw,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      merchantId: data.merchantId.present
          ? data.merchantId.value
          : this.merchantId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      costCenterId: data.costCenterId.present
          ? data.costCenterId.value
          : this.costCenterId,
      payerId: data.payerId.present ? data.payerId.value : this.payerId,
      sourceConfidence: data.sourceConfidence.present
          ? data.sourceConfidence.value
          : this.sourceConfidence,
      baseVersion: data.baseVersion.present
          ? data.baseVersion.value
          : this.baseVersion,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinanceTransaction(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('kind: $kind, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('duplicateStatus: $duplicateStatus, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('postedAt: $postedAt, ')
          ..write('competenceMonth: $competenceMonth, ')
          ..write('amountCents: $amountCents, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('descriptionRaw: $descriptionRaw, ')
          ..write('accountId: $accountId, ')
          ..write('merchantId: $merchantId, ')
          ..write('categoryId: $categoryId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('payerId: $payerId, ')
          ..write('sourceConfidence: $sourceConfidence, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    householdId,
    kind,
    reviewStatus,
    duplicateStatus,
    occurredAt,
    postedAt,
    competenceMonth,
    amountCents,
    currencyCode,
    descriptionRaw,
    accountId,
    merchantId,
    categoryId,
    costCenterId,
    payerId,
    sourceConfidence,
    baseVersion,
    serverVersion,
    updatedAt,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinanceTransaction &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.kind == this.kind &&
          other.reviewStatus == this.reviewStatus &&
          other.duplicateStatus == this.duplicateStatus &&
          other.occurredAt == this.occurredAt &&
          other.postedAt == this.postedAt &&
          other.competenceMonth == this.competenceMonth &&
          other.amountCents == this.amountCents &&
          other.currencyCode == this.currencyCode &&
          other.descriptionRaw == this.descriptionRaw &&
          other.accountId == this.accountId &&
          other.merchantId == this.merchantId &&
          other.categoryId == this.categoryId &&
          other.costCenterId == this.costCenterId &&
          other.payerId == this.payerId &&
          other.sourceConfidence == this.sourceConfidence &&
          other.baseVersion == this.baseVersion &&
          other.serverVersion == this.serverVersion &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TransactionsCompanion extends UpdateCompanion<FinanceTransaction> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> kind;
  final Value<String> reviewStatus;
  final Value<String> duplicateStatus;
  final Value<DateTime> occurredAt;
  final Value<DateTime?> postedAt;
  final Value<String> competenceMonth;
  final Value<int> amountCents;
  final Value<String> currencyCode;
  final Value<String> descriptionRaw;
  final Value<String?> accountId;
  final Value<String?> merchantId;
  final Value<String?> categoryId;
  final Value<String?> costCenterId;
  final Value<String?> payerId;
  final Value<double> sourceConfidence;
  final Value<int> baseVersion;
  final Value<int> serverVersion;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.kind = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.duplicateStatus = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.competenceMonth = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.descriptionRaw = const Value.absent(),
    this.accountId = const Value.absent(),
    this.merchantId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.payerId = const Value.absent(),
    this.sourceConfidence = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String householdId,
    required String kind,
    required String reviewStatus,
    required String duplicateStatus,
    required DateTime occurredAt,
    this.postedAt = const Value.absent(),
    required String competenceMonth,
    required int amountCents,
    this.currencyCode = const Value.absent(),
    required String descriptionRaw,
    this.accountId = const Value.absent(),
    this.merchantId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.payerId = const Value.absent(),
    this.sourceConfidence = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.serverVersion = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       kind = Value(kind),
       reviewStatus = Value(reviewStatus),
       duplicateStatus = Value(duplicateStatus),
       occurredAt = Value(occurredAt),
       competenceMonth = Value(competenceMonth),
       amountCents = Value(amountCents),
       descriptionRaw = Value(descriptionRaw),
       updatedAt = Value(updatedAt);
  static Insertable<FinanceTransaction> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? kind,
    Expression<String>? reviewStatus,
    Expression<String>? duplicateStatus,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? postedAt,
    Expression<String>? competenceMonth,
    Expression<int>? amountCents,
    Expression<String>? currencyCode,
    Expression<String>? descriptionRaw,
    Expression<String>? accountId,
    Expression<String>? merchantId,
    Expression<String>? categoryId,
    Expression<String>? costCenterId,
    Expression<String>? payerId,
    Expression<double>? sourceConfidence,
    Expression<int>? baseVersion,
    Expression<int>? serverVersion,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (kind != null) 'kind': kind,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (duplicateStatus != null) 'duplicate_status': duplicateStatus,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (postedAt != null) 'posted_at': postedAt,
      if (competenceMonth != null) 'competence_month': competenceMonth,
      if (amountCents != null) 'amount_cents': amountCents,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (descriptionRaw != null) 'description_raw': descriptionRaw,
      if (accountId != null) 'account_id': accountId,
      if (merchantId != null) 'merchant_id': merchantId,
      if (categoryId != null) 'category_id': categoryId,
      if (costCenterId != null) 'cost_center_id': costCenterId,
      if (payerId != null) 'payer_id': payerId,
      if (sourceConfidence != null) 'source_confidence': sourceConfidence,
      if (baseVersion != null) 'base_version': baseVersion,
      if (serverVersion != null) 'server_version': serverVersion,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? kind,
    Value<String>? reviewStatus,
    Value<String>? duplicateStatus,
    Value<DateTime>? occurredAt,
    Value<DateTime?>? postedAt,
    Value<String>? competenceMonth,
    Value<int>? amountCents,
    Value<String>? currencyCode,
    Value<String>? descriptionRaw,
    Value<String?>? accountId,
    Value<String?>? merchantId,
    Value<String?>? categoryId,
    Value<String?>? costCenterId,
    Value<String?>? payerId,
    Value<double>? sourceConfidence,
    Value<int>? baseVersion,
    Value<int>? serverVersion,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      kind: kind ?? this.kind,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      duplicateStatus: duplicateStatus ?? this.duplicateStatus,
      occurredAt: occurredAt ?? this.occurredAt,
      postedAt: postedAt ?? this.postedAt,
      competenceMonth: competenceMonth ?? this.competenceMonth,
      amountCents: amountCents ?? this.amountCents,
      currencyCode: currencyCode ?? this.currencyCode,
      descriptionRaw: descriptionRaw ?? this.descriptionRaw,
      accountId: accountId ?? this.accountId,
      merchantId: merchantId ?? this.merchantId,
      categoryId: categoryId ?? this.categoryId,
      costCenterId: costCenterId ?? this.costCenterId,
      payerId: payerId ?? this.payerId,
      sourceConfidence: sourceConfidence ?? this.sourceConfidence,
      baseVersion: baseVersion ?? this.baseVersion,
      serverVersion: serverVersion ?? this.serverVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(reviewStatus.value);
    }
    if (duplicateStatus.present) {
      map['duplicate_status'] = Variable<String>(duplicateStatus.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (postedAt.present) {
      map['posted_at'] = Variable<DateTime>(postedAt.value);
    }
    if (competenceMonth.present) {
      map['competence_month'] = Variable<String>(competenceMonth.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (descriptionRaw.present) {
      map['description_raw'] = Variable<String>(descriptionRaw.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (merchantId.present) {
      map['merchant_id'] = Variable<String>(merchantId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (costCenterId.present) {
      map['cost_center_id'] = Variable<String>(costCenterId.value);
    }
    if (payerId.present) {
      map['payer_id'] = Variable<String>(payerId.value);
    }
    if (sourceConfidence.present) {
      map['source_confidence'] = Variable<double>(sourceConfidence.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('kind: $kind, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('duplicateStatus: $duplicateStatus, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('postedAt: $postedAt, ')
          ..write('competenceMonth: $competenceMonth, ')
          ..write('amountCents: $amountCents, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('descriptionRaw: $descriptionRaw, ')
          ..write('accountId: $accountId, ')
          ..write('merchantId: $merchantId, ')
          ..write('categoryId: $categoryId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('payerId: $payerId, ')
          ..write('sourceConfidence: $sourceConfidence, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewInboxTable extends ReviewInbox
    with TableInfo<$ReviewInboxTable, ReviewInboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewInboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    transactionId,
    reason,
    severity,
    createdAt,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_inbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewInboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewInboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewInboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
    );
  }

  @override
  $ReviewInboxTable createAlias(String alias) {
    return $ReviewInboxTable(attachedDatabase, alias);
  }
}

class ReviewInboxRow extends DataClass implements Insertable<ReviewInboxRow> {
  final String id;
  final String householdId;
  final String transactionId;
  final String reason;
  final String severity;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  const ReviewInboxRow({
    required this.id,
    required this.householdId,
    required this.transactionId,
    required this.reason,
    required this.severity,
    required this.createdAt,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['transaction_id'] = Variable<String>(transactionId);
    map['reason'] = Variable<String>(reason);
    map['severity'] = Variable<String>(severity);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  ReviewInboxCompanion toCompanion(bool nullToAbsent) {
    return ReviewInboxCompanion(
      id: Value(id),
      householdId: Value(householdId),
      transactionId: Value(transactionId),
      reason: Value(reason),
      severity: Value(severity),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory ReviewInboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewInboxRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      reason: serializer.fromJson<String>(json['reason']),
      severity: serializer.fromJson<String>(json['severity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'transactionId': serializer.toJson<String>(transactionId),
      'reason': serializer.toJson<String>(reason),
      'severity': serializer.toJson<String>(severity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  ReviewInboxRow copyWith({
    String? id,
    String? householdId,
    String? transactionId,
    String? reason,
    String? severity,
    DateTime? createdAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
  }) => ReviewInboxRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    transactionId: transactionId ?? this.transactionId,
    reason: reason ?? this.reason,
    severity: severity ?? this.severity,
    createdAt: createdAt ?? this.createdAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  ReviewInboxRow copyWithCompanion(ReviewInboxCompanion data) {
    return ReviewInboxRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      reason: data.reason.present ? data.reason.value : this.reason,
      severity: data.severity.present ? data.severity.value : this.severity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewInboxRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('transactionId: $transactionId, ')
          ..write('reason: $reason, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    transactionId,
    reason,
    severity,
    createdAt,
    resolvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewInboxRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.transactionId == this.transactionId &&
          other.reason == this.reason &&
          other.severity == this.severity &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt);
}

class ReviewInboxCompanion extends UpdateCompanion<ReviewInboxRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> transactionId;
  final Value<String> reason;
  final Value<String> severity;
  final Value<DateTime> createdAt;
  final Value<DateTime?> resolvedAt;
  final Value<int> rowid;
  const ReviewInboxCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.reason = const Value.absent(),
    this.severity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewInboxCompanion.insert({
    required String id,
    required String householdId,
    required String transactionId,
    required String reason,
    this.severity = const Value.absent(),
    required DateTime createdAt,
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       transactionId = Value(transactionId),
       reason = Value(reason),
       createdAt = Value(createdAt);
  static Insertable<ReviewInboxRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? transactionId,
    Expression<String>? reason,
    Expression<String>? severity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? resolvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (reason != null) 'reason': reason,
      if (severity != null) 'severity': severity,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewInboxCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? transactionId,
    Value<String>? reason,
    Value<String>? severity,
    Value<DateTime>? createdAt,
    Value<DateTime?>? resolvedAt,
    Value<int>? rowid,
  }) {
    return ReviewInboxCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      transactionId: transactionId ?? this.transactionId,
      reason: reason ?? this.reason,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewInboxCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('transactionId: $transactionId, ')
          ..write('reason: $reason, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionBeneficiariesTable extends TransactionBeneficiaries
    with TableInfo<$TransactionBeneficiariesTable, TransactionBeneficiaryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionBeneficiariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allocationModeMeta = const VerificationMeta(
    'allocationMode',
  );
  @override
  late final GeneratedColumn<String> allocationMode = GeneratedColumn<String>(
    'allocation_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mark_only'),
  );
  static const VerificationMeta _allocatedAmountCentsMeta =
      const VerificationMeta('allocatedAmountCents');
  @override
  late final GeneratedColumn<int> allocatedAmountCents = GeneratedColumn<int>(
    'allocated_amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allocatedPercentMeta = const VerificationMeta(
    'allocatedPercent',
  );
  @override
  late final GeneratedColumn<double> allocatedPercent = GeneratedColumn<double>(
    'allocated_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    personId,
    allocationMode,
    allocatedAmountCents,
    allocatedPercent,
    isPrimary,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_beneficiaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionBeneficiaryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('allocation_mode')) {
      context.handle(
        _allocationModeMeta,
        allocationMode.isAcceptableOrUnknown(
          data['allocation_mode']!,
          _allocationModeMeta,
        ),
      );
    }
    if (data.containsKey('allocated_amount_cents')) {
      context.handle(
        _allocatedAmountCentsMeta,
        allocatedAmountCents.isAcceptableOrUnknown(
          data['allocated_amount_cents']!,
          _allocatedAmountCentsMeta,
        ),
      );
    }
    if (data.containsKey('allocated_percent')) {
      context.handle(
        _allocatedPercentMeta,
        allocatedPercent.isAcceptableOrUnknown(
          data['allocated_percent']!,
          _allocatedPercentMeta,
        ),
      );
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionBeneficiaryRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionBeneficiaryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_id'],
      )!,
      allocationMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allocation_mode'],
      )!,
      allocatedAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allocated_amount_cents'],
      ),
      allocatedPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}allocated_percent'],
      ),
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
    );
  }

  @override
  $TransactionBeneficiariesTable createAlias(String alias) {
    return $TransactionBeneficiariesTable(attachedDatabase, alias);
  }
}

class TransactionBeneficiaryRow extends DataClass
    implements Insertable<TransactionBeneficiaryRow> {
  final String id;
  final String transactionId;
  final String personId;
  final String allocationMode;
  final int? allocatedAmountCents;
  final double? allocatedPercent;
  final bool isPrimary;
  const TransactionBeneficiaryRow({
    required this.id,
    required this.transactionId,
    required this.personId,
    required this.allocationMode,
    this.allocatedAmountCents,
    this.allocatedPercent,
    required this.isPrimary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    map['person_id'] = Variable<String>(personId);
    map['allocation_mode'] = Variable<String>(allocationMode);
    if (!nullToAbsent || allocatedAmountCents != null) {
      map['allocated_amount_cents'] = Variable<int>(allocatedAmountCents);
    }
    if (!nullToAbsent || allocatedPercent != null) {
      map['allocated_percent'] = Variable<double>(allocatedPercent);
    }
    map['is_primary'] = Variable<bool>(isPrimary);
    return map;
  }

  TransactionBeneficiariesCompanion toCompanion(bool nullToAbsent) {
    return TransactionBeneficiariesCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      personId: Value(personId),
      allocationMode: Value(allocationMode),
      allocatedAmountCents: allocatedAmountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(allocatedAmountCents),
      allocatedPercent: allocatedPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(allocatedPercent),
      isPrimary: Value(isPrimary),
    );
  }

  factory TransactionBeneficiaryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionBeneficiaryRow(
      id: serializer.fromJson<String>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      personId: serializer.fromJson<String>(json['personId']),
      allocationMode: serializer.fromJson<String>(json['allocationMode']),
      allocatedAmountCents: serializer.fromJson<int?>(
        json['allocatedAmountCents'],
      ),
      allocatedPercent: serializer.fromJson<double?>(json['allocatedPercent']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'personId': serializer.toJson<String>(personId),
      'allocationMode': serializer.toJson<String>(allocationMode),
      'allocatedAmountCents': serializer.toJson<int?>(allocatedAmountCents),
      'allocatedPercent': serializer.toJson<double?>(allocatedPercent),
      'isPrimary': serializer.toJson<bool>(isPrimary),
    };
  }

  TransactionBeneficiaryRow copyWith({
    String? id,
    String? transactionId,
    String? personId,
    String? allocationMode,
    Value<int?> allocatedAmountCents = const Value.absent(),
    Value<double?> allocatedPercent = const Value.absent(),
    bool? isPrimary,
  }) => TransactionBeneficiaryRow(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    personId: personId ?? this.personId,
    allocationMode: allocationMode ?? this.allocationMode,
    allocatedAmountCents: allocatedAmountCents.present
        ? allocatedAmountCents.value
        : this.allocatedAmountCents,
    allocatedPercent: allocatedPercent.present
        ? allocatedPercent.value
        : this.allocatedPercent,
    isPrimary: isPrimary ?? this.isPrimary,
  );
  TransactionBeneficiaryRow copyWithCompanion(
    TransactionBeneficiariesCompanion data,
  ) {
    return TransactionBeneficiaryRow(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      personId: data.personId.present ? data.personId.value : this.personId,
      allocationMode: data.allocationMode.present
          ? data.allocationMode.value
          : this.allocationMode,
      allocatedAmountCents: data.allocatedAmountCents.present
          ? data.allocatedAmountCents.value
          : this.allocatedAmountCents,
      allocatedPercent: data.allocatedPercent.present
          ? data.allocatedPercent.value
          : this.allocatedPercent,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionBeneficiaryRow(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('personId: $personId, ')
          ..write('allocationMode: $allocationMode, ')
          ..write('allocatedAmountCents: $allocatedAmountCents, ')
          ..write('allocatedPercent: $allocatedPercent, ')
          ..write('isPrimary: $isPrimary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    personId,
    allocationMode,
    allocatedAmountCents,
    allocatedPercent,
    isPrimary,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionBeneficiaryRow &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.personId == this.personId &&
          other.allocationMode == this.allocationMode &&
          other.allocatedAmountCents == this.allocatedAmountCents &&
          other.allocatedPercent == this.allocatedPercent &&
          other.isPrimary == this.isPrimary);
}

class TransactionBeneficiariesCompanion
    extends UpdateCompanion<TransactionBeneficiaryRow> {
  final Value<String> id;
  final Value<String> transactionId;
  final Value<String> personId;
  final Value<String> allocationMode;
  final Value<int?> allocatedAmountCents;
  final Value<double?> allocatedPercent;
  final Value<bool> isPrimary;
  final Value<int> rowid;
  const TransactionBeneficiariesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.personId = const Value.absent(),
    this.allocationMode = const Value.absent(),
    this.allocatedAmountCents = const Value.absent(),
    this.allocatedPercent = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionBeneficiariesCompanion.insert({
    required String id,
    required String transactionId,
    required String personId,
    this.allocationMode = const Value.absent(),
    this.allocatedAmountCents = const Value.absent(),
    this.allocatedPercent = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transactionId = Value(transactionId),
       personId = Value(personId);
  static Insertable<TransactionBeneficiaryRow> custom({
    Expression<String>? id,
    Expression<String>? transactionId,
    Expression<String>? personId,
    Expression<String>? allocationMode,
    Expression<int>? allocatedAmountCents,
    Expression<double>? allocatedPercent,
    Expression<bool>? isPrimary,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (personId != null) 'person_id': personId,
      if (allocationMode != null) 'allocation_mode': allocationMode,
      if (allocatedAmountCents != null)
        'allocated_amount_cents': allocatedAmountCents,
      if (allocatedPercent != null) 'allocated_percent': allocatedPercent,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionBeneficiariesCompanion copyWith({
    Value<String>? id,
    Value<String>? transactionId,
    Value<String>? personId,
    Value<String>? allocationMode,
    Value<int?>? allocatedAmountCents,
    Value<double?>? allocatedPercent,
    Value<bool>? isPrimary,
    Value<int>? rowid,
  }) {
    return TransactionBeneficiariesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      personId: personId ?? this.personId,
      allocationMode: allocationMode ?? this.allocationMode,
      allocatedAmountCents: allocatedAmountCents ?? this.allocatedAmountCents,
      allocatedPercent: allocatedPercent ?? this.allocatedPercent,
      isPrimary: isPrimary ?? this.isPrimary,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (allocationMode.present) {
      map['allocation_mode'] = Variable<String>(allocationMode.value);
    }
    if (allocatedAmountCents.present) {
      map['allocated_amount_cents'] = Variable<int>(allocatedAmountCents.value);
    }
    if (allocatedPercent.present) {
      map['allocated_percent'] = Variable<double>(allocatedPercent.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionBeneficiariesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('personId: $personId, ')
          ..write('allocationMode: $allocationMode, ')
          ..write('allocatedAmountCents: $allocatedAmountCents, ')
          ..write('allocatedPercent: $allocatedPercent, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionSourcesTable extends TransactionSources
    with TableInfo<$TransactionSourcesTable, TransactionSourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceKindMeta = const VerificationMeta(
    'sourceKind',
  );
  @override
  late final GeneratedColumn<String> sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rowHashMeta = const VerificationMeta(
    'rowHash',
  );
  @override
  late final GeneratedColumn<String> rowHash = GeneratedColumn<String>(
    'row_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notificationKeyMeta = const VerificationMeta(
    'notificationKey',
  );
  @override
  late final GeneratedColumn<String> notificationKey = GeneratedColumn<String>(
    'notification_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawPayloadJsonMeta = const VerificationMeta(
    'rawPayloadJson',
  );
  @override
  late final GeneratedColumn<String> rawPayloadJson = GeneratedColumn<String>(
    'raw_payload_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    sourceKind,
    provider,
    externalId,
    fileHash,
    rowHash,
    notificationKey,
    rawPayloadJson,
    occurredAt,
    confidence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionSourceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('source_kind')) {
      context.handle(
        _sourceKindMeta,
        sourceKind.isAcceptableOrUnknown(data['source_kind']!, _sourceKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKindMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    }
    if (data.containsKey('row_hash')) {
      context.handle(
        _rowHashMeta,
        rowHash.isAcceptableOrUnknown(data['row_hash']!, _rowHashMeta),
      );
    }
    if (data.containsKey('notification_key')) {
      context.handle(
        _notificationKeyMeta,
        notificationKey.isAcceptableOrUnknown(
          data['notification_key']!,
          _notificationKeyMeta,
        ),
      );
    }
    if (data.containsKey('raw_payload_json')) {
      context.handle(
        _rawPayloadJsonMeta,
        rawPayloadJson.isAcceptableOrUnknown(
          data['raw_payload_json']!,
          _rawPayloadJsonMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionSourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionSourceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      ),
      rowHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_hash'],
      ),
      notificationKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_key'],
      ),
      rawPayloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_payload_json'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
    );
  }

  @override
  $TransactionSourcesTable createAlias(String alias) {
    return $TransactionSourcesTable(attachedDatabase, alias);
  }
}

class TransactionSourceRow extends DataClass
    implements Insertable<TransactionSourceRow> {
  final String id;
  final String transactionId;
  final String sourceKind;
  final String provider;
  final String? externalId;
  final String? fileHash;
  final String? rowHash;
  final String? notificationKey;
  final String? rawPayloadJson;
  final DateTime? occurredAt;
  final double confidence;
  const TransactionSourceRow({
    required this.id,
    required this.transactionId,
    required this.sourceKind,
    required this.provider,
    this.externalId,
    this.fileHash,
    this.rowHash,
    this.notificationKey,
    this.rawPayloadJson,
    this.occurredAt,
    required this.confidence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    map['source_kind'] = Variable<String>(sourceKind);
    map['provider'] = Variable<String>(provider);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    if (!nullToAbsent || fileHash != null) {
      map['file_hash'] = Variable<String>(fileHash);
    }
    if (!nullToAbsent || rowHash != null) {
      map['row_hash'] = Variable<String>(rowHash);
    }
    if (!nullToAbsent || notificationKey != null) {
      map['notification_key'] = Variable<String>(notificationKey);
    }
    if (!nullToAbsent || rawPayloadJson != null) {
      map['raw_payload_json'] = Variable<String>(rawPayloadJson);
    }
    if (!nullToAbsent || occurredAt != null) {
      map['occurred_at'] = Variable<DateTime>(occurredAt);
    }
    map['confidence'] = Variable<double>(confidence);
    return map;
  }

  TransactionSourcesCompanion toCompanion(bool nullToAbsent) {
    return TransactionSourcesCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      sourceKind: Value(sourceKind),
      provider: Value(provider),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      fileHash: fileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(fileHash),
      rowHash: rowHash == null && nullToAbsent
          ? const Value.absent()
          : Value(rowHash),
      notificationKey: notificationKey == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationKey),
      rawPayloadJson: rawPayloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rawPayloadJson),
      occurredAt: occurredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(occurredAt),
      confidence: Value(confidence),
    );
  }

  factory TransactionSourceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionSourceRow(
      id: serializer.fromJson<String>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
      provider: serializer.fromJson<String>(json['provider']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      fileHash: serializer.fromJson<String?>(json['fileHash']),
      rowHash: serializer.fromJson<String?>(json['rowHash']),
      notificationKey: serializer.fromJson<String?>(json['notificationKey']),
      rawPayloadJson: serializer.fromJson<String?>(json['rawPayloadJson']),
      occurredAt: serializer.fromJson<DateTime?>(json['occurredAt']),
      confidence: serializer.fromJson<double>(json['confidence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'sourceKind': serializer.toJson<String>(sourceKind),
      'provider': serializer.toJson<String>(provider),
      'externalId': serializer.toJson<String?>(externalId),
      'fileHash': serializer.toJson<String?>(fileHash),
      'rowHash': serializer.toJson<String?>(rowHash),
      'notificationKey': serializer.toJson<String?>(notificationKey),
      'rawPayloadJson': serializer.toJson<String?>(rawPayloadJson),
      'occurredAt': serializer.toJson<DateTime?>(occurredAt),
      'confidence': serializer.toJson<double>(confidence),
    };
  }

  TransactionSourceRow copyWith({
    String? id,
    String? transactionId,
    String? sourceKind,
    String? provider,
    Value<String?> externalId = const Value.absent(),
    Value<String?> fileHash = const Value.absent(),
    Value<String?> rowHash = const Value.absent(),
    Value<String?> notificationKey = const Value.absent(),
    Value<String?> rawPayloadJson = const Value.absent(),
    Value<DateTime?> occurredAt = const Value.absent(),
    double? confidence,
  }) => TransactionSourceRow(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    sourceKind: sourceKind ?? this.sourceKind,
    provider: provider ?? this.provider,
    externalId: externalId.present ? externalId.value : this.externalId,
    fileHash: fileHash.present ? fileHash.value : this.fileHash,
    rowHash: rowHash.present ? rowHash.value : this.rowHash,
    notificationKey: notificationKey.present
        ? notificationKey.value
        : this.notificationKey,
    rawPayloadJson: rawPayloadJson.present
        ? rawPayloadJson.value
        : this.rawPayloadJson,
    occurredAt: occurredAt.present ? occurredAt.value : this.occurredAt,
    confidence: confidence ?? this.confidence,
  );
  TransactionSourceRow copyWithCompanion(TransactionSourcesCompanion data) {
    return TransactionSourceRow(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      provider: data.provider.present ? data.provider.value : this.provider,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      rowHash: data.rowHash.present ? data.rowHash.value : this.rowHash,
      notificationKey: data.notificationKey.present
          ? data.notificationKey.value
          : this.notificationKey,
      rawPayloadJson: data.rawPayloadJson.present
          ? data.rawPayloadJson.value
          : this.rawPayloadJson,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSourceRow(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('provider: $provider, ')
          ..write('externalId: $externalId, ')
          ..write('fileHash: $fileHash, ')
          ..write('rowHash: $rowHash, ')
          ..write('notificationKey: $notificationKey, ')
          ..write('rawPayloadJson: $rawPayloadJson, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('confidence: $confidence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    sourceKind,
    provider,
    externalId,
    fileHash,
    rowHash,
    notificationKey,
    rawPayloadJson,
    occurredAt,
    confidence,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionSourceRow &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.sourceKind == this.sourceKind &&
          other.provider == this.provider &&
          other.externalId == this.externalId &&
          other.fileHash == this.fileHash &&
          other.rowHash == this.rowHash &&
          other.notificationKey == this.notificationKey &&
          other.rawPayloadJson == this.rawPayloadJson &&
          other.occurredAt == this.occurredAt &&
          other.confidence == this.confidence);
}

class TransactionSourcesCompanion
    extends UpdateCompanion<TransactionSourceRow> {
  final Value<String> id;
  final Value<String> transactionId;
  final Value<String> sourceKind;
  final Value<String> provider;
  final Value<String?> externalId;
  final Value<String?> fileHash;
  final Value<String?> rowHash;
  final Value<String?> notificationKey;
  final Value<String?> rawPayloadJson;
  final Value<DateTime?> occurredAt;
  final Value<double> confidence;
  final Value<int> rowid;
  const TransactionSourcesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.provider = const Value.absent(),
    this.externalId = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.rowHash = const Value.absent(),
    this.notificationKey = const Value.absent(),
    this.rawPayloadJson = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.confidence = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionSourcesCompanion.insert({
    required String id,
    required String transactionId,
    required String sourceKind,
    required String provider,
    this.externalId = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.rowHash = const Value.absent(),
    this.notificationKey = const Value.absent(),
    this.rawPayloadJson = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.confidence = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transactionId = Value(transactionId),
       sourceKind = Value(sourceKind),
       provider = Value(provider);
  static Insertable<TransactionSourceRow> custom({
    Expression<String>? id,
    Expression<String>? transactionId,
    Expression<String>? sourceKind,
    Expression<String>? provider,
    Expression<String>? externalId,
    Expression<String>? fileHash,
    Expression<String>? rowHash,
    Expression<String>? notificationKey,
    Expression<String>? rawPayloadJson,
    Expression<DateTime>? occurredAt,
    Expression<double>? confidence,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (provider != null) 'provider': provider,
      if (externalId != null) 'external_id': externalId,
      if (fileHash != null) 'file_hash': fileHash,
      if (rowHash != null) 'row_hash': rowHash,
      if (notificationKey != null) 'notification_key': notificationKey,
      if (rawPayloadJson != null) 'raw_payload_json': rawPayloadJson,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (confidence != null) 'confidence': confidence,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionSourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? transactionId,
    Value<String>? sourceKind,
    Value<String>? provider,
    Value<String?>? externalId,
    Value<String?>? fileHash,
    Value<String?>? rowHash,
    Value<String?>? notificationKey,
    Value<String?>? rawPayloadJson,
    Value<DateTime?>? occurredAt,
    Value<double>? confidence,
    Value<int>? rowid,
  }) {
    return TransactionSourcesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      sourceKind: sourceKind ?? this.sourceKind,
      provider: provider ?? this.provider,
      externalId: externalId ?? this.externalId,
      fileHash: fileHash ?? this.fileHash,
      rowHash: rowHash ?? this.rowHash,
      notificationKey: notificationKey ?? this.notificationKey,
      rawPayloadJson: rawPayloadJson ?? this.rawPayloadJson,
      occurredAt: occurredAt ?? this.occurredAt,
      confidence: confidence ?? this.confidence,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (rowHash.present) {
      map['row_hash'] = Variable<String>(rowHash.value);
    }
    if (notificationKey.present) {
      map['notification_key'] = Variable<String>(notificationKey.value);
    }
    if (rawPayloadJson.present) {
      map['raw_payload_json'] = Variable<String>(rawPayloadJson.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSourcesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('provider: $provider, ')
          ..write('externalId: $externalId, ')
          ..write('fileHash: $fileHash, ')
          ..write('rowHash: $rowHash, ')
          ..write('notificationKey: $notificationKey, ')
          ..write('rawPayloadJson: $rawPayloadJson, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('confidence: $confidence, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _opIdMeta = const VerificationMeta('opId');
  @override
  late final GeneratedColumn<String> opId = GeneratedColumn<String>(
    'op_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseVersionMeta = const VerificationMeta(
    'baseVersion',
  );
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
    'base_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ackAtMeta = const VerificationMeta('ackAt');
  @override
  late final GeneratedColumn<DateTime> ackAt = GeneratedColumn<DateTime>(
    'ack_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    opId,
    deviceId,
    householdId,
    entityType,
    entityId,
    operationType,
    baseVersion,
    payloadJson,
    createdAt,
    sentAt,
    ackAt,
    status,
    retryCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('op_id')) {
      context.handle(
        _opIdMeta,
        opId.isAcceptableOrUnknown(data['op_id']!, _opIdMeta),
      );
    } else if (isInserting) {
      context.missing(_opIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('base_version')) {
      context.handle(
        _baseVersionMeta,
        baseVersion.isAcceptableOrUnknown(
          data['base_version']!,
          _baseVersionMeta,
        ),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    }
    if (data.containsKey('ack_at')) {
      context.handle(
        _ackAtMeta,
        ackAt.isAcceptableOrUnknown(data['ack_at']!, _ackAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {opId};
  @override
  SyncOutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxRow(
      opId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      baseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_version'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      ),
      ackAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ack_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxRow extends DataClass implements Insertable<SyncOutboxRow> {
  final String opId;
  final String deviceId;
  final String householdId;
  final String entityType;
  final String entityId;
  final String operationType;
  final int baseVersion;
  final String payloadJson;
  final DateTime createdAt;
  final DateTime? sentAt;
  final DateTime? ackAt;
  final String status;
  final int retryCount;
  const SyncOutboxRow({
    required this.opId,
    required this.deviceId,
    required this.householdId,
    required this.entityType,
    required this.entityId,
    required this.operationType,
    required this.baseVersion,
    required this.payloadJson,
    required this.createdAt,
    this.sentAt,
    this.ackAt,
    required this.status,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['op_id'] = Variable<String>(opId);
    map['device_id'] = Variable<String>(deviceId);
    map['household_id'] = Variable<String>(householdId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation_type'] = Variable<String>(operationType);
    map['base_version'] = Variable<int>(baseVersion);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    if (!nullToAbsent || ackAt != null) {
      map['ack_at'] = Variable<DateTime>(ackAt);
    }
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      opId: Value(opId),
      deviceId: Value(deviceId),
      householdId: Value(householdId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operationType: Value(operationType),
      baseVersion: Value(baseVersion),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      sentAt: sentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentAt),
      ackAt: ackAt == null && nullToAbsent
          ? const Value.absent()
          : Value(ackAt),
      status: Value(status),
      retryCount: Value(retryCount),
    );
  }

  factory SyncOutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxRow(
      opId: serializer.fromJson<String>(json['opId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      householdId: serializer.fromJson<String>(json['householdId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      baseVersion: serializer.fromJson<int>(json['baseVersion']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      ackAt: serializer.fromJson<DateTime?>(json['ackAt']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'opId': serializer.toJson<String>(opId),
      'deviceId': serializer.toJson<String>(deviceId),
      'householdId': serializer.toJson<String>(householdId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operationType': serializer.toJson<String>(operationType),
      'baseVersion': serializer.toJson<int>(baseVersion),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'ackAt': serializer.toJson<DateTime?>(ackAt),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  SyncOutboxRow copyWith({
    String? opId,
    String? deviceId,
    String? householdId,
    String? entityType,
    String? entityId,
    String? operationType,
    int? baseVersion,
    String? payloadJson,
    DateTime? createdAt,
    Value<DateTime?> sentAt = const Value.absent(),
    Value<DateTime?> ackAt = const Value.absent(),
    String? status,
    int? retryCount,
  }) => SyncOutboxRow(
    opId: opId ?? this.opId,
    deviceId: deviceId ?? this.deviceId,
    householdId: householdId ?? this.householdId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operationType: operationType ?? this.operationType,
    baseVersion: baseVersion ?? this.baseVersion,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    sentAt: sentAt.present ? sentAt.value : this.sentAt,
    ackAt: ackAt.present ? ackAt.value : this.ackAt,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
  );
  SyncOutboxRow copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxRow(
      opId: data.opId.present ? data.opId.value : this.opId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      baseVersion: data.baseVersion.present
          ? data.baseVersion.value
          : this.baseVersion,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      ackAt: data.ackAt.present ? data.ackAt.value : this.ackAt,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxRow(')
          ..write('opId: $opId, ')
          ..write('deviceId: $deviceId, ')
          ..write('householdId: $householdId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operationType: $operationType, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('sentAt: $sentAt, ')
          ..write('ackAt: $ackAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    opId,
    deviceId,
    householdId,
    entityType,
    entityId,
    operationType,
    baseVersion,
    payloadJson,
    createdAt,
    sentAt,
    ackAt,
    status,
    retryCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxRow &&
          other.opId == this.opId &&
          other.deviceId == this.deviceId &&
          other.householdId == this.householdId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operationType == this.operationType &&
          other.baseVersion == this.baseVersion &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.sentAt == this.sentAt &&
          other.ackAt == this.ackAt &&
          other.status == this.status &&
          other.retryCount == this.retryCount);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxRow> {
  final Value<String> opId;
  final Value<String> deviceId;
  final Value<String> householdId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operationType;
  final Value<int> baseVersion;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<DateTime?> sentAt;
  final Value<DateTime?> ackAt;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.opId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.householdId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.ackAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String opId,
    required String deviceId,
    required String householdId,
    required String entityType,
    required String entityId,
    required String operationType,
    this.baseVersion = const Value.absent(),
    required String payloadJson,
    required DateTime createdAt,
    this.sentAt = const Value.absent(),
    this.ackAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : opId = Value(opId),
       deviceId = Value(deviceId),
       householdId = Value(householdId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operationType = Value(operationType),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<SyncOutboxRow> custom({
    Expression<String>? opId,
    Expression<String>? deviceId,
    Expression<String>? householdId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operationType,
    Expression<int>? baseVersion,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? sentAt,
    Expression<DateTime>? ackAt,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opId != null) 'op_id': opId,
      if (deviceId != null) 'device_id': deviceId,
      if (householdId != null) 'household_id': householdId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operationType != null) 'operation_type': operationType,
      if (baseVersion != null) 'base_version': baseVersion,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (sentAt != null) 'sent_at': sentAt,
      if (ackAt != null) 'ack_at': ackAt,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? opId,
    Value<String>? deviceId,
    Value<String>? householdId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operationType,
    Value<int>? baseVersion,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<DateTime?>? sentAt,
    Value<DateTime?>? ackAt,
    Value<String>? status,
    Value<int>? retryCount,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      opId: opId ?? this.opId,
      deviceId: deviceId ?? this.deviceId,
      householdId: householdId ?? this.householdId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operationType: operationType ?? this.operationType,
      baseVersion: baseVersion ?? this.baseVersion,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
      ackAt: ackAt ?? this.ackAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (opId.present) {
      map['op_id'] = Variable<String>(opId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (ackAt.present) {
      map['ack_at'] = Variable<DateTime>(ackAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('opId: $opId, ')
          ..write('deviceId: $deviceId, ')
          ..write('householdId: $householdId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operationType: $operationType, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('sentAt: $sentAt, ')
          ..write('ackAt: $ackAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PeopleTable people = $PeopleTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CreditCardsTable creditCards = $CreditCardsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $CostCentersTable costCenters = $CostCentersTable(this);
  late final $MerchantsTable merchants = $MerchantsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $ReviewInboxTable reviewInbox = $ReviewInboxTable(this);
  late final $TransactionBeneficiariesTable transactionBeneficiaries =
      $TransactionBeneficiariesTable(this);
  late final $TransactionSourcesTable transactionSources =
      $TransactionSourcesTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    people,
    accounts,
    creditCards,
    categories,
    costCenters,
    merchants,
    transactions,
    reviewInbox,
    transactionBeneficiaries,
    transactionSources,
    syncOutbox,
  ];
}

typedef $$PeopleTableCreateCompanionBuilder =
    PeopleCompanion Function({
      required String id,
      required String householdId,
      required String displayName,
      required String kind,
      Value<bool> active,
      Value<int> rowid,
    });
typedef $$PeopleTableUpdateCompanionBuilder =
    PeopleCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> displayName,
      Value<String> kind,
      Value<bool> active,
      Value<int> rowid,
    });

class $$PeopleTableFilterComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PeopleTableOrderingComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PeopleTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$PeopleTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeopleTable,
          PersonRow,
          $$PeopleTableFilterComposer,
          $$PeopleTableOrderingComposer,
          $$PeopleTableAnnotationComposer,
          $$PeopleTableCreateCompanionBuilder,
          $$PeopleTableUpdateCompanionBuilder,
          (PersonRow, BaseReferences<_$AppDatabase, $PeopleTable, PersonRow>),
          PersonRow,
          PrefetchHooks Function()
        > {
  $$PeopleTableTableManager(_$AppDatabase db, $PeopleTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeopleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeopleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeopleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PeopleCompanion(
                id: id,
                householdId: householdId,
                displayName: displayName,
                kind: kind,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String displayName,
                required String kind,
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PeopleCompanion.insert(
                id: id,
                householdId: householdId,
                displayName: displayName,
                kind: kind,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PeopleTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeopleTable,
      PersonRow,
      $$PeopleTableFilterComposer,
      $$PeopleTableOrderingComposer,
      $$PeopleTableAnnotationComposer,
      $$PeopleTableCreateCompanionBuilder,
      $$PeopleTableUpdateCompanionBuilder,
      (PersonRow, BaseReferences<_$AppDatabase, $PeopleTable, PersonRow>),
      PersonRow,
      PrefetchHooks Function()
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      required String id,
      required String householdId,
      required String provider,
      required String name,
      required String type,
      Value<String> currencyCode,
      Value<String?> last4,
      Value<bool> active,
      Value<int> rowid,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> provider,
      Value<String> name,
      Value<String> type,
      Value<String> currencyCode,
      Value<String?> last4,
      Value<bool> active,
      Value<int> rowid,
    });

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          AccountRow,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (
            AccountRow,
            BaseReferences<_$AppDatabase, $AccountsTable, AccountRow>,
          ),
          AccountRow,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                householdId: householdId,
                provider: provider,
                name: name,
                type: type,
                currencyCode: currencyCode,
                last4: last4,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String provider,
                required String name,
                required String type,
                Value<String> currencyCode = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                householdId: householdId,
                provider: provider,
                name: name,
                type: type,
                currencyCode: currencyCode,
                last4: last4,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      AccountRow,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (AccountRow, BaseReferences<_$AppDatabase, $AccountsTable, AccountRow>),
      AccountRow,
      PrefetchHooks Function()
    >;
typedef $$CreditCardsTableCreateCompanionBuilder =
    CreditCardsCompanion Function({
      required String id,
      required String householdId,
      required String provider,
      required String name,
      Value<String?> brand,
      Value<String?> last4,
      Value<int?> billingDay,
      Value<int?> dueDay,
      Value<bool> active,
      Value<int> rowid,
    });
typedef $$CreditCardsTableUpdateCompanionBuilder =
    CreditCardsCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> provider,
      Value<String> name,
      Value<String?> brand,
      Value<String?> last4,
      Value<int?> billingDay,
      Value<int?> dueDay,
      Value<bool> active,
      Value<int> rowid,
    });

class $$CreditCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get billingDay => $composableBuilder(
    column: $table.billingDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CreditCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get billingDay => $composableBuilder(
    column: $table.billingDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CreditCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumn<int> get billingDay => $composableBuilder(
    column: $table.billingDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$CreditCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditCardsTable,
          CreditCardRow,
          $$CreditCardsTableFilterComposer,
          $$CreditCardsTableOrderingComposer,
          $$CreditCardsTableAnnotationComposer,
          $$CreditCardsTableCreateCompanionBuilder,
          $$CreditCardsTableUpdateCompanionBuilder,
          (
            CreditCardRow,
            BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCardRow>,
          ),
          CreditCardRow,
          PrefetchHooks Function()
        > {
  $$CreditCardsTableTableManager(_$AppDatabase db, $CreditCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<int?> billingDay = const Value.absent(),
                Value<int?> dueDay = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CreditCardsCompanion(
                id: id,
                householdId: householdId,
                provider: provider,
                name: name,
                brand: brand,
                last4: last4,
                billingDay: billingDay,
                dueDay: dueDay,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String provider,
                required String name,
                Value<String?> brand = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<int?> billingDay = const Value.absent(),
                Value<int?> dueDay = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CreditCardsCompanion.insert(
                id: id,
                householdId: householdId,
                provider: provider,
                name: name,
                brand: brand,
                last4: last4,
                billingDay: billingDay,
                dueDay: dueDay,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CreditCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditCardsTable,
      CreditCardRow,
      $$CreditCardsTableFilterComposer,
      $$CreditCardsTableOrderingComposer,
      $$CreditCardsTableAnnotationComposer,
      $$CreditCardsTableCreateCompanionBuilder,
      $$CreditCardsTableUpdateCompanionBuilder,
      (
        CreditCardRow,
        BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCardRow>,
      ),
      CreditCardRow,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String householdId,
      Value<String?> parentId,
      required String name,
      required String kind,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String?> parentId,
      Value<String> name,
      Value<String> kind,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (
            CategoryRow,
            BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>,
          ),
          CategoryRow,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                householdId: householdId,
                parentId: parentId,
                name: name,
                kind: kind,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                Value<String?> parentId = const Value.absent(),
                required String name,
                required String kind,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                householdId: householdId,
                parentId: parentId,
                name: name,
                kind: kind,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (
        CategoryRow,
        BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>,
      ),
      CategoryRow,
      PrefetchHooks Function()
    >;
typedef $$CostCentersTableCreateCompanionBuilder =
    CostCentersCompanion Function({
      required String id,
      required String householdId,
      required String name,
      Value<bool> active,
      Value<int> rowid,
    });
typedef $$CostCentersTableUpdateCompanionBuilder =
    CostCentersCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> name,
      Value<bool> active,
      Value<int> rowid,
    });

class $$CostCentersTableFilterComposer
    extends Composer<_$AppDatabase, $CostCentersTable> {
  $$CostCentersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CostCentersTableOrderingComposer
    extends Composer<_$AppDatabase, $CostCentersTable> {
  $$CostCentersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CostCentersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CostCentersTable> {
  $$CostCentersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$CostCentersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CostCentersTable,
          CostCenterRow,
          $$CostCentersTableFilterComposer,
          $$CostCentersTableOrderingComposer,
          $$CostCentersTableAnnotationComposer,
          $$CostCentersTableCreateCompanionBuilder,
          $$CostCentersTableUpdateCompanionBuilder,
          (
            CostCenterRow,
            BaseReferences<_$AppDatabase, $CostCentersTable, CostCenterRow>,
          ),
          CostCenterRow,
          PrefetchHooks Function()
        > {
  $$CostCentersTableTableManager(_$AppDatabase db, $CostCentersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CostCentersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CostCentersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CostCentersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CostCentersCompanion(
                id: id,
                householdId: householdId,
                name: name,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String name,
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CostCentersCompanion.insert(
                id: id,
                householdId: householdId,
                name: name,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CostCentersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CostCentersTable,
      CostCenterRow,
      $$CostCentersTableFilterComposer,
      $$CostCentersTableOrderingComposer,
      $$CostCentersTableAnnotationComposer,
      $$CostCentersTableCreateCompanionBuilder,
      $$CostCentersTableUpdateCompanionBuilder,
      (
        CostCenterRow,
        BaseReferences<_$AppDatabase, $CostCentersTable, CostCenterRow>,
      ),
      CostCenterRow,
      PrefetchHooks Function()
    >;
typedef $$MerchantsTableCreateCompanionBuilder =
    MerchantsCompanion Function({
      required String id,
      required String householdId,
      required String normalizedName,
      required String displayName,
      Value<String?> providerHintsJson,
      Value<int> rowid,
    });
typedef $$MerchantsTableUpdateCompanionBuilder =
    MerchantsCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> normalizedName,
      Value<String> displayName,
      Value<String?> providerHintsJson,
      Value<int> rowid,
    });

class $$MerchantsTableFilterComposer
    extends Composer<_$AppDatabase, $MerchantsTable> {
  $$MerchantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerHintsJson => $composableBuilder(
    column: $table.providerHintsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MerchantsTableOrderingComposer
    extends Composer<_$AppDatabase, $MerchantsTable> {
  $$MerchantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerHintsJson => $composableBuilder(
    column: $table.providerHintsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MerchantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MerchantsTable> {
  $$MerchantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerHintsJson => $composableBuilder(
    column: $table.providerHintsJson,
    builder: (column) => column,
  );
}

class $$MerchantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MerchantsTable,
          MerchantRow,
          $$MerchantsTableFilterComposer,
          $$MerchantsTableOrderingComposer,
          $$MerchantsTableAnnotationComposer,
          $$MerchantsTableCreateCompanionBuilder,
          $$MerchantsTableUpdateCompanionBuilder,
          (
            MerchantRow,
            BaseReferences<_$AppDatabase, $MerchantsTable, MerchantRow>,
          ),
          MerchantRow,
          PrefetchHooks Function()
        > {
  $$MerchantsTableTableManager(_$AppDatabase db, $MerchantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MerchantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MerchantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MerchantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> normalizedName = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> providerHintsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MerchantsCompanion(
                id: id,
                householdId: householdId,
                normalizedName: normalizedName,
                displayName: displayName,
                providerHintsJson: providerHintsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String normalizedName,
                required String displayName,
                Value<String?> providerHintsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MerchantsCompanion.insert(
                id: id,
                householdId: householdId,
                normalizedName: normalizedName,
                displayName: displayName,
                providerHintsJson: providerHintsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MerchantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MerchantsTable,
      MerchantRow,
      $$MerchantsTableFilterComposer,
      $$MerchantsTableOrderingComposer,
      $$MerchantsTableAnnotationComposer,
      $$MerchantsTableCreateCompanionBuilder,
      $$MerchantsTableUpdateCompanionBuilder,
      (
        MerchantRow,
        BaseReferences<_$AppDatabase, $MerchantsTable, MerchantRow>,
      ),
      MerchantRow,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required String householdId,
      required String kind,
      required String reviewStatus,
      required String duplicateStatus,
      required DateTime occurredAt,
      Value<DateTime?> postedAt,
      required String competenceMonth,
      required int amountCents,
      Value<String> currencyCode,
      required String descriptionRaw,
      Value<String?> accountId,
      Value<String?> merchantId,
      Value<String?> categoryId,
      Value<String?> costCenterId,
      Value<String?> payerId,
      Value<double> sourceConfidence,
      Value<int> baseVersion,
      Value<int> serverVersion,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> kind,
      Value<String> reviewStatus,
      Value<String> duplicateStatus,
      Value<DateTime> occurredAt,
      Value<DateTime?> postedAt,
      Value<String> competenceMonth,
      Value<int> amountCents,
      Value<String> currencyCode,
      Value<String> descriptionRaw,
      Value<String?> accountId,
      Value<String?> merchantId,
      Value<String?> categoryId,
      Value<String?> costCenterId,
      Value<String?> payerId,
      Value<double> sourceConfidence,
      Value<int> baseVersion,
      Value<int> serverVersion,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duplicateStatus => $composableBuilder(
    column: $table.duplicateStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get postedAt => $composableBuilder(
    column: $table.postedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get competenceMonth => $composableBuilder(
    column: $table.competenceMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionRaw => $composableBuilder(
    column: $table.descriptionRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantId => $composableBuilder(
    column: $table.merchantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get costCenterId => $composableBuilder(
    column: $table.costCenterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payerId => $composableBuilder(
    column: $table.payerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sourceConfidence => $composableBuilder(
    column: $table.sourceConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duplicateStatus => $composableBuilder(
    column: $table.duplicateStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get postedAt => $composableBuilder(
    column: $table.postedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get competenceMonth => $composableBuilder(
    column: $table.competenceMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionRaw => $composableBuilder(
    column: $table.descriptionRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantId => $composableBuilder(
    column: $table.merchantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get costCenterId => $composableBuilder(
    column: $table.costCenterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payerId => $composableBuilder(
    column: $table.payerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sourceConfidence => $composableBuilder(
    column: $table.sourceConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get duplicateStatus => $composableBuilder(
    column: $table.duplicateStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get postedAt =>
      $composableBuilder(column: $table.postedAt, builder: (column) => column);

  GeneratedColumn<String> get competenceMonth => $composableBuilder(
    column: $table.competenceMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionRaw => $composableBuilder(
    column: $table.descriptionRaw,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get merchantId => $composableBuilder(
    column: $table.merchantId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get costCenterId => $composableBuilder(
    column: $table.costCenterId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payerId =>
      $composableBuilder(column: $table.payerId, builder: (column) => column);

  GeneratedColumn<double> get sourceConfidence => $composableBuilder(
    column: $table.sourceConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          FinanceTransaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            FinanceTransaction,
            BaseReferences<
              _$AppDatabase,
              $TransactionsTable,
              FinanceTransaction
            >,
          ),
          FinanceTransaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<String> duplicateStatus = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime?> postedAt = const Value.absent(),
                Value<String> competenceMonth = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> descriptionRaw = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String?> merchantId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> costCenterId = const Value.absent(),
                Value<String?> payerId = const Value.absent(),
                Value<double> sourceConfidence = const Value.absent(),
                Value<int> baseVersion = const Value.absent(),
                Value<int> serverVersion = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                householdId: householdId,
                kind: kind,
                reviewStatus: reviewStatus,
                duplicateStatus: duplicateStatus,
                occurredAt: occurredAt,
                postedAt: postedAt,
                competenceMonth: competenceMonth,
                amountCents: amountCents,
                currencyCode: currencyCode,
                descriptionRaw: descriptionRaw,
                accountId: accountId,
                merchantId: merchantId,
                categoryId: categoryId,
                costCenterId: costCenterId,
                payerId: payerId,
                sourceConfidence: sourceConfidence,
                baseVersion: baseVersion,
                serverVersion: serverVersion,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String kind,
                required String reviewStatus,
                required String duplicateStatus,
                required DateTime occurredAt,
                Value<DateTime?> postedAt = const Value.absent(),
                required String competenceMonth,
                required int amountCents,
                Value<String> currencyCode = const Value.absent(),
                required String descriptionRaw,
                Value<String?> accountId = const Value.absent(),
                Value<String?> merchantId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> costCenterId = const Value.absent(),
                Value<String?> payerId = const Value.absent(),
                Value<double> sourceConfidence = const Value.absent(),
                Value<int> baseVersion = const Value.absent(),
                Value<int> serverVersion = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                householdId: householdId,
                kind: kind,
                reviewStatus: reviewStatus,
                duplicateStatus: duplicateStatus,
                occurredAt: occurredAt,
                postedAt: postedAt,
                competenceMonth: competenceMonth,
                amountCents: amountCents,
                currencyCode: currencyCode,
                descriptionRaw: descriptionRaw,
                accountId: accountId,
                merchantId: merchantId,
                categoryId: categoryId,
                costCenterId: costCenterId,
                payerId: payerId,
                sourceConfidence: sourceConfidence,
                baseVersion: baseVersion,
                serverVersion: serverVersion,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      FinanceTransaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        FinanceTransaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, FinanceTransaction>,
      ),
      FinanceTransaction,
      PrefetchHooks Function()
    >;
typedef $$ReviewInboxTableCreateCompanionBuilder =
    ReviewInboxCompanion Function({
      required String id,
      required String householdId,
      required String transactionId,
      required String reason,
      Value<String> severity,
      required DateTime createdAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });
typedef $$ReviewInboxTableUpdateCompanionBuilder =
    ReviewInboxCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> transactionId,
      Value<String> reason,
      Value<String> severity,
      Value<DateTime> createdAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });

class $$ReviewInboxTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewInboxTable> {
  $$ReviewInboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewInboxTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewInboxTable> {
  $$ReviewInboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewInboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewInboxTable> {
  $$ReviewInboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );
}

class $$ReviewInboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewInboxTable,
          ReviewInboxRow,
          $$ReviewInboxTableFilterComposer,
          $$ReviewInboxTableOrderingComposer,
          $$ReviewInboxTableAnnotationComposer,
          $$ReviewInboxTableCreateCompanionBuilder,
          $$ReviewInboxTableUpdateCompanionBuilder,
          (
            ReviewInboxRow,
            BaseReferences<_$AppDatabase, $ReviewInboxTable, ReviewInboxRow>,
          ),
          ReviewInboxRow,
          PrefetchHooks Function()
        > {
  $$ReviewInboxTableTableManager(_$AppDatabase db, $ReviewInboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewInboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewInboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewInboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewInboxCompanion(
                id: id,
                householdId: householdId,
                transactionId: transactionId,
                reason: reason,
                severity: severity,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String transactionId,
                required String reason,
                Value<String> severity = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewInboxCompanion.insert(
                id: id,
                householdId: householdId,
                transactionId: transactionId,
                reason: reason,
                severity: severity,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewInboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewInboxTable,
      ReviewInboxRow,
      $$ReviewInboxTableFilterComposer,
      $$ReviewInboxTableOrderingComposer,
      $$ReviewInboxTableAnnotationComposer,
      $$ReviewInboxTableCreateCompanionBuilder,
      $$ReviewInboxTableUpdateCompanionBuilder,
      (
        ReviewInboxRow,
        BaseReferences<_$AppDatabase, $ReviewInboxTable, ReviewInboxRow>,
      ),
      ReviewInboxRow,
      PrefetchHooks Function()
    >;
typedef $$TransactionBeneficiariesTableCreateCompanionBuilder =
    TransactionBeneficiariesCompanion Function({
      required String id,
      required String transactionId,
      required String personId,
      Value<String> allocationMode,
      Value<int?> allocatedAmountCents,
      Value<double?> allocatedPercent,
      Value<bool> isPrimary,
      Value<int> rowid,
    });
typedef $$TransactionBeneficiariesTableUpdateCompanionBuilder =
    TransactionBeneficiariesCompanion Function({
      Value<String> id,
      Value<String> transactionId,
      Value<String> personId,
      Value<String> allocationMode,
      Value<int?> allocatedAmountCents,
      Value<double?> allocatedPercent,
      Value<bool> isPrimary,
      Value<int> rowid,
    });

class $$TransactionBeneficiariesTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionBeneficiariesTable> {
  $$TransactionBeneficiariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personId => $composableBuilder(
    column: $table.personId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allocationMode => $composableBuilder(
    column: $table.allocationMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allocatedAmountCents => $composableBuilder(
    column: $table.allocatedAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get allocatedPercent => $composableBuilder(
    column: $table.allocatedPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionBeneficiariesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionBeneficiariesTable> {
  $$TransactionBeneficiariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personId => $composableBuilder(
    column: $table.personId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allocationMode => $composableBuilder(
    column: $table.allocationMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allocatedAmountCents => $composableBuilder(
    column: $table.allocatedAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get allocatedPercent => $composableBuilder(
    column: $table.allocatedPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionBeneficiariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionBeneficiariesTable> {
  $$TransactionBeneficiariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get allocationMode => $composableBuilder(
    column: $table.allocationMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allocatedAmountCents => $composableBuilder(
    column: $table.allocatedAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<double> get allocatedPercent => $composableBuilder(
    column: $table.allocatedPercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);
}

class $$TransactionBeneficiariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionBeneficiariesTable,
          TransactionBeneficiaryRow,
          $$TransactionBeneficiariesTableFilterComposer,
          $$TransactionBeneficiariesTableOrderingComposer,
          $$TransactionBeneficiariesTableAnnotationComposer,
          $$TransactionBeneficiariesTableCreateCompanionBuilder,
          $$TransactionBeneficiariesTableUpdateCompanionBuilder,
          (
            TransactionBeneficiaryRow,
            BaseReferences<
              _$AppDatabase,
              $TransactionBeneficiariesTable,
              TransactionBeneficiaryRow
            >,
          ),
          TransactionBeneficiaryRow,
          PrefetchHooks Function()
        > {
  $$TransactionBeneficiariesTableTableManager(
    _$AppDatabase db,
    $TransactionBeneficiariesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionBeneficiariesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TransactionBeneficiariesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransactionBeneficiariesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> personId = const Value.absent(),
                Value<String> allocationMode = const Value.absent(),
                Value<int?> allocatedAmountCents = const Value.absent(),
                Value<double?> allocatedPercent = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionBeneficiariesCompanion(
                id: id,
                transactionId: transactionId,
                personId: personId,
                allocationMode: allocationMode,
                allocatedAmountCents: allocatedAmountCents,
                allocatedPercent: allocatedPercent,
                isPrimary: isPrimary,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transactionId,
                required String personId,
                Value<String> allocationMode = const Value.absent(),
                Value<int?> allocatedAmountCents = const Value.absent(),
                Value<double?> allocatedPercent = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionBeneficiariesCompanion.insert(
                id: id,
                transactionId: transactionId,
                personId: personId,
                allocationMode: allocationMode,
                allocatedAmountCents: allocatedAmountCents,
                allocatedPercent: allocatedPercent,
                isPrimary: isPrimary,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionBeneficiariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionBeneficiariesTable,
      TransactionBeneficiaryRow,
      $$TransactionBeneficiariesTableFilterComposer,
      $$TransactionBeneficiariesTableOrderingComposer,
      $$TransactionBeneficiariesTableAnnotationComposer,
      $$TransactionBeneficiariesTableCreateCompanionBuilder,
      $$TransactionBeneficiariesTableUpdateCompanionBuilder,
      (
        TransactionBeneficiaryRow,
        BaseReferences<
          _$AppDatabase,
          $TransactionBeneficiariesTable,
          TransactionBeneficiaryRow
        >,
      ),
      TransactionBeneficiaryRow,
      PrefetchHooks Function()
    >;
typedef $$TransactionSourcesTableCreateCompanionBuilder =
    TransactionSourcesCompanion Function({
      required String id,
      required String transactionId,
      required String sourceKind,
      required String provider,
      Value<String?> externalId,
      Value<String?> fileHash,
      Value<String?> rowHash,
      Value<String?> notificationKey,
      Value<String?> rawPayloadJson,
      Value<DateTime?> occurredAt,
      Value<double> confidence,
      Value<int> rowid,
    });
typedef $$TransactionSourcesTableUpdateCompanionBuilder =
    TransactionSourcesCompanion Function({
      Value<String> id,
      Value<String> transactionId,
      Value<String> sourceKind,
      Value<String> provider,
      Value<String?> externalId,
      Value<String?> fileHash,
      Value<String?> rowHash,
      Value<String?> notificationKey,
      Value<String?> rawPayloadJson,
      Value<DateTime?> occurredAt,
      Value<double> confidence,
      Value<int> rowid,
    });

class $$TransactionSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionSourcesTable> {
  $$TransactionSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowHash => $composableBuilder(
    column: $table.rowHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notificationKey => $composableBuilder(
    column: $table.notificationKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawPayloadJson => $composableBuilder(
    column: $table.rawPayloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionSourcesTable> {
  $$TransactionSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowHash => $composableBuilder(
    column: $table.rowHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationKey => $composableBuilder(
    column: $table.notificationKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawPayloadJson => $composableBuilder(
    column: $table.rawPayloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionSourcesTable> {
  $$TransactionSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<String> get rowHash =>
      $composableBuilder(column: $table.rowHash, builder: (column) => column);

  GeneratedColumn<String> get notificationKey => $composableBuilder(
    column: $table.notificationKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawPayloadJson => $composableBuilder(
    column: $table.rawPayloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );
}

class $$TransactionSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionSourcesTable,
          TransactionSourceRow,
          $$TransactionSourcesTableFilterComposer,
          $$TransactionSourcesTableOrderingComposer,
          $$TransactionSourcesTableAnnotationComposer,
          $$TransactionSourcesTableCreateCompanionBuilder,
          $$TransactionSourcesTableUpdateCompanionBuilder,
          (
            TransactionSourceRow,
            BaseReferences<
              _$AppDatabase,
              $TransactionSourcesTable,
              TransactionSourceRow
            >,
          ),
          TransactionSourceRow,
          PrefetchHooks Function()
        > {
  $$TransactionSourcesTableTableManager(
    _$AppDatabase db,
    $TransactionSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionSourcesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<String?> rowHash = const Value.absent(),
                Value<String?> notificationKey = const Value.absent(),
                Value<String?> rawPayloadJson = const Value.absent(),
                Value<DateTime?> occurredAt = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionSourcesCompanion(
                id: id,
                transactionId: transactionId,
                sourceKind: sourceKind,
                provider: provider,
                externalId: externalId,
                fileHash: fileHash,
                rowHash: rowHash,
                notificationKey: notificationKey,
                rawPayloadJson: rawPayloadJson,
                occurredAt: occurredAt,
                confidence: confidence,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transactionId,
                required String sourceKind,
                required String provider,
                Value<String?> externalId = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<String?> rowHash = const Value.absent(),
                Value<String?> notificationKey = const Value.absent(),
                Value<String?> rawPayloadJson = const Value.absent(),
                Value<DateTime?> occurredAt = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionSourcesCompanion.insert(
                id: id,
                transactionId: transactionId,
                sourceKind: sourceKind,
                provider: provider,
                externalId: externalId,
                fileHash: fileHash,
                rowHash: rowHash,
                notificationKey: notificationKey,
                rawPayloadJson: rawPayloadJson,
                occurredAt: occurredAt,
                confidence: confidence,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionSourcesTable,
      TransactionSourceRow,
      $$TransactionSourcesTableFilterComposer,
      $$TransactionSourcesTableOrderingComposer,
      $$TransactionSourcesTableAnnotationComposer,
      $$TransactionSourcesTableCreateCompanionBuilder,
      $$TransactionSourcesTableUpdateCompanionBuilder,
      (
        TransactionSourceRow,
        BaseReferences<
          _$AppDatabase,
          $TransactionSourcesTable,
          TransactionSourceRow
        >,
      ),
      TransactionSourceRow,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String opId,
      required String deviceId,
      required String householdId,
      required String entityType,
      required String entityId,
      required String operationType,
      Value<int> baseVersion,
      required String payloadJson,
      required DateTime createdAt,
      Value<DateTime?> sentAt,
      Value<DateTime?> ackAt,
      Value<String> status,
      Value<int> retryCount,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> opId,
      Value<String> deviceId,
      Value<String> householdId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operationType,
      Value<int> baseVersion,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<DateTime?> sentAt,
      Value<DateTime?> ackAt,
      Value<String> status,
      Value<int> retryCount,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ackAt => $composableBuilder(
    column: $table.ackAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ackAt => $composableBuilder(
    column: $table.ackAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opId =>
      $composableBuilder(column: $table.opId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<DateTime> get ackAt =>
      $composableBuilder(column: $table.ackAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxRow,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxRow,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>,
          ),
          SyncOutboxRow,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> opId = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<int> baseVersion = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<DateTime?> ackAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                opId: opId,
                deviceId: deviceId,
                householdId: householdId,
                entityType: entityType,
                entityId: entityId,
                operationType: operationType,
                baseVersion: baseVersion,
                payloadJson: payloadJson,
                createdAt: createdAt,
                sentAt: sentAt,
                ackAt: ackAt,
                status: status,
                retryCount: retryCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String opId,
                required String deviceId,
                required String householdId,
                required String entityType,
                required String entityId,
                required String operationType,
                Value<int> baseVersion = const Value.absent(),
                required String payloadJson,
                required DateTime createdAt,
                Value<DateTime?> sentAt = const Value.absent(),
                Value<DateTime?> ackAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                opId: opId,
                deviceId: deviceId,
                householdId: householdId,
                entityType: entityType,
                entityId: entityId,
                operationType: operationType,
                baseVersion: baseVersion,
                payloadJson: payloadJson,
                createdAt: createdAt,
                sentAt: sentAt,
                ackAt: ackAt,
                status: status,
                retryCount: retryCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxRow,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxRow,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>,
      ),
      SyncOutboxRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PeopleTableTableManager get people =>
      $$PeopleTableTableManager(_db, _db.people);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CreditCardsTableTableManager get creditCards =>
      $$CreditCardsTableTableManager(_db, _db.creditCards);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$CostCentersTableTableManager get costCenters =>
      $$CostCentersTableTableManager(_db, _db.costCenters);
  $$MerchantsTableTableManager get merchants =>
      $$MerchantsTableTableManager(_db, _db.merchants);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$ReviewInboxTableTableManager get reviewInbox =>
      $$ReviewInboxTableTableManager(_db, _db.reviewInbox);
  $$TransactionBeneficiariesTableTableManager get transactionBeneficiaries =>
      $$TransactionBeneficiariesTableTableManager(
        _db,
        _db.transactionBeneficiaries,
      );
  $$TransactionSourcesTableTableManager get transactionSources =>
      $$TransactionSourcesTableTableManager(_db, _db.transactionSources);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
}
