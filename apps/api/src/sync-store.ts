import type { Collection, Db, MongoClient } from "mongodb";
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

export interface SyncStore {
  init(): Promise<void>;
  close(): Promise<void>;
  pushOperation(operation: SyncPushOperation): Promise<SyncPushResult>;
  pullEvents(householdId: string, sinceSeq: number): Promise<SyncEvent[]>;
  latestSeq(householdId: string): Promise<number>;
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
  private entities = new Map<string, { baseVersion: number }>();
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
      this.entities.set(entityKey, { baseVersion: operation.baseVersion + 1 });
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
}

export class MongoSyncStore implements SyncStore {
  private operations!: Collection<StoredOperation>;
  private events!: Collection<SyncEvent>;
  private entities!: Collection<Record<string, unknown>>;
  private devices!: Collection<Record<string, unknown>>;
  private conflicts!: Collection<Record<string, unknown>>;

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
    ]);
  }

  async close(): Promise<void> {
    await this.client.close();
  }

  async pushOperation(operation: SyncPushOperation): Promise<SyncPushResult> {
    const existing = await this.operations.findOne({ opId: operation.opId });
    if (existing) {
      return {
        opId: operation.opId,
        result: "duplicate",
        entityId: existing.entityId,
        seq: existing.seq,
      };
    }

    const result = await this.resultFor(operation);
    const seq = (await this.latestSeq(operation.householdId)) + 1;
    const serverAt = new Date().toISOString();
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
      serverAt,
    };

    await this.operations.insertOne(stored);
    await this.devices.updateOne(
      { householdId: operation.householdId, deviceId: operation.deviceId },
      {
        $set: {
          householdId: operation.householdId,
          deviceId: operation.deviceId,
          lastSeenAt: serverAt,
        },
        $setOnInsert: { createdAt: serverAt },
      },
      { upsert: true },
    );

    if (result === "applied") {
      await this.entities.updateOne(
        {
          householdId: operation.householdId,
          entityType: operation.entityType,
          entityId: operation.entityId,
        },
        {
          $set: {
            householdId: operation.householdId,
            entityType: operation.entityType,
            entityId: operation.entityId,
            payload: operation.payload,
            baseVersion: operation.baseVersion + 1,
            updatedAt: serverAt,
            deletedAt: operation.operationType === "delete" ? serverAt : null,
          },
          $setOnInsert: { createdAt: serverAt },
        },
        { upsert: true },
      );
      await this.events.insertOne({
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
        serverAt,
      });
    }

    if (result === "conflict") {
      await this.conflicts.insertOne({
        householdId: operation.householdId,
        entityType: operation.entityType,
        entityId: operation.entityId,
        opId: operation.opId,
        status: "pending_review",
        payload: operation.payload,
        baseVersion: operation.baseVersion,
        createdAt: serverAt,
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
    const rows = await this.events
      .find({ householdId, seq: { $gt: sinceSeq } })
      .sort({ seq: 1 })
      .toArray();
    return rows.map(({ _id: _ignored, ...event }) => event as SyncEvent);
  }

  async latestSeq(householdId: string): Promise<number> {
    const latest = await this.events
      .find({ householdId })
      .sort({ seq: -1 })
      .limit(1)
      .next();
    return latest?.seq ?? 0;
  }

  private async resultFor(operation: SyncPushOperation): Promise<SyncOperationResult> {
    if (operation.baseVersion < 0) {
      return "rejected";
    }

    if (operation.operationType === "create") {
      return "applied";
    }

    const existing = await this.entities.findOne({
      householdId: operation.householdId,
      entityType: operation.entityType,
      entityId: operation.entityId,
    });
    const existingVersion = Number(existing?.baseVersion ?? 0);
    if (existing && existingVersion !== operation.baseVersion) {
      return "conflict";
    }

    return "applied";
  }
}
