#!/bin/bash

##
#  This file is part of prose-pod-system
#
#  Copyright 2025, Prose Foundation
##

source "${REPOSITORY_ROOT:?}"/scripts/tools/colors.sh

error() {
	echo -e "${BRed:?}${@:?"Must pass a message"}${Color_Off:?}" >&2
}
die() {
	[[ $# == 0 ]] || error "${@}"
	exit 1
}
