#!/usr/bin/env bash

# ============================================
# MODULE: Configure Backblaze B2 Storage
# ============================================
# Configures Supabase Storage to use Backblaze B2
# Adds TUS_ALLOW_S3_TAGS=false for compatibility

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

configure_b2_storage() {
    log_step "Configure Backblaze B2 Storage"

    load_env

    # Check if Backblaze B2 is configured
    if [ -z "${S3_BUCKET:-}" ] || [ -z "${S3_ENDPOINT:-}" ]; then
        log_warning "Backblaze B2 not configured in .env - skipping"
        log_info "To enable Backblaze B2, set S3_BUCKET, S3_ENDPOINT, S3_ACCESS_KEY, S3_SECRET_KEY"
        return 0
    fi

    # Check if using Backblaze B2 (not MinIO)
    if [[ "${S3_ENDPOINT}" == *"backblazeb2.com"* ]]; then
        log_info "Detected Backblaze B2 configuration"
        log_info "Endpoint: ${S3_ENDPOINT}"
        log_info "Bucket: ${S3_BUCKET}"
    elif [[ "${S3_ENDPOINT}" == *"sss.pigsty"* ]] || [[ "${S3_ENDPOINT}" == *":9000"* ]]; then
        log_info "MinIO detected - TUS_ALLOW_S3_TAGS not needed"
        return 0
    else
        log_info "S3-compatible storage detected: ${S3_ENDPOINT}"
        log_info "Applying TUS_ALLOW_S3_TAGS=false for compatibility"
    fi

    # Step 1: Update /opt/supabase/.env with Backblaze B2 configuration
    log_info "Updating Supabase .env with Backblaze B2 configuration..."

    ssh_exec << REMOTE
set -e
cd /opt/supabase

# Backup current .env
sudo cp .env .env.backup.\$(date +%Y%m%d_%H%M%S)

# Remove old S3 configuration
sudo sed -i '/^S3_BUCKET=/d' .env
sudo sed -i '/^S3_ENDPOINT=/d' .env
sudo sed -i '/^S3_REGION=/d' .env
sudo sed -i '/^S3_ACCESS_KEY=/d' .env
sudo sed -i '/^S3_SECRET_KEY=/d' .env
sudo sed -i '/^S3_FORCE_PATH_STYLE=/d' .env
sudo sed -i '/^S3_PROTOCOL=/d' .env
sudo sed -i '/^TUS_ALLOW_S3_TAGS=/d' .env
sudo sed -i '/^MINIO_DOMAIN_IP=/d' .env

# Add Backblaze B2 configuration
sudo tee -a .env > /dev/null << 'EOF'

# Backblaze B2 Configuration
S3_BUCKET=${S3_BUCKET}
S3_ENDPOINT=${S3_ENDPOINT}
S3_REGION=${S3_REGION}
S3_ACCESS_KEY=${S3_ACCESS_KEY}
S3_SECRET_KEY=${S3_SECRET_KEY}
S3_FORCE_PATH_STYLE=${S3_FORCE_PATH_STYLE:-false}
S3_PROTOCOL=${S3_PROTOCOL:-https}

# Disable S3 tagging for Backblaze B2 compatibility
# This prevents "x-amz-tagging not supported" errors
TUS_ALLOW_S3_TAGS=false

# Placeholder for Docker Compose (not used but prevents warnings)
MINIO_DOMAIN_IP=127.0.0.1
EOF

# Substitute actual values
sudo sed -i "s|\\\${S3_BUCKET}|${S3_BUCKET}|g" .env
sudo sed -i "s|\\\${S3_ENDPOINT}|${S3_ENDPOINT}|g" .env
sudo sed -i "s|\\\${S3_REGION}|${S3_REGION}|g" .env
sudo sed -i "s|\\\${S3_ACCESS_KEY}|${S3_ACCESS_KEY}|g" .env
sudo sed -i "s|\\\${S3_SECRET_KEY}|${S3_SECRET_KEY}|g" .env
sudo sed -i "s|\\\${S3_FORCE_PATH_STYLE}|${S3_FORCE_PATH_STYLE:-false}|g" .env
sudo sed -i "s|\\\${S3_PROTOCOL}|${S3_PROTOCOL:-https}|g" .env

echo "✅ Updated .env file"
REMOTE

    log_success "Supabase .env updated"

    # Step 2: Update docker-compose.yml to include TUS_ALLOW_S3_TAGS
    log_info "Updating docker-compose.yml with TUS_ALLOW_S3_TAGS..."

    ssh_exec << 'REMOTE'
set -e
cd /opt/supabase

# Backup docker-compose.yml
sudo cp docker-compose.yml docker-compose.yml.backup.$(date +%Y%m%d_%H%M%S)

# Check if TUS_ALLOW_S3_TAGS already exists
if grep -q "TUS_ALLOW_S3_TAGS" docker-compose.yml; then
    echo "✅ TUS_ALLOW_S3_TAGS already configured"
else
    # Add TUS_ALLOW_S3_TAGS to storage service using Python
    python3 << 'EOFPYTHON'
import yaml
import sys

try:
    with open('docker-compose.yml', 'r') as f:
        compose = yaml.safe_load(f)

    if 'services' in compose and 'storage' in compose['services']:
        if 'environment' not in compose['services']['storage']:
            compose['services']['storage']['environment'] = {}

        # Add TUS_ALLOW_S3_TAGS
        compose['services']['storage']['environment']['TUS_ALLOW_S3_TAGS'] = 'false'

        with open('docker-compose.yml', 'w') as f:
            yaml.dump(compose, f, default_flow_style=False, sort_keys=False)

        print("✅ Added TUS_ALLOW_S3_TAGS=false to storage service")
    else:
        print("❌ Storage service not found in docker-compose.yml")
        sys.exit(1)
except Exception as e:
    print(f"❌ Error: {e}")
    sys.exit(1)
EOFPYTHON
fi
REMOTE

    log_success "docker-compose.yml updated"

    # Step 3: Recreate storage container
    log_info "Recreating storage container with new configuration..."

    ssh_exec << 'REMOTE'
set -e
cd /opt/supabase

# Stop and remove storage container
docker compose stop storage
docker compose rm -f storage

# Recreate storage container
docker compose up -d storage

echo "✅ Storage container recreated"
REMOTE

    log_success "Storage container recreated"

    # Step 4: Wait for storage to be healthy
    log_info "Waiting for storage service to be healthy..."
    sleep 15

    # Step 5: Verify configuration
    log_info "Verifying configuration..."

    ssh_exec << 'REMOTE'
set -e
cd /opt/supabase

echo ""
echo "Storage Container Status:"
docker compose ps storage

echo ""
echo "Storage Environment Variables:"
docker compose exec storage env | grep -E "GLOBAL_S3|TUS_ALLOW" | sort || true

echo ""
echo "Configuration in .env:"
grep -E "^(S3_BUCKET|S3_ENDPOINT|TUS_ALLOW_S3_TAGS)=" .env
REMOTE

    log_success "Backblaze B2 storage configured successfully"

    cat << INFO

${GREEN}✅ Backblaze B2 Storage Configured${NC}

Configuration:
  Endpoint: ${S3_ENDPOINT}
  Bucket:   ${S3_BUCKET}
  Region:   ${S3_REGION}

${YELLOW}Important:${NC}
  • TUS_ALLOW_S3_TAGS=false is now active
  • This prevents "x-amz-tagging not supported" errors
  • Supabase Storage now works directly with Backblaze B2
  • MinIO is NO LONGER NEEDED for storage

${BLUE}Test Upload:${NC}
  Run: ./test-storage-simple.sh

${BLUE}Documentation:${NC}
  • docs/STORAGE_ARCHITECTURE.md
  • docs/BACKBLAZE_B2_SUCCESS.md

INFO
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    configure_b2_storage
fi
