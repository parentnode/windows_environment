#!/bin/bash -e
# Downloading and installing ffmpeg
echo "Looking for $ffmpeg"
if [ -e /mnt/c/srv/packages/$ffmpeg.zip ] ; then
	echo "$ffmpeg already exist"
else

	# Remove existing version
	if [ -e /mnt/c/srv/installed-packages/ffmpeg ] ; then
		sudo rm -R /mnt/c/srv/installed-packages/ffmpeg
	fi

	echo "Downloading: $ffmpeg"
	cd /mnt/c/srv/packages/
	wget -O $ffmpeg.zip $ffmpeg_path 

	echo ""
	echo "Installing $ffmpeg"
	unzip $ffmpeg.zip -d /mnt/c/srv/installed-packages/ffmpeg

fi
echo ""