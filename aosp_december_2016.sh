#!/bin/bash

# patching android-5.1.1_r37 with Google December 2016 security fixes wherever possible

LOCAL_REPO="$1"
if [[ "$#" != "1"  ]]; then
  echo "usage: $0 LOCAL_REPO" >&2
  exit 1
fi

# errors on
set -e

pushd "$LOCAL_REPO/build"
  sed -i 's#PLATFORM_SECURITY_PATCH := 2016-11-01#PLATFORM_SECURITY_PATCH := 2016-12-01#' core/version_defaults.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Updating security string patch to 2016-12-01"
popd
pushd "$LOCAL_REPO/system/core"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/system/core
  git fetch aosp
  # Fix out of bound access in libziparchive
  git cherry-pick 1ee4892e66ba314131b7ecf17e98bb1762c4b84c
  git remote rm aosp
popd
pushd "$LOCAL_REPO/packages/services/Telephony"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/packages/services/Telephony
  git fetch aosp
  # Restrict SipProfiles to profiles directory
  git cherry-pick 1294620627b1e9afdf4bd0ad51c25ed3daf80d84 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/av"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/av
  git fetch aosp
  # stagefright: stop reading meta data after MDAT or MOOF
  git cherry-pick 928da1e9631bc7f5a5484c4668646c161515aee6 #|| git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # stagefright: fix issues with bitrate handling
  git cherry-pick 46f80165c595d81dda68f8f3fea27f4fb04937dd || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # Fix divide by zero
  git cherry-pick fd9cc97d4dfe2a2fbce2c0f1704d7a27ce7cbc44
  # MPEG4Extractor: Check mLastTrack before parsing btrt box.
  git cherry-pick 0d13824315b0491d44e9c6eb5db06489ab0fcc20 || git rm media/libmedia/IMediaExtractor.cpp && git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/ex"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/ex
  git fetch aosp
  # Handle color bounds correctly in GIF decode
  git cherry-pick 0ada9456d0270cb0e357a43d9187a6418d770760
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/base"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/base
  git fetch aosp
  # Isolated processes don't get precached system service binders
  git cherry-pick 2c61c57ac53cbb270b4e76b9d04465f8a3f6eadc
  git remote rm aosp
popd
pushd "$LOCAL_REPO/frameworks/opt/net/wifi"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/frameworks/opt/net/wifi
  git fetch aosp
  # wifinative jni: check array length to prevent stack overflow
  git cherry-pick a5a18239096f6faee80f15f3fff39c3311898484
  git remote rm aosp
popd

exit 0

pushd "$LOCAL_REPO/bionic"
  [ $(git remote | egrep \^aosp) ] && git remote rm aosp
  git remote add aosp https://android.googlesource.com/platform/bionic
  git fetch aosp
  git cherry-pick 3656958a16590d07d1e25587734e000beb437740
  git remote rm aosp
popd

# this was for nano inculsion, which I cannot find case for
pushd "$LOCAL_REPO/external/openssh"
  # CVE-2015-5352, CVE-2015-6563, CVE-2015-6564, CVE-2016-1907, CVE-2016-3115, CVE-2016-6515, CVE-2016-8858, CVE-2016-6210
  [ $(git remote | egrep \^openssh) ] && git remote rm openssh
  git remote add openssh https://github.com/openssh/openssh-portable.git
  git fetch openssh
  # better refuse ForwardX11Trusted=no connections attempted
  git cherry-pick 1bf477d3cdf1a864646d59820878783d42357a1d || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # Don't resend username to PAM; it already has it.
  git cherry-pick d4697fe9a28dab7255c60433e4dd23cf7fce8a8b
  # set sshpam_ctxt to NULL after free
  git cherry-pick 5e75f5198769056089fb06c4d738ab0e5abc66f7
  # ignore PAM environment vars when UseLogin=yes
  git cherry-pick 85bdcd7c92fe7ff133bbc4e10a65c91810f88755
  # fix OOB read in packet code caused by missing return
  git cherry-pick 2fecfd486bdba9f51b3a789277bb0733ca36e1c0 || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  git apply $HOME/uber-saber/patches/CVE-2016-3115.patch
  git add $(git status -s | awk '{print $2}') && git commit -m "Fix for CVE-2016-3115"
  # Skip passwords longer than 1k in length so clients can't easily DoS sshd by sending very long passwords, causing it to spend CPU hashing them
  git cherry-pick fcd135c9df440bcd2d5870405ad3311743d78d97
  # Unregister the KEXINIT handler after message has been received
  git cherry-pick ec165c392ca54317dbe3064a8c200de6531e89ad || git add $(git status -s | awk '{print $2}') && git cherry-pick --continue
  # Determine appropriate salt for invalid users
  git cherry-pick 9286875a73b2de7736b5e50692739d314cd8d9dc
  # Mitigate timing of disallowed users PAM logins
  git cherry-pick 283b97ff33ea2c641161950849931bd578de6946
  # Search users for one with a valid salt
  git cherry-pick dbf788b4d9d9490a5fff08a7b09888272bb10fcc
  git remote rm openssh
popd

# Sultan added it
pushd "$LOCAL_REPO/kernel/oneplus/msm8974/"
  [ $(git remote | egrep \^linux) ] && git remote rm linux
  git remote add linux https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  git fetch linux
  # packet: fix race condition in packet_set_ring
  git cherry-pick 84ac7260236a49c79eede91617700174c2c19b0c
  git remote rm linux
popd
pushd "$LOCAL_REPO/kernel/oneplus/msm8974/"
  [ $(git remote | egrep \^CAF310) ] && git remote rm CAF310
  git remote add CAF310 https://source.codeaurora.org/quic/la/kernel/msm-3.10
  git fetch CAF310
  # msm: sensor: validate the i2c table index before use
  git cherry-pick b5df02edbcdf53dbbab77903d28162772edcf6e0
  git remote rm CAF310
popd
