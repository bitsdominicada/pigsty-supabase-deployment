#!/usr/bin/env bash
set -euo pipefail

# ============================================
# PIGSTY SUPABASE - HEALTH CHECK
# ============================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found!${NC}"
    exit 1
fi

source .env

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Pigsty Supabase Health Check${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# Function to check HTTP endpoint
check_http() {
    local url=$1
    local name=$2
    
    if curl -f -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$url" | grep -q "200\|301\|302"; then
        echo -e "  ${name}: ${GREEN}✓ OK${NC}"
        return 0
    else
        echo -e "  ${name}: ${RED}✗ FAILED${NC}"
        return 1
    fi
}

# SSH Connection
echo -e "${YELLOW}[1] SSH Connection${NC}"
if ssh -i ~/.ssh/pigsty_deploy -o ConnectTimeout=5 ${DEPLOY_USER}@${VPS_HOST} "echo 'OK'" &>/dev/null; then
    echo -e "  SSH: ${GREEN}✓ Connected${NC}"
else
    echo -e "  SSH: ${RED}✗ Failed${NC}"
fi
echo ""

# PostgreSQL
echo -e "${YELLOW}[2] PostgreSQL${NC}"
ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << 'REMOTE_CHECK'
set +e

# Check PostgreSQL process
if pgrep -x postgres > /dev/null; then
    echo -e "  PostgreSQL: \033[0;32m✓ Running\033[0m"
else
    echo -e "  PostgreSQL: \033[0;31m✗ Not running\033[0m"
fi

# Check Patroni
if pgrep -x patroni > /dev/null; then
    echo -e "  Patroni: \033[0;32m✓ Running\033[0m"
else
    echo -e "  Patroni: \033[0;31m✗ Not running\033[0m"
fi

# Check Pgbouncer
if pgrep -x pgbouncer > /dev/null; then
    echo -e "  Pgbouncer: \033[0;32m✓ Running\033[0m"
else
    echo -e "  Pgbouncer: \033[0;31m✗ Not running\033[0m"
fi
REMOTE_CHECK
echo ""

# Docker Services
echo -e "${YELLOW}[3] Docker Services${NC}"
ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << 'REMOTE_CHECK'
set +e

if command -v docker &> /dev/null; then
    RUNNING=$(sudo docker ps --format "{{.Names}}" | wc -l)
    echo -e "  Docker containers: \033[0;32m✓ $RUNNING running\033[0m"
    
    # Check specific Supabase containers
    for container in supabase-kong supabase-auth supabase-rest supabase-realtime supabase-storage; do
        if sudo docker ps | grep -q $container; then
            echo -e "    $container: \033[0;32m✓\033[0m"
        else
            echo -e "    $container: \033[0;31m✗\033[0m"
        fi
    done
else
    echo -e "  Docker: \033[0;31m✗ Not installed\033[0m"
fi
REMOTE_CHECK
echo ""

# HTTP Endpoints
echo -e "${YELLOW}[4] HTTP Endpoints${NC}"
check_http "http://${VPS_HOST}:8000" "Supabase Studio"
check_http "http://${VPS_HOST}" "Grafana"
check_http "http://${VPS_HOST}:9000" "MinIO"
echo ""

# System Resources
echo -e "${YELLOW}[5] System Resources${NC}"
ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << 'REMOTE_CHECK'
# CPU
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo -e "  CPU Usage: ${CPU_USAGE}%"

# Memory
MEM_INFO=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
echo -e "  Memory: ${MEM_INFO}"

# Disk
DISK_INFO=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 " used)"}')
echo -e "  Disk: ${DISK_INFO}"
REMOTE_CHECK
echo ""

echo -e "${GREEN}Health check completed${NC}"
