#!/bin/bash

# patching android-5.1.1_r34 to android-5.1.1_r35
# taking changes from log http://www.androidpolice.com/android_aosp_changelogs/android-5.1.1_r34-to-android-5.1.1_r35-AOSP-changelog.html

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  git remote add aosp_build https://android.googlesource.com/platform/build
  git fetch aosp_build
  git cherry-pick fa1323c3b38495606fba31518e552faec530b199
  git cherry-pick fafe789699316238ce8755f92ae0a1a9aa79c6ac
  git remote rm aosp_build
popd

pushd "$LOCAL_REPO/frameworks/av"
  git remote add aosp https://android.googlesource.com/platform/frameworks/av
  git fetch aosp
  git cherry-pick 6ad0c98cb9ae119156b264a7532b1e0cc701e0d8
  git cherry-pick 5a6788730acfc6fd8f4a6ef89d2c376572a26b55
  git cherry-pick fe84c20143f95ad1d4e0203a6a11abb772efdef0
  git cherry-pick b862285d2ac905c2a4845335d6a68a55135f6260
  git remote rm aosp
popd

pushd "$LOCAL_REPO/frameworks/native"
  git remote add aosp https://android.googlesource.com/platform/frameworks/native
  git fetch aosp
  git cherry-pick b8a86fe81c0da124d04630b9b3327482fef6220a
  git cherry-pick d9b370cf4d8cbc5972023bd9dde2174d9d965191
  git remote rm aosp
popd

pushd "$LOCAL_REPO/frameworks/opt/telephony"
  git remote add aosp https://android.googlesource.com/platform/frameworks/opt/telephony
  git fetch aosp
  git cherry-pick 572af2dd8148fd6b24b1c8a0bf2ff769015ba2db
  git remote rm aosp
popd
