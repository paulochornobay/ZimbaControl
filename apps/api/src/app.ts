import cors from "@fastify/cors";
import Fastify, { type FastifyReply, type FastifyRequest } from "fastify";
import { MongoClient } from "mongodb";
import {
  AuthError,
  ensureAllowedEmail,
  GoogleOidcVerifier,
  type GoogleTokenVerifier,
  SessionService,
} from "./auth.js";
import { loadConfig, type ApiConfig } from "./config.js";
import {
  googleAuthRequestSchema,
  passwordAuthRequestSchema,
  syncEntityTypeSchema,
  syncPullQuerySchema,
  syncPushRequestSchema,
} from "./contracts.js";
import {
  MemorySyncStore,
  MongoSyncStore,
  type SyncStore,
} from "./sync-store.js";
import {
  IdentityError,
  MemoryIdentityStore,
  MongoIdentityStore,
  type IdentityStore,
} from "./identity-store.js";

type BuildAppOptions = {
  config?: ApiConfig;
  syncStore?: SyncStore;
  googleVerifier?: GoogleTokenVerifier;
  identityStore?: IdentityStore;
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
  const sessionService = new SessionService(config);
  const storageMode = config.mongodbUri ? "mongodb" : "memory";
  const app = Fastify({
    logger: true,
  });

  app.register(cors, {
    origin:
      (config.corsOrigins?.length ?? 0) === 0 ? false : config.corsOrigins,
    credentials: true,
  });

  app.addHook("onReady", async () => {
    await syncStore.init();
    await identityStore.init();
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
      const user = await googleVerifier.verify(
        parsed.data.idToken,
        config.googleOidcAudience,
      );
      ensureAllowedEmail(config, user.email);
      const token = await sessionService.create(user);
      return {
        token,
        expiresInSeconds: config.sessionTtlSeconds,
        user,
      };
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

  app.post("/sync/push", async (request, reply) => {
    const unauthorized = await requireSyncAuth(request, reply);
    if (unauthorized) {
      return;
    }

    const parsed = syncPushRequestSchema.safeParse(request.body);

    if (!parsed.success) {
      return reply.code(400).send({
        error: "invalid_sync_push",
        issues: parsed.error.issues,
      });
    }

    const results = [];
    for (const operation of parsed.data.operations) {
      results.push(await syncStore.pushOperation(operation));
    }
    const latestSeq = await syncStore.latestSeq(parsed.data.householdId);

    return {
      results,
      latestSeq,
    };
  });

  app.get("/sync/pull", async (request, reply) => {
    const unauthorized = await requireSyncAuth(request, reply);
    if (unauthorized) {
      return;
    }

    const parsed = syncPullQuerySchema.safeParse(request.query);

    if (!parsed.success) {
      return reply.code(400).send({
        error: "invalid_sync_pull",
        issues: parsed.error.issues,
      });
    }

    const events = await syncStore.pullEvents(
      parsed.data.householdId,
      parsed.data.sinceSeq,
    );
    const latestSeq = await syncStore.latestSeq(parsed.data.householdId);

    return {
      events,
      latestSeq,
    };
  });

  app.get("/data/entities", async (request, reply) => {
    const unauthorized = await requireSyncAuth(request, reply);
    if (unauthorized) return;
    const query = request.query as { householdId?: string; entityType?: string };
    if (!query.householdId || !query.entityType) {
      return reply.code(400).send({ error: "householdId_and_entityType_required" });
    }
    const entityType = syncEntityTypeSchema.safeParse(query.entityType);
    if (!entityType.success) {
      return reply.code(400).send({ error: "invalid_entity_type" });
    }
    return { data: await syncStore.listEntitySnapshots(query.householdId, entityType.data) };
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

  async function requireSyncAuth(
    request: FastifyRequest,
    reply: FastifyReply,
  ): Promise<boolean> {
    if (!config.googleOidcEnabled && !config.passwordAuthEnabled) {
      return false;
    }

    const authorization = request.headers.authorization;
    const token = authorization?.startsWith("Bearer ")
      ? authorization.slice("Bearer ".length).trim()
      : undefined;

    if (!token) {
      reply.code(401).send({ error: "missing_session" });
      return true;
    }

    try {
      const user = await sessionService.verify(token);
      ensureAllowedEmail(config, user.email);
      if (config.passwordAuthEnabled && !(await identityStore.isMember(user.sub, parsedHouseholdId(request)))) {
        reply.code(403).send({ error: "household_not_allowed" });
        return true;
      }
      return false;
    } catch (error) {
      if (error instanceof AuthError) {
        reply.code(error.statusCode).send({ error: error.message });
        return true;
      }
      reply.code(401).send({ error: "invalid_session" });
      return true;
    }
  }

  async function sessionResponse(identity: {
    id: string;
    email: string;
    householdId: string;
    role: "admin" | "member";
    name?: string;
  }) {
    const user = {
      sub: identity.id,
      email: identity.email,
      householdId: identity.householdId,
      role: identity.role,
      name: identity.name,
    };
    return {
      token: await sessionService.create(user),
      expiresInSeconds: config.sessionTtlSeconds,
      user,
    };
  }
}

function parsedHouseholdId(request: FastifyRequest): string {
  const query = request.query as { householdId?: string };
  const body = request.body as { householdId?: string } | undefined;
  return body?.householdId ?? query.householdId ?? "";
}
