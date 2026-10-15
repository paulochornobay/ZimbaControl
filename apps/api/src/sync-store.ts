import type { Collection, Db, MongoClient, ClientSession } from "mongodb";
import { randomUUID } from "node:crypto";
import type { SyncOperationResult, SyncPushOperation } from "./contracts.js";

export type SyncEvent = {
  seq: number;
  opId: string;
  deviceId: string;
  householdId: string;
  entityType: SyncPushOperation["entityType"];
  entityId: string;
  operationType: SyncPushOperation["operationType"];
  baseVersion: number;
  payload: Record<string, unknown>;
  createdAt: string;
  serverAt: string;
};

export type SyncPushResult = {
  opId: string;
  result: SyncOperationResult;
  entityId: string;
  seq: number;
};

export type EntitySnapshot = {
  entityId: string;
  entityType: SyncPushOperation["entityType"];
  baseVersion: number;
  payload: Record<string, unknown>;
  updatedAt?: string;
  deletedAt?: boolean;
};

export type SyncDevice = {
  deviceId: string;
  lastSeenAt: string;
};

export type OwnerProfile = {
  userId: string;
  email: string;
  householdId: string;
};

export function ownerPersonId(userId: string): string {
  return `person-${userId}`;
}

export interface SyncStore {
  init(): Promise<void>;
  close(): Promise<void>;
  pushOperation(operation: SyncPushOperation): Promise<SyncPushResult>;
  pullEvents(householdId: string, sinceSeq: number): Promise<SyncEvent[]>;
  latestSeq(householdId: string): Promise<number>;
  listEntitySnapshots(householdId: string, entityType: SyncPushOperation["entityType"]): Promise<EntitySnapshot[]>;
  listDevices(householdId: string): Promise<SyncDevice[]>;
  ensureOwnerProfile(owner: OwnerProfile): Promise<void>;
}

/**
 * Keeps the financial owner deterministic and repairs legacy records without
 * creating a second person. This is deliberately part of the sync store so
 * every client (Web and mobile) observes the same data contract.
 */
async function ensureOwnerProfileForStore(
  store: Pick<SyncStore, "listEntitySnapshots" | "pushOperation">,
  owner: OwnerProfile,
): Promise<void> {
  const id = ownerPersonId(owner.userId);
  const now = new Date().toISOString();
  const operation = async (
    snapshot: EntitySnapshot | undefined,
    entityType: SyncPushOperation["entityType"],
    entityId: string,
    payload: Record<string, unknown>,
  ) => {
    await store.pushOperation({
      opId: `owner-reconcile-${randomUUID()}`,
      deviceId: "server-owner-reconcile",
      householdId: owner.householdId,
      entityType,
      entityId,
      operationType: "update",
      baseVersion: snapshot?.baseVersion ?? 0,
      payload,
      createdAt: now,
    });
  };

  const people = await store.listEntitySnapshots(owner.householdId, "person");
  const currentOwner = people.find((person) => person.entityId === id);
  const ownerRow = currentOwner?.payload.person as Record<string, unknown> | undefined;
  const displayName = typeof ownerRow?.displayName === "string" && ownerRow.displayName.trim().length > 0
    ? ownerRow.displayName.trim()
    : owner.email;
  const canonicalOwner = {
    schemaVersion: 1,
    person: {
      id,
      householdId: owner.householdId,
      displayName,
      kind: "adult",
      relationship: "self",
      active: true,
    },
  };
  if (
    !ownerRow ||
    ownerRow.kind !== "adult" ||
    ownerRow.relationship !== "self" ||
    ownerRow.active !== true
  ) {
    await operation(currentOwner, "person", id, canonicalOwner);
  }

  // These are templates, not demonstration data. They are copied once when a
  // private account is created and can subsequently be changed independently.
  await ensureDefaultCatalog(store, owner);

  for (const person of people) {
    if (person.entityId === id) continue;
    const row = person.payload.person as Record<string, unknown> | undefined;
    if (!row) continue;
    const kind = row.kind === "adult" ? "other" : row.kind;
    const relationship = row.relationship === "spouse" || row.relationship === "child" || row.relationship === "other"
      ? row.relationship
      : kind === "child" ? "child" : "other";
    if (row.kind === kind && row.relationship === relationship) continue;
    await operation(person, "person", person.entityId, {
      ...person.payload,
      person: { ...row, kind, relationship },
    });
  }

  const accounts = await store.listEntitySnapshots(owner.householdId, "account");
  for (const account of accounts) {
    const row = account.payload.account as Record<string, unknown> | undefined;
    if (!row || row.ownerPersonId === id) continue;
    await operation(account, "account", account.entityId, {
      ...account.payload,
      account: { ...row, ownerPersonId: id },
    });
  }

  const cards = await store.listEntitySnapshots(owner.householdId, "creditCard");
  for (const card of cards) {
    const row = card.payload.creditCard as Record<string, unknown> | undefined;
    if (!row || row.ownerPersonId === id) continue;
    await operation(card, "creditCard", card.entityId, {
      ...card.payload,
      creditCard: { ...row, ownerPersonId: id },
    });
  }

  const transactions = await store.listEntitySnapshots(owner.householdId, "transaction");
  for (const transaction of transactions) {
    const row = transaction.payload.transaction as Record<string, unknown> | undefined;
    const beneficiaries = Array.isArray(transaction.payload.beneficiaries)
      ? transaction.payload.beneficiaries
      : [];
    if (!row || (row.payerId === id && beneficiaries.length > 0)) continue;
    await operation(transaction, "transaction", transaction.entityId, {
      ...transaction.payload,
      transaction: { ...row, payerId: id },
      beneficiaries:
        beneficiaries.length > 0
          ? beneficiaries
          : [ownerBeneficiary(transaction.entityId, id)],
    });
  }
}

async function ensureDefaultCatalog(
  store: Pick<SyncStore, "listEntitySnapshots" | "pushOperation">,
  owner: OwnerProfile,
): Promise<void> {
  const current = await store.listEntitySnapshots(owner.householdId, "category");
  const known = new Set(current.map((item) => item.entityId));
  const now = new Date().toISOString();
  const templates = [
    ["alimentacao", "AlimentaÃ§Ã£o", "expense", "cart", "amber"],
    ["moradia", "Moradia", "expense", "home", "blue"],
    ["transporte", "Transporte", "expense", "car", "violet"],
    ["saude", "SaÃºde", "expense", "heart-pulse", "red"],
    ["receitas", "Receitas", "income", "wallet", "green"],
  ] as const;
  const templateLabels = {
    alimentacao: "Alimenta\u00e7\u00e3o",
    moradia: "Moradia",
    transporte: "Transporte",
    saude: "Sa\u00fade",
    receitas: "Receitas",
  } as const;
  await Promise.all(templates.filter(([key]) => !known.has(`category-system-${key}`)).map(async ([key, , kind, iconKey, colorKey], index) => {
    const entityId = `category-system-${key}`;
    await store.pushOperation({
      opId: `catalog-${owner.householdId}-${key}`,
      deviceId: "server-catalog-provisioning",
      householdId: owner.householdId,
      entityType: "category",
      entityId,
      operationType: "create",
      baseVersion: 0,
      payload: {
        schemaVersion: 1,
        category: {
          id: entityId, householdId: owner.householdId, parentId: null, systemKey: key,
          name: templateLabels[key], kind, iconKey, colorKey, sortOrder: (index + 1) * 10,
          isDefault: true, isHidden: false, active: true, createdAt: now, updatedAt: now,
        },
      },
      createdAt: now,
    });
  }));

  // Corrige somente os rótulos de template que foram gravados com codificação
  // quebrada em versões anteriores, sem sobrescrever nomes personalizados.
  await Promise.all(templates.map(async ([key, , kind, iconKey, colorKey], index) => {
    const snapshot = current.find((item) => item.entityId === `category-system-${key}`);
    const category = snapshot?.payload.category as Record<string, unknown> | undefined;
    const name = typeof category?.name === "string" ? category.name : "";
    if (!snapshot || !category || (!name.includes("\u00c3") && !name.includes("\u00c2"))) return;
    await store.pushOperation({
      opId: `catalog-text-repair-${owner.householdId}-${key}-${randomUUID()}`,
      deviceId: "server-catalog-provisioning",
      householdId: owner.householdId,
      entityType: "category",
      entityId: snapshot.entityId,
      operationType: "update",
      baseVersion: snapshot.baseVersion,
      payload: {
        schemaVersion: 1,
        category: {
          ...category, id: snapshot.entityId, householdId: owner.householdId, systemKey: key,
          name: templateLabels[key], kind, iconKey, colorKey, sortOrder: (index + 1) * 10,
          isDefault: true, isHidden: category.isHidden === true, active: category.active !== false,
          updatedAt: now,
        },
      },
      createdAt: now,
    });
  }));
}

function ownerBeneficiary(transactionId: string, personId: string) {
  return {
    id: `beneficiary-${transactionId}-${personId}`,
    transactionId,
    personId,
    allocationMode: "full",
    allocatedAmountCents: null,
    allocatedPercent: null,
    isPrimary: true,
  };
}

type StoredOperation = SyncPushResult & {
  deviceId: string;
  householdId: string;
  entityType: SyncPushOperation["entityType"];
  operationType: SyncPushOperation["operationType"];
  baseVersion: number;
  payload: Record<string, unknown>;
  createdAt: string;
  serverAt: string;
};

export class MemorySyncStore implements SyncStore {
  private operations = new Map<string, StoredOperation>();
  private entities = new Map<string, EntitySnapshot>();
  private events: SyncEvent[] = [];
  private seq = 0;

  async init(): Promise<void> {
    return;
  }

  async close(): Promise<void> {
    return;
  }

  async pushOperation(operation: SyncPushOperation): Promise<SyncPushResult> {
    const existing = this.operations.get(operation.opId);
    if (existing) {
      return {
        opId: operation.opId,
        result: "duplicate",
        entityId: existing.entityId,
        seq: existing.seq,
      };
    }

    const entityKey = [
      operation.householdId,
      operation.entityType,
      operation.entityId,
    ].join(":");
    const existingEntity = this.entities.get(entityKey);
    const result: SyncOperationResult =
      operation.baseVersion < 0
        ? "rejected"
        : existingEntity &&
            operation.operationType !== "create" &&
            existingEntity.baseVersion !== operation.baseVersion
          ? "conflict"
          : "applied";
    const seq = ++this.seq;
    const stored: StoredOperation = {
      opId: operation.opId,
      result,
      entityId: operation.entityId,
      seq,
      deviceId: operation.deviceId,
      householdId: operation.householdId,
      entityType: operation.entityType,
      operationType: operation.operationType,
      baseVersion: operation.baseVersion,
      payload: operation.payload,
      createdAt: operation.createdAt,
      serverAt: new Date().toISOString(),
    };
    this.operations.set(operation.opId, stored);

    if (result === "applied") {
      this.entities.set(entityKey, {
        entityId: operation.entityId,
        entityType: operation.entityType,
        baseVersion: operation.baseVersion + 1,
        payload: operation.payload,
        updatedAt: stored.serverAt,
        deletedAt: operation.operationType === "delete",
      });
      this.events.push({
        seq,
        opId: operation.opId,
        deviceId: operation.deviceId,
        householdId: operation.householdId,
        entityType: operation.entityType,
        entityId: operation.entityId,
        operationType: operation.operationType,
        baseVersion: operation.baseVersion,
        payload: operation.payload,
        createdAt: operation.createdAt,
        serverAt: stored.serverAt,
      });
    }

    return {
      opId: operation.opId,
      result,
      entityId: operation.entityId,
      seq,
    };
  }

  async pullEvents(householdId: string, sinceSeq: number): Promise<SyncEvent[]> {
    return this.events.filter(
      (event) => event.householdId === householdId && event.seq > sinceSeq,
    );
  }

  async latestSeq(householdId: string): Promise<number> {
    return this.events
      .filter((event) => event.householdId === householdId)
      .reduce((latest, event) => Math.max(latest, event.seq), 0);
  }

  async ensureOwnerProfile(owner: OwnerProfile): Promise<void> {
    await ensureOwnerProfileForStore(this, owner);
  }

  async listEntitySnapshots(householdId: string, entityType: SyncPushOperation["entityType"]): Promise<EntitySnapshot[]> {
    const prefix = `${householdId}:${entityType}:`;
    return [...this.entities.entries()]
      .filter(([key, entity]) => key.startsWith(prefix) && !entity.deletedAt)
      .map(([, entity]) => entity);
  }

  async listDevices(householdId: string): Promise<SyncDevice[]> {
    const devices = new Map<string, string>();
    for (const operation of this.operations.values()) {
      if (operation.householdId !== householdId) continue;
      const previous = devices.get(operation.deviceId);
      if (!previous || operation.serverAt > previous) {
        devices.set(operation.deviceId, operation.serverAt);
      }
    }
    return [...devices.entries()]
      .map(([deviceId, lastSeenAt]) => ({ deviceId, lastSeenAt }))
      .sort((left, right) => right.lastSeenAt.localeCompare(left.lastSeenAt));
  }
}

export class MongoSyncStore implements SyncStore {
  private operations!: Collection<StoredOperation>;
  private events!: Collection<SyncEvent>;
  private entities!: Collection<Record<string, unknown>>;
  private devices!: Collection<Record<string, unknown>>;
  private conflicts!: Collection<Record<string, unknown>>;
  private cursors!: Collection<{ householdId: string; latestSeq: number }>;

  constructor(
    private readonly client: MongoClient,
    private readonly databaseName: string,
  ) {}

  async init(): Promise<void> {
    await this.client.connect();
    const db: Db = this.client.db(this.databaseName);
    this.operations = db.collection<StoredOperation>("sync_operations");
    this.events = db.collection<SyncEvent>("sync_events");
    this.entities = db.collection<Record<string, unknown>>("entities");
    this.devices = db.collection<Record<string, unknown>>("devices");
    this.conflicts = db.collection<Record<string, unknown>>("conflicts");
    this.cursors = db.collection<{ householdId: string; latestSeq: number }>(
      "sync_cursors",
    );

    await Promise.all([
      this.operations.createIndex({ opId: 1 }, { unique: true }),
      this.operations.createIndex({ householdId: 1, seq: 1 }),
      this.events.createIndex({ householdId: 1, seq: 1 }, { unique: true }),
      this.entities.createIndex(
        { householdId: 1, entityType: 1, entityId: 1 },
        { unique: true },
      ),
      this.devices.createIndex({ householdId: 1, deviceId: 1 }, { unique: true }),
      this.conflicts.createIndex({ householdId: 1, entityId: 1, status: 1 }),
      this.cursors.createIndex({ householdId: 1 }, { unique: true }),
    ]);
  }

  async close(): Promise<void> {
    await this.client.close();
  }

  async pushOperation(operation: SyncPushOperation): Promise<SyncPushResult> {
    const session = this.client.startSession();
    try {
      let response: SyncPushResult | undefined;
      await session.withTransaction(async () => {
        const existing = await this.operations.findOne(
          { opId: operation.opId },
          { session },
        );
        if (existing) {
          response = {
            opId: operation.opId,
            result: "duplicate",
            entityId: existing.entityId,
            seq: existing.seq,
          };
          return;
        }

        const result = await this.resultFor(operation, session);
        const cursor = await this.cursors.findOneAndUpdate(
          { householdId: operation.householdId },
          { $inc: { latestSeq: 1 }, $setOnInsert: { householdId: operation.householdId } },
          { upsert: true, returnDocument: "after", session },
        );
        const seq = cursor?.latestSeq;
        if (!seq) throw new Error("sync_sequence_unavailable");
        const serverAt = new Date().toISOString();
        const stored: StoredOperation = {
          opId: operation.opId, result, entityId: operation.entityId, seq,
          deviceId: operation.deviceId, householdId: operation.householdId,
          entityType: operation.entityType, operationType: operation.operationType,
          baseVersion: operation.baseVersion, payload: operation.payload,
          createdAt: operation.createdAt, serverAt,
        };
        await this.operations.insertOne(stored, { session });
        await this.devices.updateOne(
          { householdId: operation.householdId, deviceId: operation.deviceId },
          { $set: { householdId: operation.householdId, deviceId: operation.deviceId, lastSeenAt: serverAt }, $setOnInsert: { createdAt: serverAt } },
          { upsert: true, session },
        );
        if (result === "applied") {
          await this.entities.updateOne(
            { householdId: operation.householdId, entityType: operation.entityType, entityId: operation.entityId },
            { $set: { householdId: operation.householdId, entityType: operation.entityType, entityId: operation.entityId, payload: operation.payload, baseVersion: operation.baseVersion + 1, updatedAt: serverAt, deletedAt: operation.operationType === "delete" ? serverAt : null }, $setOnInsert: { createdAt: serverAt } },
            { upsert: true, session },
          );
          await this.events.insertOne({ seq, opId: operation.opId, deviceId: operation.deviceId, householdId: operation.householdId, entityType: operation.entityType, entityId: operation.entityId, operationType: operation.operationType, baseVersion: operation.baseVersion, payload: operation.payload, createdAt: operation.createdAt, serverAt }, { session });
        }
        if (result === "conflict") {
          await this.conflicts.insertOne({ householdId: operation.householdId, entityType: operation.entityType, entityId: operation.entityId, opId: operation.opId, status: "pending_review", payload: operation.payload, baseVersion: operation.baseVersion, createdAt: serverAt }, { session });
        }
        response = { opId: operation.opId, result, entityId: operation.entityId, seq };
      });
      if (!response) throw new Error("sync_operation_unavailable");
      return response;
    } finally {
      await session.endSession();
    }
  }

  async pullEvents(householdId: string, sinceSeq: number): Promise<SyncEvent[]> {
    const rows = await this.events
      .find({ householdId, seq: { $gt: sinceSeq } })
      .sort({ seq: 1 })
      .toArray();
    return rows.map(({ _id: _ignored, ...event }) => event as SyncEvent);
  }

  async latestSeq(householdId: string): Promise<number> {
    return (await this.cursors.findOne({ householdId }))?.latestSeq ?? 0;
  }

  async listEntitySnapshots(householdId: string, entityType: SyncPushOperation["entityType"]): Promise<EntitySnapshot[]> {
    const rows = await this.entities.find({ householdId, entityType, deletedAt: null }).sort({ updatedAt: -1 }).toArray();
    return rows.map((row) => ({
      entityId: String(row.entityId),
      entityType: row.entityType as SyncPushOperation["entityType"],
      baseVersion: Number(row.baseVersion ?? 0),
      payload: row.payload as Record<string, unknown>,
      updatedAt: typeof row.updatedAt === "string" ? row.updatedAt : undefined,
    }));
  }

  async ensureOwnerProfile(owner: OwnerProfile): Promise<void> {
    await ensureOwnerProfileForStore(this, owner);
  }

  async listDevices(householdId: string): Promise<SyncDevice[]> {
    const rows = await this.devices
      .find({ householdId })
      .sort({ lastSeenAt: -1 })
      .toArray();
    return rows.flatMap((row) => {
      const deviceId = typeof row.deviceId === "string" ? row.deviceId : undefined;
      const lastSeenAt = typeof row.lastSeenAt === "string" ? row.lastSeenAt : undefined;
      return deviceId && lastSeenAt ? [{ deviceId, lastSeenAt }] : [];
    });
  }

  private async resultFor(
    operation: SyncPushOperation,
    session?: ClientSession,
  ): Promise<SyncOperationResult> {
    if (operation.baseVersion < 0) {
      return "rejected";
    }

    if (operation.operationType === "create") {
      return "applied";
    }

    const existing = await this.entities.findOne(
      { householdId: operation.householdId, entityType: operation.entityType, entityId: operation.entityId },
      { session },
    );
    const existingVersion = Number(existing?.baseVersion ?? 0);
    if (existing && existingVersion !== operation.baseVersion) {
      return "conflict";
    }

    return "applied";
  }
}
