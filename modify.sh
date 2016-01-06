#!/bin/bash

SCRIPT_DIR="$(dirname $(readlink -f $0))"

# turning Sultan's CPU underclock off
$SCRIPT_DIR/turn_off_underclock.sh

# setting custom camera as system one
$SCRIPT_DIR/set_customcamera.sh

# setting Uber version (currently works only for 4.8 - even 4.9 causes data alignment segfaults while working)
# now taking some commits from DerRommeister and building kernel with 6.0 :)
$SCRIPT_DIR/set_uber.sh

# setting GPS configuration for Belarus
$SCRIPT_DIR/bel_gps/copy_gps_conf.sh

# copying browser sync backup script
#$SCRIPT_DIR/browsersync/copy_browsersync.sh

# any additional actions
$SCRIPT_DIR/additional.sh

# odexing framework
$SCRIPT_DIR/odex.sh

# update NovaLauncher to the recent version
$SCRIPT_DIR/NovaUpdate/copy_nova.sh

# set translation for SnapCam
$SCRIPT_DIR/RussianSnapCam/copy_russian_snapcam.sh

# set translation for Settings
$SCRIPT_DIR/RussianSettings/copy_rus_settings.sh

# set translation for DeviceHandler
$SCRIPT_DIR/RussianDeviceHandler/copy_rus_devicehandler.sh

# set translation for Telephony
$SCRIPT_DIR/RussianTelephony/copy_rus_telephony.sh

# patching SlimSaber sources with AOSP changes from android-5.1.1_r26 to android-5.1.1_r30
$SCRIPT_DIR/aosp_r30.sh

# patching SlimSaber sources with AOSP changes from android-5.1.1_r30 to android-5.1.1_r33
$SCRIPT_DIR/aosp_r33.sh

# adding pre-built Chromium Snapdragon
$SCRIPT_DIR/chromium.sh

# temporary changes, which will be removed or something
$SCRIPT_DIR/temp.sh
