#!/bin/bash

LOCAL_REPO="$HOME/slimsaber"

cp -f /mnt/sdc/chromium/src/out/Release/apks/SWE_Browser.apk $LOCAL_REPO/vendor/gwindlord/proprietary/SWE_Browser/
cp -f /mnt/sdc/chromium/src/out/Release/swe_browser_apk/stripped_libraries/*.so $LOCAL_REPO/vendor/gwindlord/proprietary/SWE_Browser/

exit 0

