#!/bin/bash -e
# Downloading and installing ffmpeg

echo ""
echo "---Looking for $ffmpeg---"
echo ""
if [ -e /mnt/c/srv/packages/$ffmpeg.zip ] ; then
	echo "$ffmpeg already exist"
	echo ""
	echo "---$ffmpeg already exist---"
	echo ""
else

	# Remove existing version
	if [ -e /mnt/c/srv/installed-packages/ffmpeg ] ; then
		sudo rm -R /mnt/c/srv/installed-packages/ffmpeg
	fi

	echo ""
	echo "---Downloading: $ffmpeg---"
	echo ""
	cd /mnt/c/srv/packages/
	wget -O $ffmpeg.zip $ffmpeg_path 

	echo ""
	echo "---Installing $ffmpeg---"
	echo ""
	unzip $ffmpeg.zip -d /mnt/c/srv/installed-packages/ffmpeg

fi
echo ""