#!/bin/bash

LOCAL_REPO="/data/slimsaber"
DHANDLER_RES_DIR="$LOCAL_REPO/device/oppo/common/DeviceHandler/res/"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

pushd "$DHANDLER_RES_DIR"

  cp -rf $SCRIPT_DIR/values-ru .
  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding Russian translation for DeviceHandler"

popd
