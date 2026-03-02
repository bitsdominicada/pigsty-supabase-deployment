#!/usr/bin/env bash
# =============================================================
# Phase 2b: Deploy Supabase (Docker Compose)
# Idempotent — safe to re-run. Restarts containers if running.
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V2_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${V2_DIR}/.env"
TEMPLATES_DIR="${V2_DIR}/config"

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
PIGSTY_DIR="/root/pigsty"

step() { echo -e "\n${GREEN}▶ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }

# -----------------------------------------------------------
# 1. Install Docker if needed
# -----------------------------------------------------------
step "Ensuring Docker is installed..."
DOCKER_INSTALLED=$(ssh "${META}" "command -v docker >/dev/null 2>&1 && echo yes || echo no")

if [[ "${DOCKER_INSTALLED}" == "no" ]]; then
  step "Installing Docker via Pigsty docker.yml..."
  ssh "${META}" "cd ${PIGSTY_DIR} && ./docker.yml"
else
  echo "Docker already installed."
fi

# -----------------------------------------------------------
# 2. Generate Supabase .env from template
# -----------------------------------------------------------
step "Generating Supabase .env..."

export APP_FQDN="${APP_SUBDOMAIN:-app}.${DOMAIN}"
export API_FQDN="${API_SUBDOMAIN:-api}.${DOMAIN}"
export STUDIO_FQDN="${STUDIO_SUBDOMAIN:-studio}.${DOMAIN}"

if [[ -f "${TEMPLATES_DIR}/supabase.env.tpl" ]]; then
  envsubst < "${TEMPLATES_DIR}/supabase.env.tpl" > /tmp/supabase-v2.env
  scp /tmp/supabase-v2.env "${META}:/opt/supabase/.env"
  echo "Uploaded .env to /opt/supabase/.env"
else
  warn "No supabase.env.tpl found — using Pigsty app.yml defaults."
fi

# -----------------------------------------------------------
# 3. Deploy Supabase via Pigsty app.yml
# -----------------------------------------------------------
step "Running Pigsty app.yml (launches Supabase containers)..."
ssh "${META}" "cd ${PIGSTY_DIR} && ./app.yml"

# -----------------------------------------------------------
# 4. Wait for containers to become healthy
# -----------------------------------------------------------
step "Waiting for Supabase containers to become healthy..."

MAX_WAIT=120
ELAPSED=0
while [[ ${ELAPSED} -lt ${MAX_WAIT} ]]; do
  UNHEALTHY=$(ssh "${META}" "docker ps --filter 'name=supabase' --format '{{.Status}}' | grep -cv 'healthy'" 2>/dev/null || echo "99")
  if [[ "${UNHEALTHY}" == "0" ]]; then
    echo -e "${GREEN}All Supabase containers are healthy.${NC}"
    break
  fi
  echo "  Waiting... (${ELAPSED}s / ${MAX_WAIT}s, ${UNHEALTHY} not ready)"
  sleep 10
  ELAPSED=$((ELAPSED + 10))
done

if [[ ${ELAPSED} -ge ${MAX_WAIT} ]]; then
  warn "Some containers may not be healthy yet. Check manually:"
  ssh "${META}" "docker ps --filter 'name=supabase' --format 'table {{.Names}}\t{{.Status}}'"
fi

# -----------------------------------------------------------
# 5. Configure Nginx reverse proxy + SSL
# -----------------------------------------------------------
step "Setting up Nginx reverse proxy and SSL certificates..."

# Ensure certbot and acme challenge dir exist
ssh "${META}" "mkdir -p /www/acme/.well-known/acme-challenge"

# Request Let's Encrypt certificates for all domains
for FQDN in "${APP_FQDN}" "${API_FQDN}" "${STUDIO_FQDN}"; do
  step "Requesting SSL certificate for ${FQDN}..."
  ssh "${META}" "
    if [[ -d /etc/letsencrypt/live/${FQDN} ]]; then
      echo 'Certificate already exists for ${FQDN}'
    else
      certbot certonly --webroot -w /www/acme \
        -d ${FQDN} \
        --email ${CERTBOT_EMAIL} \
        --agree-tos --non-interactive \
        --deploy-hook 'nginx -s reload' || echo 'certbot failed for ${FQDN} — may need DNS propagation'
    fi
  "
done

# Copy certs to nginx cert dir
ssh "${META}" "
  for FQDN in ${APP_FQDN} ${API_FQDN} ${STUDIO_FQDN}; do
    if [[ -d /etc/letsencrypt/live/\${FQDN} ]]; then
      mkdir -p /etc/nginx/conf.d/cert
      cp /etc/letsencrypt/live/\${FQDN}/fullchain.pem /etc/nginx/conf.d/cert/\${FQDN}.crt
      cp /etc/letsencrypt/live/\${FQDN}/privkey.pem /etc/nginx/conf.d/cert/\${FQDN}.key
    fi
  done
  nginx -t && nginx -s reload
"

# -----------------------------------------------------------
# 6. Quick smoke test
# -----------------------------------------------------------
step "Quick smoke test..."

API_STATUS=$(ssh "${META}" "curl -s -o /dev/null -w '%{http_code}' https://${API_FQDN}/rest/v1/ -H 'apikey: placeholder'" 2>/dev/null)
APP_STATUS=$(ssh "${META}" "curl -s -o /dev/null -w '%{http_code}' https://${APP_FQDN}" 2>/dev/null)
STUDIO_STATUS=$(ssh "${META}" "curl -s -o /dev/null -w '%{http_code}' https://${STUDIO_FQDN}" 2>/dev/null)

echo "  API    (${API_FQDN}):    HTTP ${API_STATUS} $([ "${API_STATUS}" = "401" ] && echo '✓' || echo '?')"
echo "  App    (${APP_FQDN}):    HTTP ${APP_STATUS} $([ "${APP_STATUS}" = "200" ] && echo '✓' || echo '?')"
echo "  Studio (${STUDIO_FQDN}): HTTP ${STUDIO_STATUS} $([ "${STUDIO_STATUS}" = "200" ] || [ "${STUDIO_STATUS}" = "307" ] && echo '✓' || echo '?')"

echo ""
echo -e "${GREEN}Phase 2b complete: Supabase deployed and accessible.${NC}"
