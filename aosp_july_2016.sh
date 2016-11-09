#!/bin/bash

# patching android-5.1.1_r37 with Google July 2016 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2016-06-01#PLATFORM_SECURITY_PATCH := 2016-07-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2016-07-01"
popd
pushd "$LOCAL_REPO/frameworks/av"
  git remote add aosp https://android.googlesource.com/platform/frameworks/av/
  git fetch aosp
  git cherry-pick 60547808ca4e9cfac50028c00c58a6ceb2319301
  git cherry-pick e248db02fbab2ee9162940bc19f087fd7d96cb9d
  git cherry-pick f81038006b4c59a5a148dcad887371206033c28f
  git cherry-pick d112f7d0c1dbaf0368365885becb11ca8d3f13a4
  #git cherry-pick 6fdee2a83432b3b150d6a34f231c4e2f7353c01e || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # limit mediaserver memory (https://review.cyanogenmod.org/#/c/152160/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/60/152160/2 && git cherry-pick FETCH_HEAD
  git cherry-pick e7142a0703bc93f75e213e96ebc19000022afed9
  git cherry-pick daef4327fe0c75b0a90bb8627458feec7a301e1f
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/native"
  git remote add aosp https://android.googlesource.com/platform/frameworks/native
  git fetch aosp
  git cherry-pick 54cb02ad733fb71b1bdf78590428817fb780aff8
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/tremolo"
  #git remote add aosp https://android.googlesource.com/platform/external/tremolo
  #git fetch aosp
  git cherry-pick 659030a2e80c38fb8da0a4eb68695349eec6778b
  #git remote rm aosp
popd
pushd "$LOCAL_REPO/system/core"
  git remote add aosp https://android.googlesource.com/platform/system/core
  git fetch aosp
  git cherry-pick ae18eb014609948a40e22192b87b10efc680daa7
  git remote rm aosp
popd
pushd "$LOCAL_REPO/dalvik"
  #git remote add aosp https://android.googlesource.com/platform/dalvik
  #git fetch aosp
  git cherry-pick 338aeaf28e9981c15d0673b18487dba61eb5447c
  #git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/base"
  git remote add aosp https://android.googlesource.com/platform/frameworks/base
  git fetch aosp
  #git cherry-pick 9b8c6d2df35455ce9e67907edded1e4a2ecb9e28 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # DO NOT MERGE : backport of backup transport whitelist (https://review.cyanogenmod.org/#/c/152168/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/68/152168/2 && git cherry-pick FETCH_HEAD
  git cherry-pick ec2fc50d202d975447211012997fe425496c849c
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/sepolicy"
  git remote add aosp https://android.googlesource.com/platform/external/sepolicy/
  git fetch aosp
  git cherry-pick abf0663ed884af7bc880a05e9529e6671eb58f39
  git remote rm aosp
popd
pushd "$LOCAL_REPO/hardware/libhardware"
  git remote add aosp https://android.googlesource.com/platform/hardware/libhardware
  git fetch aosp
  git cherry-pick 8b3d5a64c3c8d010ad4517f652731f09107ae9c5
  git remote rm aosp
popd

exit 0

# added my CM

# have to take this one from https://git.openssl.org/?p=openssl.git;a=commit;h=3661bb4e7934668bd99ca777ea8b30eedfafa871
# because 6.0.1 has BoringSSL instead of OpenSSL and there is no OpenSSL fix from Google
pushd "$LOCAL_REPO/external/openssl"
  git apply $HOME/uber-saber/patches/CVE-2016-2108.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Fix encoding bug in i2c_ASN1_INTEGER"
popd
pushd "$LOCAL_REPO/external/bluetooth/bluedroid"
  git remote add aosp https://android.googlesource.com/platform/system/bt && git fetch aosp
  git cherry-pick 514139f4b40cbb035bb92f3e24d5a389d75db9e6
  # CVE-2016-3760 - too hard to merge, code is totally rewritten, cannot include guest mode without adding the new BT working model...
  #git cherry-pick 37c88107679d36c419572732b4af6e18bb2f7dce || git rm tools/bdtool/bdtool.c && git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/packages/apps/Bluetooth"
  git remote add aosp https://android.googlesource.com/platform/packages/apps/Bluetooth/ && git fetch aosp
  git cherry-pick 122feb9a0b04290f55183ff2f0384c6c53756bd8 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/libpng"
  git remote add aosp https://android.googlesource.com/platform/external/libpng && git fetch aosp
  git cherry-pick 9d4853418ab2f754c2b63e091c29c5529b8b86ca || git add pngrutil.c && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/hardware/qcom/audio-caf/msm8974"
  git remote add aosp https://android.googlesource.com/platform/hardware/qcom/audio && git fetch aosp
  git cherry-pick 073a80800f341325932c66818ce4302b312909a4
  git remote rm aosp
popd
pushd "$LOCAL_REPO/packages/apps/Nfc"
  git remote add aosp https://android.googlesource.com/platform/packages/apps/Nfc/ && git fetch aosp
  git cherry-pick 9ea802b5456a36f1115549b645b65c791eff3c2c
  git remote rm aosp
popd
