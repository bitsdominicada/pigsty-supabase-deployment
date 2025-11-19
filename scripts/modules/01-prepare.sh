#!/usr/bin/env bash

# ============================================
# MODULE: VPS Preparation
# ============================================
# Sets up VPS: user, SSH keys, dependencies

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

prepare_vps() {
    log_step "VPS Preparation"

    load_env
    ensure_sshpass

    log_info "Target: ${VPS_HOST}"
    log_info "Deploy user: ${DEPLOY_USER}"

    # Test root connection
    log_info "Testing root SSH connection..."
    if ! ssh_root "echo 'Root access verified'" &>/dev/null; then
        log_error "Cannot connect as root. Check VPS_HOST and VPS_ROOT_PASSWORD"
        exit 1
    fi
    log_success "Root access verified"

    # Create deploy user
    log_info "Creating deploy user..."
    ssh_root << SETUP
set -e

# Create user if doesn't exist
if ! id -u ${DEPLOY_USER} &>/dev/null; then
    useradd -m -s /bin/bash ${DEPLOY_USER}
    echo "${DEPLOY_USER}:${DEPLOY_USER_PASSWORD}" | chpasswd
fi

# Add to sudo group
usermod -aG sudo ${DEPLOY_USER} 2>/dev/null || usermod -aG wheel ${DEPLOY_USER} 2>/dev/null || true

# Passwordless sudo
echo "${DEPLOY_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${DEPLOY_USER}
chmod 0440 /etc/sudoers.d/${DEPLOY_USER}
SETUP
    log_success "Deploy user configured"

    # Setup SSH key
    log_info "Configuring SSH key authentication..."
    if [ ! -f ~/.ssh/pigsty_deploy ]; then
        ssh-keygen -t ed25519 -f ~/.ssh/pigsty_deploy -N "" -C "pigsty-deploy"
    fi

    ssh_root << SSHKEY
set -e
mkdir -p /home/${DEPLOY_USER}/.ssh
chmod 700 /home/${DEPLOY_USER}/.ssh
cat > /home/${DEPLOY_USER}/.ssh/authorized_keys << 'EOF'
$(cat ~/.ssh/pigsty_deploy.pub)
EOF
chmod 600 /home/${DEPLOY_USER}/.ssh/authorized_keys
chown -R ${DEPLOY_USER}:${DEPLOY_USER} /home/${DEPLOY_USER}/.ssh
SSHKEY
    log_success "SSH key installed"

    # Test key authentication
    if ! test_ssh; then
        log_error "SSH key authentication failed"
        exit 1
    fi

    # Install base dependencies
    log_info "Installing base dependencies..."
    ssh_exec << 'DEPS'
set -e

# Update package list
sudo apt-get update -qq 2>/dev/null || sudo dnf check-update -q 2>/dev/null || true

# Install dependencies
if command -v apt-get &>/dev/null; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl wget git vim htop python3 python3-pip
elif command -v dnf &>/dev/null; then
    sudo dnf install -y curl wget git vim htop python3 python3-pip
fi
DEPS
    log_success "Dependencies installed"

    # Create Ansible inventory
    log_info "Creating Ansible inventory..."
    mkdir -p ansible/inventory
    cat > ansible/inventory/hosts.ini << INV
[pigsty]
${VPS_HOST} ansible_user=${DEPLOY_USER} ansible_ssh_private_key_file=~/.ssh/pigsty_deploy

[pigsty:vars]
ansible_python_interpreter=/usr/bin/python3
INV
    log_success "Ansible inventory created"

    log_success "VPS preparation completed"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    prepare_vps
fi
