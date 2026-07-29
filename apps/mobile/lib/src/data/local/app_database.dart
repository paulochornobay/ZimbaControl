import 'package:drift/drift.dart';

import '../../application/import_parser.dart';
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
  TextColumn get ownerPersonId => text().nullable()();
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
  TextColumn get ownerPersonId => text().nullable()();
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
  TextColumn get transferFromAccountId => text().nullable()();
  TextColumn get transferToAccountId => text().nullable()();
  TextColumn get recurringScheduleId => text().nullable()();
  TextColumn get installmentPlanId => text().nullable()();
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

@DataClassName('AppPreferenceRow')
class AppPreferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('AuthUserRow')
class AuthUsers extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get email => text()();
  TextColumn get provider => text()();
  TextColumn get linkedPersonId => text().nullable()();
  BoolColumn get allowed => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RecurringScheduleRow')
class RecurringSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get label => text()();
  TextColumn get kind => text()();
  IntColumn get amountCents => integer()();
  TextColumn get currencyCode => text().withDefault(const Constant('BRL'))();
  TextColumn get frequency => text().withDefault(const Constant('monthly'))();
  IntColumn get dayOfMonth => integer()();
  TextColumn get startMonth => text()();
  TextColumn get endMonth => text().nullable()();
  TextColumn get payerPersonId => text().nullable()();
  TextColumn get beneficiaryPersonId => text().nullable()();
  TextColumn get fromAccountId => text().nullable()();
  TextColumn get toAccountId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get costCenterId => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('InstallmentPlanRow')
class InstallmentPlans extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get label => text()();
  TextColumn get planKind => text()();
  TextColumn get ownerPersonId => text().nullable()();
  TextColumn get assetName => text().nullable()();
  IntColumn get totalAmountCents => integer().nullable()();
  IntColumn get installmentAmountCents => integer()();
  IntColumn get currentInstallment => integer()();
  IntColumn get totalInstallments => integer()();
  IntColumn get dueDay => integer().nullable()();
  TextColumn get startMonth => text()();
  TextColumn get endMonth => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get costCenterId => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ImportBatchRow')
class ImportBatches extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get fileName => text()();
  TextColumn get fileHash => text()();
  TextColumn get fileFormat => text()();
  TextColumn get provider => text()();
  DateTimeColumn get importedAt => dateTime()();
  IntColumn get totalRows => integer().withDefault(const Constant(0))();
  IntColumn get validRows => integer().withDefault(const Constant(0))();
  IntColumn get invalidRows => integer().withDefault(const Constant(0))();
  IntColumn get duplicateRows => integer().withDefault(const Constant(0))();
  IntColumn get reviewRows => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('staged'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StagedSourceRecordRow')
class StagedSourceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get batchId => text()();
  TextColumn get householdId => text()();
  TextColumn get sourceKind => text()();
  TextColumn get provider => text()();
  IntColumn get rowIndex => integer()();
  TextColumn get rowHash => text()();
  TextColumn get externalId => text().nullable()();
  DateTimeColumn get occurredAt => dateTime().nullable()();
  DateTimeColumn get postedAt => dateTime().nullable()();
  TextColumn get descriptionRaw => text().nullable()();
  IntColumn get amountCents => integer().nullable()();
  TextColumn get currencyCode => text().withDefault(const Constant('BRL'))();
  TextColumn get accountHint => text().nullable()();
  TextColumn get status => text()();
  TextColumn get duplicateOfTransactionId => text().nullable()();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get rawPayloadJson => text().nullable()();
  RealColumn get confidence => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get promotedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
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
    AppPreferences,
    AuthUsers,
    RecurringSchedules,
    InstallmentPlans,
    ImportBatches,
    StagedSourceRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  AppDatabase.forTesting(super.executor);

  static const householdMain = 'household-main';
  static const reviewFilterPreferenceKey = 'review_filter';

  @override
  int get schemaVersion => 5;

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
      if (from < 3) {
        await migrator.createTable(appPreferences);
      }
      if (from < 4) {
        await migrator.addColumn(accounts, accounts.ownerPersonId);
        await migrator.addColumn(creditCards, creditCards.ownerPersonId);
        await migrator.addColumn(
          transactions,
          transactions.transferFromAccountId,
        );
        await migrator.addColumn(
          transactions,
          transactions.transferToAccountId,
        );
        await migrator.addColumn(
          transactions,
          transactions.recurringScheduleId,
        );
        await migrator.addColumn(transactions, transactions.installmentPlanId);
        await migrator.createTable(authUsers);
        await migrator.createTable(recurringSchedules);
        await migrator.createTable(installmentPlans);
      }
      if (from < 5) {
        await migrator.createTable(importBatches);
        await migrator.createTable(stagedSourceRecords);
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

  Stream<List<ReviewTransactionDetails>> watchPendingReviewDetails() {
    return watchPendingReview().asyncMap(_hydrateReviewTransactions);
  }

  Stream<String> watchReviewFilter() {
    final query = select(appPreferences)
      ..where((row) => row.key.equals(reviewFilterPreferenceKey));
    return query.watchSingleOrNull().map((row) => row?.value ?? 'all');
  }

  Future<void> setReviewFilter(String filter) {
    return into(appPreferences).insertOnConflictUpdate(
      AppPreferencesCompanion.insert(
        key: reviewFilterPreferenceKey,
        value: filter,
        updatedAt: DateTime.now(),
      ),
    );
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

  Future<List<AccountWithOwner>> listAccountsWithOwners() async {
    final accountRows =
        await (select(accounts)
              ..where((row) => row.householdId.equals(householdMain))
              ..orderBy([(row) => OrderingTerm.asc(row.name)]))
            .get();
    final owners = await _peopleByIds(
      accountRows.map((row) => row.ownerPersonId).whereType<String>().toSet(),
    );

    return [
      for (final account in accountRows)
        AccountWithOwner(
          account: account,
          owner: account.ownerPersonId == null
              ? null
              : owners[account.ownerPersonId],
        ),
    ];
  }

  Future<List<CreditCardWithOwner>> listCreditCardsWithOwners() async {
    final cardRows =
        await (select(creditCards)
              ..where((row) => row.householdId.equals(householdMain))
              ..orderBy([(row) => OrderingTerm.asc(row.name)]))
            .get();
    final owners = await _peopleByIds(
      cardRows.map((row) => row.ownerPersonId).whereType<String>().toSet(),
    );

    return [
      for (final card in cardRows)
        CreditCardWithOwner(
          creditCard: card,
          owner: card.ownerPersonId == null ? null : owners[card.ownerPersonId],
        ),
    ];
  }

  Future<List<AuthUserRow>> listAuthUsers() {
    final query = select(authUsers)
      ..where((row) => row.householdId.equals(householdMain))
      ..orderBy([(row) => OrderingTerm.asc(row.email)]);
    return query.get();
  }

  Future<List<RecurringScheduleRow>> listRecurringSchedules() {
    final query = select(recurringSchedules)
      ..where((row) => row.householdId.equals(householdMain))
      ..orderBy([(row) => OrderingTerm.asc(row.dayOfMonth)]);
    return query.get();
  }

  Future<List<InstallmentPlanRow>> listInstallmentPlans() {
    final query = select(installmentPlans)
      ..where((row) => row.householdId.equals(householdMain))
      ..orderBy([(row) => OrderingTerm.asc(row.dueDay)]);
    return query.get();
  }

  Future<List<ImportBatchRow>> listImportBatches() {
    final query = select(importBatches)
      ..where((row) => row.householdId.equals(householdMain))
      ..orderBy([(row) => OrderingTerm.desc(row.importedAt)]);
    return query.get();
  }

  Future<List<StagedSourceRecordRow>> listStagedRecords(String batchId) {
    final query = select(stagedSourceRecords)
      ..where((row) => row.batchId.equals(batchId))
      ..orderBy([(row) => OrderingTerm.asc(row.rowIndex)]);
    return query.get();
  }

  Future<ImportBatchDetails?> getLatestImportBatchDetails() async {
    final batch =
        await (select(importBatches)
              ..where((row) => row.householdId.equals(householdMain))
              ..orderBy([(row) => OrderingTerm.desc(row.importedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (batch == null) {
      return null;
    }

    return ImportBatchDetails(
      batch: batch,
      records: await listStagedRecords(batch.id),
    );
  }

  Future<ImportBatchDetails> importStatementFile({
    required String fileName,
    required List<int> bytes,
    CsvImportMapping? csvMapping,
  }) async {
    final parsed = parseStatementFile(
      fileName: fileName,
      bytes: bytes,
      csvMapping: csvMapping,
    );
    final now = DateTime.now();
    final batchId = 'batch-${now.microsecondsSinceEpoch}';
    var valid = 0;
    var invalid = 0;
    var duplicate = 0;
    var review = 0;
    final staged = <StagedSourceRecordsCompanion>[];

    for (final record in parsed.records) {
      final duplicateTransactionId = await _findDuplicateSource(
        fileHash: parsed.fileHash,
        rowHash: record.rowHash,
        externalId: record.externalId,
        provider: record.provider,
      );
      final alreadyStaged = await _hasStagedSource(
        fileHash: parsed.fileHash,
        rowHash: record.rowHash,
      );
      final status = !record.isValid
          ? 'invalid'
          : duplicateTransactionId != null || alreadyStaged
          ? 'duplicate'
          : 'needs_review';

      switch (status) {
        case 'invalid':
          invalid += 1;
        case 'duplicate':
          duplicate += 1;
        default:
          valid += 1;
          review += 1;
      }

      staged.add(
        StagedSourceRecordsCompanion.insert(
          id: 'staged-$batchId-${record.rowIndex}',
          batchId: batchId,
          householdId: householdMain,
          sourceKind: record.sourceKind,
          provider: record.provider,
          rowIndex: record.rowIndex,
          rowHash: record.rowHash,
          externalId: Value(record.externalId),
          occurredAt: Value(record.occurredAt),
          postedAt: Value(record.postedAt),
          descriptionRaw: Value(record.description),
          amountCents: Value(record.amountCents),
          currencyCode: Value(record.currencyCode),
          accountHint: Value(record.accountHint),
          status: status,
          duplicateOfTransactionId: Value(duplicateTransactionId),
          errorMessage: Value(record.errorMessage),
          rawPayloadJson: Value(record.rawPayload),
          confidence: Value(record.confidence),
          createdAt: now,
        ),
      );
    }

    final batchCompanion = ImportBatchesCompanion.insert(
      id: batchId,
      householdId: householdMain,
      fileName: fileName,
      fileHash: parsed.fileHash,
      fileFormat: parsed.fileFormat,
      provider: parsed.provider,
      importedAt: now,
      totalRows: Value(parsed.records.length),
      validRows: Value(valid),
      invalidRows: Value(invalid),
      duplicateRows: Value(duplicate),
      reviewRows: Value(review),
      status: const Value('staged'),
    );

    await into(importBatches).insert(batchCompanion);
    if (staged.isNotEmpty) {
      await batch((batch) {
        batch.insertAll(stagedSourceRecords, staged);
      });
    }

    return ImportBatchDetails(
      batch: ImportBatchRow(
        id: batchId,
        householdId: householdMain,
        fileName: fileName,
        fileHash: parsed.fileHash,
        fileFormat: parsed.fileFormat,
        provider: parsed.provider,
        importedAt: now,
        totalRows: parsed.records.length,
        validRows: valid,
        invalidRows: invalid,
        duplicateRows: duplicate,
        reviewRows: review,
        status: 'staged',
      ),
      records: await listStagedRecords(batchId),
    );
  }

  Future<int> promoteImportBatchToReview(String batchId) async {
    final importBatch = await (select(
      importBatches,
    )..where((batch) => batch.id.equals(batchId))).getSingle();
    final rows =
        await (select(stagedSourceRecords)
              ..where((row) => row.batchId.equals(batchId))
              ..where((row) => row.status.equals('needs_review')))
            .get();
    var promoted = 0;

    for (final row in rows) {
      if (row.descriptionRaw == null ||
          row.amountCents == null ||
          row.occurredAt == null) {
        continue;
      }

      final txId = 'tx-import-${row.id}';
      final existing = await getTransaction(txId);
      if (existing != null) {
        continue;
      }

      await into(transactions).insert(
        _transaction(
          id: txId,
          kind: row.amountCents! >= 0 ? 'income' : 'expense',
          reviewStatus: 'pending',
          duplicateStatus: 'none',
          amountCents: row.amountCents!,
          description: row.descriptionRaw!,
          accountId: _accountForProvider(row.provider),
          occurredAt: row.occurredAt!,
          confidence: row.confidence,
        ),
      );
      await into(
        transactionBeneficiaries,
      ).insert(_beneficiary(txId, 'eu', true));
      await into(reviewInbox).insert(
        _reviewItem(txId, 'imported_statement_needs_review', DateTime.now()),
      );
      await into(transactionSources).insert(
        TransactionSourcesCompanion.insert(
          id: 'src-$txId',
          transactionId: txId,
          sourceKind: row.sourceKind,
          provider: row.provider,
          externalId: Value(row.externalId),
          fileHash: Value(importBatch.fileHash),
          rowHash: Value(row.rowHash),
          rawPayloadJson: Value(row.rawPayloadJson),
          occurredAt: Value(row.occurredAt),
          confidence: Value(row.confidence),
        ),
      );
      await (update(
        stagedSourceRecords,
      )..where((item) => item.id.equals(row.id))).write(
        StagedSourceRecordsCompanion(
          status: const Value('promoted'),
          promotedAt: Value(DateTime.now()),
        ),
      );
      await _enqueueOutbox(txId, 'create');
      promoted += 1;
    }

    await (update(importBatches)..where((row) => row.id.equals(batchId))).write(
      const ImportBatchesCompanion(
        reviewRows: Value(0),
        status: Value('promoted'),
      ),
    );

    return promoted;
  }

  Future<FamilyStructureSnapshot> getFamilyStructureSnapshot() async {
    final peopleRows = await watchPeople().first;
    final accounts = await listAccountsWithOwners();
    final cards = await listCreditCardsWithOwners();
    final auth = await listAuthUsers();
    final schedules = await listRecurringSchedules();
    final plans = await listInstallmentPlans();

    return FamilyStructureSnapshot(
      people: peopleRows,
      accounts: accounts,
      creditCards: cards,
      authUsers: auth,
      recurringSchedules: schedules,
      installmentPlans: plans,
    );
  }

  Future<void> seedIfEmpty() async {
    final existing = await (select(transactions)..limit(1)).getSingleOrNull();
    if (existing == null) {
      await _seedInitialData(DateTime.now());
    }

    await ensureFamilyStructureSeed();
  }

  Future<void> _seedInitialData(DateTime now) async {
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
          ownerPersonId: const Value('eu'),
          provider: 'mercado_pago',
          name: 'Mercado Pago',
          type: 'account',
        ),
        AccountsCompanion.insert(
          id: 'nu',
          householdId: householdMain,
          ownerPersonId: const Value('eu'),
          provider: 'nubank',
          name: 'Nubank',
          type: 'credit_card',
        ),
      ]);

      batch.insertAll(creditCards, [
        CreditCardsCompanion.insert(
          id: 'nu-card',
          householdId: householdMain,
          ownerPersonId: const Value('eu'),
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
        _category('renda', 'Renda', 50, kind: 'income'),
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
          recurringScheduleId: 'rec-escola-sofia',
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

      batch.insertAll(transactionSources, [
        _source(
          id: 'src-tx-mercado-notif',
          transactionId: 'tx-mercado',
          sourceKind: 'notification',
          provider: 'nubank',
          confidence: 0.82,
          occurredAt: now.subtract(const Duration(hours: 3)),
        ),
        _source(
          id: 'src-tx-farmacia-notif',
          transactionId: 'tx-farmacia',
          sourceKind: 'notification',
          provider: 'mercado_pago',
          confidence: 0.76,
          occurredAt: now.subtract(const Duration(hours: 6)),
        ),
        _source(
          id: 'src-tx-escola-manual',
          transactionId: 'tx-escola',
          sourceKind: 'manual',
          provider: 'zimba_control',
          confidence: 0.95,
          occurredAt: now.subtract(const Duration(days: 1)),
        ),
        _source(
          id: 'src-tx-salario-manual',
          transactionId: 'tx-salario',
          sourceKind: 'manual',
          provider: 'zimba_control',
          confidence: 1,
          occurredAt: now.subtract(const Duration(days: 2)),
        ),
      ]);
    });
  }

  Future<void> ensureFamilyStructureSeed() async {
    final now = DateTime.now();
    final currentMonth =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}';

    await into(accounts).insert(
      AccountsCompanion.insert(
        id: 'marina-conta',
        householdId: householdMain,
        ownerPersonId: const Value('marina'),
        provider: 'manual',
        name: 'Conta Marina',
        type: 'account',
      ),
      mode: InsertMode.insertOrIgnore,
    );

    await (update(accounts)..where((row) => row.id.equals('mp'))).write(
      const AccountsCompanion(ownerPersonId: Value('eu')),
    );
    await (update(accounts)..where((row) => row.id.equals('nu'))).write(
      const AccountsCompanion(ownerPersonId: Value('eu')),
    );
    await (update(creditCards)..where((row) => row.id.equals('nu-card'))).write(
      const CreditCardsCompanion(ownerPersonId: Value('eu')),
    );

    await into(authUsers).insert(
      AuthUsersCompanion.insert(
        id: 'auth-test-owner',
        householdId: householdMain,
        email: 'teste@zimbacontrol.local',
        provider: 'google_oidc_future',
        linkedPersonId: const Value('eu'),
        createdAt: now,
      ),
      mode: InsertMode.insertOrIgnore,
    );

    await into(merchants).insert(
      _merchant('consorcio-auto', 'consorcio auto', 'Consorcio Auto'),
      mode: InsertMode.insertOrIgnore,
    );
    await into(merchants).insert(
      _merchant('pensao-sofia', 'pensao sofia', 'Pensao Sofia'),
      mode: InsertMode.insertOrIgnore,
    );

    await _insertRecurringSchedule(
      _recurringSchedule(
        id: 'rec-escola-sofia',
        label: 'Escola da Sofia',
        kind: 'expense',
        amountCents: -129000,
        dayOfMonth: 5,
        startMonth: currentMonth,
        payerPersonId: 'eu',
        beneficiaryPersonId: 'sofia',
        fromAccountId: 'mp',
        categoryId: 'educacao',
        costCenterId: 'filhos',
        updatedAt: now,
      ),
    );
    await _insertRecurringSchedule(
      _recurringSchedule(
        id: 'rec-pensao-sofia',
        label: 'Pensao destinada a Sofia',
        kind: 'income',
        amountCents: 90000,
        dayOfMonth: 10,
        startMonth: currentMonth,
        beneficiaryPersonId: 'sofia',
        toAccountId: 'mp',
        categoryId: 'renda',
        costCenterId: 'filhos',
        updatedAt: now,
      ),
    );
    await _insertRecurringSchedule(
      _recurringSchedule(
        id: 'rec-ajuda-marina',
        label: 'Ajuda familiar para Marina',
        kind: 'transfer',
        amountCents: -250000,
        dayOfMonth: 1,
        startMonth: currentMonth,
        payerPersonId: 'eu',
        beneficiaryPersonId: 'marina',
        fromAccountId: 'mp',
        toAccountId: 'marina-conta',
        updatedAt: now,
      ),
    );

    await into(installmentPlans).insert(
      InstallmentPlansCompanion.insert(
        id: 'plan-consorcio-carro',
        householdId: householdMain,
        label: 'Consorcio do carro',
        planKind: 'vehicle_consortium',
        ownerPersonId: const Value('eu'),
        assetName: const Value('Carro consorciado'),
        totalAmountCents: const Value(6000000),
        installmentAmountCents: 98500,
        currentInstallment: 18,
        totalInstallments: 72,
        dueDay: const Value(15),
        startMonth: currentMonth,
        categoryId: const Value('transporte'),
        costCenterId: const Value('casa'),
        updatedAt: now,
      ),
      mode: InsertMode.insertOrIgnore,
    );

    await _insertTransactionIfAbsent(
      _transaction(
        id: 'tx-ajuda-marina',
        kind: 'transfer',
        reviewStatus: 'confirmed',
        duplicateStatus: 'none',
        amountCents: -250000,
        description: 'Ajuda familiar para Marina',
        accountId: 'mp',
        transferFromAccountId: 'mp',
        transferToAccountId: 'marina-conta',
        recurringScheduleId: 'rec-ajuda-marina',
        occurredAt: now.subtract(const Duration(days: 3)),
        confidence: 1,
      ),
    );
    await _insertTransactionIfAbsent(
      _transaction(
        id: 'tx-pensao-sofia',
        kind: 'income',
        reviewStatus: 'confirmed',
        duplicateStatus: 'none',
        amountCents: 90000,
        description: 'Pensao Sofia',
        accountId: 'mp',
        merchantId: 'pensao-sofia',
        categoryId: 'renda',
        costCenterId: 'filhos',
        recurringScheduleId: 'rec-pensao-sofia',
        occurredAt: now.subtract(const Duration(days: 4)),
        confidence: 1,
      ),
    );
    await _insertTransactionIfAbsent(
      _transaction(
        id: 'tx-consorcio-carro',
        kind: 'expense',
        reviewStatus: 'confirmed',
        duplicateStatus: 'none',
        amountCents: -98500,
        description: 'Consorcio do carro',
        accountId: 'mp',
        merchantId: 'consorcio-auto',
        categoryId: 'transporte',
        costCenterId: 'casa',
        installmentPlanId: 'plan-consorcio-carro',
        occurredAt: now.subtract(const Duration(days: 5)),
        confidence: 1,
      ),
    );

    await _insertBeneficiaryIfAbsent(
      _beneficiary('tx-ajuda-marina', 'marina', true),
    );
    await _insertBeneficiaryIfAbsent(
      _beneficiary('tx-pensao-sofia', 'sofia', true),
    );
    await _insertBeneficiaryIfAbsent(
      _beneficiary('tx-consorcio-carro', 'eu', true),
    );

    await _insertSourceIfAbsent(
      _source(
        id: 'src-tx-ajuda-marina-rec',
        transactionId: 'tx-ajuda-marina',
        sourceKind: 'manual',
        provider: 'recurring_schedule',
        confidence: 1,
        occurredAt: now.subtract(const Duration(days: 3)),
      ),
    );
    await _insertSourceIfAbsent(
      _source(
        id: 'src-tx-pensao-sofia-rec',
        transactionId: 'tx-pensao-sofia',
        sourceKind: 'manual',
        provider: 'recurring_schedule',
        confidence: 1,
        occurredAt: now.subtract(const Duration(days: 4)),
      ),
    );
    await _insertSourceIfAbsent(
      _source(
        id: 'src-tx-consorcio-carro-plan',
        transactionId: 'tx-consorcio-carro',
        sourceKind: 'manual',
        provider: 'installment_plan',
        confidence: 1,
        occurredAt: now.subtract(const Duration(days: 5)),
      ),
    );
  }

  Future<ReviewActionSnapshot?> captureReviewSnapshot(String id) async {
    final transaction = await getTransaction(id);
    if (transaction == null) {
      return null;
    }

    final openReviewItems =
        await (select(reviewInbox)
              ..where((row) => row.transactionId.equals(id))
              ..where((row) => row.resolvedAt.isNull()))
            .get();

    return ReviewActionSnapshot(
      transaction: transaction,
      openReviewItems: openReviewItems,
    );
  }

  Future<void> restoreReviewSnapshot(ReviewActionSnapshot snapshot) async {
    final tx = snapshot.transaction;
    await (update(transactions)..where((row) => row.id.equals(tx.id))).write(
      TransactionsCompanion(
        kind: Value(tx.kind),
        reviewStatus: Value(tx.reviewStatus),
        duplicateStatus: Value(tx.duplicateStatus),
        categoryId: Value(tx.categoryId),
        costCenterId: Value(tx.costCenterId),
        updatedAt: Value(DateTime.now()),
      ),
    );

    if (tx.reviewStatus == 'pending') {
      final reopened =
          await (update(reviewInbox)
                ..where((row) => row.transactionId.equals(tx.id)))
              .write(const ReviewInboxCompanion(resolvedAt: Value(null)));

      if (reopened == 0) {
        await into(
          reviewInbox,
        ).insert(_reviewItem(tx.id, 'restored_after_undo', DateTime.now()));
      }
    }

    await _enqueueOutbox(tx.id, 'update');
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

  Future<void> markDuplicateAndResolve(String id) async {
    await (update(transactions)..where((row) => row.id.equals(id))).write(
      TransactionsCompanion(
        reviewStatus: const Value('ignored'),
        duplicateStatus: const Value('duplicate'),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _resolveReviewItem(id);
    await _enqueueOutbox(id, 'update');
  }

  Future<void> convertToTransfer(String id) async {
    await (update(transactions)..where((row) => row.id.equals(id))).write(
      TransactionsCompanion(
        kind: const Value('transfer'),
        reviewStatus: const Value('confirmed'),
        duplicateStatus: const Value('none'),
        categoryId: const Value(null),
        costCenterId: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _resolveReviewItem(id);
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
    await into(transactionSources).insert(
      _source(
        id: 'src-$id-manual',
        transactionId: id,
        sourceKind: 'manual',
        provider: 'zimba_control',
        confidence: 0.4,
        occurredAt: now,
      ),
    );
    await into(
      reviewInbox,
    ).insert(_reviewItem(id, 'manual_draft_needs_review', now));
    await _enqueueOutbox(id, 'create');
  }

  Future<String> createInternalTransfer({
    required String fromAccountId,
    required String toAccountId,
    required int amountCents,
    required String description,
    required String payerPersonId,
    required String beneficiaryPersonId,
    DateTime? occurredAt,
  }) async {
    final now = DateTime.now();
    final happenedAt = occurredAt ?? now;
    final id = 'tx-transfer-${now.microsecondsSinceEpoch}';
    final signedAmount = amountCents > 0 ? -amountCents : amountCents;

    await into(transactions).insert(
      _transaction(
        id: id,
        kind: 'transfer',
        reviewStatus: 'confirmed',
        duplicateStatus: 'none',
        amountCents: signedAmount,
        description: description,
        accountId: fromAccountId,
        transferFromAccountId: fromAccountId,
        transferToAccountId: toAccountId,
        occurredAt: happenedAt,
        confidence: 1,
        payerPersonId: payerPersonId,
      ),
    );
    await into(
      transactionBeneficiaries,
    ).insert(_beneficiary(id, beneficiaryPersonId, true));
    await into(transactionSources).insert(
      _source(
        id: 'src-$id-manual',
        transactionId: id,
        sourceKind: 'manual',
        provider: 'internal_transfer',
        confidence: 1,
        occurredAt: happenedAt,
      ),
    );
    await _enqueueOutbox(id, 'create');

    return id;
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

  Future<void> _insertTransactionIfAbsent(TransactionsCompanion transaction) {
    return into(
      transactions,
    ).insert(transaction, mode: InsertMode.insertOrIgnore);
  }

  Future<void> _insertBeneficiaryIfAbsent(
    TransactionBeneficiariesCompanion beneficiary,
  ) {
    return into(
      transactionBeneficiaries,
    ).insert(beneficiary, mode: InsertMode.insertOrIgnore);
  }

  Future<void> _insertSourceIfAbsent(TransactionSourcesCompanion source) {
    return into(
      transactionSources,
    ).insert(source, mode: InsertMode.insertOrIgnore);
  }

  Future<void> _insertRecurringSchedule(RecurringSchedulesCompanion schedule) {
    return into(
      recurringSchedules,
    ).insert(schedule, mode: InsertMode.insertOrIgnore);
  }

  Future<String?> _findDuplicateSource({
    required String fileHash,
    required String rowHash,
    required String? externalId,
    required String provider,
  }) async {
    final exact =
        await (select(transactionSources)
              ..where((row) => row.fileHash.equals(fileHash))
              ..where((row) => row.rowHash.equals(rowHash))
              ..limit(1))
            .getSingleOrNull();
    if (exact != null) {
      return exact.transactionId;
    }

    if (externalId == null || externalId.isEmpty) {
      return null;
    }

    final byExternalId =
        await (select(transactionSources)
              ..where((row) => row.provider.equals(provider))
              ..where((row) => row.externalId.equals(externalId))
              ..limit(1))
            .getSingleOrNull();

    return byExternalId?.transactionId;
  }

  Future<bool> _hasStagedSource({
    required String fileHash,
    required String rowHash,
  }) async {
    final batches = await (select(
      importBatches,
    )..where((row) => row.fileHash.equals(fileHash))).get();
    if (batches.isEmpty) {
      return false;
    }

    final batchIds = batches.map((batch) => batch.id).toSet();
    final existing =
        await (select(stagedSourceRecords)
              ..where((row) => row.batchId.isIn(batchIds))
              ..where((row) => row.rowHash.equals(rowHash))
              ..limit(1))
            .getSingleOrNull();
    return existing != null;
  }

  String? _accountForProvider(String provider) {
    return switch (provider) {
      'nubank' => 'nu',
      'mercado_pago' => 'mp',
      _ => null,
    };
  }

  Future<Map<String, PersonRow>> _peopleByIds(Set<String> ids) async {
    if (ids.isEmpty) {
      return const {};
    }

    final rows = await (select(people)..where((row) => row.id.isIn(ids))).get();
    return {for (final row in rows) row.id: row};
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
    String? transferFromAccountId,
    String? transferToAccountId,
    String? recurringScheduleId,
    String? installmentPlanId,
    String? merchantId,
    String? categoryId,
    String? costCenterId,
    String payerPersonId = 'eu',
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
      transferFromAccountId: Value(transferFromAccountId),
      transferToAccountId: Value(transferToAccountId),
      recurringScheduleId: Value(recurringScheduleId),
      installmentPlanId: Value(installmentPlanId),
      merchantId: Value(merchantId),
      categoryId: Value(categoryId),
      costCenterId: Value(costCenterId),
      payerId: Value(payerPersonId),
      sourceConfidence: Value(confidence),
      updatedAt: occurredAt,
    );
  }

  CategoriesCompanion _category(
    String id,
    String name,
    int sortOrder, {
    String kind = 'expense',
  }) {
    return CategoriesCompanion.insert(
      id: id,
      householdId: householdMain,
      name: name,
      kind: kind,
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

  TransactionSourcesCompanion _source({
    required String id,
    required String transactionId,
    required String sourceKind,
    required String provider,
    required double confidence,
    DateTime? occurredAt,
  }) {
    return TransactionSourcesCompanion.insert(
      id: id,
      transactionId: transactionId,
      sourceKind: sourceKind,
      provider: provider,
      confidence: Value(confidence),
      occurredAt: Value(occurredAt),
    );
  }

  RecurringSchedulesCompanion _recurringSchedule({
    required String id,
    required String label,
    required String kind,
    required int amountCents,
    required int dayOfMonth,
    required String startMonth,
    required DateTime updatedAt,
    String? payerPersonId,
    String? beneficiaryPersonId,
    String? fromAccountId,
    String? toAccountId,
    String? categoryId,
    String? costCenterId,
  }) {
    return RecurringSchedulesCompanion.insert(
      id: id,
      householdId: householdMain,
      label: label,
      kind: kind,
      amountCents: amountCents,
      dayOfMonth: dayOfMonth,
      startMonth: startMonth,
      payerPersonId: Value(payerPersonId),
      beneficiaryPersonId: Value(beneficiaryPersonId),
      fromAccountId: Value(fromAccountId),
      toAccountId: Value(toAccountId),
      categoryId: Value(categoryId),
      costCenterId: Value(costCenterId),
      updatedAt: updatedAt,
    );
  }

  Future<List<ReviewTransactionDetails>> _hydrateReviewTransactions(
    List<FinanceTransaction> transactions,
  ) async {
    if (transactions.isEmpty) {
      return const [];
    }

    final transactionIds = transactions.map((tx) => tx.id).toSet();
    final accountIds = transactions
        .map((tx) => tx.accountId)
        .whereType<String>()
        .toSet();
    final merchantIds = transactions
        .map((tx) => tx.merchantId)
        .whereType<String>()
        .toSet();
    final categoryIds = transactions
        .map((tx) => tx.categoryId)
        .whereType<String>()
        .toSet();
    final costCenterIds = transactions
        .map((tx) => tx.costCenterId)
        .whereType<String>()
        .toSet();

    final accountRows = accountIds.isEmpty
        ? const <AccountRow>[]
        : await (select(
            accounts,
          )..where((row) => row.id.isIn(accountIds))).get();
    final merchantRows = merchantIds.isEmpty
        ? const <MerchantRow>[]
        : await (select(
            merchants,
          )..where((row) => row.id.isIn(merchantIds))).get();
    final categoryRows = categoryIds.isEmpty
        ? const <CategoryRow>[]
        : await (select(
            categories,
          )..where((row) => row.id.isIn(categoryIds))).get();
    final costCenterRows = costCenterIds.isEmpty
        ? const <CostCenterRow>[]
        : await (select(
            costCenters,
          )..where((row) => row.id.isIn(costCenterIds))).get();
    final beneficiaryRows = await (select(
      transactionBeneficiaries,
    )..where((row) => row.transactionId.isIn(transactionIds))).get();
    final sourceRows = await (select(
      transactionSources,
    )..where((row) => row.transactionId.isIn(transactionIds))).get();
    final inboxRows =
        await (select(reviewInbox)
              ..where((row) => row.transactionId.isIn(transactionIds))
              ..where((row) => row.resolvedAt.isNull()))
            .get();

    final personIds = beneficiaryRows.map((row) => row.personId).toSet();
    final personRows = personIds.isEmpty
        ? const <PersonRow>[]
        : await (select(people)..where((row) => row.id.isIn(personIds))).get();

    final accountsById = {for (final row in accountRows) row.id: row};
    final merchantsById = {for (final row in merchantRows) row.id: row};
    final categoriesById = {for (final row in categoryRows) row.id: row};
    final costCentersById = {for (final row in costCenterRows) row.id: row};
    final peopleById = {for (final row in personRows) row.id: row};
    final beneficiariesByTransaction = <String, List<PersonRow>>{};
    final sourcesByTransaction = <String, List<TransactionSourceRow>>{};
    final inboxByTransaction = <String, List<ReviewInboxRow>>{};

    for (final row in beneficiaryRows) {
      final person = peopleById[row.personId];
      if (person == null) {
        continue;
      }
      beneficiariesByTransaction
          .putIfAbsent(row.transactionId, () => [])
          .add(person);
    }

    for (final row in sourceRows) {
      sourcesByTransaction.putIfAbsent(row.transactionId, () => []).add(row);
    }

    for (final row in inboxRows) {
      inboxByTransaction.putIfAbsent(row.transactionId, () => []).add(row);
    }

    return [
      for (final tx in transactions)
        ReviewTransactionDetails(
          transaction: tx,
          account: tx.accountId == null ? null : accountsById[tx.accountId],
          merchant: tx.merchantId == null ? null : merchantsById[tx.merchantId],
          category: tx.categoryId == null
              ? null
              : categoriesById[tx.categoryId],
          costCenter: tx.costCenterId == null
              ? null
              : costCentersById[tx.costCenterId],
          beneficiaries: beneficiariesByTransaction[tx.id] ?? const [],
          sources: sourcesByTransaction[tx.id] ?? const [],
          inboxItems: inboxByTransaction[tx.id] ?? const [],
        ),
    ];
  }
}

class ReviewTransactionDetails {
  const ReviewTransactionDetails({
    required this.transaction,
    required this.account,
    required this.merchant,
    required this.category,
    required this.costCenter,
    required this.beneficiaries,
    required this.sources,
    required this.inboxItems,
  });

  final FinanceTransaction transaction;
  final AccountRow? account;
  final MerchantRow? merchant;
  final CategoryRow? category;
  final CostCenterRow? costCenter;
  final List<PersonRow> beneficiaries;
  final List<TransactionSourceRow> sources;
  final List<ReviewInboxRow> inboxItems;

  String get displayMerchant =>
      merchant?.displayName ?? transaction.descriptionRaw;

  String get accountLabel => account?.name ?? 'Conta nao definida';

  String get categoryLabel => category?.name ?? 'Sem categoria';

  String get costCenterLabel => costCenter?.name ?? 'Sem centro';

  String get sourceLabel {
    if (sources.isEmpty) {
      return 'Local';
    }
    final source = sources.first;
    return switch (source.sourceKind) {
      'notification' => 'Notificacao',
      'csv' => 'CSV',
      'ofx' => 'OFX',
      'manual' => 'Manual',
      _ => source.sourceKind,
    };
  }

  String get providerLabel {
    if (sources.isEmpty) {
      return 'ZimbaControl';
    }
    return switch (sources.first.provider) {
      'mercado_pago' => 'Mercado Pago',
      'nubank' => 'Nubank',
      'zimba_control' => 'ZimbaControl',
      final value => value,
    };
  }

  bool get hasLowConfidence => transaction.sourceConfidence < 0.8;

  bool get isProbableDuplicate => transaction.duplicateStatus != 'none';

  bool get suggestsTransfer {
    final text = transaction.descriptionRaw.toLowerCase();
    return transaction.kind == 'transfer' ||
        text.contains('transfer') ||
        text.contains('pix enviado') ||
        text.contains('pagamento de fatura');
  }

  bool get hasInstallmentHint {
    final text = transaction.descriptionRaw.toLowerCase();
    return text.contains('parcela') || text.contains('/12');
  }

  String get reviewReason {
    if (inboxItems.isEmpty) {
      return 'Revisar sugestao';
    }
    return switch (inboxItems.first.reason) {
      'needs_user_confirmation' => 'Confirmar sugestao',
      'suggestion_low_confidence' => 'Baixa confianca',
      'manual_draft_needs_review' => 'Rascunho manual',
      final value => value.replaceAll('_', ' '),
    };
  }
}

class ReviewActionSnapshot {
  const ReviewActionSnapshot({
    required this.transaction,
    required this.openReviewItems,
  });

  final FinanceTransaction transaction;
  final List<ReviewInboxRow> openReviewItems;
}

class AccountWithOwner {
  const AccountWithOwner({required this.account, required this.owner});

  final AccountRow account;
  final PersonRow? owner;

  String get ownerLabel => owner?.displayName ?? 'Sem proprietario';
}

class CreditCardWithOwner {
  const CreditCardWithOwner({required this.creditCard, required this.owner});

  final CreditCardRow creditCard;
  final PersonRow? owner;

  String get ownerLabel => owner?.displayName ?? 'Sem proprietario';
}

class FamilyStructureSnapshot {
  const FamilyStructureSnapshot({
    required this.people,
    required this.accounts,
    required this.creditCards,
    required this.authUsers,
    required this.recurringSchedules,
    required this.installmentPlans,
  });

  final List<PersonRow> people;
  final List<AccountWithOwner> accounts;
  final List<CreditCardWithOwner> creditCards;
  final List<AuthUserRow> authUsers;
  final List<RecurringScheduleRow> recurringSchedules;
  final List<InstallmentPlanRow> installmentPlans;
}

class ImportBatchDetails {
  const ImportBatchDetails({required this.batch, required this.records});

  final ImportBatchRow batch;
  final List<StagedSourceRecordRow> records;
}
