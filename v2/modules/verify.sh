#!/usr/bin/env bash
# =============================================================
# Phase 4: Post-deploy verification and smoke tests
# Non-destructive — safe to run anytime.
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V2_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${V2_DIR}/.env"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

set -a
# shellcheck disable=SC1090
source "${ENV_FILE}"
set +a

SSH_USER="${SSH_USER:-root}"
META="${SSH_USER}@${META_IP}"

export APP_FQDN="${APP_SUBDOMAIN:-app}.${DOMAIN}"
export API_FQDN="${API_SUBDOMAIN:-api}.${DOMAIN}"
export STUDIO_FQDN="${STUDIO_SUBDOMAIN:-studio}.${DOMAIN}"
export POS_FQDN="${POS_SUBDOMAIN:-pos}.${DOMAIN}"
export AI_FQDN="${AI_SUBDOMAIN:-ai}.${DOMAIN}"
export DDL_FQDN="${DDL_SUBDOMAIN:-ddl}.${DOMAIN}"
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
META_RESULT=$(ssh -o ConnectTimeout=5 -o BatchMode=yes "${META}" "echo true" 2>/dev/null || echo "false")
check "SSH to meta (${META_IP})" "${META_RESULT}"

# Data nodes are only reachable via VPC from meta
for NODE_DESC in "db1:${DB1_PRIVATE_IP}" "db2:${DB2_PRIVATE_IP}"; do
  NODE_NAME="${NODE_DESC%%:*}"
  NODE_IP="${NODE_DESC##*:}"
  RESULT=$(ssh -o ConnectTimeout=5 "${META}" "ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no -o BatchMode=yes ${NODE_IP} 'echo true' 2>/dev/null" 2>/dev/null || echo "false")
  check "SSH to ${NODE_NAME} (${NODE_IP}) via meta" "${RESULT}"
done
echo ""

# -----------------------------------------------------------
# 2. PostgreSQL
# -----------------------------------------------------------
echo "2. PostgreSQL"
PG_RUNNING=$(ssh "${META}" "systemctl is-active patroni 2>/dev/null || systemctl is-active postgresql 2>/dev/null" || echo "inactive")
check "Patroni/PostgreSQL service" "${PG_RUNNING}" "active"

PG_VER=$(ssh "${META}" "sudo -u postgres psql -t -c 'SHOW server_version;'" 2>/dev/null | xargs)
echo -e "  ${GREEN}[INFO]${NC} PostgreSQL version: ${PG_VER}"

PG_RECOVERY=$(ssh "${META}" "sudo -u postgres psql -t -c 'SELECT pg_is_in_recovery();'" 2>/dev/null | xargs)
echo -e "  ${GREEN}[INFO]${NC} pg-meta is_in_recovery: ${PG_RECOVERY}"
echo ""

# -----------------------------------------------------------
# 3. Patroni Cluster
# -----------------------------------------------------------
echo "3. Patroni Cluster"
PATRONI_ACTIVE=$(ssh "${META}" "systemctl is-active patroni" 2>/dev/null || echo "inactive")
check "Patroni service" "${PATRONI_ACTIVE}" "active"

CLUSTER_SIZE=$(ssh "${META}" "patronictl -c /etc/patroni/patroni.yml list -f json 2>/dev/null | python3 -c 'import sys,json; print(len(json.load(sys.stdin)))'" 2>/dev/null || echo "0")
check "Patroni cluster size (expected 3)" "${CLUSTER_SIZE}" "3"

LEADER_COUNT=$(ssh "${META}" "patronictl -c /etc/patroni/patroni.yml list -f json 2>/dev/null | python3 -c 'import sys,json; print(sum(1 for m in json.load(sys.stdin) if m.get(\"Role\")==\"Leader\"))'" 2>/dev/null || echo "0")
check "Exactly 1 Leader in cluster" "${LEADER_COUNT}" "1"

STREAMING=$(ssh "${META}" "patronictl -c /etc/patroni/patroni.yml list -f json 2>/dev/null | python3 -c 'import sys,json; print(sum(1 for m in json.load(sys.stdin) if m.get(\"State\")==\"streaming\"))'" 2>/dev/null || echo "0")
check "Streaming replicas (expected 2)" "${STREAMING}" "2"
echo ""

# -----------------------------------------------------------
# 4. Supporting Services
# -----------------------------------------------------------
echo "4. Supporting Services"
for SVC in etcd haproxy pgbouncer; do
  STATUS=$(ssh "${META}" "systemctl is-active ${SVC}" 2>/dev/null || echo "inactive")
  check "${SVC}" "${STATUS}" "active"
done
echo ""

# -----------------------------------------------------------
# 5. Docker & Supabase Containers
# -----------------------------------------------------------
echo "5. Docker & Supabase Containers"
DOCKER_OK=$(ssh "${META}" "docker info >/dev/null 2>&1 && echo true || echo false")
check "Docker daemon" "${DOCKER_OK}"

CONTAINER_COUNT=$(ssh "${META}" "docker ps --filter 'name=supabase' --format '{{.Names}}' | wc -l" 2>/dev/null | xargs)
check "Supabase containers running (expected ≥10)" "$([ "${CONTAINER_COUNT}" -ge 10 ] && echo true || echo false)"

HEALTHY_COUNT=$(ssh "${META}" "docker ps --filter 'name=supabase' --format '{{.Status}}' | grep -c 'healthy'" 2>/dev/null || echo "0")
echo -e "  ${GREEN}[INFO]${NC} Healthy containers: ${HEALTHY_COUNT}/${CONTAINER_COUNT}"

UNHEALTHY=$(ssh "${META}" "docker ps --filter 'name=supabase' --filter 'health=unhealthy' --format '{{.Names}}'" 2>/dev/null)
if [[ -n "${UNHEALTHY}" ]]; then
  echo -e "  ${RED}[FAIL]${NC} Unhealthy containers: ${UNHEALTHY}"
  FAIL=$((FAIL + 1))
fi
echo ""

# -----------------------------------------------------------
# 6. HTTPS Endpoints
# -----------------------------------------------------------
echo "6. HTTPS Endpoints (from server)"
PORTAL_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${PORTAL_FQDN}" 2>/dev/null || echo "000")
check_warn "Portal ${PORTAL_FQDN} returns 200 or 307" "$([ "${PORTAL_STATUS}" = "200" ] || [ "${PORTAL_STATUS}" = "307" ] && echo true || echo false)"

API_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${API_FQDN}/rest/v1/ -H 'apikey: placeholder'" 2>/dev/null || echo "000")
check "API ${API_FQDN} returns 401 (auth required)" "${API_STATUS}" "401"

APP_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${APP_FQDN}" 2>/dev/null || echo "000")
check "App ${APP_FQDN} returns 200" "${APP_STATUS}" "200"

POS_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${POS_FQDN}" 2>/dev/null || echo "000")
check_warn "POS ${POS_FQDN} returns 200" "${POS_STATUS}" "200"

AI_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${AI_FQDN}/health" 2>/dev/null || echo "000")
check_warn "AI ${AI_FQDN}/health returns 200" "${AI_STATUS}" "200"

DDL_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${DDL_FQDN}" 2>/dev/null || echo "000")
check_warn "Bytebase ${DDL_FQDN} returns 200 or 307" "$([ "${DDL_STATUS}" = "200" ] || [ "${DDL_STATUS}" = "307" ] && echo true || echo false)"

LITELLM_STATUS=$(ssh "${META}" "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:4000/health" 2>/dev/null || echo "000")
check_warn "LiteLLM internal health returns 200" "${LITELLM_STATUS}" "200"

STUDIO_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${STUDIO_FQDN}" 2>/dev/null || echo "000")
check_warn "Studio ${STUDIO_FQDN} returns 200 or 307" "$([ "${STUDIO_STATUS}" = "200" ] || [ "${STUDIO_STATUS}" = "307" ] && echo true || echo false)"

REGISTRY_LOCAL_STATUS=$(ssh "${META}" "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:5000/v2/" 2>/dev/null || echo "000")
check_warn "Registry local 127.0.0.1:5000/v2/ returns 200 or 401" "$([ "${REGISTRY_LOCAL_STATUS}" = "200" ] || [ "${REGISTRY_LOCAL_STATUS}" = "401" ] && echo true || echo false)"

REGISTRY_UI_LOCAL_STATUS=$(ssh "${META}" "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:5080" 2>/dev/null || echo "000")
check_warn "Registry UI local 127.0.0.1:5080 returns 200 or 307" "$([ "${REGISTRY_UI_LOCAL_STATUS}" = "200" ] || [ "${REGISTRY_UI_LOCAL_STATUS}" = "307" ] && echo true || echo false)"
echo ""

# -----------------------------------------------------------
# 7. SSL Certificates
# -----------------------------------------------------------
echo "7. SSL Certificates"
for FQDN in "${APP_FQDN}" "${API_FQDN}" "${STUDIO_FQDN}"; do
  CERT_EXISTS=$(ssh "${META}" "test -d /etc/letsencrypt/live/${FQDN} && echo true || echo false" 2>/dev/null)
  check "Let's Encrypt cert for ${FQDN}" "${CERT_EXISTS}"
done
CERT_EXISTS=$(ssh "${META}" "test -d /etc/letsencrypt/live/${PORTAL_FQDN} && echo true || echo false" 2>/dev/null)
check_warn "Let's Encrypt cert for ${PORTAL_FQDN}" "${CERT_EXISTS}"
for FQDN in "${POS_FQDN}" "${AI_FQDN}" "${DDL_FQDN}"; do
  CERT_EXISTS=$(ssh "${META}" "test -d /etc/letsencrypt/live/${FQDN} && echo true || echo false" 2>/dev/null)
  check_warn "Let's Encrypt cert for ${FQDN}" "${CERT_EXISTS}"
done
echo ""

# -----------------------------------------------------------
# 8. Backups (pgBackRest)
# -----------------------------------------------------------
echo "8. Backups (pgBackRest)"
STANZA_OK=$(ssh "${META}" "sudo -u postgres pgbackrest --stanza=${PG_CLUSTER_NAME} info 2>&1 | grep -c 'status: ok'" 2>/dev/null || echo "0")
check "pgBackRest stanza status: ok" "$([ "${STANZA_OK}" -ge 1 ] && echo true || echo false)"

LAST_BACKUP=$(ssh "${META}" "sudo -u postgres pgbackrest --stanza=${PG_CLUSTER_NAME} info 2>&1 | grep 'full backup' | tail -1" 2>/dev/null)
echo -e "  ${GREEN}[INFO]${NC} Last full backup: ${LAST_BACKUP}"

BACKUP_REPO=$(ssh "${META}" "grep 'repo1-type' /etc/pgbackrest/pgbackrest.conf 2>/dev/null || echo 'unknown'")
echo -e "  ${GREEN}[INFO]${NC} Backup repo type: ${BACKUP_REPO}"
echo ""

# -----------------------------------------------------------
# 9. Security
# -----------------------------------------------------------
echo "9. Security"
UFW_ACTIVE=$(ssh "${META}" "ufw status | head -1 | grep -c 'active'" 2>/dev/null || echo "0")
check "UFW active" "$([ "${UFW_ACTIVE}" -ge 1 ] && echo true || echo false)"

F2B_ACTIVE=$(ssh "${META}" "systemctl is-active fail2ban" 2>/dev/null || echo "inactive")
check "Fail2ban active" "${F2B_ACTIVE}" "active"

ROOT_LOGIN=$(ssh "${META}" "grep '^PermitRootLogin' /etc/ssh/sshd_config" 2>/dev/null | awk '{print $2}')
check_warn "SSH PermitRootLogin = prohibit-password" "${ROOT_LOGIN}" "prohibit-password"
echo ""

# -----------------------------------------------------------
# 10. Monitoring
# -----------------------------------------------------------
echo "10. Monitoring"
for SVC in grafana-server node_exporter pg_exporter vmalert; do
  STATUS=$(ssh "${META}" "systemctl is-active ${SVC}" 2>/dev/null || echo "inactive")
  check_warn "${SVC}" "${STATUS}" "active"
done
echo ""

# -----------------------------------------------------------
# 11. Resources
# -----------------------------------------------------------
echo "11. Resources"
DISK_USAGE=$(ssh "${META}" "df -h / | tail -1 | awk '{print \$5}'" 2>/dev/null | tr -d '%')
echo -e "  ${GREEN}[INFO]${NC} Disk usage: ${DISK_USAGE}%"
check_warn "Disk usage < 80%" "$([ "${DISK_USAGE}" -lt 80 ] && echo true || echo false)"

MEM_TOTAL=$(ssh "${META}" "free -m | awk '/Mem/{print \$2}'" 2>/dev/null)
MEM_USED=$(ssh "${META}" "free -m | awk '/Mem/{print \$3}'" 2>/dev/null)
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
