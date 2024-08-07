#!/bin/bash

##
#  This file is part of prose-pod-system
#
#  Copyright 2023, Prose Foundation
##

ABSPATH=$(cd "$(dirname "$0")/../"; pwd)

if [ ! -z "$1" ]; then
  environment=$1
else
  environment="local"
fi

rc=0

if [ -d "$ABSPATH/server/$environment" ]; then
  echo "[$environment] 🚀 Bootstrapping Prose server..."

  # Bootstrap Prose server (using target environment)
  docker run --rm \
    -p 5222:5222 \
    -p 5269:5269 \
    -p 5280:5280 \
    -v "$ABSPATH/server/$environment/etc/prosody/:/etc/prosody/" \
    -v "$ABSPATH/server/$environment/var/lib/prosody/:/var/lib/prosody/" \
    proseim/prose-pod-server
  rc=$?

  if [[ $rc = 0 ]]; then
    echo "[$environment] ✅ Prose server stopped."
  else
    echo "[$environment] ❌ Error bootstrapping Prose server."
  fi
else
  echo "[$environment] ⚠️  Nothing to do."

  rc=0
fi

exit $rc
