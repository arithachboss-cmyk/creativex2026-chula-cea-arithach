# พรพระนคร — ACS OS: ชุดแบบ Engineering v2.2

> **โฟลเดอร์นี้เป็นเอกสารออกแบบเท่านั้น** repository นี้ (`creativex2026-chula-cea-arithach`) **ไม่ใช่ repository เป้าหมาย** ของ ACS OS และไม่ได้ใช้เป็นหลักฐาน existing stack เก็บไว้ที่นี่ชั่วคราวจนกว่าเจ้าของจะระบุ repo เป้าหมาย (LIL-34)

สถานะ: `DESIGN_DRAFT` · `IMPLEMENTATION_BLOCKED` · `NOT_DEPLOYED` · Verdict **REVISE**

| ไฟล์ | เนื้อหา |
|---|---|
| [`ACS_OS_Engineering_v2.2.md`](ACS_OS_Engineering_v2.2.md) | เอกสารหลักฉบับรวม (v2.2 แก้จำนวนหน้าจอใน §10.7 จาก v2.1 ดู §1.2; v2.1 อยู่ที่ commit `1fadfd3`): แหล่งอ้างอิง, changelog เทียบ v2, discrepancy register, architecture, data design, transactions, outbox, security, privacy, prototype contract, ADR, delivery/acceptance, verdict |
| [`schema/v2.1-proposed-schema.sql`](schema/v2.1-proposed-schema.sql) | DDL ที่เสนอ (Option A) — ไม่ใช่ migration ของระบบจริง; ไม่เปลี่ยนใน v2.2 |
| [`schema/option-b-terms-decision.sql`](schema/option-b-terms-decision.sql) | ตาราง approval แบบ CONDITIONAL ใช้เมื่อเจ้าของยืนยันขั้นอนุมัติ |
| [`schema/smoke-test.sql`](schema/smoke-test.sql), [`schema/run-smoke-test.sh`](schema/run-smoke-test.sh) | smoke test ของ DDL บน PostgreSQL ชั่วคราว รวม concurrency 2 sessions |
| [`verification/smoke-test-raw-output.md`](verification/smoke-test-raw-output.md) | ผลรันจริง (PostgreSQL 16.15, 2026-10-10) |

รัน smoke test ซ้ำ (ต้องเป็นผู้ใช้ที่ไม่ใช่ root และมี PostgreSQL 16 binaries):

```bash
PGBIN=/usr/lib/postgresql/16/bin ./schema/run-smoke-test.sh /tmp/acs-smoke
```

ผล smoke test พิสูจน์พฤติกรรม constraint/trigger ของแบบที่เสนอเท่านั้น ไม่ใช่ implementation, application test, reviewer approval หรือ deployment
