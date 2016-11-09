#!/bin/bash

# patching android-5.1.1_r37 with Google October 2016 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2016-09-01#PLATFORM_SECURITY_PATCH := 2016-10-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2016-10-01"
popd
pushd "$LOCAL_REPO/frameworks/native"
  git remote add cm https://github.com/CyanogenMod/android_frameworks_native
  git fetch cm
  git cherry-pick 862a727771af5d6ec3cfa64a83bde8a6d1bef796
  git cherry-pick 4acafe2e181e936e94d94bd611a001a9ab541743
  git remote rm cm
popd
pushd "$LOCAL_REPO/frameworks/av"
  git remote add cm https://github.com/CyanogenMod/android_frameworks_av
  git fetch cm
  git cherry-pick 826b9af553ddee8fee8fa6594dd1ec3a5d1e7d7c
  git cherry-pick 2c8009ee0a3228ca175a34b247ea0d73aa296eb9
  git cherry-pick d0dc38980f91b6c3538917cc2b71b2f7320b70de
  git cherry-pick a503c4bb47068d422243c28590b215f4c94718b2
  git cherry-pick a04c6705f057406cc3edffb386a2687f95196d4e
  git cherry-pick a7f7f5234cc673466dd75444503fee0e77c33b16
  git cherry-pick 675ef580789218d936a49a5482f22900ab3e1d3f
  git cherry-pick bfe0b7309da8f7090fb03f11c06d91d5c04f0c5c
  git remote rm cm
popd
pushd "$LOCAL_REPO/frameworks/base"
  git remote add cm https://github.com/CyanogenMod/android_frameworks_base
  git fetch cm
  git cherry-pick 1a2a4df95806c551be18f90bbf0bfab93d22aac2
  git cherry-pick c72e7b01b3428c582fe87e338db5bf9f55d71358
  git cherry-pick 4f1a0a87b7bc9ab780d4c5d636c294b0cc3e090f || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm cm
popd
pushd "$LOCAL_REPO/system/core"
  git remote add cm https://github.com/CyanogenMod/android_system_core
  git fetch cm
  git cherry-pick 19fe3b4bc33da906a8c523e16bef5803317ddc46
  git remote rm cm
popd
pushd "$LOCAL_REPO/packages/providers/TelephonyProvider"
  git remote add cm https://github.com/CyanogenMod/android_packages_providers_TelephonyProvider
  git fetch cm
  git cherry-pick 36a0ceae88ed6d45692c30302db5d2b963cf690f
  git remote rm cm
popd
