#!/usr/bin/env bash
# =============================================================
# Phase 1: Validate .env contract
# Ensures all REQUIRED variables are set before any deployment.
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V2_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${V2_DIR}/.env"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

errors=0

check_var() {
  local var_name="$1"
  local description="${2:-}"
  local value="${!var_name:-}"
  if [[ -z "${value}" ]]; then
    echo -e "  ${RED}[MISSING]${NC} ${var_name}  ${description:+— $description}"
    ((errors++))
  else
    echo -e "  ${GREEN}[OK]${NC}      ${var_name}"
  fi
}

check_var_optional() {
  local var_name="$1"
  local value="${!var_name:-}"
  if [[ -z "${value}" ]]; then
    echo -e "  ${YELLOW}[SKIP]${NC}    ${var_name} (optional)"
  else
    echo -e "  ${GREEN}[OK]${NC}      ${var_name}"
  fi
}

echo "=============================================="
echo "  Pigsty Supabase V2 — Config Validation"
echo "=============================================="
echo ""

# Load .env
if [[ ! -f "${ENV_FILE}" ]]; then
  echo -e "${RED}ERROR: ${ENV_FILE} not found.${NC}"
  echo "Run: cp v2/.env.example v2/.env  and fill required values."
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "${ENV_FILE}"
set +a

echo "Section: Cluster Identity"
check_var META_IP "public IP of pg-meta (from terraform output)"
check_var META_PRIVATE_IP "private IP of pg-meta"
check_var DB1_PRIVATE_IP "private IP of pg-data-1"
check_var DB2_PRIVATE_IP "private IP of pg-data-2"
echo ""

echo "Section: Pigsty"
check_var PIGSTY_VERSION "e.g. v4.2.0"
check_var PG_VERSION "e.g. 18"
check_var PG_CLUSTER_NAME "e.g. pg-meta"
check_var SUPABASE_DB_PASSWORD "shared supabase DB password"
echo ""

echo "Section: Supabase Secrets"
check_var JWT_SECRET "openssl rand -base64 48"
check_var ANON_KEY "JWT anon key"
check_var SERVICE_ROLE_KEY "JWT service_role key"
check_var PG_META_CRYPTO_KEY "32-64 random chars"
check_var SECRET_KEY_BASE "32-64 random chars"
check_var DASHBOARD_PASSWORD "Studio login password"
echo ""

echo "Section: Domain / SSL"
check_var DOMAIN "root domain e.g. bitsneura.com"
check_var CERTBOT_EMAIL "email for Let's Encrypt"
echo ""

echo "Section: S3 / Backblaze B2"
check_var S3_BUCKET "bucket for Supabase storage"
check_var S3_ACCESS_KEY "S3 access key"
check_var S3_SECRET_KEY "S3 secret key"
check_var PGBACKREST_S3_BUCKET "bucket for pgBackRest"
check_var PGBACKREST_CIPHER_PASS "backup encryption passphrase"
echo ""

echo "Section: SMTP (optional)"
check_var_optional SMTP_PASS
echo ""

echo "Section: Cloudflare (optional)"
check_var_optional CLOUDFLARE_API_TOKEN
check_var_optional CLOUDFLARE_ZONE_ID
echo ""

echo "Section: Provider Tokens (at least one required)"
has_provider=false
for var_name in VULTR_API_KEY HCLOUD_TOKEN DIGITALOCEAN_TOKEN LINODE_TOKEN AWS_ACCESS_KEY_ID; do
  if [[ -n "${!var_name:-}" ]]; then
    has_provider=true
    echo -e "  ${GREEN}[OK]${NC}      ${var_name}"
    break
  fi
done
if [[ "${has_provider}" == "false" ]]; then
  echo -e "  ${RED}[MISSING]${NC} No provider API token found"
  ((errors++))
fi
echo ""

# Derived values
APP_FQDN="${APP_SUBDOMAIN:-app}.${DOMAIN:-}"
API_FQDN="${API_SUBDOMAIN:-api}.${DOMAIN:-}"
STUDIO_FQDN="${STUDIO_SUBDOMAIN:-studio}.${DOMAIN:-}"

echo "----------------------------------------------"
echo "Derived URLs:"
echo "  App:    https://${APP_FQDN}"
echo "  API:    https://${API_FQDN}"
echo "  Studio: https://${STUDIO_FQDN}"
echo "----------------------------------------------"
echo ""

# SSH connectivity test
if [[ -n "${META_IP:-}" ]]; then
  echo -n "Testing SSH to ${SSH_USER:-root}@${META_IP}... "
  if ssh -o ConnectTimeout=5 -o BatchMode=yes "${SSH_USER:-root}@${META_IP}" "true" 2>/dev/null; then
    echo -e "${GREEN}OK${NC}"
  else
    echo -e "${YELLOW}FAILED (non-blocking)${NC}"
  fi
fi

echo ""
if [[ ${errors} -gt 0 ]]; then
  echo -e "${RED}Validation FAILED: ${errors} missing variable(s).${NC}"
  echo "Fill them in ${ENV_FILE} and re-run."
  exit 1
else
  echo -e "${GREEN}Validation PASSED. Ready to deploy.${NC}"
  exit 0
fi
