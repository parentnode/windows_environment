#!/bin/bash -e
# Downloading and installing Imagick
echo "--------------------------"
echo "---Looking for $imagick---"
echo "--------------------------"
if [ -e /mnt/c/srv/packages/$imagick.zip ] ; then
	echo "----------------------------"
	echo "---$imagick already exist---"
	echo "----------------------------"
else
	echo "---------------------------"
	echo "---Downloading: $imagick---"
	echo "---------------------------"
	echo ""

	cd /mnt/c/srv/packages/
	wget -O $imagick.zip $imagick_path
	echo ""

	# Unpack zip
	unzip $imagick.zip -d /mnt/c/srv/packages/
	echo "-------------------------"
	echo "---Installing $imagick---"
	echo "-------------------------"
	echo ""
	/mnt/c/srv/packages/$imagick.exe /NOICONS /SILENT
	echo ""

	echo "----------------------------------------------"
	echo "---Removing installation files for $imagick---"
	echo "----------------------------------------------"
	echo ""
	# Remove installer
	rm /mnt/c/srv/packages/$imagick.exe
	echo ""
fi
echo ""