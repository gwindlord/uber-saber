#!/bin/bash

LOCAL_REPO="$HOME/slimsaber"
ADDON_DIR="$LOCAL_REPO/vendor/slim/prebuilt/common/bin"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

pushd "$ADDON_DIR"

  cp -f $SCRIPT_DIR/73-browsersync.sh .
  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding backup script for browser sync"

popd
