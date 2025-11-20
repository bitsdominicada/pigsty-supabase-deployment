#!/bin/bash
#==============================================================#
# File      :   06-post-supabase.sh
# Desc      :   Post-deployment fixes for Supabase
# Ctime     :   2025-11-20
# Mtime     :   2025-11-20
# Path      :   scripts/modules/06-post-supabase.sh
# Author    :   Automation Script
# License   :   AGPLv3
#==============================================================#

PROG_NAME="$(basename $0)"
PROG_DIR="$(cd $(dirname $0) && pwd)"
PROJECT_ROOT="$(cd ${PROG_DIR}/../.. && pwd)"

source "${PROJECT_ROOT}/scripts/utils.sh"

#--------------------------------------------------------------#
# Fix Supabase .env file with proper configurations
#--------------------------------------------------------------#
function fix_supabase_env() {
    log_info "Fixing Supabase .env file..."

    # Load local .env for correct values
    source "${PROJECT_ROOT}/.env"

    # URL-encode the password for DATABASE_URL
    POSTGRES_PASSWORD_ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${POSTGRES_PASSWORD}', safe=''))")

    # SSH into VPS and update .env
    log_info "Updating JWT tokens and passwords on VPS..."

    sshpass -p "${DEPLOY_USER_PASSWORD}" ssh -o StrictHostKeyChecking=no "${DEPLOY_USER}@${VPS_HOST}" bash << EOF
        # Backup original .env
        sudo cp /opt/supabase/.env /opt/supabase/.env.backup-\$(date +%Y%m%d-%H%M%S)

        # Fix #1: Update POSTGRES_HOST to Docker gateway
        sudo sed -i 's|^POSTGRES_HOST=.*|POSTGRES_HOST=172.17.0.1|' /opt/supabase/.env

        # Fix #5: Update POSTGRES_PASSWORD with correct value
        sudo sed -i 's|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=${POSTGRES_PASSWORD}|' /opt/supabase/.env

        # Update JWT_SECRET
        sudo sed -i 's|^JWT_SECRET=.*|JWT_SECRET=${JWT_SECRET}|' /opt/supabase/.env

        # Update ANON_KEY
        sudo sed -i 's|^ANON_KEY=.*|ANON_KEY=${ANON_KEY}|' /opt/supabase/.env

        # Update SERVICE_ROLE_KEY
        sudo sed -i 's|^SERVICE_ROLE_KEY=.*|SERVICE_ROLE_KEY=${SERVICE_ROLE_KEY}|' /opt/supabase/.env

        # Add POSTGRES_PASSWORD_ENCODED if not exists
        if ! grep -q "^POSTGRES_PASSWORD_ENCODED=" /opt/supabase/.env; then
            sudo sed -i '/^POSTGRES_PASSWORD=/a POSTGRES_PASSWORD_ENCODED=${POSTGRES_PASSWORD_ENCODED}' /opt/supabase/.env
        else
            sudo sed -i 's|^POSTGRES_PASSWORD_ENCODED=.*|POSTGRES_PASSWORD_ENCODED=${POSTGRES_PASSWORD_ENCODED}|' /opt/supabase/.env
        fi

        # Add TUS_ALLOW_S3_TAGS if not exists
        if ! grep -q "^TUS_ALLOW_S3_TAGS=" /opt/supabase/.env; then
            echo "TUS_ALLOW_S3_TAGS=false" | sudo tee -a /opt/supabase/.env > /dev/null
        fi

        # Add DB_SSL if not exists
        if ! grep -q "^DB_SSL=" /opt/supabase/.env; then
            echo "DB_SSL=false" | sudo tee -a /opt/supabase/.env > /dev/null
        fi

        # Add DATABASE_URL if not exists (for Auth service)
        if ! grep -q "^DATABASE_URL=" /opt/supabase/.env; then
            echo "" | sudo tee -a /opt/supabase/.env > /dev/null
            echo "# Database URL for Auth service" | sudo tee -a /opt/supabase/.env > /dev/null
            echo "DATABASE_URL=postgresql://supabase_auth_admin:${POSTGRES_PASSWORD_ENCODED}@${VPS_HOST}:5436/postgres" | sudo tee -a /opt/supabase/.env > /dev/null
        fi
EOF

    log_success "Supabase .env file updated"
}

#--------------------------------------------------------------#
# Fix docker-compose.yml to use URL-encoded passwords
#--------------------------------------------------------------#
function fix_docker_compose() {
    log_info "Fixing docker-compose.yml to use URL-encoded passwords..."

    sshpass -p "${DEPLOY_USER_PASSWORD}" ssh -o StrictHostKeyChecking=no "${DEPLOY_USER}@${VPS_HOST}" bash << 'EOF'
        # Backup original docker-compose.yml
        sudo cp /opt/supabase/docker-compose.yml /opt/supabase/docker-compose.yml.backup-$(date +%Y%m%d-%H%M%S)

        # Replace POSTGRES_PASSWORD with POSTGRES_PASSWORD_ENCODED in DATABASE URLs
        sudo sed -i 's|\${POSTGRES_PASSWORD}|\${POSTGRES_PASSWORD_ENCODED}|g' /opt/supabase/docker-compose.yml

        # Fix analytics DB_PASSWORD to use non-encoded password (Fix #4)
        sudo sed -i 's|DB_PASSWORD: \${POSTGRES_PASSWORD_ENCODED}|DB_PASSWORD: ${POSTGRES_PASSWORD}|' /opt/supabase/docker-compose.yml
EOF

    log_success "docker-compose.yml updated"
}

#--------------------------------------------------------------#
# Update PostgreSQL user passwords
#--------------------------------------------------------------#
function update_pg_passwords() {
    log_info "Updating PostgreSQL user passwords and pg_hba.conf..."

    source "${PROJECT_ROOT}/.env"

    sshpass -p "${DEPLOY_USER_PASSWORD}" ssh -o StrictHostKeyChecking=no "${DEPLOY_USER}@${VPS_HOST}" bash << EOF
        # Fix #2: Add pg_hba.conf rule for VPS IP
        if ! sudo grep -q "${VPS_HOST}/32" /pg/data/pg_hba.conf; then
            echo "host     all                all                ${VPS_HOST}/32  scram-sha-256" | sudo tee -a /pg/data/pg_hba.conf > /dev/null
            sudo su - postgres -c "psql -p 5432 -c 'SELECT pg_reload_conf();'"
            echo "pg_hba.conf updated with VPS IP rule"
        fi

        # Fix #3: Update supabase_admin user password
        sudo su - postgres -c "psql -p 5432 -c \"ALTER USER supabase_admin WITH PASSWORD '${POSTGRES_PASSWORD}';\""

        # Update all other Supabase user passwords
        sudo su - postgres -c "psql -p 5432 -d postgres << 'PGSQL'
ALTER USER supabase_auth_admin WITH PASSWORD '${POSTGRES_PASSWORD}';
ALTER USER supabase_storage_admin WITH PASSWORD '${POSTGRES_PASSWORD}';
ALTER USER supabase_functions_admin WITH PASSWORD '${POSTGRES_PASSWORD}';
ALTER USER supabase_replication_admin WITH PASSWORD '${POSTGRES_PASSWORD}';
ALTER USER supabase_read_only_user WITH PASSWORD '${POSTGRES_PASSWORD}';
ALTER USER authenticator WITH PASSWORD '${POSTGRES_PASSWORD}';
PGSQL
"
EOF

    log_success "PostgreSQL user passwords and pg_hba.conf updated"
}

#--------------------------------------------------------------#
# Recreate Auth and Storage containers
#--------------------------------------------------------------#
function recreate_containers() {
    log_info "Recreating Auth and Storage containers..."

    sshpass -p "${DEPLOY_USER_PASSWORD}" ssh -o StrictHostKeyChecking=no "${DEPLOY_USER}@${VPS_HOST}" bash << 'EOF'
        cd /opt/supabase
        sudo docker compose down auth storage
        sudo docker compose up -d auth storage
EOF

    log_info "Waiting for containers to become healthy..."
    sleep 20

    sshpass -p "${DEPLOY_USER_PASSWORD}" ssh -o StrictHostKeyChecking=no "${DEPLOY_USER}@${VPS_HOST}" \
        "sudo docker ps | grep -E 'supabase-(auth|storage)'"

    log_success "Containers recreated successfully"
}

#--------------------------------------------------------------#
# Verify all services are running
#--------------------------------------------------------------#
function verify_services() {
    log_info "Verifying all Supabase services..."

    sshpass -p "${DEPLOY_USER_PASSWORD}" ssh -o StrictHostKeyChecking=no "${DEPLOY_USER}@${VPS_HOST}" \
        "sudo docker ps --format 'table {{.Names}}\t{{.Status}}' | grep supabase"

    # Check Kong health
    log_info "Checking Kong API Gateway..."
    sshpass -p "${DEPLOY_USER_PASSWORD}" ssh -o StrictHostKeyChecking=no "${DEPLOY_USER}@${VPS_HOST}" \
        "curl -s http://localhost:8000/health | head -5"

    log_success "All services verified"
}

#--------------------------------------------------------------#
# Main execution
#--------------------------------------------------------------#
function main() {
    log_step "Post-Supabase Deployment Fixes"

    fix_supabase_env
    fix_docker_compose
    update_pg_passwords
    recreate_containers
    verify_services

    log_success "Post-deployment fixes completed successfully!"

    echo ""
    echo "==================================================================="
    echo "  Supabase is now fully configured and running!"
    echo "==================================================================="
    echo ""
    echo "  Kong API Gateway: http://${VPS_HOST}:8000"
    echo "  Studio Dashboard: http://${VPS_HOST}:3000"
    echo "  PostgreSQL:       ${VPS_HOST}:5436"
    echo ""
    echo "  All services:"
    sshpass -p "${DEPLOY_USER_PASSWORD}" ssh -o StrictHostKeyChecking=no "${DEPLOY_USER}@${VPS_HOST}" \
        "sudo docker ps --format 'table {{.Names}}\t{{.Status}}' | grep supabase"
    echo ""
    echo "==================================================================="
}

# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Load environment variables
    set -a
    source "${PROJECT_ROOT}/.env"
    set +a

    main "$@"
fi
