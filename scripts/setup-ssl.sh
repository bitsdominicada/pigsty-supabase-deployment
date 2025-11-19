#!/usr/bin/env bash
set -euo pipefail

# ============================================
# SETUP SSL/TLS CERTIFICATES
# ============================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found!${NC}"
    exit 1
fi

source .env

echo -e "${GREEN}SSL/TLS Certificate Setup${NC}"
echo ""

if [ "${USE_LETSENCRYPT}" != "true" ]; then
    echo -e "${YELLOW}Let's Encrypt is disabled in .env${NC}"
    echo "To enable: Set USE_LETSENCRYPT=true and configure LETSENCRYPT_EMAIL"
    echo ""
    echo "Using self-signed certificates for development..."
    
    ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << 'REMOTE_SCRIPT'
set -e
cd ~/pigsty
make cert-self
echo "Self-signed certificates generated"
REMOTE_SCRIPT
    
    echo -e "${GREEN}Self-signed certificates created${NC}"
    exit 0
fi

# Let's Encrypt setup
echo -e "Domain: ${YELLOW}${SUPABASE_DOMAIN}${NC}"
echo -e "Email: ${YELLOW}${LETSENCRYPT_EMAIL}${NC}"
echo ""

ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << REMOTE_SCRIPT
set -e

# Install certbot
if ! command -v certbot &> /dev/null; then
    echo "Installing certbot..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y certbot python3-certbot-nginx
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y certbot python3-certbot-nginx
    fi
fi

# Request certificate
echo "Requesting Let's Encrypt certificate..."
sudo certbot --nginx -d ${SUPABASE_DOMAIN} \
    --non-interactive \
    --agree-tos \
    --email ${LETSENCRYPT_EMAIL} \
    --redirect

# Setup auto-renewal
echo "Setting up auto-renewal..."
(sudo crontab -l 2>/dev/null || true; echo "0 3 * * * certbot renew --quiet --post-hook 'systemctl reload nginx'") | sudo crontab -

echo "SSL/TLS setup completed"
REMOTE_SCRIPT

echo -e "${GREEN}Let's Encrypt certificates configured!${NC}"
echo -e "Certificate will auto-renew via cron"
