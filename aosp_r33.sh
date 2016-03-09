#!/bin/bash

# patching android-5.1.1_r30 to android-5.1.1_r33
# taking changes from log http://www.androidpolice.com/android_aosp_changelogs/android-5.1.1_r30-to-android-5.1.1_r33-AOSP-changelog.html

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
  git cherry-pick 22c60bf23556598adff34fc585372d21f186e249
  git cherry-pick 1cab8b5b3121f5cdc977d251e088567a71b6e165
  git cherry-pick 8094d8cf99a36538bb810e4a7da8692e1445d4e2
#  git cherry-pick 5c8bd5229ef1d55cd442df7de39b5a1f262bf6e9 # too early guys, too early
  git cherry-pick d9a7c8eb8e48d2d7185d8a831a5550dd347fc126
  git cherry-pick 98e29ea4cf1f5e954187323cbc40654f5112829e
  git remote rm aosp_build
popd

pushd "$LOCAL_REPO/frameworks/av"
  git remote add aosp_frameworks_av https://android.googlesource.com/platform/frameworks/av
  git fetch aosp_frameworks_av
  git cherry-pick 6616d19bac870bcec85f499f8f5c580468a31f93
  git cherry-pick 0077bdf424dd53567244e9630b2c6be5f503730f
  git cherry-pick 3292bef42a7f396f637dd6395c7f57973115aff7
  git cherry-pick 3e49ad28cf6d5fa947389cde8ab93d20772f2360
  git remote rm aosp_frameworks_av
popd

pushd "$LOCAL_REPO/frameworks/base"
  git remote add aosp_frameworks_base https://android.googlesource.com/platform/frameworks/base
  git fetch aosp_frameworks_base
  git cherry-pick df407ff7157c39fa149330f6784fe7d67f66b12d
  git cherry-pick 60fb6c37e9a7e6c48029839985212143bee5c5fe
  git cherry-pick 3749eefd89679caafa3a8bf5058aea76535ef454
  git cherry-pick a1734f02c965a989092bbadce43920d0e729d0d4
  git cherry-pick ef53d61260e3b2e4925dd3aaa3d7ab6cfb1fc856
  git remote rm aosp_frameworks_base
popd

pushd "$LOCAL_REPO/packages/apps/Settings"
  git remote add aosp_packages_apps_Settings https://android.googlesource.com/platform/packages/apps/Settings
  git fetch aosp_packages_apps_Settings
  git cherry-pick 665ac7bc29396fd5af2ecfdfda2b9de7a507daa0
  git cherry-pick a7ff2e955d2509ed28deeef984347e093794f92b
  git remote rm aosp_packages_apps_Settings
popd

pushd "$LOCAL_REPO/system/core"
  git remote add aosp_system_core https://android.googlesource.com/platform/system/core
  git fetch aosp_system_core
  git cherry-pick 75ac84c0bf57d646dfae468916fcdcc071570293
  git remote rm aosp_system_core
popd
