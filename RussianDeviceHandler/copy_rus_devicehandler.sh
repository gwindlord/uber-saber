#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

DHANDLER_RES_DIR="$LOCAL_REPO/device/oppo/common/DeviceHandler/res/"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

pushd "$DHANDLER_RES_DIR"

  cp -rf $SCRIPT_DIR/values-ru .
  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding Russian translation for DeviceHandler"

popd
