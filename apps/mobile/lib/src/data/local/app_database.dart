import 'package:drift/drift.dart';

import 'connection/database_connection.dart';

part 'app_database.g.dart';

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

@DataClassName('CreditCardRow')
class CreditCards extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get provider => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get last4 => text().nullable()();
  IntColumn get billingDay => integer().nullable()();
  IntColumn get dueDay => integer().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get kind => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CostCenterRow')
class CostCenters extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get name => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MerchantRow')
class Merchants extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get normalizedName => text()();
  TextColumn get displayName => text()();
  TextColumn get providerHintsJson => text().nullable()();

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

@DataClassName('ReviewInboxRow')
class ReviewInbox extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get transactionId => text()();
  TextColumn get reason => text()();
  TextColumn get severity => text().withDefault(const Constant('medium'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();

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
    CreditCards,
    Categories,
    CostCenters,
    Merchants,
    Transactions,
    ReviewInbox,
    TransactionBeneficiaries,
    TransactionSources,
    SyncOutbox,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  AppDatabase.forTesting(super.executor);

  static const householdMain = 'household-main';

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(creditCards);
        await migrator.createTable(categories);
        await migrator.createTable(costCenters);
        await migrator.createTable(merchants);
        await migrator.createTable(reviewInbox);
      }
    },
  );

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

  Stream<List<ReviewInboxRow>> watchOpenReviewInbox() {
    final query = select(reviewInbox)
      ..where((row) => row.resolvedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    return query.watch();
  }

  Future<FinanceTransaction?> getTransaction(String id) {
    return (select(
      transactions,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<CategoryRow>> listCategories() {
    final query = select(categories)
      ..where((row) => row.householdId.equals(householdMain))
      ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]);
    return query.get();
  }

  Future<List<CostCenterRow>> listCostCenters() {
    final query = select(costCenters)
      ..where((row) => row.householdId.equals(householdMain))
      ..orderBy([(row) => OrderingTerm.asc(row.name)]);
    return query.get();
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

      batch.insertAll(creditCards, [
        CreditCardsCompanion.insert(
          id: 'nu-card',
          householdId: householdMain,
          provider: 'nubank',
          name: 'Nubank',
          brand: const Value('Mastercard'),
          last4: const Value('1234'),
          billingDay: const Value(20),
          dueDay: const Value(27),
        ),
      ]);

      batch.insertAll(categories, [
        _category('alimentacao', 'Alimentacao', 10),
        _category('saude', 'Saude', 20),
        _category('educacao', 'Educacao', 30),
        _category('transporte', 'Transporte', 40),
        _category('renda', 'Renda', 50),
      ]);

      batch.insertAll(costCenters, [
        _costCenter('casa', 'Casa'),
        _costCenter('filhos', 'Filhos'),
        _costCenter('pessoal', 'Pessoal'),
        _costCenter('trabalho', 'Trabalho'),
      ]);

      batch.insertAll(merchants, [
        _merchant('mercado-extra', 'mercado extra', 'Mercado Extra'),
        _merchant(
          'pague-menos',
          'farmacia pague menos',
          'Farmacia Pague Menos',
        ),
        _merchant('escola-sofia', 'escola sofia', 'Escola Sofia'),
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
          merchantId: 'mercado-extra',
          categoryId: 'alimentacao',
          costCenterId: 'casa',
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
          merchantId: 'pague-menos',
          categoryId: 'saude',
          costCenterId: 'filhos',
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
          merchantId: 'escola-sofia',
          categoryId: 'educacao',
          costCenterId: 'filhos',
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
          categoryId: 'renda',
          costCenterId: 'trabalho',
          occurredAt: now.subtract(const Duration(days: 2)),
          confidence: 1,
        ),
      ]);

      batch.insertAll(reviewInbox, [
        _reviewItem('tx-mercado', 'needs_user_confirmation', now),
        _reviewItem('tx-farmacia', 'suggestion_low_confidence', now),
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
    await _resolveReviewItem(id);
    await _enqueueOutbox(id, 'update');
  }

  Future<void> ignoreTransaction(String id) async {
    await (update(transactions)..where((row) => row.id.equals(id))).write(
      TransactionsCompanion(
        reviewStatus: const Value('ignored'),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _resolveReviewItem(id);
    await _enqueueOutbox(id, 'update');
  }

  Future<void> markProbableDuplicate(String id) async {
    await (update(transactions)..where((row) => row.id.equals(id))).write(
      TransactionsCompanion(
        duplicateStatus: const Value('probable'),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _enqueueOutbox(id, 'update');
  }

  Future<void> updateTransactionCore({
    required String id,
    required String description,
    required int amountCents,
    required String kind,
    required String? categoryId,
    required String? costCenterId,
  }) async {
    await (update(transactions)..where((row) => row.id.equals(id))).write(
      TransactionsCompanion(
        descriptionRaw: Value(description),
        amountCents: Value(amountCents),
        kind: Value(kind),
        categoryId: Value(categoryId),
        costCenterId: Value(costCenterId),
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
    await into(
      reviewInbox,
    ).insert(_reviewItem(id, 'manual_draft_needs_review', now));
    await _enqueueOutbox(id, 'create');
  }

  Future<void> _resolveReviewItem(String transactionId) async {
    await (update(reviewInbox)
          ..where((row) => row.transactionId.equals(transactionId))
          ..where((row) => row.resolvedAt.isNull()))
        .write(ReviewInboxCompanion(resolvedAt: Value(DateTime.now())));
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
    String? merchantId,
    String? categoryId,
    String? costCenterId,
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
      merchantId: Value(merchantId),
      categoryId: Value(categoryId),
      costCenterId: Value(costCenterId),
      payerId: const Value('eu'),
      sourceConfidence: Value(confidence),
      updatedAt: occurredAt,
    );
  }

  CategoriesCompanion _category(String id, String name, int sortOrder) {
    return CategoriesCompanion.insert(
      id: id,
      householdId: householdMain,
      name: name,
      kind: 'expense',
      sortOrder: Value(sortOrder),
    );
  }

  CostCentersCompanion _costCenter(String id, String name) {
    return CostCentersCompanion.insert(
      id: id,
      householdId: householdMain,
      name: name,
    );
  }

  MerchantsCompanion _merchant(
    String id,
    String normalizedName,
    String displayName,
  ) {
    return MerchantsCompanion.insert(
      id: id,
      householdId: householdMain,
      normalizedName: normalizedName,
      displayName: displayName,
    );
  }

  ReviewInboxCompanion _reviewItem(
    String transactionId,
    String reason,
    DateTime createdAt,
  ) {
    return ReviewInboxCompanion.insert(
      id: 'review-$transactionId',
      householdId: householdMain,
      transactionId: transactionId,
      reason: reason,
      createdAt: createdAt,
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
