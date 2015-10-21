#!/bin/bash

LOCAL_REPO="/data/slimsaber"
BOARD_CONFIG="$LOCAL_REPO/device/oneplus/bacon/BoardConfig.mk"
KERNEL_INCLUDES="$LOCAL_REPO/kernel/oneplus/msm8974/"
KERNEL_URL="https://github.com/DerRomtester/android_kernel_oneplus_msm8974.git"
LIBCORE_DIR="$LOCAL_REPO/libcore"

pushd $(dirname "$BOARD_CONFIG")

# sed -i 's/# Bluetooth/KERNEL_TOOLCHAIN_PREFIX := arm-eabi-\nKERNEL_TOOLCHAIN := "\$\(ANDROID_BUILD_TOP\)\/prebuilts\/gcc\/\$\(HOST_OS\)-x86\/arm\/arm-eabi-4.8\/bin\/"\n\n# Bluetooth/' "$BOARD_CONFIG"
#  sed -i 's/# Bluetooth/KERNEL_TOOLCHAIN_PREFIX := arm-eabi-\nKERNEL_TOOLCHAIN := "\$\(ANDROID_BUILD_TOP\)\/prebuilts\/gcc\/\$\(HOST_OS\)-x86\/arm\/arm-eabi-4.9\/bin\/"\n\n# Bluetooth/' "$BOARD_CONFIG"
#  sed -i 's/# Bluetooth/KERNEL_TOOLCHAIN_PREFIX := arm-eabi-\nKERNEL_TOOLCHAIN := "\$\(ANDROID_BUILD_TOP\)\/prebuilts\/gcc\/\$\(HOST_OS\)-x86\/arm\/arm-eabi-4.9_cortex_a15\/bin\/"\n\n# Bluetooth/' "$BOARD_CONFIG"
#  sed -i 's/# Bluetooth/KERNEL_TOOLCHAIN_PREFIX := arm-eabi-\nKERNEL_TOOLCHAIN := "\$\(ANDROID_BUILD_TOP\)\/prebuilts\/gcc\/\$\(HOST_OS\)-x86\/arm\/arm-eabi-5.1\/bin\/"\n\n# Bluetooth/' "$BOARD_CONFIG"
  sed -i 's/# Bluetooth/KERNEL_TOOLCHAIN_PREFIX := arm-eabi-\nKERNEL_TOOLCHAIN := "\$\(ANDROID_BUILD_TOP\)\/prebuilts\/gcc\/\$\(HOST_OS\)-x86\/arm\/arm-eabi-6.0\/bin\/"\n\n# Bluetooth/' "$BOARD_CONFIG"
#  sed -i 's/# Bluetooth/KERNEL_TOOLCHAIN_PREFIX := arm-eabi-\nKERNEL_TOOLCHAIN := "\$\(ANDROID_BUILD_TOP\)\/prebuilts\/gcc\/\$\(HOST_OS\)-x86\/arm\/arm-cortex_a15-linux-gnueabihf-linaro_4.9\/bin\/"\n\n# Bluetooth/' "$BOARD_CONFIG"

  git add $(git status -s | awk '{print $2}')
  git commit -m "Setting Uber toolchain"

popd

#exit 0

# including GCC6 from DerRomtester to Sultan's kernel
pushd "$KERNEL_INCLUDES"

  git remote add DerRomtester "$KERNEL_URL"
  git fetch DerRomtester

  git cherry-pick 0ceb6e5718203c572a45805990316c16243f5717
  git cherry-pick 9d6fde06b225f00e2272d8002280d0a270bbade8
  git cherry-pick b53d471b49259160a1a689e394161035947f9a85
  git cherry-pick d345409deb06a61ab391fd1f46520d14f8ff5d1e
  git cherry-pick 89be48a4654e4d887d84ba9d1f6542459d6340a6
  git cherry-pick b2e9e3f5f37d36d49e82b66b57d5c55be891d0de
  git cherry-pick da42ac628a716cf116470e78d63b67824b240eae
  git cherry-pick cab877e62ad93b492f0e263b33cc80185dcefe0a
  git cherry-pick e9434a8e3e6e2b87dec6c2a701c6dd6df5a5b79b
  git cherry-pick 586c615952cc970b1ad63a25f55054ef4233d428
  git cherry-pick cbe7ab94c1304cd476b960a54e593992450cb699
  # and for make - JIC
  git cherry-pick 02fbb2213a980b97d1a8257c08c9c558db9820c1
  git cherry-pick 560dc563a065e5e8fe8f009680a8ed2a1f28c167
  git cherry-pick 224b7e1dc977bcb95d5b874d3d1011708522bd66
  # and panel dynamic fps support
  git cherry-pick 2343e6873f2949c29118af04db9e07720b64eac6

  git remote rm DerRomtester

popd

exit 0

# taking Google's fix for GCC 4.9 (https://android-review.googlesource.com/#/c/143200/) - cannot build tests, multiple compilation errors
pushd "$LIBCORE_DIR"

  git fetch https://android.googlesource.com/platform/libcore refs/changes/00/143200/5 && git cherry-pick FETCH_HEAD

popd
