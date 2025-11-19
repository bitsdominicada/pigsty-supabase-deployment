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
        /tmp/pigsty.yml.original

    # Apply patches
    log_info "Applying custom patches..."
    patch_config

    # Upload patched config
    log_info "Uploading patched configuration..."
    scp -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o LogLevel=ERROR \
        /tmp/pigsty.yml.patched \
        "${DEPLOY_USER}@${VPS_HOST}:~/pigsty/pigsty.yml"

    log_success "Configuration completed"
}

patch_config() {
    local input="/tmp/pigsty.yml.original"
    local output="/tmp/pigsty.yml.patched"

    # Copy original
    cp "$input" "$output"

    # Use sed to patch critical values
    # Replace passwords
    sed -i.bak "s/grafana_admin_password: .*/grafana_admin_password: ${GRAFANA_ADMIN_PASSWORD}/" "$output"
    sed -i.bak "s/pg_admin_password: .*/pg_admin_password: ${PG_ADMIN_PASSWORD}/" "$output"
    sed -i.bak "s/minio_secret_key: .*/minio_secret_key: ${MINIO_ROOT_PASSWORD}/" "$output"

    # Replace PostgreSQL password in pg_users section
    sed -i.bak "s/password: 'DBUser\.Supa'/password: '${POSTGRES_PASSWORD}'/" "$output"

    # Replace JWT secrets in app config
    if grep -q "JWT_SECRET:" "$output"; then
        sed -i.bak "s|JWT_SECRET: .*|JWT_SECRET: \"${JWT_SECRET}\"|" "$output"
        sed -i.bak "s|ANON_KEY: .*|ANON_KEY: \"${ANON_KEY}\"|" "$output"
        sed -i.bak "s|SERVICE_ROLE_KEY: .*|SERVICE_ROLE_KEY: \"${SERVICE_ROLE_KEY}\"|" "$output"
    else
        # Add Supabase app config if not present
        cat >> "$output" << APPCONFIG

# Supabase App Configuration
app_list:
  - { name: supabase, state: enabled }

app_supabase:
  JWT_SECRET: "${JWT_SECRET}"
  ANON_KEY: "${ANON_KEY}"
  SERVICE_ROLE_KEY: "${SERVICE_ROLE_KEY}"
  SITE_URL: "${SUPABASE_API_EXTERNAL_URL:-http://${VPS_HOST}:8000}"
  API_EXTERNAL_URL: "${SUPABASE_API_EXTERNAL_URL:-http://${VPS_HOST}:8000}"
  POSTGRES_HOST: "${VPS_HOST}"
  POSTGRES_PORT: "5436"
  POSTGRES_DB: "supa"
  POSTGRES_USER: "supabase_admin"
  POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
APPCONFIG
    fi

    # Optional: SMTP configuration
    if [ -n "${SMTP_HOST:-}" ]; then
        log_info "Adding SMTP configuration..."
        cat >> "$output" << SMTP
  SMTP_HOST: "${SMTP_HOST}"
  SMTP_PORT: "${SMTP_PORT:-587}"
  SMTP_USER: "${SMTP_USER:-}"
  SMTP_PASS: "${SMTP_PASSWORD:-}"
  SMTP_SENDER_NAME: "${SMTP_SENDER_NAME:-Supabase}"
SMTP
    fi

    # Cleanup backup files
    rm -f /tmp/pigsty.yml.*.bak

    log_success "Configuration patched"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    configure_pigsty
fi
