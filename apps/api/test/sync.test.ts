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

test("POST /sync/push accepts a versioned credit-limit group payload", async () => {
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
          opId: "op-limit-group-1",
          deviceId: "device-local",
          householdId: "household-main",
          entityType: "creditCardLimitGroup",
          entityId: "limit-group-1",
          operationType: "update",
          baseVersion: 0,
          payload: {
            schemaVersion: 1,
            group: {
              id: "limit-group-1",
              householdId: "household-main",
              name: "Limite compartilhado",
              totalLimitCents: 250000,
              active: true,
            },
          },
          createdAt: "2026-08-30T12:00:00.000Z",
        },
      ],
    },
  });

  assert.equal(response.statusCode, 200);
  assert.equal(response.json().results[0].result, "applied");
  await app.close();
});

test("registry entities are validated and available as household snapshots", async () => {
  const app = buildApp({ config: testConfig() });
  await app.ready();

  const response = await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: {
      deviceId: "device-registry",
      householdId: "household-main",
      operations: [
        registryOperation("person", "person-1", {
          schemaVersion: 1,
          person: { id: "person-1", householdId: "household-main", displayName: "Paulo", kind: "adult", active: true },
        }),
        registryOperation("account", "account-1", {
          schemaVersion: 1,
          account: { id: "account-1", householdId: "household-main", ownerPersonId: "person-1", provider: "nubank", name: "Conta principal", type: "checking", currencyCode: "BRL", last4: "1234", externalAccountId: null, active: true },
        }),
        registryOperation("category", "category-1", {
          schemaVersion: 1,
          category: { id: "category-1", householdId: "household-main", parentId: null, systemKey: null, name: "Alimentação", kind: "expense", iconKey: "cart", colorKey: "amber", sortOrder: 10, isDefault: false, isHidden: false, active: true, createdAt: "2026-09-10T12:00:00.000Z", updatedAt: "2026-09-10T12:00:00.000Z" },
        }),
        registryOperation("costCenter", "center-1", {
          schemaVersion: 1,
          costCenter: { id: "center-1", householdId: "household-main", name: "Casa", iconKey: "home", colorKey: "green", active: true },
        }),
      ],
    },
  });

  assert.equal(response.statusCode, 200);
  assert.deepEqual(response.json().results.map((result: { result: string }) => result.result), ["applied", "applied", "applied", "applied"]);

  const people = await app.inject({ method: "GET", url: "/data/entities?householdId=household-main&entityType=person" });
  assert.equal(people.statusCode, 200);
  assert.equal(people.json().data[0].payload.person.displayName, "Paulo");

  const categories = await app.inject({ method: "GET", url: "/data/entities?householdId=household-main&entityType=category" });
  assert.equal(categories.statusCode, 200);
  assert.equal(categories.json().data[0].payload.category.name, "Alimentação");
  await app.close();
});

test("registry payloads reject invalid fields", async () => {
  const app = buildApp({ config: testConfig() });
  await app.ready();
  const response = await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: {
      deviceId: "device-registry",
      householdId: "household-main",
      operations: [registryOperation("person", "person-invalid", {
        schemaVersion: 1,
        person: { id: "person-invalid", householdId: "household-main", displayName: "", kind: "adult", active: true },
      })],
    },
  });
  assert.equal(response.statusCode, 400);
  assert.equal(response.json().error, "invalid_sync_push");
  await app.close();
});

test("registry payloads cannot target a different entity or household", async () => {
  const app = buildApp({ config: testConfig() });
  await app.ready();
  const response = await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: {
      deviceId: "device-registry",
      householdId: "household-main",
      operations: [registryOperation("person", "person-expected", {
        schemaVersion: 1,
        person: { id: "person-other", householdId: "another-household", displayName: "Paulo", kind: "adult", active: true },
      })],
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

test("password registration creates an isolated admin household and session", async () => {
  const app = buildApp({
    config: testConfig({
      passwordAuthEnabled: true,
      sessionJwtSecret: "test-secret-with-enough-length",
    }),
  });
  await app.ready();

  const first = await app.inject({
    method: "POST",
    url: "/auth/register",
    payload: { email: "admin@zimbacontrol.com.br", password: "123mudar!", name: "Admin" },
  });
  const second = await app.inject({
    method: "POST",
    url: "/auth/register",
    payload: { email: "other@example.com", password: "123mudar!" },
  });

  assert.equal(first.statusCode, 200);
  assert.equal(first.json().user.role, "admin");
  assert.notEqual(first.json().user.householdId, second.json().user.householdId);

  const firstPeople = await app.inject({
    method: "GET",
    url: `/data/entities?householdId=${first.json().user.householdId}&entityType=person`,
    headers: { authorization: `Bearer ${first.json().token}` },
  });
  const secondPeople = await app.inject({
    method: "GET",
    url: `/data/entities?householdId=${second.json().user.householdId}&entityType=person`,
    headers: { authorization: `Bearer ${second.json().token}` },
  });
  assert.equal(firstPeople.json().data.length, 1);
  assert.equal(firstPeople.json().data[0].entityId, `person-${first.json().user.sub}`);
  assert.equal(firstPeople.json().data[0].payload.person.displayName, "admin@zimbacontrol.com.br");
  assert.equal(secondPeople.json().data.length, 1);
  assert.equal(secondPeople.json().data[0].payload.person.displayName, "other@example.com");

  const relogin = await app.inject({
    method: "POST",
    url: "/auth/login",
    payload: { email: "admin@zimbacontrol.com.br", password: "123mudar!" },
  });
  assert.equal(relogin.statusCode, 200);
  const peopleAfterLogin = await app.inject({
    method: "GET",
    url: `/data/entities?householdId=${first.json().user.householdId}&entityType=person`,
    headers: { authorization: `Bearer ${relogin.json().token}` },
  });
  assert.equal(peopleAfterLogin.json().data.length, 1);

  const forbidden = await app.inject({
    method: "GET",
    url: `/sync/pull?householdId=${second.json().user.householdId}&sinceSeq=0`,
    headers: { authorization: `Bearer ${first.json().token}` },
  });
  assert.equal(forbidden.statusCode, 403);
  await app.close();
});

test("authenticated sync forces the account owner and transaction payer to the email owner", async () => {
  const app = buildApp({ config: testConfig({ passwordAuthEnabled: true, sessionJwtSecret: "test-secret-with-enough-length" }) });
  await app.ready();
  const registration = await app.inject({
    method: "POST",
    url: "/auth/register",
    payload: { email: "owner@example.com", password: "123mudar!" },
  });
  const { token, user } = registration.json();
  const householdId = user.householdId as string;
  const ownerId = `person-${user.sub}`;
  const response = await app.inject({
    method: "POST",
    url: "/sync/push",
    headers: { authorization: `Bearer ${token}` },
    payload: {
      deviceId: "web-test",
      householdId,
      operations: [
        {
          ...registryOperation("account", "account-owner", {
            schemaVersion: 1,
            account: { id: "account-owner", householdId, ownerPersonId: null, provider: "manual", name: "Conta", type: "checking", currencyCode: "BRL", last4: null, externalAccountId: null, active: true },
          }),
          householdId,
        },
        {
          ...registryOperation("transaction" as never, "tx-owner", transactionPayload("tx-owner", "Teste", -100)),
          householdId,
        },
      ],
    },
  });
  assert.equal(response.statusCode, 200);
  const account = await app.inject({ method: "GET", url: `/data/entities?householdId=${householdId}&entityType=account`, headers: { authorization: `Bearer ${token}` } });
  const transaction = await app.inject({ method: "GET", url: `/data/entities?householdId=${householdId}&entityType=transaction`, headers: { authorization: `Bearer ${token}` } });
  assert.equal(account.json().data[0].payload.account.ownerPersonId, ownerId);
  assert.equal(transaction.json().data[0].payload.transaction.payerId, ownerId);
  assert.equal(transaction.json().data[0].payload.beneficiaries[0].personId, ownerId);
  await app.close();
});

test("GET /sync/status exposes only devices that wrote to the household", async () => {
  const app = buildApp({ config: testConfig() });
  await app.ready();
  await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: {
      deviceId: "device-mobile",
      householdId: "household-main",
      operations: [{
        opId: "op-status-1",
        deviceId: "device-mobile",
        householdId: "household-main",
        entityType: "transaction",
        entityId: "tx-status",
        operationType: "create",
        baseVersion: 0,
        payload: transactionPayload("tx-status", "Sincronização", -1000),
        createdAt: "2026-09-10T12:00:00.000Z",
      }],
    },
  });

  const status = await app.inject({
    method: "GET",
    url: "/sync/status?householdId=household-main",
  });
  assert.equal(status.statusCode, 200);
  assert.equal(status.json().latestSeq, 1);
  assert.deepEqual(status.json().devices.map((device: { deviceId: string }) => device.deviceId), ["device-mobile"]);

  const missingHousehold = await app.inject({ method: "GET", url: "/sync/status" });
  assert.equal(missingHousehold.statusCode, 400);
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
    corsOrigins: [],
    passwordAuthEnabled: false,
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

function registryOperation(
  entityType: "person" | "account" | "category" | "costCenter",
  entityId: string,
  payload: Record<string, unknown>,
) {
  return {
    opId: `op-${entityType}-${entityId}`,
    deviceId: "device-registry",
    householdId: "household-main",
    entityType,
    entityId,
    operationType: "create",
    baseVersion: 0,
    payload,
    createdAt: "2026-09-10T12:00:00.000Z",
  };
}
