#!/bin/bash -e
# Downloading and installing php
echo "----------------"
echo "Looking for $php"
echo "----------------"
echo ""

if [ -e /mnt/c/srv/packages/$php.zip ] ; then
	echo "-------------------------"
	echo "---$php already exists---"
	echo "-------------------------"
	echo ""

else

	# Remove existing version
	if [ -e /mnt/c/srv/installed-packages/php722 ] ; then
		sudo rm -R /mnt/c/srv/installed-packages/php722
	fi
	echo "----------------------"
	echo "---Downloading $php---"
	echo "----------------------"
    echo ""
	
	cd /mnt/c/srv/packages
	wget -O $php.zip $php_path 
	echo ""

	echo "---------------------"
	echo "---Installing $php---"
	echo "---------------------"
	# Unpack zip to install location
	unzip $php.zip -d /mnt/c/srv/installed-packages/php722
	echo ""
fi
echo ""