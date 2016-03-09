#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

SCRIPT_DIR="$(dirname $(readlink -f $0))"

pushd "$LOCAL_REPO/vendor/oneplus/bacon/"
  cp -r $SCRIPT_DIR/proprietary .
  sed -Ei -z 's#libAKM8963.so\n#libAKM8963.so \\\n    vendor/oneplus/bacon/proprietary/vendor/lib/libchromatix_ov5648_liveshot.so:system/vendor/lib/libchromatix_ov5648_liveshot.so \\\n    vendor/oneplus/bacon/proprietary/vendor/lib/libmmcamera2_q3a_core.so:system/vendor/lib/libmmcamera2_q3a_core.so \\\n    vendor/oneplus/bacon/proprietary/vendor/lib/libmmcamera_cac_lib.so:system/vendor/lib/libmmcamera_cac_lib.so\n#' bacon-vendor-blobs.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Adding proprietary camera libraries from OxygenOS 2.2.0 for the OnePlus X"
popd

exit 0

# tried to merge these commits into CM13 kernel - it bootloops on logo.bin >_<
pushd "$LOCAL_REPO/kernel/oneplus/msm8974/"
  # bacon: Import camera drivers from OxygenOS 2.1.4
  git cherry-pick 455a3b3fa907369f10db3dcf5e23e030f3eda2c6 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # msm: camera: Use old actuator driver
  git cherry-pick e98083aa3ff41cc0d702fa3d0a47d13b3e8c1953
popd
