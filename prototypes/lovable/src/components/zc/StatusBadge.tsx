import { cn } from "@/lib/utils";
import type { Status } from "@/lib/mock-data";

const map: Record<Status, { label: string; className: string }> = {
  novo: { label: "Novo", className: "bg-accent-soft text-accent" },
  sugerido: { label: "Sugerido", className: "bg-info-soft text-foreground" },
  conflito: { label: "Conflito", className: "bg-warning-soft text-warning" },
  duplicado: { label: "Duplicado", className: "bg-destructive-soft text-destructive" },
  parcela: { label: "Parcela", className: "bg-muted text-text-secondary" },
  revisado: { label: "Revisado", className: "bg-success-soft text-success" },
};

export function StatusBadge({ status, className }: { status: Status; className?: string }) {
  const s = map[status];
  return (
    <span
      className={cn(
        "inline-flex items-center rounded-full px-2 py-0.5 text-[11px] font-medium",
        s.className,
        className,
      )}
    >
      {s.label}
    </span>
  );
}
