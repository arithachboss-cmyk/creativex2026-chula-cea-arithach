import Link from "next/link";
import { ChevronRight } from "lucide-react";
import type { Prayer } from "@/data/prayers";
import { BookmarkButton } from "./BookmarkButton";

export function PrayerCard({ prayer }: { prayer: Prayer }) {
  return (
    <article className="border border-temple-gold/20 bg-white/80 p-5 shadow-soft transition hover:-translate-y-0.5 hover:border-temple-gold/45 dark:bg-stone-900/70">
      <div className="mb-4 flex items-start justify-between gap-4">
        <div>
          <p className="mb-1 text-xs font-medium text-temple-gold">{prayer.category}</p>
          <h3 className="font-serif text-xl font-semibold text-temple-deep dark:text-ivory-50">
            {prayer.title}
          </h3>
        </div>
        <BookmarkButton prayerId={prayer.id} />
      </div>
      <p className="mb-5 line-clamp-2 text-sm leading-7 text-stone-600 dark:text-stone-300">
        {prayer.excerpt}
      </p>
      <Link
        href={`/${prayer.page}#${prayer.id}`}
        className="inline-flex items-center gap-2 text-sm font-medium text-temple-green hover:text-temple-gold dark:text-[#a7d5c7]"
      >
        เปิดอ่าน
        <ChevronRight className="h-4 w-4" />
      </Link>
    </article>
  );
}
