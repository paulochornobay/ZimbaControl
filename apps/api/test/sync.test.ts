import assert from "node:assert/strict";
import { test } from "node:test";
import type { ApiConfig } from "../src/config.js";
import { buildApp } from "../src/app.js";
import type { AuthenticatedUser, GoogleTokenVerifier } from "../src/auth.js";

test("POST /sync/push applies an operation once and treats retry as duplicate", async () => {
  const app = buildApp({ config: testConfig() });
  await app.ready();

  const body = {
    deviceId: "device-local",
    householdId: "household-main",
    operations: [
      {
        opId: "op-1",
        deviceId: "device-local",
        householdId: "household-main",
        entityType: "transaction",
        entityId: "tx-1",
        operationType: "create",
        baseVersion: 0,
        payload: transactionPayload("tx-1", "Mercado Extra", -48732),
        createdAt: "2026-07-28T12:00:00.000Z",
      },
    ],
  };

  const first = await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: body,
  });

  assert.equal(first.statusCode, 200);
  assert.equal(first.json().results[0].result, "applied");

  const second = await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: body,
  });

  assert.equal(second.statusCode, 200);
  assert.equal(second.json().results[0].result, "duplicate");

  await app.close();
});

test("POST /sync/push rejects legacy transaction payloads without a version", async () => {
  const app = buildApp({ config: testConfig() });
  await app.ready();

  const response = await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: {
      deviceId: "device-local",
      householdId: "household-main",
      operations: [
        {
          opId: "op-legacy-payload",
          deviceId: "device-local",
          householdId: "household-main",
          entityType: "transaction",
          entityId: "tx-legacy",
          operationType: "create",
          baseVersion: 0,
          payload: { entityId: "tx-legacy" },
          createdAt: "2026-07-28T12:00:00.000Z",
        },
      ],
    },
  });

  assert.equal(response.statusCode, 400);
  assert.equal(response.json().error, "invalid_sync_push");
  await app.close();
});

test("GET /sync/pull returns incremental events in order", async () => {
  const app = buildApp({ config: testConfig() });
  await app.ready();

  const operations = [
    {
      opId: "op-pull-1",
      deviceId: "device-a",
      householdId: "household-main",
      entityType: "transaction",
      entityId: "tx-1",
      operationType: "create",
      baseVersion: 0,
      payload: transactionPayload("tx-1", "Mercado Extra", -48732),
      createdAt: "2026-07-28T12:00:00.000Z",
    },
    {
      opId: "op-pull-2",
      deviceId: "device-a",
      householdId: "household-main",
      entityType: "transaction",
      entityId: "tx-2",
      operationType: "create",
      baseVersion: 0,
      payload: transactionPayload("tx-2", "Farmacia", -12000),
      createdAt: "2026-07-28T12:05:00.000Z",
    },
  ];

  await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: {
      deviceId: "device-a",
      householdId: "household-main",
      operations,
    },
  });

  const pull = await app.inject({
    method: "GET",
    url: "/sync/pull?householdId=household-main&sinceSeq=1",
  });

  assert.equal(pull.statusCode, 200);
  assert.equal(pull.json().events.length, 1);
  assert.equal(pull.json().events[0].opId, "op-pull-2");
  assert.equal(pull.json().events[0].baseVersion, 0);
  assert.equal(pull.json().latestSeq, 2);

  await app.close();
});

test("POST /sync/push returns conflict when base version is stale", async () => {
  const app = buildApp({ config: testConfig() });
  await app.ready();

  const create = {
    opId: "op-conflict-create",
    deviceId: "device-a",
    householdId: "household-main",
    entityType: "transaction",
    entityId: "tx-conflict",
    operationType: "create",
    baseVersion: 0,
    payload: transactionPayload("tx-conflict", "Valor original", -1000),
    createdAt: "2026-07-28T12:00:00.000Z",
  };
  const staleUpdate = {
    ...create,
    opId: "op-conflict-update",
    deviceId: "device-b",
    operationType: "update",
    baseVersion: 0,
    payload: transactionPayload("tx-conflict", "Valor concorrente", -2000),
  };

  await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: {
      deviceId: "device-a",
      householdId: "household-main",
      operations: [create],
    },
  });
  const conflict = await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: {
      deviceId: "device-b",
      householdId: "household-main",
      operations: [staleUpdate],
    },
  });

  assert.equal(conflict.statusCode, 200);
  assert.equal(conflict.json().results[0].result, "conflict");

  await app.close();
});

test("POST /auth/google creates a session for an allowed email", async () => {
  const app = buildApp({
    config: testConfig({
      googleOidcEnabled: true,
      googleOidcAudience: "web-client-id",
      allowedEmails: ["tester@example.com"],
      sessionJwtSecret: "test-secret-with-enough-length",
    }),
    googleVerifier: new FakeGoogleVerifier({
      sub: "google-sub-1",
      email: "tester@example.com",
      name: "Tester",
    }),
  });
  await app.ready();

  const auth = await app.inject({
    method: "POST",
    url: "/auth/google",
    payload: { idToken: "valid-id-token" },
  });

  assert.equal(auth.statusCode, 200);
  assert.equal(auth.json().user.email, "tester@example.com");
  assert.equal(typeof auth.json().token, "string");

  const sync = await app.inject({
    method: "GET",
    url: "/sync/pull?householdId=household-main&sinceSeq=0",
    headers: { authorization: `Bearer ${auth.json().token}` },
  });

  assert.equal(sync.statusCode, 200);
  await app.close();
});

test("POST /auth/google rejects emails outside the allowlist", async () => {
  const app = buildApp({
    config: testConfig({
      googleOidcEnabled: true,
      googleOidcAudience: "web-client-id",
      allowedEmails: ["allowed@example.com"],
      sessionJwtSecret: "test-secret-with-enough-length",
    }),
    googleVerifier: new FakeGoogleVerifier({
      sub: "google-sub-2",
      email: "blocked@example.com",
    }),
  });
  await app.ready();

  const auth = await app.inject({
    method: "POST",
    url: "/auth/google",
    payload: { idToken: "valid-id-token" },
  });

  assert.equal(auth.statusCode, 403);
  assert.equal(auth.json().error, "email_not_allowed");
  await app.close();
});

test("sync requires a valid session when Google OIDC is enabled", async () => {
  const app = buildApp({
    config: testConfig({
      googleOidcEnabled: true,
      googleOidcAudience: "web-client-id",
      sessionJwtSecret: "test-secret-with-enough-length",
    }),
  });
  await app.ready();

  const sync = await app.inject({
    method: "GET",
    url: "/sync/pull?householdId=household-main&sinceSeq=0",
  });

  assert.equal(sync.statusCode, 401);
  assert.equal(sync.json().error, "missing_session");
  await app.close();
});

function testConfig(overrides: Partial<ApiConfig> = {}): ApiConfig {
  return {
    nodeEnv: "test",
    port: 3333,
    host: "127.0.0.1",
    mongodbDb: "zimbacontrol_test",
    defaultHouseholdId: "household-main",
    allowDevAuth: true,
    googleOidcEnabled: false,
    allowedEmails: [],
    sessionTtlSeconds: 2_592_000,
    ...overrides,
  };
}

class FakeGoogleVerifier implements GoogleTokenVerifier {
  constructor(private readonly user: AuthenticatedUser) {}

  async verify(): Promise<AuthenticatedUser> {
    return this.user;
  }
}

function transactionPayload(id: string, descriptionRaw: string, amountCents: number) {
  return {
    schemaVersion: 1,
    transaction: {
      id,
      householdId: "household-main",
      kind: "expense",
      reviewStatus: "pending",
      duplicateStatus: "none",
      occurredAt: "2026-07-28T12:00:00.000Z",
      postedAt: null,
      competenceMonth: "2026-07",
      amountCents,
      currencyCode: "BRL",
      descriptionRaw,
      accountId: "mp",
      transferFromAccountId: null,
      transferToAccountId: null,
      recurringScheduleId: null,
      installmentPlanId: null,
      merchantId: null,
      categoryId: "alimentacao",
      costCenterId: null,
      payerId: "eu",
      appliedRuleId: null,
      sourceConfidence: 1,
      updatedAt: "2026-07-28T12:00:00.000Z",
      deletedAt: null,
    },
    beneficiaries: [],
    sources: [
      {
        id: `src-${id}`,
        transactionId: id,
        sourceKind: "manual",
        provider: "manual",
        externalId: null,
        fileHash: null,
        rowHash: null,
        notificationKey: null,
        rawPayloadJson: null,
        occurredAt: "2026-07-28T12:00:00.000Z",
        confidence: 1,
      },
    ],
  };
}
