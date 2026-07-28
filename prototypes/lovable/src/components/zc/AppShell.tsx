import { Link, useRouterState } from "@tanstack/react-router";
import { Home, Inbox, PlusCircle, SlidersHorizontal, Settings } from "lucide-react";
import type { ReactNode } from "react";
import { cn } from "@/lib/utils";

const tabs: Array<{
  to: string;
  label: string;
  icon: typeof Home;
  badge?: number;
  primary?: boolean;
}> = [
  { to: "/", label: "Início", icon: Home },
  { to: "/review", label: "Revisão", icon: Inbox, badge: 2 },
  { to: "/transaction/new", label: "Novo", icon: PlusCircle, primary: true },
  { to: "/filters", label: "Filtros", icon: SlidersHorizontal },
  { to: "/settings", label: "Ajustes", icon: Settings },
];

export function AppShell({
  title,
  subtitle,
  right,
  back,
  children,
  scrollable = true,
}: {
  title?: string;
  subtitle?: string;
  right?: ReactNode;
  back?: { to: string; label?: string };
  children: ReactNode;
  scrollable?: boolean;
}) {
  const pathname = useRouterState({ select: (s) => s.location.pathname });

  return (
    <div className="min-h-screen w-full bg-background">
      <div className="mx-auto flex min-h-screen w-full max-w-[440px] flex-col bg-background sm:my-4 sm:min-h-[calc(100vh-2rem)] sm:rounded-[32px] sm:border sm:border-border sm:shadow-elevated">
        {(title || back || right) && (
          <header className="sticky top-0 z-20 flex items-center gap-3 border-b border-border bg-background/85 px-5 pb-3 pt-5 backdrop-blur-xl sm:rounded-t-[32px]">
            {back && (
              <Link
                to={back.to}
                className="-ml-2 inline-flex h-9 items-center rounded-full px-2 text-[15px] font-medium text-accent"
              >
                ← {back.label ?? "Voltar"}
              </Link>
            )}
            <div className="min-w-0 flex-1">
              {title && (
                <h1 className="truncate font-display text-[22px] font-semibold leading-tight tracking-tight text-foreground">
                  {title}
                </h1>
              )}
              {subtitle && (
                <p className="mt-0.5 truncate text-[13px] text-text-secondary">
                  {subtitle}
                </p>
              )}
            </div>
            {right && <div className="shrink-0">{right}</div>}
          </header>
        )}

        <main
          className={cn(
            "flex-1 pb-24",
            scrollable && "overflow-y-auto",
          )}
        >
          {children}
        </main>

        <nav className="sticky bottom-0 z-20 border-t border-border bg-surface/95 px-2 pb-[max(env(safe-area-inset-bottom),8px)] pt-2 backdrop-blur-xl sm:rounded-b-[32px]">
          <ul className="grid grid-cols-5">
            {tabs.map((t) => {
              const active =
                t.to === "/" ? pathname === "/" : pathname.startsWith(t.to);
              const Icon = t.icon;
              return (
                <li key={t.to} className="flex justify-center">
                  <Link
                    to={t.to}
                    className={cn(
                      "flex flex-col items-center gap-0.5 rounded-xl px-3 py-1.5 transition-colors",
                      active ? "text-accent" : "text-text-secondary",
                    )}
                  >
                    <span className="relative">
                      <Icon
                        className={cn(
                          t.primary ? "h-7 w-7" : "h-5 w-5",
                          t.primary && !active && "text-foreground",
                        )}
                        strokeWidth={active ? 2.4 : 2}
                      />
                      {"badge" in t && t.badge ? (
                        <span className="absolute -right-1 -top-1 grid h-4 min-w-4 place-items-center rounded-full bg-destructive px-1 text-[10px] font-semibold text-destructive-foreground">
                          {t.badge}
                        </span>
                      ) : null}
                    </span>
                    <span className="text-[10px] font-medium">{t.label}</span>
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>
      </div>
    </div>
  );
}

export function Section({
  title,
  action,
  children,
  className,
}: {
  title?: string;
  action?: ReactNode;
  children: ReactNode;
  className?: string;
}) {
  return (
    <section className={cn("px-5 pt-6", className)}>
      {(title || action) && (
        <div className="mb-2 flex items-center justify-between gap-3">
          {title && (
            <h2 className="text-[13px] font-semibold uppercase tracking-wide text-text-secondary">
              {title}
            </h2>
          )}
          {action}
        </div>
      )}
      {children}
    </section>
  );
}

export function Card({
  children,
  className,
  as: As = "div",
}: {
  children: ReactNode;
  className?: string;
  as?: keyof React.JSX.IntrinsicElements;
}) {
  const Cmp = As as any;
  return (
    <Cmp
      className={cn(
        "rounded-2xl border border-border bg-surface shadow-card",
        className,
      )}
    >
      {children}
    </Cmp>
  );
}
