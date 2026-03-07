#!/usr/bin/env bash
# =============================================================
# Incremental SQL migrations for app schema (safe production flow)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V2_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${V2_DIR}/.env"
COMMON_SH="${SCRIPT_DIR}/common.sh"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

DEFAULT_TRACKING_TABLE="public._app_schema_migrations"

step() { echo -e "\n${GREEN}▶ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }
err() { echo -e "${RED}✖ $1${NC}" >&2; }

usage() {
  cat <<'USAGE'
Usage:
  ./v2/bin/pigsty-v2 migrations status [--source /abs/path/to/migrations] [--db postgres]
  ./v2/bin/pigsty-v2 migrations apply [--source /abs/path/to/migrations] [--db postgres]
  ./v2/bin/pigsty-v2 migrations baseline [--source /abs/path/to/migrations] [--db postgres]

Notes:
  - `apply` executes only pending *.sql files in lexical order.
  - `baseline` marks all pending files as applied without executing SQL.
  - Tracking table: public._app_schema_migrations
USAGE
}

load_env() {
  if [[ ! -f "${ENV_FILE}" ]]; then
    warn "Env file not found (${ENV_FILE}). Using process environment variables."
  fi
  # shellcheck disable=SC1090
  source "${COMMON_SH}"
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
    err "Missing required env var: ${name}"
    exit 1
  fi
}

ssh_target() {
  meta_target
}

resolve_source() {
  local source_override="${1:-}"
  local src=""

  if [[ -n "${source_override}" ]]; then
    src="${source_override}"
  elif [[ -n "${SUPABASE_MIGRATIONS_SOURCE:-}" ]]; then
    src="${SUPABASE_MIGRATIONS_SOURCE}"
  else
    err "No source provided. Use --source or set SUPABASE_MIGRATIONS_SOURCE"
    exit 1
  fi

  if [[ ! -d "${src}" ]]; then
    err "Migrations source directory not found: ${src}"
    exit 1
  fi

  echo "${src}"
}

leader_ip() {
  local meta="$1"
  ssh "${V2_SSH_ARGS[@]}" "${meta}" "patronictl -c /etc/patroni/patroni.yml list -f json | python3 -c 'import sys,json; d=json.load(sys.stdin); print(next(x[\"Host\"] for x in d if x[\"Role\"]==\"Leader\"))'" < /dev/null
}

sql_escape_literal() {
  # shellcheck disable=SC2001
  sed "s/'/''/g"
}

checksum_file() {
  local file="$1"
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "${file}" | awk '{print $1}'
  elif command -v sha256sum >/dev/null 2>&1; then
    sha256sum "${file}" | awk '{print $1}'
  else
    echo "no-checksum"
  fi
}

ensure_tracking_table() {
  local meta="$1"
  local leader="$2"
  local db="$3"
  local table="$4"

  local schema="${table%%.*}"
  local name="${table##*.}"

  local sql="
CREATE SCHEMA IF NOT EXISTS ${schema};
CREATE TABLE IF NOT EXISTS ${schema}.${name} (
  filename text PRIMARY KEY,
  checksum text,
  mode text NOT NULL DEFAULT 'apply',
  applied_at timestamptz NOT NULL DEFAULT now()
);"
  ssh "${V2_SSH_ARGS[@]}" "${meta}" "ssh ${leader} \"sudo -u postgres psql -d ${db} -v ON_ERROR_STOP=1 -c \\\"${sql}\\\"\"" < /dev/null >/dev/null
}

fetch_applied() {
  local meta="$1"
  local leader="$2"
  local db="$3"
  local table="$4"
  ssh "${V2_SSH_ARGS[@]}" "${meta}" "ssh ${leader} \"sudo -u postgres psql -d ${db} -tAc \\\"select filename from ${table} order by 1;\\\"\"" < /dev/null 2>/dev/null | sed '/^\s*$/d'
}

insert_tracking_row() {
  local meta="$1"
  local leader="$2"
  local db="$3"
  local table="$4"
  local filename="$5"
  local checksum="$6"
  local mode="$7"

  local fn_esc
  local ch_esc
  local mode_esc
  fn_esc="$(printf '%s' "${filename}" | sql_escape_literal)"
  ch_esc="$(printf '%s' "${checksum}" | sql_escape_literal)"
  mode_esc="$(printf '%s' "${mode}" | sql_escape_literal)"

  local sql="insert into ${table}(filename, checksum, mode) values ('${fn_esc}', '${ch_esc}', '${mode_esc}') on conflict (filename) do nothing;"
  ssh "${V2_SSH_ARGS[@]}" "${meta}" "ssh ${leader} \"sudo -u postgres psql -d ${db} -v ON_ERROR_STOP=1 -c \\\"${sql}\\\"\"" < /dev/null >/dev/null
}

collect_migrations() {
  local src="$1"
  find "${src}" -maxdepth 1 -type f -name '*.sql' | sort
}

cmd_status() {
  local src="$1"
  local db="$2"
  local table="$3"
  local meta="$4"
  local leader="$5"

  ensure_tracking_table "${meta}" "${leader}" "${db}" "${table}"

  local applied_tmp pending_tmp
  applied_tmp="$(mktemp)"
  pending_tmp="$(mktemp)"
  fetch_applied "${meta}" "${leader}" "${db}" "${table}" > "${applied_tmp}"

  local total=0
  local applied=0
  while IFS= read -r file; do
    [[ -f "${file}" ]] || continue
    total=$((total + 1))
    local base
    base="$(basename "${file}")"
    if grep -Fxq "${base}" "${applied_tmp}"; then
      applied=$((applied + 1))
    else
      echo "${base}" >> "${pending_tmp}"
    fi
  done < <(collect_migrations "${src}")

  local pending
  pending="$(wc -l < "${pending_tmp}" | tr -d ' ')"

  echo "Migrations source : ${src}"
  echo "Database          : ${db}"
  echo "Tracking table    : ${table}"
  echo "Leader            : ${leader}"
  echo "Total             : ${total}"
  echo "Applied           : ${applied}"
  echo "Pending           : ${pending}"

  if [[ "${pending}" -gt 0 ]]; then
    echo ""
    echo "Pending files:"
    sed -n '1,200p' "${pending_tmp}" | sed 's/^/  - /'
  fi

  rm -f "${applied_tmp}" "${pending_tmp}"
}

cmd_apply() {
  local src="$1"
  local db="$2"
  local table="$3"
  local meta="$4"
  local leader="$5"

  ensure_tracking_table "${meta}" "${leader}" "${db}" "${table}"

  local applied_tmp
  applied_tmp="$(mktemp)"
  fetch_applied "${meta}" "${leader}" "${db}" "${table}" > "${applied_tmp}"

  local applied_count=0
  local skipped_count=0

  while IFS= read -r file; do
    [[ -f "${file}" ]] || continue
    local base checksum
    base="$(basename "${file}")"
    checksum="$(checksum_file "${file}")"

    if grep -Fxq "${base}" "${applied_tmp}"; then
      echo "  - skip ${base} (already applied)"
      skipped_count=$((skipped_count + 1))
      continue
    fi

    step "Applying ${base}"
    cat "${file}" | ssh "${V2_SSH_ARGS[@]}" "${meta}" "ssh ${leader} \"sudo -u postgres psql -d ${db} -v ON_ERROR_STOP=1\"" > /tmp/migrate_apply.out 2>/tmp/migrate_apply.err || {
      err "Migration failed: ${base}"
      sed -n '1,120p' /tmp/migrate_apply.err
      rm -f "${applied_tmp}"
      exit 1
    }

    insert_tracking_row "${meta}" "${leader}" "${db}" "${table}" "${base}" "${checksum}" "apply"
    echo "  ✓ applied ${base}"
    applied_count=$((applied_count + 1))
  done < <(collect_migrations "${src}")

  rm -f "${applied_tmp}"

  step "Reloading PostgREST schema cache"
  ssh "${V2_SSH_ARGS[@]}" "${meta}" "ssh ${leader} \"sudo -u postgres psql -d ${db} -c \\\"NOTIFY pgrst, 'reload schema';\\\"\"" < /dev/null >/dev/null || warn "Could not send NOTIFY pgrst"
  ssh "${V2_SSH_ARGS[@]}" "${meta}" "docker restart supabase-rest >/dev/null" < /dev/null || warn "Could not restart supabase-rest container"

  echo ""
  echo "Applied migrations : ${applied_count}"
  echo "Skipped migrations : ${skipped_count}"
}

cmd_baseline() {
  local src="$1"
  local db="$2"
  local table="$3"
  local meta="$4"
  local leader="$5"

  ensure_tracking_table "${meta}" "${leader}" "${db}" "${table}"

  local applied_tmp
  applied_tmp="$(mktemp)"
  fetch_applied "${meta}" "${leader}" "${db}" "${table}" > "${applied_tmp}"

  local baseline_count=0
  local skipped_count=0

  while IFS= read -r file; do
    [[ -f "${file}" ]] || continue
    local base checksum
    base="$(basename "${file}")"
    checksum="$(checksum_file "${file}")"

    if grep -Fxq "${base}" "${applied_tmp}"; then
      skipped_count=$((skipped_count + 1))
      continue
    fi

    insert_tracking_row "${meta}" "${leader}" "${db}" "${table}" "${base}" "${checksum}" "baseline"
    echo "  - baseline ${base}"
    baseline_count=$((baseline_count + 1))
  done < <(collect_migrations "${src}")

  rm -f "${applied_tmp}"

  echo ""
  echo "Baselined migrations : ${baseline_count}"
  echo "Already tracked      : ${skipped_count}"
}

main() {
  load_env
  require_cmd ssh
  require_cmd python3

  local subcmd="${1:-}"
  shift || true

  if [[ -z "${subcmd}" || "${subcmd}" == "-h" || "${subcmd}" == "--help" ]]; then
    usage
    exit 0
  fi

  local source_override=""
  local db="postgres"
  local table="${DEFAULT_TRACKING_TABLE}"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --source)
        source_override="${2:-}"
        shift 2
        ;;
      --db)
        db="${2:-postgres}"
        shift 2
        ;;
      --table)
        table="${2:-${DEFAULT_TRACKING_TABLE}}"
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

  local src
  src="$(resolve_source "${source_override}")"

  local meta leader
  meta="$(ssh_target)"
  leader="$(leader_ip "${meta}")"

  step "Target cluster"
  echo "Meta   : ${meta}"
  echo "Leader : ${leader}"
  echo "DB     : ${db}"

  case "${subcmd}" in
    status)
      cmd_status "${src}" "${db}" "${table}" "${meta}" "${leader}"
      ;;
    apply)
      cmd_apply "${src}" "${db}" "${table}" "${meta}" "${leader}"
      ;;
    baseline)
      cmd_baseline "${src}" "${db}" "${table}" "${meta}" "${leader}"
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
