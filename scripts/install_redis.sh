#!/bin/bash -e
# Downloading and installing redis
echo "------------------------"
echo "---Looking for $redis---"
echo "------------------------"
if [ -e /mnt/c/srv/packages/$redis.zip ] ; then
	echo "--------------------------"
	echo "---$redis already exist---"
	echo "--------------------------"
else
	echo "-------------------------"
	echo "---Downloading: $redis---"
	echo "-------------------------"
	echo ""
	cd /mnt/c/srv/packages/
	wget -O $redis.zip $redis_path
	echo ""

	echo "-----------------------"
	echo "---Installing $redis---"
	echo "-----------------------"
	echo ""
	# Unpack zip
	unzip $redis.zip -d /mnt/c/srv/packages/
	echo ""
	
	sudo /mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\\srv\\packages\\$redis.msi" ADD_FIREWALL_RULE=1 /qn
	echo "--------------------------------------------"
	echo "---Removing installation files for $redis---"
	echo "--------------------------------------------"
	echo ""
	# Remove installer
	rm /mnt/c/srv/packages/$redis.msi
	echo ""
fi
echo ""
