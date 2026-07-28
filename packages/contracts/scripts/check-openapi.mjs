import { readdirSync, readFileSync } from "node:fs";

const openapi = JSON.parse(readFileSync(new URL("../openapi.json", import.meta.url)));

if (openapi.openapi !== "3.1.0") {
  throw new Error("OpenAPI document must use 3.1.0");
}

for (const path of ["/sync/push", "/sync/pull", "/transactions"]) {
  if (!openapi.paths[path]) {
    throw new Error(`Missing path ${path}`);
  }
}

const schemas = readdirSync(new URL("../schemas", import.meta.url)).filter((name) =>
  name.endsWith(".schema.json"),
);

for (const schema of schemas) {
  const parsed = JSON.parse(
    readFileSync(new URL(`../schemas/${schema}`, import.meta.url)),
  );
  if (!parsed.$schema || !parsed.title || parsed.type !== "object") {
    throw new Error(`Invalid schema shape: ${schema}`);
  }
}

console.log("OpenAPI contract looks structurally valid.");
