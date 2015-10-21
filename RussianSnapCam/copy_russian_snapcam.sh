#!/bin/bash

LOCAL_REPO="/data/slimsaber"
SNAPCAM_RUS_DIR="$LOCAL_REPO/packages/apps/SnapdragonCamera/res/values-ru"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

pushd "$SNAPCAM_RUS_DIR"

  cp -f $SCRIPT_DIR/*.xml .
  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding Russian translation for SnapCam"

popd
