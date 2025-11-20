#!/bin/bash
set -e

# Script to enable Backblaze B2 for Supabase Storage by disabling S3 tagging
# This solves the x-amz-tagging incompatibility issue

echo "=========================================="
echo "Enable Backblaze B2 for Supabase Storage"
echo "=========================================="
echo

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    exit 1
fi

# Source environment variables
source .env

# Check required variables
if [ -z "$S3_BUCKET" ] || [ -z "$S3_ENDPOINT" ] || [ -z "$S3_ACCESS_KEY" ] || [ -z "$S3_SECRET_KEY" ]; then
    echo "❌ Error: Missing required S3 configuration in .env"
    echo "Required: S3_BUCKET, S3_ENDPOINT, S3_ACCESS_KEY, S3_SECRET_KEY"
    exit 1
fi

if [ -z "$VPS_ROOT_PASSWORD" ]; then
    echo "❌ Error: VPS_ROOT_PASSWORD not set in .env"
    exit 1
fi

# Check if sshpass is available
if ! command -v sshpass &> /dev/null; then
    echo "❌ Error: sshpass is required but not installed"
    echo "Install with: brew install hudochenkov/sshpass/sshpass (macOS)"
    exit 1
fi

echo "Configuration:"
echo "  S3_BUCKET: $S3_BUCKET"
echo "  S3_ENDPOINT: $S3_ENDPOINT"
echo "  S3_REGION: $S3_REGION"
echo

# SSH helper function
ssh_root() {
    sshpass -p "$VPS_ROOT_PASSWORD" \
        ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        root@"$VPS_HOST" "$@"
}

# Step 1: Update Supabase .env file with Backblaze B2 configuration
echo "Step 1: Updating Supabase Storage configuration..."

ssh_root << 'ENDSSH'
cd /opt/supabase

# Backup current .env
cp .env .env.backup.$(date +%Y%m%d_%H%M%S)

# Update S3 configuration for Backblaze B2
cat > /tmp/s3_config.txt << 'EOF'
# Backblaze B2 Configuration for Supabase Storage
S3_BUCKET=${S3_BUCKET}
S3_ENDPOINT=${S3_ENDPOINT}
S3_REGION=${S3_REGION}
S3_ACCESS_KEY=${S3_ACCESS_KEY}
S3_SECRET_KEY=${S3_SECRET_KEY}
S3_FORCE_PATH_STYLE=false
S3_PROTOCOL=https

# Disable S3 tagging for Backblaze B2 compatibility
# This prevents the "x-amz-tagging not supported" error
TUS_ALLOW_S3_TAGS=false
EOF

# Remove old S3 configuration
sed -i '/^S3_BUCKET=/d' .env
sed -i '/^S3_ENDPOINT=/d' .env
sed -i '/^S3_REGION=/d' .env
sed -i '/^S3_ACCESS_KEY=/d' .env
sed -i '/^S3_SECRET_KEY=/d' .env
sed -i '/^S3_FORCE_PATH_STYLE=/d' .env
sed -i '/^S3_PROTOCOL=/d' .env
sed -i '/^TUS_ALLOW_S3_TAGS=/d' .env
sed -i '/^MINIO_DOMAIN_IP=/d' .env

# Add new configuration
cat /tmp/s3_config.txt >> .env
rm /tmp/s3_config.txt

echo "✅ Updated Supabase .env file"
ENDSSH

# Substitute actual values
ssh_root << ENDSSH2
cd /opt/supabase
sed -i "s|\\\${S3_BUCKET}|$S3_BUCKET|g" .env
sed -i "s|\\\${S3_ENDPOINT}|$S3_ENDPOINT|g" .env
sed -i "s|\\\${S3_REGION}|$S3_REGION|g" .env
sed -i "s|\\\${S3_ACCESS_KEY}|$S3_ACCESS_KEY|g" .env
sed -i "s|\\\${S3_SECRET_KEY}|$S3_SECRET_KEY|g" .env
ENDSSH2

# Step 2: Update docker-compose.yml to add TUS_ALLOW_S3_TAGS to storage service
echo
echo "Step 2: Updating docker-compose.yml..."

ssh_root << 'ENDSSH3'
cd /opt/supabase

# Backup docker-compose.yml
cp docker-compose.yml docker-compose.yml.backup.$(date +%Y%m%d_%H%M%S)

# Check if TUS_ALLOW_S3_TAGS is already in docker-compose.yml
if grep -q "TUS_ALLOW_S3_TAGS" docker-compose.yml; then
    echo "✅ TUS_ALLOW_S3_TAGS already in docker-compose.yml"
else
    # Add TUS_ALLOW_S3_TAGS to storage service environment
    # Find the storage service and add the variable
    python3 << 'EOFPYTHON'
import yaml
import sys

try:
    with open('docker-compose.yml', 'r') as f:
        compose = yaml.safe_load(f)

    if 'services' in compose and 'storage' in compose['services']:
        if 'environment' not in compose['services']['storage']:
            compose['services']['storage']['environment'] = {}

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
ENDSSH3

# Step 3: Restart Supabase Storage service
echo
echo "Step 3: Restarting Supabase Storage service..."

ssh_root << 'ENDSSH4'
cd /opt/supabase
docker compose restart storage

echo
echo "Waiting for storage service to be ready..."
sleep 10

# Check storage service status
docker compose ps storage
ENDSSH4

echo
echo "=========================================="
echo "✅ Configuration Complete!"
echo "=========================================="
echo
echo "Supabase Storage is now configured to use Backblaze B2"
echo "The TUS_ALLOW_S3_TAGS=false setting prevents the x-amz-tagging error"
echo
echo "Next steps:"
echo "1. Test file upload through Supabase Dashboard"
echo "2. Verify files are stored in Backblaze B2"
echo "3. If successful, disable MinIO service"
echo
echo "To verify the configuration:"
echo "  sshpass -p \"$VPS_ROOT_PASSWORD\" ssh -o StrictHostKeyChecking=no root@$VPS_HOST 'cd /opt/supabase && cat .env | grep -A 10 S3_BUCKET'"
echo
