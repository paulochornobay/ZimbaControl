import { OAuth2Client } from "google-auth-library";
import { jwtVerify, SignJWT } from "jose";
import type { ApiConfig } from "./config.js";

export type AuthenticatedUser = {
  sub: string;
  email: string;
  name?: string;
  picture?: string;
};

export type GoogleTokenVerifier = {
  verify(idToken: string, audience: string): Promise<AuthenticatedUser>;
};

export class GoogleOidcVerifier implements GoogleTokenVerifier {
  private readonly client = new OAuth2Client();

  async verify(idToken: string, audience: string): Promise<AuthenticatedUser> {
    const ticket = await this.client.verifyIdToken({
      idToken,
      audience,
    });
    const payload = ticket.getPayload();

    if (!payload?.sub || !payload.email || payload.email_verified !== true) {
      throw new AuthError("invalid_google_identity", 401);
    }

    return {
      sub: payload.sub,
      email: payload.email.toLowerCase(),
      name: payload.name,
      picture: payload.picture,
    };
  }
}

export class AuthError extends Error {
  constructor(
    message: string,
    readonly statusCode: number,
  ) {
    super(message);
  }
}

export class SessionService {
  constructor(private readonly config: ApiConfig) {}

  async create(user: AuthenticatedUser): Promise<string> {
    const secret = this.secret();
    return new SignJWT({
      email: user.email,
      name: user.name,
      picture: user.picture,
    })
      .setProtectedHeader({ alg: "HS256" })
      .setSubject(user.sub)
      .setIssuedAt()
      .setExpirationTime(`${this.config.sessionTtlSeconds}s`)
      .sign(secret);
  }

  async verify(token: string): Promise<AuthenticatedUser> {
    try {
      const { payload } = await jwtVerify(token, this.secret());
      const sub = payload.sub;
      const email = payload.email;
      if (typeof sub !== "string" || typeof email !== "string") {
        throw new AuthError("invalid_session", 401);
      }
      return {
        sub,
        email: email.toLowerCase(),
        name: typeof payload.name === "string" ? payload.name : undefined,
        picture:
          typeof payload.picture === "string" ? payload.picture : undefined,
      };
    } catch (error) {
      if (error instanceof AuthError) {
        throw error;
      }
      throw new AuthError("invalid_session", 401);
    }
  }

  private secret(): Uint8Array {
    if (!this.config.sessionJwtSecret) {
      throw new AuthError("session_secret_not_configured", 500);
    }
    return new TextEncoder().encode(this.config.sessionJwtSecret);
  }
}

export function ensureAllowedEmail(config: ApiConfig, email: string): void {
  const normalized = email.toLowerCase();
  if (
    config.allowedEmails.length > 0 &&
    !config.allowedEmails.includes(normalized)
  ) {
    throw new AuthError("email_not_allowed", 403);
  }
}

