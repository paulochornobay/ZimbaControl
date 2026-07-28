import { Link } from "@tanstack/react-router";
import { ChevronRight } from "lucide-react";
import { cn } from "@/lib/utils";
import { formatBRL, type Transaction } from "@/lib/mock-data";
import { BeneficiaryChips } from "./BeneficiaryChips";
import { StatusBadge } from "./StatusBadge";

const sourceLabel: Record<Transaction["source"], string> = {
  notif: "Notificação",
  csv: "CSV",
  ofx: "OFX",
  manual: "Manual",
};

export function TransactionRow({
  tx,
  compact = false,
}: {
  tx: Transaction;
  compact?: boolean;
}) {
  const isIncome = tx.direction === "income";
  return (
    <Link
      to="/transaction/$id"
      params={{ id: tx.id }}
      className={cn(
        "grid grid-cols-[minmax(0,1fr)_auto] items-center gap-3 rounded-lg px-3 transition-colors hover:bg-muted/60",
        compact ? "py-2.5" : "py-3",
      )}
    >
      <div className="min-w-0">
        <div className="flex items-center gap-2">
          <p className="truncate text-[15px] font-medium text-foreground">
            {tx.description}
          </p>
          {tx.installment && (
            <span className="shrink-0 text-[11px] font-medium text-text-secondary tabular">
              {tx.installment.current}/{tx.installment.total}
            </span>
          )}
        </div>
        <div className="mt-1 flex items-center gap-2 text-[12px] text-text-secondary">
          <span className="truncate">
            {tx.category ?? tx.suggestedCategory ?? "Sem categoria"} · {tx.account}
          </span>
          <span className="hidden sm:inline">· {sourceLabel[tx.source]}</span>
        </div>
        <div className="mt-2 flex items-center gap-2">
          <BeneficiaryChips ids={tx.beneficiaries} />
          <StatusBadge status={tx.status} />
        </div>
      </div>
      <div className="flex items-center gap-1 pl-2">
        <div className="text-right">
          <p
            className={cn(
              "tabular text-[15px] font-semibold",
              isIncome ? "text-success" : "text-foreground",
            )}
          >
            {isIncome ? "+" : ""}
            {formatBRL(tx.amount)}
          </p>
          <p className="mt-0.5 text-[11px] text-text-secondary tabular">{tx.date}</p>
        </div>
        <ChevronRight className="h-4 w-4 text-text-secondary/60" />
      </div>
    </Link>
  );
}
