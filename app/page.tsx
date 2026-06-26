import { BookOpen, Flower2, HandHeart, Moon, ScrollText, Sun, TreePine } from "lucide-react";
import { AppShell } from "@/components/AppShell";
import { CategoryCard } from "@/components/CategoryCard";
import { DharmaQuote } from "@/components/DharmaQuote";
import { InnerCover } from "@/components/InnerCover";
import { PrayerCard } from "@/components/PrayerCard";
import { SectionHeader } from "@/components/SectionHeader";
import { prayers } from "@/data/prayers";

const categoryCards = [
  {
    href: "/morning",
    title: "ทำวัตรเช้า",
    description: "ลำดับบทสวดเริ่มต้นวันด้วยจิตตั้งมั่นและเมตตา",
    Icon: Sun
  },
  {
    href: "/evening",
    title: "ทำวัตรเย็น",
    description: "อ่านทบทวนและวางใจให้สงบก่อนสิ้นวัน",
    Icon: Moon
  },
  {
    href: "/important",
    title: "บทสวดสำคัญ",
    description: "รวมบทบาลีหลัก เช่น นะโม อิติปิโส พาหุงมหากา",
    Icon: ScrollText
  },
  {
    href: "/merit",
    title: "แผ่เมตตาและอุทิศส่วนกุศล",
    description: "บทสวดเพื่อเกื้อกูลใจและน้อมอุทิศความดี",
    Icon: HandHeart
  },
  {
    href: "/meditation",
    title: "สมาธิและภาวนา",
    description: "หัวข้อฝึกสติและการภาวนาอย่างเรียบง่าย",
    Icon: Flower2
  },
  {
    href: "/dharma",
    title: "หลักธรรม",
    description: "สรุปหลักธรรมพื้นฐานสำหรับอ่านทบทวน",
    Icon: TreePine
  }
];

export default function Home() {
  return (
    <AppShell>
      <InnerCover />
      <section className="px-4 py-10 md:px-8 md:py-14">
        <div className="mx-auto max-w-5xl">
          <SectionHeader
            eyebrow="สารบัญหลัก"
            title="เลือกอ่านตามเวลาและเจตนา"
            description="จัดหมวดหมู่แบบหนังสือสวดมนต์ อ่านง่าย ค้นหาเร็ว และบันทึกบทที่ใช้ประจำไว้บนเครื่อง"
          />
          <div className="mt-10 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {categoryCards.map((card) => (
              <CategoryCard key={card.href} {...card} />
            ))}
          </div>
        </div>
      </section>
      <section className="px-4 py-10 md:px-8 md:py-14">
        <div className="mx-auto max-w-5xl">
          <DharmaQuote />
        </div>
      </section>
      <section className="px-4 py-10 md:px-8 md:py-14">
        <div className="mx-auto max-w-5xl">
          <SectionHeader
            eyebrow="บทสวดแนะนำ"
            title="เริ่มอ่านจากบทพื้นฐาน"
            description="ใช้บทบาลีดั้งเดิมในส่วนที่ปลอดภัย และระบุ TODO เมื่อจำเป็นต้องตรวจทานต้นฉบับก่อนเผยแพร่"
          />
          <div className="mt-10 grid gap-4 md:grid-cols-3">
            {prayers.slice(0, 6).map((prayer) => (
              <PrayerCard key={prayer.id} prayer={prayer} />
            ))}
          </div>
        </div>
      </section>
    </AppShell>
  );
}
