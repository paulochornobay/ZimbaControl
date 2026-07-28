import cors from "@fastify/cors";
import Fastify from "fastify";
import { syncPushRequestSchema, type SyncOperationResult } from "./contracts.js";

type StoredOperation = {
  opId: string;
  result: SyncOperationResult;
  entityId: string;
  seq: number;
};

const operations = new Map<string, StoredOperation>();
let seq = 0;

export function buildApp() {
  const app = Fastify({
    logger: true,
  });

  app.register(cors, {
    origin: true,
  });

  app.get("/health", async () => ({
    ok: true,
    service: "zimbacontrol-api",
  }));

  app.post("/sync/push", async (request, reply) => {
    const parsed = syncPushRequestSchema.safeParse(request.body);

    if (!parsed.success) {
      return reply.code(400).send({
        error: "invalid_sync_push",
        issues: parsed.error.issues,
      });
    }

    const results = parsed.data.operations.map((operation) => {
      const existing = operations.get(operation.opId);

      if (existing) {
        return {
          opId: operation.opId,
          result: "duplicate" as const,
          entityId: existing.entityId,
          seq: existing.seq,
        };
      }

      const result: SyncOperationResult =
        operation.baseVersion < 0 ? "rejected" : "applied";
      const stored = {
        opId: operation.opId,
        result,
        entityId: operation.entityId,
        seq: ++seq,
      };

      operations.set(operation.opId, stored);
      return stored;
    });

    return {
      results,
      latestSeq: seq,
    };
  });

  app.get<{
    Querystring: {
      householdId?: string;
      sinceSeq?: string;
    };
  }>("/sync/pull", async (request, reply) => {
    if (!request.query.householdId) {
      return reply.code(400).send({
        error: "missing_household_id",
      });
    }

    const sinceSeq = Number(request.query.sinceSeq ?? 0);
    const events = [...operations.values()].filter((op) => op.seq > sinceSeq);

    return {
      events,
      latestSeq: seq,
    };
  });

  app.get("/transactions", async () => ({
    data: [],
  }));

  app.post("/transactions", async (_request, reply) =>
    reply.code(501).send({ error: "not_implemented_yet" }),
  );

  app.patch("/transactions/:id", async (_request, reply) =>
    reply.code(501).send({ error: "not_implemented_yet" }),
  );

  app.post("/imports", async (_request, reply) =>
    reply.code(501).send({ error: "not_implemented_yet" }),
  );

  app.post("/duplicates/:id/resolve", async (_request, reply) =>
    reply.code(501).send({ error: "not_implemented_yet" }),
  );

  app.post("/review/:id/resolve", async (_request, reply) =>
    reply.code(501).send({ error: "not_implemented_yet" }),
  );

  app.get("/rules", async () => ({
    data: [],
  }));

  app.post("/rules", async (_request, reply) =>
    reply.code(501).send({ error: "not_implemented_yet" }),
  );

  app.patch("/rules/:id", async (_request, reply) =>
    reply.code(501).send({ error: "not_implemented_yet" }),
  );

  return app;
}
