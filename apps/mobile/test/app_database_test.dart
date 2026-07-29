import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/presentation/dashboard_page.dart';

void main() {
  test('formatBrl formats integer cents as Brazilian currency text', () {
    expect(formatBrl(1280000), 'R\$ 12.800,00');
    expect(formatBrl(-48732), '-R\$ 487,32');
  });

  test('seedIfEmpty creates the first offline dashboard records', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final transactions = await database.watchRecentTransactions().first;
    final pending = await database.watchPendingReview().first;
    final people = await database.watchPeople().first;
    final inbox = await database.watchOpenReviewInbox().first;
    final categories = await database.listCategories();
    final costCenters = await database.listCostCenters();

    expect(transactions, hasLength(4));
    expect(pending, hasLength(2));
    expect(people.map((person) => person.displayName), contains('Sofia'));
    expect(inbox, hasLength(2));
    expect(categories.map((category) => category.name), contains('Saude'));
    expect(costCenters.map((center) => center.name), contains('Filhos'));
  });

  test('review actions update local transaction state and outbox', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();
    await database.markProbableDuplicate('tx-mercado');
    await database.confirmTransaction('tx-mercado');

    final transaction = await database.getTransaction('tx-mercado');
    final pending = await database.watchPendingReview().first;
    final inbox = await database.watchOpenReviewInbox().first;

    expect(transaction?.reviewStatus, 'confirmed');
    expect(transaction?.duplicateStatus, 'probable');
    expect(pending.map((tx) => tx.id), isNot(contains('tx-mercado')));
    expect(
      inbox.map((item) => item.transactionId),
      isNot(contains('tx-mercado')),
    );
  });

  test('watchPendingReviewDetails hydrates review metadata', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final details = await database.watchPendingReviewDetails().first;
    final mercado = details.firstWhere(
      (item) => item.transaction.id == 'tx-mercado',
    );

    expect(mercado.displayMerchant, 'Mercado Extra');
    expect(mercado.accountLabel, 'Nubank');
    expect(mercado.categoryLabel, 'Alimentacao');
    expect(mercado.costCenterLabel, 'Casa');
    expect(mercado.sourceLabel, 'Notificacao');
    expect(mercado.providerLabel, 'Nubank');
    expect(
      mercado.beneficiaries.map((person) => person.displayName),
      containsAll(['Voce', 'Marina', 'Sofia', 'Bebe']),
    );
  });

  test('review filter preference is stored locally', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.setReviewFilter('low_confidence');

    expect(await database.watchReviewFilter().first, 'low_confidence');
  });

  test('duplicate and transfer review actions can be undone', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();

    final duplicateSnapshot = await database.captureReviewSnapshot(
      'tx-mercado',
    );
    await database.markDuplicateAndResolve('tx-mercado');

    var mercado = await database.getTransaction('tx-mercado');
    var pending = await database.watchPendingReview().first;

    expect(mercado?.reviewStatus, 'ignored');
    expect(mercado?.duplicateStatus, 'duplicate');
    expect(pending.map((tx) => tx.id), isNot(contains('tx-mercado')));

    await database.restoreReviewSnapshot(duplicateSnapshot!);

    mercado = await database.getTransaction('tx-mercado');
    pending = await database.watchPendingReview().first;

    expect(mercado?.reviewStatus, 'pending');
    expect(mercado?.duplicateStatus, 'none');
    expect(pending.map((tx) => tx.id), contains('tx-mercado'));

    final transferSnapshot = await database.captureReviewSnapshot(
      'tx-farmacia',
    );
    await database.convertToTransfer('tx-farmacia');

    var farmacia = await database.getTransaction('tx-farmacia');

    expect(farmacia?.kind, 'transfer');
    expect(farmacia?.reviewStatus, 'confirmed');
    expect(farmacia?.categoryId, isNull);
    expect(farmacia?.costCenterId, isNull);

    await database.restoreReviewSnapshot(transferSnapshot!);

    farmacia = await database.getTransaction('tx-farmacia');

    expect(farmacia?.kind, 'expense');
    expect(farmacia?.reviewStatus, 'pending');
    expect(farmacia?.categoryId, 'saude');
    expect(farmacia?.costCenterId, 'filhos');
  });

  test('updateTransactionCore edits the local canonical transaction', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await database.seedIfEmpty();
    await database.updateTransactionCore(
      id: 'tx-farmacia',
      description: 'Farmacia editada',
      amountCents: -12000,
      kind: 'expense',
      categoryId: 'saude',
      costCenterId: 'pessoal',
    );

    final transaction = await database.getTransaction('tx-farmacia');

    expect(transaction?.descriptionRaw, 'Farmacia editada');
    expect(transaction?.amountCents, -12000);
    expect(transaction?.costCenterId, 'pessoal');
  });
}
