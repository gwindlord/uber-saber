#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

GPS_CONF_DIR="$LOCAL_REPO/device/oppo/msm8974-common/gps"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

pushd "$GPS_CONF_DIR"

echo "path: $SCRIPT_DIR"

  cp -f $SCRIPT_DIR/gps.conf .
  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding GPS configuration file for Belarus"

popd
