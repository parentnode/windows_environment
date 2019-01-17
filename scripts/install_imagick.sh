#!/bin/bash -e
# Downloading and installing Imagick
echo "Looking for $imagick"
if [ -e /mnt/c/srv/packages/$imagick.zip ] ; then
	echo "$imagick already exist"
else

	echo "Downloading: $imagick"
	cd /mnt/c/srv/packages/
	wget -O $imagick.zip $imagick_path


	# Unpack zip
	unzip $imagick.zip -d /mnt/c/srv/packages/

	echo ""
	echo "Installing $imagick"
	/mnt/c/srv/packages/$imagick.exe /NOICONS /SILENT

	# Remove installer
	rm /mnt/c/srv/packages/$imagick.exe

fi
echo ""