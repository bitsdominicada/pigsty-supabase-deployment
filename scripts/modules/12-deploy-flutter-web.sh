#!/usr/bin/env bash

# ============================================
# MODULE: Deploy Flutter Web Application
# ============================================
# Builds and deploys Flutter Web app to the VPS
# Serves from Nginx alongside Supabase

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Flutter project configuration
FLUTTER_PROJECT="${FLUTTER_PROJECT_PATH:-/Users/andymelo/Projects/bits_flare_platform}"
FLUTTER_APP="${FLUTTER_APP_PATH:-apps/neura_core_app}"
FLUTTER_APP_NAME="${FLUTTER_APP_NAME:-neura}"

deploy_flutter_web() {
    log_step "Deploying Flutter Web Application"

    load_env

    # Validate Flutter project exists
    if [ ! -d "${FLUTTER_PROJECT}/${FLUTTER_APP}" ]; then
        log_error "Flutter project not found at ${FLUTTER_PROJECT}/${FLUTTER_APP}"
        return 1
    fi

    # Get Supabase credentials for the build
    local supabase_url="https://${SUPABASE_DOMAIN}"
    local supabase_anon_key="${ANON_KEY:-}"

    if [ -z "${supabase_anon_key}" ]; then
        log_error "ANON_KEY not found in .env"
        return 1
    fi

    log_info "Building Flutter Web for: ${supabase_url}"

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
    flutter build web --release \
        --dart-define=SUPABASE_URL="${supabase_url}" \
        --dart-define=SUPABASE_ANON_KEY="${supabase_anon_key}" \
        --dart-define=DEBUG_MODE=false \
        --base-href="/${FLUTTER_APP_NAME}/"

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
    ssh_exec "sudo mkdir -p /var/www/${FLUTTER_APP_NAME}"
    ssh_exec "sudo chown deploy:deploy /var/www/${FLUTTER_APP_NAME}"

    # Upload build files
    log_info "Uploading Flutter Web build to VPS..."
    rsync -avz --delete \
        -e "ssh -i ${ssh_key} -o StrictHostKeyChecking=no" \
        "${FLUTTER_PROJECT}/${FLUTTER_APP}/build/web/" \
        "deploy@${VPS_HOST}:/var/www/${FLUTTER_APP_NAME}/"

    log_success "Files uploaded successfully"

    # Configure Nginx
    log_info "Configuring Nginx..."
    configure_nginx

    log_success "Flutter Web deployed successfully!"
    echo ""
    log_info "Application URL: https://${SUPABASE_DOMAIN}/${FLUTTER_APP_NAME}/"
}

configure_nginx() {
    # Create Nginx configuration for Flutter app
    ssh_exec "sudo tee /etc/nginx/conf.d/${FLUTTER_APP_NAME}.conf > /dev/null << 'NGINX_EOF'
# Flutter Web App: ${FLUTTER_APP_NAME}
# Served alongside Supabase

location /${FLUTTER_APP_NAME} {
    alias /var/www/${FLUTTER_APP_NAME};
    index index.html;
    try_files \$uri \$uri/ /${FLUTTER_APP_NAME}/index.html;

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }

    # Don't cache index.html
    location = /${FLUTTER_APP_NAME}/index.html {
        expires -1;
        add_header Cache-Control \"no-store, no-cache, must-revalidate\";
    }
}
NGINX_EOF"

    # Check if we need to include this in the main config
    ssh_exec "
        # Check if main nginx config includes conf.d
        if ! grep -q 'include /etc/nginx/conf.d' /etc/nginx/nginx.conf 2>/dev/null; then
            # Add include directive if not present
            sudo sed -i '/http {/a\\    include /etc/nginx/conf.d/*.conf;' /etc/nginx/nginx.conf 2>/dev/null || true
        fi

        # Test and reload nginx
        sudo nginx -t && sudo systemctl reload nginx
    "

    log_success "Nginx configured for ${FLUTTER_APP_NAME}"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    deploy_flutter_web
fi
