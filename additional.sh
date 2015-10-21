#!/bin/bash

LOCAL_REPO="/data/slimsaber"
SETTINGS_REPO="$LOCAL_REPO/packages/apps/Settings"
KERNEL_INCLUDES="$LOCAL_REPO/kernel/oneplus/msm8974/"
UBERCM_URL="https://github.com/UberCM/vendor_ubercm.git"
DEVICE_REPO="$LOCAL_REPO/device/oppo/msm8974-common/"
ROM_PACKAGES_MAKEFILE="$LOCAL_REPO/device/oppo/msm8974-common/msm8974.mk"
VENDOR_REPO="$LOCAL_REPO/vendor/slim"
MY_VENDOR_REPO="$LOCAL_REPO/vendor/gwindlord"
CONFIG_FILE="config/common.mk"
FRAMEWORKS_BASE="$LOCAL_REPO/frameworks/base"
FRAMEWORKS_AV="$LOCAL_REPO/frameworks/av"
COMMON_FILE="$LOCAL_REPO/vendor/slim/config/common.mk"
BUILD_REPO="$LOCAL_REPO/build/"
SYSTEM_CORE="$LOCAL_REPO/system/core"
SULTAN_CORE_URL="https://github.com/sultanxda/android_system_core.git"
TELEPHONY_REPO="$LOCAL_REPO/packages/services/Telephony"
DEVICE_OPPO_REPO="$LOCAL_REPO/device/oppo/common/"

pushd "$VENDOR_REPO"

  # setting Nova as default launcher
  git remote add UberCM "$UBERCM_URL"
  git fetch UberCM

  git cherry-pick 45c7ba3f11968e23cbaa1c93bbd9a91f0ad9f8d1 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
#  git cherry-pick 7e68eb9c79f10931fbd16618cf59a3a929758281 || git add $(git status -s | awk '{print $2}') && git commit --allow-empty

  git remote rm UberCM

  sed -i 's#:system/etc/backup.conf#:system/etc/backup.conf \\\n    vendor/slim/prebuilt/common/bin/73-browsersync.sh:system/addon.d/73-browsersync.sh#' "$CONFIG_FILE"
  sed -i 's#    SlimLauncher \\#    CMFileManager \\#' "$CONFIG_FILE"
  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding Browser sync backup script and CM File manager to the build"

  cp proprietary/CameraNextMod/Android.mk $LOCAL_REPO/vendor/gwindlord/proprietary/CameraNextMod/
  git rm proprietary/CameraNextMod/Android.mk && git commit -m "Remove duplicate"

#  cp $LOCAL_REPO/vendor/gwindlord/proprietary/CameraNextMod/CameraNextMod.apk proprietary/CameraNextMod/
#  git add $(git status -s | awk '{print $2}') && git commit -m "Setting translated Camera"

popd

pushd "$MY_VENDOR_REPO"

#  git rm proprietary/CameraNextMod/Android.mk && git commit -m "Remove duplicate"

  git add proprietary/CameraNextMod/Android.mk && git commit -m "Setting translated Camera"

popd

pushd $(dirname "$COMMON_FILE")

  sed -i 's#%Y%m%d#%Y%m%d-%H%M#' "$COMMON_FILE"

  git add $(git status -s | awk '{print $2}')
  git commit -m "Setting more presice zip date"

popd

pushd $(dirname "$ROM_PACKAGES_MAKEFILE")

  sed -i 's/^    libantradio/    libantradio\n\n# ChromeBookmarksSyncAdapter\nPRODUCT_PACKAGES += \\\n    ChromeBookmarksSyncAdapter/' "$ROM_PACKAGES_MAKEFILE"

  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding Browser sync"

popd

# msm8974: Enable adaptive LMK (http://review.cyanogenmod.org/#/c/103749/)
pushd "$DEVICE_REPO"

  #git revert 20335991423c255d1f6471d804fa7a547a87b39d

  git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oppo_msm8974-common refs/changes/49/103749/1 && git cherry-pick FETCH_HEAD

popd

pushd "$SYSTEM_CORE"

  git remote add SultanCore "$SULTAN_CORE_URL"
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

pushd "$FRAMEWORKS_BASE"

  wget https://github.com/CyanogenMod/android_frameworks_base/commit/e75f59e7fd349dd1fa5d452086c795f693776d89.patch && patch -p1 < e75f59e7fd349dd1fa5d452086c795f693776d89.patch
  wget https://github.com/sultanxda/android_frameworks_base/commit/0cbd4a88767d78640b7dd391674575f7d5e517e6.patch && patch -p1 < 0cbd4a88767d78640b7dd391674575f7d5e517e6.patch
  git clean -f -d

  git add $(git status -s | awk '{print $2}')
  git commit -m "StrictMode: Disable all strict mode functions when disable prop is set; telephony: Hack GSM and LTE signal strength; telephony: Handle NPE in setDataEnabledUsingSubId(); SpamFilter : Avoid a requery for each item"

popd

# removing Viper commit
pushd external/sepolicy/

  git revert 9e46bc6fee9ca77f743b694739da9b3367c86017 || git revert --continue

popd

pushd "$DEVICE_OPPO_REPO"

  git remote add slimdevice https://github.com/SlimRoms/device_oppo_common.git
  git fetch slimdevice

  git cherry-pick a6d1ecd71eb3ce17fafae034068bc169f0b9005b
  git cherry-pick f9aebb542b60eceb42db145ca34df4aa058a4449 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

  git remote rm slimdevice

popd

pushd "$LOCAL_REPO/vendor/cmsdk"

  git revert 1d927754055ec17e44470659faf7dc77d65aa7f5

popd

pushd "$BUILD_REPO"

  sed -i "s#LMY48U#LMY48W#" core/build_id.mk

  git add $(git status -s | awk '{print $2}')
  git commit -m "Setting correct version id"

popd

exit 0

#################################################################

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
