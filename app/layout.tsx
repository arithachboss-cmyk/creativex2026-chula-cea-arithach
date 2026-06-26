import type { Metadata } from "next";
import { Noto_Sans_Thai, Noto_Serif_Thai } from "next/font/google";
import "./globals.css";

const notoThai = Noto_Sans_Thai({
  subsets: ["thai", "latin"],
  variable: "--font-noto-thai",
  display: "swap"
});

const notoSerifThai = Noto_Serif_Thai({
  subsets: ["thai", "latin"],
  variable: "--font-noto-serif-thai",
  display: "swap"
});

export const metadata: Metadata = {
  title: "หนังสือสวดมนต์ออนไลน์ | สวดมนต์ สมาธิ ปัญญา เมตตา",
  description:
    "คลังบทสวดมนต์ออนไลน์สำหรับทำวัตรเช้า ทำวัตรเย็น แผ่เมตตา อุทิศส่วนกุศล และฝึกสมาธิ"
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="th" suppressHydrationWarning>
      <body className={`${notoThai.variable} ${notoSerifThai.variable} font-sans`}>
        {children}
      </body>
    </html>
  );
}
