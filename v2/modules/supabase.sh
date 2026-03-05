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
export POS_FQDN="${POS_SUBDOMAIN:-pos}.${DOMAIN}"
export AI_FQDN="${AI_SUBDOMAIN:-ai}.${DOMAIN}"
export PORTAL_FQDN="${PORTAL_SUBDOMAIN:-home}.${DOMAIN}"
export REGISTRY_FQDN="${REGISTRY_SUBDOMAIN:-registry}.${DOMAIN}"
export REGISTRY_UI_FQDN="${REGISTRY_UI_SUBDOMAIN:-registry-ui}.${DOMAIN}"

# Keep inventory in sync before running Pigsty playbooks.
if [[ -f "${TEMPLATES_DIR}/pigsty.yml.tpl" ]]; then
  step "Rendering and uploading pigsty inventory..."
  envsubst < "${TEMPLATES_DIR}/pigsty.yml.tpl" > /tmp/pigsty-v2-generated.yml
  scp /tmp/pigsty-v2-generated.yml "${META}:${PIGSTY_DIR}/pigsty.yml"
  scp /tmp/pigsty-v2-generated.yml "${META}:${PIGSTY_DIR}/pigsty-ha.yml"
  echo "Uploaded pigsty.yml and pigsty-ha.yml"
else
  warn "No pigsty.yml.tpl found — using existing inventory on server."
fi

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

# Install Pigsty registry app explicitly. The same host belongs to multiple
# app groups, so we force app selection here to avoid inventory precedence.
step "Running Pigsty app.yml for Docker registry mirror..."
ssh "${META}" "cd ${PIGSTY_DIR} && ./app.yml -e app=registry"

# Pigsty's bundled registry app defaults to proxy mode (Docker Hub mirror),
# which can fail on networks with restricted egress. Keep a plain local registry.
step "Configuring registry as local private registry (no upstream proxy)..."
ssh "${META}" "cat > /opt/registry/config.yml <<'CFG'
version: 0.1
log:
  fields:
    service: registry
  level: info

storage:
  cache:
    blobdescriptor: inmemory
  filesystem:
    rootdirectory: /var/lib/registry
  delete:
    enabled: true

http:
  addr: 0.0.0.0:5000
  headers:
    X-Content-Type-Options: [nosniff]
    Access-Control-Allow-Origin: ['*']
    Access-Control-Allow-Methods: ['HEAD', 'GET', 'OPTIONS', 'DELETE']
    Access-Control-Allow-Headers: ['Authorization', 'Accept', 'Cache-Control']
    Access-Control-Max-Age: [1728000]
    Access-Control-Allow-Credentials: [true]
    Access-Control-Expose-Headers: ['Docker-Content-Digest']

health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
CFG
cd /opt/registry && docker compose up -d registry registry-ui"

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

# Re-render Nginx from infra_portal so app/pos/ai endpoints are published.
ssh "${META}" "cd ${PIGSTY_DIR} && ./infra.yml -t nginx_config,nginx_reload"

# Ensure certbot and acme challenge dir exist
ssh "${META}" "mkdir -p /www/acme/.well-known/acme-challenge"

# Request Let's Encrypt certificates for all domains
for FQDN in "${APP_FQDN}" "${POS_FQDN}" "${AI_FQDN}" "${API_FQDN}" "${STUDIO_FQDN}"; do
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
  for FQDN in ${APP_FQDN} ${POS_FQDN} ${AI_FQDN} ${API_FQDN} ${STUDIO_FQDN}; do
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

PORTAL_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${PORTAL_FQDN}" 2>/dev/null || echo "000")
API_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${API_FQDN}/rest/v1/ -H 'apikey: placeholder'" 2>/dev/null || echo "000")
APP_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${APP_FQDN}" 2>/dev/null || echo "000")
POS_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${POS_FQDN}" 2>/dev/null || echo "000")
AI_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${AI_FQDN}/health" 2>/dev/null || echo "000")
LITELLM_STATUS=$(ssh "${META}" "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:4000/health" 2>/dev/null || echo "000")
STUDIO_STATUS=$(ssh "${META}" "curl -sk -o /dev/null -w '%{http_code}' https://${STUDIO_FQDN}" 2>/dev/null || echo "000")
REGISTRY_STATUS=$(ssh "${META}" "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:5000/v2/" 2>/dev/null || echo "000")
REGISTRY_UI_STATUS=$(ssh "${META}" "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:5080" 2>/dev/null || echo "000")

echo "  Portal (${PORTAL_FQDN}): HTTP ${PORTAL_STATUS} $([ "${PORTAL_STATUS}" = "200" ] || [ "${PORTAL_STATUS}" = "307" ] && echo '✓' || echo '?')"
echo "  API    (${API_FQDN}):    HTTP ${API_STATUS} $([ "${API_STATUS}" = "401" ] && echo '✓' || echo '?')"
echo "  App    (${APP_FQDN}):    HTTP ${APP_STATUS} $([ "${APP_STATUS}" = "200" ] && echo '✓' || echo '?')"
echo "  POS    (${POS_FQDN}):    HTTP ${POS_STATUS} $([ "${POS_STATUS}" = "200" ] && echo '✓' || echo '?')"
echo "  AI     (${AI_FQDN}):     HTTP ${AI_STATUS} $([ "${AI_STATUS}" = "200" ] && echo '✓' || echo '?')"
echo "  LiteLLM (127.0.0.1):     HTTP ${LITELLM_STATUS} $([ "${LITELLM_STATUS}" = "200" ] && echo '✓' || echo '?')"
echo "  Studio (${STUDIO_FQDN}): HTTP ${STUDIO_STATUS} $([ "${STUDIO_STATUS}" = "200" ] || [ "${STUDIO_STATUS}" = "307" ] && echo '✓' || echo '?')"
echo "  Registry (127.0.0.1:5000/v2/): HTTP ${REGISTRY_STATUS} $([ "${REGISTRY_STATUS}" = "200" ] || [ "${REGISTRY_STATUS}" = "401" ] && echo '✓' || echo '?')"
echo "  Registry UI (127.0.0.1:5080):   HTTP ${REGISTRY_UI_STATUS} $([ "${REGISTRY_UI_STATUS}" = "200" ] || [ "${REGISTRY_UI_STATUS}" = "307" ] && echo '✓' || echo '?')"

echo ""
echo -e "${GREEN}Phase 2b complete: Supabase deployed and accessible.${NC}"
