#!/bin/bash

LOCAL_REPO="/data/slimsaber"
TELEPHONY_RUS_DIR="$LOCAL_REPO/packages/services/Telephony/res/values-ru/"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

pushd "$TELEPHONY_RUS_DIR"

  cp -rf $SCRIPT_DIR/*.xml .
  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding Russian translation for Telephony"

popd
