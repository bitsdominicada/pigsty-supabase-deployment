#!/usr/bin/env bash

# ============================================
# MODULE: SSL/TLS Setup with Let's Encrypt
# ============================================
# Uses Pigsty's built-in certbot for HTTPS certificates

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

ssl_setup() {
    log_step "SSL/TLS Setup with Let's Encrypt"

    load_env

    # Validate domain configuration
    if [ -z "${SUPABASE_DOMAIN:-}" ]; then
        log_error "SUPABASE_DOMAIN not set in .env"
        echo ""
        echo "Please configure SSL in your .env file:"
        echo ""
        echo "  SUPABASE_DOMAIN=bitsflaredb.bits.do"
        echo "  LETSENCRYPT_EMAIL=your@email.com"
        echo "  USE_LETSENCRYPT=true"
        echo ""
        exit 1
    fi

    if [ "${USE_LETSENCRYPT:-false}" != "true" ]; then
        log_error "USE_LETSENCRYPT is not enabled in .env"
        exit 1
    fi

    log_info "Domain: ${SUPABASE_DOMAIN}"
    log_info "Email: ${LETSENCRYPT_EMAIL}"
    echo ""

    # Check DNS resolution
    log_info "Checking DNS resolution..."
    if ! host "${SUPABASE_DOMAIN}" >/dev/null 2>&1; then
        log_error "DNS resolution failed for ${SUPABASE_DOMAIN}"
        echo ""
        echo "Please ensure your domain DNS points to: ${VPS_HOST}"
        echo ""
        exit 1
    fi

    local resolved_ip=$(host "${SUPABASE_DOMAIN}" | grep "has address" | head -1 | awk '{print $4}')
    log_info "Domain resolves to: ${resolved_ip}"

    if [ "${resolved_ip}" != "${VPS_HOST}" ]; then
        log_warning "Domain resolves to ${resolved_ip} but VPS is ${VPS_HOST}"
        echo ""
        read -p "Continue anyway? (y/N): " confirm
        if [ "$confirm" != "y" ]; then
            exit 1
        fi
    else
        log_success "DNS correctly configured"
    fi

    echo ""
    log_info "This will:"
    echo "  1. Update pigsty.yml with SSL domain configuration"
    echo "  2. Sync configuration to VPS"
    echo "  3. Request Let's Encrypt certificate via certbot"
    echo "  4. Update Supabase URLs to use HTTPS"
    echo "  5. Restart Supabase with new configuration"
    echo ""
    read -p "Continue? (y/N): " confirm
    if [ "$confirm" != "y" ]; then
        log_info "Cancelled"
        exit 0
    fi

    # Step 1: Sync configuration with SSL domain
    log_step "Updating configuration with SSL domain"

    # The config:sync command will now inject the SSL domain from .env
    "${SCRIPT_DIR}/modules/05-config-sync.sh" sync

    log_success "Configuration synced"

    # Step 2: Apply infra configuration to update nginx
    log_step "Applying infrastructure configuration"

    ssh_exec << 'REMOTE'
set -e
cd ~/pigsty
./infra.yml -t nginx_config,nginx_restart
REMOTE

    log_success "Nginx configuration updated"

    # Step 3: Request certificate using Pigsty's certbot
    log_step "Requesting Let's Encrypt certificate"

    ssh_exec << REMOTE
set -e

# Check if certificate already exists
if sudo certbot certificates 2>/dev/null | grep -q "${SUPABASE_DOMAIN}"; then
    echo "Certificate for ${SUPABASE_DOMAIN} already exists"
else
    echo "Requesting certificate for ${SUPABASE_DOMAIN}..."
    sudo certbot certonly \
        --webroot \
        --webroot-path /www/acme \
        --non-interactive \
        --agree-tos \
        --email ${LETSENCRYPT_EMAIL} \
        -d ${SUPABASE_DOMAIN}

    echo ""
    echo "Certificate installed successfully!"
fi
REMOTE

    log_success "SSL certificate obtained"

    # Step 4: Configure nginx to use Let's Encrypt certificates
    log_step "Configuring nginx with Let's Encrypt certificates"

    ssh_exec << REMOTE
set -e

# Update nginx config to use Let's Encrypt certificates
echo "Updating nginx configuration to use Let's Encrypt..."
sudo sed -i 's|ssl_certificate     /etc/nginx/conf.d/cert/${SUPABASE_DOMAIN}.crt;|ssl_certificate     /etc/letsencrypt/live/${SUPABASE_DOMAIN}/fullchain.pem;|' /etc/nginx/conf.d/supa.conf

sudo sed -i 's|ssl_certificate_key /etc/nginx/conf.d/cert/${SUPABASE_DOMAIN}.key;|ssl_certificate_key /etc/letsencrypt/live/${SUPABASE_DOMAIN}/privkey.pem;|' /etc/nginx/conf.d/supa.conf

# Test nginx configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx

echo "✓ Nginx configured with Let's Encrypt certificates"
REMOTE

    log_success "Nginx configured with SSL certificates"

    # Step 5: Update Supabase .env and restart containers
    log_step "Updating Supabase with HTTPS URLs"

    ssh_exec << REMOTE
set -e
cd /opt/supabase

# Update Supabase .env with correct HTTPS URLs
sudo sed -i 's|SITE_URL=.*|SITE_URL=https://${SUPABASE_DOMAIN}|' .env
sudo sed -i 's|API_EXTERNAL_URL=.*|API_EXTERNAL_URL=https://${SUPABASE_DOMAIN}|' .env
sudo sed -i 's|SUPABASE_PUBLIC_URL=.*|SUPABASE_PUBLIC_URL=https://${SUPABASE_DOMAIN}|' .env

# Restart Supabase containers
echo "Restarting Supabase containers..."
sudo docker compose down
sleep 3
sudo docker compose up -d

echo "✓ Supabase restarted with HTTPS URLs"
REMOTE

    log_success "Supabase configured with HTTPS"

    echo ""
    log_step "SSL Setup Complete!"
    echo ""
    echo -e "${GREEN}✓ Your Supabase instance is now available at:${NC}"
    echo -e "  ${BLUE}https://${SUPABASE_DOMAIN}${NC}"
    echo ""
    echo -e "${GREEN}Certificate details:${NC}"
    echo -e "  Issuer: Let's Encrypt"
    echo -e "  Validity: 90 days"
    echo -e "  Auto-renewal: Enabled (certbot systemd timer)"
    echo ""
    echo -e "${GREEN}Next steps:${NC}"
    echo -e "  • Update your Supabase client configuration to use HTTPS URL"
    echo -e "  • Test certificate renewal: ${CYAN}./scripts/deploy ssl:renew --dry-run${NC}"
    echo ""
}

ssl_status() {
    log_step "SSL Certificate Status"

    load_env

    if [ -z "${SUPABASE_DOMAIN:-}" ]; then
        log_error "SUPABASE_DOMAIN not configured in .env"
        exit 1
    fi

    log_info "Checking certificate for: ${SUPABASE_DOMAIN}"
    echo ""

    ssh_exec << REMOTE
# Check certificate status
sudo certbot certificates -d ${SUPABASE_DOMAIN} 2>/dev/null || {
    echo "No certificate found for ${SUPABASE_DOMAIN}"
    exit 1
}

echo ""
echo "Renewal timer status:"
sudo systemctl status certbot.timer --no-pager -l || true
REMOTE
}

ssl_renew() {
    log_step "Renew SSL Certificate"

    load_env

    local dry_run="${1:-}"

    if [ "$dry_run" = "--dry-run" ]; then
        log_info "Testing certificate renewal (dry-run)..."
        echo ""

        ssh_exec << 'REMOTE'
sudo certbot renew --dry-run
REMOTE

        echo ""
        log_success "Renewal test successful"
        echo ""
        echo "To force actual renewal, run:"
        echo "  ./scripts/deploy ssl:renew"
    else
        log_warning "This will force certificate renewal"
        echo ""
        read -p "Continue? (y/N): " confirm
        if [ "$confirm" != "y" ]; then
            log_info "Cancelled"
            exit 0
        fi

        log_info "Renewing certificate..."

        ssh_exec << 'REMOTE'
sudo certbot renew --force-renewal
sudo systemctl reload nginx
REMOTE

        log_success "Certificate renewed and nginx reloaded"
    fi
}

# Run based on subcommand
case "${1:-setup}" in
    setup)
        ssl_setup
        ;;
    status)
        ssl_status
        ;;
    renew)
        ssl_renew "${2:-}"
        ;;
    *)
        echo "Usage: $0 {setup|status|renew [--dry-run]}"
        exit 1
        ;;
esac
