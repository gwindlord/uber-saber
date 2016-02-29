#!/bin/bash

LOCAL_REPO="$HOME/slimsaber"

pushd "$LOCAL_REPO/bionic"
  sed -i 's|#include <wchar.h>|#include <wchar.h>\n#include <stdint.h>\ntypedef uint16_t char16_t;\ntypedef uint32_t char32_t;|' libc/include/uchar.h
  git add $(git status -s | awk '{print $2}') && git commit -m "Fixing GCC5 build"
popd

pushd "$LOCAL_REPO/frameworks/base"
  perl -p -i -e 's/\(!mHeader->flags&ResStringPool_header::UTF8_FLAG &&/\(!(mHeader->flags&ResStringPool_header::UTF8_FLAG\) &&/' libs/androidfw/ResourceTypes.cpp
  git add $(git status -s | awk '{print $2}') && git commit -m "Fixing GCC5 build"
popd

pushd "$LOCAL_REPO/hardware/qcom/display-caf/msm8974"
  sed -i 's#common_flags += -Werror -Wno-error=unused-parameter #common_flags += -Werror -Wno-error=unused-parameter -Wno-error=sizeof-array-argument -Wno-error=bool-compare#' common.mk
  git add $(git status -s | awk '{print $2}') && git commit -m "Fixing GCC5 build"
popd

pushd "$LOCAL_REPO/system/core"
  sed -i 's|#include <stddef.h>|#include <stddef.h>\ntypedef uint16_t char16_t;|' include/cutils/jstring.h
  git add $(git status -s | awk '{print $2}') && git commit -m "Fixing GCC5 build"
popd

