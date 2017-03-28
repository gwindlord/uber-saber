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
  # at lineae gerrit loog for comment:"162010" and so on - they have initial cm gerrit addresses in comments as importing log
  # https://review.lineageos.org/#/c/142889/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/10/162010/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_system_core refs/changes/89/142889/2 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/142890/
  # git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/09/162009/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_system_core refs/changes/90/142890/1 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/142888/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/11/162011/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_system_core refs/changes/88/142888/2 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/frameworks/av"
  # https://review.lineageos.org/#/c/62540/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/14/162014/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/40/62540/1 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/62539/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/15/162015/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/39/62539/2 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/62538/
  # git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/16/162016/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/38/62538/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # https://review.lineageos.org/#/c/62537/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/17/162017/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/37/62537/2 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/62536/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/18/162018/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/36/62536/2 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/62535/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/19/162019/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/35/62535/2 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/62534/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/20/162020/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/34/62534/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # https://review.lineageos.org/#/c/62533/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/21/162021/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/33/62533/2 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/62532/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/26/162026/1 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/32/62532/1 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
popd
pushd "$LOCAL_REPO/frameworks/base"
  # https://review.lineageos.org/#/c/65548/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/23/162023/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/48/65548/2 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/65547/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/27/162027/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/47/65547/1 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/65549/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/22/162022/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/49/65549/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/frameworks/opt/telephony"
  # https://review.lineageos.org/#/c/71262/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_opt_telephony refs/changes/04/162004/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_opt_telephony refs/changes/62/71262/1 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/71261/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_opt_telephony refs/changes/05/162005/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_opt_telephony refs/changes/61/71261/2 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/packages/services/Telephony"
  # Make TTY broadcasts protected
  git cherry-pick d1d248d10cf03498efb7041f1a8c9c467482a19d
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_services_Telephony refs/changes/08/162008/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/external/libvpx"
  # libvpx: cherry-pick aa1c813 from upstream
  git cherry-pick 4974dcbd0289a2530df2ee2a25b5f92775df80da
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_libvpx refs/changes/02/162002/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/libcore"
  # https://review.lineageos.org/#/c/108941/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_libcore refs/changes/06/162006/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_libcore refs/changes/41/108941/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/external/flac"
  # https://review.lineageos.org/#/c/60292/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_flac refs/changes/00/162000/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_external_flac refs/changes/92/60292/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/external/bouncycastle"
  # https://review.lineageos.org/#/c/59649/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_bouncycastle refs/changes/99/161999/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_external_bouncycastle refs/changes/49/59649/1 && git cherry-pick FETCH_HEAD
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
