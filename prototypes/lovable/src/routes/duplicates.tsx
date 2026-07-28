import { createFileRoute } from "@tanstack/react-router";
import { GitMerge } from "lucide-react";
import { AppShell, Card, Section } from "@/components/zc/AppShell";
import { StatusBadge } from "@/components/zc/StatusBadge";
import { formatBRL, transactions } from "@/lib/mock-data";

export const Route = createFileRoute("/duplicates")({
  head: () => ({
    meta: [
      { title: "Resolver duplicidades · ZimbaControl" },
      {
        name: "description",
        content:
          "Compare lançamentos suspeitos de duplicidade lado a lado e escolha o correto.",
      },
      { property: "og:title", content: "Duplicidades · ZimbaControl" },
      {
        property: "og:description",
        content: "Deduplicação inteligente entre notificações e importações.",
      },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
  }),
  component: Duplicates,
});

function Duplicates() {
  const a = transactions.find((t) => t.id === "t6")!;
  const b = transactions.find((t) => t.id === "t7")!;

  return (
    <AppShell title="Duplicidade" subtitle="1 par para resolver" back={{ to: "/review" }}>
      <Section className="pt-4">
        <Card className="p-4">
          <div className="flex items-center gap-2">
            <div className="grid h-9 w-9 place-items-center rounded-full bg-warning-soft text-warning">
              <GitMerge className="h-4.5 w-4.5" />
            </div>
            <div>
              <p className="text-[14px] font-semibold text-foreground">
                Mesmo valor, mesma data
              </p>
              <p className="text-[12px] text-text-secondary">
                Notificação e CSV chegaram no mesmo cartão
              </p>
            </div>
          </div>
        </Card>
      </Section>

      <Section title="Comparar">
        <div className="space-y-3">
          {[a, b].map((t, i) => (
            <Card key={t.id} className="p-4">
              <div className="flex items-center justify-between">
                <StatusBadge status={t.status} />
                <span className="text-[11px] uppercase tracking-wide text-text-secondary">
                  Origem: {t.source === "notif" ? "Notificação" : "CSV"}
                </span>
              </div>
              <p className="mt-2 text-[15px] font-semibold text-foreground">
                {t.description}
              </p>
              <p className="tabular text-[22px] font-semibold text-foreground">
                {formatBRL(t.amount)}
              </p>
              <p className="mt-1 text-[12px] text-text-secondary">
                {t.date} · {t.account}
              </p>

              <div className="mt-4 flex gap-2">
                <button
                  className={`h-10 flex-1 rounded-xl text-[13px] font-semibold ${
                    i === 0
                      ? "bg-foreground text-primary-foreground"
                      : "border border-border bg-surface text-foreground"
                  }`}
                >
                  {i === 0 ? "Manter este" : "Manter este"}
                </button>
                <button className="h-10 rounded-xl border border-border bg-surface px-3 text-[13px] font-medium text-destructive">
                  Descartar
                </button>
              </div>
            </Card>
          ))}
        </div>
      </Section>

      <Section>
        <button className="mt-2 grid h-12 w-full place-items-center rounded-2xl border border-border bg-surface text-[14px] font-semibold text-foreground">
          Mesclar como um só lançamento
        </button>
      </Section>
    </AppShell>
  );
}
