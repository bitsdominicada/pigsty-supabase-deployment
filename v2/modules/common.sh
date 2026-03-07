#!/usr/bin/env bash
# Shared remote transport helpers for direct SSH and Tailscale-based SSH.

if [[ -n "${V2_COMMON_SH_SOURCED:-}" ]]; then
  return 0
fi
V2_COMMON_SH_SOURCED=1

COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V2_DIR="${V2_DIR:-$(cd "${COMMON_DIR}/.." && pwd)}"
ENV_FILE="${ENV_FILE:-${V2_DIR}/.env}"

load_v2_env_if_present() {
  if [[ -f "${ENV_FILE}" ]]; then
    set -a
    # shellcheck disable=SC1090
    source "${ENV_FILE}"
    set +a
  fi
}

load_v2_env_if_present

SSH_TRANSPORT="${SSH_TRANSPORT:-direct}"
SSH_USER="${SSH_USER:-root}"
SSH_CONNECT_TIMEOUT="${SSH_CONNECT_TIMEOUT:-10}"
SSH_STRICT_HOST_KEY_CHECKING="${SSH_STRICT_HOST_KEY_CHECKING:-accept-new}"

V2_SSH_ARGS=(
  -o "ConnectTimeout=${SSH_CONNECT_TIMEOUT}"
  -o "StrictHostKeyChecking=${SSH_STRICT_HOST_KEY_CHECKING}"
)
V2_SCP_ARGS=("${V2_SSH_ARGS[@]}")
V2_INNER_SSH_ARGS=(
  -o "ConnectTimeout=${SSH_CONNECT_TIMEOUT}"
  -o "StrictHostKeyChecking=${SSH_STRICT_HOST_KEY_CHECKING}"
)

V2_RSYNC_RSH="ssh -o ConnectTimeout=${SSH_CONNECT_TIMEOUT} -o StrictHostKeyChecking=${SSH_STRICT_HOST_KEY_CHECKING}"

common_err() {
  echo "$*" >&2
}

require_remote_env_var() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    common_err "Missing required env var: ${name}"
    exit 1
  fi
}

using_tailscale_transport() {
  [[ "${SSH_TRANSPORT}" == "tailscale" ]]
}

meta_host() {
  if using_tailscale_transport; then
    require_remote_env_var TAILSCALE_META_HOST
    printf '%s\n' "${TAILSCALE_META_HOST}"
  else
    require_remote_env_var META_IP
    printf '%s\n' "${META_IP}"
  fi
}

meta_target() {
  printf '%s@%s\n' "${SSH_USER}" "$(meta_host)"
}

tailscale_private_host() {
  local host="$1"
  case "${host}" in
    "${DB1_PRIVATE_IP:-}")
      printf '%s\n' "${TAILSCALE_DB1_HOST:-}"
      ;;
    "${DB2_PRIVATE_IP:-}")
      printf '%s\n' "${TAILSCALE_DB2_HOST:-}"
      ;;
    *)
      return 1
      ;;
  esac
}

private_ssh_prefix() {
  local host="$1"
  local user_host="${SSH_USER}@${host}"
  printf 'ssh'
  local arg
  for arg in "${V2_INNER_SSH_ARGS[@]}"; do
    printf ' %q' "${arg}"
  done
  printf ' %q' "${user_host}"
}

ssh_to_meta() {
  local target
  target="$(meta_target)"
  ssh "${V2_SSH_ARGS[@]}" "${target}" "$@"
}

scp_to_meta() {
  local src="$1"
  local dst="$2"
  local target
  target="$(meta_target)"
  scp "${V2_SCP_ARGS[@]}" "${src}" "${target}:${dst}"
}

rsync_to_meta() {
  local src="$1"
  local dst="$2"
  local target
  target="$(meta_target)"
  rsync -az -e "${V2_RSYNC_RSH}" \
    --exclude '.DS_Store' \
    --exclude 'node_modules' \
    --exclude '.git' \
    "${src}" "${target}:${dst}"
}

bash_on_meta() {
  ssh_to_meta 'bash -seuo pipefail -s' <<<"$1"
}

bash_on_private_via_meta() {
  local host="$1"
  local script="$2"

  if using_tailscale_transport; then
    local ts_host=""
    ts_host="$(tailscale_private_host "${host}" 2>/dev/null || true)"
    if [[ -n "${ts_host}" ]]; then
      ssh "${V2_SSH_ARGS[@]}" "${SSH_USER}@${ts_host}" 'bash -seuo pipefail -s' <<<"${script}"
      return 0
    fi
  fi

  local inner_prefix
  inner_prefix="$(private_ssh_prefix "${host}")"
  ssh_to_meta "${inner_prefix} 'bash -seuo pipefail -s'" <<<"${script}"
}
