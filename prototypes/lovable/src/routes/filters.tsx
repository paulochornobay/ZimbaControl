import { createFileRoute } from "@tanstack/react-router";
import { AppShell, Card, Section } from "@/components/zc/AppShell";
import { categories, costCenters, people } from "@/lib/mock-data";

export const Route = createFileRoute("/filters")({
  head: () => ({
    meta: [
      { title: "Filtros · ZimbaControl" },
      {
        name: "description",
        content:
          "Filtre lançamentos por pessoa, categoria, centro de custo, conta e período.",
      },
      { property: "og:title", content: "Filtros · ZimbaControl" },
      {
        property: "og:description",
        content: "Segmente a visão do orçamento em segundos.",
      },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
  }),
  component: Filters,
});

function Filters() {
  return (
    <AppShell title="Filtros" subtitle="Refine sua visão">
      <Section title="Período" className="pt-4">
        <Card className="p-2">
          <div className="grid grid-cols-4 gap-1 p-1">
            {["Semana", "Mês", "Trimestre", "Ano"].map((p, i) => (
              <button
                key={p}
                className={`h-9 rounded-lg text-[13px] font-medium ${
                  i === 1
                    ? "bg-foreground text-primary-foreground"
                    : "text-text-secondary"
                }`}
              >
                {p}
              </button>
            ))}
          </div>
        </Card>
      </Section>

      <Section title="Pessoas">
        <Card className="p-3">
          <div className="flex flex-wrap gap-2">
            {people.map((p, i) => (
              <button
                key={p.id}
                className={`inline-flex items-center gap-1.5 rounded-full border px-3 py-1.5 text-[13px] font-medium ${
                  i < 2
                    ? "border-accent bg-accent-soft text-accent"
                    : "border-border bg-surface text-text-secondary"
                }`}
              >
                {p.name}
              </button>
            ))}
          </div>
        </Card>
      </Section>

      <Section title="Categorias">
        <Card className="p-3">
          <div className="flex flex-wrap gap-2">
            {categories.map((c, i) => (
              <button
                key={c.id}
                className={`inline-flex items-center gap-1.5 rounded-full border px-3 py-1.5 text-[13px] font-medium ${
                  i % 3 === 0
                    ? "border-foreground bg-foreground text-primary-foreground"
                    : "border-border bg-surface text-text-secondary"
                }`}
              >
                <span>{c.icon}</span>
                {c.label}
              </button>
            ))}
          </div>
        </Card>
      </Section>

      <Section title="Centro de custo">
        <Card className="p-3">
          <div className="flex flex-wrap gap-2">
            {costCenters.map((c, i) => (
              <button
                key={c.id}
                className={`rounded-full border px-3 py-1.5 text-[13px] font-medium ${
                  i === 0
                    ? "border-foreground bg-foreground text-primary-foreground"
                    : "border-border bg-surface text-text-secondary"
                }`}
              >
                {c.label}
              </button>
            ))}
          </div>
        </Card>
      </Section>

      <Section title="Contas">
        <Card className="p-2">
          <ul className="divide-y divide-border">
            {["Mercado Pago", "Nubank", "Salário PJ"].map((a, i) => (
              <li key={a} className="flex items-center justify-between px-3 py-3">
                <span className="text-[14px] font-medium text-foreground">{a}</span>
                <span
                  className={`h-6 w-11 rounded-full ${
                    i < 2 ? "bg-accent" : "bg-border-strong"
                  } relative transition-colors`}
                >
                  <span
                    className={`absolute top-0.5 h-5 w-5 rounded-full bg-surface shadow-card transition-all ${
                      i < 2 ? "left-5" : "left-0.5"
                    }`}
                  />
                </span>
              </li>
            ))}
          </ul>
        </Card>
      </Section>

      <div className="px-5 pt-6">
        <button className="grid h-12 w-full place-items-center rounded-2xl bg-foreground text-[15px] font-semibold text-primary-foreground">
          Aplicar filtros
        </button>
      </div>
    </AppShell>
  );
}
