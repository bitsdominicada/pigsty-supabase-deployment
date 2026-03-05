#!/usr/bin/env bash
# =============================================================
# Edge Functions deploy + smoke test helpers
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V2_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${V2_DIR}/.env"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

REMOTE_BASE="/opt/supabase/volumes/functions"
EDGE_CONTAINER="supabase-edge-functions"

step() { echo -e "\n${GREEN}▶ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }
err() { echo -e "${RED}✖ $1${NC}" >&2; }

usage() {
  cat <<'USAGE'
Usage:
  ./v2/bin/pigsty-v2 functions deploy [--source /abs/path/to/supabase/functions]
  ./v2/bin/pigsty-v2 functions smoke [--api-base https://api.example.com] [--mode safe|live]
  ./v2/bin/pigsty-v2 functions all [--source ...] [--api-base ...] [--mode ...]

Notes:
  - deploy syncs every folder in local supabase/functions to /opt/supabase/volumes/functions
  - smoke safe mode is non-destructive by default
USAGE
}

load_env() {
  if [[ -f "${ENV_FILE}" ]]; then
    set -a
    # shellcheck disable=SC1090
    source "${ENV_FILE}"
    set +a
  else
    warn "Env file not found (${ENV_FILE}). Falling back to process environment variables."
  fi
}

require_cmd() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    err "Required command not found: ${cmd}"
    exit 1
  fi
}

require_env_var() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    err "Missing required env var in v2/.env: ${name}"
    exit 1
  fi
}

resolve_source() {
  local source_override="${1:-}"
  local src=""
  if [[ -n "${source_override}" ]]; then
    src="${source_override}"
  elif [[ -n "${SUPABASE_FUNCTIONS_SOURCE:-}" ]]; then
    src="${SUPABASE_FUNCTIONS_SOURCE}"
  else
    err "No source path provided. Use --source or set SUPABASE_FUNCTIONS_SOURCE in v2/.env"
    exit 1
  fi

  if [[ ! -d "${src}" ]]; then
    err "Functions source directory not found: ${src}"
    exit 1
  fi

  if [[ ! -f "${src}/create-user/index.ts" ]]; then
    warn "Directory does not look like the expected bits_flare_platform functions path: ${src}"
  fi

  echo "${src}"
}

ssh_target() {
  require_env_var META_IP
  local user="${SSH_USER:-root}"
  echo "${user}@${META_IP}"
}

edge_deploy() {
  local source_override="${1:-}"
  local src
  src="$(resolve_source "${source_override}")"

  require_cmd ssh
  require_cmd rsync

  local meta
  meta="$(ssh_target)"

  step "Checking SSH connectivity to ${meta}"
  ssh -o BatchMode=yes -o ConnectTimeout=8 "${meta}" "echo ok" >/dev/null

  step "Ensuring edge functions directory exists on VPS"
  ssh "${meta}" "mkdir -p '${REMOTE_BASE}'"

  if ! ssh "${meta}" "test -d '${REMOTE_BASE}/main'"; then
    err "Remote '${REMOTE_BASE}/main' not found. Deploy Supabase first (./v2/bin/pigsty-v2 supabase)."
    exit 1
  fi

  step "Syncing local functions from ${src}"
  local count=0
  while IFS= read -r fn_dir; do
    local fn_name
    fn_name="$(basename "${fn_dir}")"
    [[ -d "${fn_dir}" ]] || continue
    count=$((count + 1))
    echo "  - ${fn_name}"
    ssh "${meta}" "mkdir -p '${REMOTE_BASE}/${fn_name}'" < /dev/null
    rsync -az --delete \
      --exclude '.DS_Store' \
      --exclude 'node_modules' \
      --exclude '.git' \
      "${fn_dir}/" "${meta}:${REMOTE_BASE}/${fn_name}/" < /dev/null
  done < <(find "${src}" -mindepth 1 -maxdepth 1 -type d | sort)

  if [[ "${count}" -eq 0 ]]; then
    err "No function directories found in ${src}"
    exit 1
  fi

  step "Cleaning default hello sample function (if present)"
  ssh "${meta}" "rm -rf '${REMOTE_BASE}/hello'"

  step "Restarting ${EDGE_CONTAINER}"
  ssh "${meta}" "docker restart '${EDGE_CONTAINER}' >/dev/null"

  step "Verifying remote function directories"
  ssh "${meta}" "ls -1 '${REMOTE_BASE}' | sort"

  echo -e "\n${GREEN}Deploy complete: ${count} functions synced.${NC}"
}

SMOKE_PASS=0
SMOKE_FAIL=0

smoke_case() {
  local api_base="$1"
  local name="$2"
  local method="$3"
  local path="$4"
  local auth="$5"
  local extra_header_key="$6"
  local extra_header_value="$7"
  local body="$8"
  local expected_regex="$9"
  local note="${10}"

  local tmp_body
  tmp_body="$(mktemp)"
  local url="${api_base}/functions/v1/${path}"

  local -a cmd
  cmd=(curl -sk -o "${tmp_body}" -w '%{http_code}' -X "${method}" "${url}" -H 'Content-Type: application/json')

  if [[ "${auth}" == "service" ]]; then
    cmd+=(-H "Authorization: Bearer ${SERVICE_ROLE_KEY}" -H "apikey: ${SERVICE_ROLE_KEY}")
  elif [[ "${auth}" == "anon" ]]; then
    cmd+=(-H "Authorization: Bearer ${ANON_KEY}" -H "apikey: ${ANON_KEY}")
  fi

  if [[ -n "${extra_header_key}" ]]; then
    cmd+=(-H "${extra_header_key}: ${extra_header_value}")
  fi

  if [[ -n "${body}" ]]; then
    cmd+=(--data "${body}")
  fi

  local code
  code="$("${cmd[@]}" || echo "000")"

  if [[ "${code}" =~ ^(${expected_regex})$ ]]; then
    SMOKE_PASS=$((SMOKE_PASS + 1))
    printf "  [PASS] %-28s -> %s (%s)\n" "${name}" "${code}" "${note}"
  else
    SMOKE_FAIL=$((SMOKE_FAIL + 1))
    local preview
    preview="$(tr '\n' ' ' < "${tmp_body}" | cut -c1-180)"
    printf "  [FAIL] %-28s -> %s expected (%s) | body: %s\n" "${name}" "${code}" "${expected_regex}" "${preview}"
  fi

  rm -f "${tmp_body}"
}

edge_smoke() {
  local api_base_override="${1:-}"
  local mode="${2:-safe}"

  require_cmd curl
  require_env_var DOMAIN
  require_env_var API_SUBDOMAIN
  require_env_var ANON_KEY
  require_env_var SERVICE_ROLE_KEY

  local api_base="${api_base_override:-https://${API_SUBDOMAIN}.${DOMAIN}}"
  local meta
  meta="$(ssh_target)"

  step "Smoke tests against ${api_base} (mode=${mode})"

  smoke_case "${api_base}" "create-org-member" "POST" "create-org-member" "anon" "" "" '{"organization_id":"00000000-0000-0000-0000-000000000000","email":"qa@example.com","password":"Secret123!","full_name":"QA User","role_key":"staff"}' "400|401|403|500" "auth/permission gate"
  smoke_case "${api_base}" "create-user" "POST" "create-user" "anon" "" "" '{"email":"qa.user@example.com","password":"Secret123!","full_name":"QA User"}' "400|401|403|500" "platform-admin gate"
  smoke_case "${api_base}" "generate-recurring-documents" "POST" "generate-recurring-documents" "service" "" "" '{"target_date":"1900-01-01"}' "200|500" "dry date execution"
  smoke_case "${api_base}" "parse-p12" "POST" "parse-p12" "none" "" "" '{}' "400" "required fields validation"
  smoke_case "${api_base}" "portal-auth" "POST" "portal-auth?action=validate-token" "none" "" "" '{"token":"invalid-test-token"}' "401|400" "invalid portal token"
  smoke_case "${api_base}" "portal-create-payment" "POST" "portal-create-payment" "none" "" "" '{"document_id":"00000000-0000-0000-0000-000000000000","document_date":"2026-01-01","amount":100}' "401|400" "session gate"
  smoke_case "${api_base}" "portal-data" "POST" "portal-data?action=invoices" "none" "x-portal-session" "invalid-session" '{"page":1,"page_size":5}' "401|400" "invalid portal session"
  smoke_case "${api_base}" "portal-download-pdf" "GET" "portal-download-pdf?document_id=00000000-0000-0000-0000-000000000000" "none" "x-portal-session" "invalid-session" "" "401|404" "invalid session/doc"
  smoke_case "${api_base}" "portal-payment-callback" "GET" "portal-payment-callback?intent_id=test-intent-not-found" "none" "" "" "" "302|400" "callback redirect"

  if [[ "${mode}" == "live" ]]; then
    smoke_case "${api_base}" "process-emisor-receptor" "POST" "process-emisor-receptor" "service" "" "" '{}' "200|500" "queue processor"
    smoke_case "${api_base}" "process-ncf-recovery" "POST" "process-ncf-recovery" "service" "" "" '{}' "200|500" "queue processor"
    smoke_case "${api_base}" "process-post-recovery" "POST" "process-post-recovery" "service" "" "" '{}' "200|500" "queue processor"
    smoke_case "${api_base}" "sync-exchange-rates" "GET" "sync-exchange-rates" "service" "" "" "" "200|500" "rates sync"
  else
    smoke_case "${api_base}" "process-emisor-receptor" "OPTIONS" "process-emisor-receptor" "none" "" "" "" "200|204" "safe preflight"
    smoke_case "${api_base}" "process-ncf-recovery" "OPTIONS" "process-ncf-recovery" "none" "" "" "" "200|204" "safe preflight"
    smoke_case "${api_base}" "process-post-recovery" "OPTIONS" "process-post-recovery" "none" "" "" "" "200|204" "safe preflight"
    smoke_case "${api_base}" "sync-exchange-rates" "OPTIONS" "sync-exchange-rates" "none" "" "" "" "200|204" "safe preflight"
  fi

  smoke_case "${api_base}" "receive-ecf-webhook" "POST" "receive-ecf-webhook" "none" "" "" '{"type":"test"}' "400" "required fields validation"
  smoke_case "${api_base}" "send-appointment-notification" "POST" "send-appointment-notification" "service" "" "" '{"appointment_id":"00000000-0000-0000-0000-000000000000","notification_type":"reminder_24h"}' "404|400|500|200" "appointment flow"
  smoke_case "${api_base}" "send-document-email" "POST" "send-document-email" "none" "" "" '{"to":"invalid-email","subject":"Smoke","html":"<p>test</p>"}' "400" "email payload validation"
  smoke_case "${api_base}" "sign-ecf" "POST" "sign-ecf" "anon" "" "" '{"xml":"<ECF></ECF>","organizationId":"00000000-0000-0000-0000-000000000000","ecfNumber":"E310000000001"}' "401|403|404|400|500" "auth/document gate"
  smoke_case "${api_base}" "stripe-portal-webhook" "POST" "stripe-portal-webhook" "none" "stripe-signature" "smoke-signature" '{"type":"payment_intent.created","data":{"object":{"id":"pi_smoke","metadata":{}}}}' "200" "non-target event ack"
  smoke_case "${api_base}" "validate-ecf-xsd" "POST" "validate-ecf-xsd" "none" "" "" '{"xml":"<xml>invalid</xml>","ecfType":"31"}' "400|200|500" "xml validation"
  smoke_case "${api_base}" "verify-ecf-timbre" "POST" "verify-ecf-timbre" "none" "" "" '{"url":"https://example.com/not-dgii"}' "400" "url validation"

  step "Runtime check"
  ssh "${meta}" "docker ps --filter name=${EDGE_CONTAINER} --format '{{.Names}} {{.Status}}'"

  echo ""
  echo "Smoke summary: PASS=${SMOKE_PASS} FAIL=${SMOKE_FAIL}"
  if [[ "${SMOKE_FAIL}" -gt 0 ]]; then
    return 1
  fi
}

main() {
  load_env
  local subcmd="${1:-}"
  shift || true

  if [[ -z "${subcmd}" || "${subcmd}" == "-h" || "${subcmd}" == "--help" ]]; then
    usage
    exit 0
  fi

  local source_override=""
  local api_base_override=""
  local mode="safe"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --source)
        source_override="${2:-}"
        shift 2
        ;;
      --api-base)
        api_base_override="${2:-}"
        shift 2
        ;;
      --mode)
        mode="${2:-safe}"
        shift 2
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        err "Unknown argument: $1"
        usage
        exit 1
        ;;
    esac
  done

  case "${subcmd}" in
    deploy)
      edge_deploy "${source_override}"
      ;;
    smoke)
      edge_smoke "${api_base_override}" "${mode}"
      ;;
    all)
      edge_deploy "${source_override}"
      edge_smoke "${api_base_override}" "${mode}"
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
