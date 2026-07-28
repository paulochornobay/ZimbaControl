import assert from "node:assert/strict";
import { test } from "node:test";
import { buildApp } from "../src/app.js";

test("POST /sync/push applies an operation once and treats retry as duplicate", async () => {
  const app = buildApp();
  await app.ready();

  const body = {
    deviceId: "device-local",
    householdId: "household-main",
    operations: [
      {
        opId: "op-1",
        deviceId: "device-local",
        householdId: "household-main",
        entityType: "transaction",
        entityId: "tx-1",
        operationType: "create",
        baseVersion: 0,
        payload: { descriptionRaw: "Mercado Extra" },
        createdAt: "2026-07-28T12:00:00.000Z",
      },
    ],
  };

  const first = await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: body,
  });

  assert.equal(first.statusCode, 200);
  assert.equal(first.json().results[0].result, "applied");

  const second = await app.inject({
    method: "POST",
    url: "/sync/push",
    payload: body,
  });

  assert.equal(second.statusCode, 200);
  assert.equal(second.json().results[0].result, "duplicate");

  await app.close();
});
