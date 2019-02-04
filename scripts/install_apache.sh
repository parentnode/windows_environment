#!/bin/bash -e
# Check if Apache is installed

# Downloading and installing Apache
echo "-------------------------"
echo "---Looking for $apache---"
echo "-------------------------"
echo ""
apache_service_installed=$(/mnt/c/Windows/System32/sc.exe queryex type= service state= all | grep -E "Apache" || echo "")

if [ -e /mnt/c/srv/packages/$apache.zip ] ; then
	echo "----------------------"
	echo "$apache already exists"
	echo "----------------------"
	echo ""
else

	# Uninstall existing service
	if [ ! -z "$apache_service_installed" ]; then
		echo "-----------------------"
		echo "---APACHE IS RUNNING---"
		echo "-----------------------"
		echo ""
		# Old path
		if [ -e /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe ] ; then
			echo "--------------"
			echo "---OLD PATH---"
			echo "--------------"
			echo ""
			sudo /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe -k uninstall
			echo ""
		# New path
		else
			echo "--------------"
			echo "---NEW PATH---"
			echo "--------------"
			echo ""
			sudo /mnt/c/srv/installed-packages/apache24/bin/httpd.exe -k uninstall
			echo ""
		fi

	fi
	echo "----------------------------------------------"
	echo "---Removing installation files for  $apache---"
	echo "----------------------------------------------"
	echo ""
	# Remove existing version
	if [ -e /mnt/c/srv/installed-packages/apache24 ] ; then
		sudo rm -R /mnt/c/srv/installed-packages/apache24
	fi
	echo ""
	
	echo "--------------------------"
	echo "---Downloading: $apache---"
	echo "--------------------------"
	echo ""
	cd /mnt/c/srv/packages/
	wget -O $apache.zip $apache_path
	echo ""
	
	echo "------------------------"
	echo "---Installing $apache---"
	echo "------------------------"
	echo ""
	# Unpack zip to install location
	unzip $apache.zip -d /mnt/c/srv/installed-packages/apache24
	echo ""
	# Copy default apache config, before installing service to avoid error
	cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
	sudo /mnt/c/srv/installed-packages/apache24/bin/httpd.exe -k install 
	echo ""
fi
echo ""
echo "---apache installed---"
echo ""

