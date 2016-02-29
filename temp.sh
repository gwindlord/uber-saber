#!/bin/bash

LOCAL_REPO="$HOME/slimsaber"
BUILD_REPO="$LOCAL_REPO/build/"
DEVICE_REPO="$LOCAL_REPO/device/oppo/msm8974-common/"
SETTINGS_REPO="$LOCAL_REPO/packages/apps/Settings"

exit 0

# JustArchi's optimizations
# require his toolchains in manifest
# but for a week I did not noticed any difference

pushd "$BUILD_REPO"
  git remote add JustArchi https://github.com/ArchiDroid/android_build.git
  git fetch JustArchi
  git cherry-pick f9b983e8e11624b48ae575da206f1baf6979772c || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm JustArchi
popd

pushd external/bluetooth/bluedroid/
  git remote add Archi https://github.com/ArchiDroid/android_external_bluetooth_bluedroid.git
  git fetch Archi
  git cherry-pick 932c01b05465fbf1ae3933efa915902b7f30aec9
  git remote rm Archi
popd

pushd frameworks/av
  git remote add Archi https://github.com/ArchiDroid/android_frameworks_av.git
  git fetch Archi
  git cherry-pick 038d57b7b713edb1016d5dcc977459701949e487
  git remote rm Archi
popd
