#!/usr/bin/env bash
set -euo pipefail

# ============================================
# GENERATE JWT KEYS FOR SUPABASE
# ============================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Generating JWT Secret and Keys for Supabase${NC}"
echo ""

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq
    else
        echo "Please install jq manually"
        exit 1
    fi
fi

# Generate JWT Secret (40+ characters)
JWT_SECRET=$(openssl rand -base64 32)

echo -e "${YELLOW}JWT_SECRET (add to .env):${NC}"
echo "$JWT_SECRET"
echo ""

# Generate ANON_KEY
ANON_PAYLOAD='{"role":"anon","iss":"supabase","iat":1641971400,"exp":4795571400}'
ANON_KEY=$(echo -n "$ANON_PAYLOAD" | openssl dgst -sha256 -hmac "$JWT_SECRET" -binary | base64 | tr -d '=' | tr '/+' '_-')

ANON_HEADER='{"alg":"HS256","typ":"JWT"}'
ANON_HEADER_B64=$(echo -n "$ANON_HEADER" | base64 | tr -d '=' | tr '/+' '_-')
ANON_PAYLOAD_B64=$(echo -n "$ANON_PAYLOAD" | base64 | tr -d '=' | tr '/+' '_-')
ANON_KEY="${ANON_HEADER_B64}.${ANON_PAYLOAD_B64}.${ANON_KEY}"

echo -e "${YELLOW}ANON_KEY (add to .env):${NC}"
echo "$ANON_KEY"
echo ""

# Generate SERVICE_ROLE_KEY
SERVICE_PAYLOAD='{"role":"service_role","iss":"supabase","iat":1641971400,"exp":4795571400}'
SERVICE_KEY=$(echo -n "$SERVICE_PAYLOAD" | openssl dgst -sha256 -hmac "$JWT_SECRET" -binary | base64 | tr -d '=' | tr '/+' '_-')

SERVICE_HEADER='{"alg":"HS256","typ":"JWT"}'
SERVICE_HEADER_B64=$(echo -n "$SERVICE_HEADER" | base64 | tr -d '=' | tr '/+' '_-')
SERVICE_PAYLOAD_B64=$(echo -n "$SERVICE_PAYLOAD" | base64 | tr -d '=' | tr '/+' '_-')
SERVICE_KEY="${SERVICE_HEADER_B64}.${SERVICE_PAYLOAD_B64}.${SERVICE_KEY}"

echo -e "${YELLOW}SERVICE_ROLE_KEY (add to .env):${NC}"
echo "$SERVICE_KEY"
echo ""

echo -e "${GREEN}Add these to your .env file:${NC}"
echo ""
echo "JWT_SECRET=\"$JWT_SECRET\""
echo "ANON_KEY=\"$ANON_KEY\""
echo "SERVICE_ROLE_KEY=\"$SERVICE_KEY\""
echo ""
