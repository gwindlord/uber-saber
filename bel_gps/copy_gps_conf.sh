#!/bin/bash

LOCAL_REPO="$HOME/slimsaber"
GPS_CONF_DIR="$LOCAL_REPO/device/oppo/msm8974-common/gps"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

pushd "$GPS_CONF_DIR"

echo "path: $SCRIPT_DIR"

  cp -f $SCRIPT_DIR/gps.conf .
  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding GPS configuration file for Belarus"

popd
