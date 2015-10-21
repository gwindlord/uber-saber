#!/bin/bash

LOCAL_REPO="/data/slimsaber"
VERSION_FILE="$LOCAL_REPO/vendor/cm/config/version.mk"
VENDOR_REPO="$LOCAL_REPO/vendor/slim"
VENDORSETUP_FILE="vendorsetup.sh"
MAKEFILE="core/Makefile"
COMMON_FILE="config/common.mk"
CONFIG_FILE="build/core/config.mk"
BUILD_REPO="$LOCAL_REPO/build/"

# Odexing framework (thanks to Mokee)
pushd "$VENDOR_REPO"

  echo -e "WITH_DEXPREOPT := true\nDONT_DEXPREOPT_PREBUILTS := true" >> "$COMMON_FILE"

  git add $(git status -s | awk '{print $2}')
  git commit -m "Odexing framework :)"

popd

pushd "$BUILD_REPO"

  sed -i 's#/dex2oatd#/dex2oat#' core/dex_preopt_libart.mk
  git add $(git status -s | awk '{print $2}')
  git commit -m "Removing issue with odex"

popd

exit 0

# reverting vendor_cm -> vendor_ubercm
pushd "$VENDOR_REPO"

  set -e
  git revert 47fa7db2f73061127497f4f22e93fcf8c2df40d0 --rerere-autoupdate || git revert --continue
  set +e

  sed -i 's#ubercm_bacon#cm_bacon#' "$VENDORSETUP_FILE"

  # one more vendor/ubercm revert occurrence fix
  sed -i 's#vendor/ubercm#vendor/cm#' "$COMMON_FILE"
  sed -i 's#vendor/ubercm#vendor/cm#' "$CONFIG_FILE" 

  git add $(git status -s | awk '{print $2}')
  git commit -m "Re-setting bacon target, setting vx_process_props.py and cmsdk paths"

popd

pushd "$BUILD_REPO"

  # one more vendor/ubercm revert occurrence fix
  sed -i 's#vendor/ubercm/#vendor/cm/#' "$MAKEFILE"

  git add $(git status -s | awk '{print $2}')
  git commit -m "Reverting one more vendor_cm -> vendor_ubercm"

  set -e
  git revert 915bd50f21525f12b6784ffbc8a0ddb8e0c065f1 --rerere-autoupdate || git revert --continue
  set +e

popd

