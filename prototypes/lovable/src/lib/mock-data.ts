// Mock data para o protótipo ZimbaControl.
export type Person = {
  id: string;
  name: string;
  short: string;
  color: string; // token semântico ou hex; usamos hex controlado abaixo
  emoji: string;
};

export const people: Person[] = [
  { id: "eu", name: "Você", short: "EU", color: "bg-accent-soft text-accent", emoji: "🧑" },
  { id: "esposa", name: "Marina", short: "MA", color: "bg-info-soft text-foreground", emoji: "👩" },
  { id: "filha", name: "Sofia", short: "SO", color: "bg-warning-soft text-warning", emoji: "🧒" },
  { id: "bebe", name: "Bebê", short: "BE", color: "bg-success-soft text-success", emoji: "👶" },
];

export type Status = "novo" | "sugerido" | "conflito" | "duplicado" | "parcela" | "revisado";
export type Source = "notif" | "csv" | "ofx" | "manual";
export type Direction = "expense" | "income";

export type Transaction = {
  id: string;
  description: string;
  amount: number;
  date: string;
  account: string;
  category?: string;
  subcategory?: string;
  costCenter?: string;
  beneficiaries: string[]; // person ids
  status: Status;
  source: Source;
  direction: Direction;
  installment?: { current: number; total: number };
  suggestedCategory?: string;
  duplicateOf?: string;
};

export const transactions: Transaction[] = [
  {
    id: "t1",
    description: "Mercado Extra",
    amount: -487.32,
    date: "Hoje · 14:22",
    account: "Nubank",
    beneficiaries: ["eu", "esposa", "filha", "bebe"],
    status: "novo",
    source: "notif",
    direction: "expense",
    suggestedCategory: "Mercado / Alimentação",
  },
  {
    id: "t2",
    description: "Farmácia Pague Menos",
    amount: -89.9,
    date: "Hoje · 11:04",
    account: "Mercado Pago",
    beneficiaries: ["bebe"],
    status: "sugerido",
    source: "notif",
    direction: "expense",
    suggestedCategory: "Saúde / Farmácia",
  },
  {
    id: "t3",
    description: "Escola Sofia — mensalidade",
    amount: -1290,
    date: "Ontem",
    account: "Mercado Pago",
    category: "Educação",
    subcategory: "Mensalidade",
    costCenter: "Filhos",
    beneficiaries: ["filha"],
    status: "revisado",
    source: "manual",
    direction: "expense",
  },
  {
    id: "t4",
    description: "Salário",
    amount: 12800,
    date: "27 jul",
    account: "Mercado Pago",
    category: "Renda",
    subcategory: "Salário",
    beneficiaries: ["eu"],
    status: "revisado",
    source: "manual",
    direction: "income",
  },
  {
    id: "t5",
    description: "iPhone 15 — parcela 4/12",
    amount: -624.9,
    date: "25 jul",
    account: "Nubank",
    category: "Eletrônicos",
    beneficiaries: ["eu"],
    status: "parcela",
    source: "csv",
    direction: "expense",
    installment: { current: 4, total: 12 },
  },
  {
    id: "t6",
    description: "Uber Trip",
    amount: -24.5,
    date: "25 jul",
    account: "Nubank",
    beneficiaries: ["esposa"],
    status: "duplicado",
    source: "notif",
    direction: "expense",
    duplicateOf: "t7",
    suggestedCategory: "Transporte",
  },
  {
    id: "t7",
    description: "Uber *Trip",
    amount: -24.5,
    date: "25 jul",
    account: "Nubank",
    beneficiaries: ["esposa"],
    status: "conflito",
    source: "csv",
    direction: "expense",
    suggestedCategory: "Transporte",
  },
];

export const categories = [
  { id: "mercado", label: "Mercado", icon: "🛒" },
  { id: "saude", label: "Saúde", icon: "💊" },
  { id: "educacao", label: "Educação", icon: "📚" },
  { id: "transporte", label: "Transporte", icon: "🚗" },
  { id: "lazer", label: "Lazer", icon: "🎬" },
  { id: "casa", label: "Casa", icon: "🏠" },
  { id: "renda", label: "Renda", icon: "💰" },
];

export const costCenters = [
  { id: "casa", label: "Casa" },
  { id: "filhos", label: "Filhos" },
  { id: "pessoal", label: "Pessoal" },
  { id: "trabalho", label: "Trabalho" },
];

export const accounts = [
  { id: "mp", label: "Mercado Pago", type: "Conta" },
  { id: "nu", label: "Nubank", type: "Cartão" },
];

export function formatBRL(v: number) {
  return v.toLocaleString("pt-BR", {
    style: "currency",
    currency: "BRL",
    minimumFractionDigits: 2,
  });
}
