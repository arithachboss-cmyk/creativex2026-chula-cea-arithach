"use client";

import { Search } from "lucide-react";

type SearchBarProps = {
  value: string;
  onChange: (value: string) => void;
};

export function SearchBar({ value, onChange }: SearchBarProps) {
  return (
    <label className="relative block">
      <Search className="pointer-events-none absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-temple-gold" />
      <input
        value={value}
        onChange={(event) => onChange(event.target.value)}
        placeholder="ค้นหาบทสวด"
        className="h-12 w-full border border-temple-gold/25 bg-white/80 pl-12 pr-4 text-base text-temple-ink outline-none transition focus:border-temple-gold focus:ring-4 focus:ring-temple-gold/15 dark:bg-stone-900/70 dark:text-ivory-50"
      />
    </label>
  );
}
