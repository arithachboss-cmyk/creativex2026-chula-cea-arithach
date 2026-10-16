-- Smoke test ของ DDL ที่เสนอ บนฐานข้อมูลชั่วคราวเท่านั้น (fixtures ติดป้าย TEST)
-- ตรวจ constraint/trigger ระดับฐานข้อมูล ไม่ใช่ application acceptance test
\set ON_ERROR_STOP off
\pset footer on
SET search_path = acs, public;

\echo '== T01 lead + acquisition + consent + outbox ใน transaction เดียว (สำเร็จ)'
INSERT INTO privacy_notice_version (id, version_label, locale, content_sha256, published_at)
VALUES ('00000000-0000-0000-0000-0000000000a1','TEST-notice-1','th', sha256('TEST notice'), now());
INSERT INTO app_user (id, external_auth_id, display_name)
VALUES ('00000000-0000-0000-0000-00000000000a','TEST-auth-a','TEST maker'),
       ('00000000-0000-0000-0000-00000000000b','TEST-auth-b','TEST checker');

BEGIN;
INSERT INTO idempotency_record (endpoint, scope_kind, scope_id, idem_key, request_sha256,
                                resource_type, resource_id, response_status, expires_at)
VALUES ('POST /public/leads','anonymous_session','TEST-sess-1','TEST-key-0000000001',
        sha256('payload-1'),'lead','00000000-0000-0000-0000-000000000101',202, now() + interval '24 hours')
ON CONFLICT DO NOTHING;
INSERT INTO lead (id, full_name, email, locale)
VALUES ('00000000-0000-0000-0000-000000000101','TEST Person','test@example.invalid','th');
INSERT INTO lead_acquisition (lead_id, channel, claimed_source)
VALUES ('00000000-0000-0000-0000-000000000101','public_form','{"utm_source":"TEST"}');
INSERT INTO consent_event (lead_id, purpose, legal_basis, event_type, notice_version_id, source)
VALUES ('00000000-0000-0000-0000-000000000101','TEST_followup','TEST_basis','granted',
        '00000000-0000-0000-0000-0000000000a1','public_form');
INSERT INTO outbox_event (event_key, destination, event_type, payload_version, payload,
                          subject_lead_id, consent_purpose, provider_idempotent)
VALUES ('crm:lead_created:00000000-0000-0000-0000-000000000101','crm','lead_created',1,
        '{"lead_ref":"00000000-0000-0000-0000-000000000101"}',
        '00000000-0000-0000-0000-000000000101','TEST_followup', false);
COMMIT;
SELECT count(*) AS leads FROM lead;

\echo '== T02 acquisition ล้ม => rollback ทั้งหมด (คาดว่า leads ยังเป็น 1)'
BEGIN;
INSERT INTO lead (id, full_name) VALUES ('00000000-0000-0000-0000-000000000102','TEST rollback');
INSERT INTO lead_acquisition (lead_id, channel, verified_campaign_ref)  -- ละเมิด CHECK
VALUES ('00000000-0000-0000-0000-000000000102','public_form','TEST-campaign');
COMMIT;
SELECT count(*) AS leads_after_failed_tx FROM lead;

\echo '== T03 idempotency key ซ้ำ: ON CONFLICT DO NOTHING คืน 0 แถว แล้วเทียบ hash'
INSERT INTO idempotency_record (endpoint, scope_kind, scope_id, idem_key, request_sha256,
                                resource_type, resource_id, response_status, expires_at)
VALUES ('POST /public/leads','anonymous_session','TEST-sess-1','TEST-key-0000000001',
        sha256('payload-DIFFERENT'),'lead',gen_random_uuid(),202, now() + interval '24 hours')
ON CONFLICT DO NOTHING RETURNING 'inserted' AS result;
SELECT (request_sha256 = sha256('payload-1')) AS same_payload,
       (request_sha256 = sha256('payload-DIFFERENT')) AS conflicting_payload
FROM idempotency_record WHERE idem_key = 'TEST-key-0000000001';

\echo '== T04 idempotency หมดอายุ: takeover แบบ atomic เฉพาะแถวที่ expires_at <= now()'
INSERT INTO idempotency_record (endpoint, scope_kind, scope_id, idem_key, request_sha256,
                                resource_type, resource_id, response_status, created_at, expires_at)
VALUES ('POST /public/leads','anonymous_session','TEST-sess-2','TEST-key-0000000002',
        sha256('old'),'lead',gen_random_uuid(),202, now() - interval '2 days', now() - interval '1 day');
INSERT INTO idempotency_record AS r (endpoint, scope_kind, scope_id, idem_key, request_sha256,
                                resource_type, resource_id, response_status, expires_at)
VALUES ('POST /public/leads','anonymous_session','TEST-sess-2','TEST-key-0000000002',
        sha256('new'),'lead',gen_random_uuid(),202, now() + interval '24 hours')
ON CONFLICT (endpoint, scope_kind, scope_id, idem_key) DO UPDATE
  SET request_sha256 = EXCLUDED.request_sha256, resource_id = EXCLUDED.resource_id,
      created_at = now(), expires_at = EXCLUDED.expires_at
  WHERE r.expires_at <= now()
RETURNING 'took_over_expired' AS result;

\echo '== T05 deal + terms v1, v2 แล้วแก้ terms v1 (คาดว่า ERROR append-only)'
BEGIN;
INSERT INTO deal (id, lead_id, owner_user_id)
VALUES ('00000000-0000-0000-0000-000000000201','00000000-0000-0000-0000-000000000101',
        '00000000-0000-0000-0000-00000000000a');
INSERT INTO deal_terms_version (id, deal_id, version_no, currency, total_amount, terms_document,
                                content_sha256, created_by_user_id)
VALUES ('00000000-0000-0000-0000-000000000301','00000000-0000-0000-0000-000000000201',1,'XXX',
        1000.10,'{"total_amount":"1000.10"}', sha256('v1'),'00000000-0000-0000-0000-00000000000a');
INSERT INTO deal_terms_version (id, deal_id, version_no, supersedes_version_id, currency, total_amount,
                                terms_document, content_sha256, created_by_user_id)
VALUES ('00000000-0000-0000-0000-000000000302','00000000-0000-0000-0000-000000000201',2,
        '00000000-0000-0000-0000-000000000301','XXX',
        1000.20,'{"total_amount":"1000.20"}', sha256('v2'),'00000000-0000-0000-0000-00000000000a');
UPDATE deal SET current_terms_version_id = '00000000-0000-0000-0000-000000000302', status='terms_proposed'
WHERE id = '00000000-0000-0000-0000-000000000201';
COMMIT;
UPDATE deal_terms_version SET total_amount = 1 WHERE id = '00000000-0000-0000-0000-000000000301';
DELETE FROM deal_terms_version WHERE id = '00000000-0000-0000-0000-000000000301';

\echo '== T06 terms version ของ deal อื่น (คาดว่า ERROR composite FK ตอน commit)'
BEGIN;
INSERT INTO deal (id, lead_id, owner_user_id)
VALUES ('00000000-0000-0000-0000-000000000202','00000000-0000-0000-0000-000000000101',
        '00000000-0000-0000-0000-00000000000a');
UPDATE deal SET current_terms_version_id = '00000000-0000-0000-0000-000000000301'
WHERE id = '00000000-0000-0000-0000-000000000202';
COMMIT;

\echo '== T07 binding ด้วย stale version (v1 แทน v2) => 0 แถว'
SELECT row_version AS rv_before FROM deal WHERE id='00000000-0000-0000-0000-000000000201' \gset
UPDATE deal SET status='bound', bound_terms_version_id='00000000-0000-0000-0000-000000000301',
       bound_at=now(), bound_by_user_id='00000000-0000-0000-0000-00000000000b'
WHERE id='00000000-0000-0000-0000-000000000201' AND row_version = :rv_before
  AND current_terms_version_id='00000000-0000-0000-0000-000000000301' AND status='terms_proposed'
RETURNING 'UNEXPECTED: stale version bound' AS result;

\echo '== T08 binding ด้วย stale row_version => 0 แถว'
UPDATE deal SET status='bound', bound_terms_version_id='00000000-0000-0000-0000-000000000302',
       bound_at=now(), bound_by_user_id='00000000-0000-0000-0000-00000000000b'
WHERE id='00000000-0000-0000-0000-000000000201' AND row_version = :rv_before - 1
  AND current_terms_version_id='00000000-0000-0000-0000-000000000302' AND status='terms_proposed'
RETURNING 'UNEXPECTED: stale row_version bound' AS result;

\echo '== T09 binding ถูกต้อง + audit + outbox ใน transaction เดียว => 1 แถว'
BEGIN;
UPDATE deal SET status='bound', bound_terms_version_id='00000000-0000-0000-0000-000000000302',
       bound_at=now(), bound_by_user_id='00000000-0000-0000-0000-00000000000b'
WHERE id='00000000-0000-0000-0000-000000000201' AND row_version = :rv_before
  AND current_terms_version_id='00000000-0000-0000-0000-000000000302' AND status='terms_proposed'
RETURNING row_version AS rv_after;
INSERT INTO audit_event (actor_type, actor_user_id, action, entity_type, entity_id, terms_version_id)
VALUES ('user','00000000-0000-0000-0000-00000000000b','deal.bound','deal',
        '00000000-0000-0000-0000-000000000201','00000000-0000-0000-0000-000000000302');
COMMIT;

\echo '== T10 เปลี่ยน version หลัง bound (คาดว่า ERROR)'
UPDATE deal SET bound_terms_version_id='00000000-0000-0000-0000-000000000301'
WHERE id='00000000-0000-0000-0000-000000000201';

\echo '== T11 แก้/ลบ audit (คาดว่า ERROR ทั้งสองคำสั่ง)'
UPDATE audit_event SET action='tampered';
DELETE FROM audit_event;

\echo '== T12 outbox fencing (provider ไม่ idempotent): A claim -> lease หมด -> A heartbeat ถูกปฏิเสธ -> reclaim ย้ายเป็น uncertain -> A ack ถูกปฏิเสธ'
-- claim (A)
UPDATE outbox_event SET status='processing', lease_token='00000000-0000-0000-0000-0000000000aa',
       lease_expires_at = now() + interval '30 seconds', attempt_count = attempt_count + 1,
       attempt_started_at = now(), updated_at = now()
WHERE id IN (SELECT id FROM outbox_event
             WHERE (status='pending' AND next_attempt_at <= now())
                OR (status='processing' AND lease_expires_at < now())
             ORDER BY next_attempt_at FOR UPDATE SKIP LOCKED LIMIT 10)
RETURNING event_key, lease_token AS token_a;
-- จำลองเวลาผ่านไปจน lease ของ A หมด (fixture เท่านั้น)
UPDATE outbox_event SET lease_expires_at = now() - interval '1 second' WHERE status='processing';
\echo '-- A heartbeat หลัง lease หมด แต่ก่อนมีใคร reclaim (คาดว่า 0 แถว)'
UPDATE outbox_event SET lease_expires_at = now() + interval '30 seconds'
WHERE id = (SELECT id FROM outbox_event LIMIT 1) AND status='processing'
  AND lease_token='00000000-0000-0000-0000-0000000000aa' AND lease_expires_at > now()
RETURNING 'UNEXPECTED: expired heartbeat accepted' AS result;
-- reclaim (B): provider ไม่รองรับ idempotency และ attempt ก่อนหน้าเริ่มแล้ว => ย้ายเป็น uncertain ไม่ส่งซ้ำ
UPDATE outbox_event SET
       status = CASE WHEN status='processing' AND NOT provider_idempotent THEN 'uncertain' ELSE 'processing' END,
       lease_token = CASE WHEN status='processing' AND NOT provider_idempotent THEN NULL
                          ELSE '00000000-0000-0000-0000-0000000000bb'::uuid END,
       lease_expires_at = CASE WHEN status='processing' AND NOT provider_idempotent THEN NULL
                               ELSE now() + interval '30 seconds' END,
       last_error = CASE WHEN status='processing' AND NOT provider_idempotent
                         THEN 'lease expired with unknown outcome; reconcile before resend' ELSE last_error END,
       updated_at = now()
WHERE id IN (SELECT id FROM outbox_event WHERE status='processing' AND lease_expires_at < now()
             FOR UPDATE SKIP LOCKED LIMIT 10)
RETURNING event_key, status, lease_token;
\echo '-- A ack ด้วย token เก่า (คาดว่า 0 แถว)'
UPDATE outbox_event SET status='succeeded', lease_token=NULL, lease_expires_at=NULL, updated_at=now()
WHERE id = (SELECT id FROM outbox_event LIMIT 1) AND status='processing'
  AND lease_token='00000000-0000-0000-0000-0000000000aa' AND lease_expires_at > now()
RETURNING 'UNEXPECTED: stale ack accepted' AS result;

\echo '== T13 กรณี provider idempotent: reclaim หมุน token แล้ว ack ด้วย token ใหม่ได้, token เก่าไม่ได้'
INSERT INTO outbox_event (event_key, destination, event_type, payload_version, payload, provider_idempotent,
                          status, lease_token, lease_expires_at, attempt_count, attempt_started_at)
VALUES ('notify:TEST:1','notify','lead_created',1,'{}', true, 'processing',
        '00000000-0000-0000-0000-0000000000a2', now() - interval '1 second', 1, now() - interval '1 minute');
UPDATE outbox_event SET lease_token='00000000-0000-0000-0000-0000000000b2',
       lease_expires_at = now() + interval '30 seconds', attempt_count = attempt_count + 1
WHERE event_key='notify:TEST:1' AND status='processing' AND lease_expires_at < now()
RETURNING attempt_count;
UPDATE outbox_event SET status='succeeded', lease_token=NULL, lease_expires_at=NULL
WHERE event_key='notify:TEST:1' AND status='processing'
  AND lease_token='00000000-0000-0000-0000-0000000000a2' AND lease_expires_at > now()
RETURNING 'UNEXPECTED: stale ack accepted' AS result;
UPDATE outbox_event SET status='succeeded', lease_token=NULL, lease_expires_at=NULL
WHERE event_key='notify:TEST:1' AND status='processing'
  AND lease_token='00000000-0000-0000-0000-0000000000b2' AND lease_expires_at > now()
RETURNING 'fresh ack accepted' AS result;

\echo '== T14 ถอน consent: ยกเลิก queued events ของ purpose นั้นใน transaction เดียว'
INSERT INTO outbox_event (event_key, destination, event_type, payload_version, payload,
                          subject_lead_id, consent_purpose, provider_idempotent)
VALUES ('crm:followup:TEST:1','crm','followup_requested',1,'{}',
        '00000000-0000-0000-0000-000000000101','TEST_followup', true);
BEGIN;
INSERT INTO consent_event (lead_id, purpose, legal_basis, event_type, notice_version_id, source)
VALUES ('00000000-0000-0000-0000-000000000101','TEST_followup','TEST_basis','withdrawn',
        '00000000-0000-0000-0000-0000000000a1','subject_request');
UPDATE outbox_event SET status='cancelled', cancelled_reason='consent_withdrawn', updated_at=now()
WHERE subject_lead_id='00000000-0000-0000-0000-000000000101' AND consent_purpose='TEST_followup'
  AND status='pending'
RETURNING event_key, status;
COMMIT;
SELECT lead_id, purpose, event_type FROM consent_current;

\echo '== T15 erasure: ล้าง PII ใน lead ได้, แต่สถานะ erased ที่ยังมี PII ถูก CHECK ปฏิเสธ'
UPDATE lead SET status='erased', erased_at=now()
WHERE id='00000000-0000-0000-0000-000000000101';
UPDATE lead SET status='erased', erased_at=now(), full_name=NULL, email=NULL, phone=NULL, message=NULL
WHERE id='00000000-0000-0000-0000-000000000101' RETURNING id, status;

\echo '== T16 ห้ามลบ deal'
DELETE FROM deal WHERE id='00000000-0000-0000-0000-000000000201';

\echo '== สรุปสถานะ outbox'
SELECT event_key, status, attempt_count, cancelled_reason FROM outbox_event ORDER BY event_key;
