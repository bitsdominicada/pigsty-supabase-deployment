#!/usr/bin/env bash
set -euo pipefail

# ============================================
# PIGSTY SUPABASE - DEPLOYMENT SCRIPT
# ============================================
# This script deploys Pigsty with Supabase to your VPS
# Run from your Mac: ./scripts/02-deploy-pigsty.sh
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found!${NC}"
    exit 1
fi

source .env

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Pigsty Supabase Deployment${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "Target VPS: ${YELLOW}${VPS_HOST}${NC}"
echo -e "Deploy User: ${YELLOW}${DEPLOY_USER}${NC}"
echo -e "PostgreSQL Version: ${YELLOW}${POSTGRES_VERSION}${NC}"
echo ""

# Check SSH connection
echo -e "${BLUE}[1/8] Verifying SSH connection...${NC}"
if ! ssh -i ~/.ssh/pigsty_deploy -o ConnectTimeout=5 ${DEPLOY_USER}@${VPS_HOST} "echo 'Connected'"; then
    echo -e "${RED}Cannot connect to VPS. Run ./scripts/01-prepare-vps.sh first${NC}"
    exit 1
fi

# Download Pigsty on remote server
echo -e "${BLUE}[2/8] Downloading Pigsty on remote server...${NC}"
ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << 'REMOTE_SCRIPT'
set -e
cd ~
if [ -d ~/pigsty ]; then
    echo "Pigsty directory already exists, backing up..."
    mv ~/pigsty ~/pigsty.backup.$(date +%Y%m%d_%H%M%S)
fi
curl -fsSL https://repo.pigsty.io/get | bash
echo "Pigsty downloaded to ~/pigsty"
REMOTE_SCRIPT

# Install Ansible dependencies
echo -e "${BLUE}[3/8] Installing Ansible on remote server...${NC}"
ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << 'REMOTE_SCRIPT'
set -e
cd ~/pigsty
./bootstrap
echo "Ansible installed successfully"
REMOTE_SCRIPT

# Generate and upload custom Pigsty configuration
echo -e "${BLUE}[4/8] Generating custom Pigsty configuration...${NC}"
./scripts/generate-pigsty-config.sh

# Upload configuration to remote server
echo -e "${BLUE}[5/8] Uploading configuration files...${NC}"
scp -i ~/.ssh/pigsty_deploy config/pigsty.yml ${DEPLOY_USER}@${VPS_HOST}:~/pigsty/pigsty.yml
scp -i ~/.ssh/pigsty_deploy config/supabase-env.yml ${DEPLOY_USER}@${VPS_HOST}:~/pigsty/

# Run Pigsty installation
echo -e "${BLUE}[6/8] Running Pigsty installation (this may take 10-20 minutes)...${NC}"
ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << 'REMOTE_SCRIPT'
set -e
cd ~/pigsty

echo "Starting Pigsty installation..."
./install.yml

echo "Pigsty core installation completed"
REMOTE_SCRIPT

# Install Docker and Docker Compose
echo -e "${BLUE}[7/8] Installing Docker for Supabase components...${NC}"
ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << 'REMOTE_SCRIPT'
set -e
cd ~/pigsty

echo "Installing Docker..."
./docker.yml

echo "Docker installed successfully"
REMOTE_SCRIPT

# Deploy Supabase components
echo -e "${BLUE}[8/8] Deploying Supabase components...${NC}"
ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << 'REMOTE_SCRIPT'
set -e
cd ~/pigsty

# Merge Supabase environment variables
if [ -f ~/pigsty/supabase-env.yml ]; then
    echo "Merging Supabase configuration..."
    cat ~/pigsty/supabase-env.yml >> ~/pigsty/pigsty.yml
fi

echo "Launching Supabase..."
./app.yml

echo "Supabase deployment completed"
REMOTE_SCRIPT

# Display access information
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Deployment Completed Successfully!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}Access Information:${NC}"
echo ""
echo -e "  Supabase Studio:"
echo -e "    URL: ${GREEN}http://${VPS_HOST}:8000${NC}"
echo -e "    User: ${GREEN}supabase${NC}"
echo -e "    Password: ${GREEN}pigsty${NC} (change this!)"
echo ""
echo -e "  Grafana (Monitoring):"
echo -e "    URL: ${GREEN}http://${VPS_HOST}${NC}"
echo -e "    User: ${GREEN}admin${NC}"
echo -e "    Password: ${GREEN}${GRAFANA_ADMIN_PASSWORD}${NC}"
echo ""
echo -e "  PostgreSQL (via pgbouncer):"
echo -e "    Host: ${GREEN}${VPS_HOST}:5436${NC}"
echo -e "    Database: ${GREEN}meta${NC}"
echo -e "    User: ${GREEN}supabase_admin${NC}"
echo -e "    Password: ${GREEN}${POSTGRES_PASSWORD}${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo -e "  1. Change default passwords"
echo -e "  2. Configure SSL/TLS certificates: ${GREEN}./scripts/setup-ssl.sh${NC}"
echo -e "  3. Test health check: ${GREEN}./scripts/health-check.sh${NC}"
echo -e "  4. Setup backups: ${GREEN}./scripts/setup-backup.sh${NC}"
echo ""
