#!/bin/bash

##
#  This file is part of prose-pod-system
#
#  Copyright 2024, Prose Foundation
##

set -e

PROSE_POD_SYSTEM_DIR=${PROSE_POD_SYSTEM_DIR:-"$(dirname "$0")"/..};
SERVER_ROOT=${SERVER_ROOT:-"${PROSE_POD_SYSTEM_DIR:?}"/server/pod};

rm -rf "${PROSE_POD_SYSTEM_DIR}"/database.sqlite;
rm -rf "${SERVER_ROOT}"/etc/prosody/prosody.cfg.lua;
rm -rf "${SERVER_ROOT}"/var/lib/prosody/*%2e*;
