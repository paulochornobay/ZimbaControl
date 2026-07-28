import { cn } from "@/lib/utils";
import { people } from "@/lib/mock-data";

export function BeneficiaryChips({
  ids,
  size = "sm",
  className,
}: {
  ids: string[];
  size?: "sm" | "md";
  className?: string;
}) {
  const list = ids.map((id) => people.find((p) => p.id === id)).filter(Boolean);
  const dim = size === "md" ? "h-7 w-7 text-[11px]" : "h-6 w-6 text-[10px]";
  return (
    <div className={cn("flex -space-x-1.5", className)}>
      {list.map((p) => (
        <span
          key={p!.id}
          title={p!.name}
          className={cn(
            "inline-flex items-center justify-center rounded-full font-semibold ring-2 ring-surface",
            p!.color,
            dim,
          )}
        >
          {p!.short}
        </span>
      ))}
    </div>
  );
}
