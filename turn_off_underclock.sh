#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

BOARD_CONFIG="$LOCAL_REPO/device/oneplus/bacon/BoardConfig.mk"

# turning underclock off makes kernel stuck in constant activity
pushd "$(dirname $(readlink -f $BOARD_CONFIG))"
  sed -i 's#msm_sdcc.1#msm_sdcc.1 no_underclock=1#' "$BOARD_CONFIG"
  git add $(git status -s | awk '{print $2}') && git commit -m "Removing CPU underclock from Sultanxda kernel"
popd
