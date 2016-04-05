#!/bin/bash

# patching android-5.1.1_r36 to android-5.1.1_r37
# source: uber-saber/aosp_rev_diff.sh

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  git remote add aosp https://android.googlesource.com/platform/build
  git fetch aosp
  git cherry-pick b2ac0ea
  git cherry-pick 604febc
  git remote rm aosp
popd

pushd "$LOCAL_REPO/external/dhcpcd"
  git remote add aosp https://android.googlesource.com/platform/external/dhcpcd
  git fetch aosp
  git cherry-pick 1390ace
  git remote rm aosp
popd

pushd "$LOCAL_REPO/external/skia"
  git remote add aosp https://android.googlesource.com/platform/external/skia
  git fetch aosp
  git cherry-pick b36c23b
  git remote rm aosp
popd

pushd "$LOCAL_REPO/frameworks/av"
  git remote add aosp https://android.googlesource.com/platform/frameworks/av
  git fetch aosp
  git cherry-pick 25be9ac
  git cherry-pick 1171e7c
  git cherry-pick 7a282fb
  git cherry-pick 3097f36
  git remote rm aosp
popd

pushd "$LOCAL_REPO/frameworks/base"
  git remote add aosp https://android.googlesource.com/platform/frameworks/base
  git fetch aosp
  git cherry-pick 63363af
  git cherry-pick d3383d5
  git remote rm aosp
popd

pushd "$LOCAL_REPO/frameworks/native"
  git remote add aosp https://android.googlesource.com/platform/frameworks/native
  git fetch aosp
  git cherry-pick 85d253f
  git cherry-pick f3199c2
  git cherry-pick a40b30f
  git remote rm aosp
popd

pushd "$LOCAL_REPO/libcore"
  git remote add aosp https://android.googlesource.com/platform/libcore
  git fetch aosp
  git cherry-pick efd369d
  git remote rm aosp
popd

pushd "$LOCAL_REPO/packages/providers/DownloadProvider"
  git remote add aosp https://android.googlesource.com/platform/packages/providers/DownloadProvider
  git fetch aosp
  git cherry-pick 5110b8a
  git remote rm aosp
popd

pushd "$LOCAL_REPO/packages/services/Telecomm"
  git remote add aosp https://android.googlesource.com/platform/packages/services/Telecomm
  git fetch aosp
  git cherry-pick a06c9a4
  git cherry-pick 4f52419
  git remote rm aosp
popd

pushd "$LOCAL_REPO/system/core"
  git remote add aosp https://android.googlesource.com/platform/system/core
  git fetch aosp
  set +e
  git cherry-pick 81df1cc || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  set -e
  git remote rm aosp
popd
