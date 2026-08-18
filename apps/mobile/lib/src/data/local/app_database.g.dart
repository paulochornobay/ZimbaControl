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
  static const VerificationMeta _ownerPersonIdMeta = const VerificationMeta(
    'ownerPersonId',
  );
  @override
  late final GeneratedColumn<String> ownerPersonId = GeneratedColumn<String>(
    'owner_person_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    ownerPersonId,
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
    if (data.containsKey('owner_person_id')) {
      context.handle(
        _ownerPersonIdMeta,
        ownerPersonId.isAcceptableOrUnknown(
          data['owner_person_id']!,
          _ownerPersonIdMeta,
        ),
      );
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
      ownerPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_person_id'],
      ),
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
  final String? ownerPersonId;
  final String provider;
  final String name;
  final String type;
  final String currencyCode;
  final String? last4;
  final bool active;
  const AccountRow({
    required this.id,
    required this.householdId,
    this.ownerPersonId,
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
    if (!nullToAbsent || ownerPersonId != null) {
      map['owner_person_id'] = Variable<String>(ownerPersonId);
    }
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
      ownerPersonId: ownerPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerPersonId),
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
      ownerPersonId: serializer.fromJson<String?>(json['ownerPersonId']),
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
      'ownerPersonId': serializer.toJson<String?>(ownerPersonId),
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
    Value<String?> ownerPersonId = const Value.absent(),
    String? provider,
    String? name,
    String? type,
    String? currencyCode,
    Value<String?> last4 = const Value.absent(),
    bool? active,
  }) => AccountRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    ownerPersonId: ownerPersonId.present
        ? ownerPersonId.value
        : this.ownerPersonId,
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
      ownerPersonId: data.ownerPersonId.present
          ? data.ownerPersonId.value
          : this.ownerPersonId,
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
          ..write('ownerPersonId: $ownerPersonId, ')
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
    ownerPersonId,
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
          other.ownerPersonId == this.ownerPersonId &&
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
  final Value<String?> ownerPersonId;
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
    this.ownerPersonId = const Value.absent(),
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
    this.ownerPersonId = const Value.absent(),
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
    Expression<String>? ownerPersonId,
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
      if (ownerPersonId != null) 'owner_person_id': ownerPersonId,
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
    Value<String?>? ownerPersonId,
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
      ownerPersonId: ownerPersonId ?? this.ownerPersonId,
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
    if (ownerPersonId.present) {
      map['owner_person_id'] = Variable<String>(ownerPersonId.value);
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
          ..write('ownerPersonId: $ownerPersonId, ')
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
  static const VerificationMeta _ownerPersonIdMeta = const VerificationMeta(
    'ownerPersonId',
  );
  @override
  late final GeneratedColumn<String> ownerPersonId = GeneratedColumn<String>(
    'owner_person_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    accountId,
    ownerPersonId,
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
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('owner_person_id')) {
      context.handle(
        _ownerPersonIdMeta,
        ownerPersonId.isAcceptableOrUnknown(
          data['owner_person_id']!,
          _ownerPersonIdMeta,
        ),
      );
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
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      ownerPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_person_id'],
      ),
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
  final String? accountId;
  final String? ownerPersonId;
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
    this.accountId,
    this.ownerPersonId,
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
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || ownerPersonId != null) {
      map['owner_person_id'] = Variable<String>(ownerPersonId);
    }
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
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      ownerPersonId: ownerPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerPersonId),
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
      accountId: serializer.fromJson<String?>(json['accountId']),
      ownerPersonId: serializer.fromJson<String?>(json['ownerPersonId']),
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
      'accountId': serializer.toJson<String?>(accountId),
      'ownerPersonId': serializer.toJson<String?>(ownerPersonId),
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
    Value<String?> accountId = const Value.absent(),
    Value<String?> ownerPersonId = const Value.absent(),
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
    accountId: accountId.present ? accountId.value : this.accountId,
    ownerPersonId: ownerPersonId.present
        ? ownerPersonId.value
        : this.ownerPersonId,
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
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      ownerPersonId: data.ownerPersonId.present
          ? data.ownerPersonId.value
          : this.ownerPersonId,
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
          ..write('accountId: $accountId, ')
          ..write('ownerPersonId: $ownerPersonId, ')
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
    accountId,
    ownerPersonId,
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
          other.accountId == this.accountId &&
          other.ownerPersonId == this.ownerPersonId &&
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
  final Value<String?> accountId;
  final Value<String?> ownerPersonId;
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
    this.accountId = const Value.absent(),
    this.ownerPersonId = const Value.absent(),
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
    this.accountId = const Value.absent(),
    this.ownerPersonId = const Value.absent(),
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
    Expression<String>? accountId,
    Expression<String>? ownerPersonId,
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
      if (accountId != null) 'account_id': accountId,
      if (ownerPersonId != null) 'owner_person_id': ownerPersonId,
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
    Value<String?>? accountId,
    Value<String?>? ownerPersonId,
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
      accountId: accountId ?? this.accountId,
      ownerPersonId: ownerPersonId ?? this.ownerPersonId,
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
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (ownerPersonId.present) {
      map['owner_person_id'] = Variable<String>(ownerPersonId.value);
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
          ..write('accountId: $accountId, ')
          ..write('ownerPersonId: $ownerPersonId, ')
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
    parentId,
    name,
    kind,
    sortOrder,
    active,
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
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
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
  final bool active;
  const CategoryRow({
    required this.id,
    required this.householdId,
    this.parentId,
    required this.name,
    required this.kind,
    required this.sortOrder,
    required this.active,
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
    map['active'] = Variable<bool>(active);
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
      active: Value(active),
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
      active: serializer.fromJson<bool>(json['active']),
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
      'active': serializer.toJson<bool>(active),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? householdId,
    Value<String?> parentId = const Value.absent(),
    String? name,
    String? kind,
    int? sortOrder,
    bool? active,
  }) => CategoryRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    sortOrder: sortOrder ?? this.sortOrder,
    active: active ?? this.active,
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
      active: data.active.present ? data.active.value : this.active,
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
          ..write('sortOrder: $sortOrder, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, householdId, parentId, name, kind, sortOrder, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.sortOrder == this.sortOrder &&
          other.active == this.active);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<String> kind;
  final Value<int> sortOrder;
  final Value<bool> active;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String householdId,
    this.parentId = const Value.absent(),
    required String name,
    required String kind,
    this.sortOrder = const Value.absent(),
    this.active = const Value.absent(),
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
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (active != null) 'active': active,
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
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      sortOrder: sortOrder ?? this.sortOrder,
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
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('active: $active, ')
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
  static const VerificationMeta _transferFromAccountIdMeta =
      const VerificationMeta('transferFromAccountId');
  @override
  late final GeneratedColumn<String> transferFromAccountId =
      GeneratedColumn<String>(
        'transfer_from_account_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _transferToAccountIdMeta =
      const VerificationMeta('transferToAccountId');
  @override
  late final GeneratedColumn<String> transferToAccountId =
      GeneratedColumn<String>(
        'transfer_to_account_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _recurringScheduleIdMeta =
      const VerificationMeta('recurringScheduleId');
  @override
  late final GeneratedColumn<String> recurringScheduleId =
      GeneratedColumn<String>(
        'recurring_schedule_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _installmentPlanIdMeta = const VerificationMeta(
    'installmentPlanId',
  );
  @override
  late final GeneratedColumn<String> installmentPlanId =
      GeneratedColumn<String>(
        'installment_plan_id',
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
  static const VerificationMeta _appliedRuleIdMeta = const VerificationMeta(
    'appliedRuleId',
  );
  @override
  late final GeneratedColumn<String> appliedRuleId = GeneratedColumn<String>(
    'applied_rule_id',
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
    transferFromAccountId,
    transferToAccountId,
    recurringScheduleId,
    installmentPlanId,
    merchantId,
    categoryId,
    costCenterId,
    payerId,
    appliedRuleId,
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
    if (data.containsKey('transfer_from_account_id')) {
      context.handle(
        _transferFromAccountIdMeta,
        transferFromAccountId.isAcceptableOrUnknown(
          data['transfer_from_account_id']!,
          _transferFromAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('transfer_to_account_id')) {
      context.handle(
        _transferToAccountIdMeta,
        transferToAccountId.isAcceptableOrUnknown(
          data['transfer_to_account_id']!,
          _transferToAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('recurring_schedule_id')) {
      context.handle(
        _recurringScheduleIdMeta,
        recurringScheduleId.isAcceptableOrUnknown(
          data['recurring_schedule_id']!,
          _recurringScheduleIdMeta,
        ),
      );
    }
    if (data.containsKey('installment_plan_id')) {
      context.handle(
        _installmentPlanIdMeta,
        installmentPlanId.isAcceptableOrUnknown(
          data['installment_plan_id']!,
          _installmentPlanIdMeta,
        ),
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
    if (data.containsKey('applied_rule_id')) {
      context.handle(
        _appliedRuleIdMeta,
        appliedRuleId.isAcceptableOrUnknown(
          data['applied_rule_id']!,
          _appliedRuleIdMeta,
        ),
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
      transferFromAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_from_account_id'],
      ),
      transferToAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_to_account_id'],
      ),
      recurringScheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_schedule_id'],
      ),
      installmentPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installment_plan_id'],
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
      appliedRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}applied_rule_id'],
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
  final String? transferFromAccountId;
  final String? transferToAccountId;
  final String? recurringScheduleId;
  final String? installmentPlanId;
  final String? merchantId;
  final String? categoryId;
  final String? costCenterId;
  final String? payerId;
  final String? appliedRuleId;
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
    this.transferFromAccountId,
    this.transferToAccountId,
    this.recurringScheduleId,
    this.installmentPlanId,
    this.merchantId,
    this.categoryId,
    this.costCenterId,
    this.payerId,
    this.appliedRuleId,
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
    if (!nullToAbsent || transferFromAccountId != null) {
      map['transfer_from_account_id'] = Variable<String>(transferFromAccountId);
    }
    if (!nullToAbsent || transferToAccountId != null) {
      map['transfer_to_account_id'] = Variable<String>(transferToAccountId);
    }
    if (!nullToAbsent || recurringScheduleId != null) {
      map['recurring_schedule_id'] = Variable<String>(recurringScheduleId);
    }
    if (!nullToAbsent || installmentPlanId != null) {
      map['installment_plan_id'] = Variable<String>(installmentPlanId);
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
    if (!nullToAbsent || appliedRuleId != null) {
      map['applied_rule_id'] = Variable<String>(appliedRuleId);
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
      transferFromAccountId: transferFromAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferFromAccountId),
      transferToAccountId: transferToAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferToAccountId),
      recurringScheduleId: recurringScheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringScheduleId),
      installmentPlanId: installmentPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(installmentPlanId),
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
      appliedRuleId: appliedRuleId == null && nullToAbsent
          ? const Value.absent()
          : Value(appliedRuleId),
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
      transferFromAccountId: serializer.fromJson<String?>(
        json['transferFromAccountId'],
      ),
      transferToAccountId: serializer.fromJson<String?>(
        json['transferToAccountId'],
      ),
      recurringScheduleId: serializer.fromJson<String?>(
        json['recurringScheduleId'],
      ),
      installmentPlanId: serializer.fromJson<String?>(
        json['installmentPlanId'],
      ),
      merchantId: serializer.fromJson<String?>(json['merchantId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      costCenterId: serializer.fromJson<String?>(json['costCenterId']),
      payerId: serializer.fromJson<String?>(json['payerId']),
      appliedRuleId: serializer.fromJson<String?>(json['appliedRuleId']),
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
      'transferFromAccountId': serializer.toJson<String?>(
        transferFromAccountId,
      ),
      'transferToAccountId': serializer.toJson<String?>(transferToAccountId),
      'recurringScheduleId': serializer.toJson<String?>(recurringScheduleId),
      'installmentPlanId': serializer.toJson<String?>(installmentPlanId),
      'merchantId': serializer.toJson<String?>(merchantId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'costCenterId': serializer.toJson<String?>(costCenterId),
      'payerId': serializer.toJson<String?>(payerId),
      'appliedRuleId': serializer.toJson<String?>(appliedRuleId),
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
    Value<String?> transferFromAccountId = const Value.absent(),
    Value<String?> transferToAccountId = const Value.absent(),
    Value<String?> recurringScheduleId = const Value.absent(),
    Value<String?> installmentPlanId = const Value.absent(),
    Value<String?> merchantId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> costCenterId = const Value.absent(),
    Value<String?> payerId = const Value.absent(),
    Value<String?> appliedRuleId = const Value.absent(),
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
    transferFromAccountId: transferFromAccountId.present
        ? transferFromAccountId.value
        : this.transferFromAccountId,
    transferToAccountId: transferToAccountId.present
        ? transferToAccountId.value
        : this.transferToAccountId,
    recurringScheduleId: recurringScheduleId.present
        ? recurringScheduleId.value
        : this.recurringScheduleId,
    installmentPlanId: installmentPlanId.present
        ? installmentPlanId.value
        : this.installmentPlanId,
    merchantId: merchantId.present ? merchantId.value : this.merchantId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    costCenterId: costCenterId.present ? costCenterId.value : this.costCenterId,
    payerId: payerId.present ? payerId.value : this.payerId,
    appliedRuleId: appliedRuleId.present
        ? appliedRuleId.value
        : this.appliedRuleId,
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
      transferFromAccountId: data.transferFromAccountId.present
          ? data.transferFromAccountId.value
          : this.transferFromAccountId,
      transferToAccountId: data.transferToAccountId.present
          ? data.transferToAccountId.value
          : this.transferToAccountId,
      recurringScheduleId: data.recurringScheduleId.present
          ? data.recurringScheduleId.value
          : this.recurringScheduleId,
      installmentPlanId: data.installmentPlanId.present
          ? data.installmentPlanId.value
          : this.installmentPlanId,
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
      appliedRuleId: data.appliedRuleId.present
          ? data.appliedRuleId.value
          : this.appliedRuleId,
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
          ..write('transferFromAccountId: $transferFromAccountId, ')
          ..write('transferToAccountId: $transferToAccountId, ')
          ..write('recurringScheduleId: $recurringScheduleId, ')
          ..write('installmentPlanId: $installmentPlanId, ')
          ..write('merchantId: $merchantId, ')
          ..write('categoryId: $categoryId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('payerId: $payerId, ')
          ..write('appliedRuleId: $appliedRuleId, ')
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
    transferFromAccountId,
    transferToAccountId,
    recurringScheduleId,
    installmentPlanId,
    merchantId,
    categoryId,
    costCenterId,
    payerId,
    appliedRuleId,
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
          other.transferFromAccountId == this.transferFromAccountId &&
          other.transferToAccountId == this.transferToAccountId &&
          other.recurringScheduleId == this.recurringScheduleId &&
          other.installmentPlanId == this.installmentPlanId &&
          other.merchantId == this.merchantId &&
          other.categoryId == this.categoryId &&
          other.costCenterId == this.costCenterId &&
          other.payerId == this.payerId &&
          other.appliedRuleId == this.appliedRuleId &&
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
  final Value<String?> transferFromAccountId;
  final Value<String?> transferToAccountId;
  final Value<String?> recurringScheduleId;
  final Value<String?> installmentPlanId;
  final Value<String?> merchantId;
  final Value<String?> categoryId;
  final Value<String?> costCenterId;
  final Value<String?> payerId;
  final Value<String?> appliedRuleId;
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
    this.transferFromAccountId = const Value.absent(),
    this.transferToAccountId = const Value.absent(),
    this.recurringScheduleId = const Value.absent(),
    this.installmentPlanId = const Value.absent(),
    this.merchantId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.payerId = const Value.absent(),
    this.appliedRuleId = const Value.absent(),
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
    this.transferFromAccountId = const Value.absent(),
    this.transferToAccountId = const Value.absent(),
    this.recurringScheduleId = const Value.absent(),
    this.installmentPlanId = const Value.absent(),
    this.merchantId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.payerId = const Value.absent(),
    this.appliedRuleId = const Value.absent(),
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
    Expression<String>? transferFromAccountId,
    Expression<String>? transferToAccountId,
    Expression<String>? recurringScheduleId,
    Expression<String>? installmentPlanId,
    Expression<String>? merchantId,
    Expression<String>? categoryId,
    Expression<String>? costCenterId,
    Expression<String>? payerId,
    Expression<String>? appliedRuleId,
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
      if (transferFromAccountId != null)
        'transfer_from_account_id': transferFromAccountId,
      if (transferToAccountId != null)
        'transfer_to_account_id': transferToAccountId,
      if (recurringScheduleId != null)
        'recurring_schedule_id': recurringScheduleId,
      if (installmentPlanId != null) 'installment_plan_id': installmentPlanId,
      if (merchantId != null) 'merchant_id': merchantId,
      if (categoryId != null) 'category_id': categoryId,
      if (costCenterId != null) 'cost_center_id': costCenterId,
      if (payerId != null) 'payer_id': payerId,
      if (appliedRuleId != null) 'applied_rule_id': appliedRuleId,
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
    Value<String?>? transferFromAccountId,
    Value<String?>? transferToAccountId,
    Value<String?>? recurringScheduleId,
    Value<String?>? installmentPlanId,
    Value<String?>? merchantId,
    Value<String?>? categoryId,
    Value<String?>? costCenterId,
    Value<String?>? payerId,
    Value<String?>? appliedRuleId,
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
      transferFromAccountId:
          transferFromAccountId ?? this.transferFromAccountId,
      transferToAccountId: transferToAccountId ?? this.transferToAccountId,
      recurringScheduleId: recurringScheduleId ?? this.recurringScheduleId,
      installmentPlanId: installmentPlanId ?? this.installmentPlanId,
      merchantId: merchantId ?? this.merchantId,
      categoryId: categoryId ?? this.categoryId,
      costCenterId: costCenterId ?? this.costCenterId,
      payerId: payerId ?? this.payerId,
      appliedRuleId: appliedRuleId ?? this.appliedRuleId,
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
    if (transferFromAccountId.present) {
      map['transfer_from_account_id'] = Variable<String>(
        transferFromAccountId.value,
      );
    }
    if (transferToAccountId.present) {
      map['transfer_to_account_id'] = Variable<String>(
        transferToAccountId.value,
      );
    }
    if (recurringScheduleId.present) {
      map['recurring_schedule_id'] = Variable<String>(
        recurringScheduleId.value,
      );
    }
    if (installmentPlanId.present) {
      map['installment_plan_id'] = Variable<String>(installmentPlanId.value);
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
    if (appliedRuleId.present) {
      map['applied_rule_id'] = Variable<String>(appliedRuleId.value);
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
          ..write('transferFromAccountId: $transferFromAccountId, ')
          ..write('transferToAccountId: $transferToAccountId, ')
          ..write('recurringScheduleId: $recurringScheduleId, ')
          ..write('installmentPlanId: $installmentPlanId, ')
          ..write('merchantId: $merchantId, ')
          ..write('categoryId: $categoryId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('payerId: $payerId, ')
          ..write('appliedRuleId: $appliedRuleId, ')
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

class $ClassificationRulesTable extends ClassificationRules
    with TableInfo<$ClassificationRulesTable, ClassificationRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassificationRulesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _matchTextMeta = const VerificationMeta(
    'matchText',
  );
  @override
  late final GeneratedColumn<String> matchText = GeneratedColumn<String>(
    'match_text',
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
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    name,
    matchText,
    kind,
    categoryId,
    costCenterId,
    priority,
    active,
    usageCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classification_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassificationRuleRow> instance, {
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
    if (data.containsKey('match_text')) {
      context.handle(
        _matchTextMeta,
        matchText.isAcceptableOrUnknown(data['match_text']!, _matchTextMeta),
      );
    } else if (isInserting) {
      context.missing(_matchTextMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
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
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClassificationRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassificationRuleRow(
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
      matchText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_text'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      costCenterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cost_center_id'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ClassificationRulesTable createAlias(String alias) {
    return $ClassificationRulesTable(attachedDatabase, alias);
  }
}

class ClassificationRuleRow extends DataClass
    implements Insertable<ClassificationRuleRow> {
  final String id;
  final String householdId;
  final String name;
  final String matchText;
  final String? kind;
  final String? categoryId;
  final String? costCenterId;
  final int priority;
  final bool active;
  final int usageCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ClassificationRuleRow({
    required this.id,
    required this.householdId,
    required this.name,
    required this.matchText,
    this.kind,
    this.categoryId,
    this.costCenterId,
    required this.priority,
    required this.active,
    required this.usageCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['name'] = Variable<String>(name);
    map['match_text'] = Variable<String>(matchText);
    if (!nullToAbsent || kind != null) {
      map['kind'] = Variable<String>(kind);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || costCenterId != null) {
      map['cost_center_id'] = Variable<String>(costCenterId);
    }
    map['priority'] = Variable<int>(priority);
    map['active'] = Variable<bool>(active);
    map['usage_count'] = Variable<int>(usageCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClassificationRulesCompanion toCompanion(bool nullToAbsent) {
    return ClassificationRulesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      matchText: Value(matchText),
      kind: kind == null && nullToAbsent ? const Value.absent() : Value(kind),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      costCenterId: costCenterId == null && nullToAbsent
          ? const Value.absent()
          : Value(costCenterId),
      priority: Value(priority),
      active: Value(active),
      usageCount: Value(usageCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ClassificationRuleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassificationRuleRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      name: serializer.fromJson<String>(json['name']),
      matchText: serializer.fromJson<String>(json['matchText']),
      kind: serializer.fromJson<String?>(json['kind']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      costCenterId: serializer.fromJson<String?>(json['costCenterId']),
      priority: serializer.fromJson<int>(json['priority']),
      active: serializer.fromJson<bool>(json['active']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'name': serializer.toJson<String>(name),
      'matchText': serializer.toJson<String>(matchText),
      'kind': serializer.toJson<String?>(kind),
      'categoryId': serializer.toJson<String?>(categoryId),
      'costCenterId': serializer.toJson<String?>(costCenterId),
      'priority': serializer.toJson<int>(priority),
      'active': serializer.toJson<bool>(active),
      'usageCount': serializer.toJson<int>(usageCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ClassificationRuleRow copyWith({
    String? id,
    String? householdId,
    String? name,
    String? matchText,
    Value<String?> kind = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> costCenterId = const Value.absent(),
    int? priority,
    bool? active,
    int? usageCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ClassificationRuleRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    name: name ?? this.name,
    matchText: matchText ?? this.matchText,
    kind: kind.present ? kind.value : this.kind,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    costCenterId: costCenterId.present ? costCenterId.value : this.costCenterId,
    priority: priority ?? this.priority,
    active: active ?? this.active,
    usageCount: usageCount ?? this.usageCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ClassificationRuleRow copyWithCompanion(ClassificationRulesCompanion data) {
    return ClassificationRuleRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      matchText: data.matchText.present ? data.matchText.value : this.matchText,
      kind: data.kind.present ? data.kind.value : this.kind,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      costCenterId: data.costCenterId.present
          ? data.costCenterId.value
          : this.costCenterId,
      priority: data.priority.present ? data.priority.value : this.priority,
      active: data.active.present ? data.active.value : this.active,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassificationRuleRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('matchText: $matchText, ')
          ..write('kind: $kind, ')
          ..write('categoryId: $categoryId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('priority: $priority, ')
          ..write('active: $active, ')
          ..write('usageCount: $usageCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    name,
    matchText,
    kind,
    categoryId,
    costCenterId,
    priority,
    active,
    usageCount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassificationRuleRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.matchText == this.matchText &&
          other.kind == this.kind &&
          other.categoryId == this.categoryId &&
          other.costCenterId == this.costCenterId &&
          other.priority == this.priority &&
          other.active == this.active &&
          other.usageCount == this.usageCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ClassificationRulesCompanion
    extends UpdateCompanion<ClassificationRuleRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> name;
  final Value<String> matchText;
  final Value<String?> kind;
  final Value<String?> categoryId;
  final Value<String?> costCenterId;
  final Value<int> priority;
  final Value<bool> active;
  final Value<int> usageCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ClassificationRulesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.matchText = const Value.absent(),
    this.kind = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.priority = const Value.absent(),
    this.active = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassificationRulesCompanion.insert({
    required String id,
    required String householdId,
    required String name,
    required String matchText,
    this.kind = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.priority = const Value.absent(),
    this.active = const Value.absent(),
    this.usageCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       name = Value(name),
       matchText = Value(matchText),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ClassificationRuleRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? name,
    Expression<String>? matchText,
    Expression<String>? kind,
    Expression<String>? categoryId,
    Expression<String>? costCenterId,
    Expression<int>? priority,
    Expression<bool>? active,
    Expression<int>? usageCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (matchText != null) 'match_text': matchText,
      if (kind != null) 'kind': kind,
      if (categoryId != null) 'category_id': categoryId,
      if (costCenterId != null) 'cost_center_id': costCenterId,
      if (priority != null) 'priority': priority,
      if (active != null) 'active': active,
      if (usageCount != null) 'usage_count': usageCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassificationRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? name,
    Value<String>? matchText,
    Value<String?>? kind,
    Value<String?>? categoryId,
    Value<String?>? costCenterId,
    Value<int>? priority,
    Value<bool>? active,
    Value<int>? usageCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ClassificationRulesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      matchText: matchText ?? this.matchText,
      kind: kind ?? this.kind,
      categoryId: categoryId ?? this.categoryId,
      costCenterId: costCenterId ?? this.costCenterId,
      priority: priority ?? this.priority,
      active: active ?? this.active,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (matchText.present) {
      map['match_text'] = Variable<String>(matchText.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (costCenterId.present) {
      map['cost_center_id'] = Variable<String>(costCenterId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassificationRulesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('matchText: $matchText, ')
          ..write('kind: $kind, ')
          ..write('categoryId: $categoryId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('priority: $priority, ')
          ..write('active: $active, ')
          ..write('usageCount: $usageCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
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

class $AppPreferencesTable extends AppPreferences
    with TableInfo<$AppPreferencesTable, AppPreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppPreferenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppPreferenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPreferenceRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppPreferencesTable createAlias(String alias) {
    return $AppPreferencesTable(attachedDatabase, alias);
  }
}

class AppPreferenceRow extends DataClass
    implements Insertable<AppPreferenceRow> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppPreferenceRow({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppPreferencesCompanion toCompanion(bool nullToAbsent) {
    return AppPreferencesCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppPreferenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPreferenceRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppPreferenceRow copyWith({
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => AppPreferenceRow(
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppPreferenceRow copyWithCompanion(AppPreferencesCompanion data) {
    return AppPreferenceRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferenceRow(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPreferenceRow &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppPreferencesCompanion extends UpdateCompanion<AppPreferenceRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppPreferencesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppPreferencesCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppPreferenceRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppPreferencesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppPreferencesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuthUsersTable extends AuthUsers
    with TableInfo<$AuthUsersTable, AuthUserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthUsersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
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
  static const VerificationMeta _linkedPersonIdMeta = const VerificationMeta(
    'linkedPersonId',
  );
  @override
  late final GeneratedColumn<String> linkedPersonId = GeneratedColumn<String>(
    'linked_person_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allowedMeta = const VerificationMeta(
    'allowed',
  );
  @override
  late final GeneratedColumn<bool> allowed = GeneratedColumn<bool>(
    'allowed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allowed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
  static const VerificationMeta _lastLoginAtMeta = const VerificationMeta(
    'lastLoginAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
    'last_login_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    email,
    provider,
    linkedPersonId,
    allowed,
    createdAt,
    lastLoginAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthUserRow> instance, {
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
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('linked_person_id')) {
      context.handle(
        _linkedPersonIdMeta,
        linkedPersonId.isAcceptableOrUnknown(
          data['linked_person_id']!,
          _linkedPersonIdMeta,
        ),
      );
    }
    if (data.containsKey('allowed')) {
      context.handle(
        _allowedMeta,
        allowed.isAcceptableOrUnknown(data['allowed']!, _allowedMeta),
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
    if (data.containsKey('last_login_at')) {
      context.handle(
        _lastLoginAtMeta,
        lastLoginAt.isAcceptableOrUnknown(
          data['last_login_at']!,
          _lastLoginAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthUserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthUserRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      linkedPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_person_id'],
      ),
      allowed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}allowed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastLoginAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_login_at'],
      ),
    );
  }

  @override
  $AuthUsersTable createAlias(String alias) {
    return $AuthUsersTable(attachedDatabase, alias);
  }
}

class AuthUserRow extends DataClass implements Insertable<AuthUserRow> {
  final String id;
  final String householdId;
  final String email;
  final String provider;
  final String? linkedPersonId;
  final bool allowed;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  const AuthUserRow({
    required this.id,
    required this.householdId,
    required this.email,
    required this.provider,
    this.linkedPersonId,
    required this.allowed,
    required this.createdAt,
    this.lastLoginAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['email'] = Variable<String>(email);
    map['provider'] = Variable<String>(provider);
    if (!nullToAbsent || linkedPersonId != null) {
      map['linked_person_id'] = Variable<String>(linkedPersonId);
    }
    map['allowed'] = Variable<bool>(allowed);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    return map;
  }

  AuthUsersCompanion toCompanion(bool nullToAbsent) {
    return AuthUsersCompanion(
      id: Value(id),
      householdId: Value(householdId),
      email: Value(email),
      provider: Value(provider),
      linkedPersonId: linkedPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedPersonId),
      allowed: Value(allowed),
      createdAt: Value(createdAt),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
    );
  }

  factory AuthUserRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthUserRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      email: serializer.fromJson<String>(json['email']),
      provider: serializer.fromJson<String>(json['provider']),
      linkedPersonId: serializer.fromJson<String?>(json['linkedPersonId']),
      allowed: serializer.fromJson<bool>(json['allowed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'email': serializer.toJson<String>(email),
      'provider': serializer.toJson<String>(provider),
      'linkedPersonId': serializer.toJson<String?>(linkedPersonId),
      'allowed': serializer.toJson<bool>(allowed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
    };
  }

  AuthUserRow copyWith({
    String? id,
    String? householdId,
    String? email,
    String? provider,
    Value<String?> linkedPersonId = const Value.absent(),
    bool? allowed,
    DateTime? createdAt,
    Value<DateTime?> lastLoginAt = const Value.absent(),
  }) => AuthUserRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    email: email ?? this.email,
    provider: provider ?? this.provider,
    linkedPersonId: linkedPersonId.present
        ? linkedPersonId.value
        : this.linkedPersonId,
    allowed: allowed ?? this.allowed,
    createdAt: createdAt ?? this.createdAt,
    lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
  );
  AuthUserRow copyWithCompanion(AuthUsersCompanion data) {
    return AuthUserRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      email: data.email.present ? data.email.value : this.email,
      provider: data.provider.present ? data.provider.value : this.provider,
      linkedPersonId: data.linkedPersonId.present
          ? data.linkedPersonId.value
          : this.linkedPersonId,
      allowed: data.allowed.present ? data.allowed.value : this.allowed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastLoginAt: data.lastLoginAt.present
          ? data.lastLoginAt.value
          : this.lastLoginAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthUserRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('email: $email, ')
          ..write('provider: $provider, ')
          ..write('linkedPersonId: $linkedPersonId, ')
          ..write('allowed: $allowed, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastLoginAt: $lastLoginAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    email,
    provider,
    linkedPersonId,
    allowed,
    createdAt,
    lastLoginAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthUserRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.email == this.email &&
          other.provider == this.provider &&
          other.linkedPersonId == this.linkedPersonId &&
          other.allowed == this.allowed &&
          other.createdAt == this.createdAt &&
          other.lastLoginAt == this.lastLoginAt);
}

class AuthUsersCompanion extends UpdateCompanion<AuthUserRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> email;
  final Value<String> provider;
  final Value<String?> linkedPersonId;
  final Value<bool> allowed;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastLoginAt;
  final Value<int> rowid;
  const AuthUsersCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.email = const Value.absent(),
    this.provider = const Value.absent(),
    this.linkedPersonId = const Value.absent(),
    this.allowed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthUsersCompanion.insert({
    required String id,
    required String householdId,
    required String email,
    required String provider,
    this.linkedPersonId = const Value.absent(),
    this.allowed = const Value.absent(),
    required DateTime createdAt,
    this.lastLoginAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       email = Value(email),
       provider = Value(provider),
       createdAt = Value(createdAt);
  static Insertable<AuthUserRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? email,
    Expression<String>? provider,
    Expression<String>? linkedPersonId,
    Expression<bool>? allowed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastLoginAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (email != null) 'email': email,
      if (provider != null) 'provider': provider,
      if (linkedPersonId != null) 'linked_person_id': linkedPersonId,
      if (allowed != null) 'allowed': allowed,
      if (createdAt != null) 'created_at': createdAt,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthUsersCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? email,
    Value<String>? provider,
    Value<String?>? linkedPersonId,
    Value<bool>? allowed,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastLoginAt,
    Value<int>? rowid,
  }) {
    return AuthUsersCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      email: email ?? this.email,
      provider: provider ?? this.provider,
      linkedPersonId: linkedPersonId ?? this.linkedPersonId,
      allowed: allowed ?? this.allowed,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (linkedPersonId.present) {
      map['linked_person_id'] = Variable<String>(linkedPersonId.value);
    }
    if (allowed.present) {
      map['allowed'] = Variable<bool>(allowed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthUsersCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('email: $email, ')
          ..write('provider: $provider, ')
          ..write('linkedPersonId: $linkedPersonId, ')
          ..write('allowed: $allowed, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringSchedulesTable extends RecurringSchedules
    with TableInfo<$RecurringSchedulesTable, RecurringScheduleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringSchedulesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
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
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _dayOfMonthMeta = const VerificationMeta(
    'dayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
    'day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMonthMeta = const VerificationMeta(
    'startMonth',
  );
  @override
  late final GeneratedColumn<String> startMonth = GeneratedColumn<String>(
    'start_month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMonthMeta = const VerificationMeta(
    'endMonth',
  );
  @override
  late final GeneratedColumn<String> endMonth = GeneratedColumn<String>(
    'end_month',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payerPersonIdMeta = const VerificationMeta(
    'payerPersonId',
  );
  @override
  late final GeneratedColumn<String> payerPersonId = GeneratedColumn<String>(
    'payer_person_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _beneficiaryPersonIdMeta =
      const VerificationMeta('beneficiaryPersonId');
  @override
  late final GeneratedColumn<String> beneficiaryPersonId =
      GeneratedColumn<String>(
        'beneficiary_person_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fromAccountIdMeta = const VerificationMeta(
    'fromAccountId',
  );
  @override
  late final GeneratedColumn<String> fromAccountId = GeneratedColumn<String>(
    'from_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<String> toAccountId = GeneratedColumn<String>(
    'to_account_id',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    label,
    kind,
    amountCents,
    currencyCode,
    frequency,
    dayOfMonth,
    startMonth,
    endMonth,
    payerPersonId,
    beneficiaryPersonId,
    fromAccountId,
    toAccountId,
    categoryId,
    costCenterId,
    active,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringScheduleRow> instance, {
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
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
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
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
        _dayOfMonthMeta,
        dayOfMonth.isAcceptableOrUnknown(
          data['day_of_month']!,
          _dayOfMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dayOfMonthMeta);
    }
    if (data.containsKey('start_month')) {
      context.handle(
        _startMonthMeta,
        startMonth.isAcceptableOrUnknown(data['start_month']!, _startMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_startMonthMeta);
    }
    if (data.containsKey('end_month')) {
      context.handle(
        _endMonthMeta,
        endMonth.isAcceptableOrUnknown(data['end_month']!, _endMonthMeta),
      );
    }
    if (data.containsKey('payer_person_id')) {
      context.handle(
        _payerPersonIdMeta,
        payerPersonId.isAcceptableOrUnknown(
          data['payer_person_id']!,
          _payerPersonIdMeta,
        ),
      );
    }
    if (data.containsKey('beneficiary_person_id')) {
      context.handle(
        _beneficiaryPersonIdMeta,
        beneficiaryPersonId.isAcceptableOrUnknown(
          data['beneficiary_person_id']!,
          _beneficiaryPersonIdMeta,
        ),
      );
    }
    if (data.containsKey('from_account_id')) {
      context.handle(
        _fromAccountIdMeta,
        fromAccountId.isAcceptableOrUnknown(
          data['from_account_id']!,
          _fromAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
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
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringScheduleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringScheduleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      dayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_month'],
      )!,
      startMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_month'],
      )!,
      endMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_month'],
      ),
      payerPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payer_person_id'],
      ),
      beneficiaryPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}beneficiary_person_id'],
      ),
      fromAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_account_id'],
      ),
      toAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_account_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      costCenterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cost_center_id'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurringSchedulesTable createAlias(String alias) {
    return $RecurringSchedulesTable(attachedDatabase, alias);
  }
}

class RecurringScheduleRow extends DataClass
    implements Insertable<RecurringScheduleRow> {
  final String id;
  final String householdId;
  final String label;
  final String kind;
  final int amountCents;
  final String currencyCode;
  final String frequency;
  final int dayOfMonth;
  final String startMonth;
  final String? endMonth;
  final String? payerPersonId;
  final String? beneficiaryPersonId;
  final String? fromAccountId;
  final String? toAccountId;
  final String? categoryId;
  final String? costCenterId;
  final bool active;
  final DateTime updatedAt;
  const RecurringScheduleRow({
    required this.id,
    required this.householdId,
    required this.label,
    required this.kind,
    required this.amountCents,
    required this.currencyCode,
    required this.frequency,
    required this.dayOfMonth,
    required this.startMonth,
    this.endMonth,
    this.payerPersonId,
    this.beneficiaryPersonId,
    this.fromAccountId,
    this.toAccountId,
    this.categoryId,
    this.costCenterId,
    required this.active,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['label'] = Variable<String>(label);
    map['kind'] = Variable<String>(kind);
    map['amount_cents'] = Variable<int>(amountCents);
    map['currency_code'] = Variable<String>(currencyCode);
    map['frequency'] = Variable<String>(frequency);
    map['day_of_month'] = Variable<int>(dayOfMonth);
    map['start_month'] = Variable<String>(startMonth);
    if (!nullToAbsent || endMonth != null) {
      map['end_month'] = Variable<String>(endMonth);
    }
    if (!nullToAbsent || payerPersonId != null) {
      map['payer_person_id'] = Variable<String>(payerPersonId);
    }
    if (!nullToAbsent || beneficiaryPersonId != null) {
      map['beneficiary_person_id'] = Variable<String>(beneficiaryPersonId);
    }
    if (!nullToAbsent || fromAccountId != null) {
      map['from_account_id'] = Variable<String>(fromAccountId);
    }
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<String>(toAccountId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || costCenterId != null) {
      map['cost_center_id'] = Variable<String>(costCenterId);
    }
    map['active'] = Variable<bool>(active);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurringSchedulesCompanion toCompanion(bool nullToAbsent) {
    return RecurringSchedulesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      label: Value(label),
      kind: Value(kind),
      amountCents: Value(amountCents),
      currencyCode: Value(currencyCode),
      frequency: Value(frequency),
      dayOfMonth: Value(dayOfMonth),
      startMonth: Value(startMonth),
      endMonth: endMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(endMonth),
      payerPersonId: payerPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(payerPersonId),
      beneficiaryPersonId: beneficiaryPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(beneficiaryPersonId),
      fromAccountId: fromAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromAccountId),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      costCenterId: costCenterId == null && nullToAbsent
          ? const Value.absent()
          : Value(costCenterId),
      active: Value(active),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringScheduleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringScheduleRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      label: serializer.fromJson<String>(json['label']),
      kind: serializer.fromJson<String>(json['kind']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      frequency: serializer.fromJson<String>(json['frequency']),
      dayOfMonth: serializer.fromJson<int>(json['dayOfMonth']),
      startMonth: serializer.fromJson<String>(json['startMonth']),
      endMonth: serializer.fromJson<String?>(json['endMonth']),
      payerPersonId: serializer.fromJson<String?>(json['payerPersonId']),
      beneficiaryPersonId: serializer.fromJson<String?>(
        json['beneficiaryPersonId'],
      ),
      fromAccountId: serializer.fromJson<String?>(json['fromAccountId']),
      toAccountId: serializer.fromJson<String?>(json['toAccountId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      costCenterId: serializer.fromJson<String?>(json['costCenterId']),
      active: serializer.fromJson<bool>(json['active']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'label': serializer.toJson<String>(label),
      'kind': serializer.toJson<String>(kind),
      'amountCents': serializer.toJson<int>(amountCents),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'frequency': serializer.toJson<String>(frequency),
      'dayOfMonth': serializer.toJson<int>(dayOfMonth),
      'startMonth': serializer.toJson<String>(startMonth),
      'endMonth': serializer.toJson<String?>(endMonth),
      'payerPersonId': serializer.toJson<String?>(payerPersonId),
      'beneficiaryPersonId': serializer.toJson<String?>(beneficiaryPersonId),
      'fromAccountId': serializer.toJson<String?>(fromAccountId),
      'toAccountId': serializer.toJson<String?>(toAccountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'costCenterId': serializer.toJson<String?>(costCenterId),
      'active': serializer.toJson<bool>(active),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurringScheduleRow copyWith({
    String? id,
    String? householdId,
    String? label,
    String? kind,
    int? amountCents,
    String? currencyCode,
    String? frequency,
    int? dayOfMonth,
    String? startMonth,
    Value<String?> endMonth = const Value.absent(),
    Value<String?> payerPersonId = const Value.absent(),
    Value<String?> beneficiaryPersonId = const Value.absent(),
    Value<String?> fromAccountId = const Value.absent(),
    Value<String?> toAccountId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> costCenterId = const Value.absent(),
    bool? active,
    DateTime? updatedAt,
  }) => RecurringScheduleRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    label: label ?? this.label,
    kind: kind ?? this.kind,
    amountCents: amountCents ?? this.amountCents,
    currencyCode: currencyCode ?? this.currencyCode,
    frequency: frequency ?? this.frequency,
    dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    startMonth: startMonth ?? this.startMonth,
    endMonth: endMonth.present ? endMonth.value : this.endMonth,
    payerPersonId: payerPersonId.present
        ? payerPersonId.value
        : this.payerPersonId,
    beneficiaryPersonId: beneficiaryPersonId.present
        ? beneficiaryPersonId.value
        : this.beneficiaryPersonId,
    fromAccountId: fromAccountId.present
        ? fromAccountId.value
        : this.fromAccountId,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    costCenterId: costCenterId.present ? costCenterId.value : this.costCenterId,
    active: active ?? this.active,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringScheduleRow copyWithCompanion(RecurringSchedulesCompanion data) {
    return RecurringScheduleRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      label: data.label.present ? data.label.value : this.label,
      kind: data.kind.present ? data.kind.value : this.kind,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      dayOfMonth: data.dayOfMonth.present
          ? data.dayOfMonth.value
          : this.dayOfMonth,
      startMonth: data.startMonth.present
          ? data.startMonth.value
          : this.startMonth,
      endMonth: data.endMonth.present ? data.endMonth.value : this.endMonth,
      payerPersonId: data.payerPersonId.present
          ? data.payerPersonId.value
          : this.payerPersonId,
      beneficiaryPersonId: data.beneficiaryPersonId.present
          ? data.beneficiaryPersonId.value
          : this.beneficiaryPersonId,
      fromAccountId: data.fromAccountId.present
          ? data.fromAccountId.value
          : this.fromAccountId,
      toAccountId: data.toAccountId.present
          ? data.toAccountId.value
          : this.toAccountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      costCenterId: data.costCenterId.present
          ? data.costCenterId.value
          : this.costCenterId,
      active: data.active.present ? data.active.value : this.active,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringScheduleRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('amountCents: $amountCents, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('frequency: $frequency, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('startMonth: $startMonth, ')
          ..write('endMonth: $endMonth, ')
          ..write('payerPersonId: $payerPersonId, ')
          ..write('beneficiaryPersonId: $beneficiaryPersonId, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('active: $active, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    label,
    kind,
    amountCents,
    currencyCode,
    frequency,
    dayOfMonth,
    startMonth,
    endMonth,
    payerPersonId,
    beneficiaryPersonId,
    fromAccountId,
    toAccountId,
    categoryId,
    costCenterId,
    active,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringScheduleRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.label == this.label &&
          other.kind == this.kind &&
          other.amountCents == this.amountCents &&
          other.currencyCode == this.currencyCode &&
          other.frequency == this.frequency &&
          other.dayOfMonth == this.dayOfMonth &&
          other.startMonth == this.startMonth &&
          other.endMonth == this.endMonth &&
          other.payerPersonId == this.payerPersonId &&
          other.beneficiaryPersonId == this.beneficiaryPersonId &&
          other.fromAccountId == this.fromAccountId &&
          other.toAccountId == this.toAccountId &&
          other.categoryId == this.categoryId &&
          other.costCenterId == this.costCenterId &&
          other.active == this.active &&
          other.updatedAt == this.updatedAt);
}

class RecurringSchedulesCompanion
    extends UpdateCompanion<RecurringScheduleRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> label;
  final Value<String> kind;
  final Value<int> amountCents;
  final Value<String> currencyCode;
  final Value<String> frequency;
  final Value<int> dayOfMonth;
  final Value<String> startMonth;
  final Value<String?> endMonth;
  final Value<String?> payerPersonId;
  final Value<String?> beneficiaryPersonId;
  final Value<String?> fromAccountId;
  final Value<String?> toAccountId;
  final Value<String?> categoryId;
  final Value<String?> costCenterId;
  final Value<bool> active;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecurringSchedulesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.label = const Value.absent(),
    this.kind = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.frequency = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.startMonth = const Value.absent(),
    this.endMonth = const Value.absent(),
    this.payerPersonId = const Value.absent(),
    this.beneficiaryPersonId = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.active = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringSchedulesCompanion.insert({
    required String id,
    required String householdId,
    required String label,
    required String kind,
    required int amountCents,
    this.currencyCode = const Value.absent(),
    this.frequency = const Value.absent(),
    required int dayOfMonth,
    required String startMonth,
    this.endMonth = const Value.absent(),
    this.payerPersonId = const Value.absent(),
    this.beneficiaryPersonId = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.active = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       label = Value(label),
       kind = Value(kind),
       amountCents = Value(amountCents),
       dayOfMonth = Value(dayOfMonth),
       startMonth = Value(startMonth),
       updatedAt = Value(updatedAt);
  static Insertable<RecurringScheduleRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? label,
    Expression<String>? kind,
    Expression<int>? amountCents,
    Expression<String>? currencyCode,
    Expression<String>? frequency,
    Expression<int>? dayOfMonth,
    Expression<String>? startMonth,
    Expression<String>? endMonth,
    Expression<String>? payerPersonId,
    Expression<String>? beneficiaryPersonId,
    Expression<String>? fromAccountId,
    Expression<String>? toAccountId,
    Expression<String>? categoryId,
    Expression<String>? costCenterId,
    Expression<bool>? active,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (label != null) 'label': label,
      if (kind != null) 'kind': kind,
      if (amountCents != null) 'amount_cents': amountCents,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (frequency != null) 'frequency': frequency,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (startMonth != null) 'start_month': startMonth,
      if (endMonth != null) 'end_month': endMonth,
      if (payerPersonId != null) 'payer_person_id': payerPersonId,
      if (beneficiaryPersonId != null)
        'beneficiary_person_id': beneficiaryPersonId,
      if (fromAccountId != null) 'from_account_id': fromAccountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (categoryId != null) 'category_id': categoryId,
      if (costCenterId != null) 'cost_center_id': costCenterId,
      if (active != null) 'active': active,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringSchedulesCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? label,
    Value<String>? kind,
    Value<int>? amountCents,
    Value<String>? currencyCode,
    Value<String>? frequency,
    Value<int>? dayOfMonth,
    Value<String>? startMonth,
    Value<String?>? endMonth,
    Value<String?>? payerPersonId,
    Value<String?>? beneficiaryPersonId,
    Value<String?>? fromAccountId,
    Value<String?>? toAccountId,
    Value<String?>? categoryId,
    Value<String?>? costCenterId,
    Value<bool>? active,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecurringSchedulesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      amountCents: amountCents ?? this.amountCents,
      currencyCode: currencyCode ?? this.currencyCode,
      frequency: frequency ?? this.frequency,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      startMonth: startMonth ?? this.startMonth,
      endMonth: endMonth ?? this.endMonth,
      payerPersonId: payerPersonId ?? this.payerPersonId,
      beneficiaryPersonId: beneficiaryPersonId ?? this.beneficiaryPersonId,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryId: categoryId ?? this.categoryId,
      costCenterId: costCenterId ?? this.costCenterId,
      active: active ?? this.active,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (startMonth.present) {
      map['start_month'] = Variable<String>(startMonth.value);
    }
    if (endMonth.present) {
      map['end_month'] = Variable<String>(endMonth.value);
    }
    if (payerPersonId.present) {
      map['payer_person_id'] = Variable<String>(payerPersonId.value);
    }
    if (beneficiaryPersonId.present) {
      map['beneficiary_person_id'] = Variable<String>(
        beneficiaryPersonId.value,
      );
    }
    if (fromAccountId.present) {
      map['from_account_id'] = Variable<String>(fromAccountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<String>(toAccountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (costCenterId.present) {
      map['cost_center_id'] = Variable<String>(costCenterId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('amountCents: $amountCents, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('frequency: $frequency, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('startMonth: $startMonth, ')
          ..write('endMonth: $endMonth, ')
          ..write('payerPersonId: $payerPersonId, ')
          ..write('beneficiaryPersonId: $beneficiaryPersonId, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('active: $active, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InstallmentPlansTable extends InstallmentPlans
    with TableInfo<$InstallmentPlansTable, InstallmentPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstallmentPlansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planKindMeta = const VerificationMeta(
    'planKind',
  );
  @override
  late final GeneratedColumn<String> planKind = GeneratedColumn<String>(
    'plan_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerPersonIdMeta = const VerificationMeta(
    'ownerPersonId',
  );
  @override
  late final GeneratedColumn<String> ownerPersonId = GeneratedColumn<String>(
    'owner_person_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assetNameMeta = const VerificationMeta(
    'assetName',
  );
  @override
  late final GeneratedColumn<String> assetName = GeneratedColumn<String>(
    'asset_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountCentsMeta = const VerificationMeta(
    'totalAmountCents',
  );
  @override
  late final GeneratedColumn<int> totalAmountCents = GeneratedColumn<int>(
    'total_amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _installmentAmountCentsMeta =
      const VerificationMeta('installmentAmountCents');
  @override
  late final GeneratedColumn<int> installmentAmountCents = GeneratedColumn<int>(
    'installment_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentInstallmentMeta =
      const VerificationMeta('currentInstallment');
  @override
  late final GeneratedColumn<int> currentInstallment = GeneratedColumn<int>(
    'current_installment',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalInstallmentsMeta = const VerificationMeta(
    'totalInstallments',
  );
  @override
  late final GeneratedColumn<int> totalInstallments = GeneratedColumn<int>(
    'total_installments',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _startMonthMeta = const VerificationMeta(
    'startMonth',
  );
  @override
  late final GeneratedColumn<String> startMonth = GeneratedColumn<String>(
    'start_month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMonthMeta = const VerificationMeta(
    'endMonth',
  );
  @override
  late final GeneratedColumn<String> endMonth = GeneratedColumn<String>(
    'end_month',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    label,
    planKind,
    ownerPersonId,
    assetName,
    totalAmountCents,
    installmentAmountCents,
    currentInstallment,
    totalInstallments,
    dueDay,
    startMonth,
    endMonth,
    categoryId,
    costCenterId,
    active,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installment_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstallmentPlanRow> instance, {
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
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('plan_kind')) {
      context.handle(
        _planKindMeta,
        planKind.isAcceptableOrUnknown(data['plan_kind']!, _planKindMeta),
      );
    } else if (isInserting) {
      context.missing(_planKindMeta);
    }
    if (data.containsKey('owner_person_id')) {
      context.handle(
        _ownerPersonIdMeta,
        ownerPersonId.isAcceptableOrUnknown(
          data['owner_person_id']!,
          _ownerPersonIdMeta,
        ),
      );
    }
    if (data.containsKey('asset_name')) {
      context.handle(
        _assetNameMeta,
        assetName.isAcceptableOrUnknown(data['asset_name']!, _assetNameMeta),
      );
    }
    if (data.containsKey('total_amount_cents')) {
      context.handle(
        _totalAmountCentsMeta,
        totalAmountCents.isAcceptableOrUnknown(
          data['total_amount_cents']!,
          _totalAmountCentsMeta,
        ),
      );
    }
    if (data.containsKey('installment_amount_cents')) {
      context.handle(
        _installmentAmountCentsMeta,
        installmentAmountCents.isAcceptableOrUnknown(
          data['installment_amount_cents']!,
          _installmentAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installmentAmountCentsMeta);
    }
    if (data.containsKey('current_installment')) {
      context.handle(
        _currentInstallmentMeta,
        currentInstallment.isAcceptableOrUnknown(
          data['current_installment']!,
          _currentInstallmentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentInstallmentMeta);
    }
    if (data.containsKey('total_installments')) {
      context.handle(
        _totalInstallmentsMeta,
        totalInstallments.isAcceptableOrUnknown(
          data['total_installments']!,
          _totalInstallmentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalInstallmentsMeta);
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    }
    if (data.containsKey('start_month')) {
      context.handle(
        _startMonthMeta,
        startMonth.isAcceptableOrUnknown(data['start_month']!, _startMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_startMonthMeta);
    }
    if (data.containsKey('end_month')) {
      context.handle(
        _endMonthMeta,
        endMonth.isAcceptableOrUnknown(data['end_month']!, _endMonthMeta),
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
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InstallmentPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstallmentPlanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      planKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_kind'],
      )!,
      ownerPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_person_id'],
      ),
      assetName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_name'],
      ),
      totalAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount_cents'],
      ),
      installmentAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_amount_cents'],
      )!,
      currentInstallment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_installment'],
      )!,
      totalInstallments: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_installments'],
      )!,
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      ),
      startMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_month'],
      )!,
      endMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_month'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      costCenterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cost_center_id'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InstallmentPlansTable createAlias(String alias) {
    return $InstallmentPlansTable(attachedDatabase, alias);
  }
}

class InstallmentPlanRow extends DataClass
    implements Insertable<InstallmentPlanRow> {
  final String id;
  final String householdId;
  final String label;
  final String planKind;
  final String? ownerPersonId;
  final String? assetName;
  final int? totalAmountCents;
  final int installmentAmountCents;
  final int currentInstallment;
  final int totalInstallments;
  final int? dueDay;
  final String startMonth;
  final String? endMonth;
  final String? categoryId;
  final String? costCenterId;
  final bool active;
  final DateTime updatedAt;
  const InstallmentPlanRow({
    required this.id,
    required this.householdId,
    required this.label,
    required this.planKind,
    this.ownerPersonId,
    this.assetName,
    this.totalAmountCents,
    required this.installmentAmountCents,
    required this.currentInstallment,
    required this.totalInstallments,
    this.dueDay,
    required this.startMonth,
    this.endMonth,
    this.categoryId,
    this.costCenterId,
    required this.active,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['label'] = Variable<String>(label);
    map['plan_kind'] = Variable<String>(planKind);
    if (!nullToAbsent || ownerPersonId != null) {
      map['owner_person_id'] = Variable<String>(ownerPersonId);
    }
    if (!nullToAbsent || assetName != null) {
      map['asset_name'] = Variable<String>(assetName);
    }
    if (!nullToAbsent || totalAmountCents != null) {
      map['total_amount_cents'] = Variable<int>(totalAmountCents);
    }
    map['installment_amount_cents'] = Variable<int>(installmentAmountCents);
    map['current_installment'] = Variable<int>(currentInstallment);
    map['total_installments'] = Variable<int>(totalInstallments);
    if (!nullToAbsent || dueDay != null) {
      map['due_day'] = Variable<int>(dueDay);
    }
    map['start_month'] = Variable<String>(startMonth);
    if (!nullToAbsent || endMonth != null) {
      map['end_month'] = Variable<String>(endMonth);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || costCenterId != null) {
      map['cost_center_id'] = Variable<String>(costCenterId);
    }
    map['active'] = Variable<bool>(active);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InstallmentPlansCompanion toCompanion(bool nullToAbsent) {
    return InstallmentPlansCompanion(
      id: Value(id),
      householdId: Value(householdId),
      label: Value(label),
      planKind: Value(planKind),
      ownerPersonId: ownerPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerPersonId),
      assetName: assetName == null && nullToAbsent
          ? const Value.absent()
          : Value(assetName),
      totalAmountCents: totalAmountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmountCents),
      installmentAmountCents: Value(installmentAmountCents),
      currentInstallment: Value(currentInstallment),
      totalInstallments: Value(totalInstallments),
      dueDay: dueDay == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDay),
      startMonth: Value(startMonth),
      endMonth: endMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(endMonth),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      costCenterId: costCenterId == null && nullToAbsent
          ? const Value.absent()
          : Value(costCenterId),
      active: Value(active),
      updatedAt: Value(updatedAt),
    );
  }

  factory InstallmentPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstallmentPlanRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      label: serializer.fromJson<String>(json['label']),
      planKind: serializer.fromJson<String>(json['planKind']),
      ownerPersonId: serializer.fromJson<String?>(json['ownerPersonId']),
      assetName: serializer.fromJson<String?>(json['assetName']),
      totalAmountCents: serializer.fromJson<int?>(json['totalAmountCents']),
      installmentAmountCents: serializer.fromJson<int>(
        json['installmentAmountCents'],
      ),
      currentInstallment: serializer.fromJson<int>(json['currentInstallment']),
      totalInstallments: serializer.fromJson<int>(json['totalInstallments']),
      dueDay: serializer.fromJson<int?>(json['dueDay']),
      startMonth: serializer.fromJson<String>(json['startMonth']),
      endMonth: serializer.fromJson<String?>(json['endMonth']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      costCenterId: serializer.fromJson<String?>(json['costCenterId']),
      active: serializer.fromJson<bool>(json['active']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'label': serializer.toJson<String>(label),
      'planKind': serializer.toJson<String>(planKind),
      'ownerPersonId': serializer.toJson<String?>(ownerPersonId),
      'assetName': serializer.toJson<String?>(assetName),
      'totalAmountCents': serializer.toJson<int?>(totalAmountCents),
      'installmentAmountCents': serializer.toJson<int>(installmentAmountCents),
      'currentInstallment': serializer.toJson<int>(currentInstallment),
      'totalInstallments': serializer.toJson<int>(totalInstallments),
      'dueDay': serializer.toJson<int?>(dueDay),
      'startMonth': serializer.toJson<String>(startMonth),
      'endMonth': serializer.toJson<String?>(endMonth),
      'categoryId': serializer.toJson<String?>(categoryId),
      'costCenterId': serializer.toJson<String?>(costCenterId),
      'active': serializer.toJson<bool>(active),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InstallmentPlanRow copyWith({
    String? id,
    String? householdId,
    String? label,
    String? planKind,
    Value<String?> ownerPersonId = const Value.absent(),
    Value<String?> assetName = const Value.absent(),
    Value<int?> totalAmountCents = const Value.absent(),
    int? installmentAmountCents,
    int? currentInstallment,
    int? totalInstallments,
    Value<int?> dueDay = const Value.absent(),
    String? startMonth,
    Value<String?> endMonth = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> costCenterId = const Value.absent(),
    bool? active,
    DateTime? updatedAt,
  }) => InstallmentPlanRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    label: label ?? this.label,
    planKind: planKind ?? this.planKind,
    ownerPersonId: ownerPersonId.present
        ? ownerPersonId.value
        : this.ownerPersonId,
    assetName: assetName.present ? assetName.value : this.assetName,
    totalAmountCents: totalAmountCents.present
        ? totalAmountCents.value
        : this.totalAmountCents,
    installmentAmountCents:
        installmentAmountCents ?? this.installmentAmountCents,
    currentInstallment: currentInstallment ?? this.currentInstallment,
    totalInstallments: totalInstallments ?? this.totalInstallments,
    dueDay: dueDay.present ? dueDay.value : this.dueDay,
    startMonth: startMonth ?? this.startMonth,
    endMonth: endMonth.present ? endMonth.value : this.endMonth,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    costCenterId: costCenterId.present ? costCenterId.value : this.costCenterId,
    active: active ?? this.active,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InstallmentPlanRow copyWithCompanion(InstallmentPlansCompanion data) {
    return InstallmentPlanRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      label: data.label.present ? data.label.value : this.label,
      planKind: data.planKind.present ? data.planKind.value : this.planKind,
      ownerPersonId: data.ownerPersonId.present
          ? data.ownerPersonId.value
          : this.ownerPersonId,
      assetName: data.assetName.present ? data.assetName.value : this.assetName,
      totalAmountCents: data.totalAmountCents.present
          ? data.totalAmountCents.value
          : this.totalAmountCents,
      installmentAmountCents: data.installmentAmountCents.present
          ? data.installmentAmountCents.value
          : this.installmentAmountCents,
      currentInstallment: data.currentInstallment.present
          ? data.currentInstallment.value
          : this.currentInstallment,
      totalInstallments: data.totalInstallments.present
          ? data.totalInstallments.value
          : this.totalInstallments,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      startMonth: data.startMonth.present
          ? data.startMonth.value
          : this.startMonth,
      endMonth: data.endMonth.present ? data.endMonth.value : this.endMonth,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      costCenterId: data.costCenterId.present
          ? data.costCenterId.value
          : this.costCenterId,
      active: data.active.present ? data.active.value : this.active,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentPlanRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('label: $label, ')
          ..write('planKind: $planKind, ')
          ..write('ownerPersonId: $ownerPersonId, ')
          ..write('assetName: $assetName, ')
          ..write('totalAmountCents: $totalAmountCents, ')
          ..write('installmentAmountCents: $installmentAmountCents, ')
          ..write('currentInstallment: $currentInstallment, ')
          ..write('totalInstallments: $totalInstallments, ')
          ..write('dueDay: $dueDay, ')
          ..write('startMonth: $startMonth, ')
          ..write('endMonth: $endMonth, ')
          ..write('categoryId: $categoryId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('active: $active, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    label,
    planKind,
    ownerPersonId,
    assetName,
    totalAmountCents,
    installmentAmountCents,
    currentInstallment,
    totalInstallments,
    dueDay,
    startMonth,
    endMonth,
    categoryId,
    costCenterId,
    active,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstallmentPlanRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.label == this.label &&
          other.planKind == this.planKind &&
          other.ownerPersonId == this.ownerPersonId &&
          other.assetName == this.assetName &&
          other.totalAmountCents == this.totalAmountCents &&
          other.installmentAmountCents == this.installmentAmountCents &&
          other.currentInstallment == this.currentInstallment &&
          other.totalInstallments == this.totalInstallments &&
          other.dueDay == this.dueDay &&
          other.startMonth == this.startMonth &&
          other.endMonth == this.endMonth &&
          other.categoryId == this.categoryId &&
          other.costCenterId == this.costCenterId &&
          other.active == this.active &&
          other.updatedAt == this.updatedAt);
}

class InstallmentPlansCompanion extends UpdateCompanion<InstallmentPlanRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> label;
  final Value<String> planKind;
  final Value<String?> ownerPersonId;
  final Value<String?> assetName;
  final Value<int?> totalAmountCents;
  final Value<int> installmentAmountCents;
  final Value<int> currentInstallment;
  final Value<int> totalInstallments;
  final Value<int?> dueDay;
  final Value<String> startMonth;
  final Value<String?> endMonth;
  final Value<String?> categoryId;
  final Value<String?> costCenterId;
  final Value<bool> active;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InstallmentPlansCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.label = const Value.absent(),
    this.planKind = const Value.absent(),
    this.ownerPersonId = const Value.absent(),
    this.assetName = const Value.absent(),
    this.totalAmountCents = const Value.absent(),
    this.installmentAmountCents = const Value.absent(),
    this.currentInstallment = const Value.absent(),
    this.totalInstallments = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.startMonth = const Value.absent(),
    this.endMonth = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.active = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstallmentPlansCompanion.insert({
    required String id,
    required String householdId,
    required String label,
    required String planKind,
    this.ownerPersonId = const Value.absent(),
    this.assetName = const Value.absent(),
    this.totalAmountCents = const Value.absent(),
    required int installmentAmountCents,
    required int currentInstallment,
    required int totalInstallments,
    this.dueDay = const Value.absent(),
    required String startMonth,
    this.endMonth = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.active = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       label = Value(label),
       planKind = Value(planKind),
       installmentAmountCents = Value(installmentAmountCents),
       currentInstallment = Value(currentInstallment),
       totalInstallments = Value(totalInstallments),
       startMonth = Value(startMonth),
       updatedAt = Value(updatedAt);
  static Insertable<InstallmentPlanRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? label,
    Expression<String>? planKind,
    Expression<String>? ownerPersonId,
    Expression<String>? assetName,
    Expression<int>? totalAmountCents,
    Expression<int>? installmentAmountCents,
    Expression<int>? currentInstallment,
    Expression<int>? totalInstallments,
    Expression<int>? dueDay,
    Expression<String>? startMonth,
    Expression<String>? endMonth,
    Expression<String>? categoryId,
    Expression<String>? costCenterId,
    Expression<bool>? active,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (label != null) 'label': label,
      if (planKind != null) 'plan_kind': planKind,
      if (ownerPersonId != null) 'owner_person_id': ownerPersonId,
      if (assetName != null) 'asset_name': assetName,
      if (totalAmountCents != null) 'total_amount_cents': totalAmountCents,
      if (installmentAmountCents != null)
        'installment_amount_cents': installmentAmountCents,
      if (currentInstallment != null) 'current_installment': currentInstallment,
      if (totalInstallments != null) 'total_installments': totalInstallments,
      if (dueDay != null) 'due_day': dueDay,
      if (startMonth != null) 'start_month': startMonth,
      if (endMonth != null) 'end_month': endMonth,
      if (categoryId != null) 'category_id': categoryId,
      if (costCenterId != null) 'cost_center_id': costCenterId,
      if (active != null) 'active': active,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstallmentPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? label,
    Value<String>? planKind,
    Value<String?>? ownerPersonId,
    Value<String?>? assetName,
    Value<int?>? totalAmountCents,
    Value<int>? installmentAmountCents,
    Value<int>? currentInstallment,
    Value<int>? totalInstallments,
    Value<int?>? dueDay,
    Value<String>? startMonth,
    Value<String?>? endMonth,
    Value<String?>? categoryId,
    Value<String?>? costCenterId,
    Value<bool>? active,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return InstallmentPlansCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      label: label ?? this.label,
      planKind: planKind ?? this.planKind,
      ownerPersonId: ownerPersonId ?? this.ownerPersonId,
      assetName: assetName ?? this.assetName,
      totalAmountCents: totalAmountCents ?? this.totalAmountCents,
      installmentAmountCents:
          installmentAmountCents ?? this.installmentAmountCents,
      currentInstallment: currentInstallment ?? this.currentInstallment,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      dueDay: dueDay ?? this.dueDay,
      startMonth: startMonth ?? this.startMonth,
      endMonth: endMonth ?? this.endMonth,
      categoryId: categoryId ?? this.categoryId,
      costCenterId: costCenterId ?? this.costCenterId,
      active: active ?? this.active,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (planKind.present) {
      map['plan_kind'] = Variable<String>(planKind.value);
    }
    if (ownerPersonId.present) {
      map['owner_person_id'] = Variable<String>(ownerPersonId.value);
    }
    if (assetName.present) {
      map['asset_name'] = Variable<String>(assetName.value);
    }
    if (totalAmountCents.present) {
      map['total_amount_cents'] = Variable<int>(totalAmountCents.value);
    }
    if (installmentAmountCents.present) {
      map['installment_amount_cents'] = Variable<int>(
        installmentAmountCents.value,
      );
    }
    if (currentInstallment.present) {
      map['current_installment'] = Variable<int>(currentInstallment.value);
    }
    if (totalInstallments.present) {
      map['total_installments'] = Variable<int>(totalInstallments.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (startMonth.present) {
      map['start_month'] = Variable<String>(startMonth.value);
    }
    if (endMonth.present) {
      map['end_month'] = Variable<String>(endMonth.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (costCenterId.present) {
      map['cost_center_id'] = Variable<String>(costCenterId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentPlansCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('label: $label, ')
          ..write('planKind: $planKind, ')
          ..write('ownerPersonId: $ownerPersonId, ')
          ..write('assetName: $assetName, ')
          ..write('totalAmountCents: $totalAmountCents, ')
          ..write('installmentAmountCents: $installmentAmountCents, ')
          ..write('currentInstallment: $currentInstallment, ')
          ..write('totalInstallments: $totalInstallments, ')
          ..write('dueDay: $dueDay, ')
          ..write('startMonth: $startMonth, ')
          ..write('endMonth: $endMonth, ')
          ..write('categoryId: $categoryId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('active: $active, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportBatchesTable extends ImportBatches
    with TableInfo<$ImportBatchesTable, ImportBatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportBatchesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileFormatMeta = const VerificationMeta(
    'fileFormat',
  );
  @override
  late final GeneratedColumn<String> fileFormat = GeneratedColumn<String>(
    'file_format',
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
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalRowsMeta = const VerificationMeta(
    'totalRows',
  );
  @override
  late final GeneratedColumn<int> totalRows = GeneratedColumn<int>(
    'total_rows',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _validRowsMeta = const VerificationMeta(
    'validRows',
  );
  @override
  late final GeneratedColumn<int> validRows = GeneratedColumn<int>(
    'valid_rows',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _invalidRowsMeta = const VerificationMeta(
    'invalidRows',
  );
  @override
  late final GeneratedColumn<int> invalidRows = GeneratedColumn<int>(
    'invalid_rows',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _duplicateRowsMeta = const VerificationMeta(
    'duplicateRows',
  );
  @override
  late final GeneratedColumn<int> duplicateRows = GeneratedColumn<int>(
    'duplicate_rows',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reviewRowsMeta = const VerificationMeta(
    'reviewRows',
  );
  @override
  late final GeneratedColumn<int> reviewRows = GeneratedColumn<int>(
    'review_rows',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('staged'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    fileName,
    fileHash,
    fileFormat,
    provider,
    importedAt,
    totalRows,
    validRows,
    invalidRows,
    duplicateRows,
    reviewRows,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportBatchRow> instance, {
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
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('file_format')) {
      context.handle(
        _fileFormatMeta,
        fileFormat.isAcceptableOrUnknown(data['file_format']!, _fileFormatMeta),
      );
    } else if (isInserting) {
      context.missing(_fileFormatMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('total_rows')) {
      context.handle(
        _totalRowsMeta,
        totalRows.isAcceptableOrUnknown(data['total_rows']!, _totalRowsMeta),
      );
    }
    if (data.containsKey('valid_rows')) {
      context.handle(
        _validRowsMeta,
        validRows.isAcceptableOrUnknown(data['valid_rows']!, _validRowsMeta),
      );
    }
    if (data.containsKey('invalid_rows')) {
      context.handle(
        _invalidRowsMeta,
        invalidRows.isAcceptableOrUnknown(
          data['invalid_rows']!,
          _invalidRowsMeta,
        ),
      );
    }
    if (data.containsKey('duplicate_rows')) {
      context.handle(
        _duplicateRowsMeta,
        duplicateRows.isAcceptableOrUnknown(
          data['duplicate_rows']!,
          _duplicateRowsMeta,
        ),
      );
    }
    if (data.containsKey('review_rows')) {
      context.handle(
        _reviewRowsMeta,
        reviewRows.isAcceptableOrUnknown(data['review_rows']!, _reviewRowsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportBatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportBatchRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      )!,
      fileFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_format'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
      totalRows: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_rows'],
      )!,
      validRows: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valid_rows'],
      )!,
      invalidRows: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invalid_rows'],
      )!,
      duplicateRows: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duplicate_rows'],
      )!,
      reviewRows: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_rows'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $ImportBatchesTable createAlias(String alias) {
    return $ImportBatchesTable(attachedDatabase, alias);
  }
}

class ImportBatchRow extends DataClass implements Insertable<ImportBatchRow> {
  final String id;
  final String householdId;
  final String fileName;
  final String fileHash;
  final String fileFormat;
  final String provider;
  final DateTime importedAt;
  final int totalRows;
  final int validRows;
  final int invalidRows;
  final int duplicateRows;
  final int reviewRows;
  final String status;
  const ImportBatchRow({
    required this.id,
    required this.householdId,
    required this.fileName,
    required this.fileHash,
    required this.fileFormat,
    required this.provider,
    required this.importedAt,
    required this.totalRows,
    required this.validRows,
    required this.invalidRows,
    required this.duplicateRows,
    required this.reviewRows,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['file_name'] = Variable<String>(fileName);
    map['file_hash'] = Variable<String>(fileHash);
    map['file_format'] = Variable<String>(fileFormat);
    map['provider'] = Variable<String>(provider);
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['total_rows'] = Variable<int>(totalRows);
    map['valid_rows'] = Variable<int>(validRows);
    map['invalid_rows'] = Variable<int>(invalidRows);
    map['duplicate_rows'] = Variable<int>(duplicateRows);
    map['review_rows'] = Variable<int>(reviewRows);
    map['status'] = Variable<String>(status);
    return map;
  }

  ImportBatchesCompanion toCompanion(bool nullToAbsent) {
    return ImportBatchesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      fileName: Value(fileName),
      fileHash: Value(fileHash),
      fileFormat: Value(fileFormat),
      provider: Value(provider),
      importedAt: Value(importedAt),
      totalRows: Value(totalRows),
      validRows: Value(validRows),
      invalidRows: Value(invalidRows),
      duplicateRows: Value(duplicateRows),
      reviewRows: Value(reviewRows),
      status: Value(status),
    );
  }

  factory ImportBatchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportBatchRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      fileFormat: serializer.fromJson<String>(json['fileFormat']),
      provider: serializer.fromJson<String>(json['provider']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      totalRows: serializer.fromJson<int>(json['totalRows']),
      validRows: serializer.fromJson<int>(json['validRows']),
      invalidRows: serializer.fromJson<int>(json['invalidRows']),
      duplicateRows: serializer.fromJson<int>(json['duplicateRows']),
      reviewRows: serializer.fromJson<int>(json['reviewRows']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'fileName': serializer.toJson<String>(fileName),
      'fileHash': serializer.toJson<String>(fileHash),
      'fileFormat': serializer.toJson<String>(fileFormat),
      'provider': serializer.toJson<String>(provider),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'totalRows': serializer.toJson<int>(totalRows),
      'validRows': serializer.toJson<int>(validRows),
      'invalidRows': serializer.toJson<int>(invalidRows),
      'duplicateRows': serializer.toJson<int>(duplicateRows),
      'reviewRows': serializer.toJson<int>(reviewRows),
      'status': serializer.toJson<String>(status),
    };
  }

  ImportBatchRow copyWith({
    String? id,
    String? householdId,
    String? fileName,
    String? fileHash,
    String? fileFormat,
    String? provider,
    DateTime? importedAt,
    int? totalRows,
    int? validRows,
    int? invalidRows,
    int? duplicateRows,
    int? reviewRows,
    String? status,
  }) => ImportBatchRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    fileName: fileName ?? this.fileName,
    fileHash: fileHash ?? this.fileHash,
    fileFormat: fileFormat ?? this.fileFormat,
    provider: provider ?? this.provider,
    importedAt: importedAt ?? this.importedAt,
    totalRows: totalRows ?? this.totalRows,
    validRows: validRows ?? this.validRows,
    invalidRows: invalidRows ?? this.invalidRows,
    duplicateRows: duplicateRows ?? this.duplicateRows,
    reviewRows: reviewRows ?? this.reviewRows,
    status: status ?? this.status,
  );
  ImportBatchRow copyWithCompanion(ImportBatchesCompanion data) {
    return ImportBatchRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      fileFormat: data.fileFormat.present
          ? data.fileFormat.value
          : this.fileFormat,
      provider: data.provider.present ? data.provider.value : this.provider,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      totalRows: data.totalRows.present ? data.totalRows.value : this.totalRows,
      validRows: data.validRows.present ? data.validRows.value : this.validRows,
      invalidRows: data.invalidRows.present
          ? data.invalidRows.value
          : this.invalidRows,
      duplicateRows: data.duplicateRows.present
          ? data.duplicateRows.value
          : this.duplicateRows,
      reviewRows: data.reviewRows.present
          ? data.reviewRows.value
          : this.reviewRows,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('fileName: $fileName, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileFormat: $fileFormat, ')
          ..write('provider: $provider, ')
          ..write('importedAt: $importedAt, ')
          ..write('totalRows: $totalRows, ')
          ..write('validRows: $validRows, ')
          ..write('invalidRows: $invalidRows, ')
          ..write('duplicateRows: $duplicateRows, ')
          ..write('reviewRows: $reviewRows, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    fileName,
    fileHash,
    fileFormat,
    provider,
    importedAt,
    totalRows,
    validRows,
    invalidRows,
    duplicateRows,
    reviewRows,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportBatchRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.fileName == this.fileName &&
          other.fileHash == this.fileHash &&
          other.fileFormat == this.fileFormat &&
          other.provider == this.provider &&
          other.importedAt == this.importedAt &&
          other.totalRows == this.totalRows &&
          other.validRows == this.validRows &&
          other.invalidRows == this.invalidRows &&
          other.duplicateRows == this.duplicateRows &&
          other.reviewRows == this.reviewRows &&
          other.status == this.status);
}

class ImportBatchesCompanion extends UpdateCompanion<ImportBatchRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> fileName;
  final Value<String> fileHash;
  final Value<String> fileFormat;
  final Value<String> provider;
  final Value<DateTime> importedAt;
  final Value<int> totalRows;
  final Value<int> validRows;
  final Value<int> invalidRows;
  final Value<int> duplicateRows;
  final Value<int> reviewRows;
  final Value<String> status;
  final Value<int> rowid;
  const ImportBatchesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileFormat = const Value.absent(),
    this.provider = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.totalRows = const Value.absent(),
    this.validRows = const Value.absent(),
    this.invalidRows = const Value.absent(),
    this.duplicateRows = const Value.absent(),
    this.reviewRows = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportBatchesCompanion.insert({
    required String id,
    required String householdId,
    required String fileName,
    required String fileHash,
    required String fileFormat,
    required String provider,
    required DateTime importedAt,
    this.totalRows = const Value.absent(),
    this.validRows = const Value.absent(),
    this.invalidRows = const Value.absent(),
    this.duplicateRows = const Value.absent(),
    this.reviewRows = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       fileName = Value(fileName),
       fileHash = Value(fileHash),
       fileFormat = Value(fileFormat),
       provider = Value(provider),
       importedAt = Value(importedAt);
  static Insertable<ImportBatchRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? fileName,
    Expression<String>? fileHash,
    Expression<String>? fileFormat,
    Expression<String>? provider,
    Expression<DateTime>? importedAt,
    Expression<int>? totalRows,
    Expression<int>? validRows,
    Expression<int>? invalidRows,
    Expression<int>? duplicateRows,
    Expression<int>? reviewRows,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (fileName != null) 'file_name': fileName,
      if (fileHash != null) 'file_hash': fileHash,
      if (fileFormat != null) 'file_format': fileFormat,
      if (provider != null) 'provider': provider,
      if (importedAt != null) 'imported_at': importedAt,
      if (totalRows != null) 'total_rows': totalRows,
      if (validRows != null) 'valid_rows': validRows,
      if (invalidRows != null) 'invalid_rows': invalidRows,
      if (duplicateRows != null) 'duplicate_rows': duplicateRows,
      if (reviewRows != null) 'review_rows': reviewRows,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportBatchesCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? fileName,
    Value<String>? fileHash,
    Value<String>? fileFormat,
    Value<String>? provider,
    Value<DateTime>? importedAt,
    Value<int>? totalRows,
    Value<int>? validRows,
    Value<int>? invalidRows,
    Value<int>? duplicateRows,
    Value<int>? reviewRows,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return ImportBatchesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      fileName: fileName ?? this.fileName,
      fileHash: fileHash ?? this.fileHash,
      fileFormat: fileFormat ?? this.fileFormat,
      provider: provider ?? this.provider,
      importedAt: importedAt ?? this.importedAt,
      totalRows: totalRows ?? this.totalRows,
      validRows: validRows ?? this.validRows,
      invalidRows: invalidRows ?? this.invalidRows,
      duplicateRows: duplicateRows ?? this.duplicateRows,
      reviewRows: reviewRows ?? this.reviewRows,
      status: status ?? this.status,
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
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (fileFormat.present) {
      map['file_format'] = Variable<String>(fileFormat.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (totalRows.present) {
      map['total_rows'] = Variable<int>(totalRows.value);
    }
    if (validRows.present) {
      map['valid_rows'] = Variable<int>(validRows.value);
    }
    if (invalidRows.present) {
      map['invalid_rows'] = Variable<int>(invalidRows.value);
    }
    if (duplicateRows.present) {
      map['duplicate_rows'] = Variable<int>(duplicateRows.value);
    }
    if (reviewRows.present) {
      map['review_rows'] = Variable<int>(reviewRows.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('fileName: $fileName, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileFormat: $fileFormat, ')
          ..write('provider: $provider, ')
          ..write('importedAt: $importedAt, ')
          ..write('totalRows: $totalRows, ')
          ..write('validRows: $validRows, ')
          ..write('invalidRows: $invalidRows, ')
          ..write('duplicateRows: $duplicateRows, ')
          ..write('reviewRows: $reviewRows, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StagedSourceRecordsTable extends StagedSourceRecords
    with TableInfo<$StagedSourceRecordsTable, StagedSourceRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StagedSourceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
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
  static const VerificationMeta _rowIndexMeta = const VerificationMeta(
    'rowIndex',
  );
  @override
  late final GeneratedColumn<int> rowIndex = GeneratedColumn<int>(
    'row_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowHashMeta = const VerificationMeta(
    'rowHash',
  );
  @override
  late final GeneratedColumn<String> rowHash = GeneratedColumn<String>(
    'row_hash',
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
  static const VerificationMeta _descriptionRawMeta = const VerificationMeta(
    'descriptionRaw',
  );
  @override
  late final GeneratedColumn<String> descriptionRaw = GeneratedColumn<String>(
    'description_raw',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _accountHintMeta = const VerificationMeta(
    'accountHint',
  );
  @override
  late final GeneratedColumn<String> accountHint = GeneratedColumn<String>(
    'account_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duplicateOfTransactionIdMeta =
      const VerificationMeta('duplicateOfTransactionId');
  @override
  late final GeneratedColumn<String> duplicateOfTransactionId =
      GeneratedColumn<String>(
        'duplicate_of_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
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
  static const VerificationMeta _promotedAtMeta = const VerificationMeta(
    'promotedAt',
  );
  @override
  late final GeneratedColumn<DateTime> promotedAt = GeneratedColumn<DateTime>(
    'promoted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    batchId,
    householdId,
    sourceKind,
    provider,
    rowIndex,
    rowHash,
    externalId,
    occurredAt,
    postedAt,
    descriptionRaw,
    amountCents,
    currencyCode,
    accountHint,
    status,
    duplicateOfTransactionId,
    errorMessage,
    rawPayloadJson,
    confidence,
    createdAt,
    promotedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staged_source_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<StagedSourceRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
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
    if (data.containsKey('row_index')) {
      context.handle(
        _rowIndexMeta,
        rowIndex.isAcceptableOrUnknown(data['row_index']!, _rowIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIndexMeta);
    }
    if (data.containsKey('row_hash')) {
      context.handle(
        _rowHashMeta,
        rowHash.isAcceptableOrUnknown(data['row_hash']!, _rowHashMeta),
      );
    } else if (isInserting) {
      context.missing(_rowHashMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    }
    if (data.containsKey('posted_at')) {
      context.handle(
        _postedAtMeta,
        postedAt.isAcceptableOrUnknown(data['posted_at']!, _postedAtMeta),
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
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
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
    if (data.containsKey('account_hint')) {
      context.handle(
        _accountHintMeta,
        accountHint.isAcceptableOrUnknown(
          data['account_hint']!,
          _accountHintMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('duplicate_of_transaction_id')) {
      context.handle(
        _duplicateOfTransactionIdMeta,
        duplicateOfTransactionId.isAcceptableOrUnknown(
          data['duplicate_of_transaction_id']!,
          _duplicateOfTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
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
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
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
    if (data.containsKey('promoted_at')) {
      context.handle(
        _promotedAtMeta,
        promotedAt.isAcceptableOrUnknown(data['promoted_at']!, _promotedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StagedSourceRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StagedSourceRecordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      rowIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_index'],
      )!,
      rowHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_hash'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      ),
      postedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}posted_at'],
      ),
      descriptionRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_raw'],
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      accountHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_hint'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      duplicateOfTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duplicate_of_transaction_id'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      rawPayloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_payload_json'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      promotedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}promoted_at'],
      ),
    );
  }

  @override
  $StagedSourceRecordsTable createAlias(String alias) {
    return $StagedSourceRecordsTable(attachedDatabase, alias);
  }
}

class StagedSourceRecordRow extends DataClass
    implements Insertable<StagedSourceRecordRow> {
  final String id;
  final String batchId;
  final String householdId;
  final String sourceKind;
  final String provider;
  final int rowIndex;
  final String rowHash;
  final String? externalId;
  final DateTime? occurredAt;
  final DateTime? postedAt;
  final String? descriptionRaw;
  final int? amountCents;
  final String currencyCode;
  final String? accountHint;
  final String status;
  final String? duplicateOfTransactionId;
  final String? errorMessage;
  final String? rawPayloadJson;
  final double confidence;
  final DateTime createdAt;
  final DateTime? promotedAt;
  const StagedSourceRecordRow({
    required this.id,
    required this.batchId,
    required this.householdId,
    required this.sourceKind,
    required this.provider,
    required this.rowIndex,
    required this.rowHash,
    this.externalId,
    this.occurredAt,
    this.postedAt,
    this.descriptionRaw,
    this.amountCents,
    required this.currencyCode,
    this.accountHint,
    required this.status,
    this.duplicateOfTransactionId,
    this.errorMessage,
    this.rawPayloadJson,
    required this.confidence,
    required this.createdAt,
    this.promotedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['batch_id'] = Variable<String>(batchId);
    map['household_id'] = Variable<String>(householdId);
    map['source_kind'] = Variable<String>(sourceKind);
    map['provider'] = Variable<String>(provider);
    map['row_index'] = Variable<int>(rowIndex);
    map['row_hash'] = Variable<String>(rowHash);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    if (!nullToAbsent || occurredAt != null) {
      map['occurred_at'] = Variable<DateTime>(occurredAt);
    }
    if (!nullToAbsent || postedAt != null) {
      map['posted_at'] = Variable<DateTime>(postedAt);
    }
    if (!nullToAbsent || descriptionRaw != null) {
      map['description_raw'] = Variable<String>(descriptionRaw);
    }
    if (!nullToAbsent || amountCents != null) {
      map['amount_cents'] = Variable<int>(amountCents);
    }
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || accountHint != null) {
      map['account_hint'] = Variable<String>(accountHint);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || duplicateOfTransactionId != null) {
      map['duplicate_of_transaction_id'] = Variable<String>(
        duplicateOfTransactionId,
      );
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || rawPayloadJson != null) {
      map['raw_payload_json'] = Variable<String>(rawPayloadJson);
    }
    map['confidence'] = Variable<double>(confidence);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || promotedAt != null) {
      map['promoted_at'] = Variable<DateTime>(promotedAt);
    }
    return map;
  }

  StagedSourceRecordsCompanion toCompanion(bool nullToAbsent) {
    return StagedSourceRecordsCompanion(
      id: Value(id),
      batchId: Value(batchId),
      householdId: Value(householdId),
      sourceKind: Value(sourceKind),
      provider: Value(provider),
      rowIndex: Value(rowIndex),
      rowHash: Value(rowHash),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      occurredAt: occurredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(occurredAt),
      postedAt: postedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(postedAt),
      descriptionRaw: descriptionRaw == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionRaw),
      amountCents: amountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(amountCents),
      currencyCode: Value(currencyCode),
      accountHint: accountHint == null && nullToAbsent
          ? const Value.absent()
          : Value(accountHint),
      status: Value(status),
      duplicateOfTransactionId: duplicateOfTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(duplicateOfTransactionId),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      rawPayloadJson: rawPayloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rawPayloadJson),
      confidence: Value(confidence),
      createdAt: Value(createdAt),
      promotedAt: promotedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(promotedAt),
    );
  }

  factory StagedSourceRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StagedSourceRecordRow(
      id: serializer.fromJson<String>(json['id']),
      batchId: serializer.fromJson<String>(json['batchId']),
      householdId: serializer.fromJson<String>(json['householdId']),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
      provider: serializer.fromJson<String>(json['provider']),
      rowIndex: serializer.fromJson<int>(json['rowIndex']),
      rowHash: serializer.fromJson<String>(json['rowHash']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      occurredAt: serializer.fromJson<DateTime?>(json['occurredAt']),
      postedAt: serializer.fromJson<DateTime?>(json['postedAt']),
      descriptionRaw: serializer.fromJson<String?>(json['descriptionRaw']),
      amountCents: serializer.fromJson<int?>(json['amountCents']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      accountHint: serializer.fromJson<String?>(json['accountHint']),
      status: serializer.fromJson<String>(json['status']),
      duplicateOfTransactionId: serializer.fromJson<String?>(
        json['duplicateOfTransactionId'],
      ),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      rawPayloadJson: serializer.fromJson<String?>(json['rawPayloadJson']),
      confidence: serializer.fromJson<double>(json['confidence']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      promotedAt: serializer.fromJson<DateTime?>(json['promotedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'batchId': serializer.toJson<String>(batchId),
      'householdId': serializer.toJson<String>(householdId),
      'sourceKind': serializer.toJson<String>(sourceKind),
      'provider': serializer.toJson<String>(provider),
      'rowIndex': serializer.toJson<int>(rowIndex),
      'rowHash': serializer.toJson<String>(rowHash),
      'externalId': serializer.toJson<String?>(externalId),
      'occurredAt': serializer.toJson<DateTime?>(occurredAt),
      'postedAt': serializer.toJson<DateTime?>(postedAt),
      'descriptionRaw': serializer.toJson<String?>(descriptionRaw),
      'amountCents': serializer.toJson<int?>(amountCents),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'accountHint': serializer.toJson<String?>(accountHint),
      'status': serializer.toJson<String>(status),
      'duplicateOfTransactionId': serializer.toJson<String?>(
        duplicateOfTransactionId,
      ),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'rawPayloadJson': serializer.toJson<String?>(rawPayloadJson),
      'confidence': serializer.toJson<double>(confidence),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'promotedAt': serializer.toJson<DateTime?>(promotedAt),
    };
  }

  StagedSourceRecordRow copyWith({
    String? id,
    String? batchId,
    String? householdId,
    String? sourceKind,
    String? provider,
    int? rowIndex,
    String? rowHash,
    Value<String?> externalId = const Value.absent(),
    Value<DateTime?> occurredAt = const Value.absent(),
    Value<DateTime?> postedAt = const Value.absent(),
    Value<String?> descriptionRaw = const Value.absent(),
    Value<int?> amountCents = const Value.absent(),
    String? currencyCode,
    Value<String?> accountHint = const Value.absent(),
    String? status,
    Value<String?> duplicateOfTransactionId = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    Value<String?> rawPayloadJson = const Value.absent(),
    double? confidence,
    DateTime? createdAt,
    Value<DateTime?> promotedAt = const Value.absent(),
  }) => StagedSourceRecordRow(
    id: id ?? this.id,
    batchId: batchId ?? this.batchId,
    householdId: householdId ?? this.householdId,
    sourceKind: sourceKind ?? this.sourceKind,
    provider: provider ?? this.provider,
    rowIndex: rowIndex ?? this.rowIndex,
    rowHash: rowHash ?? this.rowHash,
    externalId: externalId.present ? externalId.value : this.externalId,
    occurredAt: occurredAt.present ? occurredAt.value : this.occurredAt,
    postedAt: postedAt.present ? postedAt.value : this.postedAt,
    descriptionRaw: descriptionRaw.present
        ? descriptionRaw.value
        : this.descriptionRaw,
    amountCents: amountCents.present ? amountCents.value : this.amountCents,
    currencyCode: currencyCode ?? this.currencyCode,
    accountHint: accountHint.present ? accountHint.value : this.accountHint,
    status: status ?? this.status,
    duplicateOfTransactionId: duplicateOfTransactionId.present
        ? duplicateOfTransactionId.value
        : this.duplicateOfTransactionId,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    rawPayloadJson: rawPayloadJson.present
        ? rawPayloadJson.value
        : this.rawPayloadJson,
    confidence: confidence ?? this.confidence,
    createdAt: createdAt ?? this.createdAt,
    promotedAt: promotedAt.present ? promotedAt.value : this.promotedAt,
  );
  StagedSourceRecordRow copyWithCompanion(StagedSourceRecordsCompanion data) {
    return StagedSourceRecordRow(
      id: data.id.present ? data.id.value : this.id,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      provider: data.provider.present ? data.provider.value : this.provider,
      rowIndex: data.rowIndex.present ? data.rowIndex.value : this.rowIndex,
      rowHash: data.rowHash.present ? data.rowHash.value : this.rowHash,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      postedAt: data.postedAt.present ? data.postedAt.value : this.postedAt,
      descriptionRaw: data.descriptionRaw.present
          ? data.descriptionRaw.value
          : this.descriptionRaw,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      accountHint: data.accountHint.present
          ? data.accountHint.value
          : this.accountHint,
      status: data.status.present ? data.status.value : this.status,
      duplicateOfTransactionId: data.duplicateOfTransactionId.present
          ? data.duplicateOfTransactionId.value
          : this.duplicateOfTransactionId,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      rawPayloadJson: data.rawPayloadJson.present
          ? data.rawPayloadJson.value
          : this.rawPayloadJson,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      promotedAt: data.promotedAt.present
          ? data.promotedAt.value
          : this.promotedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StagedSourceRecordRow(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('householdId: $householdId, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('provider: $provider, ')
          ..write('rowIndex: $rowIndex, ')
          ..write('rowHash: $rowHash, ')
          ..write('externalId: $externalId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('postedAt: $postedAt, ')
          ..write('descriptionRaw: $descriptionRaw, ')
          ..write('amountCents: $amountCents, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('accountHint: $accountHint, ')
          ..write('status: $status, ')
          ..write('duplicateOfTransactionId: $duplicateOfTransactionId, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rawPayloadJson: $rawPayloadJson, ')
          ..write('confidence: $confidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('promotedAt: $promotedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    batchId,
    householdId,
    sourceKind,
    provider,
    rowIndex,
    rowHash,
    externalId,
    occurredAt,
    postedAt,
    descriptionRaw,
    amountCents,
    currencyCode,
    accountHint,
    status,
    duplicateOfTransactionId,
    errorMessage,
    rawPayloadJson,
    confidence,
    createdAt,
    promotedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StagedSourceRecordRow &&
          other.id == this.id &&
          other.batchId == this.batchId &&
          other.householdId == this.householdId &&
          other.sourceKind == this.sourceKind &&
          other.provider == this.provider &&
          other.rowIndex == this.rowIndex &&
          other.rowHash == this.rowHash &&
          other.externalId == this.externalId &&
          other.occurredAt == this.occurredAt &&
          other.postedAt == this.postedAt &&
          other.descriptionRaw == this.descriptionRaw &&
          other.amountCents == this.amountCents &&
          other.currencyCode == this.currencyCode &&
          other.accountHint == this.accountHint &&
          other.status == this.status &&
          other.duplicateOfTransactionId == this.duplicateOfTransactionId &&
          other.errorMessage == this.errorMessage &&
          other.rawPayloadJson == this.rawPayloadJson &&
          other.confidence == this.confidence &&
          other.createdAt == this.createdAt &&
          other.promotedAt == this.promotedAt);
}

class StagedSourceRecordsCompanion
    extends UpdateCompanion<StagedSourceRecordRow> {
  final Value<String> id;
  final Value<String> batchId;
  final Value<String> householdId;
  final Value<String> sourceKind;
  final Value<String> provider;
  final Value<int> rowIndex;
  final Value<String> rowHash;
  final Value<String?> externalId;
  final Value<DateTime?> occurredAt;
  final Value<DateTime?> postedAt;
  final Value<String?> descriptionRaw;
  final Value<int?> amountCents;
  final Value<String> currencyCode;
  final Value<String?> accountHint;
  final Value<String> status;
  final Value<String?> duplicateOfTransactionId;
  final Value<String?> errorMessage;
  final Value<String?> rawPayloadJson;
  final Value<double> confidence;
  final Value<DateTime> createdAt;
  final Value<DateTime?> promotedAt;
  final Value<int> rowid;
  const StagedSourceRecordsCompanion({
    this.id = const Value.absent(),
    this.batchId = const Value.absent(),
    this.householdId = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.provider = const Value.absent(),
    this.rowIndex = const Value.absent(),
    this.rowHash = const Value.absent(),
    this.externalId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.descriptionRaw = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.accountHint = const Value.absent(),
    this.status = const Value.absent(),
    this.duplicateOfTransactionId = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rawPayloadJson = const Value.absent(),
    this.confidence = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.promotedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StagedSourceRecordsCompanion.insert({
    required String id,
    required String batchId,
    required String householdId,
    required String sourceKind,
    required String provider,
    required int rowIndex,
    required String rowHash,
    this.externalId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.descriptionRaw = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.accountHint = const Value.absent(),
    required String status,
    this.duplicateOfTransactionId = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rawPayloadJson = const Value.absent(),
    this.confidence = const Value.absent(),
    required DateTime createdAt,
    this.promotedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       batchId = Value(batchId),
       householdId = Value(householdId),
       sourceKind = Value(sourceKind),
       provider = Value(provider),
       rowIndex = Value(rowIndex),
       rowHash = Value(rowHash),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<StagedSourceRecordRow> custom({
    Expression<String>? id,
    Expression<String>? batchId,
    Expression<String>? householdId,
    Expression<String>? sourceKind,
    Expression<String>? provider,
    Expression<int>? rowIndex,
    Expression<String>? rowHash,
    Expression<String>? externalId,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? postedAt,
    Expression<String>? descriptionRaw,
    Expression<int>? amountCents,
    Expression<String>? currencyCode,
    Expression<String>? accountHint,
    Expression<String>? status,
    Expression<String>? duplicateOfTransactionId,
    Expression<String>? errorMessage,
    Expression<String>? rawPayloadJson,
    Expression<double>? confidence,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? promotedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (batchId != null) 'batch_id': batchId,
      if (householdId != null) 'household_id': householdId,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (provider != null) 'provider': provider,
      if (rowIndex != null) 'row_index': rowIndex,
      if (rowHash != null) 'row_hash': rowHash,
      if (externalId != null) 'external_id': externalId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (postedAt != null) 'posted_at': postedAt,
      if (descriptionRaw != null) 'description_raw': descriptionRaw,
      if (amountCents != null) 'amount_cents': amountCents,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (accountHint != null) 'account_hint': accountHint,
      if (status != null) 'status': status,
      if (duplicateOfTransactionId != null)
        'duplicate_of_transaction_id': duplicateOfTransactionId,
      if (errorMessage != null) 'error_message': errorMessage,
      if (rawPayloadJson != null) 'raw_payload_json': rawPayloadJson,
      if (confidence != null) 'confidence': confidence,
      if (createdAt != null) 'created_at': createdAt,
      if (promotedAt != null) 'promoted_at': promotedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StagedSourceRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? batchId,
    Value<String>? householdId,
    Value<String>? sourceKind,
    Value<String>? provider,
    Value<int>? rowIndex,
    Value<String>? rowHash,
    Value<String?>? externalId,
    Value<DateTime?>? occurredAt,
    Value<DateTime?>? postedAt,
    Value<String?>? descriptionRaw,
    Value<int?>? amountCents,
    Value<String>? currencyCode,
    Value<String?>? accountHint,
    Value<String>? status,
    Value<String?>? duplicateOfTransactionId,
    Value<String?>? errorMessage,
    Value<String?>? rawPayloadJson,
    Value<double>? confidence,
    Value<DateTime>? createdAt,
    Value<DateTime?>? promotedAt,
    Value<int>? rowid,
  }) {
    return StagedSourceRecordsCompanion(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      householdId: householdId ?? this.householdId,
      sourceKind: sourceKind ?? this.sourceKind,
      provider: provider ?? this.provider,
      rowIndex: rowIndex ?? this.rowIndex,
      rowHash: rowHash ?? this.rowHash,
      externalId: externalId ?? this.externalId,
      occurredAt: occurredAt ?? this.occurredAt,
      postedAt: postedAt ?? this.postedAt,
      descriptionRaw: descriptionRaw ?? this.descriptionRaw,
      amountCents: amountCents ?? this.amountCents,
      currencyCode: currencyCode ?? this.currencyCode,
      accountHint: accountHint ?? this.accountHint,
      status: status ?? this.status,
      duplicateOfTransactionId:
          duplicateOfTransactionId ?? this.duplicateOfTransactionId,
      errorMessage: errorMessage ?? this.errorMessage,
      rawPayloadJson: rawPayloadJson ?? this.rawPayloadJson,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      promotedAt: promotedAt ?? this.promotedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (rowIndex.present) {
      map['row_index'] = Variable<int>(rowIndex.value);
    }
    if (rowHash.present) {
      map['row_hash'] = Variable<String>(rowHash.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (postedAt.present) {
      map['posted_at'] = Variable<DateTime>(postedAt.value);
    }
    if (descriptionRaw.present) {
      map['description_raw'] = Variable<String>(descriptionRaw.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (accountHint.present) {
      map['account_hint'] = Variable<String>(accountHint.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (duplicateOfTransactionId.present) {
      map['duplicate_of_transaction_id'] = Variable<String>(
        duplicateOfTransactionId.value,
      );
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (rawPayloadJson.present) {
      map['raw_payload_json'] = Variable<String>(rawPayloadJson.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (promotedAt.present) {
      map['promoted_at'] = Variable<DateTime>(promotedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StagedSourceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('householdId: $householdId, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('provider: $provider, ')
          ..write('rowIndex: $rowIndex, ')
          ..write('rowHash: $rowHash, ')
          ..write('externalId: $externalId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('postedAt: $postedAt, ')
          ..write('descriptionRaw: $descriptionRaw, ')
          ..write('amountCents: $amountCents, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('accountHint: $accountHint, ')
          ..write('status: $status, ')
          ..write('duplicateOfTransactionId: $duplicateOfTransactionId, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rawPayloadJson: $rawPayloadJson, ')
          ..write('confidence: $confidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('promotedAt: $promotedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DuplicateCandidatesTable extends DuplicateCandidates
    with TableInfo<$DuplicateCandidatesTable, DuplicateCandidateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuplicateCandidatesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _candidateTransactionIdMeta =
      const VerificationMeta('candidateTransactionId');
  @override
  late final GeneratedColumn<String> candidateTransactionId =
      GeneratedColumn<String>(
        'candidate_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _stagedSourceRecordIdMeta =
      const VerificationMeta('stagedSourceRecordId');
  @override
  late final GeneratedColumn<String> stagedSourceRecordId =
      GeneratedColumn<String>(
        'staged_source_record_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
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
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
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
    candidateTransactionId,
    stagedSourceRecordId,
    score,
    status,
    reason,
    explanation,
    createdAt,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'duplicate_candidates';
  @override
  VerificationContext validateIntegrity(
    Insertable<DuplicateCandidateRow> instance, {
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
    if (data.containsKey('candidate_transaction_id')) {
      context.handle(
        _candidateTransactionIdMeta,
        candidateTransactionId.isAcceptableOrUnknown(
          data['candidate_transaction_id']!,
          _candidateTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('staged_source_record_id')) {
      context.handle(
        _stagedSourceRecordIdMeta,
        stagedSourceRecordId.isAcceptableOrUnknown(
          data['staged_source_record_id']!,
          _stagedSourceRecordIdMeta,
        ),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
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
  DuplicateCandidateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DuplicateCandidateRow(
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
      candidateTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidate_transaction_id'],
      ),
      stagedSourceRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staged_source_record_id'],
      ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
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
  $DuplicateCandidatesTable createAlias(String alias) {
    return $DuplicateCandidatesTable(attachedDatabase, alias);
  }
}

class DuplicateCandidateRow extends DataClass
    implements Insertable<DuplicateCandidateRow> {
  final String id;
  final String householdId;
  final String transactionId;
  final String? candidateTransactionId;
  final String? stagedSourceRecordId;
  final double score;
  final String status;
  final String reason;
  final String explanation;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  const DuplicateCandidateRow({
    required this.id,
    required this.householdId,
    required this.transactionId,
    this.candidateTransactionId,
    this.stagedSourceRecordId,
    required this.score,
    required this.status,
    required this.reason,
    required this.explanation,
    required this.createdAt,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['transaction_id'] = Variable<String>(transactionId);
    if (!nullToAbsent || candidateTransactionId != null) {
      map['candidate_transaction_id'] = Variable<String>(
        candidateTransactionId,
      );
    }
    if (!nullToAbsent || stagedSourceRecordId != null) {
      map['staged_source_record_id'] = Variable<String>(stagedSourceRecordId);
    }
    map['score'] = Variable<double>(score);
    map['status'] = Variable<String>(status);
    map['reason'] = Variable<String>(reason);
    map['explanation'] = Variable<String>(explanation);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  DuplicateCandidatesCompanion toCompanion(bool nullToAbsent) {
    return DuplicateCandidatesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      transactionId: Value(transactionId),
      candidateTransactionId: candidateTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(candidateTransactionId),
      stagedSourceRecordId: stagedSourceRecordId == null && nullToAbsent
          ? const Value.absent()
          : Value(stagedSourceRecordId),
      score: Value(score),
      status: Value(status),
      reason: Value(reason),
      explanation: Value(explanation),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory DuplicateCandidateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DuplicateCandidateRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      candidateTransactionId: serializer.fromJson<String?>(
        json['candidateTransactionId'],
      ),
      stagedSourceRecordId: serializer.fromJson<String?>(
        json['stagedSourceRecordId'],
      ),
      score: serializer.fromJson<double>(json['score']),
      status: serializer.fromJson<String>(json['status']),
      reason: serializer.fromJson<String>(json['reason']),
      explanation: serializer.fromJson<String>(json['explanation']),
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
      'candidateTransactionId': serializer.toJson<String?>(
        candidateTransactionId,
      ),
      'stagedSourceRecordId': serializer.toJson<String?>(stagedSourceRecordId),
      'score': serializer.toJson<double>(score),
      'status': serializer.toJson<String>(status),
      'reason': serializer.toJson<String>(reason),
      'explanation': serializer.toJson<String>(explanation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  DuplicateCandidateRow copyWith({
    String? id,
    String? householdId,
    String? transactionId,
    Value<String?> candidateTransactionId = const Value.absent(),
    Value<String?> stagedSourceRecordId = const Value.absent(),
    double? score,
    String? status,
    String? reason,
    String? explanation,
    DateTime? createdAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
  }) => DuplicateCandidateRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    transactionId: transactionId ?? this.transactionId,
    candidateTransactionId: candidateTransactionId.present
        ? candidateTransactionId.value
        : this.candidateTransactionId,
    stagedSourceRecordId: stagedSourceRecordId.present
        ? stagedSourceRecordId.value
        : this.stagedSourceRecordId,
    score: score ?? this.score,
    status: status ?? this.status,
    reason: reason ?? this.reason,
    explanation: explanation ?? this.explanation,
    createdAt: createdAt ?? this.createdAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  DuplicateCandidateRow copyWithCompanion(DuplicateCandidatesCompanion data) {
    return DuplicateCandidateRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      candidateTransactionId: data.candidateTransactionId.present
          ? data.candidateTransactionId.value
          : this.candidateTransactionId,
      stagedSourceRecordId: data.stagedSourceRecordId.present
          ? data.stagedSourceRecordId.value
          : this.stagedSourceRecordId,
      score: data.score.present ? data.score.value : this.score,
      status: data.status.present ? data.status.value : this.status,
      reason: data.reason.present ? data.reason.value : this.reason,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DuplicateCandidateRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('transactionId: $transactionId, ')
          ..write('candidateTransactionId: $candidateTransactionId, ')
          ..write('stagedSourceRecordId: $stagedSourceRecordId, ')
          ..write('score: $score, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('explanation: $explanation, ')
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
    candidateTransactionId,
    stagedSourceRecordId,
    score,
    status,
    reason,
    explanation,
    createdAt,
    resolvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DuplicateCandidateRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.transactionId == this.transactionId &&
          other.candidateTransactionId == this.candidateTransactionId &&
          other.stagedSourceRecordId == this.stagedSourceRecordId &&
          other.score == this.score &&
          other.status == this.status &&
          other.reason == this.reason &&
          other.explanation == this.explanation &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt);
}

class DuplicateCandidatesCompanion
    extends UpdateCompanion<DuplicateCandidateRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> transactionId;
  final Value<String?> candidateTransactionId;
  final Value<String?> stagedSourceRecordId;
  final Value<double> score;
  final Value<String> status;
  final Value<String> reason;
  final Value<String> explanation;
  final Value<DateTime> createdAt;
  final Value<DateTime?> resolvedAt;
  final Value<int> rowid;
  const DuplicateCandidatesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.candidateTransactionId = const Value.absent(),
    this.stagedSourceRecordId = const Value.absent(),
    this.score = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.explanation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DuplicateCandidatesCompanion.insert({
    required String id,
    required String householdId,
    required String transactionId,
    this.candidateTransactionId = const Value.absent(),
    this.stagedSourceRecordId = const Value.absent(),
    required double score,
    this.status = const Value.absent(),
    required String reason,
    required String explanation,
    required DateTime createdAt,
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       transactionId = Value(transactionId),
       score = Value(score),
       reason = Value(reason),
       explanation = Value(explanation),
       createdAt = Value(createdAt);
  static Insertable<DuplicateCandidateRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? transactionId,
    Expression<String>? candidateTransactionId,
    Expression<String>? stagedSourceRecordId,
    Expression<double>? score,
    Expression<String>? status,
    Expression<String>? reason,
    Expression<String>? explanation,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? resolvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (candidateTransactionId != null)
        'candidate_transaction_id': candidateTransactionId,
      if (stagedSourceRecordId != null)
        'staged_source_record_id': stagedSourceRecordId,
      if (score != null) 'score': score,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (explanation != null) 'explanation': explanation,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DuplicateCandidatesCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? transactionId,
    Value<String?>? candidateTransactionId,
    Value<String?>? stagedSourceRecordId,
    Value<double>? score,
    Value<String>? status,
    Value<String>? reason,
    Value<String>? explanation,
    Value<DateTime>? createdAt,
    Value<DateTime?>? resolvedAt,
    Value<int>? rowid,
  }) {
    return DuplicateCandidatesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      transactionId: transactionId ?? this.transactionId,
      candidateTransactionId:
          candidateTransactionId ?? this.candidateTransactionId,
      stagedSourceRecordId: stagedSourceRecordId ?? this.stagedSourceRecordId,
      score: score ?? this.score,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      explanation: explanation ?? this.explanation,
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
    if (candidateTransactionId.present) {
      map['candidate_transaction_id'] = Variable<String>(
        candidateTransactionId.value,
      );
    }
    if (stagedSourceRecordId.present) {
      map['staged_source_record_id'] = Variable<String>(
        stagedSourceRecordId.value,
      );
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
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
    return (StringBuffer('DuplicateCandidatesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('transactionId: $transactionId, ')
          ..write('candidateTransactionId: $candidateTransactionId, ')
          ..write('stagedSourceRecordId: $stagedSourceRecordId, ')
          ..write('score: $score, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('explanation: $explanation, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RawNotificationEventsTable extends RawNotificationEvents
    with TableInfo<$RawNotificationEventsTable, RawNotificationEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawNotificationEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _platformEventIdMeta = const VerificationMeta(
    'platformEventId',
  );
  @override
  late final GeneratedColumn<String> platformEventId = GeneratedColumn<String>(
    'platform_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appLabelMeta = const VerificationMeta(
    'appLabel',
  );
  @override
  late final GeneratedColumn<String> appLabel = GeneratedColumn<String>(
    'app_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyTextMeta = const VerificationMeta(
    'bodyText',
  );
  @override
  late final GeneratedColumn<String> bodyText = GeneratedColumn<String>(
    'body_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bigTextMeta = const VerificationMeta(
    'bigText',
  );
  @override
  late final GeneratedColumn<String> bigText = GeneratedColumn<String>(
    'big_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postedAtMeta = const VerificationMeta(
    'postedAt',
  );
  @override
  late final GeneratedColumn<DateTime> postedAt = GeneratedColumn<DateTime>(
    'posted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('captured'),
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
  static const VerificationMeta _draftTransactionIdMeta =
      const VerificationMeta('draftTransactionId');
  @override
  late final GeneratedColumn<String> draftTransactionId =
      GeneratedColumn<String>(
        'draft_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _processedAtMeta = const VerificationMeta(
    'processedAt',
  );
  @override
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
    'processed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    platformEventId,
    packageName,
    appLabel,
    title,
    bodyText,
    bigText,
    notificationId,
    tag,
    postedAt,
    capturedAt,
    status,
    rawPayloadJson,
    draftTransactionId,
    errorMessage,
    processedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_notification_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawNotificationEventRow> instance, {
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
    if (data.containsKey('platform_event_id')) {
      context.handle(
        _platformEventIdMeta,
        platformEventId.isAcceptableOrUnknown(
          data['platform_event_id']!,
          _platformEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_platformEventIdMeta);
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('app_label')) {
      context.handle(
        _appLabelMeta,
        appLabel.isAcceptableOrUnknown(data['app_label']!, _appLabelMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body_text')) {
      context.handle(
        _bodyTextMeta,
        bodyText.isAcceptableOrUnknown(data['body_text']!, _bodyTextMeta),
      );
    }
    if (data.containsKey('big_text')) {
      context.handle(
        _bigTextMeta,
        bigText.isAcceptableOrUnknown(data['big_text']!, _bigTextMeta),
      );
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    }
    if (data.containsKey('posted_at')) {
      context.handle(
        _postedAtMeta,
        postedAt.isAcceptableOrUnknown(data['posted_at']!, _postedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_postedAtMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
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
    if (data.containsKey('draft_transaction_id')) {
      context.handle(
        _draftTransactionIdMeta,
        draftTransactionId.isAcceptableOrUnknown(
          data['draft_transaction_id']!,
          _draftTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('processed_at')) {
      context.handle(
        _processedAtMeta,
        processedAt.isAcceptableOrUnknown(
          data['processed_at']!,
          _processedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RawNotificationEventRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawNotificationEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      platformEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_event_id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      appLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_label'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      bodyText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_text'],
      ),
      bigText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}big_text'],
      ),
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      ),
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      ),
      postedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}posted_at'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      rawPayloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_payload_json'],
      ),
      draftTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}draft_transaction_id'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      processedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}processed_at'],
      ),
    );
  }

  @override
  $RawNotificationEventsTable createAlias(String alias) {
    return $RawNotificationEventsTable(attachedDatabase, alias);
  }
}

class RawNotificationEventRow extends DataClass
    implements Insertable<RawNotificationEventRow> {
  final String id;
  final String householdId;
  final String platformEventId;
  final String packageName;
  final String? appLabel;
  final String? title;
  final String? bodyText;
  final String? bigText;
  final int? notificationId;
  final String? tag;
  final DateTime postedAt;
  final DateTime capturedAt;
  final String status;
  final String? rawPayloadJson;
  final String? draftTransactionId;
  final String? errorMessage;
  final DateTime? processedAt;
  const RawNotificationEventRow({
    required this.id,
    required this.householdId,
    required this.platformEventId,
    required this.packageName,
    this.appLabel,
    this.title,
    this.bodyText,
    this.bigText,
    this.notificationId,
    this.tag,
    required this.postedAt,
    required this.capturedAt,
    required this.status,
    this.rawPayloadJson,
    this.draftTransactionId,
    this.errorMessage,
    this.processedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['platform_event_id'] = Variable<String>(platformEventId);
    map['package_name'] = Variable<String>(packageName);
    if (!nullToAbsent || appLabel != null) {
      map['app_label'] = Variable<String>(appLabel);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || bodyText != null) {
      map['body_text'] = Variable<String>(bodyText);
    }
    if (!nullToAbsent || bigText != null) {
      map['big_text'] = Variable<String>(bigText);
    }
    if (!nullToAbsent || notificationId != null) {
      map['notification_id'] = Variable<int>(notificationId);
    }
    if (!nullToAbsent || tag != null) {
      map['tag'] = Variable<String>(tag);
    }
    map['posted_at'] = Variable<DateTime>(postedAt);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || rawPayloadJson != null) {
      map['raw_payload_json'] = Variable<String>(rawPayloadJson);
    }
    if (!nullToAbsent || draftTransactionId != null) {
      map['draft_transaction_id'] = Variable<String>(draftTransactionId);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || processedAt != null) {
      map['processed_at'] = Variable<DateTime>(processedAt);
    }
    return map;
  }

  RawNotificationEventsCompanion toCompanion(bool nullToAbsent) {
    return RawNotificationEventsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      platformEventId: Value(platformEventId),
      packageName: Value(packageName),
      appLabel: appLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(appLabel),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      bodyText: bodyText == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyText),
      bigText: bigText == null && nullToAbsent
          ? const Value.absent()
          : Value(bigText),
      notificationId: notificationId == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationId),
      tag: tag == null && nullToAbsent ? const Value.absent() : Value(tag),
      postedAt: Value(postedAt),
      capturedAt: Value(capturedAt),
      status: Value(status),
      rawPayloadJson: rawPayloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rawPayloadJson),
      draftTransactionId: draftTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(draftTransactionId),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      processedAt: processedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(processedAt),
    );
  }

  factory RawNotificationEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawNotificationEventRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      platformEventId: serializer.fromJson<String>(json['platformEventId']),
      packageName: serializer.fromJson<String>(json['packageName']),
      appLabel: serializer.fromJson<String?>(json['appLabel']),
      title: serializer.fromJson<String?>(json['title']),
      bodyText: serializer.fromJson<String?>(json['bodyText']),
      bigText: serializer.fromJson<String?>(json['bigText']),
      notificationId: serializer.fromJson<int?>(json['notificationId']),
      tag: serializer.fromJson<String?>(json['tag']),
      postedAt: serializer.fromJson<DateTime>(json['postedAt']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      status: serializer.fromJson<String>(json['status']),
      rawPayloadJson: serializer.fromJson<String?>(json['rawPayloadJson']),
      draftTransactionId: serializer.fromJson<String?>(
        json['draftTransactionId'],
      ),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      processedAt: serializer.fromJson<DateTime?>(json['processedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'platformEventId': serializer.toJson<String>(platformEventId),
      'packageName': serializer.toJson<String>(packageName),
      'appLabel': serializer.toJson<String?>(appLabel),
      'title': serializer.toJson<String?>(title),
      'bodyText': serializer.toJson<String?>(bodyText),
      'bigText': serializer.toJson<String?>(bigText),
      'notificationId': serializer.toJson<int?>(notificationId),
      'tag': serializer.toJson<String?>(tag),
      'postedAt': serializer.toJson<DateTime>(postedAt),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'status': serializer.toJson<String>(status),
      'rawPayloadJson': serializer.toJson<String?>(rawPayloadJson),
      'draftTransactionId': serializer.toJson<String?>(draftTransactionId),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'processedAt': serializer.toJson<DateTime?>(processedAt),
    };
  }

  RawNotificationEventRow copyWith({
    String? id,
    String? householdId,
    String? platformEventId,
    String? packageName,
    Value<String?> appLabel = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> bodyText = const Value.absent(),
    Value<String?> bigText = const Value.absent(),
    Value<int?> notificationId = const Value.absent(),
    Value<String?> tag = const Value.absent(),
    DateTime? postedAt,
    DateTime? capturedAt,
    String? status,
    Value<String?> rawPayloadJson = const Value.absent(),
    Value<String?> draftTransactionId = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    Value<DateTime?> processedAt = const Value.absent(),
  }) => RawNotificationEventRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    platformEventId: platformEventId ?? this.platformEventId,
    packageName: packageName ?? this.packageName,
    appLabel: appLabel.present ? appLabel.value : this.appLabel,
    title: title.present ? title.value : this.title,
    bodyText: bodyText.present ? bodyText.value : this.bodyText,
    bigText: bigText.present ? bigText.value : this.bigText,
    notificationId: notificationId.present
        ? notificationId.value
        : this.notificationId,
    tag: tag.present ? tag.value : this.tag,
    postedAt: postedAt ?? this.postedAt,
    capturedAt: capturedAt ?? this.capturedAt,
    status: status ?? this.status,
    rawPayloadJson: rawPayloadJson.present
        ? rawPayloadJson.value
        : this.rawPayloadJson,
    draftTransactionId: draftTransactionId.present
        ? draftTransactionId.value
        : this.draftTransactionId,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    processedAt: processedAt.present ? processedAt.value : this.processedAt,
  );
  RawNotificationEventRow copyWithCompanion(
    RawNotificationEventsCompanion data,
  ) {
    return RawNotificationEventRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      platformEventId: data.platformEventId.present
          ? data.platformEventId.value
          : this.platformEventId,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      appLabel: data.appLabel.present ? data.appLabel.value : this.appLabel,
      title: data.title.present ? data.title.value : this.title,
      bodyText: data.bodyText.present ? data.bodyText.value : this.bodyText,
      bigText: data.bigText.present ? data.bigText.value : this.bigText,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      tag: data.tag.present ? data.tag.value : this.tag,
      postedAt: data.postedAt.present ? data.postedAt.value : this.postedAt,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      status: data.status.present ? data.status.value : this.status,
      rawPayloadJson: data.rawPayloadJson.present
          ? data.rawPayloadJson.value
          : this.rawPayloadJson,
      draftTransactionId: data.draftTransactionId.present
          ? data.draftTransactionId.value
          : this.draftTransactionId,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      processedAt: data.processedAt.present
          ? data.processedAt.value
          : this.processedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawNotificationEventRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('platformEventId: $platformEventId, ')
          ..write('packageName: $packageName, ')
          ..write('appLabel: $appLabel, ')
          ..write('title: $title, ')
          ..write('bodyText: $bodyText, ')
          ..write('bigText: $bigText, ')
          ..write('notificationId: $notificationId, ')
          ..write('tag: $tag, ')
          ..write('postedAt: $postedAt, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('status: $status, ')
          ..write('rawPayloadJson: $rawPayloadJson, ')
          ..write('draftTransactionId: $draftTransactionId, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('processedAt: $processedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    platformEventId,
    packageName,
    appLabel,
    title,
    bodyText,
    bigText,
    notificationId,
    tag,
    postedAt,
    capturedAt,
    status,
    rawPayloadJson,
    draftTransactionId,
    errorMessage,
    processedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawNotificationEventRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.platformEventId == this.platformEventId &&
          other.packageName == this.packageName &&
          other.appLabel == this.appLabel &&
          other.title == this.title &&
          other.bodyText == this.bodyText &&
          other.bigText == this.bigText &&
          other.notificationId == this.notificationId &&
          other.tag == this.tag &&
          other.postedAt == this.postedAt &&
          other.capturedAt == this.capturedAt &&
          other.status == this.status &&
          other.rawPayloadJson == this.rawPayloadJson &&
          other.draftTransactionId == this.draftTransactionId &&
          other.errorMessage == this.errorMessage &&
          other.processedAt == this.processedAt);
}

class RawNotificationEventsCompanion
    extends UpdateCompanion<RawNotificationEventRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> platformEventId;
  final Value<String> packageName;
  final Value<String?> appLabel;
  final Value<String?> title;
  final Value<String?> bodyText;
  final Value<String?> bigText;
  final Value<int?> notificationId;
  final Value<String?> tag;
  final Value<DateTime> postedAt;
  final Value<DateTime> capturedAt;
  final Value<String> status;
  final Value<String?> rawPayloadJson;
  final Value<String?> draftTransactionId;
  final Value<String?> errorMessage;
  final Value<DateTime?> processedAt;
  final Value<int> rowid;
  const RawNotificationEventsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.platformEventId = const Value.absent(),
    this.packageName = const Value.absent(),
    this.appLabel = const Value.absent(),
    this.title = const Value.absent(),
    this.bodyText = const Value.absent(),
    this.bigText = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.tag = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rawPayloadJson = const Value.absent(),
    this.draftTransactionId = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RawNotificationEventsCompanion.insert({
    required String id,
    required String householdId,
    required String platformEventId,
    required String packageName,
    this.appLabel = const Value.absent(),
    this.title = const Value.absent(),
    this.bodyText = const Value.absent(),
    this.bigText = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.tag = const Value.absent(),
    required DateTime postedAt,
    required DateTime capturedAt,
    this.status = const Value.absent(),
    this.rawPayloadJson = const Value.absent(),
    this.draftTransactionId = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       platformEventId = Value(platformEventId),
       packageName = Value(packageName),
       postedAt = Value(postedAt),
       capturedAt = Value(capturedAt);
  static Insertable<RawNotificationEventRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? platformEventId,
    Expression<String>? packageName,
    Expression<String>? appLabel,
    Expression<String>? title,
    Expression<String>? bodyText,
    Expression<String>? bigText,
    Expression<int>? notificationId,
    Expression<String>? tag,
    Expression<DateTime>? postedAt,
    Expression<DateTime>? capturedAt,
    Expression<String>? status,
    Expression<String>? rawPayloadJson,
    Expression<String>? draftTransactionId,
    Expression<String>? errorMessage,
    Expression<DateTime>? processedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (platformEventId != null) 'platform_event_id': platformEventId,
      if (packageName != null) 'package_name': packageName,
      if (appLabel != null) 'app_label': appLabel,
      if (title != null) 'title': title,
      if (bodyText != null) 'body_text': bodyText,
      if (bigText != null) 'big_text': bigText,
      if (notificationId != null) 'notification_id': notificationId,
      if (tag != null) 'tag': tag,
      if (postedAt != null) 'posted_at': postedAt,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (status != null) 'status': status,
      if (rawPayloadJson != null) 'raw_payload_json': rawPayloadJson,
      if (draftTransactionId != null)
        'draft_transaction_id': draftTransactionId,
      if (errorMessage != null) 'error_message': errorMessage,
      if (processedAt != null) 'processed_at': processedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RawNotificationEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? platformEventId,
    Value<String>? packageName,
    Value<String?>? appLabel,
    Value<String?>? title,
    Value<String?>? bodyText,
    Value<String?>? bigText,
    Value<int?>? notificationId,
    Value<String?>? tag,
    Value<DateTime>? postedAt,
    Value<DateTime>? capturedAt,
    Value<String>? status,
    Value<String?>? rawPayloadJson,
    Value<String?>? draftTransactionId,
    Value<String?>? errorMessage,
    Value<DateTime?>? processedAt,
    Value<int>? rowid,
  }) {
    return RawNotificationEventsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      platformEventId: platformEventId ?? this.platformEventId,
      packageName: packageName ?? this.packageName,
      appLabel: appLabel ?? this.appLabel,
      title: title ?? this.title,
      bodyText: bodyText ?? this.bodyText,
      bigText: bigText ?? this.bigText,
      notificationId: notificationId ?? this.notificationId,
      tag: tag ?? this.tag,
      postedAt: postedAt ?? this.postedAt,
      capturedAt: capturedAt ?? this.capturedAt,
      status: status ?? this.status,
      rawPayloadJson: rawPayloadJson ?? this.rawPayloadJson,
      draftTransactionId: draftTransactionId ?? this.draftTransactionId,
      errorMessage: errorMessage ?? this.errorMessage,
      processedAt: processedAt ?? this.processedAt,
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
    if (platformEventId.present) {
      map['platform_event_id'] = Variable<String>(platformEventId.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (appLabel.present) {
      map['app_label'] = Variable<String>(appLabel.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (bodyText.present) {
      map['body_text'] = Variable<String>(bodyText.value);
    }
    if (bigText.present) {
      map['big_text'] = Variable<String>(bigText.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (postedAt.present) {
      map['posted_at'] = Variable<DateTime>(postedAt.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rawPayloadJson.present) {
      map['raw_payload_json'] = Variable<String>(rawPayloadJson.value);
    }
    if (draftTransactionId.present) {
      map['draft_transaction_id'] = Variable<String>(draftTransactionId.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawNotificationEventsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('platformEventId: $platformEventId, ')
          ..write('packageName: $packageName, ')
          ..write('appLabel: $appLabel, ')
          ..write('title: $title, ')
          ..write('bodyText: $bodyText, ')
          ..write('bigText: $bigText, ')
          ..write('notificationId: $notificationId, ')
          ..write('tag: $tag, ')
          ..write('postedAt: $postedAt, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('status: $status, ')
          ..write('rawPayloadJson: $rawPayloadJson, ')
          ..write('draftTransactionId: $draftTransactionId, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('processedAt: $processedAt, ')
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
  late final $ClassificationRulesTable classificationRules =
      $ClassificationRulesTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $AppPreferencesTable appPreferences = $AppPreferencesTable(this);
  late final $AuthUsersTable authUsers = $AuthUsersTable(this);
  late final $RecurringSchedulesTable recurringSchedules =
      $RecurringSchedulesTable(this);
  late final $InstallmentPlansTable installmentPlans = $InstallmentPlansTable(
    this,
  );
  late final $ImportBatchesTable importBatches = $ImportBatchesTable(this);
  late final $StagedSourceRecordsTable stagedSourceRecords =
      $StagedSourceRecordsTable(this);
  late final $DuplicateCandidatesTable duplicateCandidates =
      $DuplicateCandidatesTable(this);
  late final $RawNotificationEventsTable rawNotificationEvents =
      $RawNotificationEventsTable(this);
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
    classificationRules,
    syncOutbox,
    appPreferences,
    authUsers,
    recurringSchedules,
    installmentPlans,
    importBatches,
    stagedSourceRecords,
    duplicateCandidates,
    rawNotificationEvents,
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
      Value<String?> ownerPersonId,
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
      Value<String?> ownerPersonId,
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

  ColumnFilters<String> get ownerPersonId => $composableBuilder(
    column: $table.ownerPersonId,
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

  ColumnOrderings<String> get ownerPersonId => $composableBuilder(
    column: $table.ownerPersonId,
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

  GeneratedColumn<String> get ownerPersonId => $composableBuilder(
    column: $table.ownerPersonId,
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
                Value<String?> ownerPersonId = const Value.absent(),
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
                ownerPersonId: ownerPersonId,
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
                Value<String?> ownerPersonId = const Value.absent(),
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
                ownerPersonId: ownerPersonId,
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
      Value<String?> accountId,
      Value<String?> ownerPersonId,
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
      Value<String?> accountId,
      Value<String?> ownerPersonId,
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerPersonId => $composableBuilder(
    column: $table.ownerPersonId,
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerPersonId => $composableBuilder(
    column: $table.ownerPersonId,
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

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get ownerPersonId => $composableBuilder(
    column: $table.ownerPersonId,
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
                Value<String?> accountId = const Value.absent(),
                Value<String?> ownerPersonId = const Value.absent(),
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
                accountId: accountId,
                ownerPersonId: ownerPersonId,
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
                Value<String?> accountId = const Value.absent(),
                Value<String?> ownerPersonId = const Value.absent(),
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
                accountId: accountId,
                ownerPersonId: ownerPersonId,
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
      Value<bool> active,
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
      Value<bool> active,
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

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
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

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
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

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
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
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                householdId: householdId,
                parentId: parentId,
                name: name,
                kind: kind,
                sortOrder: sortOrder,
                active: active,
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
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                householdId: householdId,
                parentId: parentId,
                name: name,
                kind: kind,
                sortOrder: sortOrder,
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
      Value<String?> transferFromAccountId,
      Value<String?> transferToAccountId,
      Value<String?> recurringScheduleId,
      Value<String?> installmentPlanId,
      Value<String?> merchantId,
      Value<String?> categoryId,
      Value<String?> costCenterId,
      Value<String?> payerId,
      Value<String?> appliedRuleId,
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
      Value<String?> transferFromAccountId,
      Value<String?> transferToAccountId,
      Value<String?> recurringScheduleId,
      Value<String?> installmentPlanId,
      Value<String?> merchantId,
      Value<String?> categoryId,
      Value<String?> costCenterId,
      Value<String?> payerId,
      Value<String?> appliedRuleId,
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

  ColumnFilters<String> get transferFromAccountId => $composableBuilder(
    column: $table.transferFromAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transferToAccountId => $composableBuilder(
    column: $table.transferToAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurringScheduleId => $composableBuilder(
    column: $table.recurringScheduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get installmentPlanId => $composableBuilder(
    column: $table.installmentPlanId,
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

  ColumnFilters<String> get appliedRuleId => $composableBuilder(
    column: $table.appliedRuleId,
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

  ColumnOrderings<String> get transferFromAccountId => $composableBuilder(
    column: $table.transferFromAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferToAccountId => $composableBuilder(
    column: $table.transferToAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurringScheduleId => $composableBuilder(
    column: $table.recurringScheduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get installmentPlanId => $composableBuilder(
    column: $table.installmentPlanId,
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

  ColumnOrderings<String> get appliedRuleId => $composableBuilder(
    column: $table.appliedRuleId,
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

  GeneratedColumn<String> get transferFromAccountId => $composableBuilder(
    column: $table.transferFromAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transferToAccountId => $composableBuilder(
    column: $table.transferToAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurringScheduleId => $composableBuilder(
    column: $table.recurringScheduleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get installmentPlanId => $composableBuilder(
    column: $table.installmentPlanId,
    builder: (column) => column,
  );

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

  GeneratedColumn<String> get appliedRuleId => $composableBuilder(
    column: $table.appliedRuleId,
    builder: (column) => column,
  );

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
                Value<String?> transferFromAccountId = const Value.absent(),
                Value<String?> transferToAccountId = const Value.absent(),
                Value<String?> recurringScheduleId = const Value.absent(),
                Value<String?> installmentPlanId = const Value.absent(),
                Value<String?> merchantId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> costCenterId = const Value.absent(),
                Value<String?> payerId = const Value.absent(),
                Value<String?> appliedRuleId = const Value.absent(),
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
                transferFromAccountId: transferFromAccountId,
                transferToAccountId: transferToAccountId,
                recurringScheduleId: recurringScheduleId,
                installmentPlanId: installmentPlanId,
                merchantId: merchantId,
                categoryId: categoryId,
                costCenterId: costCenterId,
                payerId: payerId,
                appliedRuleId: appliedRuleId,
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
                Value<String?> transferFromAccountId = const Value.absent(),
                Value<String?> transferToAccountId = const Value.absent(),
                Value<String?> recurringScheduleId = const Value.absent(),
                Value<String?> installmentPlanId = const Value.absent(),
                Value<String?> merchantId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> costCenterId = const Value.absent(),
                Value<String?> payerId = const Value.absent(),
                Value<String?> appliedRuleId = const Value.absent(),
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
                transferFromAccountId: transferFromAccountId,
                transferToAccountId: transferToAccountId,
                recurringScheduleId: recurringScheduleId,
                installmentPlanId: installmentPlanId,
                merchantId: merchantId,
                categoryId: categoryId,
                costCenterId: costCenterId,
                payerId: payerId,
                appliedRuleId: appliedRuleId,
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
typedef $$ClassificationRulesTableCreateCompanionBuilder =
    ClassificationRulesCompanion Function({
      required String id,
      required String householdId,
      required String name,
      required String matchText,
      Value<String?> kind,
      Value<String?> categoryId,
      Value<String?> costCenterId,
      Value<int> priority,
      Value<bool> active,
      Value<int> usageCount,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ClassificationRulesTableUpdateCompanionBuilder =
    ClassificationRulesCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> name,
      Value<String> matchText,
      Value<String?> kind,
      Value<String?> categoryId,
      Value<String?> costCenterId,
      Value<int> priority,
      Value<bool> active,
      Value<int> usageCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ClassificationRulesTableFilterComposer
    extends Composer<_$AppDatabase, $ClassificationRulesTable> {
  $$ClassificationRulesTableFilterComposer({
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

  ColumnFilters<String> get matchText => $composableBuilder(
    column: $table.matchText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
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

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClassificationRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassificationRulesTable> {
  $$ClassificationRulesTableOrderingComposer({
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

  ColumnOrderings<String> get matchText => $composableBuilder(
    column: $table.matchText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
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

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClassificationRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassificationRulesTable> {
  $$ClassificationRulesTableAnnotationComposer({
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

  GeneratedColumn<String> get matchText =>
      $composableBuilder(column: $table.matchText, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get costCenterId => $composableBuilder(
    column: $table.costCenterId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ClassificationRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassificationRulesTable,
          ClassificationRuleRow,
          $$ClassificationRulesTableFilterComposer,
          $$ClassificationRulesTableOrderingComposer,
          $$ClassificationRulesTableAnnotationComposer,
          $$ClassificationRulesTableCreateCompanionBuilder,
          $$ClassificationRulesTableUpdateCompanionBuilder,
          (
            ClassificationRuleRow,
            BaseReferences<
              _$AppDatabase,
              $ClassificationRulesTable,
              ClassificationRuleRow
            >,
          ),
          ClassificationRuleRow,
          PrefetchHooks Function()
        > {
  $$ClassificationRulesTableTableManager(
    _$AppDatabase db,
    $ClassificationRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassificationRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassificationRulesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ClassificationRulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> matchText = const Value.absent(),
                Value<String?> kind = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> costCenterId = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassificationRulesCompanion(
                id: id,
                householdId: householdId,
                name: name,
                matchText: matchText,
                kind: kind,
                categoryId: categoryId,
                costCenterId: costCenterId,
                priority: priority,
                active: active,
                usageCount: usageCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String name,
                required String matchText,
                Value<String?> kind = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> costCenterId = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ClassificationRulesCompanion.insert(
                id: id,
                householdId: householdId,
                name: name,
                matchText: matchText,
                kind: kind,
                categoryId: categoryId,
                costCenterId: costCenterId,
                priority: priority,
                active: active,
                usageCount: usageCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClassificationRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassificationRulesTable,
      ClassificationRuleRow,
      $$ClassificationRulesTableFilterComposer,
      $$ClassificationRulesTableOrderingComposer,
      $$ClassificationRulesTableAnnotationComposer,
      $$ClassificationRulesTableCreateCompanionBuilder,
      $$ClassificationRulesTableUpdateCompanionBuilder,
      (
        ClassificationRuleRow,
        BaseReferences<
          _$AppDatabase,
          $ClassificationRulesTable,
          ClassificationRuleRow
        >,
      ),
      ClassificationRuleRow,
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
typedef $$AppPreferencesTableCreateCompanionBuilder =
    AppPreferencesCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppPreferencesTableUpdateCompanionBuilder =
    AppPreferencesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppPreferencesTable,
          AppPreferenceRow,
          $$AppPreferencesTableFilterComposer,
          $$AppPreferencesTableOrderingComposer,
          $$AppPreferencesTableAnnotationComposer,
          $$AppPreferencesTableCreateCompanionBuilder,
          $$AppPreferencesTableUpdateCompanionBuilder,
          (
            AppPreferenceRow,
            BaseReferences<
              _$AppDatabase,
              $AppPreferencesTable,
              AppPreferenceRow
            >,
          ),
          AppPreferenceRow,
          PrefetchHooks Function()
        > {
  $$AppPreferencesTableTableManager(
    _$AppDatabase db,
    $AppPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppPreferencesCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppPreferencesCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppPreferencesTable,
      AppPreferenceRow,
      $$AppPreferencesTableFilterComposer,
      $$AppPreferencesTableOrderingComposer,
      $$AppPreferencesTableAnnotationComposer,
      $$AppPreferencesTableCreateCompanionBuilder,
      $$AppPreferencesTableUpdateCompanionBuilder,
      (
        AppPreferenceRow,
        BaseReferences<_$AppDatabase, $AppPreferencesTable, AppPreferenceRow>,
      ),
      AppPreferenceRow,
      PrefetchHooks Function()
    >;
typedef $$AuthUsersTableCreateCompanionBuilder =
    AuthUsersCompanion Function({
      required String id,
      required String householdId,
      required String email,
      required String provider,
      Value<String?> linkedPersonId,
      Value<bool> allowed,
      required DateTime createdAt,
      Value<DateTime?> lastLoginAt,
      Value<int> rowid,
    });
typedef $$AuthUsersTableUpdateCompanionBuilder =
    AuthUsersCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> email,
      Value<String> provider,
      Value<String?> linkedPersonId,
      Value<bool> allowed,
      Value<DateTime> createdAt,
      Value<DateTime?> lastLoginAt,
      Value<int> rowid,
    });

class $$AuthUsersTableFilterComposer
    extends Composer<_$AppDatabase, $AuthUsersTable> {
  $$AuthUsersTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedPersonId => $composableBuilder(
    column: $table.linkedPersonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowed => $composableBuilder(
    column: $table.allowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuthUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthUsersTable> {
  $$AuthUsersTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedPersonId => $composableBuilder(
    column: $table.linkedPersonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowed => $composableBuilder(
    column: $table.allowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuthUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthUsersTable> {
  $$AuthUsersTableAnnotationComposer({
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get linkedPersonId => $composableBuilder(
    column: $table.linkedPersonId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allowed =>
      $composableBuilder(column: $table.allowed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => column,
  );
}

class $$AuthUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthUsersTable,
          AuthUserRow,
          $$AuthUsersTableFilterComposer,
          $$AuthUsersTableOrderingComposer,
          $$AuthUsersTableAnnotationComposer,
          $$AuthUsersTableCreateCompanionBuilder,
          $$AuthUsersTableUpdateCompanionBuilder,
          (
            AuthUserRow,
            BaseReferences<_$AppDatabase, $AuthUsersTable, AuthUserRow>,
          ),
          AuthUserRow,
          PrefetchHooks Function()
        > {
  $$AuthUsersTableTableManager(_$AppDatabase db, $AuthUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String?> linkedPersonId = const Value.absent(),
                Value<bool> allowed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastLoginAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthUsersCompanion(
                id: id,
                householdId: householdId,
                email: email,
                provider: provider,
                linkedPersonId: linkedPersonId,
                allowed: allowed,
                createdAt: createdAt,
                lastLoginAt: lastLoginAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String email,
                required String provider,
                Value<String?> linkedPersonId = const Value.absent(),
                Value<bool> allowed = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> lastLoginAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthUsersCompanion.insert(
                id: id,
                householdId: householdId,
                email: email,
                provider: provider,
                linkedPersonId: linkedPersonId,
                allowed: allowed,
                createdAt: createdAt,
                lastLoginAt: lastLoginAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuthUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthUsersTable,
      AuthUserRow,
      $$AuthUsersTableFilterComposer,
      $$AuthUsersTableOrderingComposer,
      $$AuthUsersTableAnnotationComposer,
      $$AuthUsersTableCreateCompanionBuilder,
      $$AuthUsersTableUpdateCompanionBuilder,
      (
        AuthUserRow,
        BaseReferences<_$AppDatabase, $AuthUsersTable, AuthUserRow>,
      ),
      AuthUserRow,
      PrefetchHooks Function()
    >;
typedef $$RecurringSchedulesTableCreateCompanionBuilder =
    RecurringSchedulesCompanion Function({
      required String id,
      required String householdId,
      required String label,
      required String kind,
      required int amountCents,
      Value<String> currencyCode,
      Value<String> frequency,
      required int dayOfMonth,
      required String startMonth,
      Value<String?> endMonth,
      Value<String?> payerPersonId,
      Value<String?> beneficiaryPersonId,
      Value<String?> fromAccountId,
      Value<String?> toAccountId,
      Value<String?> categoryId,
      Value<String?> costCenterId,
      Value<bool> active,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecurringSchedulesTableUpdateCompanionBuilder =
    RecurringSchedulesCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> label,
      Value<String> kind,
      Value<int> amountCents,
      Value<String> currencyCode,
      Value<String> frequency,
      Value<int> dayOfMonth,
      Value<String> startMonth,
      Value<String?> endMonth,
      Value<String?> payerPersonId,
      Value<String?> beneficiaryPersonId,
      Value<String?> fromAccountId,
      Value<String?> toAccountId,
      Value<String?> categoryId,
      Value<String?> costCenterId,
      Value<bool> active,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$RecurringSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringSchedulesTable> {
  $$RecurringSchedulesTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
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

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endMonth => $composableBuilder(
    column: $table.endMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payerPersonId => $composableBuilder(
    column: $table.payerPersonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beneficiaryPersonId => $composableBuilder(
    column: $table.beneficiaryPersonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
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

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecurringSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringSchedulesTable> {
  $$RecurringSchedulesTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
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

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endMonth => $composableBuilder(
    column: $table.endMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payerPersonId => $composableBuilder(
    column: $table.payerPersonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beneficiaryPersonId => $composableBuilder(
    column: $table.beneficiaryPersonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
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

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringSchedulesTable> {
  $$RecurringSchedulesTableAnnotationComposer({
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

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endMonth =>
      $composableBuilder(column: $table.endMonth, builder: (column) => column);

  GeneratedColumn<String> get payerPersonId => $composableBuilder(
    column: $table.payerPersonId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get beneficiaryPersonId => $composableBuilder(
    column: $table.beneficiaryPersonId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
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

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecurringSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringSchedulesTable,
          RecurringScheduleRow,
          $$RecurringSchedulesTableFilterComposer,
          $$RecurringSchedulesTableOrderingComposer,
          $$RecurringSchedulesTableAnnotationComposer,
          $$RecurringSchedulesTableCreateCompanionBuilder,
          $$RecurringSchedulesTableUpdateCompanionBuilder,
          (
            RecurringScheduleRow,
            BaseReferences<
              _$AppDatabase,
              $RecurringSchedulesTable,
              RecurringScheduleRow
            >,
          ),
          RecurringScheduleRow,
          PrefetchHooks Function()
        > {
  $$RecurringSchedulesTableTableManager(
    _$AppDatabase db,
    $RecurringSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringSchedulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> dayOfMonth = const Value.absent(),
                Value<String> startMonth = const Value.absent(),
                Value<String?> endMonth = const Value.absent(),
                Value<String?> payerPersonId = const Value.absent(),
                Value<String?> beneficiaryPersonId = const Value.absent(),
                Value<String?> fromAccountId = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> costCenterId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringSchedulesCompanion(
                id: id,
                householdId: householdId,
                label: label,
                kind: kind,
                amountCents: amountCents,
                currencyCode: currencyCode,
                frequency: frequency,
                dayOfMonth: dayOfMonth,
                startMonth: startMonth,
                endMonth: endMonth,
                payerPersonId: payerPersonId,
                beneficiaryPersonId: beneficiaryPersonId,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                categoryId: categoryId,
                costCenterId: costCenterId,
                active: active,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String label,
                required String kind,
                required int amountCents,
                Value<String> currencyCode = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                required int dayOfMonth,
                required String startMonth,
                Value<String?> endMonth = const Value.absent(),
                Value<String?> payerPersonId = const Value.absent(),
                Value<String?> beneficiaryPersonId = const Value.absent(),
                Value<String?> fromAccountId = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> costCenterId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecurringSchedulesCompanion.insert(
                id: id,
                householdId: householdId,
                label: label,
                kind: kind,
                amountCents: amountCents,
                currencyCode: currencyCode,
                frequency: frequency,
                dayOfMonth: dayOfMonth,
                startMonth: startMonth,
                endMonth: endMonth,
                payerPersonId: payerPersonId,
                beneficiaryPersonId: beneficiaryPersonId,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                categoryId: categoryId,
                costCenterId: costCenterId,
                active: active,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringSchedulesTable,
      RecurringScheduleRow,
      $$RecurringSchedulesTableFilterComposer,
      $$RecurringSchedulesTableOrderingComposer,
      $$RecurringSchedulesTableAnnotationComposer,
      $$RecurringSchedulesTableCreateCompanionBuilder,
      $$RecurringSchedulesTableUpdateCompanionBuilder,
      (
        RecurringScheduleRow,
        BaseReferences<
          _$AppDatabase,
          $RecurringSchedulesTable,
          RecurringScheduleRow
        >,
      ),
      RecurringScheduleRow,
      PrefetchHooks Function()
    >;
typedef $$InstallmentPlansTableCreateCompanionBuilder =
    InstallmentPlansCompanion Function({
      required String id,
      required String householdId,
      required String label,
      required String planKind,
      Value<String?> ownerPersonId,
      Value<String?> assetName,
      Value<int?> totalAmountCents,
      required int installmentAmountCents,
      required int currentInstallment,
      required int totalInstallments,
      Value<int?> dueDay,
      required String startMonth,
      Value<String?> endMonth,
      Value<String?> categoryId,
      Value<String?> costCenterId,
      Value<bool> active,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$InstallmentPlansTableUpdateCompanionBuilder =
    InstallmentPlansCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> label,
      Value<String> planKind,
      Value<String?> ownerPersonId,
      Value<String?> assetName,
      Value<int?> totalAmountCents,
      Value<int> installmentAmountCents,
      Value<int> currentInstallment,
      Value<int> totalInstallments,
      Value<int?> dueDay,
      Value<String> startMonth,
      Value<String?> endMonth,
      Value<String?> categoryId,
      Value<String?> costCenterId,
      Value<bool> active,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$InstallmentPlansTableFilterComposer
    extends Composer<_$AppDatabase, $InstallmentPlansTable> {
  $$InstallmentPlansTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planKind => $composableBuilder(
    column: $table.planKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerPersonId => $composableBuilder(
    column: $table.ownerPersonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetName => $composableBuilder(
    column: $table.assetName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentAmountCents => $composableBuilder(
    column: $table.installmentAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentInstallment => $composableBuilder(
    column: $table.currentInstallment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalInstallments => $composableBuilder(
    column: $table.totalInstallments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endMonth => $composableBuilder(
    column: $table.endMonth,
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

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstallmentPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $InstallmentPlansTable> {
  $$InstallmentPlansTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planKind => $composableBuilder(
    column: $table.planKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerPersonId => $composableBuilder(
    column: $table.ownerPersonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetName => $composableBuilder(
    column: $table.assetName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentAmountCents => $composableBuilder(
    column: $table.installmentAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentInstallment => $composableBuilder(
    column: $table.currentInstallment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalInstallments => $composableBuilder(
    column: $table.totalInstallments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endMonth => $composableBuilder(
    column: $table.endMonth,
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

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstallmentPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstallmentPlansTable> {
  $$InstallmentPlansTableAnnotationComposer({
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

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get planKind =>
      $composableBuilder(column: $table.planKind, builder: (column) => column);

  GeneratedColumn<String> get ownerPersonId => $composableBuilder(
    column: $table.ownerPersonId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetName =>
      $composableBuilder(column: $table.assetName, builder: (column) => column);

  GeneratedColumn<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get installmentAmountCents => $composableBuilder(
    column: $table.installmentAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentInstallment => $composableBuilder(
    column: $table.currentInstallment,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalInstallments => $composableBuilder(
    column: $table.totalInstallments,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<String> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endMonth =>
      $composableBuilder(column: $table.endMonth, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get costCenterId => $composableBuilder(
    column: $table.costCenterId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InstallmentPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstallmentPlansTable,
          InstallmentPlanRow,
          $$InstallmentPlansTableFilterComposer,
          $$InstallmentPlansTableOrderingComposer,
          $$InstallmentPlansTableAnnotationComposer,
          $$InstallmentPlansTableCreateCompanionBuilder,
          $$InstallmentPlansTableUpdateCompanionBuilder,
          (
            InstallmentPlanRow,
            BaseReferences<
              _$AppDatabase,
              $InstallmentPlansTable,
              InstallmentPlanRow
            >,
          ),
          InstallmentPlanRow,
          PrefetchHooks Function()
        > {
  $$InstallmentPlansTableTableManager(
    _$AppDatabase db,
    $InstallmentPlansTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstallmentPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstallmentPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstallmentPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> planKind = const Value.absent(),
                Value<String?> ownerPersonId = const Value.absent(),
                Value<String?> assetName = const Value.absent(),
                Value<int?> totalAmountCents = const Value.absent(),
                Value<int> installmentAmountCents = const Value.absent(),
                Value<int> currentInstallment = const Value.absent(),
                Value<int> totalInstallments = const Value.absent(),
                Value<int?> dueDay = const Value.absent(),
                Value<String> startMonth = const Value.absent(),
                Value<String?> endMonth = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> costCenterId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstallmentPlansCompanion(
                id: id,
                householdId: householdId,
                label: label,
                planKind: planKind,
                ownerPersonId: ownerPersonId,
                assetName: assetName,
                totalAmountCents: totalAmountCents,
                installmentAmountCents: installmentAmountCents,
                currentInstallment: currentInstallment,
                totalInstallments: totalInstallments,
                dueDay: dueDay,
                startMonth: startMonth,
                endMonth: endMonth,
                categoryId: categoryId,
                costCenterId: costCenterId,
                active: active,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String label,
                required String planKind,
                Value<String?> ownerPersonId = const Value.absent(),
                Value<String?> assetName = const Value.absent(),
                Value<int?> totalAmountCents = const Value.absent(),
                required int installmentAmountCents,
                required int currentInstallment,
                required int totalInstallments,
                Value<int?> dueDay = const Value.absent(),
                required String startMonth,
                Value<String?> endMonth = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> costCenterId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InstallmentPlansCompanion.insert(
                id: id,
                householdId: householdId,
                label: label,
                planKind: planKind,
                ownerPersonId: ownerPersonId,
                assetName: assetName,
                totalAmountCents: totalAmountCents,
                installmentAmountCents: installmentAmountCents,
                currentInstallment: currentInstallment,
                totalInstallments: totalInstallments,
                dueDay: dueDay,
                startMonth: startMonth,
                endMonth: endMonth,
                categoryId: categoryId,
                costCenterId: costCenterId,
                active: active,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstallmentPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstallmentPlansTable,
      InstallmentPlanRow,
      $$InstallmentPlansTableFilterComposer,
      $$InstallmentPlansTableOrderingComposer,
      $$InstallmentPlansTableAnnotationComposer,
      $$InstallmentPlansTableCreateCompanionBuilder,
      $$InstallmentPlansTableUpdateCompanionBuilder,
      (
        InstallmentPlanRow,
        BaseReferences<
          _$AppDatabase,
          $InstallmentPlansTable,
          InstallmentPlanRow
        >,
      ),
      InstallmentPlanRow,
      PrefetchHooks Function()
    >;
typedef $$ImportBatchesTableCreateCompanionBuilder =
    ImportBatchesCompanion Function({
      required String id,
      required String householdId,
      required String fileName,
      required String fileHash,
      required String fileFormat,
      required String provider,
      required DateTime importedAt,
      Value<int> totalRows,
      Value<int> validRows,
      Value<int> invalidRows,
      Value<int> duplicateRows,
      Value<int> reviewRows,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$ImportBatchesTableUpdateCompanionBuilder =
    ImportBatchesCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> fileName,
      Value<String> fileHash,
      Value<String> fileFormat,
      Value<String> provider,
      Value<DateTime> importedAt,
      Value<int> totalRows,
      Value<int> validRows,
      Value<int> invalidRows,
      Value<int> duplicateRows,
      Value<int> reviewRows,
      Value<String> status,
      Value<int> rowid,
    });

class $$ImportBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableFilterComposer({
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

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileFormat => $composableBuilder(
    column: $table.fileFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRows => $composableBuilder(
    column: $table.totalRows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get validRows => $composableBuilder(
    column: $table.validRows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get invalidRows => $composableBuilder(
    column: $table.invalidRows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duplicateRows => $composableBuilder(
    column: $table.duplicateRows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewRows => $composableBuilder(
    column: $table.reviewRows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImportBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableOrderingComposer({
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

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileFormat => $composableBuilder(
    column: $table.fileFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRows => $composableBuilder(
    column: $table.totalRows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get validRows => $composableBuilder(
    column: $table.validRows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get invalidRows => $composableBuilder(
    column: $table.invalidRows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duplicateRows => $composableBuilder(
    column: $table.duplicateRows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewRows => $composableBuilder(
    column: $table.reviewRows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableAnnotationComposer({
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

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<String> get fileFormat => $composableBuilder(
    column: $table.fileFormat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalRows =>
      $composableBuilder(column: $table.totalRows, builder: (column) => column);

  GeneratedColumn<int> get validRows =>
      $composableBuilder(column: $table.validRows, builder: (column) => column);

  GeneratedColumn<int> get invalidRows => $composableBuilder(
    column: $table.invalidRows,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duplicateRows => $composableBuilder(
    column: $table.duplicateRows,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewRows => $composableBuilder(
    column: $table.reviewRows,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$ImportBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportBatchesTable,
          ImportBatchRow,
          $$ImportBatchesTableFilterComposer,
          $$ImportBatchesTableOrderingComposer,
          $$ImportBatchesTableAnnotationComposer,
          $$ImportBatchesTableCreateCompanionBuilder,
          $$ImportBatchesTableUpdateCompanionBuilder,
          (
            ImportBatchRow,
            BaseReferences<_$AppDatabase, $ImportBatchesTable, ImportBatchRow>,
          ),
          ImportBatchRow,
          PrefetchHooks Function()
        > {
  $$ImportBatchesTableTableManager(_$AppDatabase db, $ImportBatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> fileHash = const Value.absent(),
                Value<String> fileFormat = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<int> totalRows = const Value.absent(),
                Value<int> validRows = const Value.absent(),
                Value<int> invalidRows = const Value.absent(),
                Value<int> duplicateRows = const Value.absent(),
                Value<int> reviewRows = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportBatchesCompanion(
                id: id,
                householdId: householdId,
                fileName: fileName,
                fileHash: fileHash,
                fileFormat: fileFormat,
                provider: provider,
                importedAt: importedAt,
                totalRows: totalRows,
                validRows: validRows,
                invalidRows: invalidRows,
                duplicateRows: duplicateRows,
                reviewRows: reviewRows,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String fileName,
                required String fileHash,
                required String fileFormat,
                required String provider,
                required DateTime importedAt,
                Value<int> totalRows = const Value.absent(),
                Value<int> validRows = const Value.absent(),
                Value<int> invalidRows = const Value.absent(),
                Value<int> duplicateRows = const Value.absent(),
                Value<int> reviewRows = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportBatchesCompanion.insert(
                id: id,
                householdId: householdId,
                fileName: fileName,
                fileHash: fileHash,
                fileFormat: fileFormat,
                provider: provider,
                importedAt: importedAt,
                totalRows: totalRows,
                validRows: validRows,
                invalidRows: invalidRows,
                duplicateRows: duplicateRows,
                reviewRows: reviewRows,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImportBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportBatchesTable,
      ImportBatchRow,
      $$ImportBatchesTableFilterComposer,
      $$ImportBatchesTableOrderingComposer,
      $$ImportBatchesTableAnnotationComposer,
      $$ImportBatchesTableCreateCompanionBuilder,
      $$ImportBatchesTableUpdateCompanionBuilder,
      (
        ImportBatchRow,
        BaseReferences<_$AppDatabase, $ImportBatchesTable, ImportBatchRow>,
      ),
      ImportBatchRow,
      PrefetchHooks Function()
    >;
typedef $$StagedSourceRecordsTableCreateCompanionBuilder =
    StagedSourceRecordsCompanion Function({
      required String id,
      required String batchId,
      required String householdId,
      required String sourceKind,
      required String provider,
      required int rowIndex,
      required String rowHash,
      Value<String?> externalId,
      Value<DateTime?> occurredAt,
      Value<DateTime?> postedAt,
      Value<String?> descriptionRaw,
      Value<int?> amountCents,
      Value<String> currencyCode,
      Value<String?> accountHint,
      required String status,
      Value<String?> duplicateOfTransactionId,
      Value<String?> errorMessage,
      Value<String?> rawPayloadJson,
      Value<double> confidence,
      required DateTime createdAt,
      Value<DateTime?> promotedAt,
      Value<int> rowid,
    });
typedef $$StagedSourceRecordsTableUpdateCompanionBuilder =
    StagedSourceRecordsCompanion Function({
      Value<String> id,
      Value<String> batchId,
      Value<String> householdId,
      Value<String> sourceKind,
      Value<String> provider,
      Value<int> rowIndex,
      Value<String> rowHash,
      Value<String?> externalId,
      Value<DateTime?> occurredAt,
      Value<DateTime?> postedAt,
      Value<String?> descriptionRaw,
      Value<int?> amountCents,
      Value<String> currencyCode,
      Value<String?> accountHint,
      Value<String> status,
      Value<String?> duplicateOfTransactionId,
      Value<String?> errorMessage,
      Value<String?> rawPayloadJson,
      Value<double> confidence,
      Value<DateTime> createdAt,
      Value<DateTime?> promotedAt,
      Value<int> rowid,
    });

class $$StagedSourceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $StagedSourceRecordsTable> {
  $$StagedSourceRecordsTableFilterComposer({
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

  ColumnFilters<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
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

  ColumnFilters<int> get rowIndex => $composableBuilder(
    column: $table.rowIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowHash => $composableBuilder(
    column: $table.rowHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
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

  ColumnFilters<String> get descriptionRaw => $composableBuilder(
    column: $table.descriptionRaw,
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

  ColumnFilters<String> get accountHint => $composableBuilder(
    column: $table.accountHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duplicateOfTransactionId => $composableBuilder(
    column: $table.duplicateOfTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawPayloadJson => $composableBuilder(
    column: $table.rawPayloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get promotedAt => $composableBuilder(
    column: $table.promotedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StagedSourceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $StagedSourceRecordsTable> {
  $$StagedSourceRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
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

  ColumnOrderings<int> get rowIndex => $composableBuilder(
    column: $table.rowIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowHash => $composableBuilder(
    column: $table.rowHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
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

  ColumnOrderings<String> get descriptionRaw => $composableBuilder(
    column: $table.descriptionRaw,
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

  ColumnOrderings<String> get accountHint => $composableBuilder(
    column: $table.accountHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duplicateOfTransactionId => $composableBuilder(
    column: $table.duplicateOfTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawPayloadJson => $composableBuilder(
    column: $table.rawPayloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get promotedAt => $composableBuilder(
    column: $table.promotedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StagedSourceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StagedSourceRecordsTable> {
  $$StagedSourceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<int> get rowIndex =>
      $composableBuilder(column: $table.rowIndex, builder: (column) => column);

  GeneratedColumn<String> get rowHash =>
      $composableBuilder(column: $table.rowHash, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get postedAt =>
      $composableBuilder(column: $table.postedAt, builder: (column) => column);

  GeneratedColumn<String> get descriptionRaw => $composableBuilder(
    column: $table.descriptionRaw,
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

  GeneratedColumn<String> get accountHint => $composableBuilder(
    column: $table.accountHint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get duplicateOfTransactionId => $composableBuilder(
    column: $table.duplicateOfTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawPayloadJson => $composableBuilder(
    column: $table.rawPayloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get promotedAt => $composableBuilder(
    column: $table.promotedAt,
    builder: (column) => column,
  );
}

class $$StagedSourceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StagedSourceRecordsTable,
          StagedSourceRecordRow,
          $$StagedSourceRecordsTableFilterComposer,
          $$StagedSourceRecordsTableOrderingComposer,
          $$StagedSourceRecordsTableAnnotationComposer,
          $$StagedSourceRecordsTableCreateCompanionBuilder,
          $$StagedSourceRecordsTableUpdateCompanionBuilder,
          (
            StagedSourceRecordRow,
            BaseReferences<
              _$AppDatabase,
              $StagedSourceRecordsTable,
              StagedSourceRecordRow
            >,
          ),
          StagedSourceRecordRow,
          PrefetchHooks Function()
        > {
  $$StagedSourceRecordsTableTableManager(
    _$AppDatabase db,
    $StagedSourceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StagedSourceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StagedSourceRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StagedSourceRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> batchId = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<int> rowIndex = const Value.absent(),
                Value<String> rowHash = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<DateTime?> occurredAt = const Value.absent(),
                Value<DateTime?> postedAt = const Value.absent(),
                Value<String?> descriptionRaw = const Value.absent(),
                Value<int?> amountCents = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String?> accountHint = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> duplicateOfTransactionId = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> rawPayloadJson = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> promotedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StagedSourceRecordsCompanion(
                id: id,
                batchId: batchId,
                householdId: householdId,
                sourceKind: sourceKind,
                provider: provider,
                rowIndex: rowIndex,
                rowHash: rowHash,
                externalId: externalId,
                occurredAt: occurredAt,
                postedAt: postedAt,
                descriptionRaw: descriptionRaw,
                amountCents: amountCents,
                currencyCode: currencyCode,
                accountHint: accountHint,
                status: status,
                duplicateOfTransactionId: duplicateOfTransactionId,
                errorMessage: errorMessage,
                rawPayloadJson: rawPayloadJson,
                confidence: confidence,
                createdAt: createdAt,
                promotedAt: promotedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String batchId,
                required String householdId,
                required String sourceKind,
                required String provider,
                required int rowIndex,
                required String rowHash,
                Value<String?> externalId = const Value.absent(),
                Value<DateTime?> occurredAt = const Value.absent(),
                Value<DateTime?> postedAt = const Value.absent(),
                Value<String?> descriptionRaw = const Value.absent(),
                Value<int?> amountCents = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String?> accountHint = const Value.absent(),
                required String status,
                Value<String?> duplicateOfTransactionId = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> rawPayloadJson = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> promotedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StagedSourceRecordsCompanion.insert(
                id: id,
                batchId: batchId,
                householdId: householdId,
                sourceKind: sourceKind,
                provider: provider,
                rowIndex: rowIndex,
                rowHash: rowHash,
                externalId: externalId,
                occurredAt: occurredAt,
                postedAt: postedAt,
                descriptionRaw: descriptionRaw,
                amountCents: amountCents,
                currencyCode: currencyCode,
                accountHint: accountHint,
                status: status,
                duplicateOfTransactionId: duplicateOfTransactionId,
                errorMessage: errorMessage,
                rawPayloadJson: rawPayloadJson,
                confidence: confidence,
                createdAt: createdAt,
                promotedAt: promotedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StagedSourceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StagedSourceRecordsTable,
      StagedSourceRecordRow,
      $$StagedSourceRecordsTableFilterComposer,
      $$StagedSourceRecordsTableOrderingComposer,
      $$StagedSourceRecordsTableAnnotationComposer,
      $$StagedSourceRecordsTableCreateCompanionBuilder,
      $$StagedSourceRecordsTableUpdateCompanionBuilder,
      (
        StagedSourceRecordRow,
        BaseReferences<
          _$AppDatabase,
          $StagedSourceRecordsTable,
          StagedSourceRecordRow
        >,
      ),
      StagedSourceRecordRow,
      PrefetchHooks Function()
    >;
typedef $$DuplicateCandidatesTableCreateCompanionBuilder =
    DuplicateCandidatesCompanion Function({
      required String id,
      required String householdId,
      required String transactionId,
      Value<String?> candidateTransactionId,
      Value<String?> stagedSourceRecordId,
      required double score,
      Value<String> status,
      required String reason,
      required String explanation,
      required DateTime createdAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });
typedef $$DuplicateCandidatesTableUpdateCompanionBuilder =
    DuplicateCandidatesCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> transactionId,
      Value<String?> candidateTransactionId,
      Value<String?> stagedSourceRecordId,
      Value<double> score,
      Value<String> status,
      Value<String> reason,
      Value<String> explanation,
      Value<DateTime> createdAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });

class $$DuplicateCandidatesTableFilterComposer
    extends Composer<_$AppDatabase, $DuplicateCandidatesTable> {
  $$DuplicateCandidatesTableFilterComposer({
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

  ColumnFilters<String> get candidateTransactionId => $composableBuilder(
    column: $table.candidateTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stagedSourceRecordId => $composableBuilder(
    column: $table.stagedSourceRecordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
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

class $$DuplicateCandidatesTableOrderingComposer
    extends Composer<_$AppDatabase, $DuplicateCandidatesTable> {
  $$DuplicateCandidatesTableOrderingComposer({
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

  ColumnOrderings<String> get candidateTransactionId => $composableBuilder(
    column: $table.candidateTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stagedSourceRecordId => $composableBuilder(
    column: $table.stagedSourceRecordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
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

class $$DuplicateCandidatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DuplicateCandidatesTable> {
  $$DuplicateCandidatesTableAnnotationComposer({
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

  GeneratedColumn<String> get candidateTransactionId => $composableBuilder(
    column: $table.candidateTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stagedSourceRecordId => $composableBuilder(
    column: $table.stagedSourceRecordId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );
}

class $$DuplicateCandidatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DuplicateCandidatesTable,
          DuplicateCandidateRow,
          $$DuplicateCandidatesTableFilterComposer,
          $$DuplicateCandidatesTableOrderingComposer,
          $$DuplicateCandidatesTableAnnotationComposer,
          $$DuplicateCandidatesTableCreateCompanionBuilder,
          $$DuplicateCandidatesTableUpdateCompanionBuilder,
          (
            DuplicateCandidateRow,
            BaseReferences<
              _$AppDatabase,
              $DuplicateCandidatesTable,
              DuplicateCandidateRow
            >,
          ),
          DuplicateCandidateRow,
          PrefetchHooks Function()
        > {
  $$DuplicateCandidatesTableTableManager(
    _$AppDatabase db,
    $DuplicateCandidatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DuplicateCandidatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DuplicateCandidatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DuplicateCandidatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String?> candidateTransactionId = const Value.absent(),
                Value<String?> stagedSourceRecordId = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DuplicateCandidatesCompanion(
                id: id,
                householdId: householdId,
                transactionId: transactionId,
                candidateTransactionId: candidateTransactionId,
                stagedSourceRecordId: stagedSourceRecordId,
                score: score,
                status: status,
                reason: reason,
                explanation: explanation,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String transactionId,
                Value<String?> candidateTransactionId = const Value.absent(),
                Value<String?> stagedSourceRecordId = const Value.absent(),
                required double score,
                Value<String> status = const Value.absent(),
                required String reason,
                required String explanation,
                required DateTime createdAt,
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DuplicateCandidatesCompanion.insert(
                id: id,
                householdId: householdId,
                transactionId: transactionId,
                candidateTransactionId: candidateTransactionId,
                stagedSourceRecordId: stagedSourceRecordId,
                score: score,
                status: status,
                reason: reason,
                explanation: explanation,
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

typedef $$DuplicateCandidatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DuplicateCandidatesTable,
      DuplicateCandidateRow,
      $$DuplicateCandidatesTableFilterComposer,
      $$DuplicateCandidatesTableOrderingComposer,
      $$DuplicateCandidatesTableAnnotationComposer,
      $$DuplicateCandidatesTableCreateCompanionBuilder,
      $$DuplicateCandidatesTableUpdateCompanionBuilder,
      (
        DuplicateCandidateRow,
        BaseReferences<
          _$AppDatabase,
          $DuplicateCandidatesTable,
          DuplicateCandidateRow
        >,
      ),
      DuplicateCandidateRow,
      PrefetchHooks Function()
    >;
typedef $$RawNotificationEventsTableCreateCompanionBuilder =
    RawNotificationEventsCompanion Function({
      required String id,
      required String householdId,
      required String platformEventId,
      required String packageName,
      Value<String?> appLabel,
      Value<String?> title,
      Value<String?> bodyText,
      Value<String?> bigText,
      Value<int?> notificationId,
      Value<String?> tag,
      required DateTime postedAt,
      required DateTime capturedAt,
      Value<String> status,
      Value<String?> rawPayloadJson,
      Value<String?> draftTransactionId,
      Value<String?> errorMessage,
      Value<DateTime?> processedAt,
      Value<int> rowid,
    });
typedef $$RawNotificationEventsTableUpdateCompanionBuilder =
    RawNotificationEventsCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> platformEventId,
      Value<String> packageName,
      Value<String?> appLabel,
      Value<String?> title,
      Value<String?> bodyText,
      Value<String?> bigText,
      Value<int?> notificationId,
      Value<String?> tag,
      Value<DateTime> postedAt,
      Value<DateTime> capturedAt,
      Value<String> status,
      Value<String?> rawPayloadJson,
      Value<String?> draftTransactionId,
      Value<String?> errorMessage,
      Value<DateTime?> processedAt,
      Value<int> rowid,
    });

class $$RawNotificationEventsTableFilterComposer
    extends Composer<_$AppDatabase, $RawNotificationEventsTable> {
  $$RawNotificationEventsTableFilterComposer({
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

  ColumnFilters<String> get platformEventId => $composableBuilder(
    column: $table.platformEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appLabel => $composableBuilder(
    column: $table.appLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bigText => $composableBuilder(
    column: $table.bigText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get postedAt => $composableBuilder(
    column: $table.postedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawPayloadJson => $composableBuilder(
    column: $table.rawPayloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get draftTransactionId => $composableBuilder(
    column: $table.draftTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RawNotificationEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $RawNotificationEventsTable> {
  $$RawNotificationEventsTableOrderingComposer({
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

  ColumnOrderings<String> get platformEventId => $composableBuilder(
    column: $table.platformEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appLabel => $composableBuilder(
    column: $table.appLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bigText => $composableBuilder(
    column: $table.bigText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get postedAt => $composableBuilder(
    column: $table.postedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawPayloadJson => $composableBuilder(
    column: $table.rawPayloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get draftTransactionId => $composableBuilder(
    column: $table.draftTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RawNotificationEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RawNotificationEventsTable> {
  $$RawNotificationEventsTableAnnotationComposer({
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

  GeneratedColumn<String> get platformEventId => $composableBuilder(
    column: $table.platformEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appLabel =>
      $composableBuilder(column: $table.appLabel, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get bodyText =>
      $composableBuilder(column: $table.bodyText, builder: (column) => column);

  GeneratedColumn<String> get bigText =>
      $composableBuilder(column: $table.bigText, builder: (column) => column);

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  GeneratedColumn<DateTime> get postedAt =>
      $composableBuilder(column: $table.postedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get rawPayloadJson => $composableBuilder(
    column: $table.rawPayloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get draftTransactionId => $composableBuilder(
    column: $table.draftTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => column,
  );
}

class $$RawNotificationEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RawNotificationEventsTable,
          RawNotificationEventRow,
          $$RawNotificationEventsTableFilterComposer,
          $$RawNotificationEventsTableOrderingComposer,
          $$RawNotificationEventsTableAnnotationComposer,
          $$RawNotificationEventsTableCreateCompanionBuilder,
          $$RawNotificationEventsTableUpdateCompanionBuilder,
          (
            RawNotificationEventRow,
            BaseReferences<
              _$AppDatabase,
              $RawNotificationEventsTable,
              RawNotificationEventRow
            >,
          ),
          RawNotificationEventRow,
          PrefetchHooks Function()
        > {
  $$RawNotificationEventsTableTableManager(
    _$AppDatabase db,
    $RawNotificationEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RawNotificationEventsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RawNotificationEventsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RawNotificationEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> platformEventId = const Value.absent(),
                Value<String> packageName = const Value.absent(),
                Value<String?> appLabel = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> bodyText = const Value.absent(),
                Value<String?> bigText = const Value.absent(),
                Value<int?> notificationId = const Value.absent(),
                Value<String?> tag = const Value.absent(),
                Value<DateTime> postedAt = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> rawPayloadJson = const Value.absent(),
                Value<String?> draftTransactionId = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime?> processedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RawNotificationEventsCompanion(
                id: id,
                householdId: householdId,
                platformEventId: platformEventId,
                packageName: packageName,
                appLabel: appLabel,
                title: title,
                bodyText: bodyText,
                bigText: bigText,
                notificationId: notificationId,
                tag: tag,
                postedAt: postedAt,
                capturedAt: capturedAt,
                status: status,
                rawPayloadJson: rawPayloadJson,
                draftTransactionId: draftTransactionId,
                errorMessage: errorMessage,
                processedAt: processedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String platformEventId,
                required String packageName,
                Value<String?> appLabel = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> bodyText = const Value.absent(),
                Value<String?> bigText = const Value.absent(),
                Value<int?> notificationId = const Value.absent(),
                Value<String?> tag = const Value.absent(),
                required DateTime postedAt,
                required DateTime capturedAt,
                Value<String> status = const Value.absent(),
                Value<String?> rawPayloadJson = const Value.absent(),
                Value<String?> draftTransactionId = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime?> processedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RawNotificationEventsCompanion.insert(
                id: id,
                householdId: householdId,
                platformEventId: platformEventId,
                packageName: packageName,
                appLabel: appLabel,
                title: title,
                bodyText: bodyText,
                bigText: bigText,
                notificationId: notificationId,
                tag: tag,
                postedAt: postedAt,
                capturedAt: capturedAt,
                status: status,
                rawPayloadJson: rawPayloadJson,
                draftTransactionId: draftTransactionId,
                errorMessage: errorMessage,
                processedAt: processedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RawNotificationEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RawNotificationEventsTable,
      RawNotificationEventRow,
      $$RawNotificationEventsTableFilterComposer,
      $$RawNotificationEventsTableOrderingComposer,
      $$RawNotificationEventsTableAnnotationComposer,
      $$RawNotificationEventsTableCreateCompanionBuilder,
      $$RawNotificationEventsTableUpdateCompanionBuilder,
      (
        RawNotificationEventRow,
        BaseReferences<
          _$AppDatabase,
          $RawNotificationEventsTable,
          RawNotificationEventRow
        >,
      ),
      RawNotificationEventRow,
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
  $$ClassificationRulesTableTableManager get classificationRules =>
      $$ClassificationRulesTableTableManager(_db, _db.classificationRules);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$AppPreferencesTableTableManager get appPreferences =>
      $$AppPreferencesTableTableManager(_db, _db.appPreferences);
  $$AuthUsersTableTableManager get authUsers =>
      $$AuthUsersTableTableManager(_db, _db.authUsers);
  $$RecurringSchedulesTableTableManager get recurringSchedules =>
      $$RecurringSchedulesTableTableManager(_db, _db.recurringSchedules);
  $$InstallmentPlansTableTableManager get installmentPlans =>
      $$InstallmentPlansTableTableManager(_db, _db.installmentPlans);
  $$ImportBatchesTableTableManager get importBatches =>
      $$ImportBatchesTableTableManager(_db, _db.importBatches);
  $$StagedSourceRecordsTableTableManager get stagedSourceRecords =>
      $$StagedSourceRecordsTableTableManager(_db, _db.stagedSourceRecords);
  $$DuplicateCandidatesTableTableManager get duplicateCandidates =>
      $$DuplicateCandidatesTableTableManager(_db, _db.duplicateCandidates);
  $$RawNotificationEventsTableTableManager get rawNotificationEvents =>
      $$RawNotificationEventsTableTableManager(_db, _db.rawNotificationEvents);
}
