#!/bin/bash -e
# Setting php name and download link"
php="php-7-2-2-win32-vc15-x64-redis-4"
php_path="https://parentnode.dk/download/72/HTML-aqwla8g3/php-7-2-2-win32-vc15-x64-redis-4.zip"

# Downloading and installing php
echo ""
echo "Looking for $php"
echo ""

if [ -e /mnt/c/srv/packages/$php.zip ] ; then
	echo "$php already exists"
else

	# Remove existing version
	if [ -e /mnt/c/srv/installed-packages/php722 ] ; then
		sudo rm -R /mnt/c/srv/installed-packages/php722
	fi

	echo "Downloading $php"
    cd /mnt/c/srv/packages
	wget -O $php.zip $php_path 

	echo ""
	echo "Installing $php"
	# Unpack zip to install location
	unzip $php.zip -d /mnt/c/srv/installed-packages/php722

fi
echo ""