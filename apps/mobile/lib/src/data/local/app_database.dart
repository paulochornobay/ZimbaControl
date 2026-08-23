import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../../application/import_parser.dart';
import '../../infrastructure/api_sync_client.dart';
import '../../infrastructure/notification_capture_service.dart';
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
  TextColumn get accountId => text().nullable()();
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
  BoolColumn get active => boolean().withDefault(const Constant(true))();

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
  TextColumn get displayDescription => text().nullable()();
  TextColumn get accountId => text().nullable()();
  TextColumn get transferFromAccountId => text().nullable()();
  TextColumn get transferToAccountId => text().nullable()();
  TextColumn get recurringScheduleId => text().nullable()();
  TextColumn get installmentPlanId => text().nullable()();
  TextColumn get merchantId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get costCenterId => text().nullable()();
  TextColumn get payerId => text().nullable()();
  TextColumn get appliedRuleId => text().nullable()();
  RealColumn get sourceConfidence => real().withDefault(const Constant(0))();
  IntColumn get baseVersion => integer().withDefault(const Constant(0))();
  IntColumn get serverVersion => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ClassificationRuleRow')
class ClassificationRules extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get name => text()();
  TextColumn get matchText => text()();
  TextColumn get kind => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get costCenterId => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

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

@DataClassName('SyncAppliedEventRow')
class SyncAppliedEvents extends Table {
  TextColumn get opId => text()();
  TextColumn get householdId => text()();
  IntColumn get seq => integer()();
  DateTimeColumn get appliedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {opId};
}

@DataClassName('SyncConflictRow')
class SyncConflicts extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get transactionId => text()();
  TextColumn get remoteOpId => text()();
  IntColumn get remoteSeq => integer()();
  TextColumn get localPayloadJson => text()();
  TextColumn get remotePayloadJson => text()();
  TextColumn get status =>
      text().withDefault(const Constant('pending_review'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
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

@DataClassName('DuplicateCandidateRow')
class DuplicateCandidates extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get transactionId => text()();
  TextColumn get candidateTransactionId => text().nullable()();
  TextColumn get stagedSourceRecordId => text().nullable()();
  RealColumn get score => real()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get reason => text()();
  TextColumn get explanation => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RawNotificationEventRow')
class RawNotificationEvents extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get platformEventId => text()();
  TextColumn get packageName => text()();
  TextColumn get appLabel => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get bodyText => text().nullable()();
  TextColumn get bigText => text().nullable()();
  IntColumn get notificationId => integer().nullable()();
  TextColumn get tag => text().nullable()();
  DateTimeColumn get postedAt => dateTime()();
  DateTimeColumn get capturedAt => dateTime()();
  TextColumn get status => text().withDefault(const Constant('captured'))();
  TextColumn get rawPayloadJson => text().nullable()();
  TextColumn get draftTransactionId => text().nullable()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get processedAt => dateTime().nullable()();

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
    ClassificationRules,
    SyncOutbox,
    SyncAppliedEvents,
    SyncConflicts,
    AppPreferences,
    AuthUsers,
    RecurringSchedules,
    InstallmentPlans,
    ImportBatches,
    StagedSourceRecords,
    DuplicateCandidates,
    RawNotificationEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  AppDatabase.forTesting(super.executor);

  static const householdMain = 'household-main';
  static const reviewFilterPreferenceKey = 'review_filter';
  static const onboardingCompletedPreferenceKey = 'onboarding_completed';
  static const primaryPersonPreferenceKey = 'primary_person_id';
  static const primaryAccountPreferenceKey = 'primary_account_id';
  static const syncDeviceIdPreferenceKey = 'sync_device_id';
  static const notificationCaptureLastDrainPreferenceKey =
      'notification_capture_last_drain_at';
  static const notificationCaptureLastErrorPreferenceKey =
      'notification_capture_last_error';
  static const notificationCaptureRetentionDaysPreferenceKey =
      'notification_capture_retention_days';

  @override
  int get schemaVersion => 11;

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
      if (from < 6) {
        await migrator.createTable(duplicateCandidates);
      }
      if (from < 7) {
        await migrator.createTable(rawNotificationEvents);
      }
      if (from < 8) {
        await migrator.addColumn(categories, categories.active);
        await migrator.addColumn(creditCards, creditCards.accountId);
      }
      if (from < 9) {
        await migrator.addColumn(transactions, transactions.appliedRuleId);
        await migrator.createTable(classificationRules);
      }
      if (from < 10) {
        await migrator.createTable(syncAppliedEvents);
        await migrator.createTable(syncConflicts);
      }
      if (from < 11) {
        await migrator.addColumn(transactions, transactions.displayDescription);
        await customStatement(
          'UPDATE transactions '
          'SET display_description = description_raw '
          'WHERE display_description IS NULL',
        );
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

  Future<List<ClassificationRuleRow>> listClassificationRules({
    bool includeInactive = true,
  }) {
    final query = select(classificationRules)
      ..orderBy([
        (row) => OrderingTerm.desc(row.priority),
        (row) => OrderingTerm.asc(row.name),
      ]);
    if (!includeInactive) {
      query.where((row) => row.active.equals(true));
    }
    return query.get();
  }

  Future<String> upsertClassificationRule({
    String? id,
    required String name,
    required String matchText,
    String? kind,
    String? categoryId,
    String? costCenterId,
    required int priority,
    bool active = true,
  }) async {
    final cleanName = name.trim();
    final cleanMatch = matchText.trim();
    if (cleanName.isEmpty || cleanMatch.isEmpty) {
      throw ArgumentError('Nome e texto de correspondencia sao obrigatorios.');
    }
    if (categoryId == null && costCenterId == null) {
      throw ArgumentError('Escolha uma categoria ou centro de custo.');
    }
    final now = DateTime.now();
    final ruleId = id ?? 'rule-${now.microsecondsSinceEpoch}';
    await into(classificationRules).insertOnConflictUpdate(
      ClassificationRulesCompanion(
        id: Value(ruleId),
        householdId: const Value(householdMain),
        name: Value(cleanName),
        matchText: Value(cleanMatch),
        kind: Value(kind),
        categoryId: Value(categoryId),
        costCenterId: Value(costCenterId),
        priority: Value(priority),
        active: Value(active),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    return ruleId;
  }

  Future<void> archiveClassificationRule(String id, {bool active = false}) {
    return (update(
      classificationRules,
    )..where((row) => row.id.equals(id))).write(
      ClassificationRulesCompanion(
        active: Value(active),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<FinanceTransaction>> watchAllTransactions() {
    final query = select(transactions)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.occurredAt)]);
    return query.watch();
  }

  Stream<List<ReviewTransactionDetails>> watchAllTransactionDetails() {
    return watchAllTransactions().asyncMap(_hydrateReviewTransactions);
  }

  Stream<List<FinanceTransaction>> watchPendingReview() {
    final query = select(transactions)
      ..where((row) => row.reviewStatus.isIn(['pending', 'conflict']))
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

  Future<List<PersonRow>> listPeople({bool includeInactive = false}) {
    final query = select(people)
      ..orderBy([(row) => OrderingTerm.asc(row.displayName)]);
    if (!includeInactive) {
      query.where((row) => row.active.equals(true));
    }
    return query.get();
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

  Future<List<CategoryRow>> listCategories({bool includeInactive = false}) {
    final query = select(categories)
      ..where((row) => row.householdId.equals(householdMain))
      ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]);
    if (!includeInactive) {
      query.where((row) => row.active.equals(true));
    }
    return query.get();
  }

  Future<List<CostCenterRow>> listCostCenters({bool includeInactive = false}) {
    final query = select(costCenters)
      ..where((row) => row.householdId.equals(householdMain))
      ..orderBy([(row) => OrderingTerm.asc(row.name)]);
    if (!includeInactive) {
      query.where((row) => row.active.equals(true));
    }
    return query.get();
  }

  Future<List<AccountWithOwner>> listAccountsWithOwners({
    bool includeInactive = false,
  }) async {
    final accountRows =
        await (select(accounts)
              ..where((row) => row.householdId.equals(householdMain))
              ..orderBy([(row) => OrderingTerm.asc(row.name)]))
            .get();
    final visibleAccounts = includeInactive
        ? accountRows
        : accountRows.where((row) => row.active).toList(growable: false);
    final owners = await _peopleByIds(
      visibleAccounts
          .map((row) => row.ownerPersonId)
          .whereType<String>()
          .toSet(),
    );

    return [
      for (final account in visibleAccounts)
        AccountWithOwner(
          account: account,
          owner: account.ownerPersonId == null
              ? null
              : owners[account.ownerPersonId],
        ),
    ];
  }

  Future<List<CreditCardWithOwner>> listCreditCardsWithOwners({
    bool includeInactive = false,
  }) async {
    final cardRows =
        await (select(creditCards)
              ..where((row) => row.householdId.equals(householdMain))
              ..orderBy([(row) => OrderingTerm.asc(row.name)]))
            .get();
    final visibleCards = includeInactive
        ? cardRows
        : cardRows.where((row) => row.active).toList(growable: false);
    final owners = await _peopleByIds(
      visibleCards.map((row) => row.ownerPersonId).whereType<String>().toSet(),
    );

    return [
      for (final card in visibleCards)
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

  Future<List<DuplicateCandidateRow>> listDuplicateCandidates() {
    final query = select(duplicateCandidates)
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    return query.get();
  }

  Future<List<DuplicateCandidateRow>> listOpenDuplicateCandidates() {
    final query = select(duplicateCandidates)
      ..where((row) => row.resolvedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    return query.get();
  }

  Future<List<DuplicateCandidateDetails>>
  listOpenDuplicateCandidateDetails() async {
    final rows = await listOpenDuplicateCandidates();
    final details = <DuplicateCandidateDetails>[];
    for (final row in rows) {
      final primary = await getTransaction(row.transactionId);
      final candidate = row.candidateTransactionId == null
          ? null
          : await getTransaction(row.candidateTransactionId!);
      final staged = row.stagedSourceRecordId == null
          ? null
          : await (select(stagedSourceRecords)
                  ..where((item) => item.id.equals(row.stagedSourceRecordId!)))
                .getSingleOrNull();
      details.add(
        DuplicateCandidateDetails(
          candidate: row,
          primaryTransaction: primary,
          candidateTransaction: candidate,
          stagedRecord: staged,
        ),
      );
    }
    return details;
  }

  Future<List<TransactionSourceRow>> listTransactionSources(
    String transactionId,
  ) {
    final query = select(transactionSources)
      ..where((row) => row.transactionId.equals(transactionId));
    return query.get();
  }

  Future<List<RawNotificationEventRow>> listRawNotificationEvents({
    int limit = 25,
  }) {
    final query = select(rawNotificationEvents)
      ..orderBy([(row) => OrderingTerm.desc(row.capturedAt)])
      ..limit(limit);
    return query.get();
  }

  Stream<List<RawNotificationEventRow>> watchRawNotificationEvents({
    int limit = 25,
  }) {
    final query = select(rawNotificationEvents)
      ..orderBy([(row) => OrderingTerm.desc(row.capturedAt)])
      ..limit(limit);
    return query.watch();
  }

  Future<NotificationCaptureDiagnostics>
  getNotificationCaptureDiagnostics() async {
    final events = await select(rawNotificationEvents).get();
    final counts = <String, int>{};
    for (final event in events) {
      counts.update(event.status, (count) => count + 1, ifAbsent: () => 1);
    }
    final retentionDays =
        int.tryParse(
          await _preferenceValue(
                notificationCaptureRetentionDaysPreferenceKey,
              ) ??
              '',
        ) ??
        30;
    final lastDrain = DateTime.tryParse(
      await _preferenceValue(notificationCaptureLastDrainPreferenceKey) ?? '',
    );
    return NotificationCaptureDiagnostics(
      counts: counts,
      retentionDays: retentionDays.clamp(1, 365).toInt(),
      lastDrain: lastDrain,
      lastError: await _preferenceValue(
        notificationCaptureLastErrorPreferenceKey,
      ),
    );
  }

  Future<void> setNotificationCaptureRetentionDays(int days) {
    return _setPreference(
      notificationCaptureRetentionDaysPreferenceKey,
      days.clamp(1, 365).toString(),
    );
  }

  Future<List<SyncOutboxRow>> listPendingSyncOutbox({int limit = 50}) {
    final query = select(syncOutbox)
      ..where((row) => row.status.isIn(['pending', 'failed']))
      ..orderBy([(row) => OrderingTerm.asc(row.createdAt)])
      ..limit(limit);
    return query.get();
  }

  Future<List<SyncConflictRow>> listSyncConflicts(String transactionId) {
    final query = select(syncConflicts)
      ..where((row) => row.transactionId.equals(transactionId))
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    return query.get();
  }

  Future<SyncRunSummary> runSyncOnce(SyncApiClient client) async {
    final operations = await listPendingSyncOutbox();
    final sinceSeq =
        int.tryParse(await _preferenceValue('sync_pull_since_seq') ?? '0') ?? 0;
    final localDeviceId = await _deviceId();
    var pushed = 0;
    var duplicates = 0;
    var conflicts = 0;
    var rejected = 0;

    if (operations.isNotEmpty) {
      final response = await client.push(
        SyncPushPayload(
          deviceId: operations.first.deviceId,
          householdId: householdMain,
          operations: [
            for (final operation in operations) _syncOperationJson(operation),
          ],
        ),
      );
      final ackByOpId = {for (final ack in response.results) ack.opId: ack};

      for (final operation in operations) {
        final ack = ackByOpId[operation.opId];
        if (ack == null) {
          await _markOutboxFailure(operation);
          continue;
        }
        switch (ack.result) {
          case 'applied':
            pushed += 1;
            await _markOutboxAck(operation);
          case 'duplicate':
            duplicates += 1;
            await _markOutboxAck(operation);
          case 'conflict':
            conflicts += 1;
            await _markOutboxConflict(operation);
          default:
            rejected += 1;
            await _markOutboxRejected(operation.opId);
        }
      }
    }

    final pulled = await client.pull(
      householdId: householdMain,
      sinceSeq: sinceSeq,
    );
    final pullSummary = await _applyPulledSyncEvents(
      pulled.events,
      sinceSeq: sinceSeq,
      localDeviceId: localDeviceId,
    );

    return SyncRunSummary(
      pushed: pushed,
      duplicates: duplicates,
      conflicts: conflicts,
      rejected: rejected,
      pulled: pulled.events.length,
      applied: pullSummary.applied,
      remoteConflicts: pullSummary.conflicts,
      latestSeq: pullSummary.latestSeq,
    );
  }

  Future<_PullApplySummary> _applyPulledSyncEvents(
    List<Map<String, dynamic>> events, {
    required int sinceSeq,
    required String localDeviceId,
  }) async {
    var latestSeq = sinceSeq;
    var applied = 0;
    var conflicts = 0;
    final ordered = [...events]
      ..sort(
        (left, right) => _syncEventSeq(left).compareTo(_syncEventSeq(right)),
      );

    for (final event in ordered) {
      final seq = _syncEventSeq(event);
      if (seq <= latestSeq) {
        continue;
      }
      final result = await transaction(() async {
        final opId = _requiredSyncString(event, 'opId');
        final alreadyApplied = await (select(
          syncAppliedEvents,
        )..where((row) => row.opId.equals(opId))).getSingleOrNull();
        if (alreadyApplied != null) {
          return const _RemoteApplyResult();
        }

        _RemoteApplyResult result;
        if (_requiredSyncString(event, 'deviceId') == localDeviceId) {
          await _acknowledgeOwnPulledEvent(event);
          result = const _RemoteApplyResult();
        } else if (_requiredSyncString(event, 'entityType') == 'transaction') {
          result = await _applyRemoteTransactionEvent(event);
        } else {
          throw FormatException(
            'Entidade de sync nao suportada: ${event['entityType']}',
          );
        }
        await into(syncAppliedEvents).insert(
          SyncAppliedEventsCompanion.insert(
            opId: opId,
            householdId: householdMain,
            seq: seq,
            appliedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
        return result;
      });
      latestSeq = seq;
      applied += 1;
      conflicts += result.conflict ? 1 : 0;
    }

    await _setPreference('sync_pull_since_seq', latestSeq.toString());
    return _PullApplySummary(
      applied: applied,
      conflicts: conflicts,
      latestSeq: latestSeq,
    );
  }

  Future<void> _acknowledgeOwnPulledEvent(Map<String, dynamic> event) async {
    if (_requiredSyncString(event, 'entityType') != 'transaction') {
      return;
    }
    final transactionId = _requiredSyncString(event, 'entityId');
    final local = await getTransaction(transactionId);
    if (local == null) {
      return;
    }
    final remoteVersion = _syncEventBaseVersion(event) + 1;
    if (remoteVersion <= local.serverVersion) {
      return;
    }
    await (update(
      transactions,
    )..where((row) => row.id.equals(transactionId))).write(
      TransactionsCompanion(
        baseVersion: Value(remoteVersion),
        serverVersion: Value(remoteVersion),
      ),
    );
  }

  Future<_RemoteApplyResult> _applyRemoteTransactionEvent(
    Map<String, dynamic> event,
  ) async {
    final remote = _SyncTransactionPayload.fromEvent(event);
    final local = await getTransaction(remote.transaction.id);
    final remoteVersion = _syncEventBaseVersion(event) + 1;
    if (local == null) {
      await _replaceRemoteTransaction(remote, remoteVersion);
      return const _RemoteApplyResult();
    }

    final hasLocalChanges = await _hasUnsyncedLocalChanges(local.id);
    if (local.serverVersion >= remoteVersion && !hasLocalChanges) {
      return const _RemoteApplyResult();
    }
    if (!hasLocalChanges && local.serverVersion == remoteVersion - 1) {
      await _replaceRemoteTransaction(remote, remoteVersion);
      return const _RemoteApplyResult();
    }

    final now = DateTime.now();
    final opId = _requiredSyncString(event, 'opId');
    await into(syncConflicts).insert(
      SyncConflictsCompanion.insert(
        id: 'sync-conflict-$opId',
        householdId: householdMain,
        transactionId: local.id,
        remoteOpId: opId,
        remoteSeq: _syncEventSeq(event),
        localPayloadJson: jsonEncode(await _syncTransactionPayload(local.id)),
        remotePayloadJson: jsonEncode(_syncMap(event['payload'], 'payload')),
        createdAt: now,
      ),
      mode: InsertMode.insertOrIgnore,
    );
    await (update(transactions)..where((row) => row.id.equals(local.id))).write(
      TransactionsCompanion(
        reviewStatus: const Value('conflict'),
        baseVersion: Value(remoteVersion),
        serverVersion: Value(remoteVersion),
        updatedAt: Value(now),
      ),
    );
    await into(reviewInbox).insert(
      _reviewItem(
        local.id,
        'sync_remote_conflict',
        now,
        severity: 'high',
        id: 'review-sync-remote-$opId',
      ),
      mode: InsertMode.insertOrIgnore,
    );
    return const _RemoteApplyResult(conflict: true);
  }

  Future<void> _replaceRemoteTransaction(
    _SyncTransactionPayload remote,
    int remoteVersion,
  ) async {
    final value = remote.transaction;
    if (remote.operationType == 'delete') {
      await (update(
        transactions,
      )..where((row) => row.id.equals(value.id))).write(
        TransactionsCompanion(
          deletedAt: Value(remote.serverAt),
          baseVersion: Value(remoteVersion),
          serverVersion: Value(remoteVersion),
          updatedAt: Value(remote.serverAt),
        ),
      );
      return;
    }
    await into(transactions).insertOnConflictUpdate(
      TransactionsCompanion.insert(
        id: value.id,
        householdId: value.householdId,
        kind: value.kind,
        reviewStatus: value.reviewStatus,
        duplicateStatus: value.duplicateStatus,
        occurredAt: value.occurredAt,
        postedAt: Value(value.postedAt),
        competenceMonth: value.competenceMonth,
        amountCents: value.amountCents,
        currencyCode: Value(value.currencyCode),
        descriptionRaw: value.descriptionRaw,
        displayDescription: Value(value.displayDescription),
        accountId: Value(value.accountId),
        transferFromAccountId: Value(value.transferFromAccountId),
        transferToAccountId: Value(value.transferToAccountId),
        recurringScheduleId: Value(value.recurringScheduleId),
        installmentPlanId: Value(value.installmentPlanId),
        merchantId: Value(value.merchantId),
        categoryId: Value(value.categoryId),
        costCenterId: Value(value.costCenterId),
        payerId: Value(value.payerId),
        appliedRuleId: Value(value.appliedRuleId),
        sourceConfidence: Value(value.sourceConfidence),
        baseVersion: Value(remoteVersion),
        serverVersion: Value(remoteVersion),
        updatedAt: value.updatedAt,
        deletedAt: Value(value.deletedAt),
      ),
    );
    await (delete(
      transactionBeneficiaries,
    )..where((row) => row.transactionId.equals(value.id))).go();
    await (delete(
      transactionSources,
    )..where((row) => row.transactionId.equals(value.id))).go();
    if (remote.beneficiaries.isNotEmpty) {
      await batch((batch) {
        batch.insertAll(transactionBeneficiaries, remote.beneficiaries);
      });
    }
    if (remote.sources.isNotEmpty) {
      await batch((batch) {
        batch.insertAll(transactionSources, remote.sources);
      });
    }
    if (value.reviewStatus == 'pending') {
      await into(reviewInbox).insert(
        _reviewItem(
          value.id,
          'sync_remote_pending',
          value.updatedAt,
          id: 'review-sync-remote-${value.id}',
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  Future<bool> _hasUnsyncedLocalChanges(String transactionId) async {
    final row =
        await (select(syncOutbox)
              ..where((item) => item.entityType.equals('transaction'))
              ..where((item) => item.entityId.equals(transactionId))
              ..where(
                (item) => item.status.isIn(['pending', 'failed', 'conflict']),
              )
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  Future<ZimbaBackupFile> exportBackupFile() async {
    final exportedAt = DateTime.now();
    final data = <String, List<Map<String, dynamic>>>{
      'people': _toJsonRows(await select(people).get()),
      'accounts': _toJsonRows(await select(accounts).get()),
      'creditCards': _toJsonRows(await select(creditCards).get()),
      'categories': _toJsonRows(await select(categories).get()),
      'costCenters': _toJsonRows(await select(costCenters).get()),
      'merchants': _toJsonRows(await select(merchants).get()),
      'transactions': _toJsonRows(await select(transactions).get()),
      'reviewInbox': _toJsonRows(await select(reviewInbox).get()),
      'transactionBeneficiaries': _toJsonRows(
        await select(transactionBeneficiaries).get(),
      ),
      'transactionSources': _toJsonRows(await select(transactionSources).get()),
      'classificationRules': _toJsonRows(
        await select(classificationRules).get(),
      ),
      'syncOutbox': _toJsonRows(await select(syncOutbox).get()),
      'syncAppliedEvents': _toJsonRows(await select(syncAppliedEvents).get()),
      'syncConflicts': _toJsonRows(await select(syncConflicts).get()),
      'appPreferences': _toJsonRows(await select(appPreferences).get()),
      'authUsers': _toJsonRows(await select(authUsers).get()),
      'recurringSchedules': _toJsonRows(await select(recurringSchedules).get()),
      'installmentPlans': _toJsonRows(await select(installmentPlans).get()),
      'importBatches': _toJsonRows(await select(importBatches).get()),
      'stagedSourceRecords': _toJsonRows(
        await select(stagedSourceRecords).get(),
      ),
      'duplicateCandidates': _toJsonRows(
        await select(duplicateCandidates).get(),
      ),
      'rawNotificationEvents': _toJsonRows(
        await select(rawNotificationEvents).get(),
      ),
    };
    final counts = {
      for (final entry in data.entries) entry.key: entry.value.length,
    };
    final payload = {
      'format': ZimbaBackupFile.format,
      'version': ZimbaBackupFile.currentVersion,
      'schemaVersion': schemaVersion,
      'householdId': householdMain,
      'exportedAt': exportedAt.toIso8601String(),
      'counts': counts,
      'data': data,
    };
    final bytes = utf8.encode(
      const JsonEncoder.withIndent('  ').convert(payload),
    );
    return ZimbaBackupFile(
      fileName:
          'zimbacontrol-backup-${exportedAt.toIso8601String().substring(0, 10)}.json',
      exportedAt: exportedAt,
      counts: counts,
      bytes: bytes,
    );
  }

  Future<BackupValidationResult> validateBackupBytes(List<int> bytes) async {
    try {
      final decoded = _decodeBackup(bytes);
      return BackupValidationResult(
        valid: true,
        message: 'Backup valido',
        exportedAt: decoded.exportedAt,
        schemaVersion: decoded.schemaVersion,
        counts: decoded.counts,
      );
    } catch (error) {
      return BackupValidationResult(
        valid: false,
        message: 'Arquivo de backup invalido ou incompativel.',
        counts: const {},
      );
    }
  }

  Future<BackupValidationResult> restoreBackupBytes(List<int> bytes) async {
    final backup = _decodeBackup(bytes);
    await transaction(() async {
      await delete(syncConflicts).go();
      await delete(syncAppliedEvents).go();
      await delete(rawNotificationEvents).go();
      await delete(duplicateCandidates).go();
      await delete(stagedSourceRecords).go();
      await delete(importBatches).go();
      await delete(installmentPlans).go();
      await delete(recurringSchedules).go();
      await delete(authUsers).go();
      await delete(appPreferences).go();
      await delete(syncOutbox).go();
      await delete(transactionSources).go();
      await delete(transactionBeneficiaries).go();
      await delete(classificationRules).go();
      await delete(reviewInbox).go();
      await delete(transactions).go();
      await delete(merchants).go();
      await delete(costCenters).go();
      await delete(categories).go();
      await delete(creditCards).go();
      await delete(accounts).go();
      await delete(people).go();

      await _insertBackupRows(people, backup.people);
      await _insertBackupRows(accounts, backup.accounts);
      await _insertBackupRows(creditCards, backup.creditCards);
      await _insertBackupRows(categories, backup.categories);
      await _insertBackupRows(costCenters, backup.costCenters);
      await _insertBackupRows(merchants, backup.merchants);
      await _insertBackupRows(transactions, backup.transactions);
      await _insertBackupRows(reviewInbox, backup.reviewInbox);
      await _insertBackupRows(
        transactionBeneficiaries,
        backup.transactionBeneficiaries,
      );
      await _insertBackupRows(transactionSources, backup.transactionSources);
      await _insertBackupRows(classificationRules, backup.classificationRules);
      await _insertBackupRows(syncOutbox, backup.syncOutbox);
      await _insertBackupRows(syncAppliedEvents, backup.syncAppliedEvents);
      await _insertBackupRows(syncConflicts, backup.syncConflicts);
      await _insertBackupRows(appPreferences, backup.appPreferences);
      await _insertBackupRows(authUsers, backup.authUsers);
      await _insertBackupRows(recurringSchedules, backup.recurringSchedules);
      await _insertBackupRows(installmentPlans, backup.installmentPlans);
      await _insertBackupRows(importBatches, backup.importBatches);
      await _insertBackupRows(stagedSourceRecords, backup.stagedSourceRecords);
      await _insertBackupRows(duplicateCandidates, backup.duplicateCandidates);
      await _insertBackupRows(
        rawNotificationEvents,
        backup.rawNotificationEvents,
      );
    });

    return BackupValidationResult(
      valid: true,
      message: 'Backup restaurado',
      exportedAt: backup.exportedAt,
      schemaVersion: backup.schemaVersion,
      counts: backup.counts,
    );
  }

  Future<List<int>> exportTransactionsCsvBytes() async {
    final rows = await watchAllTransactions().first;
    final details = await _hydrateReviewTransactions(rows);
    final buffer = StringBuffer()
      ..writeln(
        'data;competencia;tipo;descricao;valor_centavos;status;conta;categoria;centro_custo;beneficiarios;origens',
      );
    for (final item in details) {
      final tx = item.transaction;
      buffer.writeln(
        [
          tx.occurredAt.toIso8601String().substring(0, 10),
          tx.competenceMonth,
          tx.kind,
          tx.descriptionRaw,
          tx.amountCents.toString(),
          tx.reviewStatus,
          item.account?.name ?? '',
          item.category?.name ?? '',
          item.costCenter?.name ?? '',
          item.beneficiaries.map((person) => person.displayName).join(', '),
          item.sources.map((source) => source.sourceKind).join(', '),
        ].map(_csvCell).join(';'),
      );
    }
    return utf8.encode(buffer.toString());
  }

  Future<NotificationCaptureSyncResult> syncNotificationCaptureEvents([
    NotificationCaptureService service = const NotificationCaptureService(),
  ]) async {
    var fetched = 0;
    var recorded = 0;
    String? bridgeError;

    try {
      while (true) {
        final drain = await service.drainPendingEvents();
        if (!drain.available || drain.events.isEmpty) {
          break;
        }
        fetched += drain.events.length;
        final ids = drain.events
            .map((event) => event.id)
            .toList(growable: false);
        try {
          for (final event in drain.events) {
            if (await recordRawNotificationEvent(event)) {
              recorded += 1;
            }
          }
          await service.acknowledgeDeliveredEvents(ids);
        } catch (error) {
          bridgeError = 'Falha ao gravar a captura no banco local: $error';
          await service.releaseEventsForRetry(ids, error: bridgeError);
          break;
        }
        if (!drain.hasMore) {
          break;
        }
      }
    } catch (error) {
      bridgeError = 'Falha de comunicacao com a captura Android: $error';
    }

    var drafts = 0;
    while (true) {
      final pending = await _countRawNotificationsWithStatus('captured');
      if (pending == 0) {
        break;
      }
      drafts += await processPendingRawNotificationEvents(limit: 100);
      if (pending <= 100) {
        break;
      }
    }
    await _setPreference(
      notificationCaptureLastDrainPreferenceKey,
      DateTime.now().toIso8601String(),
    );
    await _setPreference(
      notificationCaptureLastErrorPreferenceKey,
      bridgeError ?? '',
    );
    return NotificationCaptureSyncResult(
      fetched: fetched,
      recorded: recorded,
      drafts: drafts,
      bridgeError: bridgeError,
    );
  }

  Future<bool> recordRawNotificationEvent(
    CapturedNotificationEvent event,
  ) async {
    if (event.id.trim().isEmpty) {
      return false;
    }

    final rawId = 'raw-notif-${sha256.convert(utf8.encode(event.id))}';
    final existing = await (select(
      rawNotificationEvents,
    )..where((row) => row.platformEventId.equals(event.id))).getSingleOrNull();
    if (existing != null) {
      return false;
    }
    final inserted = await into(rawNotificationEvents).insert(
      RawNotificationEventsCompanion.insert(
        id: rawId,
        householdId: householdMain,
        platformEventId: event.id,
        packageName: event.packageName,
        appLabel: Value(event.appLabel),
        title: Value(event.title),
        bodyText: Value(event.text),
        bigText: Value(event.bigText),
        notificationId: Value(event.notificationId),
        tag: Value(event.tag),
        postedAt: event.postedAt,
        capturedAt: event.capturedAt,
        rawPayloadJson: Value(event.rawPayloadJson),
      ),
      mode: InsertMode.insertOrIgnore,
    );
    return inserted > 0;
  }

  Future<int> processPendingRawNotificationEvents({int limit = 100}) async {
    final rows =
        await (select(rawNotificationEvents)
              ..where((row) => row.status.equals('captured'))
              ..orderBy([(row) => OrderingTerm.asc(row.capturedAt)])
              ..limit(limit.clamp(1, 100).toInt()))
            .get();
    var drafts = 0;

    for (final row in rows) {
      final parsed = _parseRawNotificationEvent(row);
      if (parsed == null) {
        await _markRawNotification(
          row.id,
          status: 'ignored_no_amount',
          errorMessage: 'Nao foi possivel identificar valor financeiro.',
        );
        continue;
      }

      final existing = await _findDuplicateNotification(row.platformEventId);
      if (existing != null) {
        await _markRawNotification(
          row.id,
          status: 'duplicate',
          draftTransactionId: existing,
        );
        continue;
      }

      final match = await _findLikelyTransactionMatch(parsed);
      if (match != null && match.score >= 0.82) {
        await _mergeNotificationSourceWithTransaction(
          row: row,
          provider: parsed.provider,
          confidence: parsed.confidence,
          transactionId: match.transactionId,
          explanation: match.explanation,
        );
        continue;
      }

      final txId = 'tx-${row.id}';
      final existingTx = await getTransaction(txId);
      if (existingTx != null) {
        await _markRawNotification(
          row.id,
          status: 'duplicate',
          draftTransactionId: txId,
        );
        continue;
      }

      final primaryPersonId = await _preferenceValue(
        primaryPersonPreferenceKey,
      );
      final accountId = await _accountForProvider(parsed.provider);
      await into(transactions).insert(
        _transaction(
          id: txId,
          kind: parsed.amountCents! >= 0 ? 'income' : 'expense',
          reviewStatus: 'pending',
          duplicateStatus: match == null ? 'none' : 'probable',
          amountCents: parsed.amountCents!,
          description: parsed.description!,
          accountId: accountId,
          occurredAt: parsed.occurredAt!,
          confidence: parsed.confidence,
          payerPersonId: primaryPersonId,
        ),
      );
      if (primaryPersonId != null) {
        await into(
          transactionBeneficiaries,
        ).insert(_beneficiary(txId, primaryPersonId, true));
      }
      await into(reviewInbox).insert(
        _reviewItem(
          txId,
          match == null
              ? 'notification_capture_needs_review'
              : 'possible_duplicate_needs_review',
          DateTime.now(),
        ),
      );
      await into(transactionSources).insert(
        TransactionSourcesCompanion.insert(
          id: 'src-$txId',
          transactionId: txId,
          sourceKind: 'notification',
          provider: parsed.provider,
          notificationKey: Value(row.platformEventId),
          rawPayloadJson: Value(_rawNotificationPayload(row)),
          occurredAt: Value(row.postedAt),
          confidence: Value(parsed.confidence),
        ),
      );
      if (match != null) {
        await into(duplicateCandidates).insert(
          DuplicateCandidatesCompanion.insert(
            id: 'dup-${row.id}',
            householdId: householdMain,
            transactionId: match.transactionId,
            candidateTransactionId: Value(txId),
            score: match.score,
            status: const Value('pending_review'),
            reason: 'heuristic_notification_match',
            explanation: match.explanation,
            createdAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
      await _markRawNotification(
        row.id,
        status: 'draft_created',
        draftTransactionId: txId,
      );
      await _enqueueOutbox(txId, 'create');
      drafts += 1;
    }

    return drafts;
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
    final candidates = <DuplicateCandidatesCompanion>[];

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
      final likelyMatch =
          !record.isValid || duplicateTransactionId != null || alreadyStaged
          ? null
          : await _findLikelyTransactionMatch(record);
      final stagedId = 'staged-$batchId-${record.rowIndex}';
      final shouldMerge = likelyMatch != null && likelyMatch.score >= 0.82;
      final status = !record.isValid
          ? 'invalid'
          : duplicateTransactionId != null || alreadyStaged
          ? 'duplicate'
          : shouldMerge
          ? 'merge_candidate'
          : 'needs_review';
      final duplicateOfTransactionId =
          duplicateTransactionId ?? likelyMatch?.transactionId;
      final errorMessage = record.errorMessage ?? likelyMatch?.explanation;

      switch (status) {
        case 'invalid':
          invalid += 1;
        case 'duplicate':
        case 'merge_candidate':
          duplicate += 1;
        default:
          valid += 1;
          review += 1;
      }

      staged.add(
        StagedSourceRecordsCompanion.insert(
          id: stagedId,
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
          duplicateOfTransactionId: Value(duplicateOfTransactionId),
          errorMessage: Value(errorMessage),
          rawPayloadJson: Value(record.rawPayload),
          confidence: Value(record.confidence),
          createdAt: now,
        ),
      );

      if (likelyMatch != null) {
        candidates.add(
          DuplicateCandidatesCompanion.insert(
            id: 'dup-$stagedId',
            householdId: householdMain,
            transactionId: likelyMatch.transactionId,
            stagedSourceRecordId: Value(stagedId),
            score: likelyMatch.score,
            status: Value(shouldMerge ? 'auto_merged' : 'pending_review'),
            reason: 'heuristic_source_match',
            explanation: likelyMatch.explanation,
            createdAt: now,
          ),
        );
      }
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
        if (candidates.isNotEmpty) {
          batch.insertAll(duplicateCandidates, candidates);
        }
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
              ..where(
                (row) => row.status.isIn(['needs_review', 'merge_candidate']),
              ))
            .get();
    var promoted = 0;

    for (final row in rows) {
      if (row.status == 'merge_candidate' &&
          row.duplicateOfTransactionId != null) {
        await _mergeStagedSourceWithTransaction(
          row: row,
          importBatch: importBatch,
          transactionId: row.duplicateOfTransactionId!,
        );
        continue;
      }

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

      final classification = await _classifyStagedRecord(row);
      final primaryPersonId = await _preferenceValue(
        primaryPersonPreferenceKey,
      );
      await into(transactions).insert(
        _transaction(
          id: txId,
          kind: classification.kind,
          reviewStatus: 'pending',
          duplicateStatus: row.duplicateOfTransactionId == null
              ? 'none'
              : 'probable',
          amountCents: row.amountCents!,
          description: row.descriptionRaw!,
          accountId: classification.accountId,
          transferFromAccountId: classification.transferFromAccountId,
          transferToAccountId: classification.transferToAccountId,
          installmentPlanId: classification.installmentPlanId,
          categoryId: classification.categoryId,
          costCenterId: classification.costCenterId,
          occurredAt: row.occurredAt!,
          confidence: row.confidence,
          payerPersonId: primaryPersonId,
        ),
      );
      if (primaryPersonId != null) {
        await into(
          transactionBeneficiaries,
        ).insert(_beneficiary(txId, primaryPersonId, true));
      }
      await into(
        reviewInbox,
      ).insert(_reviewItem(txId, classification.reviewReason, DateTime.now()));
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
      await (update(
        duplicateCandidates,
      )..where((item) => item.stagedSourceRecordId.equals(row.id))).write(
        DuplicateCandidatesCompanion(
          candidateTransactionId: Value(txId),
          status: const Value('pending_review'),
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

  Future<LocalDataStatus> getLocalDataStatus() async {
    return LocalDataStatus(
      people: (await select(people).get()).length,
      accounts: (await select(accounts).get()).length,
      creditCards: (await select(creditCards).get()).length,
      categories: (await select(categories).get()).length,
      transactions: (await select(transactions).get()).length,
      pendingReview: (await (select(
        transactions,
      )..where((row) => row.reviewStatus.equals('pending'))).get()).length,
      importBatches: (await select(importBatches).get()).length,
      duplicateCandidates: (await select(duplicateCandidates).get()).length,
      recurringSchedules: (await select(recurringSchedules).get()).length,
      installmentPlans: (await select(installmentPlans).get()).length,
    );
  }

  Future<RegistrySnapshot> getRegistrySnapshot({
    bool includeInactive = true,
  }) async {
    final peopleRows = await watchPeople().first;
    final accounts = await listAccountsWithOwners(
      includeInactive: includeInactive,
    );
    final cards = await listCreditCardsWithOwners(
      includeInactive: includeInactive,
    );
    final categoryRows = await listCategories(includeInactive: includeInactive);
    final costCenterRows = await listCostCenters(
      includeInactive: includeInactive,
    );

    return RegistrySnapshot(
      people: peopleRows,
      accounts: accounts,
      creditCards: cards,
      categories: categoryRows,
      costCenters: costCenterRows,
    );
  }

  Future<StartupState> getStartupState() async {
    final status = await getLocalDataStatus();
    final completed =
        await _preferenceValue(onboardingCompletedPreferenceKey) == 'true';
    return StartupState(
      onboardingCompleted: completed,
      hasCoreSetup: status.people > 0 && status.accounts > 0,
      isEmpty: status.isEmpty,
      primaryPersonId: await _preferenceValue(primaryPersonPreferenceKey),
      primaryAccountId: await _preferenceValue(primaryAccountPreferenceKey),
    );
  }

  Future<void> saveInitialSetup(SetupInput input) async {
    final personName = input.personName.trim();
    final accountName = input.accountName.trim();
    if (personName.isEmpty || accountName.isEmpty) {
      throw ArgumentError('Pessoa e conta sao obrigatorias.');
    }

    final stamp = DateTime.now().microsecondsSinceEpoch;
    final personId = 'person-$stamp';
    final accountId = 'account-$stamp';

    await transaction(() async {
      await into(people).insert(
        PeopleCompanion.insert(
          id: personId,
          householdId: householdMain,
          displayName: personName,
          kind: 'adult',
        ),
      );
      await into(accounts).insert(
        AccountsCompanion.insert(
          id: accountId,
          householdId: householdMain,
          ownerPersonId: Value(personId),
          provider: input.accountProvider.trim().isEmpty
              ? 'manual'
              : input.accountProvider.trim().toLowerCase().replaceAll(
                  RegExp(r'\s+'),
                  '_',
                ),
          name: accountName,
          type: input.accountType,
        ),
      );

      if (input.createStarterCategories) {
        await batch((batch) {
          batch.insertAll(categories, [
            _category('starter-mercado', 'Mercado', 10),
            _category('starter-saude', 'Saude', 20),
            _category('starter-transporte', 'Transporte', 30),
            _category('starter-casa', 'Casa', 40),
            _category('starter-lazer', 'Lazer', 50),
            _category('starter-renda', 'Renda', 60, kind: 'income'),
          ]);
          batch.insertAll(costCenters, [
            _costCenter('starter-pessoal', 'Pessoal'),
            _costCenter('starter-casa', 'Casa'),
          ]);
        });
      }

      await _setPreference(primaryPersonPreferenceKey, personId);
      await _setPreference(primaryAccountPreferenceKey, accountId);
      await _setPreference(onboardingCompletedPreferenceKey, 'true');
    });
  }

  Future<void> completeDemoOnboarding() async {
    await loadDemoData();
    await _setPreference(primaryPersonPreferenceKey, 'eu');
    await _setPreference(primaryAccountPreferenceKey, 'mp');
    await _setPreference(onboardingCompletedPreferenceKey, 'true');
  }

  Future<void> seedIfEmpty() async {
    final existing = await (select(transactions)..limit(1)).getSingleOrNull();
    if (existing == null) {
      await _seedInitialData(DateTime.now());
    }

    await ensureFamilyStructureSeed();
  }

  Future<void> loadDemoData() => seedIfEmpty();

  Future<void> clearLocalData() async {
    await transaction(() async {
      await delete(rawNotificationEvents).go();
      await delete(duplicateCandidates).go();
      await delete(stagedSourceRecords).go();
      await delete(importBatches).go();
      await delete(installmentPlans).go();
      await delete(recurringSchedules).go();
      await delete(authUsers).go();
      await delete(appPreferences).go();
      await delete(syncOutbox).go();
      await delete(transactionSources).go();
      await delete(transactionBeneficiaries).go();
      await delete(reviewInbox).go();
      await delete(transactions).go();
      await delete(merchants).go();
      await delete(costCenters).go();
      await delete(categories).go();
      await delete(creditCards).go();
      await delete(accounts).go();
      await delete(people).go();
    });
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
      const CreditCardsCompanion(
        accountId: Value('nu'),
        ownerPersonId: Value('eu'),
      ),
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
    await _resolveSyncConflicts(id, 'keep_local');
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
    await _resolveSyncConflicts(id, 'ignore_local');
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
    await _resolveSyncConflicts(id, 'mark_duplicate');
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
    await _resolveSyncConflicts(id, 'convert_transfer');
    await _enqueueOutbox(id, 'update');
  }

  Future<void> updateTransactionCore({
    required String id,
    required String displayDescription,
    required int amountCents,
    required String kind,
    required String? categoryId,
    required String? costCenterId,
  }) async {
    await (update(transactions)..where((row) => row.id.equals(id))).write(
      TransactionsCompanion(
        displayDescription: Value(displayDescription),
        amountCents: Value(amountCents),
        kind: Value(kind),
        categoryId: Value(categoryId),
        costCenterId: Value(costCenterId),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _enqueueOutbox(id, 'update');
  }

  Future<void> updateTransactionDetails({
    required String id,
    required String displayDescription,
    required int amountCents,
    required String kind,
    required DateTime occurredAt,
    required String competenceMonth,
    required String? accountId,
    required String? categoryId,
    required String? costCenterId,
    required String? payerId,
    required List<String> beneficiaryIds,
  }) async {
    final signedCents = kind == 'expense' && amountCents > 0
        ? -amountCents
        : kind == 'income' && amountCents < 0
        ? amountCents.abs()
        : amountCents;

    await transaction(() async {
      await (update(transactions)..where((row) => row.id.equals(id))).write(
        TransactionsCompanion(
          displayDescription: Value(displayDescription),
          amountCents: Value(signedCents),
          kind: Value(kind),
          occurredAt: Value(occurredAt),
          competenceMonth: Value(competenceMonth),
          accountId: Value(accountId),
          categoryId: Value(categoryId),
          costCenterId: Value(costCenterId),
          payerId: Value(payerId),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await (delete(
        transactionBeneficiaries,
      )..where((row) => row.transactionId.equals(id))).go();
      final uniqueBeneficiaryIds = beneficiaryIds.toSet().toList();
      if (uniqueBeneficiaryIds.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(transactionBeneficiaries, [
            for (final personId in uniqueBeneficiaryIds)
              _beneficiary(
                id,
                personId,
                personId == uniqueBeneficiaryIds.first,
              ),
          ]);
        });
      }
    });
    await _enqueueOutbox(id, 'update');
  }

  Future<String> createManualTransaction(NewTransactionInput input) async {
    final description = input.description.trim();
    if (description.isEmpty || input.amountCents == 0) {
      throw ArgumentError('Descricao e valor sao obrigatorios.');
    }
    final account = await (select(
      accounts,
    )..where((row) => row.id.equals(input.accountId))).getSingleOrNull();
    if (account == null || !account.active) {
      throw StateError('Escolha uma conta ativa.');
    }

    final appliedRule = input.kind == 'transfer'
        ? null
        : await _findMatchingClassificationRule(description, input.kind);
    final categoryId = input.categoryId ?? appliedRule?.categoryId;
    final costCenterId = input.costCenterId ?? appliedRule?.costCenterId;
    final now = DateTime.now();
    final id = 'tx-manual-${now.microsecondsSinceEpoch}';
    final needsReview = input.kind != 'transfer' && categoryId == null;
    final signedAmount = input.kind == 'expense'
        ? -input.amountCents.abs()
        : input.kind == 'income'
        ? input.amountCents.abs()
        : input.amountCents;

    await transaction(() async {
      await into(transactions).insert(
        _transaction(
          id: id,
          kind: input.kind,
          reviewStatus: needsReview ? 'pending' : 'confirmed',
          duplicateStatus: 'none',
          amountCents: signedAmount,
          description: description,
          accountId: input.accountId,
          occurredAt: input.occurredAt ?? now,
          confidence: 1,
          categoryId: categoryId,
          costCenterId: costCenterId,
          payerPersonId: input.payerPersonId,
          appliedRuleId: appliedRule?.id,
        ),
      );
      if (appliedRule != null) {
        await (update(
          classificationRules,
        )..where((row) => row.id.equals(appliedRule.id))).write(
          ClassificationRulesCompanion(
            usageCount: Value(appliedRule.usageCount + 1),
            updatedAt: Value(now),
          ),
        );
      }
      final uniqueBeneficiaries = input.beneficiaryIds.toSet().toList();
      if (uniqueBeneficiaries.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(transactionBeneficiaries, [
            for (final personId in uniqueBeneficiaries)
              _beneficiary(id, personId, personId == uniqueBeneficiaries.first),
          ]);
        });
      }
      await into(transactionSources).insert(
        _source(
          id: 'src-$id-manual',
          transactionId: id,
          sourceKind: 'manual',
          provider: 'zimba_control',
          confidence: 1,
          occurredAt: input.occurredAt ?? now,
        ),
      );
      if (needsReview) {
        await into(
          reviewInbox,
        ).insert(_reviewItem(id, 'manual_needs_classification', now));
      }
    });
    await _enqueueOutbox(id, 'create');
    return id;
  }

  Future<String> upsertPerson({
    String? id,
    required String displayName,
    required String kind,
    bool active = true,
  }) async {
    final name = displayName.trim();
    if (name.isEmpty) {
      throw ArgumentError('Nome da pessoa e obrigatorio.');
    }
    final personId = id ?? 'person-${DateTime.now().microsecondsSinceEpoch}';
    await into(people).insertOnConflictUpdate(
      PeopleCompanion.insert(
        id: personId,
        householdId: householdMain,
        displayName: name,
        kind: kind,
        active: Value(active),
      ),
    );
    return personId;
  }

  Future<void> archivePerson(String id, {bool active = false}) async {
    await (update(people)..where((row) => row.id.equals(id))).write(
      PeopleCompanion(active: Value(active)),
    );
  }

  Future<String> upsertAccount({
    String? id,
    required String provider,
    required String name,
    required String type,
    required String? ownerPersonId,
    String? last4,
    bool active = true,
  }) async {
    final accountId = id ?? 'account-${DateTime.now().microsecondsSinceEpoch}';
    await into(accounts).insertOnConflictUpdate(
      AccountsCompanion.insert(
        id: accountId,
        householdId: householdMain,
        ownerPersonId: Value(ownerPersonId),
        provider: provider.trim().isEmpty ? 'manual' : provider.trim(),
        name: name.trim(),
        type: type,
        last4: Value(last4?.trim().isEmpty == true ? null : last4?.trim()),
        active: Value(active),
      ),
    );
    return accountId;
  }

  Future<void> archiveAccount(String id, {bool active = false}) async {
    await (update(accounts)..where((row) => row.id.equals(id))).write(
      AccountsCompanion(active: Value(active)),
    );
  }

  Future<String> upsertCreditCard({
    String? id,
    String? accountId,
    required String provider,
    required String name,
    required String? ownerPersonId,
    String? brand,
    String? last4,
    int? billingDay,
    int? dueDay,
    bool active = true,
  }) async {
    final cardId = id ?? 'card-${DateTime.now().microsecondsSinceEpoch}';
    final instrumentId =
        accountId ?? 'account-card-${DateTime.now().microsecondsSinceEpoch}';
    await upsertAccount(
      id: instrumentId,
      provider: provider,
      name: name,
      type: 'credit_card',
      ownerPersonId: ownerPersonId,
      last4: last4,
      active: active,
    );
    await into(creditCards).insertOnConflictUpdate(
      CreditCardsCompanion.insert(
        id: cardId,
        householdId: householdMain,
        accountId: Value(instrumentId),
        ownerPersonId: Value(ownerPersonId),
        provider: provider.trim().isEmpty ? 'manual' : provider.trim(),
        name: name.trim(),
        brand: Value(brand?.trim().isEmpty == true ? null : brand?.trim()),
        last4: Value(last4?.trim().isEmpty == true ? null : last4?.trim()),
        billingDay: Value(_validDayOrNull(billingDay)),
        dueDay: Value(_validDayOrNull(dueDay)),
        active: Value(active),
      ),
    );
    return cardId;
  }

  Future<void> archiveCreditCard(String id, {bool active = false}) async {
    final card = await (select(
      creditCards,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    await (update(creditCards)..where((row) => row.id.equals(id))).write(
      CreditCardsCompanion(active: Value(active)),
    );
    if (card?.accountId != null) {
      await archiveAccount(card!.accountId!, active: active);
    }
  }

  Future<String> upsertCategory({
    String? id,
    String? parentId,
    required String name,
    required String kind,
    required int sortOrder,
    bool active = true,
  }) async {
    final categoryId =
        id ?? 'category-${DateTime.now().microsecondsSinceEpoch}';
    await into(categories).insertOnConflictUpdate(
      CategoriesCompanion.insert(
        id: categoryId,
        householdId: householdMain,
        parentId: Value(parentId),
        name: name.trim(),
        kind: kind,
        sortOrder: Value(sortOrder),
        active: Value(active),
      ),
    );
    return categoryId;
  }

  Future<void> archiveCategory(String id, {bool active = false}) async {
    await (update(categories)..where((row) => row.id.equals(id))).write(
      CategoriesCompanion(active: Value(active)),
    );
  }

  Future<String> upsertCostCenter({
    String? id,
    required String name,
    bool active = true,
  }) async {
    final costCenterId =
        id ?? 'cost-center-${DateTime.now().microsecondsSinceEpoch}';
    await into(costCenters).insertOnConflictUpdate(
      CostCentersCompanion.insert(
        id: costCenterId,
        householdId: householdMain,
        name: name.trim(),
        active: Value(active),
      ),
    );
    return costCenterId;
  }

  Future<void> archiveCostCenter(String id, {bool active = false}) async {
    await (update(costCenters)..where((row) => row.id.equals(id))).write(
      CostCentersCompanion(active: Value(active)),
    );
  }

  Future<String> upsertRecurringSchedule({
    String? id,
    required String label,
    required String kind,
    required int amountCents,
    required int dayOfMonth,
    required String startMonth,
    String? payerPersonId,
    String? beneficiaryPersonId,
    String? fromAccountId,
    String? toAccountId,
    String? categoryId,
    String? costCenterId,
    bool active = true,
  }) async {
    final scheduleId =
        id ?? 'recurring-${DateTime.now().microsecondsSinceEpoch}';
    await into(recurringSchedules).insertOnConflictUpdate(
      RecurringSchedulesCompanion.insert(
        id: scheduleId,
        householdId: householdMain,
        label: label.trim(),
        kind: kind,
        amountCents: amountCents,
        dayOfMonth: _validDayOrNull(dayOfMonth) ?? 1,
        startMonth: startMonth,
        payerPersonId: Value(payerPersonId),
        beneficiaryPersonId: Value(beneficiaryPersonId),
        fromAccountId: Value(fromAccountId),
        toAccountId: Value(toAccountId),
        categoryId: Value(categoryId),
        costCenterId: Value(costCenterId),
        active: Value(active),
        updatedAt: DateTime.now(),
      ),
    );
    return scheduleId;
  }

  Future<void> archiveRecurringSchedule(
    String id, {
    bool active = false,
  }) async {
    await (update(recurringSchedules)..where((row) => row.id.equals(id))).write(
      RecurringSchedulesCompanion(
        active: Value(active),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<String> upsertInstallmentPlan({
    String? id,
    required String label,
    required String planKind,
    String? ownerPersonId,
    String? assetName,
    int? totalAmountCents,
    required int installmentAmountCents,
    required int currentInstallment,
    required int totalInstallments,
    int? dueDay,
    required String startMonth,
    String? endMonth,
    String? categoryId,
    String? costCenterId,
    bool active = true,
  }) async {
    final planId = id ?? 'plan-${DateTime.now().microsecondsSinceEpoch}';
    await into(installmentPlans).insertOnConflictUpdate(
      InstallmentPlansCompanion.insert(
        id: planId,
        householdId: householdMain,
        label: label.trim(),
        planKind: planKind,
        ownerPersonId: Value(ownerPersonId),
        assetName: Value(assetName),
        totalAmountCents: Value(totalAmountCents),
        installmentAmountCents: installmentAmountCents,
        currentInstallment: currentInstallment,
        totalInstallments: totalInstallments,
        dueDay: Value(_validDayOrNull(dueDay)),
        startMonth: startMonth,
        endMonth: Value(endMonth),
        categoryId: Value(categoryId),
        costCenterId: Value(costCenterId),
        active: Value(active),
        updatedAt: DateTime.now(),
      ),
    );
    return planId;
  }

  Future<void> archiveInstallmentPlan(String id, {bool active = false}) async {
    await (update(installmentPlans)..where((row) => row.id.equals(id))).write(
      InstallmentPlansCompanion(
        active: Value(active),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> resolveDuplicateCandidate({
    required String id,
    required String resolution,
  }) async {
    final candidate = await (select(
      duplicateCandidates,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (candidate == null) {
      return;
    }

    if (resolution == 'merge' &&
        candidate.stagedSourceRecordId != null &&
        candidate.transactionId.isNotEmpty) {
      final staged =
          await (select(
                stagedSourceRecords,
              )..where((row) => row.id.equals(candidate.stagedSourceRecordId!)))
              .getSingleOrNull();
      if (staged != null) {
        final batch = await (select(
          importBatches,
        )..where((row) => row.id.equals(staged.batchId))).getSingleOrNull();
        if (batch != null) {
          await _mergeStagedSourceWithTransaction(
            row: staged,
            importBatch: batch,
            transactionId: candidate.transactionId,
          );
          return;
        }
      }
    }

    if (resolution == 'merge' && candidate.candidateTransactionId != null) {
      await markDuplicateAndResolve(candidate.candidateTransactionId!);
    }

    await (update(
      duplicateCandidates,
    )..where((row) => row.id.equals(id))).write(
      DuplicateCandidatesCompanion(
        status: Value(resolution),
        resolvedAt: Value(DateTime.now()),
      ),
    );
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

  Future<void> _resolveSyncConflicts(String transactionId, String resolution) {
    return (update(syncConflicts)
          ..where((row) => row.transactionId.equals(transactionId))
          ..where((row) => row.status.equals('pending_review')))
        .write(
          SyncConflictsCompanion(
            status: Value(resolution),
            resolvedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> _enqueueOutbox(String entityId, String operationType) async {
    final transaction = await getTransaction(entityId);
    if (transaction == null) {
      return;
    }
    final now = DateTime.now();
    final deviceId = await _deviceId();
    final queued =
        await (select(syncOutbox)
              ..where((row) => row.entityType.equals('transaction'))
              ..where((row) => row.entityId.equals(entityId))
              ..where((row) => row.status.isIn(['pending', 'failed'])))
            .get();
    final baseVersion = transaction.serverVersion + queued.length;
    await into(syncOutbox).insert(
      SyncOutboxCompanion.insert(
        opId: 'op-${now.microsecondsSinceEpoch}',
        deviceId: deviceId,
        householdId: householdMain,
        entityType: 'transaction',
        entityId: entityId,
        operationType: operationType,
        baseVersion: Value(baseVersion),
        payloadJson: jsonEncode(await _syncTransactionPayload(entityId)),
        createdAt: now,
      ),
    );
  }

  Future<String> _deviceId() async {
    final existing = await _preferenceValue(syncDeviceIdPreferenceKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final generated = 'device-${DateTime.now().microsecondsSinceEpoch}';
    await _setPreference(syncDeviceIdPreferenceKey, generated);
    return generated;
  }

  Map<String, dynamic> _syncOperationJson(SyncOutboxRow operation) {
    final decoded = jsonDecode(operation.payloadJson);
    final payload = decoded is Map
        ? Map<String, dynamic>.from(decoded)
        : <String, dynamic>{'entityId': operation.entityId};
    return {
      'opId': operation.opId,
      'deviceId': operation.deviceId,
      'householdId': operation.householdId,
      'entityType': operation.entityType,
      'entityId': operation.entityId,
      'operationType': operation.operationType,
      'baseVersion': operation.baseVersion,
      'payload': payload,
      'createdAt': operation.createdAt.toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> _syncTransactionPayload(
    String transactionId,
  ) async {
    final transaction = await getTransaction(transactionId);
    if (transaction == null) {
      throw StateError('Transacao $transactionId nao existe para sincronizar.');
    }
    final beneficiaries = await (select(
      transactionBeneficiaries,
    )..where((row) => row.transactionId.equals(transactionId))).get();
    final sources = await listTransactionSources(transactionId);
    return {
      'schemaVersion': 1,
      'transaction': {
        'id': transaction.id,
        'householdId': transaction.householdId,
        'kind': transaction.kind,
        'reviewStatus': transaction.reviewStatus,
        'duplicateStatus': transaction.duplicateStatus,
        'occurredAt': transaction.occurredAt.toIso8601String(),
        'postedAt': transaction.postedAt?.toIso8601String(),
        'competenceMonth': transaction.competenceMonth,
        'amountCents': transaction.amountCents,
        'currencyCode': transaction.currencyCode,
        'descriptionRaw': transaction.descriptionRaw,
        'displayDescription': transaction.displayDescription,
        'accountId': transaction.accountId,
        'transferFromAccountId': transaction.transferFromAccountId,
        'transferToAccountId': transaction.transferToAccountId,
        'recurringScheduleId': transaction.recurringScheduleId,
        'installmentPlanId': transaction.installmentPlanId,
        'merchantId': transaction.merchantId,
        'categoryId': transaction.categoryId,
        'costCenterId': transaction.costCenterId,
        'payerId': transaction.payerId,
        'appliedRuleId': transaction.appliedRuleId,
        'sourceConfidence': transaction.sourceConfidence,
        'updatedAt': transaction.updatedAt.toIso8601String(),
        'deletedAt': transaction.deletedAt?.toIso8601String(),
      },
      'beneficiaries': [
        for (final beneficiary in beneficiaries)
          {
            'id': beneficiary.id,
            'transactionId': beneficiary.transactionId,
            'personId': beneficiary.personId,
            'allocationMode': beneficiary.allocationMode,
            'allocatedAmountCents': beneficiary.allocatedAmountCents,
            'allocatedPercent': beneficiary.allocatedPercent,
            'isPrimary': beneficiary.isPrimary,
          },
      ],
      'sources': [
        for (final source in sources)
          {
            'id': source.id,
            'transactionId': source.transactionId,
            'sourceKind': source.sourceKind,
            'provider': source.provider,
            'externalId': source.externalId,
            'fileHash': source.fileHash,
            'rowHash': source.rowHash,
            'notificationKey': source.notificationKey,
            'rawPayloadJson': source.rawPayloadJson,
            'occurredAt': source.occurredAt?.toIso8601String(),
            'confidence': source.confidence,
          },
      ],
    };
  }

  Future<void> _markOutboxAck(SyncOutboxRow operation) async {
    final now = DateTime.now();
    await (update(
      syncOutbox,
    )..where((row) => row.opId.equals(operation.opId))).write(
      SyncOutboxCompanion(
        sentAt: Value(now),
        ackAt: Value(now),
        status: const Value('acked'),
      ),
    );
    if (operation.entityType != 'transaction') {
      return;
    }
    final transaction = await getTransaction(operation.entityId);
    final acknowledgedVersion = operation.baseVersion + 1;
    if (transaction == null ||
        transaction.serverVersion >= acknowledgedVersion) {
      return;
    }
    await (update(
      transactions,
    )..where((row) => row.id.equals(operation.entityId))).write(
      TransactionsCompanion(
        baseVersion: Value(acknowledgedVersion),
        serverVersion: Value(acknowledgedVersion),
      ),
    );
  }

  Future<void> _markOutboxFailure(SyncOutboxRow operation) {
    return (update(
      syncOutbox,
    )..where((row) => row.opId.equals(operation.opId))).write(
      SyncOutboxCompanion(
        sentAt: Value(DateTime.now()),
        status: const Value('failed'),
        retryCount: Value(operation.retryCount + 1),
      ),
    );
  }

  Future<void> _markOutboxConflict(SyncOutboxRow operation) async {
    await (update(
      syncOutbox,
    )..where((row) => row.opId.equals(operation.opId))).write(
      SyncOutboxCompanion(
        sentAt: Value(DateTime.now()),
        status: const Value('conflict'),
      ),
    );
    if (operation.entityType != 'transaction') {
      return;
    }
    final exists = await getTransaction(operation.entityId);
    if (exists == null) {
      return;
    }
    await into(reviewInbox).insert(
      _reviewItem(
        operation.entityId,
        'sync_conflict',
        DateTime.now(),
        severity: 'high',
        id: 'review-sync-${operation.opId}',
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> _markOutboxRejected(String opId) {
    return (update(syncOutbox)..where((row) => row.opId.equals(opId))).write(
      SyncOutboxCompanion(
        sentAt: Value(DateTime.now()),
        status: const Value('rejected'),
      ),
    );
  }

  Future<String?> _preferenceValue(String key) async {
    final row = await (select(
      appPreferences,
    )..where((item) => item.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> _setPreference(String key, String value) {
    return into(appPreferences).insertOnConflictUpdate(
      AppPreferencesCompanion.insert(
        key: key,
        value: value,
        updatedAt: DateTime.now(),
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

  List<Map<String, dynamic>> _toJsonRows(List<dynamic> rows) {
    return [
      for (final row in rows) Map<String, dynamic>.from(row.toJson() as Map),
    ];
  }

  Future<void> _insertBackupRows<T extends Table, D extends DataClass>(
    TableInfo<T, D> table,
    List<D> rows,
  ) async {
    if (rows.isEmpty) {
      return;
    }
    await batch((batch) {
      batch.insertAll(
        table,
        rows.map((row) => row as Insertable<D>),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  _DecodedBackup _decodeBackup(List<int> bytes) {
    final root = jsonDecode(utf8.decode(bytes, allowMalformed: false));
    if (root is! Map) {
      throw const FormatException('Backup precisa ser um objeto JSON.');
    }
    final json = Map<String, dynamic>.from(root);
    if (json['format'] != ZimbaBackupFile.format) {
      throw const FormatException('Formato de backup desconhecido.');
    }
    if (json['version'] != ZimbaBackupFile.currentVersion) {
      throw const FormatException('Versao de backup incompativel.');
    }
    final data = _jsonObject(json['data']);
    final counts = _jsonObject(
      json['counts'],
    ).map((key, value) => MapEntry(key, value is int ? value : 0));

    return _DecodedBackup(
      exportedAt: DateTime.parse(json['exportedAt'] as String),
      schemaVersion: json['schemaVersion'] as int? ?? 0,
      counts: counts,
      people: _decodeRows(data, 'people', PersonRow.fromJson),
      accounts: _decodeRows(data, 'accounts', AccountRow.fromJson),
      creditCards: _decodeRows(data, 'creditCards', CreditCardRow.fromJson),
      categories: _decodeRows(data, 'categories', CategoryRow.fromJson),
      costCenters: _decodeRows(data, 'costCenters', CostCenterRow.fromJson),
      merchants: _decodeRows(data, 'merchants', MerchantRow.fromJson),
      transactions: _decodeRows(
        data,
        'transactions',
        FinanceTransaction.fromJson,
      ),
      reviewInbox: _decodeRows(data, 'reviewInbox', ReviewInboxRow.fromJson),
      transactionBeneficiaries: _decodeRows(
        data,
        'transactionBeneficiaries',
        TransactionBeneficiaryRow.fromJson,
      ),
      transactionSources: _decodeRows(
        data,
        'transactionSources',
        TransactionSourceRow.fromJson,
      ),
      classificationRules: _decodeRows(
        data,
        'classificationRules',
        ClassificationRuleRow.fromJson,
      ),
      syncOutbox: _decodeRows(data, 'syncOutbox', SyncOutboxRow.fromJson),
      syncAppliedEvents: _decodeRows(
        data,
        'syncAppliedEvents',
        SyncAppliedEventRow.fromJson,
      ),
      syncConflicts: _decodeRows(
        data,
        'syncConflicts',
        SyncConflictRow.fromJson,
      ),
      appPreferences: _decodeRows(
        data,
        'appPreferences',
        AppPreferenceRow.fromJson,
      ),
      authUsers: _decodeRows(data, 'authUsers', AuthUserRow.fromJson),
      recurringSchedules: _decodeRows(
        data,
        'recurringSchedules',
        RecurringScheduleRow.fromJson,
      ),
      installmentPlans: _decodeRows(
        data,
        'installmentPlans',
        InstallmentPlanRow.fromJson,
      ),
      importBatches: _decodeRows(
        data,
        'importBatches',
        ImportBatchRow.fromJson,
      ),
      stagedSourceRecords: _decodeRows(
        data,
        'stagedSourceRecords',
        StagedSourceRecordRow.fromJson,
      ),
      duplicateCandidates: _decodeRows(
        data,
        'duplicateCandidates',
        DuplicateCandidateRow.fromJson,
      ),
      rawNotificationEvents: _decodeRows(
        data,
        'rawNotificationEvents',
        RawNotificationEventRow.fromJson,
      ),
    );
  }

  Map<String, dynamic> _jsonObject(Object? value) {
    if (value is! Map) {
      throw const FormatException('Objeto JSON ausente.');
    }
    return Map<String, dynamic>.from(value);
  }

  List<T> _decodeRows<T>(
    Map<String, dynamic> data,
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final raw = data[key];
    if (raw is! List) {
      return const [];
    }
    return [
      for (final item in raw) fromJson(Map<String, dynamic>.from(item as Map)),
    ];
  }

  String _csvCell(String value) {
    final escaped = value.replaceAll('"', '""');
    if (escaped.contains(';') ||
        escaped.contains('"') ||
        escaped.contains('\n')) {
      return '"$escaped"';
    }
    return escaped;
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

  Future<String?> _findDuplicateNotification(String notificationKey) async {
    final exact =
        await (select(transactionSources)
              ..where((row) => row.notificationKey.equals(notificationKey))
              ..limit(1))
            .getSingleOrNull();
    return exact?.transactionId;
  }

  Future<int> _countRawNotificationsWithStatus(String status) async {
    final count = rawNotificationEvents.id.count();
    final row =
        await (selectOnly(rawNotificationEvents)
              ..addColumns([count])
              ..where(rawNotificationEvents.status.equals(status)))
            .getSingle();
    return row.read(count) ?? 0;
  }

  Future<_ReconciliationMatch?> _findLikelyTransactionMatch(
    CanonicalImportRecord record,
  ) async {
    if (!record.isValid) {
      return null;
    }

    final candidates =
        await (select(transactions)
              ..where((row) => row.deletedAt.isNull())
              ..where((row) => row.amountCents.equals(record.amountCents!)))
            .get();
    if (candidates.isEmpty) {
      return null;
    }

    final providerAccountId = await _accountForProvider(record.provider);
    final recordTokens = _conciliationTokens(record.description ?? '');
    _ReconciliationMatch? best;

    for (final candidate in candidates) {
      final daysApart = candidate.occurredAt
          .difference(record.occurredAt!)
          .inDays
          .abs();
      if (daysApart > 3) {
        continue;
      }

      var score = 0.4;
      final parts = <String>['valor igual'];

      if (daysApart == 0) {
        score += 0.25;
        parts.add('mesma data');
      } else if (daysApart == 1) {
        score += 0.22;
        parts.add('data com diferenca de 1 dia');
      } else {
        score += 0.15;
        parts.add('data proxima');
      }

      if (providerAccountId != null &&
          candidate.accountId == providerAccountId) {
        score += 0.1;
        parts.add('mesma conta');
      } else if (candidate.accountId == null) {
        score += 0.04;
        parts.add('conta ainda nao definida');
      }

      final candidateTokens = _conciliationTokens(candidate.descriptionRaw);
      final overlap = _tokenOverlap(recordTokens, candidateTokens);
      if (overlap >= 0.6) {
        score += 0.25;
        parts.add('descricao muito parecida');
      } else if (overlap >= 0.35) {
        score += 0.18;
        parts.add('descricao parecida');
      } else if (_normalizedConciliationText(
            candidate.descriptionRaw,
          ).contains(_normalizedConciliationText(record.description ?? '')) ||
          _normalizedConciliationText(
            record.description ?? '',
          ).contains(_normalizedConciliationText(candidate.descriptionRaw))) {
        score += 0.2;
        parts.add('descricao contida em outra fonte');
      }

      if (score < 0.65) {
        continue;
      }

      final match = _ReconciliationMatch(
        transactionId: candidate.id,
        score: score.clamp(0, 1).toDouble(),
        explanation:
            'Possivel mesma movimentacao: ${parts.join(', ')}. '
            'Confianca ${(score.clamp(0, 1) * 100).round()}%.',
      );
      if (best == null || match.score > best.score) {
        best = match;
      }
    }

    return best;
  }

  Future<void> _mergeNotificationSourceWithTransaction({
    required RawNotificationEventRow row,
    required String provider,
    required double confidence,
    required String transactionId,
    required String explanation,
  }) async {
    final now = DateTime.now();
    final transaction = await getTransaction(transactionId);
    if (transaction == null) {
      return;
    }

    await into(transactionSources).insert(
      TransactionSourcesCompanion.insert(
        id: 'src-merge-${row.id}',
        transactionId: transactionId,
        sourceKind: 'notification',
        provider: provider,
        notificationKey: Value(row.platformEventId),
        rawPayloadJson: Value(_rawNotificationPayload(row)),
        occurredAt: Value(row.postedAt),
        confidence: Value(confidence),
      ),
      mode: InsertMode.insertOrIgnore,
    );
    if (confidence > transaction.sourceConfidence) {
      await (update(
        transactions,
      )..where((item) => item.id.equals(transactionId))).write(
        TransactionsCompanion(
          sourceConfidence: Value(confidence),
          updatedAt: Value(now),
        ),
      );
    }
    await into(duplicateCandidates).insert(
      DuplicateCandidatesCompanion.insert(
        id: 'dup-${row.id}',
        householdId: householdMain,
        transactionId: transactionId,
        score: 0.9,
        status: const Value('auto_merged'),
        reason: 'heuristic_notification_match',
        explanation: explanation,
        createdAt: now,
        resolvedAt: Value(now),
      ),
      mode: InsertMode.insertOrIgnore,
    );
    await _markRawNotification(
      row.id,
      status: 'merged',
      draftTransactionId: transactionId,
    );
    await _enqueueOutbox(transactionId, 'update');
  }

  CanonicalImportRecord? _parseRawNotificationEvent(
    RawNotificationEventRow row,
  ) {
    final text = [
      row.title,
      row.bodyText,
      row.bigText,
    ].whereType<String>().join(' ');
    final amount = _parseNotificationAmountCents(text);
    if (amount == null) {
      return null;
    }

    final provider = _providerForPackage(row.packageName);
    final description = _notificationDescription(row);
    return CanonicalImportRecord(
      rowIndex: 0,
      rowHash: row.platformEventId,
      sourceKind: 'notification',
      provider: provider,
      rawPayload: _rawNotificationPayload(row),
      externalId: row.platformEventId,
      occurredAt: row.postedAt,
      postedAt: row.postedAt,
      description: description,
      amountCents: amount,
      accountHint: provider,
      confidence: 0.76,
    );
  }

  int? _parseNotificationAmountCents(String text) {
    final match = RegExp(
      r'(?:R\$\s*)?-?\d{1,3}(?:[.\s]\d{3})*(?:,\d{2})|(?:R\$\s*)?-?\d+,\d{2}',
      caseSensitive: false,
    ).firstMatch(text);
    if (match == null) {
      return null;
    }

    final parsed = parseAmountCents(match.group(0) ?? '');
    if (parsed == null) {
      return null;
    }

    final normalized = _normalizedConciliationText(text);
    final isIncome =
        normalized.contains('receb') ||
        normalized.contains('deposito') ||
        normalized.contains('transferencia recebida') ||
        normalized.contains('pix recebido');
    final isExpense =
        normalized.contains('compra') ||
        normalized.contains('pagamento') ||
        normalized.contains('enviado') ||
        normalized.contains('debito') ||
        normalized.contains('cartao');

    if (isIncome && !isExpense) {
      return parsed.abs();
    }
    return -parsed.abs();
  }

  String _providerForPackage(String packageName) {
    final normalized = packageName.toLowerCase();
    if (normalized.contains('nubank') || normalized.contains('.nu')) {
      return 'nubank';
    }
    if (normalized.contains('mercadopago') || normalized.contains('mercado')) {
      return 'mercado_pago';
    }
    return 'unknown';
  }

  String _notificationDescription(RawNotificationEventRow row) {
    final candidates = [row.title, row.bodyText, row.bigText, row.appLabel];
    final description = candidates
        .whereType<String>()
        .map((value) => value.trim())
        .firstWhere((value) => value.isNotEmpty, orElse: () => 'Notificacao');
    return description.length <= 96
        ? description
        : description.substring(0, 96);
  }

  String _rawNotificationPayload(RawNotificationEventRow row) {
    if (row.rawPayloadJson != null && row.rawPayloadJson!.trim().isNotEmpty) {
      return row.rawPayloadJson!;
    }
    return jsonEncode({
      'platformEventId': row.platformEventId,
      'packageName': row.packageName,
      'appLabel': row.appLabel,
      'title': row.title,
      'text': row.bodyText,
      'bigText': row.bigText,
      'notificationId': row.notificationId,
      'tag': row.tag,
      'postedAt': row.postedAt.toIso8601String(),
      'capturedAt': row.capturedAt.toIso8601String(),
    });
  }

  Future<void> _markRawNotification(
    String id, {
    required String status,
    String? draftTransactionId,
    String? errorMessage,
  }) {
    return (update(
      rawNotificationEvents,
    )..where((row) => row.id.equals(id))).write(
      RawNotificationEventsCompanion(
        status: Value(status),
        draftTransactionId: Value(draftTransactionId),
        errorMessage: Value(errorMessage),
        processedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> _mergeStagedSourceWithTransaction({
    required StagedSourceRecordRow row,
    required ImportBatchRow importBatch,
    required String transactionId,
  }) async {
    final now = DateTime.now();
    final transaction = await getTransaction(transactionId);
    if (transaction == null) {
      return;
    }

    await into(transactionSources).insert(
      TransactionSourcesCompanion.insert(
        id: 'src-merge-${row.id}',
        transactionId: transactionId,
        sourceKind: row.sourceKind,
        provider: row.provider,
        externalId: Value(row.externalId),
        fileHash: Value(importBatch.fileHash),
        rowHash: Value(row.rowHash),
        rawPayloadJson: Value(row.rawPayloadJson),
        occurredAt: Value(row.occurredAt),
        confidence: Value(row.confidence),
      ),
      mode: InsertMode.insertOrIgnore,
    );
    if (row.confidence > transaction.sourceConfidence) {
      await (update(
        transactions,
      )..where((item) => item.id.equals(transactionId))).write(
        TransactionsCompanion(
          sourceConfidence: Value(row.confidence),
          updatedAt: Value(now),
        ),
      );
    }
    await (update(
      stagedSourceRecords,
    )..where((item) => item.id.equals(row.id))).write(
      StagedSourceRecordsCompanion(
        status: const Value('merged'),
        duplicateOfTransactionId: Value(transactionId),
        promotedAt: Value(now),
      ),
    );
    await (update(
      duplicateCandidates,
    )..where((item) => item.stagedSourceRecordId.equals(row.id))).write(
      DuplicateCandidatesCompanion(
        status: const Value('auto_merged'),
        resolvedAt: Value(now),
      ),
    );
    await _enqueueOutbox(transactionId, 'update');
  }

  Future<_PromotedRecordClassification> _classifyStagedRecord(
    StagedSourceRecordRow row,
  ) async {
    final accountId = await _accountForProvider(row.provider);
    final description = row.descriptionRaw ?? '';
    if (_isInvoicePayment(description)) {
      final transferToAccountId = accountId == 'nu' ? null : 'nu';
      return _PromotedRecordClassification(
        kind: 'transfer',
        accountId: accountId,
        transferFromAccountId: accountId,
        transferToAccountId: transferToAccountId,
        reviewReason: 'invoice_payment_transfer_needs_review',
      );
    }

    if (_isConsortiumPayment(description)) {
      return _PromotedRecordClassification(
        kind: row.amountCents! >= 0 ? 'income' : 'expense',
        accountId: accountId,
        installmentPlanId: 'plan-consorcio-carro',
        categoryId: 'transporte',
        costCenterId: 'casa',
        reviewReason: 'consortium_payment_needs_review',
      );
    }

    final installment = _installmentHint(description);
    if (installment != null && row.occurredAt != null) {
      final planId = await _ensureCreditCardInstallmentPlan(row, installment);
      return _PromotedRecordClassification(
        kind: row.amountCents! >= 0 ? 'income' : 'expense',
        accountId: accountId,
        installmentPlanId: planId,
        reviewReason: 'installment_purchase_needs_review',
      );
    }

    return _PromotedRecordClassification(
      kind: row.amountCents! >= 0 ? 'income' : 'expense',
      accountId: accountId,
      reviewReason: row.duplicateOfTransactionId == null
          ? 'imported_statement_needs_review'
          : 'possible_duplicate_needs_review',
    );
  }

  Future<String> _ensureCreditCardInstallmentPlan(
    StagedSourceRecordRow row,
    _InstallmentHint installment,
  ) async {
    final occurredAt = row.occurredAt!;
    final accountId = await _accountForProvider(row.provider);
    final card = await _creditCardForAccountOrFirst(accountId);
    final label = _cleanInstallmentLabel(row.descriptionRaw ?? 'Compra');
    final invoiceMonth = card == null
        ? _monthKey(occurredAt)
        : invoiceMonthFor(card, occurredAt);
    final invoiceBase = _dateFromMonthKey(invoiceMonth);
    final planId =
        'plan-card-${_compactId(label)}-$invoiceMonth-'
        '${installment.totalInstallments}-${row.amountCents!.abs()}';
    final start = _shiftMonth(invoiceBase, 1 - installment.currentInstallment);
    final end = _shiftMonth(
      invoiceBase,
      installment.totalInstallments - installment.currentInstallment,
    );

    await into(installmentPlans).insert(
      InstallmentPlansCompanion.insert(
        id: planId,
        householdId: householdMain,
        label: label,
        planKind: 'credit_card_purchase',
        ownerPersonId: const Value('eu'),
        totalAmountCents: Value(
          row.amountCents!.abs() * installment.totalInstallments,
        ),
        installmentAmountCents: row.amountCents!.abs(),
        currentInstallment: installment.currentInstallment,
        totalInstallments: installment.totalInstallments,
        dueDay: Value(card?.dueDay),
        startMonth: _monthKey(start),
        endMonth: Value(_monthKey(end)),
        updatedAt: DateTime.now(),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    return planId;
  }

  bool _isInvoicePayment(String description) {
    final text = _normalizedConciliationText(description);
    return text.contains('pagamento fatura') ||
        text.contains('pag fatura') ||
        text.contains('fatura cartao') ||
        text.contains('fatura nubank') ||
        text.contains('pagamento cartao');
  }

  bool _isConsortiumPayment(String description) {
    return _normalizedConciliationText(description).contains('consorcio');
  }

  _InstallmentHint? _installmentHint(String description) {
    final text = _foldAccents(description.toLowerCase());
    final match = RegExp(
      r'(?:parcela\s*)?(\d{1,2})\s*/\s*(\d{1,2})',
    ).firstMatch(text);
    if (match == null) {
      return null;
    }

    final current = int.parse(match.group(1)!);
    final total = int.parse(match.group(2)!);
    if (current <= 0 || total <= 1 || current > total || total > 120) {
      return null;
    }
    return _InstallmentHint(
      currentInstallment: current,
      totalInstallments: total,
    );
  }

  String _cleanInstallmentLabel(String description) {
    final cleaned = description
        .replaceAll(
          RegExp(r'(?:parcela\s*)?\d{1,2}\s*/\s*\d{1,2}', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return cleaned.isEmpty ? 'Compra parcelada' : cleaned;
  }

  String _normalizedConciliationText(String value) {
    return _foldAccents(value.toLowerCase())
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _foldAccents(String value) {
    const replacements = {
      'á': 'a',
      'à': 'a',
      'ã': 'a',
      'â': 'a',
      'é': 'e',
      'ê': 'e',
      'í': 'i',
      'ó': 'o',
      'ô': 'o',
      'õ': 'o',
      'ú': 'u',
      'ç': 'c',
    };
    return value.split('').map((char) => replacements[char] ?? char).join();
  }

  Set<String> _conciliationTokens(String value) {
    const ignored = {
      'de',
      'da',
      'do',
      'das',
      'dos',
      'em',
      'no',
      'na',
      'pagamento',
      'compra',
      'pix',
    };
    return _normalizedConciliationText(value)
        .split(' ')
        .where((token) => token.length >= 3 && !ignored.contains(token))
        .toSet();
  }

  double _tokenOverlap(Set<String> left, Set<String> right) {
    if (left.isEmpty || right.isEmpty) {
      return 0;
    }
    final intersection = left.intersection(right).length;
    final smallest = left.length < right.length ? left.length : right.length;
    return intersection / smallest;
  }

  String _compactId(String value) {
    final compact = _normalizedConciliationText(
      value,
    ).replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
    if (compact.isEmpty) {
      return 'compra';
    }
    return compact.length <= 32 ? compact : compact.substring(0, 32);
  }

  String _monthKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}';
  }

  DateTime _shiftMonth(DateTime date, int months) {
    return DateTime(date.year, date.month + months, 1);
  }

  String invoiceMonthFor(CreditCardRow card, DateTime occurredAt) {
    final closingDay = _validDayOrNull(card.billingDay) ?? occurredAt.day;
    final invoiceBase = occurredAt.day <= closingDay
        ? occurredAt
        : _shiftMonth(occurredAt, 1);
    return _monthKey(invoiceBase);
  }

  DateTime invoiceDueDateFor(CreditCardRow card, DateTime occurredAt) {
    final invoiceMonth = invoiceMonthFor(card, occurredAt);
    final base = _dateFromMonthKey(invoiceMonth);
    final dueDay = _validDayOrNull(card.dueDay) ?? 1;
    return DateTime(
      base.year,
      base.month,
      _clampDay(base.year, base.month, dueDay),
    );
  }

  DateTime installmentDueDateFor(InstallmentPlanRow plan, DateTime reference) {
    final base = _dateFromMonthKey(plan.startMonth);
    final dueDay = _validDayOrNull(plan.dueDay) ?? 1;
    final due = DateTime(
      base.year,
      base.month,
      _clampDay(base.year, base.month, dueDay),
    );
    if (!due.isBefore(
      DateTime(reference.year, reference.month, reference.day),
    )) {
      return due;
    }
    return DateTime(
      reference.year,
      reference.month,
      _clampDay(reference.year, reference.month, dueDay),
    );
  }

  DateTime _dateFromMonthKey(String monthKey) {
    final parts = monthKey.split('-');
    final year = int.tryParse(parts.first) ?? DateTime.now().year;
    final month = parts.length > 1
        ? int.tryParse(parts[1]) ?? DateTime.now().month
        : DateTime.now().month;
    return DateTime(year, month, 1);
  }

  int _clampDay(int year, int month, int day) {
    final lastDay = DateTime(year, month + 1, 0).day;
    if (day < 1) {
      return 1;
    }
    return day > lastDay ? lastDay : day;
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

  Future<String?> _accountForProvider(String provider) async {
    final account =
        await (select(accounts)
              ..where((row) => row.provider.equals(provider))
              ..where((row) => row.active.equals(true))
              ..limit(1))
            .getSingleOrNull();
    return account?.id;
  }

  Future<CreditCardRow?> _creditCardForAccountOrFirst(String? accountId) async {
    if (accountId != null) {
      final byAccount =
          await (select(creditCards)
                ..where((row) => row.accountId.equals(accountId))
                ..where((row) => row.active.equals(true))
                ..limit(1))
              .getSingleOrNull();
      if (byAccount != null) {
        return byAccount;
      }
    }
    return (select(creditCards)
          ..where((row) => row.active.equals(true))
          ..limit(1))
        .getSingleOrNull();
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
    String? payerPersonId,
    String? appliedRuleId,
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
      displayDescription: Value(description),
      accountId: Value(accountId),
      transferFromAccountId: Value(transferFromAccountId),
      transferToAccountId: Value(transferToAccountId),
      recurringScheduleId: Value(recurringScheduleId),
      installmentPlanId: Value(installmentPlanId),
      merchantId: Value(merchantId),
      categoryId: Value(categoryId),
      costCenterId: Value(costCenterId),
      payerId: Value(payerPersonId),
      appliedRuleId: Value(appliedRuleId),
      sourceConfidence: Value(confidence),
      updatedAt: occurredAt,
    );
  }

  Future<ClassificationRuleRow?> _findMatchingClassificationRule(
    String description,
    String kind,
  ) async {
    final normalizedDescription = description.trim().toLowerCase();
    if (normalizedDescription.isEmpty) {
      return null;
    }
    final rules = await listClassificationRules(includeInactive: false);
    for (final rule in rules) {
      final normalizedMatch = rule.matchText.trim().toLowerCase();
      if (normalizedMatch.isEmpty) {
        continue;
      }
      if ((rule.kind == null || rule.kind == kind) &&
          normalizedDescription.contains(normalizedMatch)) {
        return rule;
      }
    }
    return null;
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
    DateTime createdAt, {
    String? id,
    String severity = 'medium',
  }) {
    return ReviewInboxCompanion.insert(
      id: id ?? 'review-$transactionId',
      householdId: householdMain,
      transactionId: transactionId,
      reason: reason,
      severity: Value(severity),
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

  int? _validDayOrNull(int? value) {
    if (value == null || value < 1 || value > 31) {
      return null;
    }
    return value;
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
    final conflictRows =
        await (select(syncConflicts)
              ..where((row) => row.transactionId.isIn(transactionIds))
              ..where((row) => row.status.equals('pending_review')))
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
    final conflictByTransaction = <String, SyncConflictRow>{
      for (final row in conflictRows) row.transactionId: row,
    };

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
          syncConflict: conflictByTransaction[tx.id],
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
    this.syncConflict,
  });

  final FinanceTransaction transaction;
  final AccountRow? account;
  final MerchantRow? merchant;
  final CategoryRow? category;
  final CostCenterRow? costCenter;
  final List<PersonRow> beneficiaries;
  final List<TransactionSourceRow> sources;
  final List<ReviewInboxRow> inboxItems;
  final SyncConflictRow? syncConflict;

  String get displayTitle {
    final custom = transaction.displayDescription?.trim();
    if (custom != null && custom.isNotEmpty) {
      return custom;
    }
    return merchant?.displayName ?? transaction.descriptionRaw;
  }

  String get displayMerchant => displayTitle;

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

  String? get syncConflictSummary {
    final conflict = syncConflict;
    if (conflict == null) {
      return null;
    }
    try {
      final local = _syncConflictTransaction(conflict.localPayloadJson);
      final remote = _syncConflictTransaction(conflict.remotePayloadJson);
      return 'Neste aparelho: ${local.$1} (${local.$2} centavos) · '
          'outro aparelho: ${remote.$1} (${remote.$2} centavos).';
    } catch (_) {
      return 'Os dois estados foram preservados para decisao manual.';
    }
  }
}

(String, int) _syncConflictTransaction(String payloadJson) {
  final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
  final transaction = payload['transaction'] as Map<String, dynamic>;
  return (
    transaction['displayDescription'] as String? ??
        transaction['descriptionRaw'] as String? ??
        'Sem descricao',
    transaction['amountCents'] as int? ?? 0,
  );
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

class RegistrySnapshot {
  const RegistrySnapshot({
    required this.people,
    required this.accounts,
    required this.creditCards,
    required this.categories,
    required this.costCenters,
  });

  final List<PersonRow> people;
  final List<AccountWithOwner> accounts;
  final List<CreditCardWithOwner> creditCards;
  final List<CategoryRow> categories;
  final List<CostCenterRow> costCenters;
}

class StartupState {
  const StartupState({
    required this.onboardingCompleted,
    required this.hasCoreSetup,
    required this.isEmpty,
    required this.primaryPersonId,
    required this.primaryAccountId,
  });

  final bool onboardingCompleted;
  final bool hasCoreSetup;
  final bool isEmpty;
  final String? primaryPersonId;
  final String? primaryAccountId;

  bool get needsOnboarding => !onboardingCompleted || !hasCoreSetup;
}

class SetupInput {
  const SetupInput({
    required this.personName,
    required this.accountName,
    required this.accountProvider,
    this.accountType = 'account',
    this.createStarterCategories = true,
  });

  final String personName;
  final String accountName;
  final String accountProvider;
  final String accountType;
  final bool createStarterCategories;
}

class NewTransactionInput {
  const NewTransactionInput({
    required this.kind,
    required this.amountCents,
    required this.description,
    required this.accountId,
    required this.payerPersonId,
    this.categoryId,
    this.costCenterId,
    this.beneficiaryIds = const [],
    this.occurredAt,
  });

  final String kind;
  final int amountCents;
  final String description;
  final String accountId;
  final String? payerPersonId;
  final String? categoryId;
  final String? costCenterId;
  final List<String> beneficiaryIds;
  final DateTime? occurredAt;
}

class LocalDataStatus {
  const LocalDataStatus({
    required this.people,
    required this.accounts,
    required this.creditCards,
    required this.categories,
    required this.transactions,
    required this.pendingReview,
    required this.importBatches,
    required this.duplicateCandidates,
    required this.recurringSchedules,
    required this.installmentPlans,
  });

  final int people;
  final int accounts;
  final int creditCards;
  final int categories;
  final int transactions;
  final int pendingReview;
  final int importBatches;
  final int duplicateCandidates;
  final int recurringSchedules;
  final int installmentPlans;

  bool get isEmpty =>
      people == 0 &&
      accounts == 0 &&
      creditCards == 0 &&
      categories == 0 &&
      transactions == 0 &&
      importBatches == 0 &&
      recurringSchedules == 0 &&
      installmentPlans == 0;
}

class DuplicateCandidateDetails {
  const DuplicateCandidateDetails({
    required this.candidate,
    required this.primaryTransaction,
    required this.candidateTransaction,
    required this.stagedRecord,
  });

  final DuplicateCandidateRow candidate;
  final FinanceTransaction? primaryTransaction;
  final FinanceTransaction? candidateTransaction;
  final StagedSourceRecordRow? stagedRecord;
}

class ImportBatchDetails {
  const ImportBatchDetails({required this.batch, required this.records});

  final ImportBatchRow batch;
  final List<StagedSourceRecordRow> records;
}

class NotificationCaptureSyncResult {
  const NotificationCaptureSyncResult({
    required this.fetched,
    required this.recorded,
    required this.drafts,
    this.bridgeError,
  });

  final int fetched;
  final int recorded;
  final int drafts;
  final String? bridgeError;
}

class NotificationCaptureDiagnostics {
  const NotificationCaptureDiagnostics({
    required this.counts,
    required this.retentionDays,
    this.lastDrain,
    this.lastError,
  });

  final Map<String, int> counts;
  final int retentionDays;
  final DateTime? lastDrain;
  final String? lastError;

  int count(String status) => counts[status] ?? 0;
}

class ZimbaBackupFile {
  const ZimbaBackupFile({
    required this.fileName,
    required this.exportedAt,
    required this.counts,
    required this.bytes,
  });

  static const format = 'br.com.zimbacontrol.backup';
  static const currentVersion = 1;

  final String fileName;
  final DateTime exportedAt;
  final Map<String, int> counts;
  final List<int> bytes;

  int get transactionCount => counts['transactions'] ?? 0;

  int get totalRows => counts.values.fold<int>(0, (sum, count) => sum + count);
}

class BackupValidationResult {
  const BackupValidationResult({
    required this.valid,
    required this.message,
    required this.counts,
    this.exportedAt,
    this.schemaVersion,
  });

  final bool valid;
  final String message;
  final Map<String, int> counts;
  final DateTime? exportedAt;
  final int? schemaVersion;

  int get transactionCount => counts['transactions'] ?? 0;

  int get totalRows => counts.values.fold<int>(0, (sum, count) => sum + count);
}

class SyncRunSummary {
  const SyncRunSummary({
    required this.pushed,
    required this.duplicates,
    required this.conflicts,
    required this.rejected,
    required this.pulled,
    required this.applied,
    required this.remoteConflicts,
    required this.latestSeq,
  });

  final int pushed;
  final int duplicates;
  final int conflicts;
  final int rejected;
  final int pulled;
  final int applied;
  final int remoteConflicts;
  final int latestSeq;
}

class _PullApplySummary {
  const _PullApplySummary({
    required this.applied,
    required this.conflicts,
    required this.latestSeq,
  });

  final int applied;
  final int conflicts;
  final int latestSeq;
}

class _RemoteApplyResult {
  const _RemoteApplyResult({this.conflict = false});

  final bool conflict;
}

class _SyncTransactionPayload {
  const _SyncTransactionPayload({
    required this.operationType,
    required this.serverAt,
    required this.transaction,
    required this.beneficiaries,
    required this.sources,
  });

  final String operationType;
  final DateTime serverAt;
  final _RemoteTransactionData transaction;
  final List<TransactionBeneficiariesCompanion> beneficiaries;
  final List<TransactionSourcesCompanion> sources;

  factory _SyncTransactionPayload.fromEvent(Map<String, dynamic> event) {
    final payload = _syncMap(event['payload'], 'payload');
    if (_syncInt(payload['schemaVersion'], 'payload.schemaVersion') != 1) {
      throw const FormatException('Versao de payload de sync nao suportada.');
    }
    final transaction = _syncMap(payload['transaction'], 'payload.transaction');
    final transactionId = _requiredSyncString(transaction, 'id');
    final beneficiaries = _syncList(payload['beneficiaries'], 'beneficiaries')
        .map((value) {
          final item = _syncMap(value, 'beneficiary');
          return TransactionBeneficiariesCompanion.insert(
            id: _requiredSyncString(item, 'id'),
            transactionId: _requiredSyncString(item, 'transactionId'),
            personId: _requiredSyncString(item, 'personId'),
            allocationMode: Value(
              item['allocationMode'] as String? ?? 'mark_only',
            ),
            allocatedAmountCents: Value(item['allocatedAmountCents'] as int?),
            allocatedPercent: Value(
              _syncNullableDouble(item['allocatedPercent']),
            ),
            isPrimary: Value(item['isPrimary'] == true),
          );
        })
        .toList(growable: false);
    final sources = _syncList(payload['sources'], 'sources')
        .map((value) {
          final item = _syncMap(value, 'source');
          return TransactionSourcesCompanion.insert(
            id: _requiredSyncString(item, 'id'),
            transactionId: _requiredSyncString(item, 'transactionId'),
            sourceKind: _requiredSyncString(item, 'sourceKind'),
            provider: _requiredSyncString(item, 'provider'),
            externalId: Value(item['externalId'] as String?),
            fileHash: Value(item['fileHash'] as String?),
            rowHash: Value(item['rowHash'] as String?),
            notificationKey: Value(item['notificationKey'] as String?),
            rawPayloadJson: Value(item['rawPayloadJson'] as String?),
            occurredAt: Value(_syncNullableDateTime(item['occurredAt'])),
            confidence: Value(
              _syncDouble(item['confidence'], 'source.confidence'),
            ),
          );
        })
        .toList(growable: false);

    if (beneficiaries.any(
          (item) => item.transactionId.value != transactionId,
        ) ||
        sources.any((item) => item.transactionId.value != transactionId)) {
      throw const FormatException(
        'Payload de sync contem relacao de outra transacao.',
      );
    }
    return _SyncTransactionPayload(
      operationType: _requiredSyncString(event, 'operationType'),
      serverAt: _syncDateTime(event['serverAt'], 'serverAt'),
      transaction: _RemoteTransactionData.fromJson(transaction),
      beneficiaries: beneficiaries,
      sources: sources,
    );
  }
}

class _RemoteTransactionData {
  const _RemoteTransactionData({
    required this.id,
    required this.householdId,
    required this.kind,
    required this.reviewStatus,
    required this.duplicateStatus,
    required this.occurredAt,
    required this.postedAt,
    required this.competenceMonth,
    required this.amountCents,
    required this.currencyCode,
    required this.descriptionRaw,
    required this.displayDescription,
    required this.accountId,
    required this.transferFromAccountId,
    required this.transferToAccountId,
    required this.recurringScheduleId,
    required this.installmentPlanId,
    required this.merchantId,
    required this.categoryId,
    required this.costCenterId,
    required this.payerId,
    required this.appliedRuleId,
    required this.sourceConfidence,
    required this.updatedAt,
    required this.deletedAt,
  });

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
  final String? displayDescription;
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
  final DateTime updatedAt;
  final DateTime? deletedAt;

  factory _RemoteTransactionData.fromJson(Map<String, dynamic> json) {
    return _RemoteTransactionData(
      id: _requiredSyncString(json, 'id'),
      householdId: _requiredSyncString(json, 'householdId'),
      kind: _requiredSyncString(json, 'kind'),
      reviewStatus: _requiredSyncString(json, 'reviewStatus'),
      duplicateStatus: _requiredSyncString(json, 'duplicateStatus'),
      occurredAt: _syncDateTime(json['occurredAt'], 'transaction.occurredAt'),
      postedAt: _syncNullableDateTime(json['postedAt']),
      competenceMonth: _requiredSyncString(json, 'competenceMonth'),
      amountCents: _syncInt(json['amountCents'], 'transaction.amountCents'),
      currencyCode: _requiredSyncString(json, 'currencyCode'),
      descriptionRaw: _requiredSyncString(json, 'descriptionRaw'),
      displayDescription: json['displayDescription'] as String?,
      accountId: json['accountId'] as String?,
      transferFromAccountId: json['transferFromAccountId'] as String?,
      transferToAccountId: json['transferToAccountId'] as String?,
      recurringScheduleId: json['recurringScheduleId'] as String?,
      installmentPlanId: json['installmentPlanId'] as String?,
      merchantId: json['merchantId'] as String?,
      categoryId: json['categoryId'] as String?,
      costCenterId: json['costCenterId'] as String?,
      payerId: json['payerId'] as String?,
      appliedRuleId: json['appliedRuleId'] as String?,
      sourceConfidence: _syncDouble(
        json['sourceConfidence'],
        'transaction.sourceConfidence',
      ),
      updatedAt: _syncDateTime(json['updatedAt'], 'transaction.updatedAt'),
      deletedAt: _syncNullableDateTime(json['deletedAt']),
    );
  }
}

Map<String, dynamic> _syncMap(Object? value, String field) {
  if (value is! Map) {
    throw FormatException('$field deve ser um objeto.');
  }
  return Map<String, dynamic>.from(value);
}

List<Object?> _syncList(Object? value, String field) {
  if (value is! List) {
    throw FormatException('$field deve ser uma lista.');
  }
  return List<Object?>.from(value);
}

String _requiredSyncString(Map<dynamic, dynamic> json, String field) {
  final value = json[field];
  if (value is! String || value.isEmpty) {
    throw FormatException('$field e obrigatorio.');
  }
  return value;
}

int _syncInt(Object? value, String field) {
  if (value is! int) {
    throw FormatException('$field deve ser inteiro.');
  }
  return value;
}

double _syncDouble(Object? value, String field) {
  if (value is! num) {
    throw FormatException('$field deve ser numerico.');
  }
  return value.toDouble();
}

double? _syncNullableDouble(Object? value) =>
    value is num ? value.toDouble() : null;

DateTime _syncDateTime(Object? value, String field) {
  if (value is! String) {
    throw FormatException('$field deve ser data ISO-8601.');
  }
  return DateTime.tryParse(value) ??
      (throw FormatException('$field deve ser data ISO-8601.'));
}

DateTime? _syncNullableDateTime(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

int _syncEventSeq(Map<String, dynamic> event) => _syncInt(event['seq'], 'seq');

int _syncEventBaseVersion(Map<String, dynamic> event) =>
    _syncInt(event['baseVersion'], 'baseVersion');

class _DecodedBackup {
  const _DecodedBackup({
    required this.exportedAt,
    required this.schemaVersion,
    required this.counts,
    required this.people,
    required this.accounts,
    required this.creditCards,
    required this.categories,
    required this.costCenters,
    required this.merchants,
    required this.transactions,
    required this.reviewInbox,
    required this.transactionBeneficiaries,
    required this.transactionSources,
    required this.classificationRules,
    required this.syncOutbox,
    required this.syncAppliedEvents,
    required this.syncConflicts,
    required this.appPreferences,
    required this.authUsers,
    required this.recurringSchedules,
    required this.installmentPlans,
    required this.importBatches,
    required this.stagedSourceRecords,
    required this.duplicateCandidates,
    required this.rawNotificationEvents,
  });

  final DateTime exportedAt;
  final int schemaVersion;
  final Map<String, int> counts;
  final List<PersonRow> people;
  final List<AccountRow> accounts;
  final List<CreditCardRow> creditCards;
  final List<CategoryRow> categories;
  final List<CostCenterRow> costCenters;
  final List<MerchantRow> merchants;
  final List<FinanceTransaction> transactions;
  final List<ReviewInboxRow> reviewInbox;
  final List<TransactionBeneficiaryRow> transactionBeneficiaries;
  final List<TransactionSourceRow> transactionSources;
  final List<ClassificationRuleRow> classificationRules;
  final List<SyncOutboxRow> syncOutbox;
  final List<SyncAppliedEventRow> syncAppliedEvents;
  final List<SyncConflictRow> syncConflicts;
  final List<AppPreferenceRow> appPreferences;
  final List<AuthUserRow> authUsers;
  final List<RecurringScheduleRow> recurringSchedules;
  final List<InstallmentPlanRow> installmentPlans;
  final List<ImportBatchRow> importBatches;
  final List<StagedSourceRecordRow> stagedSourceRecords;
  final List<DuplicateCandidateRow> duplicateCandidates;
  final List<RawNotificationEventRow> rawNotificationEvents;
}

class _ReconciliationMatch {
  const _ReconciliationMatch({
    required this.transactionId,
    required this.score,
    required this.explanation,
  });

  final String transactionId;
  final double score;
  final String explanation;
}

class _PromotedRecordClassification {
  const _PromotedRecordClassification({
    required this.kind,
    required this.accountId,
    required this.reviewReason,
    this.transferFromAccountId,
    this.transferToAccountId,
    this.installmentPlanId,
    this.categoryId,
    this.costCenterId,
  });

  final String kind;
  final String? accountId;
  final String reviewReason;
  final String? transferFromAccountId;
  final String? transferToAccountId;
  final String? installmentPlanId;
  final String? categoryId;
  final String? costCenterId;
}

class _InstallmentHint {
  const _InstallmentHint({
    required this.currentInstallment,
    required this.totalInstallments,
  });

  final int currentInstallment;
  final int totalInstallments;
}
