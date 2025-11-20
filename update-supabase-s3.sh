#!/bin/bash

# Update Supabase .env with Backblaze B2 credentials
# Execute: ssh deploy@194.163.149.70 'bash -s' < update-supabase-s3.sh

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Updating Supabase Storage to Backblaze B2"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd /opt/supabase

echo "[1/3] Updating S3 configuration in .env..."

# Update S3 configuration
sudo sed -i 's|^S3_BUCKET=.*|S3_BUCKET=bits-supabase-storage|' .env
sudo sed -i 's|^S3_ENDPOINT=.*|S3_ENDPOINT=https://s3.us-east-005.backblazeb2.com|' .env
sudo sed -i 's|^S3_REGION=.*|S3_REGION=us-east-005|' .env
sudo sed -i 's|^S3_ACCESS_KEY=.*|S3_ACCESS_KEY=0054f413fc50d980000000005|' .env
sudo sed -i 's|^S3_SECRET_KEY=.*|S3_SECRET_KEY=K005QH3QznmevY7wUCOU7r5NFmv9Q2U|' .env
sudo sed -i 's|^S3_FORCE_PATH_STYLE=.*|S3_FORCE_PATH_STYLE=false|' .env
sudo sed -i 's|^S3_PROTOCOL=.*|S3_PROTOCOL=https|' .env

# Remove MINIO_DOMAIN_IP as we're not using MinIO
sudo sed -i '/^MINIO_DOMAIN_IP=/d' .env

echo "✓ S3 configuration updated"

echo ""
echo "[2/3] Verifying new configuration..."
echo ""
grep "^S3_" .env
echo ""

echo "[3/3] Restarting Supabase containers..."
sudo docker compose down
sudo docker compose up -d

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Supabase Storage updated to Backblaze B2"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Waiting for containers to start..."
sleep 10
sudo docker compose ps
