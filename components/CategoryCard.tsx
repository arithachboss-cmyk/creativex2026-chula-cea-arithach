import type { LucideIcon } from "lucide-react";
import Link from "next/link";

type CategoryCardProps = {
  href: string;
  title: string;
  description: string;
  Icon: LucideIcon;
};

export function CategoryCard({ href, title, description, Icon }: CategoryCardProps) {
  return (
    <Link
      href={href}
      className="group border border-temple-gold/20 bg-white/75 p-5 shadow-soft transition hover:-translate-y-0.5 hover:border-temple-gold/45 dark:bg-stone-900/70"
    >
      <Icon className="mb-5 h-7 w-7 text-temple-gold" aria-hidden="true" />
      <h3 className="font-serif text-xl font-semibold text-temple-deep dark:text-ivory-50">
        {title}
      </h3>
      <p className="mt-3 text-sm leading-7 text-stone-600 dark:text-stone-300">
        {description}
      </p>
    </Link>
  );
}
