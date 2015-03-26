#!/bin/bash
blue='\033[1;34m'
red='\033[0;31m'
NC='\033[0m' # No Color
if [ -z "$1" ]; then
    echo -e "${red}Please use like, ./Install filetoinstall.zip${NC} "
    exit 1
fi
if [ ! -f "$1" ]; then
    echo -e "${red}Invalid Zip${NC}"
    exit 1
fi
echo -e "\n${blue}Starting...\nPlease disconnect any other device${NC}"
read -p "Press enter to continue..." -s
if ! lsusb | grep "18d1:d00d" >/dev/null; then
    if ! lsusb | grep "05c6:676" >/dev/null; then
        echo -e "\n${blue}Please connect your device${NC}"
		read -p "Press enter to continue..." -s
	    if ! lsusb | grep "05c6:676" >/dev/null; then
	        echo -e "\n${blue}Please connect your device${NC}"
			read -p "Press enter to continue..." -s
		    if ! lsusb | grep "05c6:676" >/dev/null; then
		        echo -e "\n${blue}Device not connected.${NC}"
			    exit 1
		    fi
	    fi
    fi
    if lsusb | grep "05c6:6764" >/dev/null; then
        echo -e "\n${blue}Please enable adb on your device${NC}"
        read -p "Press enter to continue..." -s
        if lsusb | grep "05c6:6764" >/dev/null; then
            echo -e "\n${blue}Please enable adb on your device${NC}"
            read -p "Press enter to continue..." -s
            if lsusb | grep "05c6:6764" >/dev/null; then
                echo -e "\n${blue}Adb has not been enabled.${NC}"
                read -p "Press enter to exit..." -s
            fi
        fi
    fi
echo -e "\n${blue}Rebooting using adb.${NC}"
adb reboot-bootloader
fi
echo -e "\n${blue}All data will be wiped off your phone if it is not yet unlocked (oem unlock hasn't been ran)${NC}"
read -p "Press enter to continue..." -s
fastboot oem unlock
if [ ! -f "openrecovery-twrp-2.8.5.1-bacon.img" ]
then
	echo -e "\n${blue}Downloading Twrp Image${NC}"
	wget  http://techerrata.com/file/twrp2/bacon/openrecovery-twrp-2.8.5.1-bacon.img
fi
echo -e "\n${blue}Booting Twrp${NC}"
fastboot boot openrecovery-twrp-2.8.5.1-bacon.img
sleep 7
echo "-e \n${blue}Please click advanced then adb sideload then swipe.${NC}"
read -p "Press enter to continue..." -s
adb sideload $1
