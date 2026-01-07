#!/usr/bin/env bash

# ============================================
# MODULE: Configure Multi-Domain Architecture
# ============================================
# Creates nginx configs for:
#   - app (domain) -> Flutter Web static files
#   - api (api.domain) -> Supabase Kong (port 8000)
#   - studio (studio.domain) -> Supabase Studio (port 3001)
#   - grafana (grafana.domain) -> Grafana (port 3000)
#
# Note: Pigsty's infra_portal only creates supa.pigsty config,
# so we create the real domain configs here.

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
    local grafana_domain="grafana.${domain}"
    local vps_ip="${VPS_HOST}"

    log_info "Domain architecture:"
    echo "  Main App:   ${domain} -> Flutter Web (static files)"
    echo "  API:        ${api_domain} -> Supabase Kong (port 8000)"
    echo "  Studio:     ${studio_domain} -> Supabase Studio (port 3001)"
    echo "  Grafana:    ${grafana_domain} -> Grafana (port 3000)"
    echo ""

    # Create Flutter app directory
    log_info "Creating Flutter app directory..."
    ssh_exec "sudo mkdir -p /var/www/app && sudo chown -R \$(whoami):\$(whoami) /var/www/app"

    # Create placeholder index.html until Flutter is deployed
    ssh_exec "cat > /var/www/app/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>App - Loading...</title>
    <style>
        body { font-family: system-ui; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background: #1a1a2e; color: #fff; }
        .loader { text-align: center; }
        h1 { font-size: 2rem; margin-bottom: 1rem; }
        p { opacity: 0.7; }
    </style>
</head>
<body>
    <div class='loader'>
        <h1>App</h1>
        <p>La aplicación se está desplegando...</p>
    </div>
</body>
</html>
HTML"

    # Create self-signed certs for initial setup (certbot will replace)
    log_info "Creating initial SSL certificates..."
    ssh_exec "
        sudo mkdir -p /etc/nginx/conf.d/cert
        if [ ! -f /etc/nginx/conf.d/cert/${domain}.crt ]; then
            sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
                -keyout /etc/nginx/conf.d/cert/${domain}.key \
                -out /etc/nginx/conf.d/cert/${domain}.crt \
                -subj '/CN=${domain}' 2>/dev/null
        fi
    "

    # Create API config (Kong proxy)
    log_info "Creating API nginx config..."
    ssh_exec "sudo tee /etc/nginx/conf.d/api.conf > /dev/null << 'NGINX'
# API endpoint - Kong (port 8000)
upstream supabase_kong {
    server 127.0.0.1:8000 max_fails=0;
}

server {
    server_name ${api_domain};
    listen 80;

    location ^~ /.well-known/acme-challenge/ {
        root /www/acme;
        try_files \$uri =404;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    server_name ${api_domain};
    listen 443 ssl;

    ssl_certificate /etc/nginx/conf.d/cert/${domain}.crt;
    ssl_certificate_key /etc/nginx/conf.d/cert/${domain}.key;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/api.log;

    location / {
        proxy_pass http://supabase_kong/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
        proxy_read_timeout 86400;
        proxy_buffering off;
    }
}
NGINX"

    # Create Studio config (port 3000)
    log_info "Creating Studio nginx config..."
    ssh_exec "sudo tee /etc/nginx/conf.d/studio.conf > /dev/null << 'NGINX'
# Studio endpoint (port 3001 - Grafana uses 3000)
upstream supabase_studio {
    server 127.0.0.1:3001 max_fails=0;
}

server {
    server_name ${studio_domain};
    listen 80;

    location ^~ /.well-known/acme-challenge/ {
        root /www/acme;
        try_files \$uri =404;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    server_name ${studio_domain};
    listen 443 ssl;

    ssl_certificate /etc/nginx/conf.d/cert/${domain}.crt;
    ssl_certificate_key /etc/nginx/conf.d/cert/${domain}.key;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/studio.log;

    location / {
        proxy_pass http://supabase_studio/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
        proxy_read_timeout 86400;
        proxy_buffering off;
    }
}
NGINX"

    # Create Grafana config (port 3000)
    log_info "Creating Grafana nginx config..."
    ssh_exec "sudo tee /etc/nginx/conf.d/grafana-public.conf > /dev/null << 'NGINX'
# Grafana endpoint (port 3000)
upstream grafana_public {
    server 127.0.0.1:3000 max_fails=0;
}

server {
    server_name ${grafana_domain};
    listen 80;

    location ^~ /.well-known/acme-challenge/ {
        root /www/acme;
        try_files \$uri =404;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    server_name ${grafana_domain};
    listen 443 ssl;

    ssl_certificate /etc/nginx/conf.d/cert/${domain}.crt;
    ssl_certificate_key /etc/nginx/conf.d/cert/${domain}.key;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/grafana-public.log;

    location / {
        proxy_pass http://grafana_public/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
        proxy_read_timeout 86400;
        proxy_buffering off;
    }
}
NGINX"

    # Create main app config (Flutter static files)
    log_info "Creating App nginx config..."
    ssh_exec "sudo tee /etc/nginx/conf.d/app.conf > /dev/null << 'NGINX'
# Main domain -> Flutter Web App

server {
    server_name ${domain};
    listen 80;

    location ^~ /.well-known/acme-challenge/ {
        root /www/acme;
        try_files \$uri =404;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    server_name ${domain};
    listen 443 ssl http2;

    ssl_certificate /etc/nginx/conf.d/cert/${domain}.crt;
    ssl_certificate_key /etc/nginx/conf.d/cert/${domain}.key;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
    ssl_prefer_server_ciphers on;

    root /var/www/app;
    index index.html;

    access_log /var/log/nginx/app.log;

    # Flutter Web SPA routing
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|json|wasm)$ {
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
NGINX"

    # Test and reload Nginx
    log_info "Testing Nginx configuration..."
    if ssh_exec "sudo nginx -t" 2>&1; then
        log_info "Reloading Nginx..."
        ssh_exec "sudo systemctl reload nginx"
        log_success "Nginx configured successfully"
    else
        log_error "Nginx config test failed"
        ssh_exec "sudo nginx -t 2>&1" || true
        return 1
    fi

    # Configure SSL with Certbot if enabled
    if [ "${USE_LETSENCRYPT:-false}" = "true" ]; then
        configure_ssl "${domain}" "${api_domain}" "${studio_domain}" "${grafana_domain}"
    fi

    log_success "Multi-domain configuration complete!"
    echo ""
    log_info "URLs:"
    if [ "${USE_LETSENCRYPT:-false}" = "true" ]; then
        echo "  App:     https://${domain}"
        echo "  API:     https://${api_domain}"
        echo "  Studio:  https://${studio_domain}"
        echo "  Grafana: https://${grafana_domain}"
    else
        echo "  App:     http://${domain}"
        echo "  API:     http://${api_domain}"
        echo "  Studio:  http://${studio_domain}"
        echo "  Grafana: http://${grafana_domain}"
    fi
}

configure_ssl() {
    local domain="$1"
    local api_domain="$2"
    local studio_domain="$3"
    local grafana_domain="$4"
    local email="${LETSENCRYPT_EMAIL:-}"

    log_step "Configuring SSL Certificates"

    if [ -z "${email}" ]; then
        log_warning "LETSENCRYPT_EMAIL not set, skipping SSL"
        return 0
    fi

    log_info "Obtaining SSL certificates for all domains..."
    log_info "Domains: ${domain}, ${api_domain}, ${studio_domain}, ${grafana_domain}"

    # Ensure acme challenge directory exists
    ssh_exec "sudo mkdir -p /www/acme/.well-known/acme-challenge"

    # Check which domains have DNS configured
    local domains_to_cert="${domain}"
    for d in ${api_domain} ${studio_domain} ${grafana_domain}; do
        if ssh_exec "host ${d} >/dev/null 2>&1"; then
            domains_to_cert="${domains_to_cert} -d ${d}"
            log_info "  ✓ DNS OK: ${d}"
        else
            log_warning "  ✗ DNS not configured: ${d} (skipping)"
        fi
    done

    # Request certificates using webroot method (works with our custom nginx configs)
    ssh_exec "sudo certbot certonly --webroot \
        -w /www/acme \
        -d ${domains_to_cert} \
        --email ${email} \
        --agree-tos \
        --no-eff-email \
        --non-interactive" || {
        log_warning "Certbot failed. Make sure DNS is configured for all domains."
        log_info "You can run certbot manually later:"
        echo "  sudo certbot certonly --webroot -w /www/acme -d ${domain} -d ${api_domain} -d ${studio_domain} -d ${grafana_domain}"
        return 0
    }

    # Update nginx configs to use Let's Encrypt certificates
    log_info "Updating nginx configs with Let's Encrypt certificates..."
    ssh_exec "
        CERT_PATH='/etc/letsencrypt/live/${domain}'

        # Update all configs to use LE certs
        for conf in api.conf studio.conf app.conf grafana-public.conf; do
            if [ -f /etc/nginx/conf.d/\${conf} ]; then
                sudo sed -i \"s|ssl_certificate /etc/nginx/conf.d/cert/${domain}.crt;|ssl_certificate \${CERT_PATH}/fullchain.pem;|g\" /etc/nginx/conf.d/\${conf}
                sudo sed -i \"s|ssl_certificate_key /etc/nginx/conf.d/cert/${domain}.key;|ssl_certificate_key \${CERT_PATH}/privkey.pem;|g\" /etc/nginx/conf.d/\${conf}
            fi
        done

        # Test and reload
        sudo nginx -t && sudo systemctl reload nginx
    "

    # Setup auto-renewal with nginx reload
    log_info "Setting up certificate auto-renewal..."
    ssh_exec "
        # Create renewal hook to reload nginx
        sudo mkdir -p /etc/letsencrypt/renewal-hooks/deploy
        echo '#!/bin/bash
systemctl reload nginx' | sudo tee /etc/letsencrypt/renewal-hooks/deploy/reload-nginx.sh
        sudo chmod +x /etc/letsencrypt/renewal-hooks/deploy/reload-nginx.sh

        # Enable certbot timer
        sudo systemctl enable certbot.timer 2>/dev/null || true
        sudo systemctl start certbot.timer 2>/dev/null || true
    "

    log_success "SSL certificates installed!"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    configure_domains
fi
