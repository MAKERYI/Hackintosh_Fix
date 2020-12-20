#!/bin/bash

echo "
************************************************************************************

                                    MAKERYI
                                一个人就是一支军队
                                                                                  
************************************************************************************
"

DAEMON_PATH=/Library/LaunchDaemons/
BIN_PATH=/usr/local/bin/
TMP_PATH=/tmp/
ALC_DAEMON_FILE=good.win.ALCPlugFix.plist
VERB_FILE=hda-verb
ALC_FIX_FILE=ALCPlugFix
TIME_FIX_FILE=localtime-toggle
TIME_DAEMON_FILE=org.osx86.localtime-toggle.plist
NUMLOCK_FIX_FILE=setleds
NUMLOCK_DAEMON_FILE=com.rajiteh.setleds.plist

echo "This script required to run as root"

sudo spctl --master-disable

sudo pmset -a hibernatemode 0

sudo rm -rf /var/vm/sleepimage

sudo mkdir /var/vm/sleepimage

echo "Downloading required files"
sudo curl -o $TMP_PATH$ALC_FIX_FILE "https://github.com/MAKERYI/Hackintosh_Fix/raw/master/ALCPlugFix/ALCPlugFix"
sudo curl -o $TMP_PATH$VERB_FILE "https://github.com/MAKERYI/Hackintosh_Fix/raw/master/ALCPlugFix/hda-verb"
sudo curl -o $TMP_PATH$ALC_DAEMON_FILE "https://github.com/MAKERYI/Hackintosh_Fix/raw/master/ALCPlugFix/good.win.ALCPlugFix.plist"
sudo curl -o $TMP_PATH$TIME_FIX_FILE "https://github.com/MAKERYI/Hackintosh_Fix/raw/master/TimeSynchronization/localtime-toggle"
sudo curl -o $TMP_PATH$TIME_DAEMON_FILE "https://github.com/MAKERYI/Hackintosh_Fix/raw/master/TimeSynchronization/org.osx86.localtime-toggle.plist"
sudo curl -o $TMP_PATH$NUMLOCK_FIX_FILE "https://github.com/MAKERYI/Hackintosh_Fix/raw/master/NumLockFix/setleds"
sudo curl -o $TMP_PATH$NUMLOCK_DAEMON_FILE "https://github.com/MAKERYI/Hackintosh_Fix/raw/master/NumLockFix/com.rajiteh.setleds.plist"

if [ ! -d "$BIN_PATH" ] ; then
    mkdir "$BIN_PATH" ;
fi

echo "Copy file to destination place..."
sudo cp -a $TMP_PATH$ALC_FIX_FILE $BIN_PATH
sudo cp -a $TMP_PATH$VERB_FILE $BIN_PATH
sudo cp -a $TMP_PATH$ALC_DAEMON_FILE $DAEMON_PATH
sudo cp -R $TMP_PATH$TIME_FIX_FILE $BIN_PATH
sudo cp -R $TMP_PATH$TIME_DAEMON_FILE $DAEMON_PATH
sudo cp $TMP_PATH$NUMLOCK_FIX_FILE $BIN_PATH
sudo cp $TMP_PATH$NUMLOCK_DAEMON_FILE $DAEMON_PATH
sudo rm $TMP_PATH$ALC_FIX_FILE
sudo rm $TMP_PATH$VERB_FILE
sudo rm $TMP_PATH$ALC_DAEMON_FILE
sudo rm $TMP_PATH$TIME_FIX_FILE
sudo rm $TMP_PATH$TIME_DAEMON_FILE
sudo rm $TMP_PATH$NUMLOCK_FIX_FILE
sudo rm $TMP_PATH$NUMLOCK_APP

echo "Chmod ALCPlugFix..."
sudo chmod 755 $BIN_PATH$ALC_FIX_FILE
sudo chown $USER:admin $BIN_PATH$ALC_FIX_FILE
sudo chmod 755 $BIN_PATH$VERB_FILE
sudo chown $USER:admin $BIN_PATH$VERB_FILE
sudo chmod 644 $DAEMON_PATH$ALC_DAEMON_FILE
sudo chown root:wheel $DAEMON_PATH$ALC_DAEMON_FILE

echo "Chmod localtime-toggle..."
sudo chmod +x $BIN_PATH$TIME_FIX_FILE
sudo chown root $DAEMON_PATH$TIME_DAEMON_FILE
sudo chmod 644 $DAEMON_PATH$TIME_DAEMON_FILE

echo "Chmod FixNumLock..."
sudo chmod +x $BIN_PATH$NUMLOCK_FIX_FILE
sudo chown root:wheel $DAEMON_PATH$NUMLOCK_DAEMON_FILE

echo "Load ALCPlugFix..."
if sudo launchctl list | grep --quiet ALCPlugFix; then
    echo "Stopping existing ALCPlugFix daemon."
    sudo launchctl unload $DAEMON_PATH$ALC_DAEMON_FILE
fi
sudo launchctl load -w $DAEMON_PATH$ALC_DAEMON_FILE

echo "Load Localtime-toggle..."
if sudo launchctl list | grep --quiet localtime-toggle; then
    echo "Stopping existing localtime-toggle daemon."
    sudo launchctl unload $DAEMON_PATH$TIME_DAEMON_FILE
fi
sudo launchctl load -w $DAEMON_PATH$TIME_DAEMON_FILE

echo "Load FixNumLock..."
if sudo launchctl list | grep --quiet com.rajiteh.setleds; then
    echo "Stopping existing FixNumLock daemon..."
   sudo launchctl unload $DAEMON_PATH$NUMLOCK_DAEMON_FILE
fi
sudo launchctl load -w $DAEMON_PATH$NUMLOCK_DAEMON_FILE

echo "Rebuild the Kextcache..."
sudo kextcache -i /

echo "Done!"

exit 0
