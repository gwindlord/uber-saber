#!/bin/bash

LOCAL_REPO="/data/slimsaber"

VENDOR_REPO="$LOCAL_REPO/vendor/slim"
CONFIG_FILE="config/common.mk"
MY_VENDOR_REPO="$LOCAL_REPO/vendor/gwindlord"

DEVICE_REPO="$LOCAL_REPO/device/oppo/msm8974-common/"
ROM_PACKAGES_MAKEFILE="msm8974.mk"

SYSTEM_CORE="$LOCAL_REPO/system/core"

FRAMEWORKS_BASE="$LOCAL_REPO/frameworks/base"
TELEPHONY_REPO="$LOCAL_REPO/packages/services/Telephony"

DEVICE_OPPO_REPO="$LOCAL_REPO/device/oppo/common/"

BUILD_REPO="$LOCAL_REPO/build/"

FRAMEWORKS_OPT_TELEPHONY="$LOCAL_REPO/frameworks/opt/telephony"

DEVICE_ONEPLUS_REPO="$LOCAL_REPO/device/oneplus/bacon"

#SETTINGS_REPO="$LOCAL_REPO/packages/apps/Settings"
#FRAMEWORKS_AV="$LOCAL_REPO/frameworks/av"

pushd "$VENDOR_REPO"

  # setting Nova as default launcher
  git remote add UberCM https://github.com/UberCM/vendor_ubercm.git
  git fetch UberCM

  git cherry-pick 45c7ba3f11968e23cbaa1c93bbd9a91f0ad9f8d1 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

  git remote rm UberCM

  sed -i 's#:system/etc/backup.conf#:system/etc/backup.conf \\\n    vendor/slim/prebuilt/common/bin/73-browsersync.sh:system/addon.d/73-browsersync.sh#' "$CONFIG_FILE"
  sed -i 's#    SlimLauncher \\#    CMFileManager \\#' "$CONFIG_FILE"
  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding Browser sync backup script and CM File manager to the build"

  cp proprietary/CameraNextMod/Android.mk $LOCAL_REPO/vendor/gwindlord/proprietary/CameraNextMod/
  git rm proprietary/CameraNextMod/Android.mk && git commit -m "Remove CameraNextMod duplicate"

popd

pushd "$MY_VENDOR_REPO"

  git add proprietary/CameraNextMod/Android.mk && git commit -m "Setting translated Camera"

popd

pushd "$VENDOR_REPO"

  sed -i 's#%Y%m%d#%Y%m%d-%H%M#' "$CONFIG_FILE"

  git add $(git status -s | awk '{print $2}')
  git commit -m "Setting more presice zip date"

popd

pushd "$DEVICE_REPO"

  sed -i 's/^    libantradio/    libantradio\n\n# ChromeBookmarksSyncAdapter\nPRODUCT_PACKAGES += \\\n    ChromeBookmarksSyncAdapter/' "$ROM_PACKAGES_MAKEFILE"

  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding Browser sync"


  # msm8974: Enable adaptive LMK (http://review.cyanogenmod.org/#/c/103749/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oppo_msm8974-common refs/changes/49/103749/1 && git cherry-pick FETCH_HEAD

  # fixing build - msm8974: remove unused resources
  git remote add YoshiShaPow https://github.com/YoshiShaPow/android_device_oppo_msm8974-common.git
  git fetch YoshiShaPow

  git cherry-pick 2cdb7c4ddb349be16ee7ecfdb4f1bc634c0d267d

  git remote rm YoshiShaPow

popd

# liblog: Silence spammy logs from camera blobs (AEC_PORT and mm-camera)
pushd "$SYSTEM_CORE"

  git remote add SultanCore https://github.com/sultanxda/android_system_core.git
  git fetch SultanCore

  git cherry-pick c407c8a2299183ce0fd0e7f7b1c026a66b5adb8d

  git remote rm SultanCore

popd

# Slim
# non-intrusive calls

pushd "$FRAMEWORKS_BASE"

  git remote add Slimfb https://github.com/SlimRoms/frameworks_base.git
  git fetch Slimfb

  git cherry-pick d1a5c06fa0bcd699ba6a6aec90bce732d7c68e43 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

  git remote rm Slimfb

popd

pushd "$TELEPHONY_REPO"

  git remote add Slimtelephony https://github.com/SlimRoms/packages_services_Telephony.git
  git fetch Slimtelephony

  git cherry-pick a5c056daf1e8a4385ce9ed982e86b3945ad1dc69 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

  git remote rm Slimtelephony

popd

# Sultan's patches
pushd "$FRAMEWORKS_BASE"

  # StrictMode: Disable all strict mode functions when disable prop is set
  wget https://github.com/CyanogenMod/android_frameworks_base/commit/e75f59e7fd349dd1fa5d452086c795f693776d89.patch && patch -p1 < e75f59e7fd349dd1fa5d452086c795f693776d89.patch
  # telephony: Hack GSM and LTE signal strength
  wget https://github.com/sultanxda/android_frameworks_base/commit/0cbd4a88767d78640b7dd391674575f7d5e517e6.patch && patch -p1 < 0cbd4a88767d78640b7dd391674575f7d5e517e6.patch
  git clean -f -d

  git add $(git status -s | awk '{print $2}')
  git commit -m "Placing Sultan's patches"

popd

pushd "$FRAMEWORKS_OPT_TELEPHONY"

  # UiccController: Don't dispose of UICC card when modem is unavailable
  wget https://github.com/sultanxda/android_frameworks_opt_telephony/commit/279bcac13acffa186483aff97f359597a8875b18.patch && patch -p1 < 279bcac13acffa186483aff97f359597a8875b18.patch
  git clean -f -d

  git add $(git status -s | awk '{print $2}')
  git commit -m "Placing Sultan's patches"

popd

# removing Viper commit
pushd external/sepolicy/

  git revert 9e46bc6fee9ca77f743b694739da9b3367c86017 || git revert --continue

popd

pushd "$DEVICE_OPPO_REPO"

  git remote add slimdevice https://github.com/SlimRoms/device_oppo_common.git
  git fetch slimdevice

  # Don't break screen off gestures when dex preopting builds
  git cherry-pick a6d1ecd71eb3ce17fafae034068bc169f0b9005b
  # Materialize DeviceHandler settings
  git cherry-pick f9aebb542b60eceb42db145ca34df4aa058a4449 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

  git remote rm slimdevice

popd

# fixing build
pushd "$LOCAL_REPO/vendor/cmsdk"
  git revert 1d927754055ec17e44470659faf7dc77d65aa7f5
popd


pushd "$DEVICE_ONEPLUS_REPO"

  # reverting play with earphone volume to 95
  git revert 049e0d932fea084aa44faa7cea2adfb20ccad4ea
  git revert cb4314a0a6bdbdec1e344e0a15d076d789c63655

  # fixing build - msm8974: remove unused resources
  git remote add YoshiShaPow https://github.com/YoshiShaPow/android_device_oneplus_bacon.git
  git fetch YoshiShaPow

  git cherry-pick 58fe5f0b0431eda155827f45e61f574838a23ba1
  git cherry-pick 76250cf690ea9ba54a3436c2781e73ed788cf3bc
  git cherry-pick 7ede547aa174bf9b857c285aa20078fa515c9b84
  git cherry-pick 7064a00e4454315e7d8dd2514dcf8d2d31ccdba6
  git cherry-pick 5eb42a3da06f71e0ad0154a766a81773259dd9b8

  git remote rm YoshiShaPow

popd

exit 0

pushd "$BUILD_REPO"

  perl -p -i -e 's/\s\s\s\sDocumentsUI \\\n//' target/product/core.mk

  git add $(git status -s | awk '{print $2}')
  git commit -m "Get rid of DocumentsUI - unnecessary to my mind"

popd

#################################################################

# 34d0618faf6ba74351ea9b37fafcdb870b11c17a should fix that patch necessity (in the other way tho)
pushd frameworks/opt/net/wifi

  wget https://github.com/sultanxda/android_frameworks_opt_net_wifi/commit/fd779363dc10cf3e4b178c2ce5d3b1e84f46d378.patch && patch -p1 < fd779363dc10cf3e4b178c2ce5d3b1e84f46d378.patch
  git clean -f -d

  git add $(git status -s | awk '{print $2}')
  git commit -m "Placing Sultan's patches"

popd

pushd "$BUILD_REPO"

  sed -i "s#LMY48U#LMY48W#" core/build_id.mk

  git add $(git status -s | awk '{print $2}')
  git commit -m "Setting correct version id"

popd

pushd "$SETTINGS_REPO"

  git fetch https://gerrit.omnirom.org/android_packages_apps_Settings refs/changes/80/10180/3 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

popd

pushd "$VENDOR_REPO"

  # setting Nova as default launcher
  git remote add UberCM "$UBERCM_URL"
  git fetch UberCM

  git cherry-pick 189b2c10d0dd5b1025c5994c5093094b84c62aa0
  git cherry-pick 45c7ba3f11968e23cbaa1c93bbd9a91f0ad9f8d1
  git cherry-pick a22924b5baea579bc74df2272785ec6b4b626080
  git cherry-pick 7e68eb9c79f10931fbd16618cf59a3a929758281 || git add $(git status -s | awk '{print $2}') && git commit --allow-empty

  git remote rm UberCM

popd

# fixing media (and bootloop)
# http://review.cyanogenmod.org/#/c/106198/
# http://review.cyanogenmod.org/#/c/106197/

pushd "$FRAMEWORKS_BASE"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/98/106198/3 && git cherry-pick FETCH_HEAD
popd

pushd "$FRAMEWORKS_AV"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/97/106197/2 && git cherry-pick FETCH_HEAD
popd


# UberCM
# su sign removal
# non-intrusive calls

pushd "$FRAMEWORKS_BASE"

  git remote add UberCMfb https://github.com/UberCM/frameworks_base.git
  git fetch UberCMfb

  git cherry-pick 5f061adcaf478e2f4681f1b7926b721200e96704
  git cherry-pick 5135ef05d3300739dd0b91ab6b4c1e6f9453cd34 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

  git remote rm UberCMfb

popd

pushd "$SETTINGS_REPO"

  git remote add UberCMsettings https://github.com/UberCM/packages_apps_Settings.git
  git fetch UberCMsettings

  git cherry-pick 1b66c3e9410bbc8356a11958f5b6dce14f12548c || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

  git remote rm UberCMsettings


popd

pushd "$TELEPHONY_REPO"

  git remote add UberCMtelephony https://github.com/UberCM/packages_services_Telephony.git
  git fetch UberCMtelephony

  git cherry-pick 064ff6eedc3878d336724028aa5fdbd1d3b36187 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

  git remote rm UberCMtelephony

popd

exit 0

# reverting optimizations, which require libc 2.17
pushd "$BUILD_REPO"

#  git revert 13e2e8ccbb96beb9034f05c47e500f829dba56c9 || git rm core/jgcaap.mk && git revert --continue

  sed -i "s#4.8#4.6#" core/clang/HOST_x86_common.mk
  sed -i "s#4.8#4.6#" core/combo/HOST_linux-x86_64.mk
  sed -i "s#4.8#4.6#" core/combo/HOST_linux-x86.mk

  git add $(git status -s | awk '{print $2}')
  git commit -m "Reverting optimizations, which require libc 2.17"

popd

exit 0

pushd "$SETTINGS_REPO"

  sed -i "s#UberCM build#Build#" res/values/ubercm_strings.xml

  git add $(git status -s | awk '{print $2}')
  git commit -m "Setting more common build name string"

popd
