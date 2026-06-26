import { Flower2 } from "lucide-react";

export function InnerCover() {
  return (
    <section className="px-4 pb-10 pt-8 md:px-8 md:pb-16">
      <div className="mx-auto max-w-[760px] border border-temple-gold/35 bg-white/82 p-5 shadow-page dark:bg-stone-900/70 md:p-8">
        <div className="relative min-h-[520px] border border-temple-gold/45 px-6 py-10 text-center md:min-h-[680px] md:px-12 md:py-16">
          <div className="thai-border absolute inset-4 opacity-35" />
          <div className="relative z-10 flex min-h-[440px] flex-col items-center justify-between md:min-h-[560px]">
            <div>
              <Flower2 className="mx-auto h-12 w-12 text-temple-gold" />
              <p className="mt-6 text-sm font-medium text-temple-gold">ฉบับอ่านออนไลน์</p>
            </div>
            <div>
              <h1 className="font-serif text-4xl font-semibold leading-tight text-temple-deep dark:text-ivory-50 md:text-6xl">
                หนังสือสวดมนต์ออนไลน์
              </h1>
              <p className="mx-auto mt-6 max-w-md text-lg leading-9 text-stone-700 dark:text-stone-300">
                สวดมนต์ สมาธิ ปัญญา เมตตา สำหรับการอ่านอย่างสงบทั้งบนมือถือและหน้าจอใหญ่
              </p>
            </div>
            <div className="text-sm leading-7 text-stone-500 dark:text-stone-400">
              <p>ทำวัตรเช้า ทำวัตรเย็น แผ่เมตตา อุทิศส่วนกุศล</p>
              <p>เนื้อหาพร้อมปรับขนาดตัวอักษรและโหมดอ่านกลางคืน</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
