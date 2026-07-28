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

    expect(transactions, hasLength(4));
    expect(pending, hasLength(2));
    expect(people.map((person) => person.displayName), contains('Sofia'));
  });
}
