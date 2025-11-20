#!/usr/bin/env bash

# ============================================
# MODULE: Pigsty Configuration
# ============================================
# Downloads Pigsty and generates config from official template

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

configure_pigsty() {
    log_step "Pigsty Configuration"

    load_env
    validate_jwt_secret

    # Generate JWT tokens if not provided
    if [ -z "${ANON_KEY:-}" ]; then
        log_info "Generating ANON_KEY..."
        ANON_KEY=$(generate_jwt_token "anon" "${JWT_SECRET}")
        log_warning "Add to .env: ANON_KEY=\"${ANON_KEY}\""
    fi

    if [ -z "${SERVICE_ROLE_KEY:-}" ]; then
        log_info "Generating SERVICE_ROLE_KEY..."
        SERVICE_ROLE_KEY=$(generate_jwt_token "service_role" "${JWT_SECRET}")
        log_warning "Add to .env: SERVICE_ROLE_KEY=\"${SERVICE_ROLE_KEY}\""
    fi

    # Download Pigsty on VPS
    log_info "Downloading Pigsty on VPS..."
    ssh_exec << 'REMOTE'
set -e
cd ~
if [ -d ~/pigsty ]; then
    echo "Backing up existing Pigsty installation..."
    mv ~/pigsty ~/pigsty.backup.$(date +%Y%m%d_%H%M%S)
fi
curl -fsSL https://repo.pigsty.io/get | bash
REMOTE
    log_success "Pigsty downloaded"

    # Bootstrap Ansible
    log_info "Installing Ansible..."
    ssh_exec << 'REMOTE'
set -e
cd ~/pigsty
./bootstrap
REMOTE
    log_success "Ansible installed"

    # Generate official config with app/supa template
    log_info "Generating configuration from official template..."
    ssh_exec << REMOTE
set -e
cd ~/pigsty
# Non-interactive configuration with explicit IP
./configure -c app/supa -i ${VPS_HOST} -n
REMOTE
    log_success "Base configuration generated"

    # Download config to Mac for patching
    log_info "Downloading configuration for patching..."
    scp -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o LogLevel=ERROR \
        "${DEPLOY_USER}@${VPS_HOST}:~/pigsty/pigsty.yml" \
        /tmp/pigsty.yml

    # Apply patches using Python script (handles special characters in passwords)
    log_info "Applying custom patches with yaml-update.py..."

    # Export all environment variables needed by yaml-update.py
    export GRAFANA_ADMIN_PASSWORD
    export PG_ADMIN_PASSWORD
    export PG_MONITOR_PASSWORD
    export PG_REPLICATION_PASSWORD
    export PATRONI_PASSWORD
    export HAPROXY_ADMIN_PASSWORD
    export POSTGRES_PASSWORD
    export MINIO_ROOT_PASSWORD
    export JWT_SECRET
    export ANON_KEY
    export SERVICE_ROLE_KEY
    export DASHBOARD_USERNAME
    export DASHBOARD_PASSWORD
    export LOGFLARE_PUBLIC_ACCESS_TOKEN
    export LOGFLARE_PRIVATE_ACCESS_TOKEN
    export S3_BUCKET
    export S3_ENDPOINT
    export S3_REGION
    export S3_ACCESS_KEY
    export S3_SECRET_KEY
    export S3_FORCE_PATH_STYLE
    export S3_PROTOCOL
    export VPS_HOST
    export SUPABASE_DOMAIN
    export USE_LETSENCRYPT
    export LETSENCRYPT_EMAIL
    export SMTP_HOST
    export SMTP_PORT
    export SMTP_USER
    export SMTP_PASSWORD
    export SMTP_SENDER_NAME
    export PGBACKREST_ENABLED
    export PGBACKREST_METHOD
    export PGBACKREST_S3_BUCKET
    export PGBACKREST_S3_ENDPOINT
    export PGBACKREST_S3_REGION
    export PGBACKREST_S3_ACCESS_KEY
    export PGBACKREST_S3_SECRET_KEY
    export PGBACKREST_CIPHER_PASS
    export PGBACKREST_RETENTION_FULL
    export PGBACKREST_LOCAL_ENABLED
    export PGBACKREST_LOCAL_RETENTION_FULL

    # Run Python script to update configuration
    python3 "${PROJECT_ROOT}/lib/yaml-update.py" /tmp/pigsty.yml

    log_success "Configuration patched"

    # Upload patched config
    log_info "Uploading patched configuration..."
    scp -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o LogLevel=ERROR \
        /tmp/pigsty.yml \
        "${DEPLOY_USER}@${VPS_HOST}:~/pigsty/pigsty.yml"

    log_success "Configuration completed"
}



# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    configure_pigsty
fi
