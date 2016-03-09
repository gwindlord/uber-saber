#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

VERSION_FILE="$LOCAL_REPO/vendor/cm/config/version.mk"
VENDOR_REPO="$LOCAL_REPO/vendor/slim"
VENDORSETUP_FILE="vendorsetup.sh"
MAKEFILE="core/Makefile"
COMMON_FILE="config/common.mk"
CONFIG_FILE="build/core/config.mk"
BUILD_REPO="$LOCAL_REPO/build/"

# Odexing framework (thanks to Mokee)
pushd "$VENDOR_REPO"
  #echo -e "WITH_DEXPREOPT := true\nDONT_DEXPREOPT_PREBUILTS := true" >> "$COMMON_FILE"
  echo -e "WITH_DEXPREOPT := true" >> "$COMMON_FILE"
  git add $(git status -s | awk '{print $2}') && git commit -m "Odexing framework :)"
popd

pushd "$BUILD_REPO"
  sed -i 's#/dex2oatd#/dex2oat#' core/dex_preopt_libart.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Removing issue with odex"
popd
