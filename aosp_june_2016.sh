#!/bin/bash

# patching android-5.1.1_r37 with Google June 2016 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2016-05-01#PLATFORM_SECURITY_PATCH := 2016-06-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2016-06-01"
popd

pushd "$LOCAL_REPO/system/core"
  git remote add aosp https://android.googlesource.com/platform/system/core
  git fetch aosp
  git cherry-pick 864e2e22fcd0cba3f5e67680ccabd0302dfda45d
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/base"
  git remote add aosp https://android.googlesource.com/platform/frameworks/base
  git fetch aosp
  git cherry-pick 9878bb99b77c3681f0fda116e2964bac26f349c3 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/libvpx"
  #git remote add aosp https://android.googlesource.com/platform/external/libvpx
  #git fetch aosp
  git cherry-pick cc274e2abe8b2a6698a5c47d8aa4bb45f1f9538d
  sed -i 's#std::isinf#isinf#' libwebm/mkvparser.cpp
  sed -i 's#std::isnan#isnan#' libwebm/mkvparser.cpp
  git add libwebm/mkvparser.cpp && git commit -m "Fixing cc274e2abe8b2a6698a5c47d8aa4bb45f1f9538d"
  git cherry-pick 65c49d5b382de4085ee5668732bcb0f6ecaf7148
  #git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/av"
  git remote add aosp https://android.googlesource.com/platform/frameworks/av/
  git fetch aosp
  git cherry-pick 2b6f22dc64d456471a1dc6df09d515771d1427c8
  git cherry-pick 295c883fe3105b19bcd0f9e07d54c6b589fc5bff || git rm media/libstagefright/codecs/avcenc/SoftAVCEnc.cpp && git cherry-pick --continue
  git cherry-pick 94d9e646454f6246bf823b6897bd6aea5f08eda3
  #git cherry-pick 0bb5ced60304da7f61478ffd359e7ba65d72f181 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git apply $HOME/uber-saber/patches/June_2016_fix1.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "frameworks_av: fixing 295c883fe3105b19bcd0f9e07d54c6b589fc5bff"
  #git cherry-pick db829699d3293f254a7387894303451a91278986
  git cherry-pick 7cea5cb64b83d690fe02bc210bbdf08f5a87636f
  sed -i 's#kMSGSMFrameSize#65#' media/libstagefright/codecs/gsm/dec/SoftGSM.cpp
  git add $(git status -s | awk '{print $2}') && git commit -m "Adding missing constant"
  git cherry-pick 4e32001e4196f39ddd0b86686ae0231c8f5ed944 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick ad40e57890f81a3cf436c5f06da66396010bd9e5
  git cherry-pick d2f47191538837e796e2b10c1ff7e1ee35f6e0ab
  git cherry-pick 918eeaa29d99d257282fafec931b4bda0e3bae12 || git add media/libstagefright/codecs/hevcdec/SoftHEVC.cpp && git rm media/libstagefright/codecs/avcdec/SoftAVCDec.cpp media/libstagefright/codecs/avcdec/SoftAVCDec.h media/libstagefright/codecs/mpeg2dec/SoftMPEG2.cpp media/libstagefright/codecs/mpeg2dec/SoftMPEG2.h && git cherry-pick --continue
  sed -i 's#mSignalledError = true;##' media/libstagefright/codecs/hevcdec/SoftHEVC.cpp
  git add $(git status -s | awk '{print $2}') && git commit -m "Fixing undeclared var"
  git cherry-pick 45737cb776625f17384540523674761e6313e6d4 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick b57b3967b1a42dd505dbe4fcf1e1d810e3ae3777
  git cherry-pick dd3546765710ce8dd49eb23901d90345dec8282f || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd

exit 0

# hardware/qcom/media-caf/msm8974 is on branch, which means that repo sync does not drop the local changes
pushd "$LOCAL_REPO/hardware/qcom/media-caf/msm8974"
  git remote add aosp https://android.googlesource.com/platform/hardware/qcom/media && git fetch aosp
  git cherry-pick 89913d7df36dbeb458ce165856bd6505a2ec647d || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
