import { createFileRoute, Link } from "@tanstack/react-router";
import { ArrowUpRight, Bell, TrendingDown, TrendingUp } from "lucide-react";
import { AppShell, Card, Section } from "@/components/zc/AppShell";
import { TransactionRow } from "@/components/zc/TransactionRow";
import { BeneficiaryChips } from "@/components/zc/BeneficiaryChips";
import { formatBRL, people, transactions } from "@/lib/mock-data";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "ZimbaControl — Suas finanças, classificadas" },
      {
        name: "description",
        content:
          "App de finanças pessoais e familiares com classificação profunda de lançamentos: pagador, beneficiários, categoria, centro de custo e mais.",
      },
      { property: "og:title", content: "ZimbaControl" },
      {
        property: "og:description",
        content:
          "Classificação profunda de lançamentos com revisão rápida, importação CSV/OFX e captura de notificações.",
      },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
  }),
  component: Home,
});

function Home() {
  const income = transactions
    .filter((t) => t.direction === "income")
    .reduce((s, t) => s + t.amount, 0);
  const expense = transactions
    .filter((t) => t.direction === "expense")
    .reduce((s, t) => s + t.amount, 0);
  const balance = income + expense;
  const pending = transactions.filter((t) =>
    ["novo", "sugerido", "conflito", "duplicado"].includes(t.status),
  );
  const recent = transactions.slice(0, 4);

  return (
    <AppShell
      title="Julho"
      subtitle="Visão da família"
      right={
        <button className="grid h-10 w-10 place-items-center rounded-full bg-muted text-foreground">
          <Bell className="h-5 w-5" />
        </button>
      }
    >
      <Section className="pt-4">
        <Card className="overflow-hidden">
          <div className="p-5">
            <p className="text-[12px] font-medium uppercase tracking-wide text-text-secondary">
              Saldo do mês
            </p>
            <p className="mt-1 tabular font-display text-[34px] font-semibold leading-none tracking-tight text-foreground">
              {formatBRL(balance)}
            </p>
            <div className="mt-4 grid grid-cols-2 gap-3">
              <div className="rounded-xl bg-success-soft/60 p-3">
                <div className="flex items-center gap-1.5 text-[12px] font-medium text-success">
                  <TrendingUp className="h-3.5 w-3.5" /> Entradas
                </div>
                <p className="mt-1 tabular text-[17px] font-semibold text-foreground">
                  {formatBRL(income)}
                </p>
              </div>
              <div className="rounded-xl bg-destructive-soft/50 p-3">
                <div className="flex items-center gap-1.5 text-[12px] font-medium text-destructive">
                  <TrendingDown className="h-3.5 w-3.5" /> Saídas
                </div>
                <p className="mt-1 tabular text-[17px] font-semibold text-foreground">
                  {formatBRL(Math.abs(expense))}
                </p>
              </div>
            </div>
          </div>
        </Card>
      </Section>

      <Section title="Pendentes de revisão" action={
        <Link to="/review" className="inline-flex items-center gap-0.5 text-[13px] font-medium text-accent">
          Ver todos <ArrowUpRight className="h-3.5 w-3.5" />
        </Link>
      }>
        <Card>
          <Link
            to="/review"
            className="flex items-center justify-between gap-3 p-4"
          >
            <div>
              <p className="text-[15px] font-semibold text-foreground">
                {pending.length} lançamentos aguardando você
              </p>
              <p className="mt-1 text-[13px] text-text-secondary">
                Vindos de Nubank e Mercado Pago
              </p>
            </div>
            <div className="grid h-10 w-10 place-items-center rounded-full bg-accent text-accent-foreground">
              <ArrowUpRight className="h-5 w-5" />
            </div>
          </Link>
        </Card>
      </Section>

      <Section title="Por pessoa">
        <Card className="p-2">
          <ul className="divide-y divide-border">
            {people.map((p) => {
              const spent = transactions
                .filter((t) => t.beneficiaries.includes(p.id) && t.direction === "expense")
                .reduce((s, t) => s + Math.abs(t.amount) / t.beneficiaries.length, 0);
              return (
                <li key={p.id} className="flex items-center gap-3 px-3 py-3">
                  <BeneficiaryChips ids={[p.id]} size="md" />
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-[15px] font-medium text-foreground">
                      {p.name}
                    </p>
                    <p className="text-[12px] text-text-secondary">
                      Rateio proporcional
                    </p>
                  </div>
                  <p className="tabular text-[15px] font-semibold text-foreground">
                    {formatBRL(spent)}
                  </p>
                </li>
              );
            })}
          </ul>
        </Card>
      </Section>

      <Section title="Recentes">
        <Card className="p-1.5">
          <ul className="divide-y divide-border">
            {recent.map((t) => (
              <li key={t.id}>
                <TransactionRow tx={t} />
              </li>
            ))}
          </ul>
        </Card>
      </Section>
    </AppShell>
  );
}
