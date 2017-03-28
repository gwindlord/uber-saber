#!/bin/bash

# patching android-5.1.1_r37 with Google November 2016 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2016-10-01#PLATFORM_SECURITY_PATCH := 2016-11-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2016-11-01"
popd
pushd "$LOCAL_REPO/external/libvpx"
  # DO NOT MERGE | libvpx: Cherry-pick 0f42d1f from upstream (https://review.cyanogenmod.org/#/c/171488/) https://review.lineageos.org/#/c/60746/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_libvpx refs/changes/88/171488/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_external_libvpx refs/changes/46/60746/1 && git cherry-pick FETCH_HEAD
  # DO NOT MERGE libvpx: Cherry-pick 8b4c315 from upstream (https://review.cyanogenmod.org/#/c/171489/) https://review.lineageos.org/#/c/60745/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_libvpx refs/changes/89/171489/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_external_libvpx refs/changes/45/60745/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/external/sepolicy"
  # Allow the zygote to stat all files it opens. (https://review.cyanogenmod.org/#/c/171491/) https://review.lineageos.org/#/c/61026/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_sepolicy refs/changes/91/171491/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_external_sepolicy refs/changes/26/61026/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/external/expat"
  # Security Vulnerability - 2012-6702 and 2016-5300 (https://review.cyanogenmod.org/#/c/171523/) https://review.lineageos.org/#/c/60086/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_expat refs/changes/23/171523/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_external_expat refs/changes/86/60086/1 && git cherry-pick FETCH_HEAD
  # Upgrade to expat 2.1.1 (https://review.cyanogenmod.org/#/c/171521/) https://review.lineageos.org/#/c/60082/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_expat refs/changes/21/171521/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_external_expat refs/changes/82/60082/2 && git cherry-pick FETCH_HEAD
  # Fix 2016-0718: Expat XML Parser Crashes on Malformed Input (https://review.cyanogenmod.org/#/c/171522/) https://review.lineageos.org/#/c/60081/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_expat refs/changes/22/171522/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_external_expat refs/changes/81/60081/2 && git cherry-pick FETCH_HEAD
  # Fix cast from pointer to integer of different size (https://review.cyanogenmod.org/#/c/171524/) https://review.lineageos.org/#/c/60080/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_expat refs/changes/24/171524/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_external_expat refs/changes/80/60080/2 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/libcore"
  # System: Close log sockets prior to a fork. (https://review.cyanogenmod.org/#/c/171494/) https://review.lineageos.org/#/c/108936/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_libcore refs/changes/94/171494/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_libcore refs/changes/36/108936/1 && git cherry-pick FETCH_HEAD
  # IDN: Fix handling of long domain names. (https://review.cyanogenmod.org/#/c/171495/) https://review.lineageos.org/#/c/108935/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_libcore refs/changes/95/171495/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_libcore refs/changes/35/108935/2 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/packages/providers/DownloadProvider"
  # Enforce calling identity before clearing. (https://review.cyanogenmod.org/#/c/171499/) https://review.lineageos.org/#/c/138953/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_providers_DownloadProvider refs/changes/99/171499/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_packages_providers_DownloadProvider refs/changes/53/138953/1 && git cherry-pick FETCH_HEAD
popd
pushd "$LOCAL_REPO/system/core"
  # liblog: add __android_log_close() (https://review.cyanogenmod.org/#/c/171501/) https://review.lineageos.org/#/c/142853/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/01/171501/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_system_core refs/changes/53/142853/1 && git cherry-pick FETCH_HEAD
  # libzipfile: add additional validity checks. (https://review.cyanogenmod.org/#/c/171503/) https://review.lineageos.org/#/c/142851/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/03/171503/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_system_core refs/changes/51/142851/2 && git cherry-pick FETCH_HEAD
popd

pushd "$LOCAL_REPO/frameworks/base"
  # DO NOT MERGE Check caller for sending media key to global priority session (https://review.cyanogenmod.org/#/c/171540/) https://review.lineageos.org/#/c/65159/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/40/171540/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/59/65159/1 && git cherry-pick FETCH_HEAD
  # DO NOT MERGE) ExifInterface: Make saveAttributes throw an exception before change (https://review.cyanogenmod.org/#/c/171541/) https://review.lineageos.org/#/c/65176/1
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/41/171541/2 && git cherry-pick FETCH_HEAD
  # https://review.lineageos.org/#/c/65158/ - this one brokes git history
  #git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/58/65158/2 && git checkout FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/76/65176/1 && git cherry-pick FETCH_HEAD
  # Backport changes to whitelist sockets opened by the zygote. (https://review.cyanogenmod.org/#/c/171542/) https://review.lineageos.org/#/c/65100/
  # allows only whitelisted apps to load with system ones (like layers themes for frameworks, etc.)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/42/171542/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/00/65100/2 && git cherry-pick FETCH_HEAD || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  [ $(git remote | egrep \^CM) ] && git remote rm CM
  git remote add CM https://github.com/CyanogenMod/android_frameworks_base.git
  git fetch CM
  git cherry-pick 914117c62f5e7d1e80ffcca0cd269c572010a6df # Add CMSDK resource APK to Zygote FD whitelist
  git cherry-pick cf70929d108d86d86d166d6aa21f388544d2685f # zygote: Allow device to append extra whitelisted paths
  git remote rm CM
  # I realise it is a security hole, but with root framework-res.apk can be compromised too, so it's not such a big one
  echo -e '#define PATH_WHITELIST_EXTRA_H \\\n  "/system/vendor/overlay/TimberWolf_Framework.apk", \\\n  "/data/resource-cache/vendor@overlay@TimberWolf_Framework.apk@idmap", \\\n  "/proc/ged"' >> core/jni/fd_utils-inl-extra.h
  git add core/jni/fd_utils-inl-extra.h && git commit -m "Adding my favorite framework layers theme ;) and /proc/ged (used by some platforms' gfx stack)"
  # Prevent FDs from being leaked when accepted sockets are closed (https://review.cyanogenmod.org/#/c/171543/) https://review.lineageos.org/#/c/65157/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/43/171543/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/57/65157/2 && git cherry-pick FETCH_HEAD
  # Fix setPairingConfirmation permissions issue (2/2) (https://review.cyanogenmod.org/#/c/171544/) https://review.lineageos.org/#/c/65156/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/44/171544/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/56/65156/2 && git cherry-pick FETCH_HEAD
  # Use "all_downloads" instead of "my_downloads". (https://review.cyanogenmod.org/#/c/171545/) https://review.lineageos.org/#/c/65155/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/45/171545/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/55/65155/2 && git cherry-pick FETCH_HEAD
  # DO NOT MERGE: Fix deadlock in AcitivityManagerService. (https://review.cyanogenmod.org/#/c/171546/) https://review.lineageos.org/#/c/65154/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/46/171546/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/54/65154/2 && git cherry-pick FETCH_HEAD
  # Avoid crashing when downloading MitM'd PAC that is too big am: 7d2198b586 am: 9c1cb7a273 am: 6634e90ad7 am: 66ee2296a9 (https://review.lineageos.org/#/c/65153/)
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/47/171547/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/53/65153/2 && git cherry-pick FETCH_HEAD
  # Fix build break due to automerge of 7d2198b5 (https://review.cyanogenmod.org/#/c/171548/) https://review.lineageos.org/#/c/65152/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/48/171548/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_base refs/changes/52/65152/2 && git cherry-pick FETCH_HEAD
  # Catch all exceptions when parsing IME meta data
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/base
  git fetch aosp
  git cherry-pick 7625010a2d22f8c3f1aeae2ef88dde37cbebd0bf || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/av"
  # Limit mp4 atom size to something reasonable (https://review.cyanogenmod.org/#/c/171552/) https://review.lineageos.org/#/c/62391/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/52/171552/1 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/91/62391/1 && git cherry-pick FETCH_HEAD
  # Check mprotect result (https://review.cyanogenmod.org/#/c/171553/) https://review.lineageos.org/#/c/62390/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/53/171553/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/90/62390/2 && git cherry-pick FETCH_HEAD
  # Fix potential overflow in Visualizer effect (https://review.cyanogenmod.org/#/c/171554/) https://review.lineageos.org/#/c/62389/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/54/171554/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/89/62389/2 && git cherry-pick FETCH_HEAD
  # SampleIterator: clear members on seekTo error (https://review.cyanogenmod.org/#/c/171555/) https://review.lineageos.org/#/c/62388/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/55/171555/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/88/62388/2 && git cherry-pick FETCH_HEAD
  # SoundTrigger: get service by value. (https://review.cyanogenmod.org/#/c/171556/) https://review.lineageos.org/#/c/62387/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/56/171556/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/87/62387/2 && git cherry-pick FETCH_HEAD
  # DO NOT MERGE omx: check buffer port before using (https://review.cyanogenmod.org/#/c/171557/) https://review.lineageos.org/#/c/62386/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/57/171557/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/86/62386/2 && git cherry-pick FETCH_HEAD
  # DO NOT MERGE: IOMX: work against metadata buffer spoofing (https://review.cyanogenmod.org/#/c/171558/) https://review.lineageos.org/#/c/62385/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/58/171558/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/85/62385/2 && git cherry-pick FETCH_HEAD
  # IOMX: allow configuration after going to loaded state (https://review.cyanogenmod.org/#/c/171561/) https://review.lineageos.org/#/c/62384/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/61/171561/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/84/62384/2 && git cherry-pick FETCH_HEAD
  # IOMX: do not clear buffer if it's allocated by component (https://review.cyanogenmod.org/#/c/171562/) https://review.lineageos.org/#/c/62383/
  #git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/62/171562/2 && git cherry-pick FETCH_HEAD
  git fetch https://review.lineageos.org/LineageOS/android_frameworks_av refs/changes/83/62383/2 && git cherry-pick FETCH_HEAD
popd

exit 0

# Sultanxda merged it
pushd "$LOCAL_REPO/kernel/oneplus/msm8974"
  [ $(git remote | egrep \^CAF) ] && git remote rm CAF
  git remote add CAF https://source.codeaurora.org/quic/la/kernel/msm-3.10 && git fetch CAF
  # msm: sensor: Avoid potential stack overflow
  git cherry-pick ef78bd62f0c064ae4c827e158d828b2c110ebcdc || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm CAF
popd

# but I still love kitties ^_^
# though I've realised how stupid it is to add this game as a system app
pushd "$HOME/apps/NekoCollector"
  #git pull
  ./buildapp
  cp app/build/outputs/apk/app-release.apk $LOCAL_REPO/vendor/gwindlord/proprietary/NekoCollector/NekoCollector.apk
popd
pushd "$LOCAL_REPO/vendor/slim"
  sed -i 's#KernelAdiutor#NekoCollector#' config/common.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Adding Neko Collector app to the build"
popd
pushd "$LOCAL_REPO/frameworks/base"
  # love kitties ^_^
  # but they don't love me >_<
  git remote add aosp https://android.googlesource.com/platform/frameworks/base
  git fetch aosp
    git cherry-pick 27a9fcc61823f919cee773df563b49ee11004f3b || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
    git cherry-pick 9a9e673bc57ee8a3651396fa3988beb22aa8f1d6
    git cherry-pick 04f8cc2bb34035fa46bbc046a66972be8913b147
    git cherry-pick 4b7e415803b3e3c9517b21bc9406af815442b59b || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
    git cherry-pick 610f6ede251c44cb4cf0e8a993d8d88c121159f9
    git cherry-pick a801d40531b71f8c75bb03bb8fec429f503e391e
    git cherry-pick 1bdc770e664d7052ae277ea07bd40bd36037d822
    git cherry-pick 753762c8fa3fae29f20a0fc34531ecef3fef85a9
    git cherry-pick 4a1bcd966b1c271909f38b41031cc012e233fbdd
    git cherry-pick 1e52909888fc27bc8d7f63ceeabba0a87b65e419
    git cherry-pick 7c2e730f637ee40f2be642b08a3956895dbb178b
  git remote rm aosp
  cp $SCRIPT_DIR/patches/PlatLogoActivity.java core/java/com/android/internal/app/
  git add core/java/com/android/internal/app/PlatLogoActivity.java && git commit -m "Fix for L version"
popd
