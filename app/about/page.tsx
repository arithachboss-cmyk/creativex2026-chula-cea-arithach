import { AppShell } from "@/components/AppShell";
import { SectionHeader } from "@/components/SectionHeader";

export default function AboutPage() {
  return (
    <AppShell>
      <section className="px-4 py-12 md:px-8 md:py-16">
        <div className="mx-auto max-w-3xl">
          <SectionHeader
            eyebrow="เกี่ยวกับหนังสือ"
            title="หนังสือสวดมนต์ออนไลน์"
            description="เว็บไซต์นี้ออกแบบให้เป็นพื้นที่อ่านบทสวดอย่างสงบ ใช้โครงหน้าแบบหนังสือ A5 มีสารบัญ ค้นหา ปรับตัวอักษร โหมดกลางคืน และบันทึกบทที่ใช้ประจำในเครื่องของผู้อ่าน"
          />
          <div className="mt-10 space-y-6 border border-temple-gold/25 bg-white/78 p-6 text-base leading-8 text-stone-700 shadow-soft dark:bg-stone-900/70 dark:text-stone-300">
            <p>
              แนวทางเนื้อหาใช้บทบาลีดั้งเดิมในส่วนที่ปลอดภัย และใส่เครื่องหมาย TODO
              สำหรับบทที่ควรตรวจทานต้นฉบับหรือถ้อยคำภาษาไทยก่อนเผยแพร่จริง
            </p>
            <p>
              โทนภาพรวมใช้สีงาช้าง ขาว ทอง และลวดลายไทยอย่างบางเบา เพื่อรักษาความสุภาพ
              อ่านง่าย และเหมาะกับทั้งมือถือและเดสก์ท็อป
            </p>
          </div>
        </div>
      </section>
    </AppShell>
  );
}
