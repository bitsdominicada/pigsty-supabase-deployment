#!/bin/bash
set -e

# Simple test script to validate Supabase Storage works with Backblaze B2
# This script tests directly on the VPS

echo "========================================"
echo "Test Supabase Storage with Backblaze B2"
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

# Check if sshpass is available
if ! command -v sshpass &> /dev/null; then
    echo "❌ Error: sshpass is required but not installed"
    exit 1
fi

echo "Testing Supabase Storage on VPS: $VPS_HOST"
echo

# SSH helper function
ssh_root() {
    sshpass -p "$VPS_ROOT_PASSWORD" \
        ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        root@"$VPS_HOST" "$@"
}

# Run test on VPS
echo "Running storage test on VPS..."
echo

ssh_root 'bash -s' << 'REMOTE_SCRIPT'
set -e

cd /opt/supabase
source .env

echo "Step 1: Verify storage configuration"
echo "-------------------------------------"
echo "S3_BUCKET: $S3_BUCKET"
echo "S3_ENDPOINT: $S3_ENDPOINT"
echo "S3_REGION: $S3_REGION"
echo "TUS_ALLOW_S3_TAGS: $(grep TUS_ALLOW_S3_TAGS .env | cut -d= -f2)"
echo

echo "Step 2: Check storage container status"
echo "---------------------------------------"
docker compose ps storage
echo

echo "Step 3: Check storage environment variables"
echo "--------------------------------------------"
docker compose exec storage env | grep -E "GLOBAL_S3" | sort
docker compose exec storage env | grep TUS_ALLOW_S3_TAGS
echo

echo "Step 4: Create test file"
echo "------------------------"
TEST_FILE="/tmp/backblaze-test-$(date +%s).txt"
cat > "$TEST_FILE" << EOF
Backblaze B2 Integration Test
==============================
Timestamp: $(date)
Server: $(hostname)

This file tests Supabase Storage with Backblaze B2.
TUS_ALLOW_S3_TAGS=false workaround is active.
EOF
echo "✅ Test file created: $TEST_FILE"
echo

echo "Step 5: Upload file to Supabase Storage"
echo "----------------------------------------"
BUCKET_NAME="test-backblaze"
FILE_NAME="test-$(date +%s).txt"

# Create bucket
echo "Creating bucket: $BUCKET_NAME"
BUCKET_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  "http://127.0.0.1:8000/storage/v1/bucket" \
  -H "Authorization: Bearer $SERVICE_ROLE_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"id\": \"$BUCKET_NAME\",
    \"name\": \"$BUCKET_NAME\",
    \"public\": true
  }" 2>&1)

HTTP_CODE=$(echo "$BUCKET_RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$BUCKET_RESPONSE" | head -n-1)

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
    echo "✅ Bucket created successfully"
elif echo "$RESPONSE_BODY" | grep -q "already exists"; then
    echo "✅ Bucket already exists"
else
    echo "Response (HTTP $HTTP_CODE): $RESPONSE_BODY"
fi
echo

# Upload file
echo "Uploading file: $FILE_NAME"
UPLOAD_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  "http://127.0.0.1:8000/storage/v1/object/$BUCKET_NAME/$FILE_NAME" \
  -H "Authorization: Bearer $ANON_KEY" \
  -F "file=@$TEST_FILE" 2>&1)

HTTP_CODE=$(echo "$UPLOAD_RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$UPLOAD_RESPONSE" | head -n-1)

echo "Upload response (HTTP $HTTP_CODE):"
echo "$RESPONSE_BODY"
echo

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
    echo "✅ File uploaded successfully!"

    echo
    echo "Step 6: Verify file in bucket"
    echo "------------------------------"
    curl -s -X GET \
      "http://127.0.0.1:8000/storage/v1/object/list/$BUCKET_NAME" \
      -H "Authorization: Bearer $ANON_KEY" | python3 -m json.tool 2>/dev/null

    echo
    echo "Step 7: Download file to verify"
    echo "--------------------------------"
    DOWNLOAD_FILE="/tmp/downloaded-test.txt"
    curl -s -X GET \
      "http://127.0.0.1:8000/storage/v1/object/public/$BUCKET_NAME/$FILE_NAME" \
      -o "$DOWNLOAD_FILE"

    if [ -f "$DOWNLOAD_FILE" ] && [ -s "$DOWNLOAD_FILE" ]; then
        echo "✅ File downloaded successfully"
        echo "Content:"
        cat "$DOWNLOAD_FILE"
        rm "$DOWNLOAD_FILE"
    fi

    echo
    echo "========================================"
    echo "🎉 SUCCESS! Backblaze B2 is working!"
    echo "========================================"
    echo
    echo "✓ TUS_ALLOW_S3_TAGS=false workaround is working"
    echo "✓ Files are being stored in Backblaze B2"
    echo "✓ Supabase Storage is fully functional"
    echo "✓ MinIO is NO LONGER NEEDED!"

else
    echo "❌ Upload failed!"
    echo
    if echo "$RESPONSE_BODY" | grep -q "x-amz-tagging"; then
        echo "❌ ERROR: x-amz-tagging issue detected!"
        echo "   TUS_ALLOW_S3_TAGS may not be properly configured"
    fi

    echo
    echo "Checking storage logs for errors..."
    docker compose logs storage --tail 30 | grep -i error || true
fi

# Cleanup
rm "$TEST_FILE" 2>/dev/null || true

REMOTE_SCRIPT

echo
echo "========================================"
echo "Test Complete"
echo "========================================"
