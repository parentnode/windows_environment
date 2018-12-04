# Getting imagick name and download link"
imagick="imagemagick-6-9-9-37-q16-x64-dll"
imagick_path="https://parentnode.dk/download/72/HTML-940u1z9m/imagemagick-6-9-9-37-q16-x64-dll.zip"

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