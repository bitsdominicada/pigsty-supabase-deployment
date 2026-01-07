#!/usr/bin/env bash

# ============================================
# CLOUDFLARE DNS AUTOMATION
# ============================================
# Creates DNS records for client subdomains
# Usage: ./cloudflare-dns.sh <client_name> <vps_ip>

set -euo pipefail

# Colors
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Cloudflare Configuration
readonly CF_API_TOKEN="8vISDbXSJgcZk2u4Xb1M3qz6Wgy0zrZ49SuG0V0x"
readonly CF_ZONE_ID="${CF_ZONE_ID:-}"  # Will be set below
readonly BASE_DOMAIN="bitsneura.com"

# ============================================
# FUNCTIONS
# ============================================

log_info() { echo -e "${CYAN}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# Create a DNS A record
create_dns_record() {
    local name="$1"
    local ip="$2"
    local zone_id="$3"

    # Check if record already exists
    local existing=$(curl -s -X GET \
        "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records?type=A&name=${name}.${BASE_DOMAIN}" \
        -H "Authorization: Bearer ${CF_API_TOKEN}" \
        -H "Content-Type: application/json" | jq -r '.result[0].id // empty')

    if [ -n "$existing" ]; then
        # Update existing record
        log_info "Updating existing record: ${name}.${BASE_DOMAIN}"
        local response=$(curl -s -X PUT \
            "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records/${existing}" \
            -H "Authorization: Bearer ${CF_API_TOKEN}" \
            -H "Content-Type: application/json" \
            --data "{
                \"type\": \"A\",
                \"name\": \"${name}\",
                \"content\": \"${ip}\",
                \"ttl\": 300,
                \"proxied\": false
            }")
    else
        # Create new record
        log_info "Creating record: ${name}.${BASE_DOMAIN} → ${ip}"
        local response=$(curl -s -X POST \
            "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records" \
            -H "Authorization: Bearer ${CF_API_TOKEN}" \
            -H "Content-Type: application/json" \
            --data "{
                \"type\": \"A\",
                \"name\": \"${name}\",
                \"content\": \"${ip}\",
                \"ttl\": 300,
                \"proxied\": false
            }")
    fi

    # Check result
    if echo "$response" | jq -e '.success' > /dev/null 2>&1; then
        log_success "${name}.${BASE_DOMAIN} → ${ip}"
        return 0
    else
        local error=$(echo "$response" | jq -r '.errors[0].message // "Unknown error"')
        log_error "Failed to create ${name}: ${error}"
        return 1
    fi
}

# Wait for DNS propagation
wait_for_dns() {
    local domain="$1"
    local expected_ip="$2"
    local max_attempts=30
    local attempt=0

    log_info "Waiting for DNS propagation of ${domain}..."

    while [ $attempt -lt $max_attempts ]; do
        local resolved_ip=$(dig +short "${domain}" @1.1.1.1 2>/dev/null | head -1)

        if [ "$resolved_ip" = "$expected_ip" ]; then
            log_success "DNS propagated: ${domain} → ${resolved_ip}"
            return 0
        fi

        attempt=$((attempt + 1))
        sleep 2
    done

    log_error "DNS propagation timeout for ${domain}"
    return 1
}

# Get Zone ID for domain
get_zone_id() {
    local domain="$1"

    local response=$(curl -s -X GET \
        "https://api.cloudflare.com/client/v4/zones?name=${domain}" \
        -H "Authorization: Bearer ${CF_API_TOKEN}" \
        -H "Content-Type: application/json")

    local zone_id=$(echo "$response" | jq -r '.result[0].id // empty')

    if [ -z "$zone_id" ]; then
        log_error "Could not find Zone ID for ${domain}"
        return 1
    fi

    echo "$zone_id"
}

# ============================================
# MAIN
# ============================================

setup_client_dns() {
    local client_name="$1"
    local vps_ip="$2"

    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  Setting up DNS for: ${client_name}${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Get Zone ID
    log_info "Getting Zone ID for ${BASE_DOMAIN}..."
    local zone_id=$(get_zone_id "${BASE_DOMAIN}")

    if [ -z "$zone_id" ]; then
        log_error "Failed to get Zone ID"
        return 1
    fi
    log_success "Zone ID: ${zone_id}"

    echo ""
    log_info "Creating DNS records..."
    echo ""

    # Create the 3 required records
    create_dns_record "${client_name}" "${vps_ip}" "${zone_id}" || return 1
    create_dns_record "api.${client_name}" "${vps_ip}" "${zone_id}" || return 1
    create_dns_record "studio.${client_name}" "${vps_ip}" "${zone_id}" || return 1

    echo ""
    log_info "Verifying DNS propagation..."
    echo ""

    # Wait for propagation (check main domain only, others should follow)
    wait_for_dns "${client_name}.${BASE_DOMAIN}" "${vps_ip}" || {
        log_error "DNS not propagated yet. It may take a few minutes."
        log_info "You can continue anyway - Let's Encrypt will retry."
        return 0
    }

    echo ""
    log_success "All DNS records configured!"
    echo ""
    echo "  ${client_name}.${BASE_DOMAIN} → ${vps_ip}"
    echo "  api.${client_name}.${BASE_DOMAIN} → ${vps_ip}"
    echo "  studio.${client_name}.${BASE_DOMAIN} → ${vps_ip}"
    echo ""

    return 0
}

# Delete client DNS records
delete_client_dns() {
    local client_name="$1"

    log_info "Getting Zone ID..."
    local zone_id=$(get_zone_id "${BASE_DOMAIN}")

    for prefix in "" "api." "studio."; do
        local name="${prefix}${client_name}"
        local record_id=$(curl -s -X GET \
            "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records?type=A&name=${name}.${BASE_DOMAIN}" \
            -H "Authorization: Bearer ${CF_API_TOKEN}" \
            -H "Content-Type: application/json" | jq -r '.result[0].id // empty')

        if [ -n "$record_id" ]; then
            curl -s -X DELETE \
                "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records/${record_id}" \
                -H "Authorization: Bearer ${CF_API_TOKEN}" > /dev/null
            log_success "Deleted: ${name}.${BASE_DOMAIN}"
        fi
    done
}

# Main entry point
main() {
    case "${1:-}" in
        create)
            if [ -z "${2:-}" ] || [ -z "${3:-}" ]; then
                echo "Usage: $0 create <client_name> <vps_ip>"
                exit 1
            fi
            setup_client_dns "$2" "$3"
            ;;
        delete)
            if [ -z "${2:-}" ]; then
                echo "Usage: $0 delete <client_name>"
                exit 1
            fi
            delete_client_dns "$2"
            ;;
        *)
            echo "Usage: $0 {create|delete} <client_name> [vps_ip]"
            echo ""
            echo "Commands:"
            echo "  create <client> <ip>  - Create DNS records for client"
            echo "  delete <client>       - Delete DNS records for client"
            echo ""
            echo "Example:"
            echo "  $0 create miltontroche 144.217.167.205"
            ;;
    esac
}

main "$@"
