# Vercel และฐานข้อมูลสำหรับ CreativEX2026

## Vercel อยู่ไหน

เว็บออนไลน์อยู่ที่:

https://creativex2026-sharing.vercel.app/#dashboard

พื้นที่จัดการโปรเจกต์อยู่ใน Vercel Dashboard:

https://vercel.com/dashboard

ให้เข้าโปรเจกต์ `creativex2026-sharing` แล้วดู 3 จุดนี้:

1. `Deployments` สำหรับดูประวัติการ deploy
2. `Settings > Environment Variables` สำหรับใส่ค่าฐานข้อมูล
3. `Storage` หรือ `Integrations` สำหรับเชื่อมฐานข้อมูลและพื้นที่เก็บไฟล์

## ฐานข้อมูลควรใช้ตัวไหน

แนะนำ `Supabase` สำหรับรอบแรก เพราะได้ครบในชุดเดียว:

1. ระบบสมาชิกจริง: Supabase Auth
2. ฐานข้อมูลกลาง: Supabase Postgres
3. อัปโหลดไฟล์จริง: Supabase Storage
4. สิทธิ์ข้อมูล: Row Level Security

ถ้าต้องการอยู่ใน Vercel Marketplace มากขึ้น:

1. Database: Neon Postgres
2. File upload: Vercel Blob
3. Auth: Clerk หรือ Auth.js

## วิธีบูรณาการแบบเร็ว

1. สร้างโปรเจกต์ที่ Supabase
2. เปิด `SQL Editor`
3. วางไฟล์ [database/schema.sql](/Users/arithachbossabc/Documents/CreativEX2026%20Chula%20CEA%20Arithach/database/schema.sql) แล้วกด Run
4. ไปที่ `Storage` แล้วสร้าง bucket ชื่อ `knowledge-files`
5. ไปที่ Vercel Project `creativex2026-sharing`
6. เข้า `Settings > Environment Variables`
7. เพิ่มค่าจาก [.env.example](/Users/arithachbossabc/Documents/CreativEX2026%20Chula%20CEA%20Arithach/.env.example)
8. Redeploy เว็บบน Vercel

## โครงข้อมูลที่สร้างไว้

ตารางหลัก:

1. `profiles` เก็บสมาชิกและบทบาท
2. `executives` เก็บคณะผู้บริหาร
3. `resources` เก็บคลังความรู้และไฟล์ที่อัปโหลด
4. `portfolios` เก็บผลงานสมาชิก
5. `learning_events` เก็บคะแนนและกิจกรรมการเรียนรู้
6. `comments` เก็บข้อเสนอแนะ
7. `badges` เก็บระดับคะแนน
8. `audit_logs` เก็บประวัติการกระทำสำคัญ

วิวสำหรับ Dashboard:

1. `profile_scores` สรุปคะแนนรวมและจำนวนกิจกรรมต่อสมาชิก

## Environment Variables ที่ต้องมี

```text
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
SUPABASE_STORAGE_BUCKET=knowledge-files
```

ข้อสำคัญ:

1. `SUPABASE_ANON_KEY` ใช้ฝั่งเว็บได้เมื่อเปิด Row Level Security แล้ว
2. `SUPABASE_SERVICE_ROLE_KEY` ต้องใช้เฉพาะฝั่ง server เท่านั้น ห้ามใส่ในไฟล์ JavaScript ที่เปิดบนหน้าเว็บ
3. ถ้าเว็บยังเป็น static HTML ล้วน ควรย้ายไป `Next.js` ก่อนเชื่อม service role และ upload API จริง

## ลำดับงานถัดไป

1. ย้ายเว็บ static เป็น Next.js บน Vercel
2. ทำหน้าเข้าสู่ระบบด้วย Supabase Auth
3. ผูก `profiles` กับสมาชิกที่ login
4. เปลี่ยนคลังความรู้/ผลงาน/คะแนนจาก `localStorage` ไปอ่านเขียน Supabase
5. ทำ API upload ไฟล์ไป Supabase Storage หรือ Vercel Blob
6. ทำ Dashboard ผู้บริหารอ่านจาก `profile_scores`, `resources`, `portfolios`, `learning_events`

## สถานะตอนนี้

ตอนนี้โปรเจกต์ในเครื่องยังเป็นต้นแบบที่เก็บข้อมูลในเครื่องผู้ใช้ด้วย `localStorage` แต่มีไฟล์เตรียมบูรณาการฐานข้อมูลแล้ว:

1. [.env.example](/Users/arithachbossabc/Documents/CreativEX2026%20Chula%20CEA%20Arithach/.env.example)
2. [database/schema.sql](/Users/arithachbossabc/Documents/CreativEX2026%20Chula%20CEA%20Arithach/database/schema.sql)
3. [VERCEL_DATABASE_INTEGRATION.md](/Users/arithachbossabc/Documents/CreativEX2026%20Chula%20CEA%20Arithach/VERCEL_DATABASE_INTEGRATION.md)
