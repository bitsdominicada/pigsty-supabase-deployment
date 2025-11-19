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

    # Step 1: Build merged configuration
    log_info "Building configuration from layers..."

    local base_file="${config_dir}/templates/base.yml"
    local common_file="${config_dir}/templates/overrides/common.yml"
    local env_file="${config_dir}/templates/overrides/production.yml"  # TODO: Make dynamic

    # Check if base exists
    if [ ! -f "$base_file" ]; then
        log_warning "Base template not found, downloading from VPS..."
        config_pull
    fi

    # Simple merge (will use yq if available)
    source "${PROJECT_ROOT}/lib/yaml-merge.sh"

    local temp_merged="/tmp/pigsty-merged-$$.yml"

    # Merge: base + common + environment + modules
    local files_to_merge=(
        "$base_file"
    )

    [ -f "$common_file" ] && files_to_merge+=("$common_file")
    [ -f "$env_file" ] && files_to_merge+=("$env_file")

    # Add module overrides
    for module_file in "${config_dir}"/templates/overrides/modules/*.yml; do
        [ -f "$module_file" ] && files_to_merge+=("$module_file")
    done

    log_info "Merging ${#files_to_merge[@]} configuration files..."
    merge_yaml "$temp_merged" "${files_to_merge[@]}"

    # Step 2: Apply credentials and SSL configuration from .env
    log_info "Applying credentials from .env..."

    # Use sed to replace placeholders (simple approach for Phase 1)
    sed -e "s/grafana_admin_password: .*/grafana_admin_password: ${GRAFANA_ADMIN_PASSWORD}/" \
        -e "s/pg_admin_password: .*/pg_admin_password: ${PG_ADMIN_PASSWORD}/" \
        -e "s/minio_secret_key: .*/minio_secret_key: ${MINIO_ROOT_PASSWORD}/" \
        "$temp_merged" > "$generated_file"

    # Inject SSL domain configuration if enabled
    if [ "${USE_LETSENCRYPT:-false}" = "true" ] && [ -n "${SUPABASE_DOMAIN:-}" ]; then
        log_info "Configuring SSL domain: ${SUPABASE_DOMAIN}"

        # Add certbot email to config
        if ! grep -q "certbot_email:" "$generated_file"; then
            sed -i.bak "/^all:/a\\
certbot_email: ${LETSENCRYPT_EMAIL}
" "$generated_file"
            rm -f "${generated_file}.bak"
        fi

        # Update infra_portal with SSL domain
        if grep -q "infra_portal:" "$generated_file"; then
            # Add supa entry with SSL domain to infra_portal
            sed -i.bak "/infra_portal:/a\\
  supa: { domain: ${SUPABASE_DOMAIN}, endpoint: \"${VPS_HOST}:8000\", websocket: true, certbot: ${SUPABASE_DOMAIN} }
" "$generated_file"
            rm -f "${generated_file}.bak"
        fi

        # Update Supabase URLs to use HTTPS
        if grep -q "app_supabase:" "$generated_file"; then
            # Inject HTTPS URLs
            sed -i.bak "/app_supabase:/a\\
  SITE_URL: \"https://${SUPABASE_DOMAIN}\"\\
  API_EXTERNAL_URL: \"https://${SUPABASE_DOMAIN}\"\\
  SUPABASE_PUBLIC_URL: \"https://${SUPABASE_DOMAIN}\"
" "$generated_file"
            rm -f "${generated_file}.bak"
        fi
    fi

    # Add Supabase credentials if not present
    if ! grep -q "JWT_SECRET:" "$generated_file"; then
        log_info "Adding Supabase credentials..."
        cat >> "$generated_file" << SUPACREDS

# Supabase Credentials (from .env)
app_supabase:
  JWT_SECRET: "${JWT_SECRET}"
  ANON_KEY: "${ANON_KEY}"
  SERVICE_ROLE_KEY: "${SERVICE_ROLE_KEY}"
  POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
  S3_ACCESS_KEY: "${MINIO_ROOT_USER}"
  S3_SECRET_KEY: "${MINIO_ROOT_PASSWORD}"
SUPACREDS

        # Add SMTP if configured
        if [ -n "${SMTP_HOST:-}" ]; then
            cat >> "$generated_file" << SMTP
  SMTP_HOST: "${SMTP_HOST}"
  SMTP_PORT: "${SMTP_PORT:-587}"
  SMTP_USER: "${SMTP_USER:-}"
  SMTP_PASS: "${SMTP_PASSWORD:-}"
  SMTP_SENDER_NAME: "${SMTP_SENDER_NAME:-Supabase}"
SMTP
        fi
    fi

    rm -f "$temp_merged"

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
