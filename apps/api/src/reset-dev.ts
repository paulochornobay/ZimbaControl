import "dotenv/config";
import { MongoClient } from "mongodb";

/**
 * Deliberate development-only reset. It is never called by the API and refuses
 * to run without an explicit confirmation, so an application request cannot
 * erase a real account.
 */
async function main() {
  if (process.env.NODE_ENV !== "development" || process.env.CONFIRM_ZIMBA_DEV_RESET !== "RESET_LOCAL_DEVELOPMENT_DATA") {
    throw new Error("refusing_reset: set NODE_ENV=development and CONFIRM_ZIMBA_DEV_RESET=RESET_LOCAL_DEVELOPMENT_DATA");
  }
  const uri = process.env.MONGODB_URI;
  if (!uri) throw new Error("MONGODB_URI is required");
  const client = new MongoClient(uri);
  try {
    await client.connect();
    const db = client.db(process.env.MONGODB_DB ?? "zimbacontrol");
    const names = [
      "users", "households", "memberships", "entities", "sync_operations",
      "sync_events", "sync_cursors", "devices", "conflicts", "notification_events",
    ];
    await Promise.all(names.map((name) => db.collection(name).deleteMany({})));
    console.log(`Development data removed from ${db.databaseName}.`);
  } finally {
    await client.close();
  }
}

void main();
