#!/bin/bash

LOCAL_REPO="$HOME/slimsaber"
NOVA_DIR="$LOCAL_REPO/vendor/slim/prebuilt/common/app"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

pushd "$NOVA_DIR"

  cp -f $SCRIPT_DIR/NovaLauncher.apk .
  git add $(git status -s | awk '{print $2}')
  git commit -m "Updating Nova Launcher"

popd
