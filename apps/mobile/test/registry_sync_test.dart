import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zimba_control/src/data/local/app_database.dart';
import 'package:zimba_control/src/infrastructure/api_sync_client.dart';

void main() {
  test('sincroniza cadastros entre dois bancos sem reenviar dados inalterados', () async {
    final deviceA = AppDatabase.forTesting(NativeDatabase.memory());
    final deviceB = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(deviceA.close);
    addTearDown(deviceB.close);
    final server = _RegistrySyncServer();
    const remoteHouseholdId = 'household-web';

    await deviceA.upsertPerson(
      id: 'person-registry-sync',
      displayName: 'Pessoa sincronizada',
      kind: 'adult',
    );
    await deviceA.upsertAccount(
      id: 'account-registry-sync',
      provider: 'manual',
      name: 'Conta sincronizada',
      type: 'checking',
      ownerPersonId: 'person-registry-sync',
    );
    await deviceA.upsertCategory(
      id: 'category-registry-sync',
      name: 'Categoria sincronizada',
      kind: 'expense',
      sortOrder: 10,
    );
    await deviceA.upsertCostCenter(
      id: 'cost-center-registry-sync',
      name: 'Contexto sincronizado',
    );

    final pushed = await deviceA.runSyncOnce(
      _RegistrySyncClient(server),
      remoteHouseholdId: remoteHouseholdId,
    );
    final pulled = await deviceB.runSyncOnce(
      _RegistrySyncClient(server),
      remoteHouseholdId: remoteHouseholdId,
    );

    expect(pushed.pushed, 4);
    expect(pulled.applied, 4);
    final person = await (deviceB.select(deviceB.people)
          ..where((row) => row.id.equals('person-registry-sync')))
        .getSingle();
    final account = await (deviceB.select(deviceB.accounts)
          ..where((row) => row.id.equals('account-registry-sync')))
        .getSingle();
    final category = await (deviceB.select(deviceB.categories)
          ..where((row) => row.id.equals('category-registry-sync')))
        .getSingle();
    expect(person.displayName, 'Pessoa sincronizada');
    expect(account.ownerPersonId, 'person-registry-sync');
    expect(category.name, 'Categoria sincronizada');

    await deviceB.upsertCostCenter(
      id: 'cost-center-registry-sync',
      name: 'Contexto atualizado no segundo aparelho',
    );
    await deviceB.runSyncOnce(
      _RegistrySyncClient(server),
      remoteHouseholdId: remoteHouseholdId,
    );
    final updatePull = await deviceA.runSyncOnce(
      _RegistrySyncClient(server),
      remoteHouseholdId: remoteHouseholdId,
    );

    final updated = await (deviceA.select(deviceA.costCenters)
          ..where((row) => row.id.equals('cost-center-registry-sync')))
        .getSingle();
    expect(updatePull.applied, 1);
    expect(updated.name, 'Contexto atualizado no segundo aparelho');
    expect(
      (await deviceA.runSyncOnce(
        _RegistrySyncClient(server),
        remoteHouseholdId: remoteHouseholdId,
      )).pushed,
      0,
    );
  });
}

class _RegistrySyncClient implements SyncApiClient {
  _RegistrySyncClient(this.server);

  final _RegistrySyncServer server;

  @override
  Future<SyncPullResponse> pull({
    required String householdId,
    required int sinceSeq,
  }) => server.pull(householdId, sinceSeq);

  @override
  Future<SyncPushResponse> push(SyncPushPayload payload) => server.push(payload);
}

class _RegistrySyncServer {
  final _events = <Map<String, dynamic>>[];
  final _acks = <String, SyncOperationAck>{};
  final _versions = <String, int>{};
  var _sequence = 0;

  Future<SyncPushResponse> push(SyncPushPayload payload) async {
    final results = <SyncOperationAck>[];
    for (final operation in payload.operations) {
      final opId = operation['opId'] as String;
      final previous = _acks[opId];
      if (previous != null) {
        results.add(
          SyncOperationAck(
            opId: opId,
            result: 'duplicate',
            entityId: previous.entityId,
            seq: previous.seq,
          ),
        );
        continue;
      }
      final key = [
        operation['householdId'],
        operation['entityType'],
        operation['entityId'],
      ].join(':');
      final expectedVersion = _versions[key] ?? 0;
      final baseVersion = operation['baseVersion'] as int;
      final accepted = operation['operationType'] == 'create'
          ? expectedVersion == 0
          : baseVersion == expectedVersion;
      final ack = SyncOperationAck(
        opId: opId,
        result: accepted ? 'applied' : 'conflict',
        entityId: operation['entityId'] as String,
        seq: ++_sequence,
      );
      _acks[opId] = ack;
      results.add(ack);
      if (accepted) {
        _versions[key] = expectedVersion + 1;
        _events.add({
          ...operation,
          'seq': ack.seq,
          'serverAt': DateTime.utc(2026, 9, 10, 12, 0, _sequence)
              .toIso8601String(),
        });
      }
    }
    return SyncPushResponse(results: results, latestSeq: _sequence);
  }

  Future<SyncPullResponse> pull(String householdId, int sinceSeq) async {
    return SyncPullResponse(
      events: _events
          .where(
            (event) =>
                event['householdId'] == householdId &&
                (event['seq'] as int) > sinceSeq,
          )
          .map(Map<String, dynamic>.from)
          .toList(growable: false),
      latestSeq: _sequence,
    );
  }
}
