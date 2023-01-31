#!/bin/bash
# Flash klipper to BTT OCtopus using RaspberrPI GPIO Reset process.

RESET_GPIO=19
BOOT0_GPIO=26
OCTOPUS_STR="OpenMoko"
DFU_STR="STMicroelectronics STM Device in DFU Mode"

# Drive the BOOT0 pin HIGH to simulate jumper
enable_boot0 () {
	raspi-gpio set $BOOT0_GPIO op pn dh
}

# Set BOOT0 Flating
disable_boot0 () {
	raspi-gpio set $BOOT0_GPIO ip pd
}

# Trigger Reboot
reboot_octopus () {
	raspi-gpio set $RESET_GPIO op pn dl
	sleep 2
	raspi-gpio set $RESET_GPIO ip 
}

echo "Octopus board GPIO Flasher"
echo "Trying to reboot in DFU Mode"

enable_boot0
sleep 1
reboot_octopus
sleep 2

# Test if device has rebooted into DFU Mode
DEV=`lsusb | grep "${DFU_STR}" | awk '{print $6}'`

if [ -z "$DEV" ]
then
	echo "Device not found"
	exit 0
else
	echo "Found DFU Device $DEV"
fi

#Flash device
echo "Invoking klipper dfu flash"
make flash FLASH_DEVICE=$DEV

#return board to normal mode
echo "Rebooting to klipper, please wait"
disable_boot0
sleep 1
reboot_octopus
sleep 4

SUCCESS=`lsusb | grep "${OCTOPUS_STR}" | awk '{print $6}'`

if [ -z "$SUCCESS" ]
then
	echo "Something went wrong, please restart the board manually"
	exit 0
else
	echo "Flashing complete"
fi

