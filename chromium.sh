#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

CHROMIUM_DIR="/data/chromium_stable"

pushd "$CHROMIUM_DIR"
  ./build/update.sh
  ./build/make.sh --system
popd
