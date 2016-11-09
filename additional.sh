#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

SCRIPT_DIR="$(dirname $(readlink -f $0))"

VENDOR_REPO="$LOCAL_REPO/vendor/slim"
CONFIG_FILE="config/common.mk"
MY_VENDOR_REPO="$LOCAL_REPO/vendor/gwindlord"

DEVICE_REPO="$LOCAL_REPO/device/oppo/msm8974-common/"
ROM_PACKAGES_MAKEFILE="msm8974.mk"

SYSTEM_CORE="$LOCAL_REPO/system/core"

FRAMEWORKS_BASE="$LOCAL_REPO/frameworks/base"
TELEPHONY_REPO="$LOCAL_REPO/packages/services/Telephony"

DEVICE_OPPO_REPO="$LOCAL_REPO/device/oppo/common/"

FRAMEWORKS_OPT_TELEPHONY="$LOCAL_REPO/frameworks/opt/telephony"

DEVICE_ONEPLUS_REPO="$LOCAL_REPO/device/oneplus/bacon"

DIALER_REPO="$LOCAL_REPO/packages/apps/Dialer"

########################################

pushd "$VENDOR_REPO"
  # setting Nova as default launcher
  git remote add UberCM https://github.com/UberCM/vendor_ubercm.git
  git fetch UberCM
  git cherry-pick 45c7ba3f11968e23cbaa1c93bbd9a91f0ad9f8d1 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm UberCM
  sed -i 's#    SlimLauncher \\#    CMFileManager \\#' "$CONFIG_FILE"
  git add $(git status -s | awk '{print $2}')
  git commit -m "Adding Snapdragon Chromium and CM File manager to the build"
  git rm proprietary/CameraNextMod/Android.mk && git commit -m "Remove CameraNextMod duplicate"
popd

pushd "$VENDOR_REPO"
  sed -i 's#%Y%m%d#%Y%m%d-%H%M#' "$CONFIG_FILE"
  git add $(git status -s | awk '{print $2}')
  git commit -m "Setting more presice zip date"
popd

pushd "$DEVICE_REPO"
  # msm8974: Enable adaptive LMK (http://review.cyanogenmod.org/#/c/103749/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oppo_msm8974-common refs/changes/49/103749/1 && git cherry-pick FETCH_HEAD
  # fixing build - msm8974: remove unused resources
  git remote add kwoktopus https://github.com/kwoktopus/android_device_oppo_msm8974-common.git
  git fetch kwoktopus
  git cherry-pick 2cdb7c4ddb349be16ee7ecfdb4f1bc634c0d267d
  git remote rm kwoktopus
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
  # Wifi tile: don't set items visible from non-ui thread
  wget -q https://github.com/CyanogenMod/android_frameworks_base/commit/06c39e200cd5edfb6019cd725343654e1d9a8fe3.patch && patch -p1 -s < 06c39e200cd5edfb6019cd725343654e1d9a8fe3.patch
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
  git revert --no-edit 1d927754055ec17e44470659faf7dc77d65aa7f5
popd

pushd "$DEVICE_ONEPLUS_REPO"
  # fixing build - msm8974: remove unused resources
#  git remote add kwoktopus https://github.com/kwoktopus/android_device_oneplus_bacon.git
#  git fetch kwoktopus
#  git cherry-pick 58fe5f0b0431eda155827f45e61f574838a23ba1
#  git cherry-pick 76250cf690ea9ba54a3436c2781e73ed788cf3bc
#  git cherry-pick 7ede547aa174bf9b857c285aa20078fa515c9b84
#  git cherry-pick 7064a00e4454315e7d8dd2514dcf8d2d31ccdba6
#  git cherry-pick 5eb42a3da06f71e0ad0154a766a81773259dd9b8
#  git remote rm kwoktopus

  # Slimfy CM
  git remote add SlimRoms https://github.com/SlimRoms/device_oneplus_bacon.git
  git fetch SlimRoms
  git cherry-pick 12002985e992dfd5103a04a05bb9a03c2c7cd52b || git add BoardConfig.mk overlay/frameworks/base/core/res/res/values/config.xml && git rm cm.dependencies && git cherry-pick --continue
  git remote rm SlimRoms

  sed -i 's#bacon_defconfig#bacon_defconfig\nTARGET_GCC_VERSION_EXP=4.9-cortex-a15\nSUPPRES_UNUSED_WARNING=true#' BoardConfig.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Cortex 4.9 GCC and unused warnings suppressed"

  # bacon: Re-enable Fluence from CM13
  git cherry-pick c31a9e117266929b5ff15c665b6f587ff95f8f0f || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick 4303c6dbfd49831388fc53b702650a1492b2b9d8 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick 73d5bfae8cb6ae58fbb1ba7ffab17c6108150cbe || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  mv audio/acdb/MTP_Handset_cal.acdb $DEVICE_REPO/audio/acdb/
  mv audio/acdb/MTP_Speaker_cal.acdb $DEVICE_REPO/audio/acdb/
  git rm $(git status -s | awk '{print $2}') && git commit -m "Moving necessary 5.1 files"

  sed -i 's#persist.audio.fluence.voicecall=true#persist.audio.fluence.voicecall=true\npersist.audio.fluence.voicerec=false\npersist.audio.fluence.speaker=false\nro.ril.amr.wideband.enable=1#' system.prop
  sed -Ei -z 's#(\s+<path name="ear">\n\s+<ctl name="RX1 MIX1 INP1" value="RX1" />\n\s+<ctl name="CLASS_H_DSM MUX" value="DSM_HPHL_RX1" />\n\s+)<ctl name="RX1 Digital Volume" value="90" />#\1<ctl name="RX1 Digital Volume" value="95" />#' audio/mixer_paths.xml
  sed -Ei -z 's#(\s+)<ctl name="RX3 Digital Volume" value="80" />#\1<ctl name="RX3 Digital Volume" value="89" />#' audio/mixer_paths.xml
  sed -Ei -z 's#(\s+)<ctl name="RX4 Digital Volume" value="80" />#\1<ctl name="RX4 Digital Volume" value="89" />#' audio/mixer_paths.xml
  git add $(git status -s | awk '{print $2}') && git commit -m "Increasing speaker volume, reverting earphone volume to 95 and setting Fluence and wideband (HD call) additional parameters"
popd

pushd "$DEVICE_REPO"
  git add $(git status -s | awk '{print $2}') && git commit -m "Moving necessary 5.1 Fluence files"
popd

pushd "$DIALER_REPO"
  git remote add CM https://github.com/CyanogenMod/android_packages_apps_Dialer.git
  git fetch CM
  git cherry-pick 4395a7ed38676f405d1b0da67916cc849526b083
  git cherry-pick 5fbf6ec963f37803e61f449f8fd7b9a4636bc1dd
  git remote rm CM
popd

pushd "$LOCAL_REPO/external/sqlite"
  cp $SCRIPT_DIR/patches/sqlite3.11.1.patch .
  git apply sqlite3.11.1.patch && rm sqlite3.11.1.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Upgrade SQLite to 3.11.1"

  cp $SCRIPT_DIR/patches/sqlite3.13.0.patch .
  git apply sqlite3.13.0.patch && rm sqlite3.13.0.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Upgrade SQLite to 3.13.0"

  cp $SCRIPT_DIR/patches/sqlite3.15.1.patch .
  git apply sqlite3.15.1.patch && rm sqlite3.15.1.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Upgrade SQLite to 3.15.1"
popd

#################################################################
