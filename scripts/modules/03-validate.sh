#!/usr/bin/env bash

# ============================================
# MODULE: Validation
# ============================================
# Validates pigsty.yml and generates Supabase .env

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/utils.sh"

validate_deployment() {
    log_step "Validation"

    load_env

    log_info "Validating pigsty.yml on VPS..."

    # Run all validations on VPS
    ssh_exec << 'VALIDATE'
set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Configuration Validation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# 1. YAML Syntax
echo "1. Validating YAML syntax..."
if python3 -c "import yaml; yaml.safe_load(open('pigsty/pigsty.yml'))" 2>/dev/null; then
    echo "   ✅ YAML syntax is valid"
else
    echo "   ❌ YAML syntax error!"
    exit 1
fi
echo

# 2. Check for unreplaced IPs
echo "2. Checking for unreplaced IPs..."
if grep -q "10\.10\.10\.10" ~/pigsty/pigsty.yml; then
    OLD_IP_COUNT=$(grep -c "10\.10\.10\.10" ~/pigsty/pigsty.yml)
    echo "   ❌ Found $OLD_IP_COUNT references to 10.10.10.10"
    exit 1
else
    echo "   ✅ No references to 10.10.10.10 found"
fi
echo

# 3. Validate endpoint format
echo "3. Validating Supabase endpoint..."
ENDPOINT=$(grep "endpoint.*8000" ~/pigsty/pigsty.yml | head -1)
if echo "$ENDPOINT" | grep -q '".*:8000"'; then
    echo "   ✅ Endpoint format correct: $ENDPOINT"
else
    echo "   ❌ Endpoint format incorrect: $ENDPOINT"
    echo "   Expected: endpoint: \"IP:8000\""
    exit 1
fi
echo

# 4. Check domain configuration
echo "4. Checking domain configuration..."
DOMAIN_COUNT=$(grep -c "bitsflaredb.bits.do" ~/pigsty/pigsty.yml || echo "0")
if [ "$DOMAIN_COUNT" -ge 3 ]; then
    echo "   ✅ Domain configured ($DOMAIN_COUNT references)"
else
    echo "   ⚠️  Domain has only $DOMAIN_COUNT references (expected >= 3)"
fi
echo

# 5. Verify SSL/Certbot
echo "5. Verifying SSL configuration..."
if grep -q "certbot_sign: true" ~/pigsty/pigsty.yml; then
    CERTBOT_EMAIL=$(grep "certbot_email:" ~/pigsty/pigsty.yml | awk '{print $2}')
    echo "   ✅ Certbot enabled with email: $CERTBOT_EMAIL"
else
    echo "   ⚠️  Certbot not enabled"
fi
echo

# 6. Verify Backblaze B2
echo "6. Verifying Backblaze B2 configuration..."
if grep -q "s3.us-east-005.backblazeb2.com" ~/pigsty/pigsty.yml; then
    S3_BUCKET=$(grep "S3_BUCKET:" ~/pigsty/pigsty.yml | head -1 | awk '{print $2}')
    echo "   ✅ Backblaze B2 configured (bucket: $S3_BUCKET)"
else
    echo "   ❌ Backblaze B2 endpoint not found"
    exit 1
fi
echo

# 7. Verify JWT tokens are on separate lines
echo "7. Verifying JWT token formatting..."
JWT_LINE=$(grep -n "JWT_SECRET:" ~/pigsty/pigsty.yml | grep -v "^#" | head -1 | cut -d: -f1)
ANON_LINE=$(grep -n "ANON_KEY:" ~/pigsty/pigsty.yml | grep -v "^#" | head -1 | cut -d: -f1)
SERVICE_LINE=$(grep -n "SERVICE_ROLE_KEY:" ~/pigsty/pigsty.yml | grep -v "^#" | head -1 | cut -d: -f1)

if [ "$((ANON_LINE - JWT_LINE))" -eq 1 ] && [ "$((SERVICE_LINE - ANON_LINE))" -eq 1 ]; then
    echo "   ✅ JWT tokens on separate consecutive lines"
else
    echo "   ⚠️  JWT tokens spacing: JWT=$JWT_LINE, ANON=$ANON_LINE, SERVICE=$SERVICE_LINE"
fi
echo

# 8. Generate Supabase .env preview
echo "8. Generating Supabase .env preview..."
awk '/conf:.*override \/opt\/supabase\/\.env/,/POSTGRES_PASSWORD:/ {print}' ~/pigsty/pigsty.yml | \
    grep -E '^\s+[A-Z_]+:' | \
    sed 's/^[[:space:]]*//' | \
    sed 's/#.*//' | \
    sed 's/[[:space:]]*$//' | \
    sed 's/: /=/' > /tmp/supabase-preview.env

ENV_COUNT=$(wc -l < /tmp/supabase-preview.env)
echo "   ✅ Generated .env with $ENV_COUNT variables"
echo
echo "   Preview (first 5 lines):"
head -5 /tmp/supabase-preview.env | sed 's/^/      /'
echo "      ..."
echo

# 9. Ansible inventory check
echo "9. Checking Ansible inventory..."
if cd ~/pigsty && ansible-inventory --list >/dev/null 2>&1; then
    echo "   ✅ Ansible can parse inventory"
else
    echo "   ❌ Ansible inventory parse error"
    exit 1
fi
echo

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ All validations passed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
VALIDATE

    log_success "Configuration validated successfully"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    validate_deployment
fi
