#!/bin/bash

# patching android-5.1.1_r37 with Google September 2016 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2016-08-01#PLATFORM_SECURITY_PATCH := 2016-09-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2016-09-01"
popd
pushd "$LOCAL_REPO/system/core"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/10/162010/2 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/09/162009/1 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/11/162011/2 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/frameworks/av"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/14/162014/1 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/15/162015/2 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/16/162016/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/17/162017/2 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/18/162018/2 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/19/162019/2 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/20/162020/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/21/162021/2 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/26/162026/1 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
popd
pushd "$LOCAL_REPO/frameworks/base"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/23/162023/2 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/27/162027/1 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/22/162022/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/frameworks/opt/telephony"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_opt_telephony refs/changes/04/162004/1 && git cherry-pick FETCH_HEAD
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_opt_telephony refs/changes/05/162005/2 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/packages/services/Telephony"
  #git cherry-pick d1d248d10cf03498efb7041f1a8c9c467482a19d
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_services_Telephony refs/changes/08/162008/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/external/libvpx"
  #git cherry-pick 4974dcbd0289a2530df2ee2a25b5f92775df80da
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_libvpx refs/changes/02/162002/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/libcore"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_libcore refs/changes/06/162006/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/external/flac"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_flac refs/changes/00/162000/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/external/bouncycastle"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_bouncycastle refs/changes/99/161999/1 && git cherry-pick FETCH_HEAD
popd

exit 0

# Sultanxda merged it
pushd "$LOCAL_REPO/kernel/oneplus/msm8974"
  [ $(git remote | egrep \^CAF) ] && git remote rm CAF
  git remote add CAF https://source.codeaurora.org/quic/la/kernel/msm-3.10 && git fetch CAF
  # ASoC: wcd9xxx: Fix unprotected userspace access
  git cherry-pick a7a6ddc91cce7ad5ad55c9709b24bfc80f5ac873
  git remote rm CAF
popd

pushd "$LOCAL_REPO/external/sonivox"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_sonivox refs/changes/03/162003/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/packages/apps/Email"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Email refs/changes/07/162007/1 && git cherry-pick FETCH_HEAD
popd
