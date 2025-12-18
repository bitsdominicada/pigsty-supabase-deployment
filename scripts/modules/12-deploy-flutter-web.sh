#!/usr/bin/env bash

# ============================================
# MODULE: Deploy Flutter Web Application
# ============================================
# Builds and deploys Flutter Web app to the VPS
# Serves from main domain (configured by 13-configure-domains.sh)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Flutter project configuration
FLUTTER_PROJECT="${FLUTTER_PROJECT_PATH:-/Users/andymelo/Projects/bits_flare_platform}"
FLUTTER_APP="${FLUTTER_APP_PATH:-apps/neura_core_app}"

deploy_flutter_web() {
    log_step "Deploying Flutter Web Application"

    load_env

    # Validate Flutter project exists
    if [ ! -d "${FLUTTER_PROJECT}/${FLUTTER_APP}" ]; then
        log_error "Flutter project not found at ${FLUTTER_PROJECT}/${FLUTTER_APP}"
        return 1
    fi

    # Get Supabase credentials for the build
    # API is now on api.domain subdomain
    local supabase_url="https://api.${SUPABASE_DOMAIN}"
    local supabase_anon_key="${ANON_KEY:-}"

    if [ -z "${supabase_anon_key}" ]; then
        log_error "ANON_KEY not found in .env"
        return 1
    fi

    log_info "Building Flutter Web for:"
    echo "  API URL: ${supabase_url}"
    echo "  App URL: https://${SUPABASE_DOMAIN}"
    echo ""

    # Build Flutter Web
    log_info "Building Flutter Web application..."
    cd "${FLUTTER_PROJECT}"

    # Get dependencies for workspace
    flutter pub get

    cd "${FLUTTER_PROJECT}/${FLUTTER_APP}"

    # Clean previous build
    flutter clean
    flutter pub get

    # Build for web with production settings
    # No base-href needed since app is served from root
    flutter build web --release \
        --dart-define=SUPABASE_URL="${supabase_url}" \
        --dart-define=SUPABASE_ANON_KEY="${supabase_anon_key}" \
        --dart-define=DEBUG_MODE=false

    log_success "Flutter Web build completed"

    # Detect SSH key
    local ssh_key=""
    if [ -n "${SSH_KEY_PATH:-}" ] && [ -f "${SSH_KEY_PATH}" ]; then
        ssh_key="${SSH_KEY_PATH}"
    elif [ -f "$HOME/.ssh/id_ed25519" ]; then
        ssh_key="$HOME/.ssh/id_ed25519"
    elif [ -f "$HOME/.ssh/id_rsa" ]; then
        ssh_key="$HOME/.ssh/id_rsa"
    fi

    # Create app directory on VPS
    log_info "Preparing VPS for deployment..."
    ssh_exec "sudo mkdir -p /var/www/app && sudo chown deploy:deploy /var/www/app"

    # Upload build files
    log_info "Uploading Flutter Web build to VPS..."
    rsync -avz --delete \
        -e "ssh -i ${ssh_key} -o StrictHostKeyChecking=no" \
        "${FLUTTER_PROJECT}/${FLUTTER_APP}/build/web/" \
        "deploy@${VPS_HOST}:/var/www/app/"

    log_success "Flutter Web deployed successfully!"
    echo ""
    log_info "Application URL: https://${SUPABASE_DOMAIN}"
    log_info "API URL: https://api.${SUPABASE_DOMAIN}"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    deploy_flutter_web
fi
