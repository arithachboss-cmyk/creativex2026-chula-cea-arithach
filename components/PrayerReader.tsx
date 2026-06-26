"use client";

import { Copy, List } from "lucide-react";
import { useMemo, useState } from "react";
import type { Prayer } from "@/data/prayers";
import { BookmarkButton } from "./BookmarkButton";
import { FontSizeControl } from "./FontSizeControl";
import { SearchBar } from "./SearchBar";

export function PrayerReader({ prayers, title }: { prayers: Prayer[]; title: string }) {
  const [query, setQuery] = useState("");
  const [fontSize, setFontSize] = useState(24);
  const [copied, setCopied] = useState<string | null>(null);

  const filtered = useMemo(() => {
    const normalized = query.trim().toLowerCase();
    if (!normalized) return prayers;
    return prayers.filter((prayer) =>
      `${prayer.title} ${prayer.category} ${prayer.content}`.toLowerCase().includes(normalized)
    );
  }, [prayers, query]);

  async function copyPrayer(prayer: Prayer) {
    await navigator.clipboard.writeText(`${prayer.title}\n\n${prayer.content}`);
    setCopied(prayer.id);
    window.setTimeout(() => setCopied(null), 1500);
  }

  return (
    <section className="px-4 py-8 md:px-8 md:py-12">
      <div className="mx-auto max-w-5xl">
        <div className="mb-6 grid gap-4 md:grid-cols-[1fr_auto] md:items-center">
          <SearchBar value={query} onChange={setQuery} />
          <FontSizeControl value={fontSize} onChange={setFontSize} />
        </div>

        <div className="grid gap-6 lg:grid-cols-[220px_minmax(0,1fr)]">
          <aside className="border border-temple-gold/20 bg-white/65 p-4 dark:bg-stone-900/60">
            <div className="mb-3 flex items-center gap-2 text-sm font-medium text-temple-deep dark:text-ivory-50">
              <List className="h-4 w-4 text-temple-gold" />
              สารบัญ
            </div>
            <nav className="space-y-2 text-sm">
              {prayers.map((prayer) => (
                <a
                  key={prayer.id}
                  href={`#${prayer.id}`}
                  className="block leading-6 text-stone-600 hover:text-temple-gold dark:text-stone-300"
                >
                  {prayer.title}
                </a>
              ))}
            </nav>
          </aside>

          <div className="space-y-8">
            <div className="book-page relative mx-auto min-h-[70vh] max-w-[740px] border border-temple-gold/25 px-6 py-8 shadow-page md:px-12 md:py-12">
              <div className="thai-border pointer-events-none absolute inset-3 opacity-30" />
              <div className="relative">
                <p className="text-sm font-medium text-temple-gold">หนังสือสวดมนต์ออนไลน์</p>
                <h1 className="mt-2 font-serif text-3xl font-semibold text-temple-deep dark:text-ivory-50 md:text-4xl">
                  {title}
                </h1>
                <div className="mt-6 h-px bg-temple-gold/35" />
              </div>

              <div className="relative mt-8 space-y-10">
                {filtered.map((prayer) => (
                  <article key={prayer.id} id={prayer.id} className="scroll-mt-28">
                    <div className="mb-4 flex items-start justify-between gap-4">
                      <div>
                        <p className="text-xs font-medium text-temple-gold">{prayer.category}</p>
                        <h2 className="font-serif text-2xl font-semibold text-temple-deep dark:text-ivory-50">
                          {prayer.title}
                        </h2>
                      </div>
                      <div className="flex shrink-0 gap-2">
                        <BookmarkButton prayerId={prayer.id} />
                        <button
                          type="button"
                          onClick={() => copyPrayer(prayer)}
                          className="grid h-10 w-10 place-items-center border border-temple-gold/25 bg-white/75 text-temple-deep transition hover:border-temple-gold dark:bg-stone-900 dark:text-ivory-50"
                          aria-label="คัดลอกบทสวด"
                          title="คัดลอกบทสวด"
                        >
                          <Copy className="h-4 w-4" />
                        </button>
                      </div>
                    </div>
                    <pre
                      className="whitespace-pre-wrap font-serif leading-[2.05] text-temple-ink dark:text-ivory-50"
                      style={{ fontSize }}
                    >
                      {prayer.content}
                    </pre>
                    {prayer.note ? (
                      <p className="mt-4 border-l-2 border-temple-gold/50 pl-3 text-sm leading-7 text-stone-500 dark:text-stone-400">
                        {prayer.note}
                      </p>
                    ) : null}
                    {copied === prayer.id ? (
                      <p className="mt-3 text-sm text-temple-green dark:text-[#a7d5c7]">
                        คัดลอกแล้ว
                      </p>
                    ) : null}
                  </article>
                ))}

                {filtered.length === 0 ? (
                  <p className="py-16 text-center text-stone-500 dark:text-stone-400">
                    ไม่พบบทสวดที่ค้นหา
                  </p>
                ) : null}
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
