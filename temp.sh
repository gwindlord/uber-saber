#!/bin/bash

LOCAL_REPO="/data/slimsaber"

exit 0

pushd $LOCAL_REPO/device/oppo/msm8974-common

  # msm8974: Update WCNSS WiFi config
  wget https://github.com/sultanxda/android_device_oppo_msm8974-common/commit/214816d8ee78054acdaf02b48b0d87b5936c7850.patch
  patch -p1 < 214816d8ee78054acdaf02b48b0d87b5936c7850.patch

  # msm8974: Disable 'proximity check on wake' feature
  wget https://github.com/sultanxda/android_device_oppo_msm8974-common/commit/a6d49d83aa07391f5140d221fe65216e74fe3685.patch
  patch -p1 < a6d49d83aa07391f5140d221fe65216e74fe3685.patch

  git add $(git status -s | awk '{print $2}')
  git commit -m "Placing Sultan's patches"

popd
