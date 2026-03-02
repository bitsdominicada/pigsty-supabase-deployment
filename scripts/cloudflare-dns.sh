#!/usr/bin/env bash

# ============================================
# CLOUDFLARE DNS AUTOMATION
# ============================================
# Requires:
#   CF_API_TOKEN  (Zone:DNS Edit)
# Optional:
#   CF_ZONE_ID    (if empty, auto-discovered from BASE_DOMAIN)
#   BASE_DOMAIN   (default: bitsneura.com)
#   CF_PROXIED    (default: true)
#   CF_TTL        (default: 300)
#
# Commands:
#   create-client <client_name> <vps_ip>
#   delete-client <client_name>
#   create-platform <vps_ip> [base_domain]
#   delete-platform [base_domain]
#
# Backward compatible aliases:
#   create <client_name> <vps_ip>    -> create-client
#   delete <client_name>             -> delete-client

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

BASE_DOMAIN="${BASE_DOMAIN:-bitsneura.com}"
CF_API_TOKEN="${CF_API_TOKEN:-}"
CF_ZONE_ID="${CF_ZONE_ID:-}"
CF_PROXIED="${CF_PROXIED:-true}"
CF_TTL="${CF_TTL:-300}"

log_info() { echo -e "${CYAN}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

require_bin() {
  local b="$1"
  command -v "$b" >/dev/null 2>&1 || { log_error "Missing dependency: $b"; exit 1; }
}

require_auth() {
  if [[ -z "$CF_API_TOKEN" ]]; then
    log_error "CF_API_TOKEN is required (export it or place in .env before running deploy)"
    exit 1
  fi
}

verify_token() {
  local response
  response="$(curl -sS -X GET \
    "https://api.cloudflare.com/client/v4/user/tokens/verify" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json")"

  if ! echo "$response" | jq -e '.success == true and .result.status == "active"' >/dev/null 2>&1; then
    local error
    error="$(echo "$response" | jq -r '.errors[0].message // "Token verification failed"')"
    log_error "$error"
    exit 1
  fi
}

resolve_zone_id() {
  local domain="$1"
  if [[ -n "$CF_ZONE_ID" ]]; then
    echo "$CF_ZONE_ID"
    return 0
  fi

  local response zone_id
  response="$(curl -sS -X GET \
    "https://api.cloudflare.com/client/v4/zones?name=${domain}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json")"

  zone_id="$(echo "$response" | jq -r '.result[0].id // empty')"
  if [[ -z "$zone_id" ]]; then
    local error
    error="$(echo "$response" | jq -r '.errors[0].message // "Could not resolve zone id"')"
    log_error "Zone lookup failed for ${domain}: ${error}"
    return 1
  fi
  echo "$zone_id"
}

upsert_a_record() {
  local fqdn="$1"
  local ip="$2"
  local zone_id="$3"

  local existing response method url
  existing="$(curl -sS -X GET \
    "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records?type=A&name=${fqdn}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" | jq -r '.result[0].id // empty')"

  if [[ -n "$existing" ]]; then
    method="PUT"
    url="https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records/${existing}"
    log_info "Updating ${fqdn} -> ${ip}"
  else
    method="POST"
    url="https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records"
    log_info "Creating ${fqdn} -> ${ip}"
  fi

  response="$(curl -sS -X "$method" "$url" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data "{
      \"type\": \"A\",
      \"name\": \"${fqdn}\",
      \"content\": \"${ip}\",
      \"ttl\": ${CF_TTL},
      \"proxied\": ${CF_PROXIED}
    }")"

  if echo "$response" | jq -e '.success == true' >/dev/null 2>&1; then
    log_success "${fqdn} -> ${ip}"
    return 0
  fi

  local error
  error="$(echo "$response" | jq -r '.errors[0].message // "Unknown error"')"
  log_error "Failed ${fqdn}: ${error}"
  return 1
}

delete_a_record() {
  local fqdn="$1"
  local zone_id="$2"
  local id
  id="$(curl -sS -X GET \
    "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records?type=A&name=${fqdn}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" | jq -r '.result[0].id // empty')"

  if [[ -z "$id" ]]; then
    log_warn "Record not found: ${fqdn}"
    return 0
  fi

  curl -sS -X DELETE \
    "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records/${id}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" >/dev/null
  log_success "Deleted ${fqdn}"
}

wait_for_dns() {
  local fqdn="$1"
  local expected_ip="$2"
  local max_attempts=30
  local attempt=0

  while [[ $attempt -lt $max_attempts ]]; do
    local resolved_ip
    resolved_ip="$(dig +short "$fqdn" @1.1.1.1 2>/dev/null | head -1)"
    if [[ "$resolved_ip" == "$expected_ip" ]]; then
      log_success "DNS propagated: ${fqdn} -> ${resolved_ip}"
      return 0
    fi
    attempt=$((attempt + 1))
    sleep 2
  done

  log_warn "DNS propagation timeout for ${fqdn}; continuing"
  return 0
}

create_client_dns() {
  local client="$1"
  local ip="$2"
  local zone_id="$3"
  local base="$4"

  local records=(
    "${client}.${base}"
    "api.${client}.${base}"
    "studio.${client}.${base}"
    "grafana.${client}.${base}"
  )

  for fqdn in "${records[@]}"; do
    upsert_a_record "$fqdn" "$ip" "$zone_id"
  done
  wait_for_dns "${client}.${base}" "$ip"
}

delete_client_dns() {
  local client="$1"
  local zone_id="$2"
  local base="$3"

  local records=(
    "${client}.${base}"
    "api.${client}.${base}"
    "studio.${client}.${base}"
    "grafana.${client}.${base}"
  )

  for fqdn in "${records[@]}"; do
    delete_a_record "$fqdn" "$zone_id"
  done
}

create_platform_dns() {
  local ip="$1"
  local zone_id="$2"
  local base="$3"

  local labels=(app pos ai api studio grafana)
  for label in "${labels[@]}"; do
    upsert_a_record "${label}.${base}" "$ip" "$zone_id"
  done
  wait_for_dns "app.${base}" "$ip"
}

delete_platform_dns() {
  local zone_id="$1"
  local base="$2"
  local labels=(app pos ai api studio grafana)

  for label in "${labels[@]}"; do
    delete_a_record "${label}.${base}" "$zone_id"
  done
}

usage() {
  cat <<EOF
Usage: $0 <command> [args]

Commands:
  create-client <client_name> <vps_ip>
  delete-client <client_name>
  create-platform <vps_ip> [base_domain]
  delete-platform [base_domain]

Aliases:
  create <client_name> <vps_ip>
  delete <client_name>
EOF
}

main() {
  require_bin curl
  require_bin jq
  require_bin dig
  require_auth
  verify_token

  local cmd="${1:-}"
  case "$cmd" in
    create-client|create)
      [[ -n "${2:-}" && -n "${3:-}" ]] || { usage; exit 1; }
      local client="$2"
      local ip="$3"
      local base="$BASE_DOMAIN"
      local zone_id
      zone_id="$(resolve_zone_id "$base")"
      create_client_dns "$client" "$ip" "$zone_id" "$base"
      ;;
    delete-client|delete)
      [[ -n "${2:-}" ]] || { usage; exit 1; }
      local client="$2"
      local base="$BASE_DOMAIN"
      local zone_id
      zone_id="$(resolve_zone_id "$base")"
      delete_client_dns "$client" "$zone_id" "$base"
      ;;
    create-platform)
      [[ -n "${2:-}" ]] || { usage; exit 1; }
      local ip="$2"
      local base="${3:-$BASE_DOMAIN}"
      local zone_id
      zone_id="$(resolve_zone_id "$base")"
      create_platform_dns "$ip" "$zone_id" "$base"
      ;;
    delete-platform)
      local base="${2:-$BASE_DOMAIN}"
      local zone_id
      zone_id="$(resolve_zone_id "$base")"
      delete_platform_dns "$zone_id" "$base"
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
