#!/usr/bin/env bash

# ============================================
# MODULE: Deployment Verification
# ============================================
# Validates that the deployment is correct
# Based on lessons learned from actual deployment

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

verify_deployment() {
    log_step "Deployment Verification"

    load_env

    local errors=0

    # Test 1: PostgreSQL pg_hba.conf rules
    if ! verify_pg_hba; then
        ((errors++))
    fi

    # Test 2: PostgreSQL users
    if ! verify_pg_users; then
        ((errors++))
    fi

    # Test 3: PostgreSQL databases
    if ! verify_pg_databases; then
        ((errors++))
    fi

    # Test 4: Docker status
    if ! verify_docker; then
        ((errors++))
    fi

    # Test 5: Supabase containers
    if ! verify_supabase_containers; then
        ((errors++))
    fi

    # Test 6: Supabase API
    if ! verify_supabase_api; then
        ((errors++))
    fi

    # Test 7: Network connectivity
    if ! verify_network; then
        ((errors++))
    fi

    echo ""
    if [ $errors -eq 0 ]; then
        log_success "✅ All verification checks passed!"
        return 0
    else
        log_error "❌ $errors verification check(s) failed"
        return 1
    fi
}

verify_pg_hba() {
    log_info "Checking pg_hba.conf rules..."

    # Check for Docker network rule (CRITICAL - learned from deployment)
    if ! ssh_exec "sudo grep -q '172.17.0.0/16' /pg/data/pg_hba.conf"; then
        log_error "Missing Docker network (172.17.0.0/16) in pg_hba.conf"
        log_info "This will cause Supabase containers to fail connecting to PostgreSQL"
        return 1
    fi

    # Check for intra network rule
    if ! ssh_exec "sudo grep -q 'addr: intra' /pg/data/pg_hba.conf || sudo grep -q 'intra' /pg/data/pg_hba.conf"; then
        log_warn "Missing 'intra' network rule in pg_hba.conf"
        # Not critical if Docker network rule exists
    fi

    log_success "pg_hba.conf rules verified"
    return 0
}

verify_pg_users() {
    log_info "Checking PostgreSQL users..."

    local required_users=(
        "supabase_admin"
        "supabase_auth_admin"
        "supabase_storage_admin"
        "supabase_functions_admin"
        "authenticator"
    )

    local missing_users=()

    for user in "${required_users[@]}"; do
        if ! ssh_exec "sudo -u postgres psql -tAc \"SELECT 1 FROM pg_user WHERE usename='$user'\" | grep -q 1"; then
            missing_users+=("$user")
        fi
    done

    if [ ${#missing_users[@]} -gt 0 ]; then
        log_error "Missing PostgreSQL users: ${missing_users[*]}"
        return 1
    fi

    log_success "All required PostgreSQL users exist"
    return 0
}

verify_pg_databases() {
    log_info "Checking PostgreSQL databases..."

    local required_dbs=("postgres" "supabase")

    for db in "${required_dbs[@]}"; do
        if ! ssh_exec "sudo -u postgres psql -lqt | cut -d \\| -f 1 | grep -qw $db"; then
            log_error "Missing database: $db"
            return 1
        fi
    done

    # Check for _analytics schema in supabase database
    if ! ssh_exec "sudo -u postgres psql -d supabase -tAc \"SELECT 1 FROM information_schema.schemata WHERE schema_name='_analytics'\" | grep -q 1"; then
        log_warn "Missing _analytics schema in supabase database"
    fi

    log_success "Required databases exist"
    return 0
}

verify_docker() {
    log_info "Checking Docker status..."

    if ! ssh_exec "docker --version >/dev/null 2>&1"; then
        log_error "Docker is not installed"
        return 1
    fi

    if ! ssh_exec "docker compose version >/dev/null 2>&1"; then
        log_error "Docker Compose is not installed"
        return 1
    fi

    if ! ssh_exec "systemctl is-active --quiet docker"; then
        log_error "Docker service is not running"
        return 1
    fi

    log_success "Docker is installed and running"
    return 0
}

verify_supabase_containers() {
    log_info "Checking Supabase containers..."

    local required_containers=(
        "supabase-kong"
        "supabase-auth"
        "supabase-rest"
        "supabase-realtime"
        "supabase-storage"
        "supabase-meta"
        "supabase-studio"
    )

    # Get container status
    local container_status=$(ssh_exec "cd /opt/supabase && docker compose ps --format json" 2>/dev/null || echo "[]")

    if [ "$container_status" = "[]" ]; then
        log_error "No Supabase containers found"
        log_info "Run: ./scripts/deploy install"
        return 1
    fi

    # Check each required container
    local unhealthy_containers=()
    for container in "${required_containers[@]}"; do
        local status=$(echo "$container_status" | jq -r "select(.Name | contains(\"$container\")) | .Health" 2>/dev/null || echo "")

        if [ -z "$status" ]; then
            unhealthy_containers+=("$container:not_found")
        elif [ "$status" != "healthy" ] && [ -n "$status" ]; then
            unhealthy_containers+=("$container:$status")
        fi
    done

    if [ ${#unhealthy_containers[@]} -gt 0 ]; then
        log_error "Unhealthy containers:"
        for container in "${unhealthy_containers[@]}"; do
            echo "  - $container"
        done
        log_info "Check logs with: ssh ${VPS_HOST} 'cd /opt/supabase && docker compose logs'"
        return 1
    fi

    # Count total containers
    local total_containers=$(echo "$container_status" | jq -s 'length' 2>/dev/null || echo "0")
    log_success "All Supabase containers healthy ($total_containers running)"
    return 0
}

verify_supabase_api() {
    log_info "Checking Supabase API..."

    # Test Kong API Gateway
    local response=$(curl -s -o /dev/null -w "%{http_code}" "http://${VPS_HOST}:8000" 2>/dev/null || echo "000")

    if [ "$response" = "000" ]; then
        log_error "Cannot reach Supabase API at http://${VPS_HOST}:8000"
        log_info "Check if Kong container is running and port 8000 is open"
        return 1
    fi

    # 200 or 401 (Unauthorized) are both acceptable - means Kong is responding
    if [ "$response" != "200" ] && [ "$response" != "401" ]; then
        log_warn "Supabase API returned HTTP $response (expected 200 or 401)"
    fi

    log_success "Supabase API is responding"
    return 0
}

verify_network() {
    log_info "Checking network connectivity..."

    # Test SSH
    if ! ssh_exec "echo 'SSH OK'" >/dev/null 2>&1; then
        log_error "SSH connection failed"
        return 1
    fi

    # Test PostgreSQL port
    if ! ssh_exec "nc -z localhost 5436"; then
        log_error "PostgreSQL port 5436 not listening"
        return 1
    fi

    # Test Docker network
    if ! ssh_exec "docker network ls | grep -q supabase"; then
        log_warn "Supabase Docker network not found"
    fi

    log_success "Network connectivity verified"
    return 0
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    verify_deployment
fi
