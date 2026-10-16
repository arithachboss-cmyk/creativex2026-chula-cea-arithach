#!/usr/bin/env bash
# รัน DDL ที่เสนอ + smoke test บน PostgreSQL ชั่วคราว (ไม่ใช่ฐานข้อมูลจริงของโครงการ)
# ใช้: PGBIN=/usr/lib/postgresql/16/bin ./run-smoke-test.sh <workdir>
# ต้องรันในฐานะผู้ใช้ที่ไม่ใช่ root (initdb ไม่ยอมให้ root)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="${1:?workdir required}"
PGBIN="${PGBIN:-/usr/lib/postgresql/16/bin}"
PORT="${PORT:-54329}"
rm -rf "$WORK/data"; mkdir -p "$WORK"
"$PGBIN/initdb" -D "$WORK/data" -U acs_test --auth=trust >/dev/null
"$PGBIN/pg_ctl" -D "$WORK/data" -o "-p $PORT -k $WORK -c listen_addresses=''" -l "$WORK/pg.log" -w start >/dev/null
trap '"$PGBIN/pg_ctl" -D "$WORK/data" -m fast stop >/dev/null' EXIT
PSQL=("$PGBIN/psql" -X -q -h "$WORK" -p "$PORT" -U acs_test -d postgres)

echo "### Load v2.1-proposed-schema.sql"
"${PSQL[@]}" -v ON_ERROR_STOP=1 -f "$HERE/v2.1-proposed-schema.sql"
echo "### Load option-b-terms-decision.sql"
"${PSQL[@]}" -v ON_ERROR_STOP=1 -f "$HERE/option-b-terms-decision.sql"

echo "### smoke-test.sql"
"${PSQL[@]}" -f "$HERE/smoke-test.sql" 2>&1

echo "### C01 concurrent duplicate idempotency key (2 sessions จริง)"
INS="INSERT INTO acs.idempotency_record (endpoint, scope_kind, scope_id, idem_key, request_sha256,
      resource_type, resource_id, response_status, expires_at)
     VALUES ('POST /public/leads','anonymous_session','TEST-conc','TEST-key-concurrent-01',
      sha256('p'),'lead',gen_random_uuid(),202, now()+interval '1 day')
     ON CONFLICT DO NOTHING RETURNING 'session-%s inserted' AS r;"
# session 1: insert แล้วค้าง transaction 3 วินาที
( printf "BEGIN;\n$(printf "$INS" 1)\nSELECT pg_sleep(3);\nCOMMIT;\n" | "${PSQL[@]}" -t ) > "$WORK/s1.out" 2>&1 &
sleep 1
# session 2: insert key เดียวกัน ต้องรอจน session 1 commit แล้วได้ 0 แถว
START=$(date +%s.%N)
printf "$(printf "$INS" 2)\n" | "${PSQL[@]}" -t > "$WORK/s2.out" 2>&1
END=$(date +%s.%N)
wait
echo "session1: $(tr -s '\n' ' ' < "$WORK/s1.out")"
echo "session2: '$(tr -s '\n' ' ' < "$WORK/s2.out")' (ว่าง = 0 แถว => ตรวจ hash แล้ว replay/409)"
printf "session2 waited: %.1fs (คาด ~2s เพราะรอ unique index ของ session 1)\n" "$(echo "$END - $START" | bc)"
"${PSQL[@]}" -t -c "SELECT 'rows for key: ' || count(*) FROM acs.idempotency_record WHERE idem_key='TEST-key-concurrent-01';"

echo "### C02 concurrent claim: 2 workers SKIP LOCKED ไม่ claim แถวเดียวกัน"
"${PSQL[@]}" -c "INSERT INTO acs.outbox_event (event_key, destination, event_type, payload_version, payload, provider_idempotent)
  SELECT 'conc:'||g, 'notify','TEST',1,'{}',true FROM generate_series(1,20) g;"
CLAIM="BEGIN; UPDATE acs.outbox_event SET status='processing', lease_token=gen_random_uuid(),
  lease_expires_at=now()+interval '30 seconds', attempt_count=attempt_count+1, attempt_started_at=now()
  WHERE id IN (SELECT id FROM acs.outbox_event WHERE status='pending' AND event_key LIKE 'conc:%%'
  ORDER BY event_key FOR UPDATE SKIP LOCKED LIMIT 15) RETURNING event_key; SELECT pg_sleep(2); COMMIT;"
( printf "$CLAIM" | "${PSQL[@]}" -t -A > "$WORK/w1.out" 2>&1 ) &
( sleep 0.5; printf "$CLAIM" | "${PSQL[@]}" -t -A > "$WORK/w2.out" 2>&1 ) &
wait
W1=$(grep -c '^conc:' "$WORK/w1.out" || true); W2=$(grep -c '^conc:' "$WORK/w2.out" || true)
DUP=$(cat "$WORK/w1.out" "$WORK/w2.out" | grep '^conc:' | sort | uniq -d | wc -l)
echo "worker1 claimed=$W1 worker2 claimed=$W2 overlap=$DUP (คาด 15/5/0)"
