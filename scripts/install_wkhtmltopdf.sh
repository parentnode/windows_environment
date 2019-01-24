#!/bin/bash -e
# Downloading and installing wkhtmltopdf
echo ""
echo "---Looking for $wkhtmltopdf---"
echo ""
if [ -e /mnt/c/srv/packages/$wkhtmltopdf.zip ] ; then
	echo ""
	echo "---$wkhtmltopdf already exist---"
	echo ""
else
	echo ""
	echo "---Removing installer for $wkhtmltopdf---"
	echo ""
	# Remove existing version
	if [ -e /mnt/c/srv/installed-packages/wkhtmltopdf ] ; then
		sudo rm -R /mnt/c/srv/installed-packages/wkhtmltopdf
	fi
	echo ""
	echo "Downloading: $wkhtmltopdf"
	echo ""
	cd /mnt/c/srv/packages/
	wget -O $wkhtmltopdf.zip $wkhtmltopdf_path 
	echo ""
	
	echo ""
	echo "---Installing $wkhtmltopdf---"
	unzip $wkhtmltopdf.zip -d /mnt/c/srv/installed-packages/wkhtmltopdf
	echo ""
fi
echo ""
