import { createFileRoute } from "@tanstack/react-router";
import { AppShell, Card, Section } from "@/components/zc/AppShell";
import { accounts, categories, people } from "@/lib/mock-data";

export const Route = createFileRoute("/transaction/new")({
  head: () => ({
    meta: [
      { title: "Novo lançamento · ZimbaControl" },
      {
        name: "description",
        content: "Cadastre um lançamento manual com classificação completa.",
      },
      { property: "og:title", content: "Novo lançamento · ZimbaControl" },
      {
        property: "og:description",
        content: "Registro manual rápido, com sugestão inteligente de categoria.",
      },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
  }),
  component: NewTx,
});

function NewTx() {
  return (
    <AppShell title="Novo lançamento" back={{ to: "/" }}>
      <Section className="pt-4">
        <Card className="p-5">
          <p className="text-[12px] uppercase tracking-wide text-text-secondary">
            Valor
          </p>
          <div className="mt-1 flex items-baseline gap-2">
            <span className="text-[16px] text-text-secondary">R$</span>
            <input
              defaultValue="0,00"
              className="tabular w-full border-0 bg-transparent p-0 font-display text-[36px] font-semibold text-foreground focus:outline-none"
            />
          </div>
          <div className="mt-4 grid grid-cols-2 gap-2">
            <button className="h-10 rounded-xl bg-destructive-soft text-[13px] font-semibold text-destructive">
              Despesa
            </button>
            <button className="h-10 rounded-xl bg-muted text-[13px] font-semibold text-text-secondary">
              Receita
            </button>
          </div>
        </Card>
      </Section>

      <Section title="Descrição">
        <Card className="p-3">
          <input
            placeholder="Ex: Padaria da esquina"
            className="w-full border-0 bg-transparent px-1 py-2 text-[15px] text-foreground placeholder:text-text-secondary/70 focus:outline-none"
          />
        </Card>
      </Section>

      <Section title="Conta">
        <Card className="p-2">
          <div className="grid grid-cols-2 gap-2 p-1">
            {accounts.map((a, i) => (
              <button
                key={a.id}
                className={`rounded-xl border p-3 text-left ${
                  i === 0 ? "border-accent bg-accent-soft" : "border-border bg-surface"
                }`}
              >
                <p className="text-[14px] font-semibold text-foreground">
                  {a.label}
                </p>
                <p className="text-[11px] text-text-secondary">{a.type}</p>
              </button>
            ))}
          </div>
        </Card>
      </Section>

      <Section title="Categoria">
        <Card className="p-3">
          <div className="flex flex-wrap gap-2">
            {categories.slice(0, 6).map((c, i) => (
              <button
                key={c.id}
                className={`inline-flex items-center gap-1.5 rounded-full border px-3 py-1.5 text-[13px] font-medium ${
                  i === 0
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

      <Section title="Beneficiários">
        <Card className="p-3">
          <div className="flex flex-wrap gap-2">
            {people.map((p, i) => (
              <button
                key={p.id}
                className={`rounded-full border px-3 py-1.5 text-[13px] font-medium ${
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

      <div className="px-5 pt-6">
        <button className="grid h-12 w-full place-items-center rounded-2xl bg-foreground text-[15px] font-semibold text-primary-foreground">
          Adicionar lançamento
        </button>
      </div>
    </AppShell>
  );
}
