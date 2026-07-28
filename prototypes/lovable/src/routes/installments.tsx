import { createFileRoute } from "@tanstack/react-router";
import { AppShell, Card, Section } from "@/components/zc/AppShell";
import { formatBRL } from "@/lib/mock-data";

export const Route = createFileRoute("/installments")({
  head: () => ({
    meta: [
      { title: "Parcelamento · ZimbaControl" },
      {
        name: "description",
        content:
          "Divida uma compra em parcelas e projete o impacto mensal no orçamento familiar.",
      },
      { property: "og:title", content: "Parcelamento · ZimbaControl" },
      {
        property: "og:description",
        content: "Configure parcelas e veja a projeção mês a mês.",
      },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
  }),
  component: Installments,
});

function Installments() {
  const total = 7499;
  const parcels = 12;
  const monthly = total / parcels;

  return (
    <AppShell title="Parcelamento" back={{ to: "/transaction/$id", label: "Voltar" } as any}>
      <Section className="pt-4">
        <Card className="p-5">
          <p className="text-[12px] uppercase tracking-wide text-text-secondary">
            iPhone 15
          </p>
          <p className="mt-1 tabular font-display text-[30px] font-semibold text-foreground">
            {formatBRL(total)}
          </p>
          <p className="mt-1 text-[13px] text-text-secondary">
            Nubank · Compra em 25 jul 2026
          </p>
        </Card>
      </Section>

      <Section title="Nº de parcelas">
        <Card className="p-4">
          <div className="flex gap-2 overflow-x-auto">
            {[1, 3, 6, 10, 12, 18, 24].map((n) => (
              <button
                key={n}
                className={`shrink-0 rounded-xl border px-4 py-2 text-[14px] font-semibold ${
                  n === parcels
                    ? "border-foreground bg-foreground text-primary-foreground"
                    : "border-border bg-surface text-foreground"
                }`}
              >
                {n}x
              </button>
            ))}
          </div>
          <div className="mt-4 grid grid-cols-2 gap-3">
            <div className="rounded-xl bg-muted p-3">
              <p className="text-[11px] uppercase tracking-wide text-text-secondary">
                Parcela
              </p>
              <p className="mt-0.5 tabular text-[18px] font-semibold text-foreground">
                {formatBRL(monthly)}
              </p>
            </div>
            <div className="rounded-xl bg-muted p-3">
              <p className="text-[11px] uppercase tracking-wide text-text-secondary">
                Última em
              </p>
              <p className="mt-0.5 text-[18px] font-semibold text-foreground">
                Jul 2027
              </p>
            </div>
          </div>
        </Card>
      </Section>

      <Section title="Projeção">
        <Card className="p-2">
          <ul className="divide-y divide-border">
            {Array.from({ length: 6 }).map((_, i) => (
              <li
                key={i}
                className="flex items-center justify-between px-3 py-3 text-[14px]"
              >
                <span className="text-foreground">
                  Parcela {i + 1}/{parcels}
                </span>
                <span className="text-text-secondary">
                  {["Ago", "Set", "Out", "Nov", "Dez", "Jan"][i]} 2026
                </span>
                <span className="tabular font-semibold text-foreground">
                  {formatBRL(monthly)}
                </span>
              </li>
            ))}
          </ul>
        </Card>
      </Section>

      <div className="px-5 pt-6">
        <button className="grid h-12 w-full place-items-center rounded-2xl bg-foreground text-[15px] font-semibold text-primary-foreground">
          Salvar parcelamento
        </button>
      </div>
    </AppShell>
  );
}
