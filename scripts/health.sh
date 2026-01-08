#!/usr/bin/env bash
#==============================================================================#
# Health endpoint setup
#==============================================================================#

setup_health_endpoint() {
    # Create health check script on VPS
    ssh_cmd "sudo tee /opt/health-check.sh > /dev/null << 'HEALTH'
#!/bin/bash
HOST_IP=\$(hostname -I | awk '{print \$1}')

check_postgres() {
    sudo -u postgres psql -c 'SELECT 1' postgres &>/dev/null && echo ok || echo fail
}

check_patroni() {
    curl -sf http://\${HOST_IP}:8008/ &>/dev/null && echo ok || echo fail
}

check_containers() {
    local bad=\$(docker ps --format '{{.Status}}' 2>/dev/null | grep -cv 'Up\|healthy')
    [[ \$bad -eq 0 ]] && echo ok || echo fail
}

cat << EOF
{
  \"status\": \"healthy\",
  \"timestamp\": \"\$(date -Iseconds)\",
  \"checks\": {
    \"postgres\": \"\$(check_postgres)\",
    \"patroni\": \"\$(check_patroni)\",
    \"containers\": \"\$(check_containers)\"
  }
}
EOF
HEALTH"

    ssh_cmd "sudo chmod +x /opt/health-check.sh"

    # Create nginx config for health endpoint
    ssh_cmd "sudo tee /etc/nginx/conf.d/health.conf > /dev/null << 'NGINX'
server {
    listen 8080;
    server_name _;

    location /health {
        default_type application/json;
        alias /var/www/health/status.json;
    }

    location /health/ping {
        return 200 'OK';
        add_header Content-Type text/plain;
    }
}
NGINX"

    # Create status directory and cron
    ssh_cmd "sudo mkdir -p /var/www/health"
    ssh_cmd "echo '* * * * * root /opt/health-check.sh > /var/www/health/status.json 2>/dev/null' | sudo tee /etc/cron.d/health-check > /dev/null"
    ssh_cmd "sudo chmod 644 /etc/cron.d/health-check"

    # Generate initial status
    ssh_cmd "sudo /opt/health-check.sh > /tmp/h.json && sudo mv /tmp/h.json /var/www/health/status.json"

    # Open port and reload nginx
    ssh_cmd "sudo ufw allow 8080/tcp comment 'Health' 2>/dev/null || true"
    ssh_cmd "sudo nginx -t && sudo systemctl reload nginx"
}
