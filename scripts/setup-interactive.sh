#!/usr/bin/env bash

# ============================================
# INTERACTIVE SETUP FOR PIGSTY + SUPABASE
# ============================================
# Simplified setup for client deployments
# Base domain: bitsneura.com
# Automatic DNS via Cloudflare API

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'
readonly BOLD='\033[1m'

# Base domain for all clients
readonly BASE_DOMAIN="bitsneura.com"

# Cloudflare API (for automatic DNS)
readonly CF_API_TOKEN="8vISDbXSJgcZk2u4Xb1M3qz6Wgy0zrZ49SuG0V0x"
readonly CF_ZONE_ID="81a85a22c025f40754817259237d203b"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ============================================
# HELPER FUNCTIONS
# ============================================

print_header() {
    clear
    echo -e "${GREEN}"
    cat << 'BANNER'
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🐷 Pigsty + Supabase - Client Setup                    ║
║   PostgreSQL 18 + Supabase + Backblaze B2 Backups        ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
}

prompt() {
    local var_name="$1"
    local prompt_text="$2"
    local default_value="${3:-}"
    local is_secret="${4:-false}"
    local value

    if [ -n "$default_value" ]; then
        echo -en "${CYAN}${prompt_text}${NC} [${default_value}]: "
    else
        echo -en "${CYAN}${prompt_text}${NC}: "
    fi

    if [ "$is_secret" = "true" ]; then
        read -rs value
        echo ""
    else
        read -r value
    fi

    # Use default if empty
    if [ -z "$value" ] && [ -n "$default_value" ]; then
        value="$default_value"
    fi

    eval "${var_name}='${value}'"
}

prompt_required() {
    local var_name="$1"
    local prompt_text="$2"
    local is_secret="${3:-false}"
    local value=""

    while [ -z "$value" ]; do
        echo -en "${CYAN}${prompt_text}${NC} ${RED}(required)${NC}: "
        if [ "$is_secret" = "true" ]; then
            read -rs value
            echo ""
        else
            read -r value
        fi
        if [ -z "$value" ]; then
            echo -e "${RED}This field is required.${NC}"
        fi
    done

    eval "${var_name}='${value}'"
}

prompt_yes_no() {
    local prompt_text="$1"
    local default="${2:-y}"
    local response

    if [ "$default" = "y" ]; then
        echo -en "${CYAN}${prompt_text}${NC} [Y/n]: "
    else
        echo -en "${CYAN}${prompt_text}${NC} [y/N]: "
    fi

    read -r response
    response="${response:-$default}"

    [[ "$response" =~ ^[Yy] ]]
}

generate_password() {
    openssl rand -base64 24 | tr -d '/+=' | head -c 32
}

generate_secret() {
    openssl rand -base64 32 | tr -d '/+='
}

# ============================================
# CLOUDFLARE DNS FUNCTIONS
# ============================================

create_dns_record() {
    local name="$1"
    local ip="$2"

    # Check if record already exists
    local existing=$(curl -s -X GET \
        "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records?type=A&name=${name}.${BASE_DOMAIN}" \
        -H "Authorization: Bearer ${CF_API_TOKEN}" \
        -H "Content-Type: application/json" | jq -r '.result[0].id // empty')

    if [ -n "$existing" ]; then
        # Update existing record
        curl -s -X PUT \
            "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${existing}" \
            -H "Authorization: Bearer ${CF_API_TOKEN}" \
            -H "Content-Type: application/json" \
            --data "{\"type\":\"A\",\"name\":\"${name}\",\"content\":\"${ip}\",\"ttl\":300,\"proxied\":false}" > /dev/null
    else
        # Create new record
        curl -s -X POST \
            "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records" \
            -H "Authorization: Bearer ${CF_API_TOKEN}" \
            -H "Content-Type: application/json" \
            --data "{\"type\":\"A\",\"name\":\"${name}\",\"content\":\"${ip}\",\"ttl\":300,\"proxied\":false}" > /dev/null
    fi
}

setup_cloudflare_dns() {
    local client="$1"
    local ip="$2"

    echo ""
    echo -e "${CYAN}Creating DNS records in Cloudflare...${NC}"

    create_dns_record "${client}" "${ip}"
    echo -e "  ${GREEN}✓${NC} ${client}.${BASE_DOMAIN} → ${ip}"

    create_dns_record "api.${client}" "${ip}"
    echo -e "  ${GREEN}✓${NC} api.${client}.${BASE_DOMAIN} → ${ip}"

    create_dns_record "studio.${client}" "${ip}"
    echo -e "  ${GREEN}✓${NC} studio.${client}.${BASE_DOMAIN} → ${ip}"

    echo ""
    echo -e "${CYAN}Waiting for DNS propagation (30s)...${NC}"
    sleep 30
    echo -e "${GREEN}✓ DNS configured${NC}"
}

# Load values from backup .env if exists
load_backup_env() {
    local backup_file=""

    # Find most recent backup
    for f in "${PROJECT_ROOT}"/.env.backup.*; do
        if [ -f "$f" ]; then
            backup_file="$f"
        fi
    done

    if [ -n "$backup_file" ] && [ -f "$backup_file" ]; then
        echo -e "${GREEN}Found previous configuration: ${backup_file}${NC}"
        if prompt_yes_no "Use Backblaze B2 and SMTP settings from backup?"; then
            source "$backup_file"
            REUSE_CONFIG="true"
            echo -e "${GREEN}✓ Loaded previous settings${NC}"
            return 0
        fi
    fi

    REUSE_CONFIG="false"
    return 1
}

# ============================================
# SETUP FUNCTIONS
# ============================================

setup_client() {
    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  Step 1: Client & Server${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    prompt_required VPS_HOST "VPS IP address"

    echo ""
    prompt_required CLIENT_NAME "Client name (subdomain)"

    # Build full domain
    SUPABASE_DOMAIN="${CLIENT_NAME}.${BASE_DOMAIN}"

    echo ""
    echo -e "${GREEN}URLs for this client:${NC}"
    echo -e "  App:    ${BOLD}https://${SUPABASE_DOMAIN}${NC}"
    echo -e "  API:    ${BOLD}https://api.${SUPABASE_DOMAIN}${NC}"
    echo -e "  Studio: ${BOLD}https://studio.${SUPABASE_DOMAIN}${NC}"
    echo ""

    # Automatic DNS via Cloudflare
    setup_cloudflare_dns "${CLIENT_NAME}" "${VPS_HOST}"

    # SSH settings
    SSH_USER="ubuntu"

    # Auto-detect SSH key
    for key in ~/.ssh/id_ed25519 ~/.ssh/id_rsa ~/.ssh/pigsty_deploy; do
        if [ -f "$key" ]; then
            SSH_KEY_PATH="$key"
            break
        fi
    done
    echo -e "${GREEN}✓ Using SSH key: ${SSH_KEY_PATH}${NC}"
}

setup_backblaze() {
    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  Step 2: Backblaze B2 Storage${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    if [ "${REUSE_CONFIG:-false}" = "true" ] && [ -n "${S3_BUCKET:-}" ]; then
        echo -e "${GREEN}✓ Using saved Backblaze B2 config:${NC}"
        echo -e "  Bucket:   ${S3_BUCKET}"
        echo -e "  Endpoint: ${S3_ENDPOINT}"
        echo ""

        # Copy to pgbackrest vars
        PGBACKREST_ENABLED="true"
        PGBACKREST_METHOD="s3"
        PGBACKREST_S3_BUCKET="$S3_BUCKET"
        PGBACKREST_S3_ENDPOINT="$S3_ENDPOINT"
        PGBACKREST_S3_REGION="$S3_REGION"
        PGBACKREST_S3_ACCESS_KEY="$S3_ACCESS_KEY"
        PGBACKREST_S3_SECRET_KEY="$S3_SECRET_KEY"
        PGBACKREST_CIPHER_PASS="$(generate_secret)"
        PGBACKREST_RETENTION_FULL="14"
        S3_FORCE_PATH_STYLE="false"
        S3_PROTOCOL="https"
        return 0
    fi

    echo -e "Backblaze B2 is used for file storage and PostgreSQL backups."
    echo ""

    prompt_required S3_BUCKET "B2 bucket name"
    prompt S3_ENDPOINT "B2 endpoint" "https://s3.us-east-005.backblazeb2.com"
    prompt S3_REGION "B2 region" "us-east-005"
    prompt_required S3_ACCESS_KEY "B2 Application Key ID"
    prompt_required S3_SECRET_KEY "B2 Application Key" "true"

    S3_FORCE_PATH_STYLE="false"
    S3_PROTOCOL="https"

    # pgBackRest settings
    PGBACKREST_ENABLED="true"
    PGBACKREST_METHOD="s3"
    PGBACKREST_S3_BUCKET="$S3_BUCKET"
    PGBACKREST_S3_ENDPOINT="$S3_ENDPOINT"
    PGBACKREST_S3_REGION="$S3_REGION"
    PGBACKREST_S3_ACCESS_KEY="$S3_ACCESS_KEY"
    PGBACKREST_S3_SECRET_KEY="$S3_SECRET_KEY"
    PGBACKREST_CIPHER_PASS="$(generate_secret)"
    PGBACKREST_RETENTION_FULL="14"
}

setup_smtp() {
    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  Step 3: Email (SMTP)${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    if [ "${REUSE_CONFIG:-false}" = "true" ] && [ -n "${SMTP_HOST:-}" ]; then
        echo -e "${GREEN}✓ Using saved SMTP config:${NC}"
        echo -e "  Host: ${SMTP_HOST}"
        echo -e "  User: ${SMTP_USER}"
        echo ""
        return 0
    fi

    if prompt_yes_no "Configure SMTP for emails?" "y"; then
        prompt SMTP_HOST "SMTP server" "smtp.resend.com"
        prompt SMTP_PORT "SMTP port" "587"
        prompt SMTP_USER "SMTP username" "resend"
        prompt_required SMTP_PASSWORD "SMTP password" "true"
        prompt SMTP_SENDER_NAME "Sender name" "Bits Supabase"
        prompt SMTP_ADMIN_EMAIL "Admin email" "noreply@updates.bits.do"
    else
        SMTP_HOST=""
        SMTP_PORT=""
        SMTP_USER=""
        SMTP_PASSWORD=""
        SMTP_SENDER_NAME=""
        SMTP_ADMIN_EMAIL=""
    fi
}

setup_ssl() {
    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  Step 4: SSL Certificate${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    if prompt_yes_no "Enable HTTPS with Let's Encrypt?" "y"; then
        USE_LETSENCRYPT="true"
        prompt LETSENCRYPT_EMAIL "Email for Let's Encrypt" "admin@bitsneura.com"
        SUPABASE_API_EXTERNAL_URL="https://${SUPABASE_DOMAIN}"
    else
        USE_LETSENCRYPT="false"
        LETSENCRYPT_EMAIL=""
        SUPABASE_API_EXTERNAL_URL="http://${SUPABASE_DOMAIN}"
    fi
}

generate_secrets() {
    echo ""
    echo -e "${BOLD}Generating secure passwords...${NC}"

    # Deploy user
    DEPLOY_USER="deploy"
    DEPLOY_USER_PASSWORD="$(generate_password)"

    # PostgreSQL
    POSTGRES_PASSWORD="$(generate_password)"
    PG_ADMIN_PASSWORD="$(generate_password)"
    PG_MONITOR_PASSWORD="$(generate_password)"
    PG_REPLICATION_PASSWORD="$(generate_password)"
    PATRONI_PASSWORD="$(generate_password)"
    HAPROXY_ADMIN_PASSWORD="$(generate_password)"

    # JWT
    JWT_SECRET="$(generate_secret)$(generate_secret | head -c 10)"

    # Generate JWT tokens
    local header='{"alg":"HS256","typ":"JWT"}'

    local anon_payload='{"role":"anon","iss":"supabase","iat":1641971400,"exp":4795571400}'
    local anon_header_b64=$(echo -n "$header" | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n')
    local anon_payload_b64=$(echo -n "$anon_payload" | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n')
    local anon_signature=$(echo -n "${anon_header_b64}.${anon_payload_b64}" | openssl dgst -sha256 -hmac "$JWT_SECRET" -binary | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n')
    ANON_KEY="${anon_header_b64}.${anon_payload_b64}.${anon_signature}"

    local service_payload='{"role":"service_role","iss":"supabase","iat":1641971400,"exp":4795571400}'
    local service_payload_b64=$(echo -n "$service_payload" | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n')
    local service_signature=$(echo -n "${anon_header_b64}.${service_payload_b64}" | openssl dgst -sha256 -hmac "$JWT_SECRET" -binary | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n')
    SERVICE_ROLE_KEY="${anon_header_b64}.${service_payload_b64}.${service_signature}"

    # Dashboard
    DASHBOARD_USERNAME="supabase"
    DASHBOARD_PASSWORD="$(generate_password)"

    # Logflare
    LOGFLARE_PUBLIC_ACCESS_TOKEN="$(openssl rand -hex 32)"
    LOGFLARE_PRIVATE_ACCESS_TOKEN="$(openssl rand -hex 32)"

    # Other keys
    PG_META_CRYPTO_KEY="$(generate_password)"
    SECRET_KEY_BASE="$(generate_secret)$(generate_secret | head -c 20)"

    # Monitoring
    GRAFANA_ADMIN_PASSWORD="$(generate_password)"

    # MinIO
    MINIO_ROOT_USER="minioadmin"
    MINIO_ROOT_PASSWORD="$(generate_password)"

    echo -e "${GREEN}✓ All passwords generated${NC}"
}

write_env_file() {
    local env_file="${PROJECT_ROOT}/.env"
    local client_upper=$(echo "$CLIENT_NAME" | tr '[:lower:]' '[:upper:]')
    local generated_date=$(date)

    cat > "$env_file" << EOF
# ============================================
# PIGSTY SUPABASE - ${client_upper} CLIENT
# ============================================
# Generated: ${generated_date}
# Client: ${CLIENT_NAME}
# Domain: ${SUPABASE_DOMAIN}

# ============================================
# VPS CONNECTION
# ============================================
VPS_HOST=${VPS_HOST}
SSH_USER=${SSH_USER}
SSH_KEY_PATH=${SSH_KEY_PATH}

# ============================================
# DEPLOY USER
# ============================================
DEPLOY_USER=${DEPLOY_USER}
DEPLOY_USER_PASSWORD=${DEPLOY_USER_PASSWORD}

# ============================================
# DOMAIN & SSL
# ============================================
SUPABASE_DOMAIN=${SUPABASE_DOMAIN}
SUPABASE_API_EXTERNAL_URL=${SUPABASE_API_EXTERNAL_URL}
USE_LETSENCRYPT=${USE_LETSENCRYPT}
LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}

# ============================================
# POSTGRESQL
# ============================================
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
PG_ADMIN_PASSWORD=${PG_ADMIN_PASSWORD}
PG_MONITOR_PASSWORD=${PG_MONITOR_PASSWORD}
PG_REPLICATION_PASSWORD=${PG_REPLICATION_PASSWORD}
PATRONI_PASSWORD=${PATRONI_PASSWORD}
HAPROXY_ADMIN_PASSWORD=${HAPROXY_ADMIN_PASSWORD}

# ============================================
# SUPABASE JWT
# ============================================
JWT_SECRET=${JWT_SECRET}
ANON_KEY=${ANON_KEY}
SERVICE_ROLE_KEY=${SERVICE_ROLE_KEY}

# ============================================
# SUPABASE DASHBOARD
# ============================================
DASHBOARD_USERNAME=${DASHBOARD_USERNAME}
DASHBOARD_PASSWORD=${DASHBOARD_PASSWORD}

# ============================================
# SUPABASE LOGFLARE
# ============================================
LOGFLARE_PUBLIC_ACCESS_TOKEN=${LOGFLARE_PUBLIC_ACCESS_TOKEN}
LOGFLARE_PRIVATE_ACCESS_TOKEN=${LOGFLARE_PRIVATE_ACCESS_TOKEN}

# ============================================
# SUPABASE INTERNAL
# ============================================
PG_META_CRYPTO_KEY=${PG_META_CRYPTO_KEY}
SECRET_KEY_BASE=${SECRET_KEY_BASE}

# ============================================
# MONITORING
# ============================================
GRAFANA_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}

# ============================================
# STORAGE (Backblaze B2)
# ============================================
MINIO_ROOT_USER=${MINIO_ROOT_USER}
MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}

S3_BUCKET=${S3_BUCKET}
S3_ENDPOINT=${S3_ENDPOINT}
S3_REGION=${S3_REGION}
S3_ACCESS_KEY=${S3_ACCESS_KEY}
S3_SECRET_KEY=${S3_SECRET_KEY}
S3_FORCE_PATH_STYLE=${S3_FORCE_PATH_STYLE}
S3_PROTOCOL=${S3_PROTOCOL}

# ============================================
# PGBACKREST BACKUPS
# ============================================
PGBACKREST_ENABLED=${PGBACKREST_ENABLED}
PGBACKREST_METHOD=${PGBACKREST_METHOD}
PGBACKREST_S3_BUCKET=${PGBACKREST_S3_BUCKET}
PGBACKREST_S3_ENDPOINT=${PGBACKREST_S3_ENDPOINT}
PGBACKREST_S3_REGION=${PGBACKREST_S3_REGION}
PGBACKREST_S3_ACCESS_KEY=${PGBACKREST_S3_ACCESS_KEY}
PGBACKREST_S3_SECRET_KEY=${PGBACKREST_S3_SECRET_KEY}
PGBACKREST_CIPHER_PASS=${PGBACKREST_CIPHER_PASS}
PGBACKREST_RETENTION_FULL=${PGBACKREST_RETENTION_FULL}

# ============================================
# SMTP
# ============================================
SMTP_HOST=${SMTP_HOST:-}
SMTP_PORT=${SMTP_PORT:-}
SMTP_USER=${SMTP_USER:-}
SMTP_PASSWORD=${SMTP_PASSWORD:-}
SMTP_SENDER_NAME=${SMTP_SENDER_NAME:-}
SMTP_ADMIN_EMAIL=${SMTP_ADMIN_EMAIL:-}
EOF

    chmod 600 "$env_file"
    echo -e "${GREEN}✓ Configuration saved to .env${NC}"
}

print_summary() {
    local client_upper=$(echo "$CLIENT_NAME" | tr '[:lower:]' '[:upper:]')
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  Setup Complete for ${client_upper}${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BOLD}Client URLs:${NC}"
    local proto="http"
    [ "$USE_LETSENCRYPT" = "true" ] && proto="https"
    echo -e "  App:      ${proto}://${SUPABASE_DOMAIN}"
    echo -e "  API:      ${proto}://api.${SUPABASE_DOMAIN}"
    echo -e "  Studio:   ${proto}://studio.${SUPABASE_DOMAIN}"
    echo ""
    echo -e "${BOLD}Credentials:${NC}"
    echo -e "  Dashboard:  ${DASHBOARD_USERNAME} / ${DASHBOARD_PASSWORD}"
    echo -e "  PostgreSQL: supabase_admin / ${POSTGRES_PASSWORD}"
    echo -e "  Grafana:    admin / ${GRAFANA_ADMIN_PASSWORD}"
    echo ""
    echo -e "${BOLD}Backups:${NC}"
    echo -e "  Destination: Backblaze B2 (${S3_BUCKET})"
    echo -e "  Schedule:    Daily at 2 AM"
    echo -e "  Retention:   14 days"
    echo ""
    echo -e "${YELLOW}To deploy now, run:${NC}"
    echo -e "  ${BOLD}./scripts/deploy-simple all${NC}"
    echo ""
}

# ============================================
# MAIN
# ============================================

main() {
    cd "$PROJECT_ROOT"

    print_header

    # Check for existing .env
    if [ -f ".env" ]; then
        echo -e "${YELLOW}⚠️  An existing .env file was found.${NC}"
        if ! prompt_yes_no "Overwrite with new client setup?"; then
            echo -e "${BLUE}Keeping existing configuration.${NC}"
            exit 0
        fi
    fi

    # Try to load backup config for B2/SMTP reuse
    load_backup_env || true

    setup_client
    setup_backblaze
    setup_smtp
    setup_ssl
    generate_secrets
    write_env_file
    print_summary
}

main "$@"
