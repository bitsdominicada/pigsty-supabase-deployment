#!/usr/bin/env bash
set -euo pipefail

# ============================================
# PIGSTY SUPABASE - VPS PREPARATION SCRIPT
# ============================================
# This script prepares a fresh VPS (Contabo) for Pigsty deployment
# Run from your Mac: ./scripts/01-prepare-vps.sh
# ============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Load environment variables
if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found!${NC}"
    echo "Please copy .env.example to .env and configure it first."
    exit 1
fi

source .env

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Pigsty Supabase VPS Preparation${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "VPS Host: ${YELLOW}${VPS_HOST}${NC}"
echo -e "Deploy User: ${YELLOW}${DEPLOY_USER}${NC}"
echo ""

# Check if sshpass is installed (needed for initial root password auth)
if ! command -v sshpass &> /dev/null; then
    echo -e "${YELLOW}Installing sshpass for password authentication...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install hudochenkov/sshpass/sshpass
    else
        echo -e "${RED}Please install sshpass manually${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}[1/6] Testing root SSH connection...${NC}"
sshpass -p "${VPS_ROOT_PASSWORD}" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    root@${VPS_HOST} "echo 'Connection successful'"

echo -e "${GREEN}[2/6] Creating deploy user...${NC}"
sshpass -p "${VPS_ROOT_PASSWORD}" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    root@${VPS_HOST} << REMOTE_SCRIPT
set -e

# Create deploy user if doesn't exist
if ! id -u ${DEPLOY_USER} > /dev/null 2>&1; then
    useradd -m -s /bin/bash ${DEPLOY_USER}
    echo "${DEPLOY_USER}:${DEPLOY_USER_PASSWORD}" | chpasswd
    echo "User ${DEPLOY_USER} created"
else
    echo "User ${DEPLOY_USER} already exists"
fi

# Add to sudo group
usermod -aG sudo ${DEPLOY_USER} || usermod -aG wheel ${DEPLOY_USER}

# Configure passwordless sudo
echo "${DEPLOY_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${DEPLOY_USER}
chmod 0440 /etc/sudoers.d/${DEPLOY_USER}

echo "Sudo configured for ${DEPLOY_USER}"
REMOTE_SCRIPT

echo -e "${GREEN}[3/6] Setting up SSH key authentication...${NC}"

# Generate SSH key if not exists
if [ ! -f ~/.ssh/pigsty_deploy ]; then
    ssh-keygen -t ed25519 -f ~/.ssh/pigsty_deploy -N "" -C "pigsty-deploy-${DEPLOY_USER}"
    echo -e "${YELLOW}New SSH key generated: ~/.ssh/pigsty_deploy${NC}"
fi

# Copy SSH key to deploy user
sshpass -p "${VPS_ROOT_PASSWORD}" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    root@${VPS_HOST} << REMOTE_SCRIPT
set -e
mkdir -p /home/${DEPLOY_USER}/.ssh
chmod 700 /home/${DEPLOY_USER}/.ssh
cat >> /home/${DEPLOY_USER}/.ssh/authorized_keys << 'SSHKEY'
$(cat ~/.ssh/pigsty_deploy.pub)
SSHKEY
chmod 600 /home/${DEPLOY_USER}/.ssh/authorized_keys
chown -R ${DEPLOY_USER}:${DEPLOY_USER} /home/${DEPLOY_USER}/.ssh
echo "SSH key installed for ${DEPLOY_USER}"
REMOTE_SCRIPT

echo -e "${GREEN}[4/6] Testing SSH key authentication...${NC}"
ssh -i ~/.ssh/pigsty_deploy -o StrictHostKeyChecking=no ${DEPLOY_USER}@${VPS_HOST} "echo 'SSH key authentication successful'"

echo -e "${GREEN}[5/6] Updating system and installing dependencies...${NC}"
ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << 'REMOTE_SCRIPT'
set -e
sudo apt-get update -qq || sudo dnf check-update -q || true

# Detect OS and install dependencies
if command -v apt-get &> /dev/null; then
    # Debian/Ubuntu
    sudo apt-get install -y curl wget git vim htop net-tools python3 python3-pip
elif command -v dnf &> /dev/null; then
    # Rocky/RHEL
    sudo dnf install -y curl wget git vim htop net-tools python3 python3-pip
fi

echo "System updated and dependencies installed"
REMOTE_SCRIPT

echo -e "${GREEN}[6/6] Creating Ansible inventory...${NC}"
cat > ansible/inventory/hosts.ini << INV_EOF
[pigsty]
${VPS_HOST} ansible_user=${DEPLOY_USER} ansible_ssh_private_key_file=~/.ssh/pigsty_deploy

[pigsty:vars]
ansible_python_interpreter=/usr/bin/python3
INV_EOF

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  VPS Preparation Complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. Test connection: ${YELLOW}ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST}${NC}"
echo -e "  2. Run deployment: ${YELLOW}./scripts/02-deploy-pigsty.sh${NC}"
echo ""
echo -e "SSH Config added to: ${YELLOW}ansible/inventory/hosts.ini${NC}"
echo ""
