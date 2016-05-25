#!/bin/bash

# patching android-5.1.1_r37 with Google May 2016 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2016-04-01#PLATFORM_SECURITY_PATCH := 2016-05-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2016-05-01"
popd

pushd "$LOCAL_REPO/external/aac"
  git remote add aosp https://android.googlesource.com/platform/external/aac && git fetch aosp
  git cherry-pick 5d4405f601fa11a8955fd7611532c982420e4206
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/flac"
  git remote add aosp https://android.googlesource.com/platform/external/flac && git fetch aosp
  git cherry-pick b499389da21d89d32deff500376c5ee4f8f0b04c
  git remote rm aosp
popd
pushd "$LOCAL_REPO/system/core"
  git apply $HOME/uber-saber/patches/ad54cfed4516292654c997910839153264ae00a0.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Don't demangle symbol names."
popd
pushd "$LOCAL_REPO/frameworks/native"
  git remote add aosp https://android.googlesource.com/platform/frameworks/native && git fetch aosp
  git cherry-pick a59b827869a2ea04022dd225007f29af8d61837a
  git cherry-pick a30d7d90c4f718e46fb41a99b3d52800e1011b73
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/av"
  git remote add aosp https://android.googlesource.com/platform/frameworks/av/ && git fetch aosp
  git cherry-pick a2d1d85726aa2a3126e9c331a8e00a8c319c9e2b
  git cherry-pick b04aee833c5cfb6b31b8558350feb14bb1a0f353
  git cherry-pick 7fd96ebfc4c9da496c59d7c45e1f62be178e626d
  git cherry-pick f9ed2fe6d61259e779a37d4c2d7edb33a1c1f8ba || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick 44749eb4f273f0eb681d0fa013e3beef754fa687
  git cherry-pick 65756b4082cd79a2d99b2ccb5b392291fd53703f || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick daa85dac2055b22dabbb3b4e537597e6ab73a866
  git remote rm aosp
popd

pushd "$LOCAL_REPO/frameworks/base"
  #git remote add aosp https://android.googlesource.com/platform/frameworks/base && git fetch aosp
  #git cherry-pick 12332e05f632794e18ea8c4ac52c98e82532e5db
  #git remote rm aosp
  git apply $HOME/uber-saber/patches/12332e05f632794e18ea8c4ac52c98e82532e5db.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Disallow guest user from changing Wifi settings"
popd

# have to take this one from https://git.openssl.org/?p=openssl.git;a=commit;h=ab4a81f69ec88d06c9d8de15326b9296d7f498ed
# because 6.0.1 has BoringSSL instead of OpenSSL and there is no OpenSSL fix from Google
pushd "$LOCAL_REPO/external/openssl"
  git apply $HOME/uber-saber/patches/CVE-2016-0705.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Remove broken DSA private key workarounds."
popd

exit 0

pushd "$LOCAL_REPO/external/bluetooth/bluedroid"
  git remote add aosp https://android.googlesource.com/platform/system/bt && git fetch aosp
  git cherry-pick 9b534de2aca5d790c2a1c4d76b545f16137d95dd
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/wpa_supplicant_8"
  git remote add aosp https://android.googlesource.com/platform/external/wpa_supplicant_8 && git fetch aosp
  git cherry-pick b79e09574e50e168dd5f19d540ae0b9a05bd1535
  git cherry-pick b845b81ec6d724bd359cdb77f515722dd4066cf8
  git remote rm aosp
popd
pushd "$LOCAL_REPO/packages/apps/UnifiedEmail"
  git remote add aosp https://android.googlesource.com/platform/packages/apps/UnifiedEmail && git fetch aosp
  git cherry-pick a55168330d9326ff2120285763c818733590266a
  git remote rm aosp
popd
pushd "$LOCAL_REPO/packages/apps/Email"
  git remote add aosp https://android.googlesource.com/platform/packages/apps/Email && git fetch aosp
  git cherry-pick 2791f0b33b610247ef87278862e66c6045f89693
  git remote rm aosp
popd
