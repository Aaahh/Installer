#!/bin/bash
if [ -z "$1" ]; then
    echo "Please use like, ./Install filetoinstall.zip"
    exit 1
fi
echo -e "\nStarting...\nPlease disconnect any other device"
read -p "Press enter to continue..." -s
if ! lsusb | grep "18d1:d00d" >/dev/null; then
    if ! lsusb | grep "05c6:676" >/dev/null; then
        echo "\nPlease connect your device"
        read -p "Press enter to continue..." -s
    fi
    if lsusb | grep "05c6:6764" >/dev/null; then
        echo "\nPlease enable adb on your device"
        read -p "Press enter to continue..." -s
        if lsusb | grep "05c6:6764" >/dev/null; then
            echo "\nPlease enable adb on your device"
            read -p "Press enter to continue..." -s
            if lsusb | grep "05c6:6764" >/dev/null; then
                echo "\nAdb has not been enabled."
                read -p "Press enter to exit..." -s
            fi
        fi
    fi
adb reboot-bootloader
fi
echo -e "\nAll data will be wiped off your phone if it is not yet unlocked (oem unlock hasn't been ran)"
read -p "Press enter to continue..." -s
fastboot oem unlock
echo "Downloading Twrp Image"
wget  http://techerrata.com/file/twrp2/bacon/openrecovery-twrp-2.8.5.1-bacon.img
echo "Booting Twrp"
fastboot boot openrecovery-twrp-2.8.5.1-bacon.img
sleep 7
echo "Please click advanced then adb sideload then swipe."
read -p "Press enter to continue..." -s
adb sideload $1
