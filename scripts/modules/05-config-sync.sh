#!/usr/bin/env bash

# ============================================
# MODULE: Configuration Sync
# ============================================
# Syncs configuration between Mac and VPS

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

source "${SCRIPT_DIR}/utils.sh"

config_pull() {
    log_step "Pull Configuration from VPS"

    load_env

    # Create backup directory
    local backup_dir="${PROJECT_ROOT}/config/generated/backups"
    mkdir -p "$backup_dir"

    # Download current pigsty.yml from VPS
    log_info "Downloading pigsty.yml from VPS..."
    scp -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o LogLevel=ERROR \
        "${DEPLOY_USER}@${VPS_HOST}:~/pigsty/pigsty.yml" \
        "${PROJECT_ROOT}/config/generated/pigsty.yml" 2>/dev/null || {
            log_error "Failed to download pigsty.yml from VPS"
            log_info "Make sure Pigsty is installed on the VPS"
            return 1
        }

    # Also save as base template if it doesn't exist
    if [ ! -f "${PROJECT_ROOT}/config/templates/base.yml" ]; then
        log_info "Saving as base template..."
        cp "${PROJECT_ROOT}/config/generated/pigsty.yml" \
           "${PROJECT_ROOT}/config/templates/base.yml"
    fi

    log_success "Configuration downloaded from VPS"
}

config_sync() {
    log_step "Sync Configuration to VPS"

    load_env

    local config_dir="${PROJECT_ROOT}/config"
    local generated_file="${config_dir}/generated/pigsty.yml"
    local backup_dir="${config_dir}/generated/backups"

    mkdir -p "$backup_dir"

    # Download current pigsty.yml from VPS (or regenerate if not exists)
    log_info "Downloading current pigsty.yml from VPS..."

    if ! scp -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o LogLevel=ERROR \
        "${DEPLOY_USER}@${VPS_HOST}:~/pigsty/pigsty.yml" \
        "$generated_file" 2>/dev/null; then

        log_warning "Could not download pigsty.yml, will regenerate on VPS..."

        # Run configure on VPS to generate clean pigsty.yml
        ssh_exec << REMOTE
cd ~/pigsty
./configure -c app/supa -i ${VPS_HOST} -n > /dev/null 2>&1
echo "✓ Generated clean pigsty.yml"
REMOTE

        # Download the generated file
        scp -i ~/.ssh/pigsty_deploy \
            -o StrictHostKeyChecking=no \
            -o LogLevel=ERROR \
            "${DEPLOY_USER}@${VPS_HOST}:~/pigsty/pigsty.yml" \
            "$generated_file" 2>/dev/null
    fi

    log_success "Base configuration retrieved"

    # Apply credentials and SSL configuration using Python
    log_info "Applying credentials and SSL configuration..."

    # Export all credentials for yaml-update.py
    export GRAFANA_ADMIN_PASSWORD POSTGRES_PASSWORD PG_ADMIN_PASSWORD MINIO_ROOT_PASSWORD
    export JWT_SECRET ANON_KEY SERVICE_ROLE_KEY
    export DASHBOARD_USERNAME DASHBOARD_PASSWORD
    export LOGFLARE_PUBLIC_ACCESS_TOKEN LOGFLARE_PRIVATE_ACCESS_TOKEN
    export S3_PROVIDER S3_BUCKET S3_ENDPOINT S3_REGION S3_ACCESS_KEY S3_SECRET_KEY
    export VPS_HOST SUPABASE_DOMAIN USE_LETSENCRYPT LETSENCRYPT_EMAIL
    export SMTP_HOST SMTP_PORT SMTP_USER SMTP_PASSWORD SMTP_SENDER_NAME

    python3 "${PROJECT_ROOT}/lib/yaml-update.py" "$generated_file"

    log_success "Configuration built successfully"

    # Step 3: Backup current VPS config
    log_info "Backing up current VPS configuration..."
    local timestamp=$(date +%Y%m%d_%H%M%S)
    scp -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o LogLevel=ERROR \
        "${DEPLOY_USER}@${VPS_HOST}:~/pigsty/pigsty.yml" \
        "${backup_dir}/pigsty.yml.${timestamp}" 2>/dev/null || \
            log_warning "Could not backup VPS config (may not exist yet)"

    # Step 4: Upload to VPS
    log_info "Uploading configuration to VPS..."
    scp -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o LogLevel=ERROR \
        "$generated_file" \
        "${DEPLOY_USER}@${VPS_HOST}:~/pigsty/pigsty.yml"

    log_success "Configuration synced to VPS"

    echo ""
    log_info "Next steps:"
    echo "  - Review changes: ./scripts/deploy config:diff"
    echo "  - Apply changes: ./scripts/deploy apply"
}

config_diff() {
    log_step "Configuration Diff"

    load_env

    local local_file="${PROJECT_ROOT}/config/generated/pigsty.yml"
    local remote_file="/tmp/pigsty-remote-$$.yml"

    if [ ! -f "$local_file" ]; then
        log_error "Local config not found. Run: ./scripts/deploy config:sync"
        return 1
    fi

    log_info "Downloading VPS configuration..."
    scp -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o LogLevel=ERROR \
        "${DEPLOY_USER}@${VPS_HOST}:~/pigsty/pigsty.yml" \
        "$remote_file" 2>/dev/null || {
            log_error "Failed to download VPS config"
            return 1
        }

    echo ""
    log_info "Differences (local vs VPS):"
    echo ""

    diff -u "$remote_file" "$local_file" || true

    rm -f "$remote_file"
}

# Run based on subcommand
case "${1:-sync}" in
    pull)
        config_pull
        ;;
    sync|push)
        config_sync
        ;;
    diff)
        config_diff
        ;;
    *)
        log_error "Unknown command: $1"
        echo "Usage: $0 {pull|sync|diff}"
        exit 1
        ;;
esac
