#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

BUILD_REPO="$LOCAL_REPO/build/"
DEVICE_REPO="$LOCAL_REPO/device/oppo/msm8974-common/"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

# cm: sepolicy: allow kernel to read storage (http://review.cyanogenmod.org/#/c/127767/)
pushd "$LOCAL_REPO/vendor/slim"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_vendor_cm refs/changes/67/127767/2 && git cherry-pick FETCH_HEAD
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
# hal: APQ8084 uses AUDIO_PARAMETER_KEY_BT_SCO_WB for bluetooth wideband
pushd "$LOCAL_REPO/hardware/qcom/audio-caf/msm8974"
  git remote add CM https://github.com/CyanogenMod/android_hardware_qcom_audio.git
  git fetch CM
  git cherry-pick 506b1e167f3e1b5186aa62d3dc4aabaf9024d53c
  git remote rm CM
popd
# Ensure non-null encoded uri before attempting to parse (http://review.cyanogenmod.org/#/c/129294/)
pushd "$LOCAL_REPO/packages/apps/ContactsCommon"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_ContactsCommon refs/changes/94/129294/1 && git cherry-pick FETCH_HEAD
popd

pushd "$LOCAL_REPO/kernel/oneplus/msm8974/"
  # KEYS: Fix race between read and revoke - CVE-2015-7550 (http://review.cyanogenmod.org/#/c/134713/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_htc_msm8974 refs/changes/13/134713/1 && git cherry-pick FETCH_HEAD
  # tty: Fix unsafe ldisc reference via ioctl(TIOCGETD) (http://review.cyanogenmod.org/#/c/134722/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_htc_msm8974 refs/changes/22/134722/2 && git cherry-pick FETCH_HEAD
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
