import { Flower2 } from "lucide-react";

export function DharmaQuote() {
  return (
    <figure className="border-y border-temple-gold/30 py-8 text-center">
      <Flower2 className="mx-auto mb-4 h-7 w-7 text-temple-gold" aria-hidden="true" />
      <blockquote className="mx-auto max-w-2xl font-serif text-2xl leading-10 text-temple-deep dark:text-ivory-50">
        “สวดมนต์เพื่อระลึก ภาวนาเพื่อรู้ เมตตาเพื่อเกื้อกูล”
      </blockquote>
      <figcaption className="mt-3 text-sm text-stone-500 dark:text-stone-400">
        ข้อความเรียบเรียงใหม่สำหรับเว็บไซต์นี้
      </figcaption>
    </figure>
  );
}
