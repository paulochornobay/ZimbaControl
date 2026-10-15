import "dotenv/config";
import { randomUUID } from "node:crypto";
import { MongoClient } from "mongodb";
import { loadConfig } from "./config.js";
import { MongoSyncStore } from "./sync-store.js";

const householdId = process.argv[2];
const config = loadConfig();
if (!householdId || !config.mongodbUri) {
  throw new Error("Usage: tsx src/recheck-duplicate-candidates.ts <household-id>");
}

const client = new MongoClient(config.mongodbUri);
const store = new MongoSyncStore(client, config.mongodbDb);
await store.init();

try {
  const transactions = await store.listEntitySnapshots(householdId, "transaction");
  const reviewItems = await store.listEntitySnapshots(householdId, "reviewItem");
  const sourceKeys = new Map<string, number>();
  for (const snapshot of transactions) {
    const transaction = snapshot.payload.transaction as Record<string, unknown> | undefined;
    if (!isDuplicateReferenceTransaction(transaction)) continue;
    for (const source of Array.isArray(snapshot.payload.sources) ? snapshot.payload.sources : []) {
      if (!source || typeof source !== "object") continue;
      const row = source as Record<string, unknown>;
      if (typeof row.rowHash === "string") increment(sourceKeys, `row:${row.rowHash}`);
      const key = externalSourceKey(
        row.externalId,
        row.occurredAt ?? transaction?.occurredAt,
        transaction?.amountCents,
        transaction?.descriptionRaw ?? transaction?.displayDescription,
      );
      if (key) increment(sourceKeys, key);
    }
  }

  let cleared = 0;
  for (const snapshot of transactions) {
    const transaction = snapshot.payload.transaction as Record<string, unknown> | undefined;
    if (!transaction || transaction.duplicateStatus !== "probable") continue;
    const hasActiveMatch = (Array.isArray(snapshot.payload.sources) ? snapshot.payload.sources : []).some((source) => {
      if (!source || typeof source !== "object") return false;
      const row = source as Record<string, unknown>;
      if (typeof row.rowHash === "string" && (sourceKeys.get(`row:${row.rowHash}`) ?? 0) > 1) return true;
      const key = externalSourceKey(
        row.externalId,
        row.occurredAt ?? transaction.occurredAt,
        transaction.amountCents,
        transaction.descriptionRaw ?? transaction.displayDescription,
      );
      return !!key && (sourceKeys.get(key) ?? 0) > 1;
    });
    if (hasActiveMatch) continue;

    const now = new Date().toISOString();
    const result = await store.pushOperation({
      opId: `duplicate-recheck-${randomUUID()}`,
      deviceId: "server-duplicate-recheck",
      householdId,
      entityType: "transaction",
      entityId: snapshot.entityId,
      operationType: "update",
      baseVersion: snapshot.baseVersion,
      payload: {
        ...snapshot.payload,
        transaction: { ...transaction, duplicateStatus: "none", updatedAt: now },
      },
      createdAt: now,
    });
    if (result.result !== "applied") continue;

    for (const review of reviewItems) {
      const row = review.payload.reviewItem as Record<string, unknown> | undefined;
      if (row?.transactionId !== snapshot.entityId || row.status !== "duplicate") continue;
      await store.pushOperation({
        opId: `duplicate-recheck-review-${randomUUID()}`,
        deviceId: "server-duplicate-recheck",
        householdId,
        entityType: "reviewItem",
        entityId: review.entityId,
        operationType: "update",
        baseVersion: review.baseVersion,
        payload: { ...review.payload, reviewItem: { ...row, status: "pending", resolvedAt: null } },
        createdAt: now,
      });
    }
    cleared += 1;
  }
  console.log(JSON.stringify({ rechecked: cleared }));
} finally {
  await store.close();
}

function increment(values: Map<string, number>, key: string) {
  values.set(key, (values.get(key) ?? 0) + 1);
}

function isDuplicateReferenceTransaction(transaction: Record<string, unknown> | undefined): boolean {
  if (!transaction || transaction.deletedAt || transaction.reviewStatus === "ignored") return false;
  return transaction.duplicateStatus !== "duplicate" && transaction.duplicateStatus !== "merged";
}

function externalSourceKey(externalId: unknown, occurredAt: unknown, amountCents: unknown, description: unknown): string | null {
  if (typeof externalId !== "string" || !externalId.trim()) return null;
  if (typeof occurredAt !== "string" || typeof amountCents !== "number" || typeof description !== "string") return null;
  return `external:${externalId.trim()}|${occurredAt.slice(0, 10)}|${amountCents}|${description.trim().toLowerCase().replace(/\s+/g, " ")}`;
}
