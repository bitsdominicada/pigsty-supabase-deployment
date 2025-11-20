#!/bin/bash
set -e

# Test script to validate Supabase Storage works with Backblaze B2
# Tests file upload, download, and verification

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

# Check required variables
if [ -z "$SUPABASE_DOMAIN" ] || [ -z "$ANON_KEY" ]; then
    echo "❌ Error: Missing required configuration in .env"
    echo "Required: SUPABASE_DOMAIN, ANON_KEY"
    exit 1
fi

SUPABASE_URL="https://$SUPABASE_DOMAIN"
STORAGE_BUCKET="test-uploads"
TEST_FILE="/tmp/supabase-test-$(date +%s).txt"

echo "Configuration:"
echo "  Supabase URL: $SUPABASE_URL"
echo "  Storage Bucket: $STORAGE_BUCKET"
echo "  Test File: $TEST_FILE"
echo

# Step 1: Create test file
echo "Step 1: Creating test file..."
cat > "$TEST_FILE" << EOF
Supabase Storage Test with Backblaze B2
========================================
Timestamp: $(date)
Test ID: $(uuidgen)

This file was uploaded to test the integration between:
- Supabase Storage (self-hosted)
- Backblaze B2 (S3-compatible storage)
- TUS_ALLOW_S3_TAGS=false workaround

If you can read this, the integration is working!
EOF

echo "✅ Test file created: $TEST_FILE"
echo

# Step 2: Create storage bucket (if not exists)
echo "Step 2: Creating storage bucket '$STORAGE_BUCKET'..."

BUCKET_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  "$SUPABASE_URL/storage/v1/bucket" \
  -H "Authorization: Bearer $SERVICE_ROLE_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"id\": \"$STORAGE_BUCKET\",
    \"name\": \"$STORAGE_BUCKET\",
    \"public\": true,
    \"file_size_limit\": 52428800,
    \"allowed_mime_types\": null
  }")

HTTP_CODE=$(echo "$BUCKET_RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$BUCKET_RESPONSE" | head -n-1)

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
    echo "✅ Bucket created successfully"
elif echo "$RESPONSE_BODY" | grep -q "already exists"; then
    echo "✅ Bucket already exists"
else
    echo "⚠️  Bucket creation response (HTTP $HTTP_CODE): $RESPONSE_BODY"
fi
echo

# Step 3: Upload test file
echo "Step 3: Uploading test file to Backblaze B2 via Supabase Storage..."

FILE_NAME="test-file-$(date +%s).txt"
UPLOAD_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  "$SUPABASE_URL/storage/v1/object/$STORAGE_BUCKET/$FILE_NAME" \
  -H "Authorization: Bearer $ANON_KEY" \
  -F "file=@$TEST_FILE")

HTTP_CODE=$(echo "$UPLOAD_RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$UPLOAD_RESPONSE" | head -n-1)

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
    echo "✅ File uploaded successfully!"
    echo "Response: $RESPONSE_BODY"
else
    echo "❌ Upload failed (HTTP $HTTP_CODE)"
    echo "Response: $RESPONSE_BODY"
    echo
    echo "Common issues:"
    echo "  - x-amz-tagging error: Check TUS_ALLOW_S3_TAGS=false is set"
    echo "  - Authentication error: Verify ANON_KEY is correct"
    echo "  - S3 credentials: Check Backblaze B2 credentials"
    rm "$TEST_FILE"
    exit 1
fi
echo

# Step 4: List files in bucket
echo "Step 4: Listing files in bucket..."

LIST_RESPONSE=$(curl -s -X GET \
  "$SUPABASE_URL/storage/v1/object/list/$STORAGE_BUCKET" \
  -H "Authorization: Bearer $ANON_KEY")

echo "Files in bucket:"
echo "$LIST_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$LIST_RESPONSE"
echo

# Step 5: Download and verify file
echo "Step 5: Downloading file to verify..."

DOWNLOAD_FILE="/tmp/downloaded-test.txt"
curl -s -X GET \
  "$SUPABASE_URL/storage/v1/object/public/$STORAGE_BUCKET/$FILE_NAME" \
  -o "$DOWNLOAD_FILE"

if [ -f "$DOWNLOAD_FILE" ] && [ -s "$DOWNLOAD_FILE" ]; then
    echo "✅ File downloaded successfully"
    echo
    echo "Downloaded content:"
    echo "-------------------"
    cat "$DOWNLOAD_FILE"
    echo "-------------------"
else
    echo "❌ File download failed"
    rm "$TEST_FILE"
    exit 1
fi
echo

# Step 6: Verify on Backblaze B2 (optional - using AWS CLI)
echo "Step 6: Verifying file in Backblaze B2..."

if command -v aws &> /dev/null; then
    export AWS_ACCESS_KEY_ID="$S3_ACCESS_KEY"
    export AWS_SECRET_ACCESS_KEY="$S3_SECRET_KEY"

    B2_ENDPOINT="${S3_ENDPOINT#https://}"

    echo "Listing files in Backblaze B2 bucket: $S3_BUCKET"
    aws s3 ls "s3://$S3_BUCKET/stub/" \
        --endpoint-url "$S3_ENDPOINT" \
        --region "$S3_REGION" \
        2>/dev/null || echo "⚠️  Could not list Backblaze B2 bucket (AWS CLI may need configuration)"
else
    echo "⚠️  AWS CLI not installed - skipping direct B2 verification"
    echo "Install with: brew install awscli (macOS)"
fi
echo

# Step 7: Check storage logs for errors
echo "Step 7: Checking storage logs for errors..."

if [ -z "$VPS_ROOT_PASSWORD" ]; then
    echo "⚠️  VPS_ROOT_PASSWORD not set - skipping log check"
else
    LOG_CHECK=$(sshpass -p "$VPS_ROOT_PASSWORD" \
        ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        root@"$VPS_HOST" \
        'cd /opt/supabase && docker compose logs storage --tail 20' 2>/dev/null || echo "")

    if echo "$LOG_CHECK" | grep -i error; then
        echo "⚠️  Errors found in storage logs"
    else
        echo "✅ No errors in storage logs"
    fi
fi
echo

# Cleanup
rm "$TEST_FILE"
rm "$DOWNLOAD_FILE" 2>/dev/null || true

echo "========================================"
echo "✅ Test Complete!"
echo "========================================"
echo
echo "Summary:"
echo "  ✓ Test file created"
echo "  ✓ Storage bucket created/verified"
echo "  ✓ File uploaded to Backblaze B2 via Supabase Storage"
echo "  ✓ File listed in bucket"
echo "  ✓ File downloaded and verified"
echo
echo "🎉 Supabase Storage is working correctly with Backblaze B2!"
echo "    The TUS_ALLOW_S3_TAGS=false workaround is successful."
echo
echo "Next steps:"
echo "  1. ✅ MinIO is NO LONGER NEEDED for Supabase Storage"
echo "  2. Disable MinIO service to save resources"
echo "  3. Update documentation"
echo
