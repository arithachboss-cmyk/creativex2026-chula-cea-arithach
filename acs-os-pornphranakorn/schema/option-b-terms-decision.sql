-- ACS OS Engineering v2.1 — CONDITIONAL (Option B)
-- สร้างเฉพาะเมื่อเจ้าของยืนยันว่ามีขั้นอนุมัติ terms แยกจากผู้ทำ deal (เช่น maker-checker)
-- ถ้าไม่มีขั้นอนุมัติ ให้ใช้ Option A ใน v2.1-proposed-schema.sql อย่างเดียว
-- บทบาทผู้อนุมัติ จำนวนผู้อนุมัติ และเงื่อนไขวงเงิน รอเจ้าของ (OD-04) ห้ามเดา

BEGIN;
SET search_path = acs, public;

-- append-only: การตัดสินใจแต่ละครั้งเป็นแถวใหม่ ไม่แก้สถานะบน deal_terms_version
CREATE TABLE acs.terms_decision (
  id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  deal_id           uuid NOT NULL,
  terms_version_id  uuid NOT NULL,
  decision          text NOT NULL CHECK (decision IN ('submitted','approved','rejected','withdrawn')),
  decided_by_user_id uuid NOT NULL REFERENCES acs.app_user(id),
  reason            text,
  decided_at        timestamptz NOT NULL DEFAULT now(),
  FOREIGN KEY (deal_id, terms_version_id) REFERENCES acs.deal_terms_version (deal_id, id)
);
-- อนุมัติได้ครั้งเดียวต่อ version (ถ้าเจ้าของกำหนดหลายผู้อนุมัติ ต้องออกแบบ constraint ใหม่)
CREATE UNIQUE INDEX terms_decision_one_approval
  ON acs.terms_decision (terms_version_id) WHERE decision = 'approved';
CREATE INDEX terms_decision_version_idx ON acs.terms_decision (terms_version_id, decided_at DESC, id DESC);
CREATE TRIGGER terms_decision_append_only
  BEFORE UPDATE OR DELETE ON acs.terms_decision
  FOR EACH ROW EXECUTE FUNCTION acs.reject_mutation();

-- maker-checker (ถ้าเจ้าของยืนยัน): ผู้อนุมัติต้องไม่ใช่ผู้สร้าง version
CREATE OR REPLACE FUNCTION acs.guard_terms_decision() RETURNS trigger
LANGUAGE plpgsql AS $$
DECLARE creator uuid;
BEGIN
  IF NEW.decision = 'approved' THEN
    SELECT created_by_user_id INTO creator FROM acs.deal_terms_version WHERE id = NEW.terms_version_id;
    IF creator = NEW.decided_by_user_id THEN
      RAISE EXCEPTION 'maker cannot approve own terms version' USING ERRCODE = 'check_violation';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;
CREATE TRIGGER terms_decision_guard BEFORE INSERT ON acs.terms_decision
  FOR EACH ROW EXECUTE FUNCTION acs.guard_terms_decision();

COMMIT;

-- Binding ภายใต้ Option B (ใน transaction เดียว):
--   UPDATE acs.deal SET status='bound', bound_terms_version_id=$v, bound_at=now(), bound_by_user_id=$u
--   WHERE id=$d AND row_version=$expected AND current_terms_version_id=$v AND status='terms_proposed'
--     AND EXISTS (SELECT 1 FROM acs.terms_decision td WHERE td.terms_version_id=$v AND td.decision='approved')
--     AND NOT EXISTS (SELECT 1 FROM acs.terms_decision td2 WHERE td2.terms_version_id=$v
--                     AND td2.decision IN ('rejected','withdrawn')
--                     AND td2.decided_at > (SELECT max(decided_at) FROM acs.terms_decision
--                                           WHERE terms_version_id=$v AND decision='approved'));
--   0 แถว => 409 stale/not-approved; แอปอ่านสาเหตุใหม่เพื่อแสดงผล
