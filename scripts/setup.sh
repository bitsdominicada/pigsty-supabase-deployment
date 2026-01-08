#!/usr/bin/env bash
#==============================================================================#
# SETUP: Interactive configuration wizard
#==============================================================================#

# Generate random password (alphanumeric only)
gen_pass() { openssl rand -base64 32 | tr -d '/+=' | head -c "${1:-32}"; }

# Generate JWT token
gen_jwt() {
    local role="$1"
    local secret="$2"
    local header='{"alg":"HS256","typ":"JWT"}'
    local payload="{\"role\":\"${role}\",\"iss\":\"supabase\",\"iat\":1700000000,\"exp\":4800000000}"

    local h=$(echo -n "$header" | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n')
    local p=$(echo -n "$payload" | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n')
    local sig=$(echo -n "${h}.${p}" | openssl dgst -sha256 -hmac "$secret" -binary | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n')

    echo "${h}.${p}.${sig}"
}

# Prompt helper
prompt() {
    local var="$1" text="$2" default="${3:-}"
    if [[ -n "$default" ]]; then
        echo -en "\033[0;36m${text}\033[0m [$default]: "
    else
        echo -en "\033[0;36m${text}\033[0m: "
    fi
    read -r value
    eval "${var}='${value:-$default}'"
}

prompt_secret() {
    local var="$1" text="$2"
    echo -en "\033[0;36m${text}\033[0m: "
    read -rs value
    echo ""
    eval "${var}='${value}'"
}

prompt_yn() {
    local text="$1" default="${2:-y}"
    local yn_hint="[Y/n]"
    [[ "$default" == "n" ]] && yn_hint="[y/N]"
    echo -en "\033[0;36m${text}\033[0m ${yn_hint}: "
    read -r value
    value="${value:-$default}"
    [[ "$value" =~ ^[Yy] ]]
}

run_setup() {
    clear
    echo -e "\033[1;32m"
    cat << 'BANNER'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   PIGSTY SUPABASE - Configuration Setup                      ║
║   PostgreSQL 18 + Supabase + Monitoring                       ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
BANNER
    echo -e "\033[0m"

    #--------------------------------------------------------------------------#
    # VPS Connection
    #--------------------------------------------------------------------------#
    echo -e "\n\033[1m━━━ VPS Connection ━━━\033[0m\n"

    prompt VPS_HOST "VPS IP address"
    prompt SSH_USER "SSH username" "ubuntu"

    # Auto-detect SSH key
    SSH_KEY=""
    for key in ~/.ssh/id_ed25519 ~/.ssh/id_rsa; do
        [[ -f "$key" ]] && SSH_KEY="$key" && break
    done
    prompt SSH_KEY "SSH key path" "$SSH_KEY"

    #--------------------------------------------------------------------------#
    # Domain & Client
    #--------------------------------------------------------------------------#
    echo -e "\n\033[1m━━━ Domain Configuration ━━━\033[0m\n"

    prompt CLIENT_NAME "Client name (for subdomain)"
    prompt BASE_DOMAIN "Base domain" "bitsneura.com"

    SUPABASE_DOMAIN="${CLIENT_NAME}.${BASE_DOMAIN}"
    echo -e "\n  URLs:"
    echo -e "    App:    https://${SUPABASE_DOMAIN}"
    echo -e "    API:    https://api.${SUPABASE_DOMAIN}"
    echo -e "    Studio: https://studio.${SUPABASE_DOMAIN}\n"

    #--------------------------------------------------------------------------#
    # SSL
    #--------------------------------------------------------------------------#
    if prompt_yn "Enable HTTPS with Let's Encrypt?"; then
        USE_LETSENCRYPT="true"
        prompt LETSENCRYPT_EMAIL "Email for SSL certificates" "admin@${BASE_DOMAIN}"
    else
        USE_LETSENCRYPT="false"
        LETSENCRYPT_EMAIL=""
    fi

    #--------------------------------------------------------------------------#
    # Backblaze B2 (Storage + Backups)
    #--------------------------------------------------------------------------#
    echo -e "\n\033[1m━━━ Backblaze B2 Storage ━━━\033[0m\n"

    if prompt_yn "Configure Backblaze B2 for storage and backups?"; then
        prompt S3_BUCKET "B2 Bucket name"
        prompt S3_ENDPOINT "B2 Endpoint" "https://s3.us-east-005.backblazeb2.com"
        prompt S3_REGION "B2 Region" "us-east-005"
        prompt S3_ACCESS_KEY "B2 Key ID"
        prompt_secret S3_SECRET_KEY "B2 Application Key"
        STORAGE_BACKEND="s3"
    else
        S3_BUCKET=""
        S3_ENDPOINT=""
        S3_REGION=""
        S3_ACCESS_KEY=""
        S3_SECRET_KEY=""
        STORAGE_BACKEND="minio"
    fi

    #--------------------------------------------------------------------------#
    # SMTP (optional)
    #--------------------------------------------------------------------------#
    echo -e "\n\033[1m━━━ Email (SMTP) ━━━\033[0m\n"

    if prompt_yn "Configure SMTP for emails?" "n"; then
        prompt SMTP_HOST "SMTP host" "smtp.resend.com"
        prompt SMTP_PORT "SMTP port" "587"
        prompt SMTP_USER "SMTP username" "resend"
        prompt_secret SMTP_PASSWORD "SMTP password"
        prompt SMTP_SENDER_NAME "Sender name" "Supabase"
        prompt SMTP_ADMIN_EMAIL "From email" "noreply@${BASE_DOMAIN}"
    else
        SMTP_HOST=""
        SMTP_PORT=""
        SMTP_USER=""
        SMTP_PASSWORD=""
        SMTP_SENDER_NAME=""
        SMTP_ADMIN_EMAIL=""
    fi

    #--------------------------------------------------------------------------#
    # Generate Secrets
    #--------------------------------------------------------------------------#
    echo -e "\n\033[1m━━━ Generating Secrets ━━━\033[0m\n"

    # PostgreSQL
    POSTGRES_PASSWORD=$(gen_pass 32)
    PG_ADMIN_PASSWORD=$(gen_pass 32)
    PG_MONITOR_PASSWORD=$(gen_pass 24)
    PG_REPLICATION_PASSWORD=$(gen_pass 24)
    PATRONI_PASSWORD=$(gen_pass 24)

    # Supabase JWT
    JWT_SECRET=$(gen_pass 64)
    ANON_KEY=$(gen_jwt "anon" "$JWT_SECRET")
    SERVICE_ROLE_KEY=$(gen_jwt "service_role" "$JWT_SECRET")

    # Dashboard
    DASHBOARD_USERNAME="supabase"
    DASHBOARD_PASSWORD=$(gen_pass 24)

    # Other
    GRAFANA_ADMIN_PASSWORD=$(gen_pass 24)
    PG_META_CRYPTO_KEY=$(gen_pass 32)
    SECRET_KEY_BASE=$(gen_pass 64)
    LOGFLARE_API_KEY=$(gen_pass 32)

    # pgBackRest
    PGBACKREST_CIPHER_PASS=$(gen_pass 40)

    echo -e "\033[0;32m✓ All secrets generated\033[0m"

    #--------------------------------------------------------------------------#
    # Write .env
    #--------------------------------------------------------------------------#
    cat > "$SCRIPT_DIR/.env" << EOF
#==============================================================================#
# PIGSTY SUPABASE - ${CLIENT_NAME^^}
#==============================================================================#
# Generated: $(date)
# Domain: ${SUPABASE_DOMAIN}
#==============================================================================#

# VPS Connection
VPS_HOST=${VPS_HOST}
SSH_USER=${SSH_USER}
SSH_KEY=${SSH_KEY}

# Domain
CLIENT_NAME=${CLIENT_NAME}
BASE_DOMAIN=${BASE_DOMAIN}
SUPABASE_DOMAIN=${SUPABASE_DOMAIN}

# SSL
USE_LETSENCRYPT=${USE_LETSENCRYPT}
LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}

# PostgreSQL
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
PG_ADMIN_PASSWORD=${PG_ADMIN_PASSWORD}
PG_MONITOR_PASSWORD=${PG_MONITOR_PASSWORD}
PG_REPLICATION_PASSWORD=${PG_REPLICATION_PASSWORD}
PATRONI_PASSWORD=${PATRONI_PASSWORD}

# Supabase JWT
JWT_SECRET=${JWT_SECRET}
ANON_KEY=${ANON_KEY}
SERVICE_ROLE_KEY=${SERVICE_ROLE_KEY}

# Supabase Dashboard
DASHBOARD_USERNAME=${DASHBOARD_USERNAME}
DASHBOARD_PASSWORD=${DASHBOARD_PASSWORD}

# Supabase Internal
PG_META_CRYPTO_KEY=${PG_META_CRYPTO_KEY}
SECRET_KEY_BASE=${SECRET_KEY_BASE}
LOGFLARE_API_KEY=${LOGFLARE_API_KEY}

# Monitoring
GRAFANA_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}

# Storage (Backblaze B2)
STORAGE_BACKEND=${STORAGE_BACKEND}
S3_BUCKET=${S3_BUCKET}
S3_ENDPOINT=${S3_ENDPOINT}
S3_REGION=${S3_REGION}
S3_ACCESS_KEY=${S3_ACCESS_KEY}
S3_SECRET_KEY=${S3_SECRET_KEY}

# Backups
PGBACKREST_CIPHER_PASS=${PGBACKREST_CIPHER_PASS}

# SMTP
SMTP_HOST=${SMTP_HOST}
SMTP_PORT=${SMTP_PORT}
SMTP_USER=${SMTP_USER}
SMTP_PASSWORD=${SMTP_PASSWORD}
SMTP_SENDER_NAME=${SMTP_SENDER_NAME}
SMTP_ADMIN_EMAIL=${SMTP_ADMIN_EMAIL}
EOF

    chmod 600 "$SCRIPT_DIR/.env"

    #--------------------------------------------------------------------------#
    # Summary
    #--------------------------------------------------------------------------#
    echo -e "\n\033[1;32m━━━ Configuration Complete ━━━\033[0m\n"
    echo -e "  VPS:       ${VPS_HOST}"
    echo -e "  Domain:    ${SUPABASE_DOMAIN}"
    echo -e "  Storage:   ${STORAGE_BACKEND^^}"
    echo -e "  SSL:       ${USE_LETSENCRYPT}"
    echo ""
    echo -e "  Dashboard: ${DASHBOARD_USERNAME} / ${DASHBOARD_PASSWORD}"
    echo -e "  Grafana:   admin / ${GRAFANA_ADMIN_PASSWORD}"
    echo ""
    echo -e "\033[1mNext step:\033[0m ./deploy install"
    echo ""
}
