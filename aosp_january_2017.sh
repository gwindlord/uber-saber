#!/bin/bash

# patching android-5.1.1_r37 with Google January 2017 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2016-12-01#PLATFORM_SECURITY_PATCH := 2017-01-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2017-01-01"
popd
pushd "$LOCAL_REPO/external/libopus"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/external/libopus
  git fetch aosp
  # Ensure that NLSF cannot be negative when computing a min distance between them
  git cherry-pick 0d052d64480a30e83fcdda80f4774624e044beb7
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/libnl"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/external/libnl
  git fetch aosp
  # libnl: Check data length in nla_reserve / nla_put
  git cherry-pick f0b40192efd1af977564ed6335d42a8bbdaf650a
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/tremolo"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/external/tremolo
  git fetch aosp
  # Tremolo: fix ARM assembly code for decode_map type 3 case
  git cherry-pick 5dc99237d49e73c27d3eca54f6ccd97d13f94de0
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/libvpx"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/external/libvpx
  git fetch aosp
  # vp8:fix threading issues
  git cherry-pick 6886e8e0a9db2dbad723dc37a548233e004b33bc
  git remote rm aosp
popd
pushd "$LOCAL_REPO/packages/services/Telephony"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/packages/services/Telephony
  git fetch aosp
  # Catch SIP exceptions which can crash Phone process on answer
  git cherry-pick 1cdced590675ce526c91c6f8983ceabb8038f58d || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/hardware/qcom/audio-caf/msm8974"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/hardware/qcom/audio
  git fetch aosp
  # Fix security vulnerability: Equalizer command might allow negative indexes
  git cherry-pick d72ea85c78a1a68bf99fd5804ad9784b4102fe57
  # Fix security vulnerability: Effect command might allow negative indexes
  git cherry-pick ed79f2cc961d7d35fdbbafdd235c1436bcd74358 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/ex"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/ex
  git fetch aosp
  # resolve merge conflicts of 3802db4 to mnc-dev
  git cherry-pick 7f0e3dab5a892228d8dead7f0221cc9ae82474f7 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/native"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/native
  git fetch aosp
  # Fix SF security vulnerability: 32660278
  git cherry-pick 675e212c8c6653825cc3352c603caf2e40b00f9f
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/av"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/av
  git fetch aosp
  # Visualizer: Check capture size and latency parameters
  git cherry-pick 557bd7bfe6c4895faee09e46fc9b5304a956c8b7
  # Fix security vulnerability: Equalizer command might allow negative indexes
  git cherry-pick c66c43ad571ed2590dcd55a762c73c90d9744bac
  # Effects: Check get parameter command size
  git cherry-pick 26965db50a617f69bdefca0d7533796c80374f2c
  # defensive parsing of mp3 album art information
  git cherry-pick 7a3246b870ddd11861eda2ab458b11d723c7f62c
  # Make VBRISeeker more robust
  git cherry-pick 453b351ac5bd2b6619925dc966da60adf6b3126c
  # Fix security vulnerability: Effect command might allow negative indexes
  git cherry-pick 321ea5257e37c8edb26e66fe4ee78cca4cd915fe
  git remote rm aosp
popd

exit 0

pushd "$LOCAL_REPO/kernel/oneplus/msm8974/"
  [ $(git remote | egrep \^linux) ] && git remote rm linux
  git remote add linux https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  git fetch linux
  # isofs: Fix infinite looping over CE entries
  git cherry-pick f54e18f1b831c92f6512d2eedb224cd63d607d3d
  git remote rm linux

  [ $(git remote | egrep \^linux) ] && git remote rm linux
  git remote add linux https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
  git fetch linux
  # ring-buffer: Prevent overflow of size in ring_buffer_resize()
  git cherry-pick 59643d1535eb220668692a5359de22545af579f6 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm linux

  # https://source.codeaurora.org/quic/la/kernel/lk/commit/?id=cf8f5a105bafda906ccb7f149d1a5b8564ce20c0
  git apply $HOME/uber-saber/patches/cf8f5a105bafda906ccb7f149d1a5b8564ce20c0.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "lib: fdt: add integer overflow checks"

  # https://source.codeaurora.org/quic/la//platform/vendor/qcom-opensource/wlan/qcacld-2.0/commit/?id=6ba9136879232442a182996427e5c88e5a7512a8
  git apply $HOME/uber-saber/patches/6ba9136879232442a182996427e5c88e5a7512a8.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "qcacld-2.0: Resolve buffer overflow issue while processing GET_CFG IOCTL"

popd