#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

ROM_PACKAGES_MAKEFILE="$LOCAL_REPO/device/oppo/msm8974-common/msm8974.mk"

pushd $(dirname "$ROM_PACKAGES_MAKEFILE")
  sed -i 's/^    libantradio/    libantradio\n# CameraNextMod\nPRODUCT_PACKAGES += \\\n    CameraNextMod \\\n    libjni_mosaic_next\n/' "$ROM_PACKAGES_MAKEFILE"
#  sed -i 's/^    libantradio/    libantradio\n\n# ColorOSCamera\nPRODUCT_PACKAGES += \\\n    ColorOSCamera \\\n\\\n    HDCamera \\\n\\\n    NightCamera \n/' "$ROM_PACKAGES_MAKEFILE"
  git add $(git status -s | awk '{print $2}') && git commit -m "Adding custom camera to the build"
popd
