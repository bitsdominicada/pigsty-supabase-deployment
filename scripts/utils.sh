#!/usr/bin/env bash

# ============================================
# PIGSTY SUPABASE - SHARED UTILITIES
# ============================================

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

# Load environment variables
load_env() {
    if [ ! -f .env ]; then
        echo -e "${RED}Error: .env file not found${NC}"
        echo "Run: cp .env.example .env"
        exit 1
    fi

    # shellcheck disable=SC1091
    source .env

    # Validate required variables
    local required_vars=(
        "VPS_HOST"
        "VPS_ROOT_PASSWORD"
        "DEPLOY_USER"
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
}

# Log functions
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

# SSH helper
ssh_exec() {
    ssh -i ~/.ssh/pigsty_deploy \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        "${DEPLOY_USER}@${VPS_HOST}" "$@"
}

ssh_root() {
    sshpass -p "${VPS_ROOT_PASSWORD}" \
        ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        root@"${VPS_HOST}" "$@"
}

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

# Install sshpass if needed
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
