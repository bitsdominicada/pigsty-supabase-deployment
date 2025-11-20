#!/bin/bash
set -e

# Script to recreate the Supabase Storage container with new Backblaze B2 configuration
# This ensures the container picks up the updated environment variables

echo "========================================"
echo "Recreate Storage Container with B2 Config"
echo "========================================"
echo

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    exit 1
fi

# Source environment variables
source .env

if [ -z "$VPS_ROOT_PASSWORD" ] || [ -z "$VPS_HOST" ]; then
    echo "❌ Error: VPS_ROOT_PASSWORD or VPS_HOST not set in .env"
    exit 1
fi

# SSH helper function
ssh_root() {
    sshpass -p "$VPS_ROOT_PASSWORD" \
        ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        root@"$VPS_HOST" "$@"
}

echo "Step 1: Stopping storage container..."
ssh_root << 'ENDSSH1'
cd /opt/supabase
docker compose stop storage
docker compose rm -f storage
echo "✅ Storage container stopped and removed"
ENDSSH1

echo
echo "Step 2: Recreating storage container with new configuration..."
ssh_root << 'ENDSSH2'
cd /opt/supabase
docker compose up -d storage
echo "✅ Storage container recreated"
ENDSSH2

echo
echo "Step 3: Waiting for storage to be healthy..."
sleep 15

ssh_root << 'ENDSSH3'
cd /opt/supabase
echo "Storage container status:"
docker compose ps storage
echo
echo "Storage environment variables:"
docker compose exec storage env | grep -E "GLOBAL_S3|TUS_ALLOW" | sort
ENDSSH3

echo
echo "========================================"
echo "✅ Storage Container Recreated"
echo "========================================"
echo
echo "The storage container is now using Backblaze B2 configuration."
echo "Run ./test-storage-simple.sh to test file uploads."
