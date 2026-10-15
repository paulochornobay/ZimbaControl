import { createHash } from "node:crypto";

export type ParsedStatementRecord = {
  rowIndex: number;
  rowHash: string;
  externalId: string | null;
  occurredAt: string | null;
  description: string | null;
  amountCents: number | null;
  currencyCode: string;
  rawPayload: string;
  error: string | null;
};

export type ParsedStatement = {
  format: "csv" | "ofx";
  provider: string;
  /** ID/número da conta quando o arquivo o expõe. */
  accountReference: string | null;
  fileHash: string;
  records: ParsedStatementRecord[];
};

/**
 * Parses the two statement formats supported by the product on the server.
 * The result deliberately retains invalid rows: the import batch is auditable
 * and the client can explain why a line was not promoted to review.
 */
export function parseStatement(fileName: string, content: string): ParsedStatement {
  const fileHash = digest(content);
  const isOfx = fileName.toLowerCase().endsWith(".ofx") || /<OFX\b/i.test(content);
  return isOfx ? parseOfx(content, fileHash) : parseCsv(fileName, content, fileHash);
}

function parseCsv(fileName: string, content: string, fileHash: string): ParsedStatement {
  const lines = content.replace(/^\uFEFF/, "").split(/\r?\n/).filter((line) => line.trim() !== "");
  if (lines.length === 0) return { format: "csv", provider: "unknown", accountReference: null, fileHash, records: [] };
  const headerIndex = lines.findIndex((line) => {
    const delimiter = delimiterFor(line);
    const fields = csvLine(line, delimiter).map(normalizeHeader);
    return fields.some((field) => ["data", "date", "release date"].includes(field))
      && fields.some((field) => ["valor", "amount", "transaction net amount"].includes(field));
  });
  if (headerIndex < 0) return { format: "csv", provider: "unknown", accountReference: null, fileHash, records: [] };

  const delimiter = delimiterFor(lines[headerIndex]);
  const header = csvLine(lines[headerIndex], delimiter).map(normalizeHeader);
  const provider = providerFor(fileName, header.join(" "));
  const field = (names: string[]) => names.find((name) => header.includes(name));
  const dateField = field(["data", "date", "data da compra", "data de operacao", "release date"]);
  const descriptionField = field(["descricao", "description", "descricao da compra", "titulo", "transaction type"]);
  const amountField = field(["valor", "amount", "valor da transacao", "total", "transaction net amount"]);
  const externalIdField = field(["id", "identificador", "codigo de operacao", "external id", "reference id"]);
  const accountField = field(["account id", "account number", "numero da conta", "id da conta", "conta"]);
  const dataLines = lines.slice(headerIndex + 1);
  const accountReference = accountField
    ? dataLines.map((line) => {
      const values = csvLine(line, delimiter);
      return values[header.indexOf(accountField)]?.trim() ?? "";
    }).find(Boolean) || null
    : null;
  const records = dataLines.map((line, index) => {
    const values = csvLine(line, delimiter);
    const row = new Map(header.map((key, fieldIndex) => [key, values[fieldIndex]?.trim() ?? ""]));
    const occurredAt = parseDate(dateField ? row.get(dateField) ?? "" : "");
    const description = descriptionField ? row.get(descriptionField)?.trim() || null : null;
    const amountCents = parseCents(amountField ? row.get(amountField) ?? "" : "");
    const valid = occurredAt !== null && description !== null && amountCents !== null;
    return {
      rowIndex: headerIndex + index + 2,
      rowHash: digest(`${provider}|${line}`),
      externalId: externalIdField ? row.get(externalIdField)?.trim() || null : null,
      occurredAt,
      description,
      amountCents,
      currencyCode: "BRL",
      rawPayload: line,
      error: valid ? null : "Linha CSV incompleta ou inválida",
    };
  });
  return { format: "csv", provider, accountReference, fileHash, records };
}

function parseOfx(content: string, fileHash: string): ParsedStatement {
  const provider = providerFor("", `${tag(content, "ORG") ?? ""} ${tag(content, "FID") ?? ""} ${tag(content, "BANKID") ?? ""}`);
  const blocks = [...content.matchAll(/<STMTTRN>(.*?)(?=<STMTTRN>|<\/BANKTRANLIST>|<\/CCSTMTRS>|$)/gis)];
  const records = blocks.map((match, index) => {
    const block = match[1].trim();
    const occurredAt = parseDate(tag(block, "DTPOSTED") ?? tag(block, "DTUSER") ?? "");
    const name = tag(block, "NAME");
    const memo = tag(block, "MEMO");
    const description = [name, memo].filter((part): part is string => Boolean(part?.trim())).join(" - ") || null;
    const amountCents = parseCents(tag(block, "TRNAMT") ?? "");
    const valid = occurredAt !== null && description !== null && amountCents !== null;
    return {
      rowIndex: index + 1,
      rowHash: digest(`${provider}|${block}`),
      externalId: tag(block, "FITID"),
      occurredAt,
      description,
      amountCents,
      currencyCode: (tag(content, "CURDEF") ?? "BRL").toUpperCase(),
      rawPayload: block,
      error: valid ? null : "Registro OFX incompleto ou inválido",
    };
  });
  return {
    format: "ofx",
    provider,
    accountReference: tag(content, "ACCTID") ?? tag(content, "CCACCTID"),
    fileHash,
    records,
  };
}

function csvLine(line: string, delimiter: string): string[] {
  const values: string[] = [];
  let current = "";
  let quoted = false;
  for (let index = 0; index < line.length; index += 1) {
    const char = line[index];
    if (char === '"' && quoted && line[index + 1] === '"') { current += '"'; index += 1; continue; }
    if (char === '"') { quoted = !quoted; continue; }
    if (char === delimiter && !quoted) { values.push(current); current = ""; continue; }
    current += char;
  }
  values.push(current);
  return values;
}

function delimiterFor(header: string): string {
  const count = (value: string) => [...header].filter((item) => item === value).length;
  const semicolons = count(";");
  const commas = count(",");
  const tabs = count("\t");
  return tabs > semicolons && tabs > commas ? "\t" : semicolons >= commas ? ";" : ",";
}

function normalizeHeader(value: string): string {
  return value.trim().toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/[_-]+/g, " ").replace(/\s+/g, " ");
}

function providerFor(fileName: string, context: string): string {
  const value = `${fileName} ${context}`.toLowerCase();
  if (value.includes("nubank") || value.includes("identificador")) return "nubank";
  if (value.includes("mercado") || value.includes("codigo de operacao")) return "mercado_pago";
  return "unknown";
}

function tag(source: string, name: string): string | null {
  return new RegExp(`<${name}>([^<\\r\\n]*)`, "i").exec(source)?.[1]?.trim() || null;
}

function parseDate(value: string): string | null {
  const trimmed = value.trim();
  const iso = /^(\d{4})-(\d{2})-(\d{2})/.exec(trimmed);
  const brazilianDash = /^(\d{1,2})-(\d{1,2})-(\d{2,4})$/.exec(trimmed);
  const brazilian = /^(\d{1,2})\/(\d{1,2})\/(\d{2,4})$/.exec(trimmed);
  const ofx = /^(\d{4})(\d{2})(\d{2})/.exec(trimmed);
  const date = iso ? new Date(Date.UTC(Number(iso[1]), Number(iso[2]) - 1, Number(iso[3])))
    : (brazilianDash ?? brazilian) ? (() => {
      const match = brazilianDash ?? brazilian!;
      return new Date(Date.UTC(Number(match[3].length === 2 ? `20${match[3]}` : match[3]), Number(match[2]) - 1, Number(match[1])));
    })()
    : ofx ? new Date(Date.UTC(Number(ofx[1]), Number(ofx[2]) - 1, Number(ofx[3]))) : null;
  return date && !Number.isNaN(date.valueOf()) ? date.toISOString() : null;
}

function parseCents(value: string): number | null {
  let normalized = value.trim();
  if (!normalized) return null;
  const negative = normalized.startsWith("-") || normalized.startsWith("(");
  normalized = normalized.replace(/[R$\s()]/g, "");
  const decimal = Math.max(normalized.lastIndexOf(","), normalized.lastIndexOf("."));
  const digits = decimal >= 0
    ? `${normalized.slice(0, decimal).replace(/\D/g, "")}${normalized.slice(decimal + 1).replace(/\D/g, "").padEnd(2, "0").slice(0, 2)}`
    : normalized.replace(/\D/g, "");
  if (!digits) return null;
  const cents = Number(digits);
  return Number.isSafeInteger(cents) ? negative ? -cents : cents : null;
}

function digest(value: string): string {
  return createHash("sha256").update(value).digest("hex");
}
