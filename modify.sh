#!/bin/bash

LOCAL_REPO="$HOME/slimsaber"
SCRIPT_DIR="$(dirname $(readlink -f $0))"

# errors on
set -e

# turning Sultan's CPU underclock off
$SCRIPT_DIR/turn_off_underclock.sh $LOCAL_REPO

# setting custom camera as system one
$SCRIPT_DIR/set_customcamera.sh $LOCAL_REPO

# setting Uber version (currently works only for 4.8 - even 4.9 causes data alignment segfaults while working)
# now taking some commits from DerRommeister and building kernel with 6.0 :)
$SCRIPT_DIR/set_uber.sh $LOCAL_REPO

# setting GPS configuration for Belarus
$SCRIPT_DIR/bel_gps/copy_gps_conf.sh $LOCAL_REPO

# copying browser sync backup script
#$SCRIPT_DIR/browsersync/copy_browsersync.sh

# any additional actions
$SCRIPT_DIR/additional.sh $LOCAL_REPO

# odexing framework
$SCRIPT_DIR/odex.sh $LOCAL_REPO

# update NovaLauncher to the recent version
$SCRIPT_DIR/NovaUpdate/copy_nova.sh $LOCAL_REPO

# set translation for SnapCam
# accidentally added this while merging LA.BR.1.2.5_rb2.28 (after such merge "repo sync" does not refresh local repo)
#$SCRIPT_DIR/RussianSnapCam/copy_russian_snapcam.sh $LOCAL_REPO

# set translation for Settings
$SCRIPT_DIR/RussianSettings/copy_rus_settings.sh $LOCAL_REPO

# set translation for DeviceHandler
$SCRIPT_DIR/RussianDeviceHandler/copy_rus_devicehandler.sh $LOCAL_REPO

# set translation for Telephony
$SCRIPT_DIR/RussianTelephony/copy_rus_telephony.sh $LOCAL_REPO

# Adding new Sultan's camera
# shots, taken at my flat, are noticeably worse with these drivers
# they set enorumous ISO, like 1977 or 2290, where the old drivers set 778-801
#$SCRIPT_DIR/OPXCamDrivers/copy_drivers.sh $LOCAL_REPO

# patching SlimSaber sources with AOSP changes from android-5.1.1_r26 to android-5.1.1_r30
$SCRIPT_DIR/aosp_r30.sh $LOCAL_REPO

# patching SlimSaber sources with AOSP changes from android-5.1.1_r30 to android-5.1.1_r33
$SCRIPT_DIR/aosp_r33.sh $LOCAL_REPO

# patching SlimSaber sources with AOSP changes from android-5.1.1_r33 to android-5.1.1_r34
$SCRIPT_DIR/aosp_r34.sh $LOCAL_REPO

# patching SlimSaber sources with AOSP changes from android-5.1.1_r33 to android-5.1.1_r35
$SCRIPT_DIR/aosp_r35_r36.sh $LOCAL_REPO

# patch code to be compiled with UBER 5.3
#$SCRIPT_DIR/androideabi5.sh

# adding pre-built Chromium Snapdragon
#$SCRIPT_DIR/chromium.sh $LOCAL_REPO

# temporary changes, which will be removed or something
$SCRIPT_DIR/temp.sh $LOCAL_REPO
