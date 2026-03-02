#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V2_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_DIR="${V2_DIR}/providers/terraform"

usage() {
  cat << 'USAGE'
Usage:
  fetch-provider-template.sh <provider> [pigsty_version]

Examples:
  fetch-provider-template.sh hetzner
  fetch-provider-template.sh digitalocean v4.2.0
USAGE
}

provider="${1:-}"
version="${2:-v4.2.0}"

if [[ -z "${provider}" ]]; then
  usage
  exit 1
fi

case "${provider}" in
  hetzner|digitalocean|aws|gcp|azure|vultr|linode|aliyun|qcloud)
    ;;
  *)
    echo "Unsupported provider: ${provider}" >&2
    echo "Supported: hetzner, digitalocean, aws, gcp, azure, vultr, linode, aliyun, qcloud" >&2
    exit 1
    ;;
esac

mkdir -p "${OUTPUT_DIR}"

source_url="https://raw.githubusercontent.com/pgsty/pigsty/${version}/terraform/spec/${provider}.tf"
target_file="${OUTPUT_DIR}/${provider}.tf"
meta_file="${OUTPUT_DIR}/${provider}.source.txt"

echo "Downloading ${source_url}"
curl -fsSL "${source_url}" -o "${target_file}"

cat > "${meta_file}" << META
provider=${provider}
version=${version}
source_url=${source_url}
fetched_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)
META

echo "Saved: ${target_file}"
echo "Source: ${meta_file}"
