#!/usr/bin/env bash
# =============================================================
# Phase 2a: Install Pigsty on the cluster
# Idempotent — safe to re-run.
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V2_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${V2_DIR}/.env"
TEMPLATES_DIR="${V2_DIR}/config"
COMMON_SH="${SCRIPT_DIR}/common.sh"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Load env
set -a
# shellcheck disable=SC1090
source "${ENV_FILE}"
set +a
# shellcheck disable=SC1090
source "${COMMON_SH}"

SSH_USER="${SSH_USER:-root}"

step() { echo -e "\n${GREEN}▶ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }

# -----------------------------------------------------------
# 1. Check if Pigsty is already installed
# -----------------------------------------------------------
step "Checking if Pigsty is already installed on ${META_IP}..."

PIGSTY_INSTALLED="$(ssh_to_meta "test -f /root/pigsty/pigsty.yml && echo yes || echo no")"

if [[ "${PIGSTY_INSTALLED}" == "yes" ]]; then
  warn "Pigsty already installed at /root/pigsty. Skipping bootstrap."
  PIGSTY_DIR="/root/pigsty"
else
  # -----------------------------------------------------------
  # 2. Bootstrap Pigsty
  # -----------------------------------------------------------
  step "Downloading Pigsty ${PIGSTY_VERSION}..."
  ssh_to_meta "curl -fsSL https://repo.pigsty.io/get | bash -s -- ${PIGSTY_VERSION}"
  PIGSTY_DIR="/root/pigsty"
fi

# -----------------------------------------------------------
# 3. Generate pigsty.yml from template
# -----------------------------------------------------------
step "Generating pigsty.yml from template..."

if [[ ! -f "${TEMPLATES_DIR}/pigsty.yml.tpl" ]]; then
  echo -e "${RED}Template not found: ${TEMPLATES_DIR}/pigsty.yml.tpl${NC}"
  exit 1
fi

# We use envsubst for simple variable substitution
export APP_FQDN="${APP_SUBDOMAIN:-app}.${DOMAIN}"
export API_FQDN="${API_SUBDOMAIN:-api}.${DOMAIN}"
export STUDIO_FQDN="${STUDIO_SUBDOMAIN:-studio}.${DOMAIN}"
export POS_FQDN="${POS_SUBDOMAIN:-pos}.${DOMAIN}"
export AI_FQDN="${AI_SUBDOMAIN:-ai}.${DOMAIN}"
export PORTAL_FQDN="${PORTAL_SUBDOMAIN:-home}.${DOMAIN}"
export REGISTRY_FQDN="${REGISTRY_SUBDOMAIN:-registry}.${DOMAIN}"
export REGISTRY_UI_FQDN="${REGISTRY_UI_SUBDOMAIN:-registry-ui}.${DOMAIN}"

envsubst < "${TEMPLATES_DIR}/pigsty.yml.tpl" > /tmp/pigsty-v2-generated.yml

# Upload to default and HA inventory names (Pigsty may point ansible.cfg to either)
scp_to_meta /tmp/pigsty-v2-generated.yml "${PIGSTY_DIR}/pigsty.yml"
scp_to_meta /tmp/pigsty-v2-generated.yml "${PIGSTY_DIR}/pigsty-ha.yml"
echo "Uploaded inventory to $(meta_target):${PIGSTY_DIR}/pigsty.yml and pigsty-ha.yml"

# -----------------------------------------------------------
# 4. Configure Pigsty
# -----------------------------------------------------------
step "Running Pigsty configure..."
ssh_to_meta "cd ${PIGSTY_DIR} && ./configure -c supabase -i ${META_PRIVATE_IP} <<< 'y' || true"

# Overwrite with our generated config (configure may reset it)
scp_to_meta /tmp/pigsty-v2-generated.yml "${PIGSTY_DIR}/pigsty.yml"
scp_to_meta /tmp/pigsty-v2-generated.yml "${PIGSTY_DIR}/pigsty-ha.yml"

# -----------------------------------------------------------
# 5. Run deploy.yml (Pigsty + PGSQL + ETCD + MinIO)
# -----------------------------------------------------------
step "Running Pigsty deploy.yml (this takes ~15-20 min on first run)..."
ssh_to_meta "cd ${PIGSTY_DIR} && ./deploy.yml"

# -----------------------------------------------------------
# 6. Verify PostgreSQL is running
# -----------------------------------------------------------
step "Verifying PostgreSQL..."
PG_VERSION_REMOTE="$(ssh_to_meta "sudo -u postgres psql -t -c 'SELECT version();'" 2>/dev/null | head -1 | xargs)"

if [[ -n "${PG_VERSION_REMOTE}" ]]; then
  echo -e "${GREEN}PostgreSQL running: ${PG_VERSION_REMOTE}${NC}"
else
  echo -e "${RED}PostgreSQL verification failed!${NC}"
  exit 1
fi

# -----------------------------------------------------------
# 7. Verify Patroni cluster
# -----------------------------------------------------------
step "Verifying Patroni cluster..."
ssh_to_meta "patronictl -c /etc/patroni/patroni.yml list" 2>/dev/null || warn "Patroni check skipped"

echo ""
echo -e "${GREEN}Phase 2a complete: Pigsty installed and PostgreSQL running.${NC}"
