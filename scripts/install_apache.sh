# Downloading and installing Apache
echo "Looking for $apache"
if [ -e /mnt/c/srv/packages/$apache.zip ] ; then
	echo "$apache already exists"
else

	# Uninstall existing service
	if [ ! -z "$apache_service_installed" ]; then

		echo "APACHE IS RUNNING"

		# Old path
		if [ -e /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe ] ; then
			echo "OLD PATH"
			sudo /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe -k uninstall
		# New path
		else
			echo "NEW PATH"
			sudo /mnt/c/srv/installed-packages/apache24/bin/httpd.exe -k uninstall
		fi

	fi

	# Remove existing version
	if [ -e /mnt/c/srv/installed-packages/apache24 ] ; then
		sudo rm -R /mnt/c/srv/installed-packages/apache24
	fi


	echo "Downloading: $apache"
	cd /mnt/c/srv/packages/
	wget -O $apache.zip $apache_path

	echo ""
	echo "Installing $apache"
	# Unpack zip to install location
	unzip $apache.zip -d /mnt/c/srv/installed-packages/apache24
	
	# Copy default apache config, before installing service to avoid error
	cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
	# Install service
	sudo /mnt/c/srv/installed-packages/apache24/bin/httpd.exe -k install

fi
echo ""