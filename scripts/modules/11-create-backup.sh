#!/usr/bin/env bash

# ============================================
# MODULE: Create Database Backup
# ============================================
# Creates clean database backups from a running Supabase installation
# These backups can be restored without permission issues

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

BACKUP_DIR="${PROJECT_ROOT}/db_backup"

create_backup() {
    log_step "Creating Database Backup"

    load_env

    # Detect SSH key
    local ssh_key=""
    if [ -n "${SSH_KEY_PATH:-}" ] && [ -f "${SSH_KEY_PATH}" ]; then
        ssh_key="${SSH_KEY_PATH}"
    elif [ -f "$HOME/.ssh/id_ed25519" ]; then
        ssh_key="$HOME/.ssh/id_ed25519"
    elif [ -f "$HOME/.ssh/id_rsa" ]; then
        ssh_key="$HOME/.ssh/id_rsa"
    fi

    log_info "Creating backups on VPS..."

    ssh_exec "
        # Create backup directory
        sudo rm -rf /tmp/db_backup
        sudo mkdir -p /tmp/db_backup
        sudo chown postgres:postgres /tmp/db_backup

        # Backup globals (roles, users)
        sudo -u postgres pg_dumpall --globals-only --no-role-passwords -f /tmp/db_backup/globals.sql

        # Backup postgres database (main Supabase data)
        sudo -u postgres pg_dump -Fc --no-owner --no-privileges -f /tmp/db_backup/postgres.dump postgres

        # Backup supabase database (analytics) if exists
        sudo -u postgres psql -tc \"SELECT 1 FROM pg_database WHERE datname = 'supabase'\" | grep -q 1 && \
            sudo -u postgres pg_dump -Fc --no-owner --no-privileges -f /tmp/db_backup/supabase.dump supabase || \
            echo 'No supabase analytics database'

        # Set permissions for download
        sudo chmod 644 /tmp/db_backup/*

        echo ''
        echo 'Backups created:'
        ls -lh /tmp/db_backup/
    "

    # Create local backup directory
    mkdir -p "${BACKUP_DIR}"

    # Backup existing backups if any
    if [ -f "${BACKUP_DIR}/postgres.dump" ]; then
        local backup_date=$(date +%Y%m%d_%H%M%S)
        log_info "Backing up existing backups to db_backup_${backup_date}..."
        mv "${BACKUP_DIR}" "${PROJECT_ROOT}/db_backup_${backup_date}"
        mkdir -p "${BACKUP_DIR}"
    fi

    # Download backups
    log_info "Downloading backups..."
    scp -i "${ssh_key}" \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        "deploy@${VPS_HOST}:/tmp/db_backup/*" \
        "${BACKUP_DIR}/" 2>/dev/null

    # Create manifest
    cat > "${BACKUP_DIR}/MANIFEST.txt" << EOF
Backup created: $(date)
Source: ${VPS_HOST}
Domain: ${SUPABASE_DOMAIN:-unknown}

Files:
$(ls -lh "${BACKUP_DIR}"/*.dump "${BACKUP_DIR}"/*.sql 2>/dev/null)

This backup was created with --no-owner --no-privileges flags
and can be restored cleanly to any Pigsty+Supabase installation.
EOF

    # Cleanup remote
    ssh_exec "sudo rm -rf /tmp/db_backup"

    log_success "Backup completed!"
    echo ""
    log_info "Backup location: ${BACKUP_DIR}"
    ls -lh "${BACKUP_DIR}"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    create_backup
fi
