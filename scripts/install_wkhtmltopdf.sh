#!/bin/bash -e
# Downloading and installing wkhtmltopdf
echo "Looking for $wkhtmltopdf"
if [ -e /mnt/c/srv/packages/$wkhtmltopdf.zip ] ; then
	echo "$wkhtmltopdf already exist"
else

	# Remove existing version
	if [ -e /mnt/c/srv/installed-packages/wkhtmltopdf ] ; then
		sudo rm -R /mnt/c/srv/installed-packages/wkhtmltopdf
	fi

	echo "Downloading: $wkhtmltopdf"
	cd /mnt/c/srv/packages/
	wget -O $wkhtmltopdf.zip $wkhtmltopdf_path 

	echo ""
	echo "Installing $wkhtmltopdf"
	unzip $wkhtmltopdf.zip -d /mnt/c/srv/installed-packages/wkhtmltopdf

fi
echo ""
