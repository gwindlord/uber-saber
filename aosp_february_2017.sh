#!/bin/bash

# patching android-5.1.1_r37 with Google February 2017 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2017-01-01#PLATFORM_SECURITY_PATCH := 2017-02-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2017-02-01"
popd
pushd "$LOCAL_REPO/frameworks/native"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/native
  git fetch aosp
  # Correct overflow check in Parcel resize code
  git cherry-pick b4d6b292bce7d82c93fd454078dedf5a1302b9fa || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/av"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/av
  git fetch aosp
  # Fix security vulnerability: potential OOB write in audioserver
  git cherry-pick b0bcddb44d992e74140a3f5eedc7177977ea8e34
  # Effect: Use local cached data for Effect commit
  git cherry-pick a155de4d70e0b9ac8fc02b2bdcbb2e8e6cca46ff
  git remote rm aosp
popd
pushd "$LOCAL_REPO/hardware/libhardware"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/hardware/libhardware
  git fetch aosp
  # Fix security vulnerability: potential OOB write in audioserver
  git cherry-pick 534098cb29e1e4151ba2ed83d6a911d0b6f48522
  git remote rm aosp
popd
pushd "$LOCAL_REPO/packages/apps/UnifiedEmail"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/packages/apps/UnifiedEmail
  git fetch aosp
  # Don't allow file attachment from /data through GET_CONTENT.
  git cherry-pick 2073799a165e6aa15117f8ad76bb0c7618b13909
  git remote rm aosp
popd
pushd "$LOCAL_REPO/bionic"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/bionic
  git fetch aosp
  # Check for bad packets in getaddrinfo.c's getanswer.
  git cherry-pick dba3df609436d7697305735818f0a840a49f1a0d || git rm libc/dns/net/gethnamaddr.c && git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/packages/apps/Bluetooth"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/packages/apps/Bluetooth
  git fetch aosp
  # Remove MANAGE_DOCUMENTS permission as it isn't needed
  git cherry-pick 4c1f39e1cf203cb9db7b85e75b5fc32ec7132083 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd

pushd "$LOCAL_REPO/kernel/oneplus/msm8974/"
  [ $(git remote | egrep \^CAF) ] && git remote rm CAF
  git remote add CAF https://source.codeaurora.org/quic/la/kernel/msm-3.10
  git fetch CAF
  # qseecom: remove entry from qseecom_registered_app_list
  git cherry-pick 0ed0f061bcd71940ed65de2ba46e37e709e31471
  git remote rm CAF

  [ $(git remote | egrep \^CAF) ] && git remote rm CAF
  git remote add CAF https://source.codeaurora.org/quic/la/kernel/msm-3.18
  git fetch CAF
  # msm: crypto: Fix integer over flow check in qce driver
  git cherry-pick 8f8066581a8e575a7d57d27f36c4db63f91ca48f || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm CAF

  # https://source.codeaurora.org/quic/la//platform/vendor/qcom-opensource/wlan/qcacld-2.0/commit/?id=10f0051f7b3b9a7635b0762a8cf102f595f7a268
  # https://source.codeaurora.org/quic/la//platform/vendor/qcom-opensource/wlan/qcacld-2.0/commit/?id=da87131740351b833f17f05dfa859977bc1e7684
  git apply $HOME/uber-saber/patches/10f0051f7b3b9a7635b0762a8cf102f595f7a268_da87131740351b833f17f05dfa859977bc1e7684.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "qcacld-2.0: Avoid overflow of 'set_bssid_hotlist' and 'significant change' params"

  [ $(git remote | egrep \^linux) ] && git remote rm linux
  git remote add linux https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  git fetch linux
  # dccp: fix freeing skb too early for IPV6_RECVPKTINFO
  git cherry-pick 5edabca9d4cff7f1f2b68f0bac55ef99d9798ba4
  git remote rm linux
popd
pushd "$LOCAL_REPO/frameworks/base"
  git apply $HOME/uber-saber/patches/fb_feb2017_858064e946dc8dbf76bff9387e847e211703e336.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Check provider access for content changes"
popd

exit 0
