import {
  randomBytes,
  scrypt as scryptCallback,
  timingSafeEqual,
  randomUUID,
} from "node:crypto";
import { promisify } from "node:util";
import type { Collection, Db, MongoClient } from "mongodb";

const scrypt = promisify(scryptCallback);

export type Identity = {
  id: string;
  email: string;
  householdId: string;
  role: "admin" | "member";
  name?: string;
};

type StoredUser = Identity & {
  passwordHash: string;
  createdAt: string;
};

export class IdentityError extends Error {
  constructor(message: "email_already_registered" | "invalid_credentials") {
    super(message);
  }
}

export interface IdentityStore {
  init(): Promise<void>;
  close(): Promise<void>;
  register(input: { email: string; password: string; name?: string }): Promise<Identity>;
  authenticate(email: string, password: string): Promise<Identity>;
  isMember(userId: string, householdId: string): Promise<boolean>;
  ensureAdmin(input: { email: string; password: string; name?: string }): Promise<Identity>;
}

export class MemoryIdentityStore implements IdentityStore {
  private readonly usersByEmail = new Map<string, StoredUser>();

  async init(): Promise<void> {}
  async close(): Promise<void> {}

  async register(input: { email: string; password: string; name?: string }): Promise<Identity> {
    const email = normalizeEmail(input.email);
    if (this.usersByEmail.has(email)) throw new IdentityError("email_already_registered");
    const identity = newIdentity(email, input.name);
    this.usersByEmail.set(email, { ...identity, passwordHash: await hashPassword(input.password), createdAt: new Date().toISOString() });
    return identity;
  }

  async authenticate(email: string, password: string): Promise<Identity> {
    const user = this.usersByEmail.get(normalizeEmail(email));
    if (!user || !(await verifyPassword(password, user.passwordHash))) {
      throw new IdentityError("invalid_credentials");
    }
    return publicIdentity(user);
  }

  async isMember(userId: string, householdId: string): Promise<boolean> {
    return [...this.usersByEmail.values()].some(
      (user) => user.id === userId && user.householdId === householdId,
    );
  }

  async ensureAdmin(input: { email: string; password: string; name?: string }): Promise<Identity> {
    const existing = this.usersByEmail.get(normalizeEmail(input.email));
    if (existing) return publicIdentity(existing);
    return this.register(input);
  }
}

export class MongoIdentityStore implements IdentityStore {
  private users!: Collection<StoredUser>;
  private households!: Collection<Record<string, unknown>>;
  private memberships!: Collection<Record<string, unknown>>;

  constructor(private readonly client: MongoClient, private readonly databaseName: string) {}

  async init(): Promise<void> {
    await this.client.connect();
    const db: Db = this.client.db(this.databaseName);
    this.users = db.collection<StoredUser>("users");
    this.households = db.collection<Record<string, unknown>>("households");
    this.memberships = db.collection<Record<string, unknown>>("memberships");
    await Promise.all([
      this.users.createIndex({ email: 1 }, { unique: true }),
      this.memberships.createIndex({ userId: 1, householdId: 1 }, { unique: true }),
    ]);
  }

  async close(): Promise<void> {
    await this.client.close();
  }

  async register(input: { email: string; password: string; name?: string }): Promise<Identity> {
    const email = normalizeEmail(input.email);
    const identity = newIdentity(email, input.name);
    const passwordHash = await hashPassword(input.password);
    const session = this.client.startSession();
    try {
      await session.withTransaction(async () => {
        const exists = await this.users.findOne({ email }, { session });
        if (exists) throw new IdentityError("email_already_registered");
        const now = new Date().toISOString();
        await this.users.insertOne({ ...identity, passwordHash, createdAt: now }, { session });
        await this.households.insertOne({ id: identity.householdId, ownerUserId: identity.id, createdAt: now }, { session });
        await this.memberships.insertOne({ userId: identity.id, householdId: identity.householdId, role: "admin", createdAt: now }, { session });
      });
      return identity;
    } finally {
      await session.endSession();
    }
  }

  async authenticate(email: string, password: string): Promise<Identity> {
    const user = await this.users.findOne({ email: normalizeEmail(email) });
    if (!user || !(await verifyPassword(password, user.passwordHash))) {
      throw new IdentityError("invalid_credentials");
    }
    return publicIdentity(user);
  }

  async isMember(userId: string, householdId: string): Promise<boolean> {
    return (await this.memberships.findOne({ userId, householdId })) !== null;
  }

  async ensureAdmin(input: { email: string; password: string; name?: string }): Promise<Identity> {
    const existing = await this.users.findOne({ email: normalizeEmail(input.email) });
    return existing ? publicIdentity(existing) : this.register(input);
  }
}

function newIdentity(email: string, name?: string): Identity {
  return { id: `user-${randomUUID()}`, email, householdId: `household-${randomUUID()}`, role: "admin", name };
}

function publicIdentity(user: StoredUser): Identity {
  const { passwordHash: _passwordHash, createdAt: _createdAt, ...identity } = user;
  return identity;
}

function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

export async function hashPassword(password: string): Promise<string> {
  const salt = randomBytes(16);
  const derived = (await scrypt(password, salt, 64)) as Buffer;
  return `scrypt$${salt.toString("hex")}$${derived.toString("hex")}`;
}

async function verifyPassword(password: string, encoded: string): Promise<boolean> {
  const [algorithm, saltHex, hashHex] = encoded.split("$");
  if (algorithm !== "scrypt" || !saltHex || !hashHex) return false;
  const actual = (await scrypt(password, Buffer.from(saltHex, "hex"), 64)) as Buffer;
  const expected = Buffer.from(hashHex, "hex");
  return actual.length === expected.length && timingSafeEqual(actual, expected);
}
