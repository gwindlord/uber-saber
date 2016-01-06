#!/bin/bash

LOCAL_REPO="$HOME/slimsaber"
CHROMIUM_DIR="/mnt/sdc/chromium"

if [ -d "$CHROMIUM_DIR/src/out/Release/apks" ]; then

  rm $LOCAL_REPO/vendor/gwindlord/proprietary/SWE_Browser/SWE_Browser.apk
  rm $LOCAL_REPO/vendor/gwindlord/proprietary/SWE_Browser/*.so

  cp -f $CHROMIUM_DIR/src/out/Release/apks/SWE_Browser.apk $LOCAL_REPO/vendor/gwindlord/proprietary/SWE_Browser/
  cp -f $CHROMIUM_DIR/src/out/Release/swe_browser_apk/stripped_libraries/*.so $LOCAL_REPO/vendor/gwindlord/proprietary/SWE_Browser/

fi
