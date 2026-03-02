#!/usr/bin/env bash
# =============================================================
# Phase 3: Security hardening
# Idempotent — safe to re-run.
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V2_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${V2_DIR}/.env"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

set -a
# shellcheck disable=SC1090
source "${ENV_FILE}"
set +a

SSH_USER="${SSH_USER:-root}"
ALL_NODES=("${META_IP}" "${DB1_PRIVATE_IP}" "${DB2_PRIVATE_IP}")

step() { echo -e "\n${GREEN}▶ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }

run_on() {
  local host="$1"
  shift
  ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no "${SSH_USER}@${host}" "$@"
}

# For data nodes, we must jump through meta
run_on_node() {
  local host="$1"
  shift
  if [[ "${host}" == "${META_IP}" ]]; then
    run_on "${host}" "$@"
  else
    # Data nodes are only reachable via private IP from meta
    ssh -o ConnectTimeout=10 "${SSH_USER}@${META_IP}" "ssh -o StrictHostKeyChecking=no ${host} '$*'"
  fi
}

# =============================================================
# Apply hardening to each node
# =============================================================
for NODE_IP in "${ALL_NODES[@]}"; do
  step "Hardening node ${NODE_IP}..."

  # -----------------------------------------------------------
  # 1. SSH hardening
  # -----------------------------------------------------------
  echo "  [SSH] Setting PermitRootLogin prohibit-password..."
  run_on_node "${NODE_IP}" "
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl reload sshd
  "

  # -----------------------------------------------------------
  # 2. UFW firewall
  # -----------------------------------------------------------
  echo "  [UFW] Configuring firewall..."
  run_on_node "${NODE_IP}" "
    apt-get install -y -qq ufw >/dev/null 2>&1

    # Reset to defaults
    ufw --force reset >/dev/null 2>&1

    # Default policies
    ufw default deny incoming
    ufw default allow outgoing

    # SSH
    ufw allow 22/tcp comment 'SSH'

    # Allow private VPC traffic
    ufw allow from 10.0.0.0/8 comment 'Private VPC'
    ufw allow from 192.168.0.0/16 comment 'Private RFC1918'
    ufw allow from 172.16.0.0/12 comment 'Docker networks'

    # Web (only on meta node)
    if [[ '${NODE_IP}' == '${META_IP}' ]]; then
      ufw allow 80/tcp comment 'HTTP'
      ufw allow 443/tcp comment 'HTTPS'
      # Allow Docker container forwarding
      ufw route allow from 172.18.0.0/16 comment 'Docker bridge forwarding'
    fi

    # Enable
    ufw --force enable
  "

  # -----------------------------------------------------------
  # 3. Fail2ban
  # -----------------------------------------------------------
  echo "  [FAIL2BAN] Configuring..."
  run_on_node "${NODE_IP}" "
    apt-get install -y -qq fail2ban >/dev/null 2>&1

    cat > /etc/fail2ban/jail.local << 'JAIL'
[DEFAULT]
bantime  = 3600
findtime = 600
maxretry = 5
backend  = systemd

[sshd]
enabled = true
port    = ssh
filter  = sshd
JAIL

    systemctl enable fail2ban
    systemctl restart fail2ban
  "

  # -----------------------------------------------------------
  # 4. Kernel hardening (sysctl)
  # -----------------------------------------------------------
  echo "  [SYSCTL] Applying kernel hardening..."
  run_on_node "${NODE_IP}" "
    cat > /etc/sysctl.d/99-hardening.conf << 'SYSCTL'
# Disable IP forwarding (except meta which needs Docker)
# net.ipv4.ip_forward = 1  # needed for Docker

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# Don't send ICMP redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Enable SYN cookies
net.ipv4.tcp_syncookies = 1

# Log martian packets
net.ipv4.conf.all.log_martians = 1
SYSCTL

    sysctl --system >/dev/null 2>&1
  "

  echo -e "  ${GREEN}Node ${NODE_IP} hardened.${NC}"
done

# -----------------------------------------------------------
# 5. Add pgbackrest verify to cron (meta node only)
# -----------------------------------------------------------
step "Adding pgBackRest verify to weekly cron..."
run_on "${META_IP}" "
  EXISTING=\$(sudo -u postgres crontab -l 2>/dev/null || true)
  if echo \"\${EXISTING}\" | grep -q 'pgbackrest.*verify'; then
    echo 'pgbackrest verify cron already exists'
  else
    echo \"\${EXISTING}
# Weekly backup verification (Sunday 6:00 AM)
0 6 * * 0 /usr/bin/pgbackrest --stanza=${PG_CLUSTER_NAME} verify >> /var/log/pgbackrest-verify.log 2>&1\" | sudo -u postgres crontab -
    echo 'Added pgbackrest verify to cron'
  fi
"

echo ""
echo -e "${GREEN}Phase 3 complete: Security hardening applied to all nodes.${NC}"
