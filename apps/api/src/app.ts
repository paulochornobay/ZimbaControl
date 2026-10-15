import cors from "@fastify/cors";
import Fastify, { type FastifyReply, type FastifyRequest } from "fastify";
import { MongoClient } from "mongodb";
import { randomUUID } from "node:crypto";
import {
  AuthError,
  ensureAllowedEmail,
  GoogleOidcVerifier,
  type AuthenticatedUser,
  type GoogleTokenVerifier,
  SessionService,
} from "./auth.js";
import { loadConfig, type ApiConfig } from "./config.js";
import {
  googleAuthRequestSchema,
  passwordAuthRequestSchema,
  syncEntityTypeSchema,
  syncPushOperationSchema,
  type SyncPushOperation,
} from "./contracts.js";
import {
  MemorySyncStore,
  MongoSyncStore,
  ownerPersonId,
  type SyncPushResult,
  type SyncStore,
} from "./sync-store.js";
import {
  IdentityError,
  MemoryIdentityStore,
  MongoIdentityStore,
  type IdentityStore,
} from "./identity-store.js";
import {
  MemoryNotificationStore,
  MongoNotificationStore,
  type NotificationStore,
} from "./notification-store.js";
import { parseStatement } from "./statement-import.js";

type BuildAppOptions = {
  config?: ApiConfig;
  syncStore?: SyncStore;
  googleVerifier?: GoogleTokenVerifier;
  identityStore?: IdentityStore;
  notificationStore?: NotificationStore;
};

export function buildApp(options: BuildAppOptions = {}) {
  const config = options.config ?? loadConfig();
  const syncStore =
    options.syncStore ??
    (config.mongodbUri
      ? new MongoSyncStore(new MongoClient(config.mongodbUri), config.mongodbDb)
      : new MemorySyncStore());
  const googleVerifier = options.googleVerifier ?? new GoogleOidcVerifier();
  const identityStore =
    options.identityStore ??
    (config.mongodbUri
      ? new MongoIdentityStore(new MongoClient(config.mongodbUri), config.mongodbDb)
      : new MemoryIdentityStore());
  const notificationStore =
    options.notificationStore ??
    (config.mongodbUri
      ? new MongoNotificationStore(new MongoClient(config.mongodbUri), config.mongodbDb)
      : new MemoryNotificationStore());
  const sessionService = new SessionService(config);
  const storageMode = config.mongodbUri ? "mongodb" : "memory";
  const app = Fastify({
    logger: true,
  });

  app.register(cors, {
    origin:
      (config.corsOrigins?.length ?? 0) === 0 ? false : config.corsOrigins,
    credentials: true,
    methods: ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  });

  app.addHook("onReady", async () => {
    await syncStore.init();
    await identityStore.init();
    await notificationStore.init();
    if (config.nodeEnv === "development" && config.devAdminEmail && config.devAdminPassword) {
      await identityStore.ensureAdmin({
        email: config.devAdminEmail,
        password: config.devAdminPassword,
        name: "Administrador ZimbaControl",
      });
    }
  });

  app.addHook("onClose", async () => {
    await syncStore.close();
    await identityStore.close();
    await notificationStore.close();
  });

  app.get("/health", async () => ({
    ok: true,
    service: "zimbacontrol-api",
    storage: storageMode,
  }));

  app.post("/auth/google", async (request, reply) => {
    if (!config.googleOidcEnabled) {
      return reply.code(400).send({ error: "google_oidc_disabled" });
    }
    if (!config.googleOidcAudience) {
      return reply.code(500).send({ error: "google_audience_not_configured" });
    }

    const parsed = googleAuthRequestSchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.code(400).send({
        error: "invalid_google_auth",
        issues: parsed.error.issues,
      });
    }

    try {
      const googleUser = await googleVerifier.verify(
        parsed.data.idToken,
        config.googleOidcAudience,
      );
      ensureAllowedEmail(config, googleUser.email);
      const identity = await identityStore.resolveGoogleIdentity({
        email: googleUser.email,
        name: googleUser.name,
      });
      return sessionResponse(identity);
    } catch (error) {
      if (error instanceof AuthError) {
        return reply.code(error.statusCode).send({ error: error.message });
      }
      request.log.warn({ error }, "google auth failed");
      return reply.code(401).send({ error: "invalid_google_token" });
    }
  });

  app.post("/auth/register", async (request, reply) => {
    if (!config.passwordAuthEnabled) {
      return reply.code(400).send({ error: "password_auth_disabled" });
    }
    const parsed = passwordAuthRequestSchema.safeParse(request.body);
    if (!parsed.success) return reply.code(400).send({ error: "invalid_registration" });
    try {
      const user = await identityStore.register(parsed.data);
      return sessionResponse(user);
    } catch (error) {
      if (error instanceof IdentityError) {
        return reply.code(409).send({ error: error.message });
      }
      throw error;
    }
  });

  app.post("/auth/login", async (request, reply) => {
    if (!config.passwordAuthEnabled) {
      return reply.code(400).send({ error: "password_auth_disabled" });
    }
    const parsed = passwordAuthRequestSchema.pick({ email: true, password: true }).safeParse(request.body);
    if (!parsed.success) return reply.code(400).send({ error: "invalid_credentials" });
    try {
      return sessionResponse(await identityStore.authenticate(parsed.data.email, parsed.data.password));
    } catch (error) {
      if (error instanceof IdentityError) return reply.code(401).send({ error: error.message });
      throw error;
    }
  });

  app.get("/v1/bootstrap", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const entities = await Promise.all(syncEntityTypeSchema.options.map(async (entityType) => [
      entityType,
      await syncStore.listEntitySnapshots(user.householdId!, entityType),
    ] as const));
    return { user: publicAccountUser(user), entities: Object.fromEntries(entities) };
  });

  app.get("/v1/entities/:entityType", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const entityType = syncEntityTypeSchema.safeParse((request.params as { entityType?: string }).entityType);
    if (!entityType.success) return reply.code(400).send({ error: "invalid_entity_type" });
    return { data: await syncStore.listEntitySnapshots(user.householdId!, entityType.data) };
  });

  app.put("/v1/entities/:entityType/:entityId", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const params = request.params as { entityType?: string; entityId?: string };
    const entityType = syncEntityTypeSchema.safeParse(params.entityType);
    if (!entityType.success || !params.entityId) return reply.code(400).send({ error: "invalid_entity" });
    const body = request.body as { payload?: Record<string, unknown>; baseVersion?: number } | undefined;
    if (!body?.payload || typeof body.baseVersion !== "number" || !Number.isInteger(body.baseVersion) || body.baseVersion < 0) {
      return reply.code(400).send({ error: "invalid_entity_write" });
    }
    const baseVersion = body.baseVersion as number;
    const existing = (await syncStore.listEntitySnapshots(user.householdId!, entityType.data))
      .find((snapshot) => snapshot.entityId === params.entityId);
    if (baseVersion === 0 && existing) return reply.code(409).send({ error: "entity_already_exists" });
    if (baseVersion > 0 && !existing) return reply.code(404).send({ error: "entity_not_found" });
    if (existing && existing.baseVersion !== baseVersion) {
      return reply.code(409).send({ error: "entity_version_conflict", baseVersion: existing.baseVersion });
    }
    const operation = scopedOperation({
      entityType: entityType.data,
      entityId: params.entityId,
      baseVersion,
      operationType: baseVersion === 0 ? "create" : "update",
      payload: body.payload,
      householdId: user.householdId!,
    });
    const parsed = syncPushOperationSchema.safeParse(operation);
    if (!parsed.success) return reply.code(400).send({ error: "invalid_entity_payload", issues: parsed.error.issues });
    const ownershipError = await validateReferencedEntities(syncStore, user.householdId!, parsed.data);
    if (ownershipError) return reply.code(400).send({ error: ownershipError });
    const result = await syncStore.pushOperation(normalizeOperationForOwner(parsed.data, {
      userId: user.sub, email: user.email, householdId: user.householdId!,
    }));
    if (result.result === "conflict") return reply.code(409).send(result);
    return reply.code(result.result === "applied" ? 200 : 400).send(result);
  });

  app.delete("/v1/entities/:entityType/:entityId", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const params = request.params as { entityType?: string; entityId?: string };
    const entityType = syncEntityTypeSchema.safeParse(params.entityType);
    const baseVersion = Number((request.query as { baseVersion?: string }).baseVersion);
    if (!entityType.success || !params.entityId || !Number.isInteger(baseVersion) || baseVersion < 1) {
      return reply.code(400).send({ error: "invalid_entity_delete" });
    }
    const existing = (await syncStore.listEntitySnapshots(user.householdId!, entityType.data))
      .find((snapshot) => snapshot.entityId === params.entityId);
    if (!existing) return reply.code(404).send({ error: "entity_not_found" });
    if (existing.baseVersion !== baseVersion) {
      return reply.code(409).send({ error: "entity_version_conflict", baseVersion: existing.baseVersion });
    }
    const result = await syncStore.pushOperation(scopedOperation({
      entityType: entityType.data, entityId: params.entityId, baseVersion,
      operationType: "delete", payload: {}, householdId: user.householdId!,
    }));
    if (result.result === "conflict") return reply.code(409).send(result);
    return reply.code(result.result === "applied" ? 200 : 400).send(result);
  });

  app.get("/v1/transactions", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    return { data: await syncStore.listEntitySnapshots(user.householdId!, "transaction") };
  });

  app.post("/v1/transactions", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const body = request.body as { id?: string; payload?: Record<string, unknown> } | undefined;
    const id = body?.id ?? `transaction-${randomUUID()}`;
    if (!body?.payload) return reply.code(400).send({ error: "invalid_transaction_write" });
    return replyForOnlineWrite(reply, await writeOnlineEntity(user, "transaction", id, 0, "create", body.payload));
  });

  app.patch("/v1/transactions/:id", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const id = (request.params as { id?: string }).id;
    const body = request.body as { payload?: Record<string, unknown>; baseVersion?: number } | undefined;
    if (!id || !body?.payload || typeof body.baseVersion !== "number") {
      return reply.code(400).send({ error: "invalid_transaction_write" });
    }
    const existing = (await syncStore.listEntitySnapshots(user.householdId!, "transaction"))
      .find((snapshot) => snapshot.entityId === id);
    if (!existing) return reply.code(404).send({ error: "transaction_not_found" });
    return replyForOnlineWrite(reply, await writeOnlineEntity(user, "transaction", id, body.baseVersion, "update", body.payload));
  });

  app.post("/v1/imports", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const body = request.body as {
      fileName?: unknown;
      content?: unknown;
      accountId?: unknown;
      createAccount?: { name?: unknown; provider?: unknown; type?: unknown; externalAccountId?: unknown };
    } | undefined;
    if (typeof body?.fileName !== "string" || typeof body.content !== "string" || body.fileName.length > 255 || body.content.length === 0 || body.content.length > 5_000_000) {
      return reply.code(400).send({ error: "invalid_statement_file" });
    }
    const statement = parseStatement(body.fileName, body.content);
    const batchId = `import-${randomUUID()}`;
    const now = new Date().toISOString();
    const knownSources = new Set<string>();
    for (const snapshot of await syncStore.listEntitySnapshots(user.householdId!, "transaction")) {
      const transaction = snapshot.payload.transaction as Record<string, unknown> | undefined;
      // Discarded rows are not financial history and cannot create duplicates.
      if (!isDuplicateReferenceTransaction(transaction)) continue;
      for (const source of Array.isArray(snapshot.payload.sources) ? snapshot.payload.sources : []) {
        if (!source || typeof source !== "object") continue;
        const row = source as Record<string, unknown>;
        if (typeof row.rowHash === "string") knownSources.add(`row:${row.rowHash}`);
        const key = externalSourceKey(
          row.externalId,
          row.occurredAt ?? transaction?.occurredAt,
          transaction?.amountCents,
          transaction?.descriptionRaw ?? transaction?.displayDescription,
        );
        if (key) knownSources.add(key);
      }
    }
    const validRows = statement.records.filter((record) => record.error === null);
    const duplicateRows = validRows.filter((record) => knownSources.has(`row:${record.rowHash}`) || knownSources.has(externalSourceKey(record.externalId, record.occurredAt, record.amountCents, record.description) ?? ""));
    const accounts = await syncStore.listEntitySnapshots(user.householdId!, "account");
    const requestedAccountId = typeof body.accountId === "string" && body.accountId.trim()
      ? body.accountId.trim()
      : null;
    const requestedAccount = requestedAccountId
      ? accounts.find((snapshot) => snapshot.entityId === requestedAccountId)
      : undefined;
    if (requestedAccountId && !requestedAccount) {
      return reply.code(400).send({ error: "invalid_import_destination" });
    }
    const matchedAccount = statement.accountReference
      ? accounts.find((snapshot) => {
        const account = snapshot.payload.account as Record<string, unknown> | undefined;
        return account?.externalAccountId === statement.accountReference;
      })
      : undefined;
    const createAccount = body.createAccount;
    const requestedName = typeof createAccount?.name === "string" ? createAccount.name.trim() : "";
    const requestedProvider = typeof createAccount?.provider === "string" ? createAccount.provider.trim() : "";
    const requestedExternalId = typeof createAccount?.externalAccountId === "string" ? createAccount.externalAccountId.trim() : "";
    const requestedType = typeof createAccount?.type === "string" ? createAccount.type : "checking";
    if (createAccount && (!requestedName || requestedName.length > 160 || requestedProvider.length > 120 || requestedExternalId.length > 255 || !["account", "checking", "savings", "wallet", "credit_card"].includes(requestedType))) {
      return reply.code(400).send({ error: "invalid_import_destination" });
    }
    let accountId = requestedAccount?.entityId ?? matchedAccount?.entityId ?? (accounts.length === 1 ? accounts[0].entityId : null);
    let createdAccountName: string | null = null;
    if (validRows.length > 0 && !accountId) {
      accountId = `account-${randomUUID()}`;
      createdAccountName = requestedName || "Conta corrente importada";
      const account = await writeOnlineEntity(user, "account", accountId, 0, "create", {
        schemaVersion: 1,
        account: {
          id: accountId,
          householdId: user.householdId,
          ownerPersonId: ownerPersonId(user.sub),
          provider: requestedProvider || (statement.provider === "unknown" ? "importação CSV" : statement.provider),
          name: createdAccountName,
          type: requestedType,
          currencyCode: "BRL",
          last4: null,
          externalAccountId: requestedExternalId || statement.accountReference,
          active: true,
        },
      });
      if (account.result !== "applied") return replyForOnlineWrite(reply, account);
    }
    const batch = await writeOnlineEntity(user, "importBatch", batchId, 0, "create", {
      schemaVersion: 1,
      importBatch: {
        id: batchId, householdId: user.householdId, fileName: body.fileName, fileHash: statement.fileHash,
        format: statement.format, provider: statement.provider, status: "completed", totalRows: statement.records.length,
        validRows: validRows.length, invalidRows: statement.records.length - validRows.length,
        duplicateRows: duplicateRows.length, accountId, accountReference: statement.accountReference, createdAt: now, completedAt: now,
      },
    });
    if (batch.result !== "applied") return replyForOnlineWrite(reply, batch);

    let createdTransactions = 0;
    let createdReviewItems = 0;
    for (const record of statement.records) {
      const duplicate = knownSources.has(`row:${record.rowHash}`) || knownSources.has(externalSourceKey(record.externalId, record.occurredAt, record.amountCents, record.description) ?? "");
      const reviewId = `review-${batchId}-${record.rowIndex}`;
      let importedTransactionId: string | null = null;
      if (record.error === null && record.occurredAt !== null && record.description !== null && record.amountCents !== null) {
        const transactionId = `transaction-${randomUUID()}`;
        const transaction = await writeOnlineEntity(user, "transaction", transactionId, 0, "create", {
          schemaVersion: 1,
          transaction: {
            id: transactionId, householdId: user.householdId, kind: record.amountCents < 0 ? "expense" : "income",
            reviewStatus: "pending", duplicateStatus: duplicate ? "probable" : "none", occurredAt: record.occurredAt,
            postedAt: record.occurredAt, competenceMonth: record.occurredAt.slice(0, 7), amountCents: record.amountCents,
            currencyCode: record.currencyCode, descriptionRaw: record.description, displayDescription: null, accountId,
            transferFromAccountId: null, transferToAccountId: null, recurringScheduleId: null, installmentPlanId: null,
            merchantId: null, categoryId: null, costCenterId: null, payerId: null, appliedRuleId: null,
            sourceConfidence: statement.provider === "unknown" ? 0.55 : 0.78, updatedAt: now, deletedAt: null,
          },
          beneficiaries: [],
          sources: [{
            id: `source-${transactionId}`, transactionId, sourceKind: statement.format, provider: statement.provider,
            externalId: record.externalId, fileHash: statement.fileHash, rowHash: record.rowHash, notificationKey: null,
            rawPayloadJson: record.rawPayload, occurredAt: record.occurredAt, confidence: statement.provider === "unknown" ? 0.55 : 0.78,
          }],
        });
        if (transaction.result !== "applied") return replyForOnlineWrite(reply, transaction);
        createdTransactions += 1;
        importedTransactionId = transactionId;
      }
      const review = await writeOnlineEntity(user, "reviewItem", reviewId, 0, "create", {
        schemaVersion: 1,
        reviewItem: {
          id: reviewId, householdId: user.householdId, importBatchId: batchId, rowIndex: record.rowIndex,
          status: record.error === null ? (duplicate ? "duplicate" : "pending") : "invalid", reason: record.error,
          transactionId: importedTransactionId, rowHash: record.rowHash, createdAt: now,
        },
      });
      if (review.result !== "applied") return replyForOnlineWrite(reply, review);
      createdReviewItems += 1;
    }
    return { batchId, format: statement.format, provider: statement.provider, totalRows: statement.records.length, createdTransactions, createdReviewItems, accountId, createdAccountName };
  });

  app.post("/v1/imports/:batchId/destination", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const batchId = (request.params as { batchId?: string }).batchId;
    const accountId = (request.body as { accountId?: unknown } | undefined)?.accountId;
    if (!batchId || typeof accountId !== "string" || !accountId.trim()) {
      return reply.code(400).send({ error: "invalid_import_destination" });
    }
    const [batches, accounts, reviewItems, transactions] = await Promise.all([
      syncStore.listEntitySnapshots(user.householdId!, "importBatch"),
      syncStore.listEntitySnapshots(user.householdId!, "account"),
      syncStore.listEntitySnapshots(user.householdId!, "reviewItem"),
      syncStore.listEntitySnapshots(user.householdId!, "transaction"),
    ]);
    const batch = batches.find((snapshot) => snapshot.entityId === batchId);
    if (!batch) return reply.code(404).send({ error: "import_batch_not_found" });
    const targetAccountId = accountId.trim();
    if (!accounts.some((snapshot) => snapshot.entityId === targetAccountId)) {
      return reply.code(400).send({ error: "invalid_import_destination" });
    }
    const transactionIds = new Set(reviewItems.flatMap((snapshot) => {
      const review = snapshot.payload.reviewItem as Record<string, unknown> | undefined;
      return review?.importBatchId === batchId && typeof review.transactionId === "string" ? [review.transactionId] : [];
    }));
    const now = new Date().toISOString();
    const batchPayload = batch.payload.importBatch as Record<string, unknown> | undefined;
    if (!batchPayload) return reply.code(409).send({ error: "invalid_import_batch" });
    const batchUpdate = await writeOnlineEntity(user, "importBatch", batchId, batch.baseVersion, "update", {
      ...batch.payload,
      importBatch: { ...batchPayload, accountId: targetAccountId, updatedAt: now },
    });
    if (batchUpdate.result !== "applied") return replyForOnlineWrite(reply, batchUpdate);
    let updated = 0;
    for (const snapshot of transactions) {
      if (!transactionIds.has(snapshot.entityId)) continue;
      const transaction = snapshot.payload.transaction as Record<string, unknown> | undefined;
      if (!transaction || transaction.accountId === targetAccountId) continue;
      const result = await writeOnlineEntity(user, "transaction", snapshot.entityId, snapshot.baseVersion, "update", {
        ...snapshot.payload,
        transaction: { ...transaction, accountId: targetAccountId, updatedAt: now },
      });
      if (result.result !== "applied") return replyForOnlineWrite(reply, result);
      updated += 1;
    }
    return { batchId, accountId: targetAccountId, updated };
  });

  app.post("/v1/reviews/:transactionId/resolve", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const transactionId = (request.params as { transactionId?: string }).transactionId;
    const decision = (request.body as { decision?: unknown } | undefined)?.decision;
    if (!transactionId || (decision !== "confirmed" && decision !== "ignored")) {
      return reply.code(400).send({ error: "invalid_review_decision" });
    }
    const snapshot = (await syncStore.listEntitySnapshots(user.householdId!, "transaction")).find((item) => item.entityId === transactionId);
    const row = snapshot?.payload.transaction as Record<string, unknown> | undefined;
    if (!snapshot || !row) return reply.code(404).send({ error: "transaction_not_found" });
    const result = await writeOnlineEntity(user, "transaction", transactionId, snapshot.baseVersion, "update", {
      ...snapshot.payload,
      transaction: { ...row, reviewStatus: decision, updatedAt: new Date().toISOString() },
    });
    if (result.result !== "applied") return replyForOnlineWrite(reply, result);
    await resolveReviewItems(user, transactionId, decision === "confirmed" ? "confirmed" : "ignored");
    return { transactionId, reviewStatus: decision };
  });

  app.post("/v1/duplicates/:transactionId/resolve", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const transactionId = (request.params as { transactionId?: string }).transactionId;
    const decision = (request.body as { decision?: unknown } | undefined)?.decision;
    if (!transactionId || (decision !== "keep" && decision !== "duplicate" && decision !== "merged")) {
      return reply.code(400).send({ error: "invalid_duplicate_decision" });
    }
    const snapshot = (await syncStore.listEntitySnapshots(user.householdId!, "transaction")).find((item) => item.entityId === transactionId);
    const row = snapshot?.payload.transaction as Record<string, unknown> | undefined;
    if (!snapshot || !row) return reply.code(404).send({ error: "transaction_not_found" });
    const duplicateStatus = decision === "keep" ? "none" : decision;
    const result = await writeOnlineEntity(user, "transaction", transactionId, snapshot.baseVersion, "update", {
      ...snapshot.payload,
      transaction: { ...row, duplicateStatus, updatedAt: new Date().toISOString() },
    });
    if (result.result !== "applied") return replyForOnlineWrite(reply, result);
    await resolveReviewItems(user, transactionId, duplicateStatus);
    return { transactionId, duplicateStatus };
  });

  app.post("/v1/duplicates/resolve-all", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const snapshots = await syncStore.listEntitySnapshots(user.householdId!, "transaction");
    const candidates = snapshots.filter((snapshot) => {
      const row = snapshot.payload.transaction as Record<string, unknown> | undefined;
      return row?.duplicateStatus === "probable";
    });
    let resolved = 0;
    let skipped = 0;
    for (const snapshot of candidates) {
      const row = snapshot.payload.transaction as Record<string, unknown>;
      const result = await writeOnlineEntity(user, "transaction", snapshot.entityId, snapshot.baseVersion, "update", {
        ...snapshot.payload,
        transaction: { ...row, duplicateStatus: "duplicate", updatedAt: new Date().toISOString() },
      });
      if (result.result !== "applied") {
        skipped += 1;
        continue;
      }
      await resolveReviewItems(user, snapshot.entityId, "duplicate");
      resolved += 1;
    }
    return { resolved, skipped };
  });

  app.get("/v1/reports/monthly", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const month = (request.query as { month?: string }).month;
    if (!month || !/^\d{4}-\d{2}$/.test(month)) return reply.code(400).send({ error: "invalid_competence_month" });
    const snapshots = await syncStore.listEntitySnapshots(user.householdId!, "transaction");
    const transactions = snapshots.map((snapshot) => snapshot.payload.transaction as Record<string, unknown> | undefined)
      .filter((transaction): transaction is Record<string, unknown> => transaction !== undefined)
      .filter((transaction) => transaction.competenceMonth === month && transaction.deletedAt == null);
    const confirmed = transactions.filter((transaction) => transaction.reviewStatus === "confirmed" && transaction.duplicateStatus === "none");
    const total = (predicate: (transaction: Record<string, unknown>) => boolean) => confirmed
      .filter(predicate).reduce((sum, transaction) => sum + Number(transaction.amountCents ?? 0), 0);
    return {
      month,
      transactionCount: transactions.length,
      pendingCount: transactions.filter((transaction) => transaction.reviewStatus === "pending" || transaction.duplicateStatus === "probable").length,
      incomeCents: total((transaction) => transaction.kind === "income"),
      expenseCents: total((transaction) => transaction.kind === "expense"),
      transferCents: total((transaction) => transaction.kind === "transfer"),
    };
  });

  app.get("/v1/backups/export", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const entities = await Promise.all(syncEntityTypeSchema.options.map(async (entityType) => [
      entityType, await syncStore.listEntitySnapshots(user.householdId!, entityType),
    ] as const));
    return {
      schemaVersion: 1,
      exportedAt: new Date().toISOString(),
      entities: Object.fromEntries(entities),
    };
  });

  app.post("/v1/backups/restore", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const body = request.body as { schemaVersion?: number; entities?: Record<string, unknown> } | undefined;
    if (body?.schemaVersion !== 1 || !body.entities || typeof body.entities !== "object") {
      return reply.code(400).send({ error: "invalid_backup" });
    }
    const restoreRows: Array<{ type: SyncPushOperation["entityType"]; id: string; payload: Record<string, unknown> }> = [];
    for (const [type, values] of Object.entries(body.entities)) {
      const parsedType = syncEntityTypeSchema.safeParse(type);
      if (!parsedType.success || !Array.isArray(values)) return reply.code(400).send({ error: "invalid_backup_entity" });
      for (const value of values) {
        if (!value || typeof value !== "object") return reply.code(400).send({ error: "invalid_backup_entity" });
        const snapshot = value as { entityId?: unknown; payload?: unknown };
        if (typeof snapshot.entityId !== "string" || !snapshot.payload || typeof snapshot.payload !== "object") {
          return reply.code(400).send({ error: "invalid_backup_entity" });
        }
        // The person that represents the authenticated account is canonical:
        // its identity comes from the bearer, never from an imported backup.
        if (parsedType.data === "person" && snapshot.entityId === ownerPersonId(user.sub)) continue;
        restoreRows.push({ type: parsedType.data, id: snapshot.entityId, payload: snapshot.payload as Record<string, unknown> });
      }
    }
    // A restore replaces only this account's domain records. It never accepts
    // an account id from the exported document.
    const current = await Promise.all(syncEntityTypeSchema.options.map(async (type) => [
      type, await syncStore.listEntitySnapshots(user.householdId!, type),
    ] as const));
    for (const [type, snapshots] of current) {
      for (const snapshot of snapshots) {
        if (type === "person" && snapshot.entityId === ownerPersonId(user.sub)) continue;
        await syncStore.pushOperation(scopedOperation({ entityType: type, entityId: snapshot.entityId, baseVersion: snapshot.baseVersion, operationType: "delete", payload: {}, householdId: user.householdId! }));
      }
    }
    const restoreOrder: Record<string, number> = {
      person: 10, account: 20, category: 30, costCenter: 40,
      creditCardLimitGroup: 50, creditCard: 60, recurringSchedule: 70,
      installmentPlan: 80, creditCardInvoice: 90, transaction: 100,
      invoicePayment: 110, rule: 120, reviewItem: 130, duplicateCandidate: 140,
      importBatch: 150, reconciliationRun: 160, backup: 170, preference: 180,
    };
    restoreRows.sort((left, right) => (restoreOrder[left.type] ?? 999) - (restoreOrder[right.type] ?? 999));
    for (const row of restoreRows) {
      const result = await writeOnlineEntity(user, row.type, row.id, 0, "create", row.payload);
      if (result.result !== "applied") return reply.code(400).send({ error: "backup_restore_rejected" });
    }
    return { restored: restoreRows.length };
  });

  app.post("/notification-events/batch", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const body = request.body as { events?: unknown } | undefined;
    if (!Array.isArray(body?.events) || body.events.length === 0 || body.events.length > 100) {
      return reply.code(400).send({ error: "invalid_notification_batch" });
    }
    try {
      const accepted = await notificationStore.acceptBatch(user.householdId!, body.events);
      return { accepted };
    } catch {
      return reply.code(400).send({ error: "invalid_notification_event" });
    }
  });

  app.post("/notification-events/:id/resolve", async (request, reply) => {
    const user = await requireAccountAuth(request, reply);
    if (!user) return;
    const id = (request.params as { id?: string }).id;
    if (!id) return reply.code(400).send({ error: "notification_id_required" });
    const resolved = await notificationStore.resolve(user.householdId!, id);
    return resolved ? { ok: true } : reply.code(404).send({ error: "notification_not_found" });
  });

  // Older REST placeholders must fail explicitly; a 200 empty list is unsafe
  // because it looks like an account without data.
  for (const route of [
    "/transactions", "/transactions/:id", "/imports", "/duplicates/:id/resolve",
    "/review/:id/resolve", "/rules", "/rules/:id",
    "/sync/push", "/sync/pull", "/sync/status", "/data/entities",
  ]) {
    app.all(route, async (_request, reply) =>
      reply.code(410).send({ error: "legacy_route_removed_use_v1" }),
    );
  }

  return app;

  async function requireSession(
    request: FastifyRequest,
    reply: FastifyReply,
  ): Promise<AuthenticatedUser | null | undefined> {
    if (!config.googleOidcEnabled && !config.passwordAuthEnabled) {
      return null;
    }

    const authorization = request.headers.authorization;
    const token = authorization?.startsWith("Bearer ")
      ? authorization.slice("Bearer ".length).trim()
      : undefined;

    if (!token) {
      reply.code(401).send({ error: "missing_session" });
      return undefined;
    }

    try {
      const user = await sessionService.verify(token);
      ensureAllowedEmail(config, user.email);
      if (config.passwordAuthEnabled && (!user.householdId || !(await identityStore.isMember(user.sub, user.householdId)))) {
        reply.code(403).send({ error: "household_not_allowed" });
        return undefined;
      }
      if (config.passwordAuthEnabled && user.householdId) {
        await syncStore.ensureOwnerProfile({
          userId: user.sub,
          email: user.email,
          householdId: user.householdId,
        });
      }
      return user;
    } catch (error) {
      if (error instanceof AuthError) {
        reply.code(error.statusCode).send({ error: error.message });
        return undefined;
      }
      reply.code(401).send({ error: "invalid_session" });
      return undefined;
    }
  }

  async function requireAccountAuth(request: FastifyRequest, reply: FastifyReply): Promise<AuthenticatedUser | undefined> {
    const user = await requireSession(request, reply);
    if (!user || !user.householdId) {
      if (user) reply.code(403).send({ error: "account_unavailable" });
      return undefined;
    }
    return user;
  }

  async function writeOnlineEntity(
    user: AuthenticatedUser,
    entityType: SyncPushOperation["entityType"],
    entityId: string,
    baseVersion: number,
    operationType: "create" | "update",
    payload: Record<string, unknown>,
  ): Promise<SyncPushResult> {
    if (!user.householdId || !Number.isInteger(baseVersion) || baseVersion < 0) {
      return { opId: "invalid", entityId, result: "rejected", seq: 0 };
    }
    const parsed = syncPushOperationSchema.safeParse(scopedOperation({
      entityType, entityId, baseVersion, operationType, payload, householdId: user.householdId,
    }));
    if (!parsed.success) return { opId: "invalid", entityId, result: "rejected", seq: 0 };
    if (await validateReferencedEntities(syncStore, user.householdId, parsed.data)) {
      return { opId: "invalid", entityId, result: "rejected", seq: 0 };
    }
    return syncStore.pushOperation(normalizeOperationForOwner(parsed.data, {
      userId: user.sub, email: user.email, householdId: user.householdId,
    }));
  }

  async function resolveReviewItems(user: AuthenticatedUser, transactionId: string, status: string) {
    if (!user.householdId) return;
    const items = await syncStore.listEntitySnapshots(user.householdId, "reviewItem");
    for (const item of items) {
      const review = item.payload.reviewItem as Record<string, unknown> | undefined;
      if (!review || review.transactionId !== transactionId) continue;
      await writeOnlineEntity(user, "reviewItem", item.entityId, item.baseVersion, "update", {
        ...item.payload,
        reviewItem: { ...review, status, resolvedAt: new Date().toISOString() },
      });
    }
  }

  function replyForOnlineWrite(reply: FastifyReply, result: SyncPushResult) {
    if (result.result === "conflict") return reply.code(409).send(result);
    return reply.code(result.result === "applied" ? 200 : 400).send(result);
  }

  async function sessionResponse(identity: {
    id: string;
    email: string;
    accountId?: string;
    householdId?: string;
    role: "admin" | "member";
    name?: string;
  }) {
    const user = {
      sub: identity.id,
      email: identity.email,
      accountId: identity.accountId,
      householdId: identity.householdId,
      role: identity.role,
      name: identity.name,
    };
    if (identity.householdId) {
      await syncStore.ensureOwnerProfile({
        userId: identity.id,
        email: identity.email,
        householdId: identity.householdId,
      });
    }
    return {
      token: await sessionService.create(user),
      expiresInSeconds: config.sessionTtlSeconds,
      user,
    };
  }
}

function normalizeOperationForOwner(
  operation: SyncPushOperation,
  owner: { userId: string; email: string; householdId: string },
): SyncPushOperation {
  const id = ownerPersonId(owner.userId);
  const payload = operation.payload as Record<string, unknown>;

  if (operation.entityType === "person") {
    const person = payload.person as Record<string, unknown> | undefined;
    if (operation.entityId === id) {
      const displayName = typeof person?.displayName === "string" && person.displayName.trim().length > 0
        ? person.displayName.trim()
        : owner.email;
      return {
        ...operation,
        operationType: "update",
        payload: {
          schemaVersion: 1,
          person: { id, householdId: owner.householdId, displayName, kind: "adult", relationship: "self", active: true },
        },
      };
    }
    if (person?.kind === "adult") {
      return { ...operation, payload: { ...payload, person: { ...person, kind: "other" } } };
    }
  }

  if (operation.entityType === "account") {
    const account = payload.account as Record<string, unknown> | undefined;
    if (account) {
      return { ...operation, payload: { ...payload, account: { ...account, ownerPersonId: id } } };
    }
  }

  if (operation.entityType === "creditCard") {
    const card = payload.creditCard as Record<string, unknown> | undefined;
    if (card) {
      return { ...operation, payload: { ...payload, creditCard: { ...card, ownerPersonId: id } } };
    }
  }

  if (operation.entityType === "transaction" && operation.operationType !== "delete") {
    const transaction = payload.transaction as Record<string, unknown> | undefined;
    const beneficiaries = Array.isArray(payload.beneficiaries) ? payload.beneficiaries : [];
    if (transaction) {
      return {
        ...operation,
        payload: {
          ...payload,
          transaction: { ...transaction, payerId: id },
          beneficiaries: beneficiaries.length > 0
            ? beneficiaries
            : [{
                id: `beneficiary-${operation.entityId}-${id}`,
                transactionId: operation.entityId,
                personId: id,
                allocationMode: "full",
                allocatedAmountCents: null,
                allocatedPercent: null,
                isPrimary: true,
              }],
        },
      };
    }
  }
  return operation;
}

/** Server-generated operation envelope.  Account scope is never accepted from
 * an online client, even when an old client still sends a householdId field. */
function scopedOperation(input: {
  entityType: SyncPushOperation["entityType"];
  entityId: string;
  baseVersion: number;
  operationType: SyncPushOperation["operationType"];
  payload: Record<string, unknown>;
  householdId: string;
}): SyncPushOperation {
  return {
    opId: `online-${randomUUID()}`,
    deviceId: "online-api",
    householdId: input.householdId,
    entityType: input.entityType,
    entityId: input.entityId,
    operationType: input.operationType,
    baseVersion: input.baseVersion,
    payload: applyHouseholdScope(input.payload, input.householdId),
    createdAt: new Date().toISOString(),
  };
}

function applyHouseholdScope(value: Record<string, unknown>, householdId: string): Record<string, unknown> {
  const visit = (item: unknown): unknown => {
    if (Array.isArray(item)) return item.map(visit);
    if (!item || typeof item !== "object") return item;
    const row = item as Record<string, unknown>;
    const scoped = Object.fromEntries(Object.entries(row).map(([key, child]) => [key, visit(child)]));
    // Every persisted finance row with a scope receives the scope selected by
    // the bearer token. Client values are deliberately overwritten.
    if ("id" in row || "householdId" in row) scoped.householdId = householdId;
    return scoped;
  };
  return visit(value) as Record<string, unknown>;
}

async function validateReferencedEntities(
  store: SyncStore,
  householdId: string,
  operation: SyncPushOperation,
): Promise<string | undefined> {
  const payload = operation.payload as Record<string, unknown>;
  const row = (payload.transaction ?? payload.account ?? payload.creditCard) as Record<string, unknown> | undefined;
  if (!row) return undefined;
  const checks: Array<[string, SyncPushOperation["entityType"]]> = [];
  if (operation.entityType === "transaction") {
    checks.push(
      ["accountId", "account"], ["transferFromAccountId", "account"], ["transferToAccountId", "account"],
      ["categoryId", "category"], ["costCenterId", "costCenter"], ["payerId", "person"],
    );
    for (const beneficiary of (Array.isArray(payload.beneficiaries) ? payload.beneficiaries : [])) {
      if (beneficiary && typeof beneficiary === "object") {
        const personId = (beneficiary as Record<string, unknown>).personId;
        if (typeof personId === "string") checks.push([`beneficiary:${personId}`, "person"]);
      }
    }
  } else if (operation.entityType === "account") {
    checks.push(["ownerPersonId", "person"]);
  } else if (operation.entityType === "creditCard") {
    checks.push(["accountId", "account"], ["ownerPersonId", "person"], ["limitGroupId", "creditCardLimitGroup"]);
  }
  for (const [field, type] of checks) {
    const id = field.startsWith("beneficiary:") ? field.slice("beneficiary:".length) : row[field];
    if (id === null || id === undefined || id === "") continue;
    if (typeof id !== "string") return "invalid_related_entity";
    const entities = await store.listEntitySnapshots(householdId, type);
    if (!entities.some((entity) => entity.entityId === id)) return "related_entity_not_found";
  }
  return undefined;
}

/**
 * Some OFX exporters reuse FITID for every month of an installment plan.
 * FITID alone is therefore not an import identity: the occurrence, value and
 * normalized description (which includes e.g. "4/10") must agree as well.
 */
function externalSourceKey(
  externalId: unknown,
  occurredAt: unknown,
  amountCents: unknown,
  description: unknown,
): string | null {
  if (typeof externalId !== "string" || !externalId.trim()) return null;
  if (typeof occurredAt !== "string" || typeof amountCents !== "number" || typeof description !== "string") return null;
  const normalizedDescription = description.trim().toLowerCase().replace(/\s+/g, " ");
  return `external:${externalId.trim()}|${occurredAt.slice(0, 10)}|${amountCents}|${normalizedDescription}`;
}

function isDuplicateReferenceTransaction(transaction: Record<string, unknown> | undefined): boolean {
  if (!transaction || transaction.deletedAt) return false;
  if (transaction.reviewStatus === "ignored") return false;
  return transaction.duplicateStatus !== "duplicate" && transaction.duplicateStatus !== "merged";
}

function publicAccountUser(user: AuthenticatedUser) {
  return { sub: user.sub, email: user.email, name: user.name, role: user.role };
}
