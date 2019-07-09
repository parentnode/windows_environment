#!/bin/bash -e
# Downloading and installing mariadb
echo "--------------------------"
echo "---Looking for $mariadb---"
echo "--------------------------"
echo ""
if [ -e /mnt/c/srv/packages/$mariadb.zip ] || [ -e /mnt/c/srv/packages/$mariadb_alt ] ; then
	echo "-----------------------------"
	echo "---$mariadb already exists---"
	echo "-----------------------------"
	echo ""
else
	echo "---------------------------"
	echo "---Downloading: $mariadb---"
	echo "---------------------------"
	echo ""
	cd /mnt/c/srv/packages/
	wget -O $mariadb.zip $mariadb_path
	echo ""

	# Unpack zip
	unzip $mariadb.zip -d /mnt/c/srv/packages/

	echo "-------------------------"
	echo "---Installing $mariadb---"
	echo "-------------------------"
	# Install MariaDB with password and servicename
	#echo "Dette er mariadb password $db_root_password"
	sudo /mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\\srv\\packages\\$mariadb.msi" /qn ACCEPT_EULA=1 PASSWORD="$db_root_password" SERVICENAME="MariaDB"
	echo ""

	echo "----------------------------------------------"
	echo "---Removing installation files for $mariadb---"
	echo "----------------------------------------------"
	# Remove installer
	rm /mnt/c/srv/packages/$mariadb.msi
	echo ""
fi
echo ""
