##
# This file is part of prose-pod-system
#
# Copyright 2026, Prose Foundation
# SPDX-License-Identifier: MPL-2.0
#
# Authors:
# - 2026, Rémi Bardon <remi@remibardon.name>
##

if [ $# -ne 1 ]; then
  die "Must pass a DNS provider name to $(format_code "$0"). Supported: ['porkbun']."
fi

# See <https://porkbun.com/api/json/v3/documentation>.
mod_porkbun() {
  PORKBUN_DNS_API=https://api.porkbun.com/api/json/v3/dns

  porkbun_post_() {
    # WARN: Reading from stdin not leak secrets in logs!
    edo curl -s -X POST "${PORKBUN_DNS_API:?}/${1:?Pass a path}" \
      -H "Content-Type: application/json" \
      -d @-
  }

  porkbun_empty_post_() {
    porkbun_post_ "$@" <<EOF
{
  "apikey": "${PORKBUN_API_KEY:?}",
  "secretapikey": "${PORKBUN_SECRET_KEY:?}"
}
EOF
  }

  list_dns_records() {
    porkbun_empty_post_ "retrieve/${PORKBUN_DOMAIN:?}"/A
  }

  add_record() {
    local type="${1:?"Pass a record type"}"
    local name="${2:?"Pass a subdomain"}"
    local content="${3:?"IP, target or value"}"
    local ttl="${4:-600}"
    local prio="${5-}"

    porkbun_post_ "create/${PORKBUN_DOMAIN:?}" <<EOF
{
  "apikey": "${PORKBUN_API_KEY:?}",
  "secretapikey": "${PORKBUN_SECRET_KEY:?}",
  "type": "${type:?}",
  "name": "${name:?}",
  "content": "${content:?}",
  "ttl": "${ttl:?}"
  "${prio:+, "prio": "${prio:?}"}"
}
EOF
  }

  delete_record() {
    local type="${1:?}"

    porkbun_empty_post_ "deleteByNameType/${PORKBUN_DOMAIN:?}/${type:?}/${TEST_SUBDOMAIN:?}"
  }
}

case "${1?}" in
  porkbun) mod_"${1:?}" ;;
  *) die "Unknown DNS provider $(format_code "${1:?}"). Supported: ['porkbun']." ;;
esac
