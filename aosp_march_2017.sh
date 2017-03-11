#!/bin/bash

# patching android-5.1.1_r37 with Google March 2017 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2017-02-01#PLATFORM_SECURITY_PATCH := 2017-03-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2017-03-01"
popd
pushd "$LOCAL_REPO/kernel/oneplus/msm8974"
  [ $(git remote | egrep \^CAF) ] && git remote rm CAF
  git remote add CAF https://source.codeaurora.org/quic/la/kernel/msm-3.18 && git fetch CAF
  # msm: crypto: fix issues on digest buf and copy_from_user in qcedev.c
  git cherry-pick eb2aad752c43f57e88ab9b0c3c5ee7b976ee31dd
  git remote rm CAF

  [ $(git remote | egrep \^CAF) ] && git remote rm CAF
  git remote add CAF https://source.codeaurora.org/quic/la/kernel/msm-3.10 && git fetch CAF
  # msm: camera: fix bound check of offset to avoid overread overwrite
  git cherry-pick 01dcc0a7cc23f23a89adf72393d5a27c6d576cd0
  # msm: cpp: Fix for buffer overflow in cpp.
  git cherry-pick bc77232707df371ff6bab9350ae39676535c0e9d || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # msm: camera: sensor: Validate eeprom_name string length
  git cherry-pick 33c9042e38506b04461fa99e304482bc20923508
  git remote rm CAF

  # https://source.codeaurora.org/quic/la/kernel/msm-3.18/commit/?id=530f3a0fd837ed105eddaf99810bc13d97dc4302
  git apply $HOME/uber-saber/patches/530f3a0fd837ed105eddaf99810bc13d97dc4302.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "ASoC: msm-lsm-client: cleanup ioctl functions"

  # https://source.codeaurora.org/quic/la/platform/vendor/qcom-opensource/wlan/qcacld-2.0/commit/?id=05af1f34723939f477cb7d25adb320d016d68513
  git apply $HOME/uber-saber/patches/05af1f34723939f477cb7d25adb320d016d68513.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "qcacld-2.0: Add buf len check in wlan_hdd_cfg80211_testmode"

  # https://source.codeaurora.org/quic/la/kernel/msm-3.18/commit/?id=dbe4f26f200db10deaf38676b96d8738afcc10c8
  git apply $HOME/uber-saber/patches/dbe4f26f200db10deaf38676b96d8738afcc10c8.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "msm: cpp: Fix for integer overflow in cpp"
popd
pushd "$LOCAL_REPO/frameworks/base"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/base
  git fetch aosp
  # Prevent writing to FRP partition during factory reset.
  git cherry-pick 1c4d535d0806dbeb6d2fa5cea0373cbd9ab6d33b
  # Add @GuardedBy annotation to PersistentDataBlockService#mIsWritable.
  git cherry-pick 5f621b5b1549e8379aee05807652d5111382ccc6
  # Fix exploit where can hide the fact that a location was mocked
  git cherry-pick d22261fef84481651e12995062105239d551cbc6
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/av"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/av
  git fetch aosp
  # improve audio effect framwework thread safety
  git cherry-pick 22e26d8ee73488c58ba3e7928e5da155151abfd0 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # audioflinger: fix recursive mutex lock in EffectHandle.
  git cherry-pick 8415635765380be496da9b4578d8f134a527d86b
  # Don't initialize sync sample parameters until the end to avoid leaving them in a partially initialized state.
  git cherry-pick bc62c086e9ba7530723dc8874b83159f4d77d976
  # avc_utils: skip empty NALs from malformed bistreams
  git cherry-pick 5cabe32a59f9be1e913b6a07a23d4cfa55e3fb2f
  git remote rm aosp
popd
pushd "$LOCAL_REPO/packages/apps/PackageInstaller"
  # https://android.googlesource.com/platform/packages/apps/PackageInstaller/+/5c49b6bf732c88481466dea341917b8604ce53fa
  git apply $HOME/uber-saber/patches/5c49b6bf732c88481466dea341917b8604ce53fa.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Prioritize package installer intent filter"
popd
pushd "$LOCAL_REPO/external/libnfc-nci"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/external/libnfc-nci
  git fetch aosp
  # Fix native crash in nfc_ncif_proc_activate
  git cherry-pick c67cc6ad2addddcb7185a33b08d27290ce54e350
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/ex"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/ex
  git fetch aosp
  # resolve merge conflicts of 89cdd4cb to mnc-dev
  git cherry-pick 7c824f17b3eea976ca58be7ea097cb807126f73b
  git remote rm aosp
popd
pushd "$LOCAL_REPO/bootable/recovery"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/bootable/recovery
  git fetch aosp
  # Add a checker for signature boundary in verifier
  git cherry-pick 2c6c23f651abb3d215134dfba463eb72a5e9f8eb
  git remote rm aosp
popd
pushd "$LOCAL_REPO/external/openssl"
  # https://git.openssl.org/?p=openssl.git;a=commit;h=07bed46f332fce8c1d157689a2cdf915a982ae34
  git apply $HOME/uber-saber/patches/CVE-2016-2182.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Check for errors in BN_bn2dec()"
popd
