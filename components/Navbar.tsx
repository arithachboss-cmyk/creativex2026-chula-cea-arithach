import Link from "next/link";
import { Flower2 } from "lucide-react";
import { ThemeToggle } from "./ThemeToggle";

export function Navbar() {
  return (
    <header className="sticky top-0 z-40 border-b border-temple-gold/20 bg-ivory-50/90 backdrop-blur dark:bg-stone-950/88">
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-4 md:px-8">
        <Link href="/" className="flex min-w-0 items-center gap-3">
          <span className="grid h-10 w-10 shrink-0 place-items-center border border-temple-gold/40 bg-white text-temple-gold dark:bg-stone-900">
            <Flower2 className="h-5 w-5" />
          </span>
          <span className="truncate font-serif text-lg font-semibold text-temple-deep dark:text-ivory-50">
            หนังสือสวดมนต์ออนไลน์
          </span>
        </Link>
        <ThemeToggle />
      </div>
    </header>
  );
}
