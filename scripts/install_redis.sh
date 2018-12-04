# Setting redis name and download link"
redis="redis-x64-4-0-2-2"
redis_path="https://parentnode.dk/download/72/HTML-wc8evnh2/redis-x64-4-0-2-2.zip"

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
