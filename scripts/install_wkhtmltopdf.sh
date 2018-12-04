wkhtmltopdf="wkhtmltopdf-static-0-12-3"
wkhtmltopdf_path="https://parentnode.dk/download/72/HTML-g2y0tm22/wkhtmltopdf-static-0-12-3.zip"

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
