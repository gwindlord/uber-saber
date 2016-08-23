#!/bin/bash

# patching android-5.1.1_r37 with Google August 2016 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2016-07-01#PLATFORM_SECURITY_PATCH := 2016-08-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2016-08-01"
popd
pushd "$LOCAL_REPO/frameworks/av"
  git remote add aosp https://android.googlesource.com/platform/frameworks/av/
  git fetch aosp
  git cherry-pick 590d1729883f700ab905cdc9ad850f3ddd7e1f56
  git cherry-pick 42a25c46b844518ff0d0b920c20c519e1417be69
  #git cherry-pick 1f24c730ab6ca5aff1e3137b340b8aeaeda4bdbc || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick 9cd8c3289c91254b3955bd7347cf605d6fa032c6
  git cherry-pick 8e438e153f661e9df8db0ac41d587e940352df06
  git remote rm aosp

  # DO NOT MERGE: Camera: Adjust pointers to ANW buffers to avoid infoleak (http://review.cyanogenmod.org/#/c/155621/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/21/155621/2 && git cherry-pick FETCH_HEAD

  # DO NOT MERGE omx: check buffer port before using (http://review.cyanogenmod.org/#/c/155622/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/22/155622/2 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/frameworks/base"
  #git remote add aosp https://android.googlesource.com/platform/frameworks/base/
  #git fetch aosp
  # Don't trust callers to supply app info to bindBackupAgent() (http://review.cyanogenmod.org/#/c/155624/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/24/155624/2 && git cherry-pick FETCH_HEAD
  #git cherry-pick e7cf91a198de995c7440b3b64352effd2e309906 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # DO NOT MERGE: Reduce shell power over user management. (http://review.cyanogenmod.org/#/c/155625/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/25/155625/2 && git cherry-pick FETCH_HEAD
  #git cherry-pick 01875b0274e74f97edf6b0d5c92de822e0555d03 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # DO NOT MERGE Fix intent filter priorities (http://review.cyanogenmod.org/#/c/155623/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/23/155623/1 && git cherry-pick FETCH_HEAD
  #git cherry-pick a75537b496e9df71c74c1d045ba5569631a16298
  # DO NOT MERGE: Add pm operation to set user restrictions. (http://review.cyanogenmod.org/#/c/155626/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/26/155626/2 && git cherry-pick FETCH_HEAD
  #git cherry-pick 4e4743a354e26467318b437892a9980eb9b8328a || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  #git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/native"
  git remote add aosp https://android.googlesource.com/platform/frameworks/native
  git fetch aosp
  git cherry-pick 3bcf0caa8cca9143443814b36676b3bae33a4368
  #git cherry-pick 9f590df0b73d14e0c30e970098f2369403eb2617
  #git cherry-pick 3454f123d0a10bd0ce0760828996aa26c80a8fd4 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  #git cherry-pick a8c2454d52d3c23bd53b4a172eff8e5f4af30168
  #git cherry-pick d910f3cf78ae878b1b86ead7ca837004c3a25aaa
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/opt/telephony"
  git remote add aosp https://android.googlesource.com/platform/frameworks/opt/telephony
  git fetch aosp
  git cherry-pick f47bc301ccbc5e6d8110afab5a1e9bac1d4ef058
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/opt/net/wifi"
  git remote add aosp https://android.googlesource.com/platform/frameworks/opt/net/wifi
  git fetch aosp
  git cherry-pick a209ff12ba9617c10550678ff93d01fb72a33399
  git remote rm aosp
popd
pushd "$LOCAL_REPO/kernel/oneplus/msm8974/"
  git remote add linux https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  git fetch linux
  git cherry-pick 5f8e44741f9f216e33736ea4ec65ca9ac03036e6 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick 3567eb6af614dac436c4b16a8d426f9faed639b3
  git remote rm linux

  git remote add CAF https://source.codeaurora.org/quic/la/kernel/msm
  git fetch CAF
  git cherry-pick cc4b26575602e492efd986e9a6ffc4278cee53b5 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick f2a3f5e63e15e97a66e8f5a300457378bcb89d9c
  git cherry-pick 8d1f7531ff379befc129a6447642061e87562bca || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm CAF
popd
pushd "$LOCAL_REPO/system/netd"
  git remote add CAF https://source.codeaurora.org/quic/la/platform/system/netd
  git fetch CAF
  git cherry-pick cc2853e6cec8ca2cf92430ad9a83358b131fc417 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm CAF
popd

exit 0

# added by CM
pushd "$LOCAL_REPO/external/bluetooth/bluedroid"
  # DO NOT MERGE Fix potential DoS caused by delivering signal to BT process (http://review.cyanogenmod.org/#/c/155612/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_bluetooth_bluedroid refs/changes/12/155612/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/external/conscrypt"
  git remote add aosp https://android.googlesource.com/platform/external/conscrypt && git fetch aosp
  git cherry-pick 5af5e93463f4333187e7e35f3bd2b846654aa214 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/jhead/"
  git remote add aosp https://android.googlesource.com/platform/external/jhead && git fetch aosp
  git cherry-pick bae671597d47b9e5955c4cb742e468cebfd7ca6b
  git remote rm aosp
popd
# have to take this one from https://git.openssl.org/?p=openssl.git;a=commit;h=578b956fe741bf8e84055547b1e83c28dd902c73
# because 6.0.1 has BoringSSL instead of OpenSSL and there is no OpenSSL fix from Google
pushd "$LOCAL_REPO/external/openssl"
  # Fix memory issues in BIO_*printf functions (http://review.cyanogenmod.org/#/c/155616/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_openssl refs/changes/16/155616/1 && git cherry-pick FETCH_HEAD
  #git apply $HOME/uber-saber/patches/CVE-2016-2842.patch
  #git add $(git status -s | awk '{print $2}') && git commit -m "Fix memory issues in BIO_*printf functions"
popd
#https://android.googlesource.com/platform/system/bt/+/472271b153c5dc53c28beac55480a8d8434b2d5c (external/bluetooth/bluedroid)
#https://source.codeaurora.org/quic/la/platform/system/netd/commit/?h=LA.BR.1&id=568ef402f6d5a7a50c126aafc78c4edf59abba1c

