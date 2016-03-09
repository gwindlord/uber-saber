#!/bin/bash

# patching android-5.1.1_r33 to android-5.1.1_r34
# taking changes from log http://www.androidpolice.com/android_aosp_changelogs/android-5.1.1_r33-to-android-5.1.1_r34-AOSP-changelog.html

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
  git cherry-pick 5c8bd5229ef1d55cd442df7de39b5a1f262bf6e9
  git remote rm aosp_build
  sed -i "s#export BUILD_ID=LMY49F#export BUILD_ID=LMY49G#" core/build_id.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating version to android-5.1.1_r34"
popd
