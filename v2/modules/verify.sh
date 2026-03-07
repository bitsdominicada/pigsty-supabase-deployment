#!/usr/bin/env bash
# =============================================================
# Phase 4: Post-deploy verification and smoke tests
# Non-destructive — safe to run anytime.
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

set -a
# shellcheck disable=SC1090
source "${ENV_FILE}"
set +a
# shellcheck disable=SC1090
source "${COMMON_SH}"

SSH_USER="${SSH_USER:-root}"

export APP_FQDN="${APP_SUBDOMAIN:-app}.${DOMAIN}"
export API_FQDN="${API_SUBDOMAIN:-api}.${DOMAIN}"
export STUDIO_FQDN="${STUDIO_SUBDOMAIN:-studio}.${DOMAIN}"
export POS_FQDN="${POS_SUBDOMAIN:-pos}.${DOMAIN}"
export AI_FQDN="${AI_SUBDOMAIN:-ai}.${DOMAIN}"
export PORTAL_FQDN="${PORTAL_SUBDOMAIN:-home}.${DOMAIN}"

PASS=0
FAIL=0
WARN=0

check() {
  local label="$1"
  local result="$2"
  local expected="${3:-true}"

  if [[ "${result}" == "${expected}" ]]; then
    echo -e "  ${GREEN}[PASS]${NC} ${label}"
    PASS=$((PASS + 1))
  else
    echo -e "  ${RED}[FAIL]${NC} ${label} (got: ${result}, expected: ${expected})"
    FAIL=$((FAIL + 1))
  fi
}

check_warn() {
  local label="$1"
  local result="$2"
  local expected="${3:-true}"

  if [[ "${result}" == "${expected}" ]]; then
    echo -e "  ${GREEN}[PASS]${NC} ${label}"
    PASS=$((PASS + 1))
  else
    echo -e "  ${YELLOW}[WARN]${NC} ${label} (got: ${result})"
    WARN=$((WARN + 1))
  fi
}

echo "=============================================="
echo "  Pigsty Supabase V2 — Verification Report"
echo "=============================================="
echo ""

# -----------------------------------------------------------
# 1. SSH Connectivity
# -----------------------------------------------------------
echo "1. SSH Connectivity"
META_RESULT="$(ssh "${V2_SSH_ARGS[@]}" -o BatchMode=yes "$(meta_target)" "echo true" 2>/dev/null || echo "false")"
check "SSH to meta ($(meta_host))" "${META_RESULT}"

for NODE_DESC in "db1:${DB1_PRIVATE_IP}" "db2:${DB2_PRIVATE_IP}"; do
  NODE_NAME="${NODE_DESC%%:*}"
  NODE_IP="${NODE_DESC##*:}"
  NODE_PATH="via meta"
  if using_tailscale_transport; then
    NODE_TS_HOST="$(tailscale_private_host "${NODE_IP}" 2>/dev/null || true)"
    if [[ -n "${NODE_TS_HOST}" ]]; then
      NODE_PATH="via tailscale (${NODE_TS_HOST})"
    fi
  fi
  RESULT="$(bash_on_private_via_meta "${NODE_IP}" "echo true" 2>/dev/null || echo "false")"
  check "SSH to ${NODE_NAME} (${NODE_IP}) ${NODE_PATH}" "${RESULT}"
done
echo ""

# -----------------------------------------------------------
# 2. PostgreSQL
# -----------------------------------------------------------
echo "2. PostgreSQL"
PG_RUNNING="$(ssh_to_meta "systemctl is-active patroni 2>/dev/null || systemctl is-active postgresql 2>/dev/null" || echo "inactive")"
check "Patroni/PostgreSQL service" "${PG_RUNNING}" "active"

PG_VER="$(ssh_to_meta "sudo -u postgres psql -t -c 'SHOW server_version;'" 2>/dev/null | xargs)"
echo -e "  ${GREEN}[INFO]${NC} PostgreSQL version: ${PG_VER}"

PG_RECOVERY="$(ssh_to_meta "sudo -u postgres psql -t -c 'SELECT pg_is_in_recovery();'" 2>/dev/null | xargs)"
echo -e "  ${GREEN}[INFO]${NC} pg-meta is_in_recovery: ${PG_RECOVERY}"
echo ""

# -----------------------------------------------------------
# 3. Patroni Cluster
# -----------------------------------------------------------
echo "3. Patroni Cluster"
PATRONI_ACTIVE="$(ssh_to_meta "systemctl is-active patroni" 2>/dev/null || echo "inactive")"
check "Patroni service" "${PATRONI_ACTIVE}" "active"

CLUSTER_SIZE="$(ssh_to_meta "patronictl -c /etc/patroni/patroni.yml list -f json 2>/dev/null | python3 -c 'import sys,json; print(len(json.load(sys.stdin)))'" 2>/dev/null || echo "0")"
check "Patroni cluster size (expected 3)" "${CLUSTER_SIZE}" "3"

LEADER_COUNT="$(ssh_to_meta "patronictl -c /etc/patroni/patroni.yml list -f json 2>/dev/null | python3 -c 'import sys,json; print(sum(1 for m in json.load(sys.stdin) if m.get(\"Role\")==\"Leader\"))'" 2>/dev/null || echo "0")"
check "Exactly 1 Leader in cluster" "${LEADER_COUNT}" "1"

STREAMING="$(ssh_to_meta "patronictl -c /etc/patroni/patroni.yml list -f json 2>/dev/null | python3 -c 'import sys,json; print(sum(1 for m in json.load(sys.stdin) if m.get(\"State\")==\"streaming\"))'" 2>/dev/null || echo "0")"
check "Streaming replicas (expected 2)" "${STREAMING}" "2"
echo ""

# -----------------------------------------------------------
# 4. Supporting Services
# -----------------------------------------------------------
echo "4. Supporting Services"
for SVC in etcd haproxy pgbouncer; do
  STATUS="$(ssh_to_meta "systemctl is-active ${SVC}" 2>/dev/null || echo "inactive")"
  check "${SVC}" "${STATUS}" "active"
done
echo ""

# -----------------------------------------------------------
# 5. Docker & Supabase Containers
# -----------------------------------------------------------
echo "5. Docker & Supabase Containers"
DOCKER_OK="$(ssh_to_meta "docker info >/dev/null 2>&1 && echo true || echo false")"
check "Docker daemon" "${DOCKER_OK}"

CONTAINER_COUNT="$(ssh_to_meta "docker ps --filter 'name=supabase' --format '{{.Names}}' | wc -l" 2>/dev/null | xargs)"
REQUIRED_CONTAINERS="$(ssh_to_meta "docker ps -a --filter 'name=supabase' --format '{{.Names}} {{.State}} {{.Status}}' | awk '(\$2==\"running\") || (\$2==\"exited\" && \$3==\"Exited\" && \$4==\"(0)\") {count++} END {print count+0}'" 2>/dev/null | xargs)"
check "Supabase services running or cleanly exited (expected ≥10)" "$([ "${REQUIRED_CONTAINERS}" -ge 10 ] && echo true || echo false)"

HEALTHY_COUNT="$(ssh_to_meta "docker ps --filter 'name=supabase' --format '{{.Status}}' | grep -c 'healthy'" 2>/dev/null || echo "0")"
echo -e "  ${GREEN}[INFO]${NC} Healthy containers: ${HEALTHY_COUNT}/${CONTAINER_COUNT}"

UNHEALTHY="$(ssh_to_meta "docker ps --filter 'name=supabase' --filter 'health=unhealthy' --format '{{.Names}}'" 2>/dev/null)"
if [[ -n "${UNHEALTHY}" ]]; then
  echo -e "  ${RED}[FAIL]${NC} Unhealthy containers: ${UNHEALTHY}"
  FAIL=$((FAIL + 1))
fi
echo ""

# -----------------------------------------------------------
# 6. HTTPS Endpoints
# -----------------------------------------------------------
echo "6. HTTPS Endpoints (from server)"
PORTAL_STATUS="$(ssh_to_meta "curl -sk -o /dev/null -w '%{http_code}' https://${PORTAL_FQDN}" 2>/dev/null || echo "000")"
check_warn "Portal ${PORTAL_FQDN} returns 200 or 307" "$([ "${PORTAL_STATUS}" = "200" ] || [ "${PORTAL_STATUS}" = "307" ] && echo true || echo false)"
if [[ "${PORTAL_STATUS}" != "200" && "${PORTAL_STATUS}" != "307" ]]; then
  PORTAL_DNS="$(ssh_to_meta "getent hosts ${PORTAL_FQDN} >/dev/null 2>&1 && echo true || echo false" 2>/dev/null || echo "false")"
  PORTAL_LOCAL_STATUS="$(ssh_to_meta "curl -sk -H 'Host: ${PORTAL_FQDN}' -o /dev/null -w '%{http_code}' https://127.0.0.1" 2>/dev/null || echo "000")"
  echo -e "  ${YELLOW}[INFO]${NC} Portal DNS resolves on meta: ${PORTAL_DNS}"
  echo -e "  ${YELLOW}[INFO]${NC} Portal local vhost via 127.0.0.1: ${PORTAL_LOCAL_STATUS}"
fi

API_STATUS="$(ssh_to_meta "curl -sk -o /dev/null -w '%{http_code}' https://${API_FQDN}/rest/v1/ -H 'apikey: placeholder'" 2>/dev/null || echo "000")"
check "API ${API_FQDN} returns 401 (auth required)" "${API_STATUS}" "401"

APP_STATUS="$(ssh_to_meta "curl -sk -o /dev/null -w '%{http_code}' https://${APP_FQDN}" 2>/dev/null || echo "000")"
check "App ${APP_FQDN} returns 200" "${APP_STATUS}" "200"

POS_STATUS="$(ssh_to_meta "curl -sk -o /dev/null -w '%{http_code}' https://${POS_FQDN}" 2>/dev/null || echo "000")"
check_warn "POS ${POS_FQDN} returns 200" "${POS_STATUS}" "200"

AI_STATUS="$(ssh_to_meta "curl -sk -o /dev/null -w '%{http_code}' https://${AI_FQDN}/health" 2>/dev/null || echo "000")"
check_warn "AI ${AI_FQDN}/health returns 200" "${AI_STATUS}" "200"

LITELLM_STATUS="$(ssh_to_meta "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:4000/health" 2>/dev/null || echo "000")"
check_warn "LiteLLM internal health returns 200" "${LITELLM_STATUS}" "200"

STUDIO_STATUS="$(ssh_to_meta "curl -sk -o /dev/null -w '%{http_code}' https://${STUDIO_FQDN}" 2>/dev/null || echo "000")"
check_warn "Studio ${STUDIO_FQDN} returns 200 or 307" "$([ "${STUDIO_STATUS}" = "200" ] || [ "${STUDIO_STATUS}" = "307" ] && echo true || echo false)"

REGISTRY_LOCAL_STATUS="$(ssh_to_meta "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:5000/v2/" 2>/dev/null || echo "000")"
check_warn "Registry local 127.0.0.1:5000/v2/ returns 200 or 401" "$([ "${REGISTRY_LOCAL_STATUS}" = "200" ] || [ "${REGISTRY_LOCAL_STATUS}" = "401" ] && echo true || echo false)"

REGISTRY_UI_LOCAL_STATUS="$(ssh_to_meta "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:5080" 2>/dev/null || echo "000")"
check_warn "Registry UI local 127.0.0.1:5080 returns 200 or 307" "$([ "${REGISTRY_UI_LOCAL_STATUS}" = "200" ] || [ "${REGISTRY_UI_LOCAL_STATUS}" = "307" ] && echo true || echo false)"
echo ""

# -----------------------------------------------------------
# 7. SSL Certificates
# -----------------------------------------------------------
echo "7. SSL Certificates"
for FQDN in "${APP_FQDN}" "${API_FQDN}" "${STUDIO_FQDN}"; do
  CERT_EXISTS="$(ssh_to_meta "test -d /etc/letsencrypt/live/${FQDN} && echo true || echo false" 2>/dev/null)"
  check "Let's Encrypt cert for ${FQDN}" "${CERT_EXISTS}"
done
CERT_EXISTS="$(ssh_to_meta "test -d /etc/letsencrypt/live/${PORTAL_FQDN} && echo true || echo false" 2>/dev/null)"
check_warn "Let's Encrypt cert for ${PORTAL_FQDN}" "${CERT_EXISTS}"
for FQDN in "${POS_FQDN}" "${AI_FQDN}"; do
  CERT_EXISTS="$(ssh_to_meta "test -d /etc/letsencrypt/live/${FQDN} && echo true || echo false" 2>/dev/null)"
  check_warn "Let's Encrypt cert for ${FQDN}" "${CERT_EXISTS}"
done
echo ""

# -----------------------------------------------------------
# 8. Backups (pgBackRest)
# -----------------------------------------------------------
echo "8. Backups (pgBackRest)"
STANZA_OK="$(ssh_to_meta "sudo -u postgres pgbackrest --stanza=${PG_CLUSTER_NAME} info 2>&1 | grep -c 'status: ok'" 2>/dev/null || echo "0")"
check "pgBackRest stanza status: ok" "$([ "${STANZA_OK}" -ge 1 ] && echo true || echo false)"

LAST_BACKUP="$(ssh_to_meta "sudo -u postgres pgbackrest --stanza=${PG_CLUSTER_NAME} info 2>&1 | grep 'full backup' | tail -1" 2>/dev/null)"
echo -e "  ${GREEN}[INFO]${NC} Last full backup: ${LAST_BACKUP}"

BACKUP_REPO="$(ssh_to_meta "grep 'repo1-type' /etc/pgbackrest/pgbackrest.conf 2>/dev/null || echo 'unknown'")"
echo -e "  ${GREEN}[INFO]${NC} Backup repo type: ${BACKUP_REPO}"
echo ""

# -----------------------------------------------------------
# 9. Security
# -----------------------------------------------------------
echo "9. Security"
UFW_ACTIVE="$(ssh_to_meta "ufw status | head -1 | grep -c 'active'" 2>/dev/null || echo "0")"
check "UFW active" "$([ "${UFW_ACTIVE}" -ge 1 ] && echo true || echo false)"

F2B_ACTIVE="$(ssh_to_meta "systemctl is-active fail2ban" 2>/dev/null || echo "inactive")"
check "Fail2ban active" "${F2B_ACTIVE}" "active"

ROOT_LOGIN="$(ssh_to_meta "sshd -T 2>/dev/null | awk '/^permitrootlogin /{print \$2}'" 2>/dev/null)"
check_warn "SSH PermitRootLogin disables password logins" "$([[ "${ROOT_LOGIN}" =~ ^(prohibit-password|without-password)$ ]] && echo true || echo false)"

AUTH_METHODS="$(ssh_to_meta "sshd -T 2>/dev/null | awk '/^authenticationmethods /{print \$2}'" 2>/dev/null)"
check_warn "SSH AuthenticationMethods = publickey" "${AUTH_METHODS}" "publickey"
echo ""

# -----------------------------------------------------------
# 10. Monitoring
# -----------------------------------------------------------
echo "10. Monitoring"
for SVC in grafana-server node_exporter pg_exporter vmalert; do
  STATUS="$(ssh_to_meta "systemctl is-active ${SVC}" 2>/dev/null || echo "inactive")"
  check_warn "${SVC}" "${STATUS}" "active"
done
echo ""

# -----------------------------------------------------------
# 11. Resources
# -----------------------------------------------------------
echo "11. Resources"
DISK_USAGE="$(ssh_to_meta "df -h / | tail -1 | awk '{print \$5}'" 2>/dev/null | tr -d '%')"
echo -e "  ${GREEN}[INFO]${NC} Disk usage: ${DISK_USAGE}%"
check_warn "Disk usage < 80%" "$([ "${DISK_USAGE}" -lt 80 ] && echo true || echo false)"

MEM_TOTAL="$(ssh_to_meta "free -m | awk '/Mem/{print \$2}'" 2>/dev/null)"
MEM_USED="$(ssh_to_meta "free -m | awk '/Mem/{print \$3}'" 2>/dev/null)"
MEM_PCT=$((MEM_USED * 100 / MEM_TOTAL))
echo -e "  ${GREEN}[INFO]${NC} Memory: ${MEM_USED}MB / ${MEM_TOTAL}MB (${MEM_PCT}%)"
check_warn "Memory usage < 90%" "$([ "${MEM_PCT}" -lt 90 ] && echo true || echo false)"
echo ""

# -----------------------------------------------------------
# Summary
# -----------------------------------------------------------
echo "=============================================="
TOTAL=$((PASS + FAIL + WARN))
echo -e "  ${GREEN}PASS: ${PASS}${NC}  ${RED}FAIL: ${FAIL}${NC}  ${YELLOW}WARN: ${WARN}${NC}  Total: ${TOTAL}"
echo "=============================================="

if [[ ${FAIL} -gt 0 ]]; then
  echo -e "${RED}Verification completed with ${FAIL} failure(s).${NC}"
  exit 1
else
  echo -e "${GREEN}Verification completed successfully.${NC}"
  exit 0
fi
