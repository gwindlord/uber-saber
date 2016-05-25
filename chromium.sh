#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

CHROMIUM_DIR="/mnt/sdc/chromium"
#CHROMIUM_DIR="/mnt/sdc/chromium50"

pushd "$CHROMIUM_DIR"
  ./build/update.sh
  ./build/make.sh --system
popd
