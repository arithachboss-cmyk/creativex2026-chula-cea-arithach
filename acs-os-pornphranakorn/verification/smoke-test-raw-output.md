# Raw output — run-smoke-test.sh

Run: 2026-10-10T00:49:34Z · psql (PostgreSQL) 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1) · disposable cluster under /var/tmp, removed after run

```text
### Load v2.1-proposed-schema.sql
### Load option-b-terms-decision.sql
### smoke-test.sql
== T01 lead + acquisition + consent + outbox ใน transaction เดียว (สำเร็จ)
 leads 
-------
     1
(1 row)

== T02 acquisition ล้ม => rollback ทั้งหมด (คาดว่า leads ยังเป็น 1)
psql:/var/tmp/acs-smoke/schema/smoke-test.sql:39: ERROR:  new row for relation "lead_acquisition" violates check constraint "lead_acquisition_check"
DETAIL:  Failing row contains (00000000-0000-0000-0000-000000000102, public_form, {}, TEST-campaign, null, <ts>).
 leads_after_failed_tx 
-----------------------
                     1
(1 row)

== T03 idempotency key ซ้ำ: ON CONFLICT DO NOTHING คืน 0 แถว แล้วเทียบ hash
 result 
--------
(0 rows)

 same_payload | conflicting_payload 
--------------+---------------------
 t            | f
(1 row)

== T04 idempotency หมดอายุ: takeover แบบ atomic เฉพาะแถวที่ expires_at <= now()
      result       
-------------------
 took_over_expired
(1 row)

== T05 deal + terms v1, v2 แล้วแก้ terms v1 (คาดว่า ERROR append-only)
psql:/var/tmp/acs-smoke/schema/smoke-test.sql:85: ERROR:  table acs.deal_terms_version is append-only (UPDATE rejected)
CONTEXT:  PL/pgSQL function reject_mutation() line 3 at RAISE
psql:/var/tmp/acs-smoke/schema/smoke-test.sql:86: ERROR:  table acs.deal_terms_version is append-only (DELETE rejected)
CONTEXT:  PL/pgSQL function reject_mutation() line 3 at RAISE
== T06 terms version ของ deal อื่น (คาดว่า ERROR composite FK ตอน commit)
psql:/var/tmp/acs-smoke/schema/smoke-test.sql:95: ERROR:  insert or update on table "deal" violates foreign key constraint "deal_current_terms_fk"
DETAIL:  Key (id, current_terms_version_id)=(00000000-0000-0000-0000-000000000202, 00000000-0000-0000-0000-000000000301) is not present in table "deal_terms_version".
== T07 binding ด้วย stale version (v1 แทน v2) => 0 แถว
 result 
--------
(0 rows)

== T08 binding ด้วย stale row_version => 0 แถว
 result 
--------
(0 rows)

== T09 binding ถูกต้อง + audit + outbox ใน transaction เดียว => 1 แถว
 rv_after 
----------
        3
(1 row)

== T10 เปลี่ยน version หลัง bound (คาดว่า ERROR)
psql:/var/tmp/acs-smoke/schema/smoke-test.sql:126: ERROR:  deal 00000000-0000-0000-0000-000000000201 is bound; binding is immutable
CONTEXT:  PL/pgSQL function guard_bound_deal() line 7 at RAISE
== T11 แก้/ลบ audit (คาดว่า ERROR ทั้งสองคำสั่ง)
psql:/var/tmp/acs-smoke/schema/smoke-test.sql:129: ERROR:  table acs.audit_event is append-only (UPDATE rejected)
CONTEXT:  PL/pgSQL function reject_mutation() line 3 at RAISE
psql:/var/tmp/acs-smoke/schema/smoke-test.sql:130: ERROR:  table acs.audit_event is append-only (DELETE rejected)
CONTEXT:  PL/pgSQL function reject_mutation() line 3 at RAISE
== T12 outbox fencing (provider ไม่ idempotent): A claim -> lease หมด -> A heartbeat ถูกปฏิเสธ -> reclaim ย้ายเป็น uncertain -> A ack ถูกปฏิเสธ
                       event_key                       |               token_a                
-------------------------------------------------------+--------------------------------------
 crm:lead_created:00000000-0000-0000-0000-000000000101 | 00000000-0000-0000-0000-0000000000aa
(1 row)

-- A heartbeat หลัง lease หมด แต่ก่อนมีใคร reclaim (คาดว่า 0 แถว)
 result 
--------
(0 rows)

                       event_key                       |  status   | lease_token 
-------------------------------------------------------+-----------+-------------
 crm:lead_created:00000000-0000-0000-0000-000000000101 | uncertain | 
(1 row)

-- A ack ด้วย token เก่า (คาดว่า 0 แถว)
 result 
--------
(0 rows)

== T13 กรณี provider idempotent: reclaim หมุน token แล้ว ack ด้วย token ใหม่ได้, token เก่าไม่ได้
 attempt_count 
---------------
             2
(1 row)

 result 
--------
(0 rows)

       result       
--------------------
 fresh ack accepted
(1 row)

== T14 ถอน consent: ยกเลิก queued events ของ purpose นั้นใน transaction เดียว
      event_key      |  status   
---------------------+-----------
 crm:followup:TEST:1 | cancelled
(1 row)

               lead_id                |    purpose    | event_type 
--------------------------------------+---------------+------------
 00000000-0000-0000-0000-000000000101 | TEST_followup | withdrawn
(1 row)

== T15 erasure: ล้าง PII ใน lead ได้, แต่สถานะ erased ที่ยังมี PII ถูก CHECK ปฏิเสธ
psql:/var/tmp/acs-smoke/schema/smoke-test.sql:204: ERROR:  new row for relation "lead" violates check constraint "lead_check"
DETAIL:  Failing row contains (00000000-0000-0000-0000-000000000101, <random-uuid>, erased, null, TEST Person, test@example.invalid, null, null, th, null, <ts>, 1, <ts>, <ts>).
                  id                  | status 
--------------------------------------+--------
 00000000-0000-0000-0000-000000000101 | erased
(1 row)

== T16 ห้ามลบ deal
psql:/var/tmp/acs-smoke/schema/smoke-test.sql:209: ERROR:  table acs.deal is append-only (DELETE rejected)
CONTEXT:  PL/pgSQL function reject_mutation() line 3 at RAISE
== สรุปสถานะ outbox
                       event_key                       |  status   | attempt_count | cancelled_reason  
-------------------------------------------------------+-----------+---------------+-------------------
 crm:followup:TEST:1                                   | cancelled |             0 | consent_withdrawn
 crm:lead_created:00000000-0000-0000-0000-000000000101 | uncertain |             1 | 
 notify:TEST:1                                         | succeeded |             2 | 
(3 rows)

### C01 concurrent duplicate idempotency key (2 sessions จริง)
session1:  session-1 inserted 
session2: ' ' (ว่าง = 0 แถว => ตรวจ hash แล้ว replay/409)
session2 waited: 2.0s (คาด ~2s เพราะรอ unique index ของ session 1)
 rows for key: 1

### C02 concurrent claim: 2 workers SKIP LOCKED ไม่ claim แถวเดียวกัน
worker1 claimed=15 worker2 claimed=5 overlap=0 (คาด 15/5/0)
```
