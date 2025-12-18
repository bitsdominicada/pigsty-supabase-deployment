#!/usr/bin/env bash

# ============================================
# MODULE: Configure Multi-Domain Architecture
# ============================================
# Configures Nginx for:
#   - Main domain -> Flutter Web App (static files)
#   - api.domain -> Supabase API (Kong)
#   - studio.domain -> Supabase Studio
# And obtains SSL certificates for all domains

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

configure_domains() {
    log_step "Configuring Multi-Domain Architecture"

    load_env

    local domain="${SUPABASE_DOMAIN}"
    local api_domain="api.${domain}"
    local studio_domain="studio.${domain}"
    local vps_ip="${VPS_HOST}"

    log_info "Domain architecture:"
    echo "  Main App:   ${domain} -> Flutter Web"
    echo "  API:        ${api_domain} -> Supabase Kong (port 8000)"
    echo "  Studio:     ${studio_domain} -> Supabase Studio (port 3000)"
    echo ""

    # Create Flutter app directory
    log_info "Creating Flutter app directory..."
    ssh_exec "sudo mkdir -p /var/www/app && sudo chown deploy:deploy /var/www/app"

    # Create placeholder index.html until Flutter is deployed
    ssh_exec "cat > /var/www/app/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Neura Core - Loading...</title>
    <style>
        body { font-family: system-ui; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background: #1a1a2e; color: #fff; }
        .loader { text-align: center; }
        h1 { font-size: 2rem; margin-bottom: 1rem; }
        p { opacity: 0.7; }
    </style>
</head>
<body>
    <div class='loader'>
        <h1>Neura Core</h1>
        <p>La aplicación se está desplegando...</p>
    </div>
</body>
</html>
HTML"

    # Configure Nginx with all domains
    log_info "Configuring Nginx for multi-domain setup..."

    ssh_exec "sudo tee /etc/nginx/conf.d/app-domains.conf > /dev/null << 'NGINX'
# =====================================================
# Multi-Domain Configuration for Supabase + Flutter
# =====================================================

# Main domain -> Flutter Web App
server {
    listen 80;
    server_name ${domain};

    root /var/www/app;
    index index.html;

    # Flutter Web SPA routing
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|json)$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }

    # Don't cache index.html and main.dart.js
    location ~* (index\.html|main\.dart\.js)$ {
        expires -1;
        add_header Cache-Control \"no-store, no-cache, must-revalidate\";
    }

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript application/wasm;
}

# API subdomain -> Supabase Kong
server {
    listen 80;
    server_name ${api_domain};

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # WebSocket support for Realtime
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";

        # Timeouts for long-running requests
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;

        # Large file uploads
        client_max_body_size 100M;
    }
}

# Studio subdomain -> Supabase Studio
server {
    listen 80;
    server_name ${studio_domain};

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # WebSocket support
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
    }
}
NGINX"

    # Test and reload Nginx
    log_info "Testing Nginx configuration..."
    ssh_exec "sudo nginx -t"

    log_info "Reloading Nginx..."
    ssh_exec "sudo systemctl reload nginx"

    log_success "Nginx configured for all domains"

    # Configure SSL with Certbot if enabled
    if [ "${USE_LETSENCRYPT:-false}" = "true" ]; then
        configure_ssl "${domain}" "${api_domain}" "${studio_domain}"
    fi

    log_success "Multi-domain configuration complete!"
    echo ""
    log_info "URLs:"
    if [ "${USE_LETSENCRYPT:-false}" = "true" ]; then
        echo "  App:     https://${domain}"
        echo "  API:     https://${api_domain}"
        echo "  Studio:  https://${studio_domain}"
    else
        echo "  App:     http://${domain}"
        echo "  API:     http://${api_domain}"
        echo "  Studio:  http://${studio_domain}"
    fi
}

configure_ssl() {
    local domain="$1"
    local api_domain="$2"
    local studio_domain="$3"
    local email="${LETSENCRYPT_EMAIL:-}"

    log_step "Configuring SSL Certificates"

    if [ -z "${email}" ]; then
        log_warning "LETSENCRYPT_EMAIL not set, skipping SSL"
        return 0
    fi

    log_info "Obtaining SSL certificates for all domains..."
    log_info "Domains: ${domain}, ${api_domain}, ${studio_domain}"

    # Request certificates for all domains at once
    ssh_exec "sudo certbot --nginx \
        -d ${domain} \
        -d ${api_domain} \
        -d ${studio_domain} \
        --email ${email} \
        --agree-tos \
        --no-eff-email \
        --non-interactive \
        --redirect" || {
        log_warning "Certbot failed. Make sure DNS is configured for all domains."
        log_info "You can run certbot manually later:"
        echo "  sudo certbot --nginx -d ${domain} -d ${api_domain} -d ${studio_domain}"
        return 0
    }

    # Setup auto-renewal
    log_info "Setting up certificate auto-renewal..."
    ssh_exec "sudo systemctl enable certbot.timer 2>/dev/null || true"
    ssh_exec "sudo systemctl start certbot.timer 2>/dev/null || true"

    log_success "SSL certificates installed!"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    configure_domains
fi
