import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final documents = await getApplicationDocumentsDirectory();
    final file = File(p.join(documents.path, 'zimbacontrol.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DataClassName('PersonRow')
class People extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get displayName => text()();
  TextColumn get kind => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get provider => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get currencyCode => text().withDefault(const Constant('BRL'))();
  TextColumn get last4 => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FinanceTransaction')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get kind => text()();
  TextColumn get reviewStatus => text()();
  TextColumn get duplicateStatus => text()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get postedAt => dateTime().nullable()();
  TextColumn get competenceMonth => text()();
  IntColumn get amountCents => integer()();
  TextColumn get currencyCode => text().withDefault(const Constant('BRL'))();
  TextColumn get descriptionRaw => text()();
  TextColumn get accountId => text().nullable()();
  TextColumn get merchantId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get costCenterId => text().nullable()();
  TextColumn get payerId => text().nullable()();
  RealColumn get sourceConfidence => real().withDefault(const Constant(0))();
  IntColumn get baseVersion => integer().withDefault(const Constant(0))();
  IntColumn get serverVersion => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TransactionBeneficiaryRow')
class TransactionBeneficiaries extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text()();
  TextColumn get personId => text()();
  TextColumn get allocationMode =>
      text().withDefault(const Constant('mark_only'))();
  IntColumn get allocatedAmountCents => integer().nullable()();
  RealColumn get allocatedPercent => real().nullable()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TransactionSourceRow')
class TransactionSources extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text()();
  TextColumn get sourceKind => text()();
  TextColumn get provider => text()();
  TextColumn get externalId => text().nullable()();
  TextColumn get fileHash => text().nullable()();
  TextColumn get rowHash => text().nullable()();
  TextColumn get notificationKey => text().nullable()();
  TextColumn get rawPayloadJson => text().nullable()();
  DateTimeColumn get occurredAt => dateTime().nullable()();
  RealColumn get confidence => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SyncOutboxRow')
class SyncOutbox extends Table {
  TextColumn get opId => text()();
  TextColumn get deviceId => text()();
  TextColumn get householdId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operationType => text()();
  IntColumn get baseVersion => integer().withDefault(const Constant(0))();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get sentAt => dateTime().nullable()();
  DateTimeColumn get ackAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {opId};
}

@DriftDatabase(
  tables: [
    People,
    Accounts,
    Transactions,
    TransactionBeneficiaries,
    TransactionSources,
    SyncOutbox,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  static const householdMain = 'household-main';

  @override
  int get schemaVersion => 1;

  Stream<List<FinanceTransaction>> watchRecentTransactions() {
    final query = select(transactions)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.occurredAt)])
      ..limit(20);
    return query.watch();
  }

  Stream<List<FinanceTransaction>> watchPendingReview() {
    final query = select(transactions)
      ..where((row) => row.reviewStatus.equals('pending'))
      ..orderBy([(row) => OrderingTerm.desc(row.occurredAt)]);
    return query.watch();
  }

  Stream<List<PersonRow>> watchPeople() {
    final query = select(people)
      ..where((row) => row.active.equals(true))
      ..orderBy([(row) => OrderingTerm.asc(row.displayName)]);
    return query.watch();
  }

  Future<void> seedIfEmpty() async {
    final existing = await (select(transactions)..limit(1)).getSingleOrNull();
    if (existing != null) {
      return;
    }

    final now = DateTime.now();

    await batch((batch) {
      batch.insertAll(people, [
        PeopleCompanion.insert(
          id: 'eu',
          householdId: householdMain,
          displayName: 'Voce',
          kind: 'adult',
        ),
        PeopleCompanion.insert(
          id: 'marina',
          householdId: householdMain,
          displayName: 'Marina',
          kind: 'adult',
        ),
        PeopleCompanion.insert(
          id: 'sofia',
          householdId: householdMain,
          displayName: 'Sofia',
          kind: 'child',
        ),
        PeopleCompanion.insert(
          id: 'bebe',
          householdId: householdMain,
          displayName: 'Bebe',
          kind: 'child',
        ),
      ]);

      batch.insertAll(accounts, [
        AccountsCompanion.insert(
          id: 'mp',
          householdId: householdMain,
          provider: 'mercado_pago',
          name: 'Mercado Pago',
          type: 'account',
        ),
        AccountsCompanion.insert(
          id: 'nu',
          householdId: householdMain,
          provider: 'nubank',
          name: 'Nubank',
          type: 'credit_card',
        ),
      ]);

      batch.insertAll(transactions, [
        _transaction(
          id: 'tx-mercado',
          kind: 'expense',
          reviewStatus: 'pending',
          duplicateStatus: 'none',
          amountCents: -48732,
          description: 'Mercado Extra',
          accountId: 'nu',
          occurredAt: now.subtract(const Duration(hours: 3)),
          confidence: 0.82,
        ),
        _transaction(
          id: 'tx-farmacia',
          kind: 'expense',
          reviewStatus: 'pending',
          duplicateStatus: 'none',
          amountCents: -8990,
          description: 'Farmacia Pague Menos',
          accountId: 'mp',
          occurredAt: now.subtract(const Duration(hours: 6)),
          confidence: 0.76,
        ),
        _transaction(
          id: 'tx-escola',
          kind: 'expense',
          reviewStatus: 'confirmed',
          duplicateStatus: 'none',
          amountCents: -129000,
          description: 'Escola Sofia mensalidade',
          accountId: 'mp',
          occurredAt: now.subtract(const Duration(days: 1)),
          confidence: 0.95,
        ),
        _transaction(
          id: 'tx-salario',
          kind: 'income',
          reviewStatus: 'confirmed',
          duplicateStatus: 'none',
          amountCents: 1280000,
          description: 'Salario',
          accountId: 'mp',
          occurredAt: now.subtract(const Duration(days: 2)),
          confidence: 1,
        ),
      ]);

      batch.insertAll(transactionBeneficiaries, [
        _beneficiary('tx-mercado', 'eu', true),
        _beneficiary('tx-mercado', 'marina', false),
        _beneficiary('tx-mercado', 'sofia', false),
        _beneficiary('tx-mercado', 'bebe', false),
        _beneficiary('tx-farmacia', 'bebe', true),
        _beneficiary('tx-escola', 'sofia', true),
        _beneficiary('tx-salario', 'eu', true),
      ]);
    });
  }

  Future<void> confirmTransaction(String id) async {
    await (update(transactions)..where((row) => row.id.equals(id))).write(
      TransactionsCompanion(
        reviewStatus: const Value('confirmed'),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _enqueueOutbox(id, 'update');
  }

  Future<void> createManualDraft() async {
    final now = DateTime.now();
    final id = 'tx-manual-${now.microsecondsSinceEpoch}';
    await into(transactions).insert(
      _transaction(
        id: id,
        kind: 'expense',
        reviewStatus: 'pending',
        duplicateStatus: 'none',
        amountCents: -2450,
        description: 'Lancamento manual',
        accountId: 'mp',
        occurredAt: now,
        confidence: 0.4,
      ),
    );
    await into(transactionBeneficiaries).insert(_beneficiary(id, 'eu', true));
    await _enqueueOutbox(id, 'create');
  }

  Future<void> _enqueueOutbox(String entityId, String operationType) async {
    final now = DateTime.now();
    await into(syncOutbox).insert(
      SyncOutboxCompanion.insert(
        opId: 'op-${now.microsecondsSinceEpoch}',
        deviceId: 'local-dev-device',
        householdId: householdMain,
        entityType: 'transaction',
        entityId: entityId,
        operationType: operationType,
        payloadJson: '{"entityId":"$entityId"}',
        createdAt: now,
      ),
    );
  }

  TransactionsCompanion _transaction({
    required String id,
    required String kind,
    required String reviewStatus,
    required String duplicateStatus,
    required int amountCents,
    required String description,
    required DateTime occurredAt,
    required double confidence,
    String? accountId,
  }) {
    final month =
        '${occurredAt.year.toString().padLeft(4, '0')}-'
        '${occurredAt.month.toString().padLeft(2, '0')}';

    return TransactionsCompanion.insert(
      id: id,
      householdId: householdMain,
      kind: kind,
      reviewStatus: reviewStatus,
      duplicateStatus: duplicateStatus,
      occurredAt: occurredAt,
      competenceMonth: month,
      amountCents: amountCents,
      descriptionRaw: description,
      accountId: Value(accountId),
      payerId: const Value('eu'),
      sourceConfidence: Value(confidence),
      updatedAt: occurredAt,
    );
  }

  TransactionBeneficiariesCompanion _beneficiary(
    String transactionId,
    String personId,
    bool isPrimary,
  ) {
    return TransactionBeneficiariesCompanion.insert(
      id: '$transactionId-$personId',
      transactionId: transactionId,
      personId: personId,
      isPrimary: Value(isPrimary),
    );
  }
}
