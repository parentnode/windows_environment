#!/bin/bash -e
# Setting mariadb name and download link"
mariadb="mariadb-10-2-12-winx64"
mariadb_path="https://parentnode.dk/download/72/HTML-uwogdi5x/mariadb-10-2-12-winx64.zip"
# Old file is also valid (and should not cause re-install)
mariadb_alt="mariadb-10.2.12-winx64.msi"

# Downloading and installing mariadb
echo "Looking for $mariadb"
if [ -e /mnt/c/srv/packages/$mariadb.zip ] || [ -e /mnt/c/srv/packages/$mariadb_alt ] ; then
	echo "$mariadb already exists"
else

	echo "Downloading: $mariadb"
	cd /mnt/c/srv/packages/
	wget -O $mariadb.zip $mariadb_path

	# Unpack zip
	unzip $mariadb.zip -d /mnt/c/srv/packages/

	echo ""
	echo "Installing $mariadb"
	# Install MariaDB with password and servicename
	#echo "Dette er mariadb password $db_root_password"
	sudo /mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\\srv\\packages\\$mariadb.msi" PASSWORD="$db_root_password" SERVICENAME="MariaDB" /qn

	# Remove installer
	rm /mnt/c/srv/packages/$mariadb.msi

fi
echo ""
