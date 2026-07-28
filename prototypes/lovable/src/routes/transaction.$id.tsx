import { createFileRoute, Link, useParams } from "@tanstack/react-router";
import { CalendarDays, Check, Layers, Sparkles, Trash2 } from "lucide-react";
import { AppShell, Card, Section } from "@/components/zc/AppShell";
import { StatusBadge } from "@/components/zc/StatusBadge";
import {
  accounts,
  categories,
  costCenters,
  formatBRL,
  people,
  transactions,
} from "@/lib/mock-data";

export const Route = createFileRoute("/transaction/$id")({
  head: ({ params }) => ({
    meta: [
      { title: `Lançamento ${params.id} · ZimbaControl` },
      {
        name: "description",
        content:
          "Classifique o lançamento com pagador, beneficiários, categoria, subcategoria e centro de custo.",
      },
      { property: "og:title", content: "Detalhe do lançamento · ZimbaControl" },
      { property: "og:description", content: "Edição profunda de um lançamento." },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
  }),
  component: Detail,
});

function Detail() {
  const { id } = useParams({ from: "/transaction/$id" });
  const tx = transactions.find((t) => t.id === id) ?? transactions[0];

  return (
    <AppShell
      title="Lançamento"
      back={{ to: "/review" }}
      right={
        <button className="grid h-10 w-10 place-items-center rounded-full bg-destructive-soft text-destructive">
          <Trash2 className="h-4.5 w-4.5" />
        </button>
      }
    >
      <Section className="pt-4">
        <Card className="p-5">
          <div className="flex items-center justify-between gap-2">
            <StatusBadge status={tx.status} />
            <span className="text-[12px] text-text-secondary">
              {tx.account} · {tx.date}
            </span>
          </div>
          <input
            defaultValue={tx.description}
            className="mt-3 w-full border-0 bg-transparent p-0 font-display text-[22px] font-semibold text-foreground focus:outline-none"
          />
          <div className="mt-1 flex items-baseline gap-2">
            <span
              className={`tabular font-display text-[32px] font-semibold leading-none ${
                tx.direction === "income" ? "text-success" : "text-foreground"
              }`}
            >
              {formatBRL(tx.amount)}
            </span>
            <span className="text-[13px] text-text-secondary">BRL</span>
          </div>
          {tx.suggestedCategory && tx.status !== "revisado" && (
            <div className="mt-3 flex items-center gap-2 rounded-xl bg-accent-soft p-2.5">
              <Sparkles className="h-4 w-4 text-accent" />
              <p className="flex-1 text-[13px] text-foreground">
                Sugerimos <b>{tx.suggestedCategory}</b> baseado no seu histórico.
              </p>
              <button className="rounded-lg bg-accent px-2.5 py-1 text-[12px] font-semibold text-accent-foreground">
                Aceitar
              </button>
            </div>
          )}
        </Card>
      </Section>

      <Section title="Classificação">
        <Card>
          <ul className="divide-y divide-border">
            <Field label="Categoria" value={tx.category ?? "Mercado"} />
            <Field label="Subcategoria" value={tx.subcategory ?? "Alimentação"} />
            <Field label="Centro de custo" value={tx.costCenter ?? "Casa"} />
            <Field label="Conta / Cartão" value={tx.account} />
            <Field label="Competência" value="Julho / 2026" icon={<CalendarDays className="h-4 w-4" />} />
          </ul>
        </Card>
      </Section>

      <Section title="Beneficiários">
        <Card className="p-3">
          <div className="flex flex-wrap gap-2">
            {people.map((p) => {
              const active = tx.beneficiaries.includes(p.id);
              return (
                <button
                  key={p.id}
                  className={`inline-flex items-center gap-1.5 rounded-full border px-3 py-1.5 text-[13px] font-medium transition-colors ${
                    active
                      ? "border-accent bg-accent-soft text-accent"
                      : "border-border bg-surface text-text-secondary"
                  }`}
                >
                  {active && <Check className="h-3.5 w-3.5" />}
                  {p.name}
                </button>
              );
            })}
          </div>
          <p className="mt-3 rounded-lg bg-muted p-2.5 text-[12px] text-text-secondary">
            Rateio automático em partes iguais entre {tx.beneficiaries.length}{" "}
            {tx.beneficiaries.length > 1 ? "pessoas" : "pessoa"}.
          </p>
        </Card>
      </Section>

      <Section title="Origem & parcelamento">
        <Card>
          <ul className="divide-y divide-border">
            <Field label="Fonte do dado" value={fmtSource(tx.source)} />
            <Field
              label="Parcelamento"
              value={
                tx.installment
                  ? `${tx.installment.current} de ${tx.installment.total}`
                  : "À vista"
              }
              icon={<Layers className="h-4 w-4" />}
              action={
                <Link to="/installments" className="text-[13px] font-medium text-accent">
                  Configurar
                </Link>
              }
            />
            <Field label="Pagador" value={people[0].name} />
          </ul>
        </Card>
      </Section>

      <div className="px-5 pt-6">
        <button className="grid h-12 w-full place-items-center rounded-2xl bg-foreground text-[15px] font-semibold text-primary-foreground">
          Salvar como revisado
        </button>
      </div>

      {/* filler para evitar warning de unused */}
      <span className="hidden">{categories.length}{costCenters.length}{accounts.length}</span>
    </AppShell>
  );
}

function Field({
  label,
  value,
  icon,
  action,
}: {
  label: string;
  value: string;
  icon?: React.ReactNode;
  action?: React.ReactNode;
}) {
  return (
    <li className="flex items-center gap-3 px-4 py-3">
      <div className="min-w-0 flex-1">
        <p className="text-[12px] text-text-secondary">{label}</p>
        <div className="mt-0.5 flex items-center gap-1.5">
          {icon && <span className="text-text-secondary">{icon}</span>}
          <p className="truncate text-[15px] font-medium text-foreground">{value}</p>
        </div>
      </div>
      {action ?? <span className="text-text-secondary/60">›</span>}
    </li>
  );
}

function fmtSource(s: string) {
  return { notif: "Notificação Android", csv: "Importação CSV", ofx: "Importação OFX", manual: "Cadastro manual" }[s as "notif" | "csv" | "ofx" | "manual"];
}
