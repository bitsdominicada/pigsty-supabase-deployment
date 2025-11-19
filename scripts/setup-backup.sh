#!/usr/bin/env bash
set -euo pipefail

# ============================================
# SETUP AUTOMATED BACKUPS
# ============================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found!${NC}"
    exit 1
fi

source .env

echo -e "${GREEN}Setting up automated backups...${NC}"

ssh -i ~/.ssh/pigsty_deploy ${DEPLOY_USER}@${VPS_HOST} << REMOTE_SCRIPT
set -e

# Verify pgBackRest is configured
if ! command -v pgbackrest &> /dev/null; then
    echo "pgBackRest not found. Install Pigsty first."
    exit 1
fi

# Create backup script
sudo tee /usr/local/bin/pigsty-backup.sh > /dev/null << 'BACKUP_SCRIPT'
#!/bin/bash
set -e

BACKUP_TYPE=\${1:-full}
LOG_FILE=/var/log/pigsty-backup.log

echo "[\$(date)] Starting \${BACKUP_TYPE} backup" | tee -a \$LOG_FILE

# Run backup
/pg/bin/pg-backup \${BACKUP_TYPE} 2>&1 | tee -a \$LOG_FILE

# Check backup status
if [ \${PIPESTATUS[0]} -eq 0 ]; then
    echo "[\$(date)] Backup completed successfully" | tee -a \$LOG_FILE
else
    echo "[\$(date)] Backup failed" | tee -a \$LOG_FILE
    exit 1
fi
BACKUP_SCRIPT

sudo chmod +x /usr/local/bin/pigsty-backup.sh

# Setup cron job for daily backups
CRON_SCHEDULE="${BACKUP_SCHEDULE}"
CRON_JOB="\${CRON_SCHEDULE} /usr/local/bin/pigsty-backup.sh full >> /var/log/pigsty-backup.log 2>&1"

# Add to postgres user crontab
(sudo -u postgres crontab -l 2>/dev/null || true; echo "\$CRON_JOB") | sudo -u postgres crontab -

echo "Backup cron job installed for postgres user"
echo "Schedule: ${BACKUP_SCHEDULE}"

# Test backup
echo "Running test backup..."
sudo -u postgres /usr/local/bin/pigsty-backup.sh full

echo "Backup setup completed successfully"
REMOTE_SCRIPT

echo -e "${GREEN}Automated backups configured!${NC}"
echo -e "Schedule: ${YELLOW}${BACKUP_SCHEDULE}${NC}"
echo -e "Retention: ${YELLOW}${BACKUP_RETENTION_DAYS} days${NC}"
