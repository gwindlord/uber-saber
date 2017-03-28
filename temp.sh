#!/bin/bash

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

SCRIPT_DIR="$(dirname $(readlink -f $0))"

pushd "$LOCAL_REPO/system/core"
  # liblog: build log_event_write regardless of TARGET_USES_LOGD (https://review.lineageos.org/#/c/143029/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/95/136095/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_system_core refs/changes/29/143029/1 && git cherry-pick FETCH_HEAD
popd

pushd "$LOCAL_REPO/build/"
  # Avoid accidentally using the host's native 'as' command. (https://review.lineageos.org/#/c/2832/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_build refs/changes/84/146384/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_build refs/changes/32/2832/1 && git cherry-pick FETCH_HEAD
  # kernel: don't build modules or dtbs unless enabled (https://review.lineageos.org/#/c/2952/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_build refs/changes/92/120592/5 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_build refs/changes/52/2952/5 && git cherry-pick FETCH_HEAD
popd

# cm: sepolicy: allow kernel to read storage (http://review.cyanogenmod.org/#/c/127767/) (https://review.lineageos.org/#/c/145175/)
pushd "$LOCAL_REPO/vendor/slim"
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_vendor_cm refs/changes/67/127767/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_vendor_cm refs/changes/75/145175/2 && git cherry-pick FETCH_HEAD
popd

# CM12 recent features

# Lockscreen: Show redaction interstitial when swipe selected
pushd "$LOCAL_REPO/packages/apps/Settings"
  [ $(git remote | egrep \^CM) ] && git remote rm CM
  git remote add CM https://github.com/CyanogenMod/android_packages_apps_Settings.git
  git fetch CM
  git cherry-pick 53047194c7d8a3245b0d2568d287912f406a1a08
  git remote rm CM
popd

pushd "$LOCAL_REPO/packages/services/Telephony/"
  # TeleService: Add call barring feature (http://review.cyanogenmod.org/#/c/129008/) (https://review.lineageos.org/#/c/140914/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_services_Telephony refs/changes/08/129008/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_services_Telephony refs/changes/14/140914/2 && git cherry-pick FETCH_HEAD
  # Emergency dialing screen flickering (https://review.cyanogenmod.org/#/c/146706/) (https://review.lineageos.org/#/c/140873/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_packages_services_Telephony refs/changes/06/146706/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_services_Telephony refs/changes/72/140772/1 && git cherry-pick FETCH_HEAD
  # Single digit MMI codes invalid. (https://review.lineageos.org/#/c/140873/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_packages_services_Telephony refs/changes/00/132100/3 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_services_Telephony refs/changes/73/140873/6 && git cherry-pick FETCH_HEAD
popd

:<<comment
  pushd "$LOCAL_REPO/hardware/qcom/audio-caf/msm8974"
    # hal: APQ8084 uses AUDIO_PARAMETER_KEY_BT_SCO_WB for bluetooth wideband
    git remote add CM https://github.com/CyanogenMod/android_hardware_qcom_audio.git
    git fetch CM
    git cherry-pick 506b1e167f3e1b5186aa62d3dc4aabaf9024d53c
    git remote rm CM

    # hal: Reduce minimum offload fragment size for PCM offload (http://review.cyanogenmod.org/#/c/135647/)
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_hardware_qcom_audio refs/changes/47/135647/2 && git cherry-pick FETCH_HEAD
  popd
comment

# Fix potential NULL dereference in Visualizer effect
pushd "$LOCAL_REPO/hardware/qcom/audio-caf/msm8974"
  [ $(git remote | egrep \^sultan) ] && git remote rm sultan
  git remote add sultan https://github.com/sultanxda/android_hardware_qcom_audio
  git fetch sultan
  git cherry-pick df4398c0761784c4cf9dbda544c89ebb3bf82ac9
  git remote rm sultan
popd

pushd "$LOCAL_REPO/packages/apps/ContactsCommon"
  # Ensure non-null encoded uri before attempting to parse (http://review.cyanogenmod.org/#/c/129294/) (https://review.lineageos.org/#/c/119173/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_ContactsCommon refs/changes/94/129294/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_apps_ContactsCommon refs/changes/73/119173/1 && git cherry-pick FETCH_HEAD
  # Enable support for groups in External contacts accounts (https://review.lineageos.org/#/c/119096/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_packages_apps_ContactsCommon refs/changes/49/131149/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_apps_ContactsCommon refs/changes/96/119096/2 && git cherry-pick FETCH_HEAD
popd

pushd "$LOCAL_REPO/packages/apps/Contacts"
  # Exporting contacts Max limit (https://review.lineageos.org/#/c/118223/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Contacts refs/changes/33/135633/3 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_apps_Contacts refs/changes/23/118223/1 && git cherry-pick FETCH_HEAD
popd

# F2FS modification
pushd "$LOCAL_REPO/device/oneplus/bacon"
  sed -i 's#noatime,nosuid,nodev,rw,inline_xattr#noatime,nosuid,nodev,rw,discard,inline_xattr#' rootdir/etc/fstab.bacon
  git add $(git status -s | awk '{print $2}') && git commit -m "Add -discard option to F2FS, as it works good according to feedbacks"
popd

# f2fs: introduce a generic shutdown ioctl (http://review.cyanogenmod.org/#/c/92997) (https://review.lineageos.org/#/c/93944/)
pushd "$LOCAL_REPO/kernel/oneplus/msm8974"
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/97/92997/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_kernel_oneplus_msm8974 refs/changes/44/93944/2 && git cherry-pick FETCH_HEAD
popd

# init: fix usage of otg-usb storage devices from within applications (http://review.cyanogenmod.org/#/c/134914/) (https://review.lineageos.org/#/c/29194/)
pushd "$LOCAL_REPO/device/oneplus/bacon"
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oneplus_bacon refs/changes/14/134914/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_device_oneplus_bacon refs/changes/94/29194/1 && git cherry-pick FETCH_HEAD
popd

pushd "$LOCAL_REPO/packages/apps/Dialer"
  # The IT Crowd rocks! ;)
  [ $(git remote | egrep \^AOSP) ] && git remote rm AOSP
  git remote add AOSP https://android.googlesource.com/platform/packages/apps/Dialer
  git fetch AOSP
  git cherry-pick 83131715419e89eebe8e4ea7ada7f96ec37dd8f9 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm AOSP

  # Delete failed CallRecording file (https://review.lineageos.org/#/c/120524/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Dialer refs/changes/79/125279/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_apps_Dialer refs/changes/24/120524/2 && git cherry-pick FETCH_HEAD
popd

# Volume steps
pushd "$LOCAL_REPO/frameworks/base"
  [ $(git remote | egrep \^DU) ] && git remote rm DU
  git remote add DU https://github.com/DirtyUnicorns/android_frameworks_base
  git fetch DU
  git cherry-pick cf997aa7c934f5e0d0d940aca1740f91ab3cb153
  git remote rm DU
popd
pushd "$LOCAL_REPO/packages/apps/Settings"
  [ $(git remote | egrep \^DU) ] && git remote rm DU
  git remote add DU https://github.com/DirtyUnicorns/android_packages_apps_Settings
  git fetch DU
  git cherry-pick 6de5019711057dbac93cd0d59416e02fb79ec7ba || git rm res/values/du_* && git apply $HOME/uber-saber/patches/volume_steps.patch && git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm DU
popd

pushd "$LOCAL_REPO/kernel/oneplus/msm8974"
  # Enable RNG hardware support and diagnostics for SnoopSnitch utility support
  # https://play.google.com/store/apps/details?id=de.srlabs.snoopsnitch
  sed -i 's#CONFIG_HW_RANDOM_MSM=y#CONFIG_DIAG_CHAR=y\nCONFIG_HW_RANDOM_MSM=y#' arch/arm/configs/bacon_defconfig
  git add $(git status -s | awk '{print $2}') && git commit -m "Enable diagnostics for SnoopSnitch utility support"

  # mm, oom: base root bonus on current usage (http://review.cyanogenmod.org/#/c/141817/) (https://review.lineageos.org/#/c/93528/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/17/141817/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_kernel_oneplus_msm8974 refs/changes/28/93528/2 && git cherry-pick FETCH_HEAD
  # persistent_ram: check PERSISTENT_RAM_SIG before writing (http://review.cyanogenmod.org/#/c/142042/) (https://review.lineageos.org/#/c/93527/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/42/142042/3 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_kernel_oneplus_msm8974 refs/changes/27/93527/3 && git cherry-pick FETCH_HEAD
  # crypto: msm: qcrypto: Fix hash crash if not last issue (http://review.cyanogenmod.org/#/c/149487/) (https://review.lineageos.org/#/c/93498/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/87/149487/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_kernel_oneplus_msm8974 refs/changes/98/93498/1 && git cherry-pick FETCH_HEAD
  # crypto: msm: qcrypto: fix crash in _qcrypto_tfm_complete (http://review.cyanogenmod.org/#/c/149483/) (https://review.lineageos.org/#/c/93501/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/83/149483/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_kernel_oneplus_msm8974 refs/changes/01/93501/1 && git cherry-pick FETCH_HEAD

  # Sultanxda merged all of it
  # USB: usbfs: fix potential infoleak in devio (http://review.cyanogenmod.org/#/c/147180/) - CVE-2016-4482
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/80/147180/1 && git cherry-pick FETCH_HEAD
  # KEYS: Fix short sprintf buffer in /proc/keys show function (https://review.cyanogenmod.org/#/c/167139/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/39/167139/1 && git cherry-pick FETCH_HEAD
  # tcp: fix use after free in tcp_xmit_retransmit_queue() (https://review.cyanogenmod.org/#/c/167138/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/38/167138/1 && git cherry-pick FETCH_HEAD
  # binder: prevent kptr leak by using %pK format specifier (https://review.cyanogenmod.org/#/c/167136/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/36/167136/1 && git cherry-pick FETCH_HEAD
  # HID: hiddev: validate num_values for HIDIOCGUSAGES, HIDIOCSUSAGES commands (https://review.cyanogenmod.org/#/c/167134/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/34/167134/1 && git cherry-pick FETCH_HEAD
  # mnt: Fail collect_mounts when applied to unmounted mounts (https://review.cyanogenmod.org/#/c/167133/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_kernel_oneplus_msm8974 refs/changes/33/167133/1 && git cherry-pick FETCH_HEAD

  # proc: Remove verifiedbootstate flag from /proc/cmdline
  [ $(git remote | egrep \^sultan) ] && git remote rm sultan
  git remote add sultan https://github.com/sultanxda/android_kernel_oneplus_msm8996.git
  git fetch sultan
  git cherry-pick abc05b16bbd33521c2fffaf491c5657a94bfcfc5
  git remote rm sultan

  # Getting debugfs back - seems to improve stability a bit and allows BBS and GSam to watch kernel wakelocks statisticss
  #git revert --no-edit c70c04f2a76f092e8eebc5a86abb1d5d33f08ae3  # uncomment if have battery drain again
  git revert --no-edit 3c3558e46e0a7f5870bfc9e21cb16d0cf867d95e
  git revert --no-edit d043b8af86e12b347de158f66d8958dacf52b309
  git revert --no-edit 2b39420050edb34817ea510775a51871e82dabd8
  git revert --no-edit b0cb842c5e2f9bd7fb1251ed70ee1bc3e2514909

  [ $(git remote | egrep \^linux) ] && git remote rm linux
  git remote add linux https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
  git fetch linux
  # tty: n_hdlc: get rid of racy n_hdlc.tbuf (CVE-2017-2636)
  # https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/commit/?id=82f2341c94d270421f383641b7cd670e474db56b
  git cherry-pick 82f2341c94d270421f383641b7cd670e474db56b || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm linux

popd

pushd "$LOCAL_REPO/device/oneplus/bacon"
  sed -i "s#SnapdragonCamera#Snap#" bacon.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Replacing SnapdragonCamera with Snap"

  # bacon: Remove command-line parameters used for debugging
  git cherry-pick 6a5d2088b8efa2b72bf7d389972b85ec075e9d02 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
popd

pushd "$LOCAL_REPO/frameworks/base"
  git apply $HOME/uber-saber/patches/lower_highspeed.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Adding missing high speed qualities for Snap"

  # RemoteController: extract interface conflicting with CTS test (1/2) (http://review.cyanogenmod.org/#/c/143310/) (https://review.lineageos.org/#/c/66393/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/10/143310/3 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/93/66393/1 && git cherry-pick FETCH_HEAD

  # Dynamically enable MSB AGPS at runtime for newer baseband versions
  [ $(git remote | egrep \^sultan) ] && git remote rm sultan
  git remote add sultan https://github.com/sultanxda/android_frameworks_base.git
  git fetch sultan
  git cherry-pick d1ca594271e8017d2301f8702362217e8ac136ba || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm sultan

  cp data/sounds/ringtones/ogg/Orion.ogg data/sounds/slim/ringtones/
  git add $(git status -s | awk '{print $2}') && git commit -m "Adding Orion ringtone (my fav :))"

:<<comment
  # Update volume slider only if ringer mode changed
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/44/145344/2 && git cherry-pick FETCH_HEAD
  # Reduce log noise
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/63/137463/1 && git cherry-pick FETCH_HEAD
  # GlobalActions: Set the initial status of airplane mode toggle
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/21/135921/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # fix metrics density comparisons
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/73/136273/1 && git cherry-pick FETCH_HEAD
  # SysUI: Keep sensitive notifications redacted for swipe
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/92/133392/1 && git cherry-pick FETCH_HEAD
  # SysUI: Fix hiding per-app sensitive notifications
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/53/135553/1 && git cherry-pick FETCH_HEAD
  # SysUI: Fix hiding sensitive notification behavior
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/79/135779/1 && git cherry-pick FETCH_HEAD
  # Add ability to set preconfirmed apps filter for immersive mode hint
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/96/133296/3 && git cherry-pick FETCH_HEAD
  # SettingsProvider: Allow default volume adjust sound to be overlayed.
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/16/133316/4 && git cherry-pick FETCH_HEAD
  # SettingsProvider: allow ambient display/doze mode to be overlayed
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/88/133388/4 && git cherry-pick FETCH_HEAD
  # bootanimation: Move the bootanimation playaudio code
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/08/130208/4 && git cherry-pick FETCH_HEAD
  # LiveDisplayTile : Update entries on locale changes
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/23/132023/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # StrictMode: fix deserialization of ViolationInfo on large stacks
  git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/80/128280/3 && git cherry-pick FETCH_HEAD
comment

  # base: Fix proximity check on power key (https://review.lineageos.org/#/c/66623/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/37/134137/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/23/66623/2 && git cherry-pick FETCH_HEAD
  # base: Fix proximity check on non power key (https://review.lineageos.org/#/c/66622/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/26/135526/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/22/66622/2 && git cherry-pick FETCH_HEAD
  # Support for country specific ECC numbers in the framework (https://review.lineageos.org/#/c/66646/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/97/137197/4 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/46/66646/1 && git cherry-pick FETCH_HEAD
  # SharedStorageAgent: fix off by 1 (https://review.lineageos.org/#/c/66750/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/62/134162/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/50/66750/2 && git cherry-pick FETCH_HEAD
  # SystemUI: Handle possible NPE on task.group during layout. (https://review.lineageos.org/#/c/66832/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/43/133043/4 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/32/66832/1 && git cherry-pick FETCH_HEAD
  # AppOps: fix wifi scan op (https://review.lineageos.org/#/c/66987/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/85/126385/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/87/66987/2 && git cherry-pick FETCH_HEAD
popd

# bacon: Disable VoIP offload (http://review.cyanogenmod.org/#/c/136065/) (https://review.lineageos.org/#/c/29177/)
pushd "$LOCAL_REPO/device/oneplus/bacon"
  git cherry-pick f730ae48f890f8bb0bc7dfaa9ce24ba25de4108d || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  cp audio/audio_effects.conf $LOCAL_REPO/device/oppo/msm8974-common/audio/
  git rm audio/audio_effects.conf && git commit -m "Fixing LP structure"
popd
pushd "$LOCAL_REPO/device/oppo/msm8974-common"
  sed -i 's/tinymix/libqcomvoiceprocessingdescriptors \\\n    tinymix/' msm8974.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Disable VoIP offload"

  # bacon: Don't override GPS SUPL version
  [ $(git remote | egrep \^sultan) ] && git remote rm sultan
  git remote add sultan https://github.com/sultanxda/android_device_oneplus_bacon
  git fetch sultan
  git cherry-pick 3612d54b6f19c851e7ad5a8850da5c3671196760 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm sultan
popd

pushd "$LOCAL_REPO/device/oneplus/bacon"
  # bacon: Don't end up on ULL for media playback
  git cherry-pick 4025ba987be315303773e661bf021ef7ac6f08d7 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick ecf8af391a1711b04b4e04687fb5724afbd876d9

  sed -i 's#persist.audio.fluence.voicecall=true#drm.service.enabled=true\npersist.audio.fluence.voicecall=true#' system.prop
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Enable DRM service for Media Scanner"
  sed -i 's#TARGET_USERIMAGES_USE_F2FS := true#TARGET_USERIMAGES_USE_F2FS := true\n\# GPS\nBOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := true\nUSE_DEVICE_SPECIFIC_GPS := true\nUSE_DEVICE_SPECIFIC_LOC_API := true#' BoardConfig.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: set BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET and USE_DEVICE_SPECIFIC_GPS"

  # bacon: Add missing ULL usecases (http://review.cyanogenmod.org/#/c/142139/) (https://review.lineageos.org/#/c/29166/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oneplus_bacon refs/changes/39/142139/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_device_oneplus_bacon refs/changes/66/29166/2 && git cherry-pick FETCH_HEAD
  # >>> bacon: Add RAW path on primary output (http://review.cyanogenmod.org/#/c/142138/) (https://review.lineageos.org/#/c/29168/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_oneplus_bacon refs/changes/38/142138/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git fetch https://review.lineageos.org/LineageOS/android_device_oneplus_bacon refs/changes/68/29168/2 && git cherry-pick FETCH_HEAD|| git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

  # getting back PCM offload - need this for Poweramp Hi-Res output
  # hope only Miitomo app will have choppy audio playback
  git revert --no-edit b28d34983a7354a5957ee7ee3d80279be875aab7

  # Revert "bacon: disable Mifare Reader to fix freeze after scanning MClassic"
  git cherry-pick 37dd735c5c9b2d21f84d5ec9efba55afb8396409

  # bacon: add NFA_PROPRIETARY_CFG for proper Mifare Classic support
  git cherry-pick 5f83ae9a018dd5be75a2ec4f7a88b3478b1a9521

#  git apply $HOME/uber-saber/patches/android_device_oneplus_bacon_8cb14e6b0465542c117d0328dca3b82f03604d9e.patch
#  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Use NQ NFC for Mifare Classic support"

  # bacon: add first_api_level for CTS
  git cherry-pick 32fc93fc47a3f7fc02f210a8ed92f52e4e5d28c0 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue

popd

pushd "$LOCAL_REPO/device/oppo/msm8974-common"
  # bacon: Update thermal configuration for new 8-zone driver
  git apply $HOME/uber-saber/patches/android_device_oneplus_bacon_097b09ac1cd1638f762bc6a2ab6b1804a862806c.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Update thermal configuration for new 8-zone driver"

  sed -i 's#above_hispeed_delay "20000 1400000:40000 1700000:20000"#above_hispeed_delay "19000 1400000:39000 1700000:19000"#' rootdir/etc/init.qcom-common.rc
  sed -i 's#go_hispeed_load 70#go_hispeed_load 99#' rootdir/etc/init.qcom-common.rc
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Delicious butter"

  sed -i 's#write /sys/block/mmcblk0/bdi/read_ahead_kb 512#setprop sys.io.scheduler noop\n    write /sys/block/mmcblk0/bdi/read_ahead_kb 512#' rootdir/etc/init.qcom-common.rc
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Set I/O scheduler to Noop on early-init for primary eMMC device"

  git apply $HOME/uber-saber/patches/3a712a50107ceece5751bb6fdd0bdfdf5cc2b4c9.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: power: Configure performance profiles"

  [ $(git remote | egrep \^sultan) ] && git remote rm sultan
  git remote add sultan https://github.com/sultanxda/android_device_oneplus_bacon && git fetch sultan
  # bacon: Sync sec_config with CAF LA.BF.1.1.3_rb1.13
  git cherry-pick c6eac4868d4b786e91b293978b80c85a2de13a6b
  # : Add TZ.BF.2.0-2.0.0137 TrustZone version to white list
  git cherry-pick 124ca361647533f3548dd1a985bc3b1468c0bde9
  git remote rm sultan

popd

pushd "$LOCAL_REPO/packages/apps/Settings"
  # Settings: restore proper live display color profile (https://review.lineageos.org/#/c/129850/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Settings refs/changes/49/142049/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_apps_Settings refs/changes/50/129850/1 && git cherry-pick FETCH_HEAD
  # >>>>>> Hide Keypad for pattern lock (https://review.lineageos.org/#/c/129816/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Settings refs/changes/45/143245/5 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git fetch https://review.lineageos.org/LineageOS/android_packages_apps_Settings refs/changes/16/129816/1 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # Use same technology type for LTE/4G (https://review.lineageos.org/#/c/130046/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Settings refs/changes/48/133448/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_apps_Settings refs/changes/46/130046/1 && git cherry-pick FETCH_HEAD
popd

pushd "$LOCAL_REPO/packages/apps/InCallUI"
  # IncallUI: Screen doesn't wakeup after MT/MO call disconnect (http://review.cyanogenmod.org/#/c/143388/) (https://review.lineageos.org/#/c/123706/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_InCallUI refs/changes/88/143388/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_apps_InCallUI refs/changes/06/123706/1 && git cherry-pick FETCH_HEAD
  # InCallUI: Fix background colour of tabs on DSDA phones (https://review.lineageos.org/#/c/123765/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_packages_apps_InCallUI refs/changes/78/127078/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_apps_InCallUI refs/changes/65/123765/1 && git cherry-pick FETCH_HEAD
popd

# ril: Use CLOCK_BOOTTIME instead of CLOCK_MONOTONIC
pushd "$LOCAL_REPO/hardware/ril-caf"
  [ $(git remote | egrep \^sultan) ] && git remote rm sultan
  git remote add sultan https://github.com/sultanxda/android_hardware_ril.git && git fetch sultan
  git cherry-pick 0ccc3fc8de53bf862c9e45c1d546a68f4a21a4ae
  git remote rm sultan
popd

pushd "$LOCAL_REPO/vendor/oneplus"
  git apply $HOME/uber-saber/patches/004c5866123c5e6d0208a883373b2bbb760414c8.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Remove unused blobs"
popd

# Nfc: read extra properties of Mifare Classic
pushd "$LOCAL_REPO/packages/apps/Nfc"
  git cherry-pick 018ec89d460f8b6389b4ffe787d293090dcc0bdd
popd

pushd "$LOCAL_REPO/frameworks/opt/telephony"
  # [PATCH] (PICCOLO-4847) [PATCH] Force data attach when data is re-enabled after carrier-detatch. (https://review.lineageos.org/#/c/71185/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_opt_telephony refs/changes/77/134277/4 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_opt_telephony refs/changes/85/71185/4 && git cherry-pick FETCH_HEAD
  sed -i 's#attachedState.get();#attachedState;#' src/java/com/android/internal/telephony/dataconnection/DcTracker.java
  git add $(git status -s | awk '{print $2}') && git commit -m "Fixing build"
  # Suppress error pop-ups for single digit dials. (https://review.lineageos.org/#/c/71492/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_opt_telephony refs/changes/98/132098/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_opt_telephony refs/changes/92/71492/3 && git cherry-pick FETCH_HEAD
  # GsmMmiCode: Fix USSD NPE (https://review.lineageos.org/#/c/71484/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_opt_telephony refs/changes/18/133018/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_opt_telephony refs/changes/84/71484/1 && git cherry-pick FETCH_HEAD
popd

pushd "$LOCAL_REPO/packages/apps/DeskClock"
  # Allow music files other than OGG to be chosen as alarm (https://review.lineageos.org/#/c/119954/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_packages_apps_DeskClock refs/changes/29/145329/3 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_apps_DeskClock refs/changes/54/119954/3 && git cherry-pick FETCH_HEAD
popd

# getting back openssh for nano
#pushd "$LOCAL_REPO/external/openssh"
#	git revert --no-edit 6dd962236c57f327b92b0c8f09f649279980023c
#popd

pushd "$LOCAL_REPO/device/oppo/msm8974-common/"
  # http://review.cyanogenmod.org/#/c/135685/
  sed -i "s#audio.offload.pcm.16bit.enable=true#audio.offload.pcm.16bit.enable=false#" msm8974.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "bacon: Disable 16-bit PCM offload for good"
popd

pushd "$LOCAL_REPO/frameworks/av"
  # Allow to use baseline profile for AVC recording (https://review.lineageos.org/#/c/62414/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/46/169846/4 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/14/62414/4 && git cherry-pick FETCH_HEAD
  # SoftVPXEncoder: don't skip the last input buffer with eos flag. (https://review.lineageos.org/#/c/62848/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/62/136162/3 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/48/62848/1 && git cherry-pick FETCH_HEAD
  # Fix potential NULL dereference in Visualizer effect (https://review.lineageos.org/#/c/62343/)
  #git fetch https://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/40/175840/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/43/62343/1 && git cherry-pick FETCH_HEAD
  # Forward Port: Add Camera sound toggle [3/3] - was suddenly missing, so camera sound switcher did nothing >_<
  git fetch https://review.slimroms.org/SlimRoms/frameworks_av refs/changes/53/1853/1 && git cherry-pick FETCH_HEAD
popd

exit 0

#################

# frameworks/base: Support for third party NFC features (https://review.cyanogenmod.org/#/c/144379)
pushd "$LOCAL_REPO/frameworks/base"
  git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/79/144379/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
popd

# repo is now on branch cm-12.1, therefore "repo sync" does not drop the changes
pushd "$LOCAL_REPO/hardware/qcom/media-caf/msm8974"
  git cherry-pick 6c65aa27f1e7f2c633e8996b04e8d3e123f2b50e
  git cherry-pick 0f6c707bff89ccd3db4cb3b8b044761b7e674e93 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick 1afc24230b1fecd9b2ec9780b72c6af5b3154646 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git cherry-pick dc64230278eb5685342b8082036772b6415cc5cb
popd

# libnfc-nci: Add missing support for pn547/pn544
pushd "$LOCAL_REPO/external/libnfc-nci"
  git remote add sultan https://github.com/sultanxda/android_vendor_nxp-nfc_opensource_libnfc-nci
  git fetch sultan
  git cherry-pick 8b6b584c8502eedc2210c65459b68b7c329492c4 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm sultan
popd



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
