#!/bin/bash

LOCAL_REPO="$HOME/slimsaber"
FREEDCAM_REPO="$HOME/sdc/apps/FreeDCam"

cp -f $FREEDCAM_REPO/androiddng/libs/armeabi/libRawToDng.so $LOCAL_REPO/vendor/gwindlord/proprietary/libRawToDng/
