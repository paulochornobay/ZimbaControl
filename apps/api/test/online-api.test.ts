import assert from "node:assert/strict";
import { test } from "node:test";
import type { AuthenticatedUser, GoogleTokenVerifier } from "../src/auth.js";
import { buildApp } from "../src/app.js";
import type { ApiConfig } from "../src/config.js";

test("legacy sync routes are unavailable even in the test environment", async () => {
  const app = buildApp({ config: testConfig() });
  await app.ready();
  for (const route of ["/sync/push", "/sync/pull", "/sync/status", "/data/entities"]) {
    const response = await app.inject({ method: route === "/sync/push" ? "POST" : "GET", url: route });
    assert.equal(response.statusCode, 410);
    assert.equal(response.json().error, "legacy_route_removed_use_v1");
  }
  await app.close();
});

test("the bearer account scopes bootstrap, writes, reads and notification resolution", async () => {
  const app = buildApp({ config: authenticatedConfig() });
  await app.ready();
  const first = await register(app, "first@example.com");
  const second = await register(app, "second@example.com");
  const firstHeaders = bearer(first.token);
  const secondHeaders = bearer(second.token);

  const bootstrap = await app.inject({ method: "GET", url: "/v1/bootstrap", headers: firstHeaders });
  assert.equal(bootstrap.statusCode, 200);
  assert.equal(bootstrap.json().entities.transaction.length, 0);
  assert.equal(bootstrap.json().entities.category.length, 5);

  const write = await app.inject({
    method: "PUT", url: "/v1/entities/category/category-private", headers: firstHeaders,
    payload: {
      baseVersion: 0,
      payload: { schemaVersion: 1, category: categoryPayload("category-private", second.user.accountId) },
    },
  });
  assert.equal(write.statusCode, 200);
  const firstCategories = await app.inject({ method: "GET", url: "/v1/entities/category", headers: firstHeaders });
  const secondCategories = await app.inject({ method: "GET", url: "/v1/entities/category", headers: secondHeaders });
  assert.equal(firstCategories.json().data.some((row: { entityId: string }) => row.entityId === "category-private"), true);
  assert.equal(secondCategories.json().data.some((row: { entityId: string }) => row.entityId === "category-private"), false);
  const foreignUpdate = await app.inject({
    method: "PUT", url: "/v1/entities/category/category-private", headers: secondHeaders,
    payload: { baseVersion: 1, payload: { schemaVersion: 1, category: categoryPayload("category-private", first.user.accountId) } },
  });
  assert.equal(foreignUpdate.statusCode, 404);

  const batch = await app.inject({
    method: "POST", url: "/notification-events/batch", headers: firstHeaders,
    payload: { events: [{ id: "android-key-1", packageName: "com.bank", postedAt: 1, capturedAt: 2, text: "Compra" }] },
  });
  assert.equal(batch.statusCode, 200);
  const forbidden = await app.inject({ method: "POST", url: "/notification-events/android-key-1/resolve", headers: secondHeaders });
  assert.equal(forbidden.statusCode, 404);
  const resolved = await app.inject({ method: "POST", url: "/notification-events/android-key-1/resolve", headers: firstHeaders });
  assert.equal(resolved.statusCode, 200);
  await app.close();
});

test("the account owner can rename their profile without authentication restoring the email", async () => {
  const app = buildApp({ config: authenticatedConfig() });
  await app.ready();
  const session = await register(app, "owner-name@example.com");
  const headers = bearer(session.token);
  const people = await app.inject({ method: "GET", url: "/v1/entities/person", headers });
  const initial = (people.json().data as Array<{
    entityId: string; baseVersion: number; payload: { person: { relationship?: string } };
  }>).find((row) => row.payload.person.relationship === "self")!;
  const ownerId = initial.entityId;

  const renamed = await app.inject({
    method: "PUT", url: `/v1/entities/person/${ownerId}`, headers,
    payload: {
      baseVersion: initial.baseVersion,
      payload: {
        schemaVersion: 1,
        person: {
          id: ownerId, householdId: "client-supplied-scope", displayName: "Paulo", kind: "adult",
          relationship: "self", active: true,
        },
      },
    },
  });
  assert.equal(renamed.statusCode, 200);
  assert.equal(renamed.json().result, "applied");

  // Every authenticated request reconciles the owner profile. It must retain the chosen name.
  const bootstrap = await app.inject({ method: "GET", url: "/v1/bootstrap", headers });
  const owner = bootstrap.json().entities.person.find((row: { entityId: string }) => row.entityId === ownerId);
  assert.equal(owner.payload.person.displayName, "Paulo");
  assert.equal(owner.payload.person.relationship, "self");
  await app.close();
});

test("default category labels with legacy mojibake are repaired without affecting custom labels", async () => {
  const app = buildApp({ config: authenticatedConfig() });
  await app.ready();
  const session = await register(app, "catalog-repair@example.com");
  const headers = bearer(session.token);
  const categories = await app.inject({ method: "GET", url: "/v1/entities/category", headers });
  const malformed = (categories.json().data as Array<{
    entityId: string; baseVersion: number; payload: { category: Record<string, unknown> };
  }>).find((row) => row.entityId === "category-system-alimentacao")!;
  const write = await app.inject({
    method: "PUT", url: `/v1/entities/category/${malformed.entityId}`, headers,
    payload: {
      baseVersion: malformed.baseVersion,
      payload: {
        ...malformed.payload,
        category: { ...malformed.payload.category, name: "Alimenta\u00c3\u00a7\u00c3\u00a3o" },
      },
    },
  });
  assert.equal(write.statusCode, 200);

  const bootstrap = await app.inject({ method: "GET", url: "/v1/bootstrap", headers });
  const repaired = bootstrap.json().entities.category.find((row: { entityId: string }) => row.entityId === malformed.entityId);
  assert.equal(repaired.payload.category.name, "Alimenta\u00e7\u00e3o");
  await app.close();
});

test("transactions, reports and backups persist only for the authenticated account", async () => {
  const app = buildApp({ config: authenticatedConfig() });
  await app.ready();
  const owner = await register(app, "report@example.com");
  const headers = bearer(owner.token);
  const payload = transactionPayload("tx-online", "Compra online", -1250);
  payload.transaction.reviewStatus = "confirmed";
  const created = await app.inject({
    method: "POST", url: "/v1/transactions", headers,
    payload: { id: "tx-online", payload },
  });
  assert.equal(created.statusCode, 200);
  const monthly = await app.inject({ method: "GET", url: "/v1/reports/monthly?month=2026-07", headers });
  assert.equal(monthly.json().expenseCents, -1250);
  const exported = await app.inject({ method: "GET", url: "/v1/backups/export", headers });
  assert.equal(exported.json().entities.transaction.length, 1);

  const other = await register(app, "other-report@example.com");
  const otherHeaders = bearer(other.token);
  const foreignRead = await app.inject({ method: "GET", url: "/v1/transactions", headers: otherHeaders });
  const foreignBackup = await app.inject({ method: "GET", url: "/v1/backups/export", headers: otherHeaders });
  assert.deepEqual(foreignRead.json().data, []);
  assert.deepEqual(foreignBackup.json().entities.transaction, []);

  const foreignWrite = await app.inject({
    method: "PATCH", url: "/v1/transactions/tx-online", headers: otherHeaders,
    payload: { baseVersion: 1, payload: transactionPayload("tx-online", "Tentativa", -1) },
  });
  assert.equal(foreignWrite.statusCode, 404);
  await app.close();
});

test("imports and their review and duplicate decisions are server-side and isolated", async () => {
  const app = buildApp({ config: authenticatedConfig() });
  await app.ready();
  const owner = await register(app, "import@example.com");
  const headers = bearer(owner.token);
  const payload = { fileName: "nubank.csv", content: "Data;Descricao;Valor;Identificador;Account Number\n01/08/2026;Assinatura;-12,34;csv-1;account-123" };
  const first = await app.inject({ method: "POST", url: "/v1/imports", headers, payload });
  const second = await app.inject({ method: "POST", url: "/v1/imports", headers, payload });
  assert.equal(first.json().createdTransactions, 1);
  assert.equal(second.json().createdTransactions, 1);
  assert.equal(first.json().accountId, second.json().accountId);
  const accounts = await app.inject({ method: "GET", url: "/v1/entities/account", headers });
  assert.equal(accounts.json().data.length, 1);
  assert.equal(accounts.json().data[0].payload.account.externalAccountId, "account-123");
  const transactions = await app.inject({ method: "GET", url: "/v1/transactions", headers });
  const rows = transactions.json().data as Array<{ entityId: string; payload: { transaction: { duplicateStatus: string } } }>;
  const regular = rows.find((row) => row.payload.transaction.duplicateStatus === "none")!;
  const duplicate = rows.find((row) => row.payload.transaction.duplicateStatus === "probable")!;
  assert.equal((await app.inject({ method: "POST", url: `/v1/reviews/${regular.entityId}/resolve`, headers, payload: { decision: "confirmed" } })).statusCode, 200);
  assert.equal((await app.inject({ method: "POST", url: `/v1/duplicates/${duplicate.entityId}/resolve`, headers, payload: { decision: "duplicate" } })).statusCode, 200);

  const installmentAugust = { fileName: "card-aug.csv", content: "Data;Descricao;Valor;Identificador\n01/08/2026;Crocs - Parcela 3/10;-56,81;reused-fitid" };
  const installmentSeptember = { fileName: "card-sep.csv", content: "Data;Descricao;Valor;Identificador\n01/09/2026;Crocs - Parcela 4/10;-56,81;reused-fitid" };
  assert.equal((await app.inject({ method: "POST", url: "/v1/imports", headers, payload: installmentAugust })).json().createdTransactions, 1);
  assert.equal((await app.inject({ method: "POST", url: "/v1/imports", headers, payload: installmentSeptember })).json().createdTransactions, 1);
  const installments = (await app.inject({ method: "GET", url: "/v1/transactions", headers })).json().data as Array<{ payload: { transaction: { descriptionRaw: string; duplicateStatus: string } } }>;
  assert.ok(installments.filter((row) => row.payload.transaction.descriptionRaw.startsWith("Crocs - Parcela")).every((row) => row.payload.transaction.duplicateStatus === "none"));

  const other = await register(app, "import-other@example.com");
  const foreignImports = await app.inject({ method: "GET", url: "/v1/entities/importBatch", headers: bearer(other.token) });
  assert.deepEqual(foreignImports.json().data, []);
  await app.close();
});

test("password and Google identities resolve to one normalized email account", async () => {
  const app = buildApp({
    config: authenticatedConfig({ googleOidcEnabled: true, googleOidcAudience: "web" }),
    googleVerifier: new FakeGoogleVerifier({ sub: "google-normalized", email: "Pessoa@Example.com", name: "Pessoa" }),
  });
  await app.ready();
  const password = await register(app, "pessoa@example.com");
  const google = await app.inject({ method: "POST", url: "/auth/google", payload: { idToken: "valid" } });
  assert.equal(google.statusCode, 200);
  assert.equal(google.json().user.accountId, password.user.accountId);
  await app.close();
});

async function register(app: ReturnType<typeof buildApp>, email: string) {
  const response = await app.inject({ method: "POST", url: "/auth/register", payload: { email, password: "123mudar!" } });
  assert.equal(response.statusCode, 200);
  return response.json() as { token: string; user: { accountId: string } };
}

function bearer(token: string) {
  return { authorization: `Bearer ${token}` };
}

function authenticatedConfig(overrides: Partial<ApiConfig> = {}): ApiConfig {
  return testConfig({ passwordAuthEnabled: true, sessionJwtSecret: "test-secret-with-enough-length", ...overrides });
}

function testConfig(overrides: Partial<ApiConfig> = {}): ApiConfig {
  return {
    nodeEnv: "test", port: 3333, host: "127.0.0.1", mongodbDb: "zimbacontrol_test",
    googleOidcEnabled: false, allowedEmails: [], sessionTtlSeconds: 2_592_000,
    corsOrigins: [], passwordAuthEnabled: false, ...overrides,
  };
}

class FakeGoogleVerifier implements GoogleTokenVerifier {
  constructor(private readonly user: AuthenticatedUser) {}
  async verify(): Promise<AuthenticatedUser> { return this.user; }
}

function categoryPayload(id: string, suppliedAccountId: string) {
  return {
    id, householdId: suppliedAccountId, parentId: null, systemKey: null, name: "Privada",
    kind: "expense", iconKey: "tag", colorKey: "slate", sortOrder: 99,
    isDefault: false, isHidden: false, active: true,
    createdAt: "2026-09-15T00:00:00.000Z", updatedAt: "2026-09-15T00:00:00.000Z",
  };
}

function transactionPayload(id: string, descriptionRaw: string, amountCents: number) {
  return {
    schemaVersion: 1,
    transaction: {
      id, householdId: "client-supplied-scope", kind: "expense", reviewStatus: "pending", duplicateStatus: "none",
      occurredAt: "2026-07-28T12:00:00.000Z", postedAt: null, competenceMonth: "2026-07", amountCents,
      currencyCode: "BRL", descriptionRaw, accountId: null, transferFromAccountId: null, transferToAccountId: null,
      recurringScheduleId: null, installmentPlanId: null, merchantId: null, categoryId: null, costCenterId: null,
      payerId: null, appliedRuleId: null, sourceConfidence: 1, updatedAt: "2026-07-28T12:00:00.000Z", deletedAt: null,
    },
    beneficiaries: [], sources: [],
  };
}
