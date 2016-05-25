#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

BUILD_REPO="$LOCAL_REPO/build/"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

# cm: sepolicy: allow kernel to read storage (http://review.cyanogenmod.org/#/c/127767/)
pushd "$LOCAL_REPO/vendor/slim"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_vendor_cm refs/changes/67/127767/2 && git cherry-pick FETCH_HEAD
popd

# CM12 recent features

# Lockscreen: Show redaction interstitial when swipe selected
pushd "$LOCAL_REPO/packages/apps/Settings"
  git remote add CM https://github.com/CyanogenMod/android_packages_apps_Settings.git
  git fetch CM
  git cherry-pick 53047194c7d8a3245b0d2568d287912f406a1a08
  git remote rm CM
popd
# TeleService: Add call barring feature (http://review.cyanogenmod.org/#/c/129008/)
pushd "$LOCAL_REPO/packages/services/Telephony/"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_services_Telephony refs/changes/08/129008/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/hardware/qcom/audio-caf/msm8974"
  # hal: APQ8084 uses AUDIO_PARAMETER_KEY_BT_SCO_WB for bluetooth wideband
  git remote add CM https://github.com/CyanogenMod/android_hardware_qcom_audio.git
  git fetch CM
  git cherry-pick 506b1e167f3e1b5186aa62d3dc4aabaf9024d53c
  git remote rm CM

  # hal: Reduce minimum offload fragment size for PCM offload (http://review.cyanogenmod.org/#/c/135647/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_hardware_qcom_audio refs/changes/47/135647/2 && git cherry-pick FETCH_HEAD
popd
# Ensure non-null encoded uri before attempting to parse (http://review.cyanogenmod.org/#/c/129294/)
pushd "$LOCAL_REPO/packages/apps/ContactsCommon"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_ContactsCommon refs/changes/94/129294/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/device/oppo/msm8974-common/"
  # http://review.cyanogenmod.org/#/c/135685/
  sed -i "s#audio.offload.pcm.16bit.enable=true#audio.offload.pcm.16bit.enable=false#" msm8974.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Disable 16-bit PCM offload for good (http://review.cyanogenmod.org/#/c/135685/)"
popd

# F2FS modification
pushd "$LOCAL_REPO/device/oneplus/bacon"
  sed -i 's#noatime,nosuid,nodev,rw,inline_xattr#noatime,nosuid,nodev,rw,discard,inline_xattr#' rootdir/etc/fstab.bacon
  git add $(git status -s | awk '{print $2}') && git commit -m "Add -discard option to F2FS, as it works good according to feedbacks"
popd

# f2fs: introduce a generic shutdown ioctl (http://review.cyanogenmod.org/#/c/92997)
pushd "$LOCAL_REPO/kernel/oneplus/msm8974"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/97/92997/2 && git cherry-pick FETCH_HEAD
popd

# Forward Port: Add Camera sound toggle [3/3] - was suddenly missing, so camera sound switcher did nothing >_<
pushd "$LOCAL_REPO/frameworks/av"
  git fetch https://review.slimroms.org/SlimRoms/frameworks_av refs/changes/53/1853/1 && git cherry-pick FETCH_HEAD
popd

# init: fix usage of otg-usb storage devices from within applications (http://review.cyanogenmod.org/#/c/134914/)
pushd "$LOCAL_REPO/device/oneplus/bacon"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oneplus_bacon refs/changes/14/134914/1 && git cherry-pick FETCH_HEAD
popd

# The IT Crowd rocks! ;)
pushd "$LOCAL_REPO/packages/apps/Dialer"
  git remote add AOSP https://android.googlesource.com/platform/packages/apps/Dialer
  git fetch AOSP
  git cherry-pick 83131715419e89eebe8e4ea7ada7f96ec37dd8f9 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm AOSP
popd

# Volume steps
# http://gerrit.dirtyunicorns.com/#/c/17297/ and http://gerrit.dirtyunicorns.com/#/c/17296/
pushd "$LOCAL_REPO/frameworks/base"
  git fetch http://gerrit.dirtyunicorns.com/android_frameworks_base refs/changes/97/17297/2 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/packages/apps/Settings"
  git fetch http://gerrit.dirtyunicorns.com/android_packages_apps_Settings refs/changes/96/17296/3 && git cherry-pick FETCH_HEAD || git rm res/values/du_* && git apply $HOME/uber-saber/patches/volume_steps.patch && git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
popd

# Enable RNG hardware support and diagnostics for SnoopSnitch utility support
# https://play.google.com/store/apps/details?id=de.srlabs.snoopsnitch
pushd "$LOCAL_REPO/kernel/oneplus/msm8974"
  #sed -i 's#CONFIG_HW_RANDOM_MSM=y#CONFIG_DIAG_CHAR=y\nCONFIG_HW_RANDOM=y\nCONFIG_HW_RANDOM_MSM=y#' arch/arm/configs/bacon_defconfig
  sed -i 's#CONFIG_HW_RANDOM_MSM=y#CONFIG_DIAG_CHAR=y\nCONFIG_HW_RANDOM_MSM=y#' arch/arm/configs/bacon_defconfig
  git add $(git status -s | awk '{print $2}') && git commit -m "Enable diagnostics for SnoopSnitch utility support"

  # hid: Add driver for FiiO USB DAC
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/10/120110/1 && git cherry-pick FETCH_HEAD
popd

pushd "$LOCAL_REPO/device/oneplus/bacon"
  sed -i "s#SnapdragonCamera#Snap#" bacon.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Replacing SnapdragonCamera with Snap"
popd

pushd "$LOCAL_REPO/frameworks/base"
  git apply $HOME/uber-saber/patches/lower_highspeed.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Adding missing high speed qualities for Snap"

  # RemoteController: extract interface conflicting with CTS test (1/2) (http://review.cyanogenmod.org/#/c/143310/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/10/143310/3 && git cherry-pick FETCH_HEAD
popd

# bacon: Disable VoIP offload (http://review.cyanogenmod.org/#/c/136065/)
pushd "$LOCAL_REPO/device/oneplus/bacon"
  git cherry-pick f730ae48f890f8bb0bc7dfaa9ce24ba25de4108d || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  cp audio/audio_effects.conf $LOCAL_REPO/device/oppo/msm8974-common/audio/
  git rm audio/audio_effects.conf && git commit -m "Fixing LP structure"
popd
pushd "$LOCAL_REPO/device/oppo/msm8974-common"
  sed -i 's/tinymix/libqcomvoiceprocessingdescriptors \\\n    tinymix/' msm8974.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Disable VoIP offload"
popd

pushd "$LOCAL_REPO/device/oneplus/bacon"
  # bacon: Don't end up on ULL for media playback
  git cherry-pick 4025ba987be315303773e661bf021ef7ac6f08d7 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick ecf8af391a1711b04b4e04687fb5724afbd876d9

  sed -i 's#persist.audio.fluence.voicecall=true#drm.service.enabled=true\npersist.audio.fluence.voicecall=true#' system.prop
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Enable DRM service for Media Scanner"
  sed -i 's#TARGET_USERIMAGES_USE_F2FS := true#TARGET_USERIMAGES_USE_F2FS := true\n\# GPS\nBOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := true\nUSE_DEVICE_SPECIFIC_GPS := true\nUSE_DEVICE_SPECIFIC_LOC_API := true#' BoardConfig.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: set BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET and USE_DEVICE_SPECIFIC_GPS"

  # bacon: Add missing ULL usecases (http://review.cyanogenmod.org/#/c/142139/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oneplus_bacon refs/changes/39/142139/2 && git cherry-pick FETCH_HEAD
  # bacon: Add RAW path on primary output (http://review.cyanogenmod.org/#/c/142138/)
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oneplus_bacon refs/changes/38/142138/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
popd

# bacon: Update thermal configuration for new 8-zone driver
pushd "$LOCAL_REPO/device/oppo/msm8974-common"
  git apply $HOME/uber-saber/patches/android_device_oneplus_bacon_097b09ac1cd1638f762bc6a2ab6b1804a862806c.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Update thermal configuration for new 8-zone driver"
popd

# Settings: restore proper live display color profile
pushd "$LOCAL_REPO/packages/apps/Settings"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Settings refs/changes/49/142049/2 && git cherry-pick FETCH_HEAD
popd

# IncallUI: Screen doesn't wakeup after MT/MO call disconnect (http://review.cyanogenmod.org/#/c/143388/)
pushd "$LOCAL_REPO/packages/apps/InCallUI"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_InCallUI refs/changes/88/143388/1 && git cherry-pick FETCH_HEAD
popd

exit 0

# repo is now on branch cm-12.1, therefore "repo sync" does not drop the changes
pushd "$LOCAL_REPO/hardware/qcom/media-caf/msm8974"
  git cherry-pick 6c65aa27f1e7f2c633e8996b04e8d3e123f2b50e
  git cherry-pick 0f6c707bff89ccd3db4cb3b8b044761b7e674e93 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick 1afc24230b1fecd9b2ec9780b72c6af5b3154646 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick dc64230278eb5685342b8082036772b6415cc5cb
popd

exit 0

#################

# Force OpenWeatherMap to be the weather provider - Yahoo changed API again >_<
pushd "$LOCAL_REPO/packages/apps/LockClock"
  git reset --hard && git clean -f -d
  wget -q https://github.com/sultanxda/android_packages_apps_LockClock/commit/201e3f432b9266dc7cb3d35a909e7710f9017ceb.patch
  patch -p1 -s < 201e3f432b9266dc7cb3d35a909e7710f9017ceb.patch
  git clean -f -d
  git add $(git status -s | awk '{print $2}') && git commit -m "Force OpenWeatherMap to be the weather provider"
popd

# Fix for Sultan's RIL at LP - compiled sap-api.proto has "#include <string>" line, and compiler has no idea where to get this header :(
pushd "$LOCAL_REPO/hardware/ril-caf"
  git apply $HOME/uber-saber/patches/ril5.patch && git add $(git status -s | awk '{print $2}') && git commit -m "Adapt RIL"
  git revert ed24474ebf87f38112129146e901590b8f8c757e || git rm libril/?ilS* && git revert --continue
  git revert --no-edit 902098d12d7f14f42dac9b573a6be76160189591
popd

# LZ4
pushd "$LOCAL_REPO/kernel/oneplus/msm8974"
  git remote add jgcaap https://github.com/jgcaaprom/android_kernel_oneplus_msm8974.git
  git fetch jgcaap
  git cherry-pick 6769cae315d98f6bd18ff28f5eca0169b07b2bfe
  git remote rm jgcaap

  git remote add faux123 https://github.com/faux123/mako.git
  git fetch faux123
  git cherry-pick b421b4ceec4fc450e5c9ad9b3c1bf9fda5144a3e
  git remote rm faux123
popd
pushd "$LOCAL_REPO/device/oneplus/bacon"
  sed -i "s#AUDIO_FEATURE_LOW_LATENCY_PRIMARY := true#AUDIO_FEATURE_LOW_LATENCY_PRIMARY := true\n\nTARGET_TRANSPARENT_COMPRESSION_METHOD := lz4#" BoardConfig.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Boardconfig : lz4"
popd

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
