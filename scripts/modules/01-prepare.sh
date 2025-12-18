#!/usr/bin/env bash

# ============================================
# MODULE: VPS Preparation
# ============================================
# Sets up VPS: user, SSH keys, dependencies
# Supports both SSH key (ubuntu/debian) and password (root) auth

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

prepare_vps() {
    log_step "VPS Preparation"

    load_env

    log_info "Target: ${VPS_HOST}"
    log_info "Auth method: ${AUTH_METHOD}"
    log_info "Deploy user: ${DEPLOY_USER}"

    # Test admin connection (ubuntu with key or root with password)
    log_info "Testing admin SSH connection..."
    if ! test_admin_ssh; then
        if [ "$AUTH_METHOD" = "key" ]; then
            log_error "Cannot connect to ${SSH_USER}@${VPS_HOST}"
            log_info "Make sure your SSH key is authorized on the VPS"
            log_info "Try: ssh ${SSH_USER}@${VPS_HOST}"
        else
            log_error "Cannot connect as root. Check VPS_HOST and VPS_ROOT_PASSWORD"
        fi
        exit 1
    fi
    log_success "Admin access verified"

    # Create deploy user
    log_info "Creating deploy user..."

    if [ "$AUTH_METHOD" = "key" ]; then
        # SSH Key mode - use sudo
        ssh_admin << SETUP
set -e

# Create user if doesn't exist
if ! id -u ${DEPLOY_USER} &>/dev/null; then
    sudo useradd -m -s /bin/bash ${DEPLOY_USER}
    echo "${DEPLOY_USER}:${DEPLOY_USER_PASSWORD}" | sudo chpasswd
fi

# Add to sudo group
sudo usermod -aG sudo ${DEPLOY_USER} 2>/dev/null || sudo usermod -aG wheel ${DEPLOY_USER} 2>/dev/null || true

# Passwordless sudo
echo "${DEPLOY_USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${DEPLOY_USER} > /dev/null
sudo chmod 0440 /etc/sudoers.d/${DEPLOY_USER}
SETUP
    else
        # Password mode - direct root
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
    fi
    log_success "Deploy user configured"

    # Setup SSH key for deploy user
    log_info "Configuring SSH key authentication for deploy user..."
    if [ ! -f ~/.ssh/pigsty_deploy ]; then
        ssh-keygen -t ed25519 -f ~/.ssh/pigsty_deploy -N "" -C "pigsty-deploy"
    fi

    local pubkey=$(cat ~/.ssh/pigsty_deploy.pub)

    if [ "$AUTH_METHOD" = "key" ]; then
        ssh_admin << SSHKEY
set -e
sudo mkdir -p /home/${DEPLOY_USER}/.ssh
sudo chmod 700 /home/${DEPLOY_USER}/.ssh
echo '${pubkey}' | sudo tee /home/${DEPLOY_USER}/.ssh/authorized_keys > /dev/null
sudo chmod 600 /home/${DEPLOY_USER}/.ssh/authorized_keys
sudo chown -R ${DEPLOY_USER}:${DEPLOY_USER} /home/${DEPLOY_USER}/.ssh
SSHKEY
    else
        ssh_root << SSHKEY
set -e
mkdir -p /home/${DEPLOY_USER}/.ssh
chmod 700 /home/${DEPLOY_USER}/.ssh
cat > /home/${DEPLOY_USER}/.ssh/authorized_keys << 'EOF'
${pubkey}
EOF
chmod 600 /home/${DEPLOY_USER}/.ssh/authorized_keys
chown -R ${DEPLOY_USER}:${DEPLOY_USER} /home/${DEPLOY_USER}/.ssh
SSHKEY
    fi
    log_success "SSH key installed for deploy user"

    # Test deploy user key authentication
    sleep 1
    if ! test_ssh; then
        log_error "SSH key authentication failed for deploy user"
        exit 1
    fi

    # Install base dependencies
    log_info "Installing base dependencies..."
    ssh_exec << 'DEPS'
set -e

# Wait for apt locks to be released (Ubuntu automatic updates)
wait_for_apt() {
    local max_wait=300  # 5 minutes
    local wait_time=0
    local interval=10

    while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || \
          sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 || \
          sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do

        if [ $wait_time -ge $max_wait ]; then
            echo "ERROR: apt lock still held after ${max_wait}s, aborting"
            return 1
        fi

        echo "Waiting for apt locks to be released... (${wait_time}s / ${max_wait}s)"
        sleep $interval
        wait_time=$((wait_time + interval))
    done

    echo "apt locks released, continuing"
    return 0
}

# Wait for any automatic updates to complete
if command -v apt-get &>/dev/null; then
    wait_for_apt
fi

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
    mkdir -p "${SCRIPT_DIR}/../ansible/inventory"
    cat > "${SCRIPT_DIR}/../ansible/inventory/hosts.ini" << INV
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
