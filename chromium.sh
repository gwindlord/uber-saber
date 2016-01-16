#!/bin/bash

LOCAL_REPO="$HOME/slimsaber"
CHROMIUM_DIR="/mnt/sdc/chromium"

pushd "$CHROMIUM_DIR"
  ./build/update.sh
  ./build/make.sh --system
popd

exit 0

if [ -f "$CHROMIUM_DIR/src/out/Release/swe_system_package.zip" ]; then

  rm -rf $LOCAL_REPO/packages/apps/Browser/*
  #rm -rf $LOCAL_REPO/packages/apps/Browser/.git
  unzip $CHROMIUM_DIR/src/out/Release/swe_system_package.zip -d $LOCAL_REPO/packages/apps/Browser

  pushd $LOCAL_REPO/packages/apps/Browser
    git add $(git status -s | awk '{print $2}')
    git commit -m "Replacing stock Browser with Snapdragon Chromium"
  popd

#  rm $LOCAL_REPO/vendor/gwindlord/proprietary/SWE_Browser/SWE_Browser.apk
#  rm $LOCAL_REPO/vendor/gwindlord/proprietary/SWE_Browser/*.so

#  cp -f $CHROMIUM_DIR/src/out/Release/apks/SWE_Browser.apk $LOCAL_REPO/vendor/gwindlord/proprietary/SWE_Browser/
#  cp -f $CHROMIUM_DIR/src/out/Release/swe_browser_apk/stripped_libraries/*.so $LOCAL_REPO/vendor/gwindlord/proprietary/SWE_Browser/

fi
