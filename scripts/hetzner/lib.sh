##
# This file is part of prose-pod-system
#
# Copyright 2026, Prose Foundation
# SPDX-License-Identifier: MPL-2.0
#
# Authors:
# - 2026, Rémi Bardon <remi@remibardon.name>
##

hetzner_server_delete() {
  local server_name="${1:?}"
  edo hcloud server delete "${server_name:?}"
}

hetzner_server_create() {
  local server_name="${1:?}"
  local server_type="${2:?}"
  local image="${3:?}"

  # NOTE: The `hcloud` CLI only accepts negative booleans for IP addresses.
  #   We have to store the negative values and unset them as needed.
  local without_ipv4=1
  if (( ${WITH_IPV4:-0} )); then
    unset without_ipv4
  fi

  local without_ipv6=1
  if (( ${WITH_IPV6:-0} )); then
    unset without_ipv6
  fi

  edo hcloud server create --name "${server_name:?}" \
    --type "${server_type:?}" \
    --image "${image:?}" \
    ${LOCATION:+--location "${LOCATION:?}"} \
    --ssh-key "${SSH_KEY:?}" \
    ${without_ipv4:+--without-ipv4} ${without_ipv6:+--without-ipv6}
}

hetzner_server_ipv4() {
  hcloud server ip "${1:?}"
}

hetzner_server_ipv6() {
  hcloud server ip -6 "${1:?}"
}

hetzner_setup() {
  hetzner_context_use "${1:?}"

  # Stop exposing sensitive `HETZNER_TOKEN` as we don’t need it anymore.
  unset HETZNER_TOKEN
}

hetzner_context_use() {
  local context_name="${1:?}"

  # Create Hetzner context if needed.
  if ! log_as_trace_ hcloud context use "${context_name:?}"; then
    if [ -z "${HETZNER_TOKEN:+redacted}" ]; then
      error "Follow $(format_hyperlink '“Generating an API token” in Hetzner’s documentation' 'https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/') to get an API token (Read & Write),"
      error "then expose it as $(format_code HETZNER_TOKEN)${ENV_FILE:+" in $(format_code "${ENV_FILE:?}")"}."

      die
    fi

    # NOTE: Run in a subshell to expose `HCLOUD_TOKEN` only temporarily.
    (
      # Expose `HCLOUD_TOKEN` once, to avoid conflicts with the active context.
      # NOTE: If it’s exposed during `hcloud context use`, `hcloud` warns
      #   “HCLOUD_TOKEN is set. The active context will have no effect.“.
      HCLOUD_TOKEN="${HETZNER_TOKEN:?}"

      log_as_info_ hcloud context create --token-from-env "${context_name:?}"
    )
  fi
}

# ---

# hcloud server
# Power/Reboot:
#   poweroff                    Poweroff a Server
#   poweron                     Poweron a server
#   reboot                      Reboot a server
#   reset                       Reset a Server
#   shutdown                    Shutdown a server
