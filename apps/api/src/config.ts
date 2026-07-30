export type ApiConfig = {
  nodeEnv: string;
  port: number;
  host: string;
  mongodbUri?: string;
  mongodbDb: string;
  defaultHouseholdId: string;
  allowDevAuth: boolean;
  devDeviceSecret?: string;
  googleOidcEnabled: boolean;
  googleOidcAudience?: string;
  allowedEmails: string[];
  sessionJwtSecret?: string;
  sessionTtlSeconds: number;
};

export function loadConfig(env: NodeJS.ProcessEnv = process.env): ApiConfig {
  return {
    nodeEnv: env.NODE_ENV ?? "development",
    port: Number(env.PORT ?? 3333),
    host: env.HOST ?? "0.0.0.0",
    mongodbUri: optional(env.MONGODB_URI),
    mongodbDb: env.MONGODB_DB ?? "zimbacontrol",
    defaultHouseholdId: env.SYNC_DEFAULT_HOUSEHOLD_ID ?? "household-main",
    allowDevAuth: env.SYNC_ALLOW_DEV_AUTH !== "false",
    devDeviceSecret: optional(env.SYNC_DEV_DEVICE_SECRET),
    googleOidcEnabled: env.GOOGLE_OIDC_ENABLED === "true",
    googleOidcAudience: optional(env.GOOGLE_OIDC_AUDIENCE),
    allowedEmails: (env.ALLOWED_EMAILS ?? "")
      .split(",")
      .map((email) => email.trim().toLowerCase())
      .filter(Boolean),
    sessionJwtSecret: optional(env.SESSION_JWT_SECRET),
    sessionTtlSeconds: Number(env.SESSION_TTL_SECONDS ?? 2_592_000),
  };
}

function optional(value: string | undefined): string | undefined {
  if (!value || value.trim().length === 0) {
    return undefined;
  }
  return value;
}
