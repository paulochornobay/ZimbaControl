import { z } from "zod";

export const syncOperationResultSchema = z.enum([
  "applied",
  "duplicate",
  "conflict",
  "rejected",
]);

export const canonicalSourceRecordSchema = z.object({
  id: z.string(),
  sourceKind: z.enum(["notification", "csv", "ofx", "manual"]),
  provider: z.string(),
  externalId: z.string().optional(),
  fileHash: z.string().optional(),
  rowHash: z.string().optional(),
  notificationKey: z.string().optional(),
  confidence: z.number().min(0).max(1).default(0),
});

export const transactionSchema = z.object({
  id: z.string(),
  householdId: z.string(),
  kind: z.enum(["income", "expense", "transfer", "refund", "adjustment"]),
  amountCents: z.number().int(),
  currencyCode: z.string().length(3).default("BRL"),
  occurredAt: z.string(),
  postedAt: z.string().optional(),
  competenceMonth: z.string(),
  descriptionRaw: z.string(),
  merchantId: z.string().optional(),
  categoryId: z.string().optional(),
  costCenterId: z.string().optional(),
  payerId: z.string().optional(),
  beneficiaryIds: z.array(z.string()).default([]),
  sourceRecords: z.array(canonicalSourceRecordSchema).default([]),
  reviewStatus: z.enum(["pending", "confirmed", "ignored", "conflict"]),
  duplicateStatus: z.enum(["none", "probable", "duplicate", "merged"]),
  baseVersion: z.number().int().nonnegative().default(0),
});

export const syncPushOperationSchema = z.object({
  opId: z.string(),
  deviceId: z.string(),
  householdId: z.string(),
  entityType: z.enum(["transaction", "rule", "reviewItem", "duplicateCandidate"]),
  entityId: z.string(),
  operationType: z.enum(["create", "update", "delete", "resolve"]),
  baseVersion: z.number().int().nonnegative(),
  payload: z.record(z.unknown()),
  createdAt: z.string(),
});

export const syncPushRequestSchema = z.object({
  deviceId: z.string(),
  householdId: z.string(),
  operations: z.array(syncPushOperationSchema),
});

export const syncPullQuerySchema = z.object({
  householdId: z.string().min(1),
  sinceSeq: z.coerce.number().int().nonnegative().default(0),
});

export const googleAuthRequestSchema = z.object({
  idToken: z.string().min(1),
});

export type Transaction = z.infer<typeof transactionSchema>;
export type SyncPushOperation = z.infer<typeof syncPushOperationSchema>;
export type SyncPushRequest = z.infer<typeof syncPushRequestSchema>;
export type SyncOperationResult = z.infer<typeof syncOperationResultSchema>;
export type SyncPullQuery = z.infer<typeof syncPullQuerySchema>;
export type GoogleAuthRequest = z.infer<typeof googleAuthRequestSchema>;
