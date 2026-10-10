-- ACS OS Engineering v2.1 — PROPOSED schema (design artifact, not a migration)
-- สถานะ: ข้อเสนอเพื่อตรวจแบบ ยังไม่ได้รันกับฐานข้อมูลของระบบเป้าหมาย
-- ทดสอบเฉพาะบน PostgreSQL 16 ชั่วคราว ดู verification/smoke-test-raw-output.md
-- ค่าที่รอเจ้าของ (ห้ามเดา): สกุลเงิน/scale, ค่าธรรมเนียม, นิยาม binding, retention, TTL ที่ผูกนโยบาย
-- Option A (baseline): immutable terms version + lifecycle อยู่บน deal row
-- Option B (มีขั้นอนุมัติแยก): ดู option-b-terms-decision.sql — สร้างเมื่อเจ้าของยืนยันเท่านั้น

BEGIN;

CREATE SCHEMA IF NOT EXISTS acs;
SET search_path = acs, public;

-- ---------------------------------------------------------------------------
-- Shared guard: ปฏิเสธ UPDATE/DELETE บนตาราง append-only / immutable
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION acs.reject_mutation() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'table %.% is append-only (% rejected)',
    TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_OP
    USING ERRCODE = 'restrict_violation';
END;
$$;

-- ---------------------------------------------------------------------------
-- Identity (ใช้ auth provider เดิมของ repo ถ้าผ่านข้อกำหนด ตารางนี้เป็น mapping ภายใน)
-- ---------------------------------------------------------------------------
CREATE TABLE acs.app_user (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  external_auth_id text NOT NULL UNIQUE,           -- subject จาก auth provider
  display_name   text NOT NULL,
  status         text NOT NULL DEFAULT 'active'
                 CHECK (status IN ('active','suspended','deactivated')),
  mfa_enrolled   boolean NOT NULL DEFAULT false,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);

-- บทบาทเป็นข้อเสนอ (รอเจ้าของยืนยัน) จึงไม่ใช้ enum เพื่อให้แก้ได้โดยไม่ต้อง ALTER TYPE
CREATE TABLE acs.user_role (
  user_id    uuid NOT NULL REFERENCES acs.app_user(id),
  role       text NOT NULL,
  granted_at timestamptz NOT NULL DEFAULT now(),
  granted_by uuid REFERENCES acs.app_user(id),
  PRIMARY KEY (user_id, role)
);

-- ---------------------------------------------------------------------------
-- Privacy notice versions (immutable)
-- ---------------------------------------------------------------------------
CREATE TABLE acs.privacy_notice_version (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version_label text NOT NULL,
  locale        text NOT NULL CHECK (locale IN ('th','en')),
  content_sha256 bytea NOT NULL CHECK (octet_length(content_sha256) = 32),
  published_at  timestamptz NOT NULL,
  UNIQUE (version_label, locale)
);
CREATE TRIGGER privacy_notice_version_immutable
  BEFORE UPDATE OR DELETE ON acs.privacy_notice_version
  FOR EACH ROW EXECUTE FUNCTION acs.reject_mutation();

-- ---------------------------------------------------------------------------
-- Lead (mutable; เป็นที่เดียวที่เก็บ PII ของผู้ติดต่อ เพื่อให้ erasure ทำได้โดยไม่แตะตาราง immutable)
-- ---------------------------------------------------------------------------
CREATE TABLE acs.lead (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  public_receipt_id  uuid NOT NULL UNIQUE DEFAULT gen_random_uuid(), -- คืนให้ผู้ส่งแบบไม่ระบุตัวตน
  status             text NOT NULL DEFAULT 'new'
                     CHECK (status IN ('new','contacted','qualified','disqualified','converted','erased')),
  assigned_user_id   uuid REFERENCES acs.app_user(id),
  full_name          text,
  email              text,
  phone              text,
  message            text CHECK (message IS NULL OR char_length(message) <= 4000),
  locale             text CHECK (locale IN ('th','en')),
  possible_duplicate_of uuid REFERENCES acs.lead(id),  -- soft dedupe หลัง idempotency หมดอายุ
  erased_at          timestamptz,
  row_version        integer NOT NULL DEFAULT 1,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  CHECK (status <> 'erased' OR (erased_at IS NOT NULL AND full_name IS NULL
                                AND email IS NULL AND phone IS NULL AND message IS NULL))
);
CREATE INDEX lead_assigned_status_idx ON acs.lead (assigned_user_id, status, created_at DESC);
CREATE INDEX lead_created_idx ON acs.lead (created_at DESC);
CREATE INDEX lead_email_lower_idx ON acs.lead (lower(email)) WHERE email IS NOT NULL;

-- ---------------------------------------------------------------------------
-- Acquisition (หนึ่งต่อหนึ่ง lead, write-once; แยกสิ่งที่ client อ้าง กับสิ่งที่ server ยืนยัน)
-- ---------------------------------------------------------------------------
CREATE TABLE acs.lead_acquisition (
  lead_id               uuid PRIMARY KEY REFERENCES acs.lead(id),
  channel               text NOT NULL,                  -- ค่าที่ server กำหนดจาก endpoint/route
  claimed_source        jsonb NOT NULL DEFAULT '{}',    -- utm/referrer ที่ client ส่ง: ไม่ใช่การยืนยัน campaign
  verified_campaign_ref text,                           -- ใส่เมื่อตรวจกับแหล่งที่เชื่อถือได้เท่านั้น
  verification_method   text,
  recorded_at           timestamptz NOT NULL DEFAULT now(),
  CHECK ((verified_campaign_ref IS NULL) = (verification_method IS NULL))
);

-- ---------------------------------------------------------------------------
-- Consent (append-only event log; สถานะปัจจุบัน = แถวล่าสุดต่อ lead+purpose)
-- ---------------------------------------------------------------------------
CREATE TABLE acs.consent_event (
  id                 bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  lead_id            uuid NOT NULL REFERENCES acs.lead(id),
  purpose            text NOT NULL,     -- รายการ purpose รอ DPO/เจ้าของยืนยัน
  legal_basis        text NOT NULL,     -- เช่น consent / contract / legitimate_interest — รอยืนยัน
  event_type         text NOT NULL CHECK (event_type IN ('granted','withdrawn','not_given')),
  notice_version_id  uuid NOT NULL REFERENCES acs.privacy_notice_version(id),
  source             text NOT NULL,     -- public_form / staff_on_behalf / subject_request
  recorded_by_user_id uuid REFERENCES acs.app_user(id),
  occurred_at        timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX consent_event_current_idx ON acs.consent_event (lead_id, purpose, occurred_at DESC, id DESC);
CREATE TRIGGER consent_event_append_only
  BEFORE UPDATE OR DELETE ON acs.consent_event
  FOR EACH ROW EXECUTE FUNCTION acs.reject_mutation();

CREATE VIEW acs.consent_current AS
SELECT DISTINCT ON (lead_id, purpose)
       lead_id, purpose, legal_basis, event_type, notice_version_id, occurred_at
FROM acs.consent_event
ORDER BY lead_id, purpose, occurred_at DESC, id DESC;

-- ---------------------------------------------------------------------------
-- Deal + Terms (Option A)
-- ---------------------------------------------------------------------------
CREATE TABLE acs.deal (
  id                        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lead_id                   uuid NOT NULL REFERENCES acs.lead(id),
  owner_user_id             uuid NOT NULL REFERENCES acs.app_user(id),
  status                    text NOT NULL DEFAULT 'draft'
                            CHECK (status IN ('draft','terms_proposed','bound','cancelled')),
  current_terms_version_id  uuid,
  bound_terms_version_id    uuid,
  bound_at                  timestamptz,
  bound_by_user_id          uuid REFERENCES acs.app_user(id),
  row_version               integer NOT NULL DEFAULT 1,
  created_at                timestamptz NOT NULL DEFAULT now(),
  updated_at                timestamptz NOT NULL DEFAULT now(),
  CHECK ((status = 'bound') = (bound_terms_version_id IS NOT NULL AND bound_at IS NOT NULL
                               AND bound_by_user_id IS NOT NULL))
);
CREATE INDEX deal_lead_idx ON acs.deal (lead_id);
CREATE INDEX deal_owner_status_idx ON acs.deal (owner_user_id, status);

-- immutable: ไม่มี updated_at และห้าม UPDATE/DELETE ทุกกรณี; แก้ไข = สร้าง version ใหม่
CREATE TABLE acs.deal_terms_version (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deal_id               uuid NOT NULL REFERENCES acs.deal(id),
  version_no            integer NOT NULL CHECK (version_no >= 1),
  supersedes_version_id uuid,
  currency              char(3) NOT NULL CHECK (currency ~ '^[A-Z]{3}$'),
  total_amount          numeric NOT NULL CHECK (total_amount >= 0), -- scale ตามสกุลเงินที่เจ้าของกำหนด
  terms_document        jsonb NOT NULL,                            -- ค่าเงินใน JSON เก็บเป็น string decimal
  content_sha256        bytea NOT NULL CHECK (octet_length(content_sha256) = 32),
  created_by_user_id    uuid NOT NULL REFERENCES acs.app_user(id),
  created_at            timestamptz NOT NULL DEFAULT now(),
  UNIQUE (deal_id, version_no),
  UNIQUE (deal_id, id),
  FOREIGN KEY (deal_id, supersedes_version_id) REFERENCES acs.deal_terms_version (deal_id, id)
);
CREATE TRIGGER deal_terms_version_immutable
  BEFORE UPDATE OR DELETE ON acs.deal_terms_version
  FOR EACH ROW EXECUTE FUNCTION acs.reject_mutation();

-- version ที่ deal ชี้ต้องเป็นของ deal เดียวกัน (composite FK, deferrable เพราะอ้างอิงวน)
ALTER TABLE acs.deal
  ADD CONSTRAINT deal_current_terms_fk FOREIGN KEY (id, current_terms_version_id)
      REFERENCES acs.deal_terms_version (deal_id, id) DEFERRABLE INITIALLY DEFERRED,
  ADD CONSTRAINT deal_bound_terms_fk FOREIGN KEY (id, bound_terms_version_id)
      REFERENCES acs.deal_terms_version (deal_id, id) DEFERRABLE INITIALLY DEFERRED;

-- เมื่อ bound แล้ว ห้ามเปลี่ยน version ที่ผูกไว้หรือย้อนสถานะ (การแก้ข้อตกลงหลัง binding รอนโยบายเจ้าของ)
CREATE OR REPLACE FUNCTION acs.guard_bound_deal() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.status = 'bound' AND (
       NEW.bound_terms_version_id IS DISTINCT FROM OLD.bound_terms_version_id
    OR NEW.bound_at IS DISTINCT FROM OLD.bound_at
    OR NEW.status NOT IN ('bound')) THEN
    RAISE EXCEPTION 'deal % is bound; binding is immutable', OLD.id
      USING ERRCODE = 'restrict_violation';
  END IF;
  NEW.row_version := OLD.row_version + 1;
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;
CREATE TRIGGER deal_guard BEFORE UPDATE ON acs.deal
  FOR EACH ROW EXECUTE FUNCTION acs.guard_bound_deal();
CREATE TRIGGER deal_no_delete BEFORE DELETE ON acs.deal
  FOR EACH ROW EXECUTE FUNCTION acs.reject_mutation();

-- ---------------------------------------------------------------------------
-- Audit (append-only; ห้ามเก็บ PII ใน details — อ้างด้วย id เท่านั้น)
-- ---------------------------------------------------------------------------
CREATE TABLE acs.audit_event (
  id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  occurred_at       timestamptz NOT NULL DEFAULT now(),
  actor_type        text NOT NULL CHECK (actor_type IN ('user','system','anonymous','worker')),
  actor_user_id     uuid REFERENCES acs.app_user(id),
  action            text NOT NULL,
  entity_type       text NOT NULL,
  entity_id         uuid NOT NULL,
  terms_version_id  uuid REFERENCES acs.deal_terms_version(id),
  request_id        text,
  details           jsonb NOT NULL DEFAULT '{}',
  CHECK ((actor_type = 'user') = (actor_user_id IS NOT NULL))
);
CREATE INDEX audit_entity_idx ON acs.audit_event (entity_type, entity_id, occurred_at);
CREATE INDEX audit_actor_idx ON acs.audit_event (actor_user_id, occurred_at) WHERE actor_user_id IS NOT NULL;
CREATE TRIGGER audit_event_append_only
  BEFORE UPDATE OR DELETE ON acs.audit_event
  FOR EACH ROW EXECUTE FUNCTION acs.reject_mutation();
CREATE TRIGGER audit_event_no_truncate
  BEFORE TRUNCATE ON acs.audit_event
  FOR EACH STATEMENT EXECUTE FUNCTION acs.reject_mutation();

-- ---------------------------------------------------------------------------
-- Idempotency (เก็บ hash เท่านั้น ไม่เก็บ payload; TTL ด้วย expires_at)
-- ---------------------------------------------------------------------------
CREATE TABLE acs.idempotency_record (
  endpoint        text NOT NULL,                 -- เช่น 'POST /public/leads'
  scope_kind      text NOT NULL CHECK (scope_kind IN ('anonymous_session','user')),
  scope_id        text NOT NULL,                 -- HMAC(nonce ของ signed form token) หรือ user id; ไม่เก็บ session id ดิบ
  idem_key        text NOT NULL CHECK (char_length(idem_key) BETWEEN 16 AND 128),
  request_sha256  bytea NOT NULL CHECK (octet_length(request_sha256) = 32),
  resource_type   text NOT NULL,
  resource_id     uuid NOT NULL,                 -- ใช้ภายใน ห้ามคืนให้ anonymous
  response_status smallint NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now(),
  expires_at      timestamptz NOT NULL,
  PRIMARY KEY (endpoint, scope_kind, scope_id, idem_key),
  CHECK (expires_at > created_at)
);
CREATE INDEX idempotency_expiry_idx ON acs.idempotency_record (expires_at);

-- ---------------------------------------------------------------------------
-- Outbox (Postgres เป็นเจ้าของสถานะงานแห่งเดียว)
-- ---------------------------------------------------------------------------
CREATE TABLE acs.outbox_event (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_key          text NOT NULL UNIQUE,      -- stable key ส่งให้ provider/n8n เป็น idempotency key
  destination        text NOT NULL,             -- crm / notify / lilith (conditional) / ...
  event_type         text NOT NULL,
  payload_version    smallint NOT NULL CHECK (payload_version >= 1),
  payload            jsonb NOT NULL,            -- เฉพาะ field ใน whitelist ต่อ destination
  subject_lead_id    uuid REFERENCES acs.lead(id),
  consent_purpose    text,                      -- purpose ที่ต้องตรวจก่อนส่ง (ถ้ามี)
  provider_idempotent boolean NOT NULL,         -- provider รองรับ idempotency key หรือไม่
  status             text NOT NULL DEFAULT 'pending'
                     CHECK (status IN ('pending','processing','succeeded','uncertain','dead','cancelled')),
  attempt_count      integer NOT NULL DEFAULT 0 CHECK (attempt_count >= 0),
  max_attempts       integer NOT NULL DEFAULT 8 CHECK (max_attempts >= 1),
  next_attempt_at    timestamptz NOT NULL DEFAULT now(),
  lease_token        uuid,
  lease_expires_at   timestamptz,
  attempt_started_at timestamptz,
  last_error         text,
  provider_ref       text,
  cancelled_reason   text,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  CHECK ((status = 'processing') = (lease_token IS NOT NULL AND lease_expires_at IS NOT NULL)),
  CHECK (status <> 'cancelled' OR cancelled_reason IS NOT NULL)
);
CREATE INDEX outbox_ready_idx ON acs.outbox_event (next_attempt_at) WHERE status = 'pending';
CREATE INDEX outbox_lease_idx ON acs.outbox_event (lease_expires_at) WHERE status = 'processing';
CREATE INDEX outbox_subject_idx ON acs.outbox_event (subject_lead_id) WHERE subject_lead_id IS NOT NULL;
CREATE INDEX outbox_attention_idx ON acs.outbox_event (status, updated_at) WHERE status IN ('uncertain','dead');

-- ---------------------------------------------------------------------------
-- Privacy requests + erasure ledger (ledger เก็บเฉพาะ id เพื่อนำ erasure ไปใช้ซ้ำหลัง restore)
-- ---------------------------------------------------------------------------
CREATE TABLE acs.privacy_request (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lead_id          uuid REFERENCES acs.lead(id),
  request_type     text NOT NULL CHECK (request_type IN
                     ('access','export','correction','erasure','withdraw_consent','objection','restriction')),
  status           text NOT NULL DEFAULT 'received'
                   CHECK (status IN ('received','identity_verification','in_progress','completed','rejected')),
  received_at      timestamptz NOT NULL DEFAULT now(),
  due_at           timestamptz,                 -- กำหนดตามที่ DPO/กฎหมายยืนยัน
  completed_at     timestamptz,
  handled_by_user_id uuid REFERENCES acs.app_user(id),
  outcome_note     text
);
CREATE INDEX privacy_request_open_idx ON acs.privacy_request (status, due_at)
  WHERE status NOT IN ('completed','rejected');

CREATE TABLE acs.erasure_ledger (
  lead_id            uuid PRIMARY KEY,           -- ไม่มี FK เพื่อให้ใช้ได้กับ backup ที่ restore
  privacy_request_id uuid NOT NULL,
  erased_at          timestamptz NOT NULL DEFAULT now()
);
CREATE TRIGGER erasure_ledger_append_only
  BEFORE UPDATE OR DELETE ON acs.erasure_ledger
  FOR EACH ROW EXECUTE FUNCTION acs.reject_mutation();

COMMIT;

-- ---------------------------------------------------------------------------
-- Grants (ข้อเสนอ): role ของแอปต้องไม่เป็นเจ้าของตาราง เพื่อไม่ให้ปิด trigger ได้
--   REVOKE UPDATE, DELETE, TRUNCATE ON acs.audit_event, acs.deal_terms_version,
--          acs.consent_event, acs.privacy_notice_version, acs.erasure_ledger FROM acs_app;
-- Trigger เป็นชั้นที่สอง; สิทธิ์ (GRANT) เป็นชั้นแรก ทั้งคู่ไม่กันผู้ดูแลระบบระดับ superuser
-- ---------------------------------------------------------------------------
