import type { Collection, Db, MongoClient } from "mongodb";

export type NotificationEvent = {
  id: string;
  packageName: string;
  appLabel?: string;
  title?: string;
  text?: string;
  bigText?: string;
  notificationId?: number;
  tag?: string;
  postedAt: number;
  capturedAt: number;
};

type StoredNotification = NotificationEvent & {
  householdId: string;
  status: "pending_review" | "resolved";
  createdAt: string;
  resolvedAt?: string;
};

export interface NotificationStore {
  init(): Promise<void>;
  close(): Promise<void>;
  acceptBatch(householdId: string, events: unknown[]): Promise<string[]>;
  /** Removes notification content once the financial review is complete. */
  resolve(householdId: string, id: string): Promise<boolean>;
}

export class MemoryNotificationStore implements NotificationStore {
  private readonly events = new Map<string, StoredNotification>();
  async init(): Promise<void> {}
  async close(): Promise<void> {}

  async acceptBatch(householdId: string, events: unknown[]): Promise<string[]> {
    const accepted: string[] = [];
    for (const value of events) {
      const event = parseEvent(value);
      const key = `${householdId}:${event.id}`;
      if (!this.events.has(key)) {
        this.events.set(key, { ...event, householdId, status: "pending_review", createdAt: new Date().toISOString() });
      }
      accepted.push(event.id);
    }
    return accepted;
  }

  async resolve(householdId: string, id: string): Promise<boolean> {
    const current = this.events.get(`${householdId}:${id}`);
    if (!current) return false;
    this.events.set(`${householdId}:${id}`, {
      id: current.id,
      packageName: current.packageName,
      postedAt: current.postedAt,
      capturedAt: current.capturedAt,
      householdId,
      status: "resolved",
      createdAt: current.createdAt,
      resolvedAt: new Date().toISOString(),
    });
    return true;
  }
}

export class MongoNotificationStore implements NotificationStore {
  private events!: Collection<StoredNotification>;
  constructor(private readonly client: MongoClient, private readonly databaseName: string) {}

  async init(): Promise<void> {
    await this.client.connect();
    const db: Db = this.client.db(this.databaseName);
    this.events = db.collection<StoredNotification>("notification_events");
    await this.events.createIndex({ householdId: 1, id: 1 }, { unique: true });
    await this.events.createIndex({ householdId: 1, status: 1, capturedAt: -1 });
  }

  async close(): Promise<void> { await this.client.close(); }

  async acceptBatch(householdId: string, values: unknown[]): Promise<string[]> {
    const events = values.map(parseEvent);
    if (events.length === 0) return [];
    const now = new Date().toISOString();
    await this.events.bulkWrite(events.map((event) => ({
      updateOne: {
        filter: { householdId, id: event.id },
        update: { $setOnInsert: { ...event, householdId, status: "pending_review", createdAt: now } },
        upsert: true,
      },
    })));
    return events.map((event) => event.id);
  }

  async resolve(householdId: string, id: string): Promise<boolean> {
    const result = await this.events.updateOne(
      { householdId, id, status: "pending_review" },
      {
        $set: { status: "resolved", resolvedAt: new Date().toISOString() },
        $unset: { title: "", text: "", bigText: "" },
      },
    );
    return result.matchedCount === 1;
  }
}

function parseEvent(value: unknown): NotificationEvent {
  if (!value || typeof value !== "object") throw new Error("invalid_notification_event");
  const event = value as Record<string, unknown>;
  if (typeof event.id !== "string" || event.id.length === 0 || event.id.length > 512) {
    throw new Error("invalid_notification_event_id");
  }
  if (typeof event.packageName !== "string" || event.packageName.length === 0 || event.packageName.length > 256) {
    throw new Error("invalid_notification_package");
  }
  if (!Number.isFinite(event.postedAt) || !Number.isFinite(event.capturedAt)) {
    throw new Error("invalid_notification_timestamp");
  }
  return {
    id: event.id,
    packageName: event.packageName,
    appLabel: stringOrUndefined(event.appLabel, 256),
    title: stringOrUndefined(event.title, 2_000),
    text: stringOrUndefined(event.text, 8_000),
    bigText: stringOrUndefined(event.bigText, 16_000),
    notificationId: typeof event.notificationId === "number" && Number.isInteger(event.notificationId) ? event.notificationId : undefined,
    tag: stringOrUndefined(event.tag, 512),
    postedAt: event.postedAt as number,
    capturedAt: event.capturedAt as number,
  };
}

function stringOrUndefined(value: unknown, max: number): string | undefined {
  return typeof value === "string" ? value.slice(0, max) : undefined;
}
