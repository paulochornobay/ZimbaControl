import { createFileRoute } from "@tanstack/react-router";
import { CheckCircle2, FileSpreadsheet, FileText, Upload } from "lucide-react";
import { AppShell, Card, Section } from "@/components/zc/AppShell";

export const Route = createFileRoute("/import")({
  head: () => ({
    meta: [
      { title: "Importar CSV/OFX · ZimbaControl" },
      {
        name: "description",
        content:
          "Importe extratos e faturas em CSV ou OFX. O ZimbaControl reconhece colunas, sugere categorias e evita duplicidades.",
      },
      { property: "og:title", content: "Importação · ZimbaControl" },
      {
        property: "og:description",
        content: "Importe extratos Nubank e Mercado Pago em segundos.",
      },
      { property: "og:type", content: "website" },
      { name: "twitter:card", content: "summary_large_image" },
    ],
  }),
  component: Import,
});

function Import() {
  return (
    <AppShell title="Importar arquivo" back={{ to: "/" }}>
      <Section className="pt-4">
        <Card className="border-dashed p-6 text-center">
          <div className="mx-auto grid h-14 w-14 place-items-center rounded-2xl bg-accent-soft text-accent">
            <Upload className="h-6 w-6" />
          </div>
          <p className="mt-3 text-[15px] font-semibold text-foreground">
            Arraste o arquivo ou toque para escolher
          </p>
          <p className="mt-1 text-[13px] text-text-secondary">
            CSV, OFX ou XLSX · até 20MB
          </p>
          <button className="mt-4 h-11 rounded-xl bg-foreground px-5 text-[14px] font-semibold text-primary-foreground">
            Escolher arquivo
          </button>
        </Card>
      </Section>

      <Section title="Fontes suportadas">
        <Card className="p-2">
          <ul className="divide-y divide-border">
            {[
              { icon: FileText, name: "Nubank fatura", ext: "CSV / OFX" },
              { icon: FileSpreadsheet, name: "Mercado Pago extrato", ext: "CSV" },
              { icon: FileSpreadsheet, name: "Planilha genérica", ext: "XLSX" },
            ].map((s) => (
              <li key={s.name} className="flex items-center gap-3 px-3 py-3">
                <div className="grid h-10 w-10 place-items-center rounded-xl bg-muted text-foreground">
                  <s.icon className="h-5 w-5" />
                </div>
                <div className="flex-1">
                  <p className="text-[14px] font-medium text-foreground">{s.name}</p>
                  <p className="text-[12px] text-text-secondary">{s.ext}</p>
                </div>
                <CheckCircle2 className="h-5 w-5 text-success" />
              </li>
            ))}
          </ul>
        </Card>
      </Section>

      <Section title="Última importação">
        <Card className="p-4">
          <div className="flex items-center gap-3">
            <div className="grid h-11 w-11 place-items-center rounded-xl bg-success-soft text-success">
              <CheckCircle2 className="h-5 w-5" />
            </div>
            <div className="flex-1">
              <p className="text-[14px] font-semibold text-foreground">
                Nubank_junho_2026.csv
              </p>
              <p className="text-[12px] text-text-secondary">
                42 lançamentos importados · 3 duplicados ignorados
              </p>
            </div>
          </div>
          <div className="mt-4 grid grid-cols-3 gap-2 text-center">
            <Stat label="Novos" value="39" />
            <Stat label="Sugeridos" value="28" />
            <Stat label="Conflitos" value="2" tone="warning" />
          </div>
        </Card>
      </Section>
    </AppShell>
  );
}

function Stat({
  label,
  value,
  tone,
}: {
  label: string;
  value: string;
  tone?: "warning";
}) {
  return (
    <div className="rounded-xl bg-muted p-3">
      <p
        className={`tabular text-[20px] font-semibold ${
          tone === "warning" ? "text-warning" : "text-foreground"
        }`}
      >
        {value}
      </p>
      <p className="mt-0.5 text-[11px] font-medium uppercase tracking-wide text-text-secondary">
        {label}
      </p>
    </div>
  );
}
