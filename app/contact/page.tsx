import { Mail, Printer, ScrollText } from "lucide-react";
import { AppShell } from "@/components/AppShell";
import { SectionHeader } from "@/components/SectionHeader";

export default function ContactPage() {
  return (
    <AppShell>
      <section className="px-4 py-12 md:px-8 md:py-16">
        <div className="mx-auto max-w-4xl">
          <SectionHeader
            eyebrow="ติดต่อ / ร่วมจัดพิมพ์"
            title="ร่วมดูแลต้นฉบับและจัดพิมพ์"
            description="พื้นที่นี้เตรียมไว้สำหรับข้อมูลติดต่อ ผู้ตรวจทานบทสวด ผู้สนับสนุนการจัดพิมพ์ และการเผยแพร่ฉบับออนไลน์"
          />
          <div className="mt-10 grid gap-4 md:grid-cols-3">
            {[
              {
                icon: Mail,
                title: "ติดต่อ",
                text: "TODO: เพิ่มอีเมลหรือช่องทางติดต่อ"
              },
              {
                icon: ScrollText,
                title: "ตรวจทานต้นฉบับ",
                text: "TODO: เพิ่มรายชื่อแหล่งอ้างอิงและผู้ตรวจทาน"
              },
              {
                icon: Printer,
                title: "ร่วมจัดพิมพ์",
                text: "TODO: เพิ่มรายละเอียดการสนับสนุน"
              }
            ].map((item) => (
              <article
                key={item.title}
                className="border border-temple-gold/20 bg-white/78 p-5 shadow-soft dark:bg-stone-900/70"
              >
                <item.icon className="mb-5 h-7 w-7 text-temple-gold" />
                <h2 className="font-serif text-xl font-semibold text-temple-deep dark:text-ivory-50">
                  {item.title}
                </h2>
                <p className="mt-3 text-sm leading-7 text-stone-600 dark:text-stone-300">
                  {item.text}
                </p>
              </article>
            ))}
          </div>
        </div>
      </section>
    </AppShell>
  );
}
