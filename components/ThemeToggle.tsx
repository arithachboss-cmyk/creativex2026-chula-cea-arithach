"use client";

import { Moon, Sun } from "lucide-react";
import { useEffect, useState } from "react";

export function ThemeToggle() {
  const [dark, setDark] = useState(false);

  useEffect(() => {
    const stored = window.localStorage.getItem("thai-prayer-book-theme");
    const next = stored === "dark";
    document.documentElement.classList.toggle("dark", next);
    setDark(next);
  }, []);

  function toggle() {
    const next = !dark;
    document.documentElement.classList.toggle("dark", next);
    window.localStorage.setItem("thai-prayer-book-theme", next ? "dark" : "light");
    setDark(next);
  }

  return (
    <button
      type="button"
      onClick={toggle}
      className="grid h-10 w-10 place-items-center border border-temple-gold/25 bg-white/75 text-temple-deep transition hover:border-temple-gold dark:bg-stone-900 dark:text-ivory-50"
      aria-label={dark ? "โหมดกลางวัน" : "โหมดกลางคืน"}
      title={dark ? "โหมดกลางวัน" : "โหมดกลางคืน"}
    >
      {dark ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
    </button>
  );
}
