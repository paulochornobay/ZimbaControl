import { createFileRoute, Link } from "@tanstack/react-router";
import { Check, Sparkles, X } from "lucide-react";
import { AppShell, Card, Section } from "@/components/zc/AppShell";
import { BeneficiaryChips } from "@/components/zc/BeneficiaryChips";
import { StatusBadge } from "@/components/zc/StatusBadge";
import { formatBRL, transactions } from "@/lib/mock-data";

export const Route = createFileRoute("/review")({
  head: () => ({
    meta: [
      { title: "Caixa de revisão · ZimbaControl" },
      {
        name: "description",
        content:
          "Revise, aprove e classifique lançamentos capturados de notificações, CSV e OFX em segundos.",
      },
      { property: "og:title", content: "Caixa de revisão · ZimbaControl" },
      {
        property: "og:description",
        content: "Fila de lançamentos pendentes com sugestões automáticas.",
      },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
  }),
  component: Review,
});

function Review() {
  const pending = transactions.filter((t) =>
    ["novo", "sugerido", "conflito", "duplicado"].includes(t.status),
  );

  return (
    <AppShell title="Caixa de revisão" subtitle={`${pending.length} lançamentos`}>
      <Section className="pt-4">
        <div className="flex gap-2 overflow-x-auto pb-1">
          {["Todos", "Notificação", "CSV", "OFX", "Conflitos"].map((f, i) => (
            <button
              key={f}
              className={`shrink-0 rounded-full border px-3 py-1.5 text-[13px] font-medium transition-colors ${
                i === 0
                  ? "border-foreground bg-foreground text-primary-foreground"
                  : "border-border bg-surface text-text-secondary"
              }`}
            >
              {f}
            </button>
          ))}
        </div>
      </Section>

      <Section title="Sugestões" className="pt-5">
        <div className="space-y-3">
          {pending.map((t) => (
            <Card key={t.id} className="p-4">
              <div className="grid grid-cols-[minmax(0,1fr)_auto] gap-3">
                <div className="min-w-0">
                  <div className="flex items-center gap-2">
                    <StatusBadge status={t.status} />
                    <span className="text-[11px] text-text-secondary">
                      {t.account} · {t.date}
                    </span>
                  </div>
                  <p className="mt-2 truncate text-[16px] font-semibold text-foreground">
                    {t.description}
                  </p>
                  {t.suggestedCategory && (
                    <div className="mt-2 inline-flex items-center gap-1.5 rounded-lg bg-accent-soft px-2 py-1 text-[12px] font-medium text-accent">
                      <Sparkles className="h-3 w-3" />
                      Sugestão: {t.suggestedCategory}
                    </div>
                  )}
                </div>
                <p
                  className={`tabular text-right text-[17px] font-semibold ${
                    t.direction === "income" ? "text-success" : "text-foreground"
                  }`}
                >
                  {formatBRL(t.amount)}
                </p>
              </div>

              <div className="mt-3 flex items-center justify-between gap-3">
                <BeneficiaryChips ids={t.beneficiaries} size="md" />
                <div className="flex gap-2">
                  <button className="grid h-10 w-10 place-items-center rounded-full border border-border bg-surface text-destructive">
                    <X className="h-5 w-5" />
                  </button>
                  <Link
                    to="/transaction/$id"
                    params={{ id: t.id }}
                    className="grid h-10 place-items-center rounded-full border border-border bg-surface px-3 text-[13px] font-medium text-foreground"
                  >
                    Editar
                  </Link>
                  <button className="grid h-10 w-10 place-items-center rounded-full bg-success text-success-foreground">
                    <Check className="h-5 w-5" strokeWidth={2.8} />
                  </button>
                </div>
              </div>
            </Card>
          ))}
        </div>
      </Section>
    </AppShell>
  );
}
