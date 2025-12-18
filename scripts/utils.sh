#!/usr/bin/env bash

# ============================================
# PIGSTY SUPABASE - SHARED UTILITIES
# ============================================
# Supports both SSH key (professional) and password auth (legacy)

# Prevent double-sourcing
if [ -n "${PIGSTY_UTILS_LOADED:-}" ]; then
    return 0
fi
readonly PIGSTY_UTILS_LOADED=1

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# ============================================
# SSH KEY AUTO-DETECTION
# ============================================

# Auto-detect SSH key path
detect_ssh_key() {
    # If explicitly set in .env, use that
    if [ -n "${SSH_KEY_PATH:-}" ] && [ -f "${SSH_KEY_PATH}" ]; then
        echo "${SSH_KEY_PATH}"
        return 0
    fi

    # Auto-detect in order of preference
    local key_paths=(
        "${HOME}/.ssh/id_ed25519"      # Most modern and secure
        "${HOME}/.ssh/id_rsa"          # Classic
        "${HOME}/.ssh/pigsty_deploy"   # Project-specific
    )

    for key in "${key_paths[@]}"; do
        if [ -f "$key" ]; then
            echo "$key"
            return 0
        fi
    done

    # No key found
    return 1
}

# Auto-detect SSH user by testing connection
detect_ssh_user() {
    local host="$1"
    local key="$2"

    # If explicitly set in .env, use that
    if [ -n "${SSH_USER:-}" ]; then
        echo "${SSH_USER}"
        return 0
    fi

    # Common cloud users to try
    local users=("ubuntu" "debian" "admin" "root" "ec2-user" "centos")

    for user in "${users[@]}"; do
        if ssh -i "$key" \
            -o StrictHostKeyChecking=no \
            -o UserKnownHostsFile=/dev/null \
            -o LogLevel=ERROR \
            -o ConnectTimeout=5 \
            -o BatchMode=yes \
            "${user}@${host}" "echo ok" &>/dev/null; then
            echo "$user"
            return 0
        fi
    done

    # No user found
    return 1
}

# Determine authentication method
# Returns: "key" or "password"
detect_auth_method() {
    # If SSH_KEY_PATH is set or a key exists, prefer key auth
    if detect_ssh_key &>/dev/null; then
        # Check if we also need password (legacy mode)
        if [ -n "${VPS_ROOT_PASSWORD:-}" ] && [ -z "${SSH_USER:-}" ]; then
            echo "password"
        else
            echo "key"
        fi
    elif [ -n "${VPS_ROOT_PASSWORD:-}" ]; then
        echo "password"
    else
        echo "none"
    fi
}

# ============================================
# ENVIRONMENT LOADING
# ============================================

load_env() {
    if [ ! -f .env ]; then
        echo -e "${RED}Error: .env file not found${NC}"
        echo "Run: cp .env.example .env"
        exit 1
    fi

    # shellcheck disable=SC1091
    source .env

    # Determine auth method
    AUTH_METHOD=$(detect_auth_method)

    if [ "$AUTH_METHOD" = "key" ]; then
        # SSH Key mode - auto-detect key and user
        SSH_KEY_PATH=$(detect_ssh_key) || {
            log_error "No SSH key found. Create one with: ssh-keygen -t ed25519"
            exit 1
        }

        # Set default SSH_USER if not specified
        SSH_USER="${SSH_USER:-ubuntu}"

        log_info "Using SSH key authentication"
        log_info "  Key: ${SSH_KEY_PATH}"
        log_info "  User: ${SSH_USER}"

    elif [ "$AUTH_METHOD" = "password" ]; then
        # Legacy password mode
        ensure_sshpass
        log_info "Using password authentication (legacy mode)"

    else
        log_error "No authentication method available"
        log_info "Either set SSH_USER + have an SSH key, or set VPS_ROOT_PASSWORD"
        exit 1
    fi

    # Validate required variables (common to both methods)
    local required_vars=(
        "VPS_HOST"
        "DEPLOY_USER"
        "DEPLOY_USER_PASSWORD"
        "POSTGRES_PASSWORD"
        "GRAFANA_ADMIN_PASSWORD"
        "JWT_SECRET"
    )

    for var in "${required_vars[@]}"; do
        if [ -z "${!var:-}" ]; then
            echo -e "${RED}Error: $var not set in .env${NC}"
            exit 1
        fi
    done

    # Export for use in other scripts
    export AUTH_METHOD SSH_KEY_PATH SSH_USER
}

# ============================================
# LOG FUNCTIONS
# ============================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

log_step() {
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  $*${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# ============================================
# SSH HELPERS (Support both key and password)
# ============================================

# SSH to VPS as the initial user (ubuntu, root, etc.) with sudo
ssh_admin() {
    if [ "${AUTH_METHOD:-key}" = "key" ]; then
        ssh -i "${SSH_KEY_PATH}" \
            -o StrictHostKeyChecking=no \
            -o UserKnownHostsFile=/dev/null \
            -o LogLevel=ERROR \
            "${SSH_USER}@${VPS_HOST}" "$@"
    else
        sshpass -p "${VPS_ROOT_PASSWORD}" \
            ssh -o StrictHostKeyChecking=no \
            -o UserKnownHostsFile=/dev/null \
            -o LogLevel=ERROR \
            "root@${VPS_HOST}" "$@"
    fi
}

# SSH to VPS as the initial user and run command with sudo
ssh_sudo() {
    if [ "${AUTH_METHOD:-key}" = "key" ]; then
        ssh -i "${SSH_KEY_PATH}" \
            -o StrictHostKeyChecking=no \
            -o UserKnownHostsFile=/dev/null \
            -o LogLevel=ERROR \
            "${SSH_USER}@${VPS_HOST}" "sudo bash -c '$*'"
    else
        sshpass -p "${VPS_ROOT_PASSWORD}" \
            ssh -o StrictHostKeyChecking=no \
            -o UserKnownHostsFile=/dev/null \
            -o LogLevel=ERROR \
            "root@${VPS_HOST}" "$@"
    fi
}

# SSH as deploy user (after setup)
ssh_exec() {
    ssh -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        "${DEPLOY_USER}@${VPS_HOST}" "$@"
}

# Legacy: SSH as root with password (for backward compatibility)
ssh_root() {
    if [ "${AUTH_METHOD:-key}" = "key" ]; then
        # In key mode, use ssh_sudo instead
        ssh_sudo "$@"
    else
        sshpass -p "${VPS_ROOT_PASSWORD}" \
            ssh -o StrictHostKeyChecking=no \
            -o UserKnownHostsFile=/dev/null \
            -o LogLevel=ERROR \
            "root@${VPS_HOST}" "$@"
    fi
}

# SCP file to VPS as admin user
scp_admin() {
    local src="$1"
    local dest="$2"

    if [ "${AUTH_METHOD:-key}" = "key" ]; then
        scp -i "${SSH_KEY_PATH}" \
            -o StrictHostKeyChecking=no \
            -o UserKnownHostsFile=/dev/null \
            -o LogLevel=ERROR \
            "$src" "${SSH_USER}@${VPS_HOST}:${dest}"
    else
        sshpass -p "${VPS_ROOT_PASSWORD}" \
            scp -o StrictHostKeyChecking=no \
            -o UserKnownHostsFile=/dev/null \
            -o LogLevel=ERROR \
            "$src" "root@${VPS_HOST}:${dest}"
    fi
}

# SCP file to VPS as deploy user
scp_deploy() {
    local src="$1"
    local dest="$2"

    scp -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        "$src" "${DEPLOY_USER}@${VPS_HOST}:${dest}"
}

# ============================================
# UTILITY FUNCTIONS
# ============================================

# Check if command exists
require_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "Required command not found: $1"
        if [ -n "${2:-}" ]; then
            log_info "Install with: $2"
        fi
        exit 1
    fi
}

# Install sshpass if needed (only for password mode)
ensure_sshpass() {
    if ! command -v sshpass &> /dev/null; then
        log_info "Installing sshpass..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install hudochenkov/sshpass/sshpass
        else
            log_error "Please install sshpass manually"
            exit 1
        fi
    fi
}

# Test SSH connection
test_ssh() {
    log_info "Testing SSH connection to ${VPS_HOST}..."
    if ssh_exec "echo 'Connected'" &>/dev/null; then
        log_success "SSH connection successful"
        return 0
    else
        log_error "SSH connection failed"
        return 1
    fi
}

# Test admin SSH connection (before deploy user is created)
test_admin_ssh() {
    log_info "Testing admin SSH connection to ${VPS_HOST}..."
    if ssh_admin "echo 'Connected'" &>/dev/null; then
        log_success "Admin SSH connection successful"
        return 0
    else
        log_error "Admin SSH connection failed"
        return 1
    fi
}

# Generate JWT tokens
generate_jwt_token() {
    local role=$1
    local secret=$2

    local header='{"alg":"HS256","typ":"JWT"}'
    local payload="{\"role\":\"${role}\",\"iss\":\"supabase\",\"iat\":1641971400,\"exp\":4795571400}"

    local header_b64=$(echo -n "$header" | base64 | tr -d '=' | tr '/+' '_-')
    local payload_b64=$(echo -n "$payload" | base64 | tr -d '=' | tr '/+' '_-')
    local signature=$(echo -n "${header_b64}.${payload_b64}" | openssl dgst -sha256 -hmac "$secret" -binary | base64 | tr -d '=' | tr '/+' '_-')

    echo "${header_b64}.${payload_b64}.${signature}"
}

# Validate JWT secret length
validate_jwt_secret() {
    if [ ${#JWT_SECRET} -lt 40 ]; then
        log_error "JWT_SECRET must be at least 40 characters"
        log_info "Generate with: openssl rand -base64 32"
        exit 1
    fi
}

# Check if Docker is installed on VPS
check_docker() {
    if ssh_exec "command -v docker &>/dev/null"; then
        return 0
    else
        return 1
    fi
}

# Check if Pigsty is installed on VPS
check_pigsty() {
    if ssh_exec "[ -d ~/pigsty ] && [ -f ~/pigsty/pigsty.yml ]"; then
        return 0
    else
        return 1
    fi
}

# Wait for service with timeout
wait_for_service() {
    local host=$1
    local port=$2
    local timeout=${3:-60}
    local elapsed=0

    log_info "Waiting for ${host}:${port}..."

    while ! nc -z "${host}" "${port}" 2>/dev/null; do
        sleep 2
        elapsed=$((elapsed + 2))
        if [ $elapsed -ge $timeout ]; then
            log_error "Timeout waiting for ${host}:${port}"
            return 1
        fi
    done

    log_success "Service ${host}:${port} is ready"
    return 0
}

# Print banner
print_banner() {
    echo -e "${GREEN}"
    cat << 'BANNER'
╔═══════════════════════════════════════════════════╗
║                                                   ║
║   Pigsty + Supabase Deployment Automation        ║
║   PostgreSQL 17 + High Availability Stack        ║
║                                                   ║
╚═══════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
}
