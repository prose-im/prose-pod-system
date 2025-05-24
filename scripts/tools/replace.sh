#!/bin/bash

##
#  This file is part of prose-pod-system
#
#  Copyright 2025, Prose Foundation
##

# A simplified `sed` command that works on both macOS and Linux.
replace() {
	local in_place
	[[ "$1" == "-i" ]] && { in_place=1; shift 1; }

	if [[ "$(uname)" == "Darwin" ]]; then
		(( $in_place )) && sed -i '' -E "$@" || sed -E "$@"
	else
		sed ${in_place:+-i} -E "$@"
	fi
}
