import { createFileRoute, Link } from "@tanstack/react-router";
import { Bell, ChevronRight, FileUp, GitMerge, ShieldCheck } from "lucide-react";
import { AppShell, Card, Section } from "@/components/zc/AppShell";

export const Route = createFileRoute("/settings")({
  head: () => ({
    meta: [
      { title: "Ajustes · ZimbaControl" },
      {
        name: "description",
        content:
          "Configure captura de notificações do Android, apps monitorados, regras de deduplicação e mais.",
      },
      { property: "og:title", content: "Ajustes · ZimbaControl" },
      {
        property: "og:description",
        content: "Controle fino do que o ZimbaControl captura.",
      },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
  }),
  component: Settings,
});

function Settings() {
  return (
    <AppShell title="Ajustes">
      <Section title="Captura de notificação" className="pt-4">
        <Card className="p-4">
          <div className="flex items-start gap-3">
            <div className="grid h-11 w-11 place-items-center rounded-xl bg-accent-soft text-accent">
              <Bell className="h-5 w-5" />
            </div>
            <div className="flex-1">
              <p className="text-[15px] font-semibold text-foreground">
                Notification Listener
              </p>
              <p className="mt-0.5 text-[12px] text-text-secondary">
                Permitimos ler notificações para capturar lançamentos automaticamente.
              </p>
            </div>
            <span className="relative h-6 w-11 rounded-full bg-accent">
              <span className="absolute left-5 top-0.5 h-5 w-5 rounded-full bg-surface shadow-card" />
            </span>
          </div>

          <div className="mt-4 rounded-xl bg-muted p-3">
            <p className="text-[12px] font-semibold uppercase tracking-wide text-text-secondary">
              Apps monitorados
            </p>
            <ul className="mt-2 space-y-2">
              {[
                { name: "Mercado Pago", on: true },
                { name: "Nubank", on: true },
                { name: "Itaú", on: false },
              ].map((a) => (
                <li key={a.name} className="flex items-center justify-between">
                  <span className="text-[14px] text-foreground">{a.name}</span>
                  <span
                    className={`relative h-5 w-9 rounded-full ${
                      a.on ? "bg-accent" : "bg-border-strong"
                    }`}
                  >
                    <span
                      className={`absolute top-0.5 h-4 w-4 rounded-full bg-surface shadow-card ${
                        a.on ? "left-4" : "left-0.5"
                      }`}
                    />
                  </span>
                </li>
              ))}
            </ul>
          </div>
        </Card>
      </Section>

      <Section title="Dados">
        <Card className="p-2">
          <ul className="divide-y divide-border">
            <Row to="/import" icon={<FileUp className="h-5 w-5" />} label="Importar CSV/OFX" hint="Nubank, Mercado Pago" />
            <Row to="/duplicates" icon={<GitMerge className="h-5 w-5" />} label="Resolver duplicidades" hint="1 pendente" />
            <Row to="/settings" icon={<ShieldCheck className="h-5 w-5" />} label="Privacidade" hint="Dados locais primeiro" />
          </ul>
        </Card>
      </Section>

      <Section title="Sobre">
        <Card className="p-4">
          <p className="text-[13px] text-text-secondary">
            ZimbaControl v0.1 — protótipo visual. Offline-first, foco em classificação
            profunda de lançamentos para famílias.
          </p>
        </Card>
      </Section>
    </AppShell>
  );
}

function Row({
  to,
  icon,
  label,
  hint,
}: {
  to: string;
  icon: React.ReactNode;
  label: string;
  hint?: string;
}) {
  return (
    <li>
      <Link to={to} className="flex items-center gap-3 px-3 py-3">
        <div className="grid h-10 w-10 place-items-center rounded-xl bg-muted text-foreground">
          {icon}
        </div>
        <div className="flex-1">
          <p className="text-[14px] font-medium text-foreground">{label}</p>
          {hint && <p className="text-[12px] text-text-secondary">{hint}</p>}
        </div>
        <ChevronRight className="h-4 w-4 text-text-secondary/60" />
      </Link>
    </li>
  );
}
