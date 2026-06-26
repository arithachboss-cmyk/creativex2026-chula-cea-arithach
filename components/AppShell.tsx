"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import clsx from "clsx";
import { bottomNavItems, navItems } from "@/lib/navigation";
import { Footer } from "./Footer";
import { Navbar } from "./Navbar";

export function AppShell({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();

  return (
    <div className="min-h-screen pb-20 md:pb-0">
      <Navbar />
      <div className="mx-auto grid max-w-7xl grid-cols-1 md:grid-cols-[240px_minmax(0,1fr)]">
        <aside className="sticky top-16 hidden h-[calc(100vh-4rem)] border-r border-temple-gold/20 px-4 py-6 md:block">
          <nav className="space-y-1">
            {navItems.map((item) => {
              const active = pathname === item.href;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={clsx(
                    "flex items-center gap-3 px-3 py-3 text-sm transition",
                    active
                      ? "bg-temple-gold text-white"
                      : "text-stone-700 hover:bg-white/70 hover:text-temple-deep dark:text-stone-300 dark:hover:bg-stone-900"
                  )}
                >
                  <item.icon className="h-4 w-4" />
                  <span>{item.label}</span>
                </Link>
              );
            })}
          </nav>
        </aside>
        <main className="min-w-0">{children}</main>
      </div>
      <Footer />
      <nav className="fixed inset-x-0 bottom-0 z-50 grid grid-cols-5 border-t border-temple-gold/20 bg-ivory-50/96 px-1 py-2 backdrop-blur dark:bg-stone-950/96 md:hidden">
        {bottomNavItems.map((item) => {
          const active = pathname === item.href;
          return (
            <Link
              key={item.href}
              href={item.href}
              className={clsx(
                "flex h-12 flex-col items-center justify-center gap-1 text-[11px] leading-none",
                active ? "text-temple-gold" : "text-stone-600 dark:text-stone-300"
              )}
            >
              <item.icon className="h-5 w-5" />
              <span className="max-w-full truncate">{item.label}</span>
            </Link>
          );
        })}
      </nav>
    </div>
  );
}
