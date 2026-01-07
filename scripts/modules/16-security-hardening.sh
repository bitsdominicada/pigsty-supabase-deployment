#!/usr/bin/env bash

# ============================================
# MODULE: Security Hardening
# ============================================
# Configures:
#   - UFW Firewall (only necessary ports)
#   - Fail2ban (brute force protection)
#   - SSH hardening
#
# Run: ./scripts/modules/16-security-hardening.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

configure_firewall() {
    log_step "Configuring UFW Firewall"

    ssh_exec "
        # Install UFW if not present
        which ufw >/dev/null || sudo apt-get install -y ufw

        # Check if already configured
        if sudo ufw status | grep -q 'Status: active'; then
            echo 'UFW already active, skipping...'
            sudo ufw status numbered
            return 0
        fi

        echo 'Configuring UFW...'

        # Reset and configure
        sudo ufw --force reset

        # Default policies
        sudo ufw default deny incoming
        sudo ufw default allow outgoing

        # SSH (critical - first)
        sudo ufw allow 22/tcp comment 'SSH'

        # Web (HTTP/HTTPS)
        sudo ufw allow 80/tcp comment 'HTTP'
        sudo ufw allow 443/tcp comment 'HTTPS'

        # Supabase API (Kong)
        sudo ufw allow 8000/tcp comment 'Supabase Kong API'
        sudo ufw allow 8443/tcp comment 'Supabase Kong HTTPS'

        # Grafana (until SSL configured)
        sudo ufw allow 3000/tcp comment 'Grafana'

        # Studio (mapped to 3001)
        sudo ufw allow 3001/tcp comment 'Supabase Studio'

        # Enable UFW
        echo 'y' | sudo ufw enable

        echo ''
        sudo ufw status verbose
    "

    log_success "Firewall configured"
}

configure_fail2ban() {
    log_step "Configuring Fail2ban"

    ssh_exec "
        # Install fail2ban
        if ! which fail2ban-server >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y fail2ban
        fi

        # Create jail.local configuration
        sudo tee /etc/fail2ban/jail.local > /dev/null << 'JAIL'
[DEFAULT]
# Ban for 1 hour
bantime = 3600
# Find failures in 10 minutes window
findtime = 600
# Ban after 5 failures
maxretry = 5
# Use UFW for banning
banaction = ufw

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600

[nginx-http-auth]
enabled = true
filter = nginx-http-auth
port = http,https
logpath = /var/log/nginx/error.log
maxretry = 5

[nginx-limit-req]
enabled = true
filter = nginx-limit-req
port = http,https
logpath = /var/log/nginx/error.log
maxretry = 10
findtime = 60
bantime = 7200

[nginx-botsearch]
enabled = true
filter = nginx-botsearch
port = http,https
logpath = /var/log/nginx/access.log
maxretry = 2
JAIL

        # Create nginx-limit-req filter if not exists
        sudo tee /etc/fail2ban/filter.d/nginx-limit-req.conf > /dev/null << 'FILTER'
[Definition]
failregex = limiting requests, excess:.* by zone.*client: <HOST>
ignoreregex =
FILTER

        # Restart fail2ban
        sudo systemctl enable fail2ban
        sudo systemctl restart fail2ban

        # Show status
        echo ''
        sudo fail2ban-client status
    "

    log_success "Fail2ban configured"
}

harden_ssh() {
    log_step "Hardening SSH Configuration"

    ssh_exec "
        # Backup original config
        sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d) 2>/dev/null || true

        # Apply SSH hardening (only if not already done)
        if ! grep -q '# Security Hardening Applied' /etc/ssh/sshd_config; then
            sudo tee -a /etc/ssh/sshd_config > /dev/null << 'SSHCONFIG'

# Security Hardening Applied
# Disable root login
PermitRootLogin no

# Disable password authentication (use keys only)
PasswordAuthentication no
PubkeyAuthentication yes

# Disable empty passwords
PermitEmptyPasswords no

# Limit authentication attempts
MaxAuthTries 3

# Disconnect idle sessions after 5 minutes
ClientAliveInterval 300
ClientAliveCountMax 2

# Disable X11 forwarding
X11Forwarding no

# Disable TCP forwarding
AllowTcpForwarding no
SSHCONFIG

            # Test config before restarting
            if sudo sshd -t; then
                sudo systemctl reload sshd
                echo 'SSH hardened successfully'
            else
                echo 'SSH config error, reverting...'
                sudo cp /etc/ssh/sshd_config.backup.* /etc/ssh/sshd_config
            fi
        else
            echo 'SSH already hardened, skipping...'
        fi
    "

    log_success "SSH hardened"
}

show_security_status() {
    log_step "Security Status"

    ssh_exec "
        echo '=== FIREWALL ==='
        sudo ufw status | head -15

        echo ''
        echo '=== FAIL2BAN ==='
        sudo fail2ban-client status 2>/dev/null || echo 'Not running'

        echo ''
        echo '=== SSH CONFIG ==='
        grep -E '^(PermitRootLogin|PasswordAuthentication|MaxAuthTries)' /etc/ssh/sshd_config 2>/dev/null || echo 'Default config'

        echo ''
        echo '=== RECENT BANNED IPs ==='
        sudo fail2ban-client status sshd 2>/dev/null | grep -E 'Banned|Currently' || echo 'None'
    "
}

main() {
    log_step "Security Hardening"
    load_env

    configure_firewall
    configure_fail2ban
    harden_ssh
    show_security_status

    log_success "Security hardening complete!"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main
fi
