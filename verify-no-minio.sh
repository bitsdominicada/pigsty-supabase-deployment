#!/bin/bash

# Verification script to ensure MinIO is not being used

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  System Verification - NO MinIO Usage"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "✓ CHECK 1: Supabase Storage Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat /opt/supabase/.env | grep "^S3_"
echo ""

echo "✓ CHECK 2: pgBackRest Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
sudo -iu postgres cat /etc/pgbackrest/pgbackrest.conf | grep -A 15 "^repo1"
echo ""

echo "✓ CHECK 3: pgBackRest Backup Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
sudo -iu postgres pgbackrest --stanza=pg-meta info | head -20
echo ""

echo "✓ CHECK 4: Supabase Containers Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cd /opt/supabase && sudo docker compose ps | grep -E "(storage|healthy)"
echo ""

echo "✓ CHECK 5: MinIO Service Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if systemctl is-active --quiet minio; then
    echo "⚠️  WARNING: MinIO service is running"
    echo "   You can stop it with: sudo systemctl stop minio"
    echo "   Disable at boot: sudo systemctl disable minio"
else
    echo "✓ MinIO service is NOT running (as expected)"
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if using Backblaze
if grep -q "s3.us-east-005.backblazeb2.com" /opt/supabase/.env; then
    echo "✓ Supabase Storage: Using Backblaze B2"
else
    echo "✗ Supabase Storage: NOT using Backblaze B2"
fi

if grep -q "s3.us-east-005.backblazeb2.com" /etc/pgbackrest/pgbackrest.conf; then
    echo "✓ pgBackRest: Using Backblaze B2"
else
    echo "✗ pgBackRest: NOT using Backblaze B2"
fi

if sudo -iu postgres pgbackrest --stanza=pg-meta info | grep -q "status: ok"; then
    echo "✓ pgBackRest: Backups OK"
else
    echo "✗ pgBackRest: Backup issues detected"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
