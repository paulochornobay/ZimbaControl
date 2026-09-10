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
  displayDescription: z.string().nullable().optional(),
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

export const syncTransactionPayloadSchema = z.object({
  schemaVersion: z.literal(1),
  transaction: z.object({
    id: z.string(),
    householdId: z.string(),
    kind: z.enum(["income", "expense", "transfer", "refund", "adjustment"]),
    reviewStatus: z.enum(["pending", "confirmed", "ignored", "conflict"]),
    duplicateStatus: z.enum(["none", "probable", "duplicate", "merged"]),
    occurredAt: z.string(),
    postedAt: z.string().nullable(),
    competenceMonth: z.string(),
    amountCents: z.number().int(),
    currencyCode: z.string().length(3),
    descriptionRaw: z.string(),
    displayDescription: z.string().nullable().optional(),
    accountId: z.string().nullable(),
    transferFromAccountId: z.string().nullable(),
    transferToAccountId: z.string().nullable(),
    recurringScheduleId: z.string().nullable(),
    installmentPlanId: z.string().nullable(),
    merchantId: z.string().nullable(),
    categoryId: z.string().nullable(),
    costCenterId: z.string().nullable(),
    payerId: z.string().nullable(),
    appliedRuleId: z.string().nullable(),
    sourceConfidence: z.number().min(0).max(1),
    updatedAt: z.string(),
    deletedAt: z.string().nullable(),
  }),
  beneficiaries: z.array(
    z.object({
      id: z.string(),
      transactionId: z.string(),
      personId: z.string(),
      allocationMode: z.string(),
      allocatedAmountCents: z.number().int().nullable(),
      allocatedPercent: z.number().nullable(),
      isPrimary: z.boolean(),
    }),
  ),
  sources: z.array(
    z.object({
      id: z.string(),
      transactionId: z.string(),
      sourceKind: z.enum(["notification", "csv", "ofx", "manual"]),
      provider: z.string(),
      externalId: z.string().nullable(),
      fileHash: z.string().nullable(),
      rowHash: z.string().nullable(),
      notificationKey: z.string().nullable(),
      rawPayloadJson: z.string().nullable(),
      occurredAt: z.string().nullable(),
      confidence: z.number().min(0).max(1),
    }),
  ),
});

const syncedRowSchema = z.object({
  id: z.string(),
  householdId: z.string(),
}).passthrough();

export const syncEntityTypes = [
  "transaction",
  "person",
  "account",
  "category",
  "costCenter",
  "rule",
  "reviewItem",
  "duplicateCandidate",
  "creditCardLimitGroup",
  "creditCard",
  "invoicePayment",
] as const;

export const syncEntityTypeSchema = z.enum(syncEntityTypes);

export const syncPersonPayloadSchema = z.object({
  schemaVersion: z.literal(1),
  person: syncedRowSchema.extend({
    displayName: z.string().trim().min(1).max(160),
    kind: z.enum(["adult", "child", "other"]),
    active: z.boolean(),
  }),
});

export const syncAccountPayloadSchema = z.object({
  schemaVersion: z.literal(1),
  account: syncedRowSchema.extend({
    ownerPersonId: z.string().nullable(),
    provider: z.string().trim().min(1).max(120),
    name: z.string().trim().min(1).max(160),
    type: z.enum(["account", "checking", "savings", "wallet", "credit_card"]),
    currencyCode: z.string().trim().length(3),
    last4: z.string().trim().min(1).max(12).nullable(),
    externalAccountId: z.string().trim().min(1).max(256).nullable(),
    active: z.boolean(),
  }),
});

export const syncCategoryPayloadSchema = z.object({
  schemaVersion: z.literal(1),
  category: syncedRowSchema.extend({
    parentId: z.string().nullable(),
    systemKey: z.string().trim().min(1).max(120).nullable(),
    name: z.string().trim().min(1).max(160),
    kind: z.enum(["expense", "income"]),
    iconKey: z.string().trim().min(1).max(80),
    colorKey: z.string().trim().min(1).max(80),
    sortOrder: z.number().int(),
    isDefault: z.boolean(),
    isHidden: z.boolean(),
    active: z.boolean(),
    createdAt: z.string().datetime(),
    updatedAt: z.string().datetime(),
  }),
});

export const syncCostCenterPayloadSchema = z.object({
  schemaVersion: z.literal(1),
  costCenter: syncedRowSchema.extend({
    name: z.string().trim().min(1).max(160),
    iconKey: z.string().trim().min(1).max(80),
    colorKey: z.string().trim().min(1).max(80),
    active: z.boolean(),
  }),
});

const registryPayloadField: Partial<Record<SyncEntityType, string>> = {
  person: "person",
  account: "account",
  category: "category",
  costCenter: "costCenter",
};

export const syncCreditCardLimitGroupPayloadSchema = z.object({
  schemaVersion: z.literal(1),
  group: syncedRowSchema.extend({
    name: z.string(),
    totalLimitCents: z.number().int().nullable(),
    active: z.boolean(),
  }),
});

export const syncCreditCardPayloadSchema = z.object({
  schemaVersion: z.literal(1),
  creditCard: syncedRowSchema.extend({
    accountId: z.string().nullable(),
    ownerPersonId: z.string().nullable(),
    provider: z.string(),
    name: z.string(),
    billingDay: z.number().int().nullable(),
    dueDay: z.number().int().nullable(),
    limitGroupId: z.string().nullable(),
    limitRole: z.enum(["primary", "additional"]),
    active: z.boolean(),
  }),
  account: syncedRowSchema.nullable(),
});

export const syncInvoicePaymentPayloadSchema = z.object({
  schemaVersion: z.literal(1),
  payment: syncedRowSchema.extend({
    invoiceId: z.string(),
    transactionId: z.string().nullable(),
    amountCents: z.number().int(),
    paidAt: z.string(),
    origin: z.string(),
    status: z.string(),
    createdAt: z.string(),
    updatedAt: z.string(),
  }),
  invoice: syncedRowSchema.nullable(),
  audits: z.array(
    syncedRowSchema.extend({
      paymentId: z.string(),
      invoiceId: z.string(),
      transactionId: z.string().nullable(),
      action: z.string(),
      reason: z.string().nullable(),
      amountCents: z.number().int(),
      createdAt: z.string(),
    }),
  ),
});

export const syncPushOperationSchema = z.object({
  opId: z.string(),
  deviceId: z.string(),
  householdId: z.string(),
  entityType: syncEntityTypeSchema,
  entityId: z.string(),
  operationType: z.enum(["create", "update", "delete", "resolve"]),
  baseVersion: z.number().int().nonnegative(),
  payload: z.record(z.unknown()),
  createdAt: z.string(),
}).superRefine((operation, context) => {
  let schema: z.ZodTypeAny | undefined;
  switch (operation.entityType) {
    case "transaction":
      schema = syncTransactionPayloadSchema;
      break;
    case "person":
      schema = syncPersonPayloadSchema;
      break;
    case "account":
      schema = syncAccountPayloadSchema;
      break;
    case "category":
      schema = syncCategoryPayloadSchema;
      break;
    case "costCenter":
      schema = syncCostCenterPayloadSchema;
      break;
    case "creditCardLimitGroup":
      schema = syncCreditCardLimitGroupPayloadSchema;
      break;
    case "creditCard":
      schema = syncCreditCardPayloadSchema;
      break;
    case "invoicePayment":
      schema = syncInvoicePaymentPayloadSchema;
      break;
  }
  if (schema === undefined) return;
  const payload = schema.safeParse(operation.payload);
  if (!payload.success) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      message: `invalid_${operation.entityType}_sync_payload`,
      path: ["payload"],
    });
    return;
  }
  const field = registryPayloadField[operation.entityType];
  if (field) {
    const row = (payload.data as Record<string, Record<string, unknown>>)[field];
    if (row.id !== operation.entityId) {
      context.addIssue({
        code: z.ZodIssueCode.custom,
        message: "registry_entity_id_mismatch",
        path: ["entityId"],
      });
    }
    if (row.householdId !== operation.householdId) {
      context.addIssue({
        code: z.ZodIssueCode.custom,
        message: "registry_household_id_mismatch",
        path: ["householdId"],
      });
    }
  }
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

export const passwordAuthRequestSchema = z.object({
  email: z.string().trim().email().max(254),
  password: z.string().min(9).max(256),
  name: z.string().trim().min(1).max(100).optional(),
});

export type Transaction = z.infer<typeof transactionSchema>;
export type SyncEntityType = z.infer<typeof syncEntityTypeSchema>;
export type SyncPushOperation = z.infer<typeof syncPushOperationSchema>;
export type SyncPushRequest = z.infer<typeof syncPushRequestSchema>;
export type SyncOperationResult = z.infer<typeof syncOperationResultSchema>;
export type SyncPullQuery = z.infer<typeof syncPullQuerySchema>;
export type GoogleAuthRequest = z.infer<typeof googleAuthRequestSchema>;
