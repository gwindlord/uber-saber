#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

BUILD_REPO="$LOCAL_REPO/build/"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

# cm: sepolicy: allow kernel to read storage (http://review.cyanogenmod.org/#/c/127767/)
pushd "$LOCAL_REPO/vendor/slim"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_vendor_cm refs/changes/67/127767/2 && git cherry-pick FETCH_HEAD
popd

pushd "$LOCAL_REPO/packages/apps/CMFileManager"
  perl -p -i -e 's#\<\/xliff\:g\> \%\<#\<\/xliff\:g\> \\\%\<#' res/values-ru/strings.xml
  git add $(git status -s | awk '{print $2}') && git commit -m "Fixing Russian locale"
popd

# CM12 recent features

# Lockscreen: Show redaction interstitial when swipe selected
pushd "$LOCAL_REPO/packages/apps/Settings"
  git remote add CM https://github.com/CyanogenMod/android_packages_apps_Settings.git
  git fetch CM
  git cherry-pick 53047194c7d8a3245b0d2568d287912f406a1a08
  git remote rm CM
popd
# TeleService: Add call barring feature (http://review.cyanogenmod.org/#/c/129008/)
pushd "$LOCAL_REPO/packages/services/Telephony/"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_services_Telephony refs/changes/08/129008/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/hardware/qcom/audio-caf/msm8974"
  # hal: APQ8084 uses AUDIO_PARAMETER_KEY_BT_SCO_WB for bluetooth wideband
  git remote add CM https://github.com/CyanogenMod/android_hardware_qcom_audio.git
  git fetch CM
  git cherry-pick 506b1e167f3e1b5186aa62d3dc4aabaf9024d53c
  git remote rm CM
  # hal: Reduce minimum offload fragment size for PCM offload (http://review.cyanogenmod.org/#/c/135647/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_hardware_qcom_audio refs/changes/47/135647/2 && git cherry-pick FETCH_HEAD
popd
# Ensure non-null encoded uri before attempting to parse (http://review.cyanogenmod.org/#/c/129294/)
pushd "$LOCAL_REPO/packages/apps/ContactsCommon"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_ContactsCommon refs/changes/94/129294/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/device/oppo/msm8974-common/"
  # http://review.cyanogenmod.org/#/c/135685/
  sed -i "s#audio.offload.pcm.16bit.enable=true#audio.offload.pcm.16bit.enable=false#" msm8974.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Disable 16-bit PCM offload for good (http://review.cyanogenmod.org/#/c/135685/)"
  # oppo_msm8974-common: support f2fs volumes (http://review.cyanogenmod.org/#/c/92999/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oppo_msm8974-common refs/changes/99/92999/2 && git cherry-pick FETCH_HEAD
popd

# F2FS support
pushd "$LOCAL_REPO/device/oneplus/bacon"
  #git cherry-pick e5308ebdd4eff41ffd781301febae11467cb6a38 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # http://review.cyanogenmod.org/#/c/92998
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oneplus_bacon refs/changes/98/92998/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  sed -i "s#BOARD_USERDATAEXTRAIMAGE_PARTITION_NAME := 64G#BOARD_USERDATAEXTRAIMAGE_PARTITION_NAME := 64G\nTARGET_USERIMAGES_USE_EXT4 := true\nTARGET_USERIMAGES_USE_F2FS := true#" BoardConfig.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Add missing F2FS and EXT4 flags"
popd

# fs: introduce a generic shutdown ioctl (http://review.cyanogenmod.org/#/c/92997)
pushd "$LOCAL_REPO/kernel/oneplus/msm8974"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/97/92997/2 && git cherry-pick FETCH_HEAD
popd

# Forward Port: Add Camera sound toggle [3/3] - was suddenly missing, so camera sound switcher did nothing >_<
pushd "$LOCAL_REPO/frameworks/av"
  git fetch https://review.slimroms.org/SlimRoms/frameworks_av refs/changes/53/1853/1 && git cherry-pick FETCH_HEAD
popd

# init: fix usage of otg-usb storage devices from within applications (http://review.cyanogenmod.org/#/c/134914/)
pushd "$LOCAL_REPO/device/oneplus/bacon"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oneplus_bacon refs/changes/14/134914/1 && git cherry-pick FETCH_HEAD
popd

# The IT Crowd rocks! ;)
pushd "$LOCAL_REPO/packages/apps/Dialer"
  git remote add AOSP https://android.googlesource.com/platform/packages/apps/Dialer
  git fetch AOSP
  git cherry-pick 83131715419e89eebe8e4ea7ada7f96ec37dd8f9 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm AOSP
popd

# Force OpenWeatherMap to be the weather provider - Yahoo changed API again >_<
pushd "$LOCAL_REPO/packages/apps/LockClock"
  git reset --hard && git clean -f -d
  wget -q https://github.com/sultanxda/android_packages_apps_LockClock/commit/201e3f432b9266dc7cb3d35a909e7710f9017ceb.patch
  patch -p1 -s < 201e3f432b9266dc7cb3d35a909e7710f9017ceb.patch
  git clean -f -d
  git add $(git status -s | awk '{print $2}') && git commit -m "Force OpenWeatherMap to be the weather provider"
popd
exit 0

#################

# LZ4
pushd "$LOCAL_REPO/kernel/oneplus/msm8974"
  git remote add jgcaap https://github.com/jgcaaprom/android_kernel_oneplus_msm8974.git
  git fetch jgcaap
  git cherry-pick 6769cae315d98f6bd18ff28f5eca0169b07b2bfe
  git remote rm jgcaap

  git remote add faux123 https://github.com/faux123/mako.git
  git fetch faux123
  git cherry-pick b421b4ceec4fc450e5c9ad9b3c1bf9fda5144a3e
  git remote rm faux123
popd
pushd "$LOCAL_REPO/device/oneplus/bacon"
  sed -i "s#AUDIO_FEATURE_LOW_LATENCY_PRIMARY := true#AUDIO_FEATURE_LOW_LATENCY_PRIMARY := true\n\nTARGET_TRANSPARENT_COMPRESSION_METHOD := lz4#" BoardConfig.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Boardconfig : lz4"
popd

# JustArchi's optimizations
# require his toolchains in manifest
# but for a week I did not noticed any difference

pushd "$BUILD_REPO"
  git remote add JustArchi https://github.com/ArchiDroid/android_build.git
  git fetch JustArchi
  git cherry-pick f9b983e8e11624b48ae575da206f1baf6979772c || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm JustArchi
popd

pushd external/bluetooth/bluedroid/
  git remote add Archi https://github.com/ArchiDroid/android_external_bluetooth_bluedroid.git
  git fetch Archi
  git cherry-pick 932c01b05465fbf1ae3933efa915902b7f30aec9
  git remote rm Archi
popd

pushd frameworks/av
  git remote add Archi https://github.com/ArchiDroid/android_frameworks_av.git
  git fetch Archi
  git cherry-pick 038d57b7b713edb1016d5dcc977459701949e487
  git remote rm Archi
popd
