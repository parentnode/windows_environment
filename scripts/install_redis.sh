#!/bin/bash -e
# Downloading and installing redis
echo "Looking for $redis"
if [ -e /mnt/c/srv/packages/$redis.zip ] ; then
	echo "$redis already exist"
else

	echo "Downloading: $redis"
	cd /mnt/c/srv/packages/
	wget -O $redis.zip $redis_path


	# Unpack zip
	unzip $redis.zip -d /mnt/c/srv/packages/

	echo ""
	echo "Installing $redis"
	sudo /mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\\srv\\packages\\$redis.msi" ADD_FIREWALL_RULE=1 /qn

	# Remove installer
	rm /mnt/c/srv/packages/$redis.msi

fi
echo ""
