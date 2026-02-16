#!/bin/bash

##
# This file is part of prose-pod-system
#
# Copyright 2025, Prose Foundation
# SPDX-License-Identifier: MPL-2.0
#
# Authors:
# - 2025, Rémi Bardon <remi@remibardon.name>
##

: ${SCRIPTS_DIR:="$(realpath "$(dirname "$0")"/..)"}
: ${BASH_TOOLBOX:="${SCRIPTS_DIR:?}"/bash-toolbox}
for util in die edo format log; do
  source "${BASH_TOOLBOX:?}/${util:?}.sh"
done
source "${SCRIPTS_DIR:?}"/tools/replace.sh

: ${COMPOSE_FILE:="${REPOSITORY_ROOT:?}"/compose.yaml}

find_version() {
	local regex="${1:?}" file="${2:?}"
	replace -n 's/.*'"${regex}"'.*/\2/p' "${file}"
}
replace_version() {
	local regex="${1:?}" replace="${2:?}" file="${3:?}"
	local pattern='s/'"${regex}"'/\1'"${replace}"'\3/'

	replace -i "${pattern}" "${file}"
}

# `:` blocks the greedy `+` from eating the `:-` prefix and `}` the suffix.
# Otherwise, allow pretty much any name, there's no reason to enforce a pattern here.
DOCKER_TAG_REGEX='[^:}]+'

APP_REGEX='(PROSE_APP_WEB_VERSION:-)('"${DOCKER_TAG_REGEX:?}"')(\}+)'
find_version_app() {
	find_version "${APP_REGEX:?}" "${COMPOSE_FILE:?}"
}
replace_version_app() {
	replace_version "${APP_REGEX:?}" "${1:?}" "${COMPOSE_FILE:?}"
}

DASHBOARD_REGEX='(PROSE_POD_DASHBOARD_VERSION:-)('"${DOCKER_TAG_REGEX:?}"')(\}+)'
find_version_dashboard() {
	find_version "${DASHBOARD_REGEX:?}" "${COMPOSE_FILE:?}"
}
replace_version_dashboard() {
	replace_version "${DASHBOARD_REGEX:?}" "${1:?}" "${COMPOSE_FILE:?}"
}

API_REGEX='(PROSE_POD_API_VERSION:-)('"${DOCKER_TAG_REGEX:?}"')(\}+)'
find_version_api() {
	find_version "${API_REGEX:?}" "${COMPOSE_FILE:?}"
}
replace_version_api() {
	replace_version "${API_REGEX:?}" "${1:?}" "${COMPOSE_FILE:?}"
}

SERVER_REGEX='(PROSE_POD_SERVER_VERSION:-)('"${DOCKER_TAG_REGEX:?}"')(\}+)'
find_version_server() {
	find_version "${SERVER_REGEX:?}" "${COMPOSE_FILE:?}"
}
replace_version_server() {
	replace_version "${SERVER_REGEX:?}" "${1:?}" "${COMPOSE_FILE:?}"
}
