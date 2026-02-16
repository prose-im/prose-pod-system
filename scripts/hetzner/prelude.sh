##
# This file is part of prose-pod-system
#
# Copyright 2026, Prose Foundation
# SPDX-License-Identifier: MPL-2.0
#
# Authors:
# - 2026, Rémi Bardon <remi@remibardon.name>
##

source "$(dirname "${BASH_SOURCE[0]}")"/lib.sh

server_create() {
  hetzner_server_create "$@"
}

server_ipv4() {
  hetzner_server_ipv4 "$@"
}

server_ipv6() {
  hetzner_server_ipv6 "$@"
}

server_delete() {
  hetzner_server_delete "$@"
}
