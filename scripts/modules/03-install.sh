#!/usr/bin/env bash

# ============================================
# MODULE: Stack Installation
# ============================================
# Installs Pigsty, Docker, and Supabase

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

install_stack() {
    log_step "Stack Installation"

    load_env

    # Verify Pigsty is configured
    if ! check_pigsty; then
        log_error "Pigsty not configured. Run configuration module first."
        exit 1
    fi

    # Install Pigsty core
    log_info "Installing Pigsty infrastructure (this takes 10-15 minutes)..."
    ssh_exec << 'REMOTE'
set -e
cd ~/pigsty
./install.yml
REMOTE
    log_success "Pigsty infrastructure installed"

    # Install Docker
    log_info "Installing Docker..."
    ssh_exec << 'REMOTE'
set -e
cd ~/pigsty
./docker.yml
REMOTE
    log_success "Docker installed"

    # Deploy Supabase
    log_info "Deploying Supabase containers (this takes 3-5 minutes)..."
    ssh_exec << 'REMOTE'
set -e
cd ~/pigsty
./app.yml
REMOTE
    log_success "Supabase deployed"

    # Wait for services to be ready
    log_info "Waiting for services to start..."
    sleep 10

    log_success "Stack installation completed"

    # Display access info
    print_access_info
}

print_access_info() {
    echo ""
    log_step "Deployment Successful"

    cat << INFO
${GREEN}Supabase Studio:${NC}
  URL:      http://${VPS_HOST}:8000
  Default:  supabase / pigsty ${YELLOW}(CHANGE THIS!)${NC}

${GREEN}Grafana Monitoring:${NC}
  URL:      http://${VPS_HOST}
  User:     admin
  Password: ${GRAFANA_ADMIN_PASSWORD}

${GREEN}PostgreSQL:${NC}
  Host:     ${VPS_HOST}:5436 (pgbouncer)
  Database: supa
  User:     supabase_admin
  Password: ${POSTGRES_PASSWORD}

${GREEN}MinIO (S3 Storage):${NC}
  URL:      http://${VPS_HOST}:9000
  User:     ${MINIO_ROOT_USER}
  Password: ${MINIO_ROOT_PASSWORD}

${YELLOW}Next Steps:${NC}
  1. Change Supabase default credentials
  2. Setup SSL/TLS: ./scripts/deploy ssl
  3. Configure backups: ./scripts/deploy backup
  4. Run health check: ./scripts/deploy verify

${BLUE}Documentation:${NC} README.md
INFO
    echo ""
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    install_stack
fi
