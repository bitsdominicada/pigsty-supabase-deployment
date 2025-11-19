#!/usr/bin/env bash

# ============================================
# MODULE: Configuration Apply
# ============================================
# Applies configuration changes using Pigsty playbooks

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

apply_module() {
    local module=$1
    local tags=${2:-}

    log_step "Applying ${module} Module"

    load_env

    local playbook="${module}.yml"
    local cmd="cd ~/pigsty && ./${playbook}"

    if [ -n "$tags" ]; then
        cmd="${cmd} -t ${tags}"
        log_info "Applying with tags: ${tags}"
    fi

    log_info "Executing: ${playbook}"

    ssh_exec << REMOTE
set -e
${cmd}
REMOTE

    log_success "${module} module applied successfully"
}

# Parse command
MODULE="${1:-}"
TAGS="${2:-}"

case "$MODULE" in
    infra)
        apply_module "infra" "$TAGS"
        ;;
    pgsql)
        apply_module "pgsql" "$TAGS"
        ;;
    node)
        apply_module "node" "$TAGS"
        ;;
    app)
        apply_module "app" "$TAGS"
        ;;
    all)
        log_step "Applying All Modules"
        apply_module "node" ""
        apply_module "infra" ""
        apply_module "pgsql" ""
        apply_module "app" ""
        ;;
    *)
        echo "Usage: $0 {infra|pgsql|node|app|all} [tags]"
        echo ""
        echo "Examples:"
        echo "  $0 infra                    # Apply all INFRA changes"
        echo "  $0 infra grafana_config     # Apply only Grafana config"
        echo "  $0 pgsql pg_user            # Apply only PostgreSQL users"
        echo "  $0 app app_config,app_launch # Restart Supabase"
        exit 1
        ;;
esac
