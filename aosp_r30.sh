#!/bin/bash

# patching android-5.1.1_r26 to android-5.1.1_r30
# taking changes from log http://www.androidpolice.com/android_aosp_changelogs/android-5.1.1_r26-to-android-5.1.1_r30-AOSP-changelog.html

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  [ $(git remote | egrep \^aosp_build) ] && git remote rm aosp_build
  git remote add aosp_build https://android.googlesource.com/platform/build
  git fetch aosp_build
  git cherry-pick d0da231ed5e347ef78cd7cbcdef9185a1aa89016
  git cherry-pick 990b025c2e346a225b0423b5506692123a46e37a
  git remote rm aosp_build
popd

pushd "$LOCAL_REPO/external/skia"
  [ $(git remote | egrep \^aosp_skia) ] && git remote rm aosp_skia
  git remote add aosp_skia https://android.googlesource.com/platform/external/skia
  git fetch aosp_skia
  git cherry-pick 3a0fdc1e084a7815b9d16c7c81cd068007b5afa1 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp_skia
popd

pushd "$LOCAL_REPO/frameworks/av"
  [ $(git remote | egrep \^aosp_frameworks_av) ] && git remote rm aosp_frameworks_av
  git remote add aosp_frameworks_av https://android.googlesource.com/platform/frameworks/av
  git fetch aosp_frameworks_av
  git cherry-pick f0b53a1c06ca19656373ab48b76b71946c096a5a
  git cherry-pick cf6067b5f192f8ede803e9671a9afa4527dbd35c
  git cherry-pick 2642744c8230abdef68e37247f04ec192e702c61
  git cherry-pick 9f474114e1a2db8e41ae8d7acac9b539b733a8c2
  git cherry-pick cf12b35a761b487d71fe55105204aa7afeb54bd1
  git cherry-pick 9c20e9ecd4bba48eca51bd898aca929fa023ffa0
  git cherry-pick 44cc604408c3234125ea764b11300fe64b375c3f
  git cherry-pick 53156f318dcdc2f0e28c3ae555a7592e99eec5ea
  git cherry-pick 6ca328597cfd812ddb2e04b2f621ac67b6b95118
  git cherry-pick f35e4b55e303edb3fc2366b427b007939e1238a6
  git cherry-pick 7f62e8bfc2d2c3c5c151b2487702f72699ac8736
  git remote rm aosp_frameworks_av
popd

pushd "$LOCAL_REPO/frameworks/base"
  [ $(git remote | egrep \^aosp_frameworks_base) ] && git remote rm aosp_frameworks_base
  git remote add aosp_frameworks_base https://android.googlesource.com/platform/frameworks/base
  git fetch aosp_frameworks_base
  git cherry-pick ae98d39253ba54ddf6091ec8c3120076a6807899 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick 4ce29f8179a5322e27fb8f4316059a497159f444
  git remote rm aosp_frameworks_base
popd

pushd "$LOCAL_REPO/frameworks/native"
  [ $(git remote | egrep \^aosp_frameworks_native) ] && git remote rm aosp_frameworks_native
  git remote add aosp_frameworks_native https://android.googlesource.com/platform/frameworks/native
  git fetch aosp_frameworks_native
  git cherry-pick 8ac7474234d62958e88d60bc0e942711ad9272ed
  git remote rm aosp_frameworks_native
popd

pushd "$LOCAL_REPO/frameworks/opt/net/wifi"
  [ $(git remote | egrep \^aosp_frameworks_opt_net_wifi) ] && git remote rm aosp_frameworks_opt_net_wifi
  git remote add aosp_frameworks_opt_net_wifi https://android.googlesource.com/platform/frameworks/opt/net/wifi
  git fetch aosp_frameworks_opt_net_wifi
  git cherry-pick c6249cce8c5025daf6f2a20fe36b7e517d5943ba
  git remote rm aosp_frameworks_opt_net_wifi
popd
