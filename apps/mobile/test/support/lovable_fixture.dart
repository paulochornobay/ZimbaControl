import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:zimba_control/src/data/local/app_database.dart';

/// Deterministic representation of `pixel-perfect-pixels/src/lib/mock-data.ts`.
/// It is deliberately test-only: production onboarding keeps its own local data.
final lovableReferenceDate = DateTime(2026, 8, 16, 12);

Future<AppDatabase> openLovableTestDatabase() async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  await seedLovableFixture(database);
  return database;
}

Future<void> seedLovableFixture(AppDatabase database) async {
  const household = AppDatabase.householdMain;
  final august = DateTime(2026, 8, 5, 12);

  final people = [
    PeopleCompanion.insert(
      id: 'eu',
      householdId: household,
      displayName: 'Paulo',
      kind: 'adult',
    ),
    PeopleCompanion.insert(
      id: 'marina',
      householdId: household,
      displayName: 'Marina',
      kind: 'adult',
    ),
    PeopleCompanion.insert(
      id: 'sofia',
      householdId: household,
      displayName: 'Sofia',
      kind: 'child',
    ),
    PeopleCompanion.insert(
      id: 'bebe',
      householdId: household,
      displayName: 'Liz',
      kind: 'child',
    ),
  ];
  final accounts = [
    _account('mp', 'Mercado Pago', 'mercado_pago', 'eu'),
    _account('nu', 'Nubank Crédito', 'nubank', 'eu', type: 'credit_card'),
    _account('mp-marina', 'Mercado Pago Marina', 'mercado_pago', 'marina'),
    _account(
      'nu-marina',
      'Nubank Marina',
      'nubank',
      'marina',
      type: 'credit_card',
    ),
    _account('caixa', 'Caixa Poupança', 'caixa', 'eu'),
  ];
  final categories = [
    _category('mercado', 'Mercado', 'expense', 10),
    _category('saude', 'Saúde', 'expense', 20),
    _category('educacao', 'Educação', 'expense', 30),
    _category('transporte', 'Transporte', 'expense', 40),
    _category('lazer', 'Lazer', 'expense', 50),
    _category('casa', 'Casa', 'expense', 60),
    _category('eletronicos', 'Eletrônicos', 'expense', 70),
    _category('renda', 'Renda', 'income', 80),
    _category('transferencia', 'Transferência', 'transfer', 90),
  ];
  final centers = [
    _center('casa', 'Casa'),
    _center('filhos', 'Filhos'),
    _center('pessoal', 'Pessoal'),
    _center('carro', 'Carro'),
    _center('trabalho', 'Trabalho'),
  ];

  final movements = <TransactionsCompanion>[
    _transaction(
      'm1',
      'income',
      1280000,
      'Salário',
      august,
      'mp',
      'renda',
      'trabalho',
      'eu',
    ),
    _transaction(
      'm2',
      'income',
      640000,
      'Salário Marina',
      august,
      'mp-marina',
      'renda',
      'trabalho',
      'marina',
    ),
    _transaction(
      'm3',
      'expense',
      -320000,
      'Aluguel',
      august,
      'mp',
      'casa',
      'casa',
      'eu',
    ),
    _transaction(
      'm4',
      'transfer',
      -221055,
      'Pagamento fatura Nubank (jul)',
      august,
      'mp',
      'transferencia',
      null,
      'eu',
      transferTo: 'nu',
    ),
    _transaction(
      'm5',
      'expense',
      -38912,
      'Enel Energia',
      DateTime(2026, 8, 7, 12),
      'mp',
      'casa',
      'casa',
      'eu',
    ),
    _transaction(
      'm6',
      'expense',
      -5590,
      'Netflix',
      DateTime(2026, 8, 8, 12),
      'nu',
      'lazer',
      'casa',
      'eu',
    ),
    _transaction(
      'm7',
      'expense',
      -2450,
      'Uber',
      DateTime(2026, 8, 15, 22, 15),
      'nu',
      'transporte',
      'pessoal',
      'marina',
    ),
    _transaction(
      'm8',
      'expense',
      -14270,
      'Drogasil',
      DateTime(2026, 8, 11, 12),
      'nu',
      'saude',
      'filhos',
      'eu',
    ),
    _transaction(
      'm9',
      'expense',
      -1235,
      'Ajuste de saldo Mercado Pago',
      DateTime(2026, 8, 1, 12),
      'mp',
      'casa',
      'pessoal',
      'eu',
    ),
    _transaction(
      'transfer-internal',
      'transfer',
      -113945,
      'Transferência interna',
      DateTime(2026, 8, 6, 12),
      'mp',
      'transferencia',
      null,
      'eu',
      transferTo: 'mp-marina',
    ),
    _transaction(
      'pensao-agosto',
      'income',
      140000,
      'Pensão recebida',
      DateTime(2026, 8, 13, 12),
      'mp-marina',
      'renda',
      'filhos',
      'marina',
    ),
  ];
  const pendingRows = [
    ('Mercado Extra', -30000, 'mercado', 'casa', 'eu'),
    ('Farmácia Pague Menos', -11028, 'mercado', 'casa', 'eu'),
    ('Transporte pendente', -118110, 'transporte', 'carro', 'marina'),
    ('Educação pendente', -117860, 'educacao', 'pessoal', 'marina'),
    ('Mercado da Sofia', -107704, 'mercado', 'filhos', 'sofia'),
    ('Curso da Sofia', -11140, 'educacao', 'filhos', 'sofia'),
    ('Saúde da Sofia', -48990, 'saude', 'filhos', 'sofia'),
    ('Lazer da Sofia', -47006, 'lazer', 'casa', 'sofia'),
    ('Casa da Liz', -11755, 'casa', 'filhos', 'bebe'),
    ('Lazer da Liz', -20981, 'lazer', 'filhos', 'bebe'),
    ('Lazer da Liz', -7057, 'lazer', 'pessoal', 'bebe'),
    ('Lazer da Liz', -4374, 'lazer', 'casa', 'bebe'),
  ];
  for (var index = 0; index < pendingRows.length; index++) {
    final row = pendingRows[index];
    movements.add(
      _transaction(
        'r${index + 1}',
        'expense',
        row.$2,
        row.$1,
        DateTime(2026, 8, 16, 10, index),
        'nu',
        row.$3,
        row.$4,
        row.$5,
        reviewStatus: 'pending',
      ),
    );
  }

  await database.batch((batch) {
    batch.insertAll(database.people, people);
    batch.insertAll(database.accounts, accounts);
    batch.insertAll(database.creditCards, [
      CreditCardsCompanion.insert(
        id: 'nu-card',
        householdId: household,
        accountId: const Value('nu'),
        ownerPersonId: const Value('eu'),
        provider: 'nubank',
        name: 'Nubank Crédito',
      ),
      CreditCardsCompanion.insert(
        id: 'nu-marina-card',
        householdId: household,
        accountId: const Value('nu-marina'),
        ownerPersonId: const Value('marina'),
        provider: 'nubank',
        name: 'Nubank Marina',
      ),
    ]);
    batch.insertAll(database.categories, categories);
    batch.insertAll(database.costCenters, centers);
    batch.insertAll(database.merchants, [
      for (final tx in movements)
        _merchant(
          tx.id.value,
          tx.displayDescription.value as String,
          tx.displayDescription.value as String,
        ),
    ]);
    batch.insertAll(database.transactions, movements);
    batch.insertAll(database.transactionBeneficiaries, [
      for (final tx in movements)
        _beneficiary(tx.id.value, tx.payerId.value ?? 'eu'),
    ]);
    batch.insertAll(database.transactionSources, [
      for (var index = 0; index < movements.length; index++)
        _source(
          'source-${movements[index].id.value}',
          movements[index].id.value,
          _sourceKind(index),
          movements[index].occurredAt.value,
        ),
    ]);
    batch.insertAll(database.reviewInbox, [
      for (var index = 0; index < pendingRows.length; index++)
        ReviewInboxCompanion.insert(
          id: 'review-r${index + 1}',
          householdId: household,
          transactionId: 'r${index + 1}',
          reason: 'needs_user_confirmation',
          createdAt: lovableReferenceDate,
        ),
    ]);
    batch.insertAll(database.recurringSchedules, [
      _schedule(
        'rec-escola',
        'Escola Sofia',
        'expense',
        -129000,
        10,
        'mp',
        'sofia',
        'educacao',
        'filhos',
      ),
      _schedule(
        'rec-pensao',
        'Pensão recebida',
        'income',
        140000,
        13,
        'mp-marina',
        'sofia',
        'renda',
        'filhos',
      ),
      _schedule(
        'rec-ajuda',
        'Ajuda familiar',
        'expense',
        -60000,
        8,
        'mp',
        'eu',
        'casa',
        'casa',
      ),
      _schedule(
        'rec-aluguel',
        'Aluguel',
        'expense',
        -320000,
        5,
        'mp',
        'eu',
        'casa',
        'casa',
      ),
      _schedule(
        'rec-internet',
        'Internet Vivo Fibra',
        'expense',
        -12990,
        18,
        'mp',
        'eu',
        'casa',
        'casa',
      ),
    ]);
    batch.insertAll(database.installmentPlans, [
      _plan(
        'plan-consorcio',
        'Consórcio Carro',
        'vehicle_consortium',
        96870,
        46,
        72,
        12,
        'transporte',
        'carro',
      ),
      _plan(
        'plan-iphone',
        'iPhone 15 —',
        'installment',
        62490,
        5,
        12,
        14,
        'eletronicos',
        'pessoal',
      ),
    ]);
  });
}

AccountsCompanion _account(
  String id,
  String name,
  String provider,
  String owner, {
  String type = 'account',
}) => AccountsCompanion.insert(
  id: id,
  householdId: AppDatabase.householdMain,
  ownerPersonId: Value(owner),
  provider: provider,
  name: name,
  type: type,
);

CategoriesCompanion _category(String id, String name, String kind, int order) =>
    CategoriesCompanion.insert(
      id: id,
      householdId: AppDatabase.householdMain,
      name: name,
      kind: kind,
      sortOrder: Value(order),
    );

CostCentersCompanion _center(String id, String name) =>
    CostCentersCompanion.insert(
      id: id,
      householdId: AppDatabase.householdMain,
      name: name,
    );

MerchantsCompanion _merchant(String id, String normalized, String label) =>
    MerchantsCompanion.insert(
      id: id,
      householdId: AppDatabase.householdMain,
      normalizedName: normalized.toLowerCase(),
      displayName: label,
    );

TransactionsCompanion _transaction(
  String id,
  String kind,
  int amount,
  String description,
  DateTime at,
  String account,
  String? category,
  String? center,
  String payer, {
  String reviewStatus = 'confirmed',
  String? transferTo,
}) => TransactionsCompanion.insert(
  id: id,
  householdId: AppDatabase.householdMain,
  kind: kind,
  reviewStatus: reviewStatus,
  duplicateStatus: 'none',
  occurredAt: at,
  competenceMonth: '2026-08',
  amountCents: amount,
  descriptionRaw: description,
  displayDescription: Value(description),
  accountId: Value(account),
  transferFromAccountId: Value(kind == 'transfer' ? account : null),
  transferToAccountId: Value(transferTo),
  merchantId: Value(id),
  categoryId: Value(category),
  costCenterId: Value(center),
  payerId: Value(payer),
  sourceConfidence: const Value(1),
  updatedAt: at,
);

TransactionBeneficiariesCompanion _beneficiary(
  String transactionId,
  String personId,
) => TransactionBeneficiariesCompanion.insert(
  id: 'beneficiary-$transactionId-$personId',
  transactionId: transactionId,
  personId: personId,
  isPrimary: const Value(true),
);

TransactionSourcesCompanion _source(
  String id,
  String transactionId,
  String kind,
  DateTime at,
) => TransactionSourcesCompanion.insert(
  id: id,
  transactionId: transactionId,
  sourceKind: kind,
  provider: kind == 'notification' ? 'nubank' : 'zimba_control',
  occurredAt: Value(at),
  confidence: const Value(1),
);

String _sourceKind(int index) => switch (index % 4) {
  0 => 'notification',
  1 => 'csv',
  2 => 'ofx',
  _ => 'manual',
};

RecurringSchedulesCompanion _schedule(
  String id,
  String label,
  String kind,
  int amount,
  int day,
  String account,
  String beneficiary,
  String category,
  String center,
) => RecurringSchedulesCompanion.insert(
  id: id,
  householdId: AppDatabase.householdMain,
  label: label,
  kind: kind,
  amountCents: amount,
  dayOfMonth: day,
  startMonth: '2026-08',
  beneficiaryPersonId: Value(beneficiary),
  fromAccountId: Value(kind == 'expense' ? account : null),
  toAccountId: Value(kind == 'income' ? account : null),
  categoryId: Value(category),
  costCenterId: Value(center),
  updatedAt: lovableReferenceDate,
);

InstallmentPlansCompanion _plan(
  String id,
  String label,
  String kind,
  int amount,
  int current,
  int total,
  int dueDay,
  String category,
  String center,
) => InstallmentPlansCompanion.insert(
  id: id,
  householdId: AppDatabase.householdMain,
  label: label,
  planKind: kind,
  installmentAmountCents: amount,
  currentInstallment: current,
  totalInstallments: total,
  dueDay: Value(dueDay),
  startMonth: '2026-08',
  categoryId: Value(category),
  costCenterId: Value(center),
  updatedAt: lovableReferenceDate,
);
