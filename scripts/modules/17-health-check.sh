#!/usr/bin/env bash

# ============================================
# MODULE: Health Check System
# ============================================
# Creates local health check script with cron and configures /health endpoint
#
# Run: ./scripts/modules/17-health-check.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Health check script that runs on cron
create_health_check_script() {
    log_info "Creating health check script on remote server..."

    local alert_email="${ALERT_EMAIL:-admin@localhost}"

    ssh_exec "sudo tee /opt/supabase/health-check.sh > /dev/null << 'HEALTHSCRIPT'
#!/bin/bash
# Supabase + Pigsty Health Check Script
# Runs via cron and sends alerts on failures

ALERT_EMAIL=\"${alert_email}\"
LOG_FILE=\"/var/log/supabase-health.log\"
ALERT_COOLDOWN_FILE=\"/tmp/health-alert-cooldown\"
COOLDOWN_MINUTES=30

# Colors for local output
RED='\\033[0;31m'
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
NC='\\033[0m'

log() {
    echo \"\$(date '+%Y-%m-%d %H:%M:%S') - \$1\" >> \"\$LOG_FILE\"
}

send_alert() {
    local subject=\"\$1\"
    local body=\"\$2\"

    # Check cooldown to avoid alert flooding
    if [[ -f \"\$ALERT_COOLDOWN_FILE\" ]]; then
        local last_alert=\$(cat \"\$ALERT_COOLDOWN_FILE\")
        local now=\$(date +%s)
        local diff=\$(( (now - last_alert) / 60 ))
        if [[ \$diff -lt \$COOLDOWN_MINUTES ]]; then
            log \"Alert suppressed (cooldown: \${diff}m/\${COOLDOWN_MINUTES}m)\"
            return
        fi
    fi

    echo \"\$body\" | mail -s \"\$subject\" \"\$ALERT_EMAIL\" 2>/dev/null || log \"Failed to send email alert\"
    date +%s > \"\$ALERT_COOLDOWN_FILE\"
    log \"Alert sent: \$subject\"
}

check_postgres() {
    local status=\"OK\"
    local details=\"\"

    # Check if PostgreSQL is responding
    if ! sudo -u postgres psql -c \"SELECT 1\" postgres >/dev/null 2>&1; then
        status=\"CRITICAL\"
        details=\"PostgreSQL is not responding\"
    else
        # Check replication lag
        local lag=\$(sudo -u postgres psql -t -c \"SELECT COALESCE(MAX(pg_wal_lsn_diff(pg_current_wal_lsn(), confirmed_flush_lsn))::bigint, 0) FROM pg_replication_slots WHERE active = true;\" postgres 2>/dev/null | tr -d ' ')
        if [[ \"\$lag\" -gt 1073741824 ]]; then  # 1GB
            status=\"WARNING\"
            details=\"Replication lag: \$(echo \"scale=2; \$lag/1024/1024\" | bc)MB\"
        fi

        # Check connection count
        local connections=\$(sudo -u postgres psql -t -c \"SELECT count(*) FROM pg_stat_activity;\" postgres 2>/dev/null | tr -d ' ')
        local max_connections=\$(sudo -u postgres psql -t -c \"SHOW max_connections;\" postgres 2>/dev/null | tr -d ' ')
        local pct=\$(echo \"scale=0; \$connections * 100 / \$max_connections\" | bc)
        if [[ \$pct -gt 80 ]]; then
            status=\"WARNING\"
            details=\"\${details} Connection usage: \${pct}%\"
        fi
    fi

    echo \"\$status|\$details\"
}

check_patroni() {
    local status=\"OK\"
    local details=\"\"

    if ! systemctl is-active --quiet patroni 2>/dev/null; then
        status=\"CRITICAL\"
        details=\"Patroni service is not running\"
    else
        # Check Patroni API
        local patroni_state=\$(curl -s http://127.0.0.1:8008/health 2>/dev/null | jq -r '.state // \"unknown\"')
        if [[ \"\$patroni_state\" != \"running\" ]]; then
            status=\"WARNING\"
            details=\"Patroni state: \$patroni_state\"
        fi
    fi

    echo \"\$status|\$details\"
}

check_supabase_containers() {
    local status=\"OK\"
    local details=\"\"
    local failed_containers=\"\"

    cd /opt/supabase

    # Check each container
    while read -r container state; do
        if [[ \"\$state\" != \"running\" ]]; then
            failed_containers=\"\${failed_containers}\${container}(\${state}) \"
        fi
    done < <(docker compose ps --format '{{.Name}} {{.State}}' 2>/dev/null)

    if [[ -n \"\$failed_containers\" ]]; then
        status=\"CRITICAL\"
        details=\"Failed containers: \$failed_containers\"
    fi

    echo \"\$status|\$details\"
}

check_disk_space() {
    local status=\"OK\"
    local details=\"\"

    # Check main partitions
    while read -r mount usage; do
        local pct=\${usage%\%}
        if [[ \$pct -gt 90 ]]; then
            status=\"CRITICAL\"
            details=\"\${details}\${mount}: \${usage} \"
        elif [[ \$pct -gt 80 ]]; then
            [[ \"\$status\" != \"CRITICAL\" ]] && status=\"WARNING\"
            details=\"\${details}\${mount}: \${usage} \"
        fi
    done < <(df -h / /var /opt 2>/dev/null | awk 'NR>1 {print \$6, \$5}')

    echo \"\$status|\$details\"
}

check_memory() {
    local status=\"OK\"
    local details=\"\"

    local mem_info=\$(free | awk '/Mem:/ {printf \"%.0f\", \$3/\$2 * 100}')
    if [[ \$mem_info -gt 95 ]]; then
        status=\"CRITICAL\"
        details=\"Memory usage: \${mem_info}%\"
    elif [[ \$mem_info -gt 85 ]]; then
        status=\"WARNING\"
        details=\"Memory usage: \${mem_info}%\"
    fi

    echo \"\$status|\$details\"
}

check_ssl_expiry() {
    local status=\"OK\"
    local details=\"\"
    local domain=\"\$(hostname -f)\"

    # Check if we have SSL certs
    if [[ -f /etc/letsencrypt/live/\$domain/cert.pem ]]; then
        local expiry=\$(openssl x509 -enddate -noout -in /etc/letsencrypt/live/\$domain/cert.pem 2>/dev/null | cut -d= -f2)
        local expiry_epoch=\$(date -d \"\$expiry\" +%s 2>/dev/null)
        local now=\$(date +%s)
        local days_left=\$(( (expiry_epoch - now) / 86400 ))

        if [[ \$days_left -lt 7 ]]; then
            status=\"CRITICAL\"
            details=\"SSL expires in \${days_left} days\"
        elif [[ \$days_left -lt 14 ]]; then
            status=\"WARNING\"
            details=\"SSL expires in \${days_left} days\"
        fi
    fi

    echo \"\$status|\$details\"
}

# Main health check
main() {
    local overall_status=\"OK\"
    local alert_body=\"\"
    local hostname=\$(hostname -f)

    log \"Starting health check...\"

    # Run all checks
    declare -A checks
    checks[\"PostgreSQL\"]=\$(check_postgres)
    checks[\"Patroni\"]=\$(check_patroni)
    checks[\"Supabase\"]=\$(check_supabase_containers)
    checks[\"DiskSpace\"]=\$(check_disk_space)
    checks[\"Memory\"]=\$(check_memory)
    checks[\"SSL\"]=\$(check_ssl_expiry)

    # Process results
    for check_name in \"\${!checks[@]}\"; do
        IFS='|' read -r status details <<< \"\${checks[\$check_name]}\"

        if [[ \"\$status\" == \"CRITICAL\" ]]; then
            overall_status=\"CRITICAL\"
            alert_body=\"\${alert_body}[CRITICAL] \${check_name}: \${details}\\n\"
            log \"CRITICAL: \$check_name - \$details\"
        elif [[ \"\$status\" == \"WARNING\" ]]; then
            [[ \"\$overall_status\" != \"CRITICAL\" ]] && overall_status=\"WARNING\"
            alert_body=\"\${alert_body}[WARNING] \${check_name}: \${details}\\n\"
            log \"WARNING: \$check_name - \$details\"
        else
            log \"OK: \$check_name\"
        fi
    done

    # Send alert if needed
    if [[ \"\$overall_status\" != \"OK\" ]]; then
        local subject=\"[\${overall_status}] Supabase Health Alert - \${hostname}\"
        local body=\"Health check detected issues on \${hostname}:\\n\\n\${alert_body}\\nTimestamp: \$(date)\"
        send_alert \"\$subject\" \"\$(echo -e \"\$body\")\"
    fi

    log \"Health check complete: \$overall_status\"

    # Return status for external use
    case \"\$overall_status\" in
        OK) exit 0 ;;
        WARNING) exit 1 ;;
        CRITICAL) exit 2 ;;
    esac
}

main \"\$@\"
HEALTHSCRIPT"

    ssh_exec "sudo chmod +x /opt/supabase/health-check.sh"
    log_success "Health check script created"
}

# Configure cron job for health checks
configure_health_cron() {
    log_info "Configuring health check cron job..."

    # Run every 5 minutes
    ssh_exec "sudo tee /etc/cron.d/supabase-health > /dev/null << 'CRON'
# Supabase health check - runs every 5 minutes
*/5 * * * * root /opt/supabase/health-check.sh >/dev/null 2>&1
CRON"

    ssh_exec "sudo chmod 644 /etc/cron.d/supabase-health"
    log_success "Health check cron configured (every 5 minutes)"
}

# Create /health endpoint via nginx
create_health_endpoint() {
    log_info "Creating /health endpoint for external monitoring..."

    # Create health check API script
    ssh_exec "sudo tee /opt/supabase/health-api.sh > /dev/null << 'HEALTHAPI'
#!/bin/bash
# Quick health check for HTTP endpoint

HOST_IP=\$(hostname -I | awk '{print \$1}')

check_postgres() {
    sudo -u postgres psql -c \"SELECT 1\" postgres >/dev/null 2>&1 && echo \"ok\" || echo \"fail\"
}

check_containers() {
    cd /opt/supabase
    local unhealthy=\$(docker compose ps --format '{{.State}}' 2>/dev/null | grep -v running | wc -l)
    [[ \$unhealthy -eq 0 ]] && echo \"ok\" || echo \"fail\"
}

check_patroni() {
    curl -sf http://\${HOST_IP}:8008/ >/dev/null 2>&1 && echo \"ok\" || echo \"fail\"
}

# Generate JSON response
postgres_status=\$(check_postgres)
containers_status=\$(check_containers)
patroni_status=\$(check_patroni)

# Determine overall status
overall=\"healthy\"
[[ \"\$postgres_status\" != \"ok\" ]] && overall=\"unhealthy\"
[[ \"\$containers_status\" != \"ok\" ]] && overall=\"unhealthy\"
[[ \"\$patroni_status\" != \"ok\" ]] && overall=\"unhealthy\"

# Output JSON
cat << EOF
{
  \"status\": \"\$overall\",
  \"timestamp\": \"\$(date -Iseconds)\",
  \"checks\": {
    \"postgres\": \"\$postgres_status\",
    \"containers\": \"\$containers_status\",
    \"patroni\": \"\$patroni_status\"
  }
}
EOF
HEALTHAPI"

    ssh_exec "sudo chmod +x /opt/supabase/health-api.sh"

    # Create fcgiwrap config for the health endpoint
    ssh_exec "sudo apt-get install -y fcgiwrap spawn-fcgi >/dev/null 2>&1 || true"

    # Create a simple health endpoint using nginx + shell
    ssh_exec "sudo tee /etc/nginx/conf.d/health-endpoint.conf > /dev/null << 'NGINXCONF'
# Health check endpoint
server {
    listen 8080;
    server_name _;

    location /health {
        default_type application/json;

        content_by_lua_block {
            local handle = io.popen(\"/opt/supabase/health-api.sh\")
            local result = handle:read(\"*a\")
            handle:close()
            ngx.say(result)
        }
    }

    location /health/simple {
        access_log off;
        return 200 'OK';
        add_header Content-Type text/plain;
    }
}
NGINXCONF"

    # Check if nginx has lua module, if not use alternative approach
    if ! ssh_exec "sudo nginx -t 2>&1 | grep -q 'test is successful'"; then
        log_info "Lua module not available, using alternative approach..."

        # Use a simple static file approach with cron updates
        ssh_exec "sudo tee /etc/nginx/conf.d/health-endpoint.conf > /dev/null << 'NGINXCONF'
# Health check endpoint (static file approach)
server {
    listen 8080;
    server_name _;

    location /health {
        default_type application/json;
        alias /var/www/health/status.json;
    }

    location /health/simple {
        access_log off;
        return 200 'OK';
        add_header Content-Type text/plain;
    }
}
NGINXCONF"

        # Create health status directory
        ssh_exec "sudo mkdir -p /var/www/health"

        # Add cron to update health status every minute
        ssh_exec "sudo tee /etc/cron.d/health-status > /dev/null << 'CRON'
# Update health status file every minute
* * * * * root /opt/supabase/health-api.sh > /var/www/health/status.json 2>/dev/null
CRON"

        ssh_exec "sudo chmod 644 /etc/cron.d/health-status"

        # Generate initial status
        ssh_exec "sudo /opt/supabase/health-api.sh > /tmp/health-status.json 2>/dev/null && sudo mv /tmp/health-status.json /var/www/health/status.json || echo '{\"status\":\"initializing\"}' | sudo tee /var/www/health/status.json > /dev/null"
    fi

    # Open port 8080 in firewall if UFW is active
    ssh_exec "sudo ufw allow 8080/tcp comment 'Health Check Endpoint' 2>/dev/null || true"

    # Reload nginx
    ssh_exec "sudo nginx -t && sudo systemctl reload nginx"

    log_success "Health endpoint created at http://${VPS_HOST}:8080/health"
}

# Main function
setup_health_monitoring() {
    load_env
    log_step "Setting up Health Monitoring"

    create_health_check_script
    configure_health_cron
    create_health_endpoint

    # Run initial health check
    log_info "Running initial health check..."
    ssh_exec "/opt/supabase/health-check.sh" || true

    log_success "Health monitoring setup complete!"
    echo ""
    echo "Health Check Summary:"
    echo "  - Local check: /opt/supabase/health-check.sh (runs every 5 min)"
    echo "  - Logs: /var/log/supabase-health.log"
    echo "  - HTTP endpoint: http://${VPS_HOST}:8080/health"
    echo "  - Simple ping: http://${VPS_HOST}:8080/health/simple"
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_health_monitoring
fi
