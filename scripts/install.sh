#!/bin/bash -e


# Defining paths and download urls

# Setting c++ compiler name and download link"
vc_compiler="vc_redist-x64"
vc_compiler_path="https://parentnode.dk/download/72/HTML-ikg9m2me/vc_redist-x64.zip"
# Old file is also valid (and should not cause re-install)
vc_compiler_alt="VC_redist.x64.exe"

# Setting mariadb name and download link"
mariadb="mariadb-10-2-12-winx64"
mariadb_path="https://parentnode.dk/download/72/HTML-uwogdi5x/mariadb-10-2-12-winx64.zip"
# Old file is also valid (and should not cause re-install)
mariadb_alt="mariadb-10.2.12-winx64.msi"

# Setting apache name and download link"
apache="apachehttpd-2-4-33-win64-vc15"
apache_path="https://parentnode.dk/download/72/HTML-i59ty49r/apachehttpd-2-4-33-win64-vc15.zip"

# Setting php name and download link"
php="php-7-2-2-win32-vc15-x64-redis-4"
php_path="https://parentnode.dk/download/72/HTML-aqwla8g3/php-7-2-2-win32-vc15-x64-redis-4.zip"

# Getting imagick name and download link"
imagick="imagemagick-6-9-9-37-q16-x64-dll"
imagick_path="https://parentnode.dk/download/72/HTML-940u1z9m/imagemagick-6-9-9-37-q16-x64-dll.zip"

# Setting redis name and download link"
redis="redis-x64-4-0-2-2"
redis_path="https://parentnode.dk/download/72/HTML-wc8evnh2/redis-x64-4-0-2-2.zip"

# Setting ffmpeg name and download link"
ffmpeg="ffmpeg-20180129-d4967c0-win64"
ffmpeg_path="https://parentnode.dk/download/72/HTML-knnkg3yn/ffmpeg-20180129-d4967c0-win64.zip"

# Setting wkhtml name and download link"
wkhtmltopdf="wkhtmltopdf-static-0-12-3"
wkhtmltopdf_path="https://parentnode.dk/download/72/HTML-g2y0tm22/wkhtmltopdf-static-0-12-3.zip"



echo "--------------------------------------------------------------"
echo ""
echo "                 Starting server installation"
echo "           DO NOT CLOSE UNTILL INSTALL IS COMPLETE" 
echo  "You will see 'Server install complete' message once it's done"


# tar command available
# TODO: This finds Out whether Curl or Tar is present 

# Root path for curl and tar 
curl_tar_path="/mnt/c/Windows/System32"

# Testing if the file exists and if the version number is above 7.5
curlversion=$(($curl_tar_path/curl.exe -V) 2>/dev/null | grep -E "^curl (7\.[5-9]+|[8-9]\.[0-9]+)" || echo "")

# Testing if the file exists and if the version number is above 3.3
tarversion=$(($curl_tar_path/tar.exe --help) 2>/dev/null | grep -E "^bsdtar (3\.[3-9]+|[4-9]\.[0-9]+)" || echo "")

# Testing if either conditions for tar or curl are met then you can proceed 
if [ -z "$curlversion" ] || [ -z "$tarversion" ];then
	echo "You seem to be missing curl or tar or running an older version of curl or tar"
	echo "### Please Check you have all available updates ###"
	exit
else
	echo "curl and tar are up to date you are all set"
fi

echo ""
echo ""
echo "Please enter the information required for your install:"
echo ""

# Setting up git user and email
read -p "Your git username: " git_user
export git_user
echo ""

read -p "Your git email address: " git_email
export git_email
echo ""

echo "MariaDB Password section"
# MariaDB not installed, ask for new root password
if [ ! -e /mnt/c/srv/packages/$mariadb.zip ] && [ ! -e /mnt/c/srv/packages/$mariadb_alt ]; then
	while [ true ]
	do
    	read -s -p "Enter new root DB password: " db_root_password
    	echo ""
    	read -s -p "Verify new root DB password: " db_root_password2    
    	if [ $db_root_password != $db_root_password2 ]; then
    		echo ""
    		echo "Not same"
    	else 
    		echo ""
    		echo "Same"
    		export $db_root_password
    		break
    	fi	
	done
fi
username=$( echo $SUDO_USER)

# SETTING DEFAULT GIT USER
echo ""
echo "--- Setting up default user configuration ---"
echo ""

echo ""
echo "Setting Git variables"
git config --global core.filemode false
git config --global user.name "$git_user"
git config --global user.email "$git_email"
git config --global credential.helper cache
git config --global push.default simple
git config --global core.autocrlf true

sudo chown "$username:$username" "/home/$username/.profile"
echo "Changed owner"
ls -Fla
check_for_existing_parentnode_dot_profile=$( grep -R "# ADMIN CHECK" "$HOME/.profile" )
check_for_existing_alias=$( grep -R "alias" "$HOME/.profile" )
echo "Keys Checked"
if [ -z "$check_for_existing_alias" ] && [ -z $"check_for_existing_parentnode_dot_profile" ];
then
	# Setting up bash config
	echo ""
	echo "Copying .profile to /home/$username"
	sudo cp "/mnt/c/srv/tools/conf/dot_profile" "/home/$username/.profile"
	sudo chown "$username:$username" "/home/$username/.profile"
	echo ""
else
	echo "Update my alias here"
fi


echo ""
echo "--- Checking Directories ---"
echo ""

# Base parentnode project location
if [ -e /mnt/c/srv/sites/parentnode ] ; then
	echo "C:/srv/sites/parentnode already exists"
else
	echo "Create directory C:/srv/sites/parentnode"
    mkdir -p /mnt/c/srv/sites/parentnode;
fi;

# Base apache configuration location
if [ -e /mnt/c/srv/sites/apache/logs ] ; then
	echo "C:/srv/sites/apache/logs already exists"
else
	echo "Create directory C:/srv/sites/apache/logs"
    mkdir -p /mnt/c/srv/sites/apache/logs;
fi;

# Creating packages folder
if [ -e /mnt/c/srv/packages ] ; then
	echo "C:/srv/packages already exists"
else
	echo "Create directory C:/srv/packages"
    mkdir -p /mnt/c/srv/packages;
fi;

# Creating installed-packages folder
if [ -e /mnt/c/srv/installed-packages ] ; then
	echo "C:/srv/installed-packages already exists"
else
	echo "Create directory C:/srv/installed-packages"
    mkdir -p /mnt/c/srv/installed-packages;
fi;
echo ""


# Check if Apache is installed
apache_service_installed=$(/mnt/c/Windows/System32/sc.exe queryex type= service state= all | grep -E "Apache" || echo "")

# Check if Apache is running
apache_service_running=$(/mnt/c/Windows/System32/net.exe start | grep -E "Apache" || echo "")
# Apache is running (possibly other version)
if [ ! -z "$apache_service_running" ]; then

	echo ""
	echo "Apache is running. Stopping Apache to continue."
	# Stop Apache before continuing
	sudo /mnt/c/Windows/System32/net.exe stop Apache2.4
	echo ""

fi



echo ""
echo "--- Installing software ---"
echo ""


# Install unzip to unpack downloaded packages
echo "Checking unzip:"
install_unzip=$(unzip || echo "")
if [ "$install_unzip" = "" ]; then
	sudo apt-get --assume-yes install unzip
else
	echo "unzip is installed"
fi


# Clean up
echo ""
echo "Cleaning up:"
sudo apt-get --assume-yes autoremove
echo ""



# Downloading and installing c++ compiler
echo "Looking for $vc_compiler"
if [ -e /mnt/c/srv/packages/$vc_compiler.zip ] || [ -e /mnt/c/srv/packages/$vc_compiler_alt ]; then
	echo "$vc_compiler already exists"
else

	echo "Downloading $vc_compiler"
	cd /mnt/c/srv/packages/
	wget -O $vc_compiler.zip $vc_compiler_path

	# Unpack zip
	unzip $vc_compiler.zip -d /mnt/c/srv/packages/

	echo ""
	echo "Installing $vc_compiler"
	/mnt/c/srv/packages/$vc_compiler.exe /passive /norestart

	# Remove installer
	rm /mnt/c/srv/packages/$vc_compiler.exe

fi
echo ""


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


# Downloading and installing php
echo "Looking for $php"
if [ -e /mnt/c/srv/packages/$php.zip ] ; then
	echo "$php already exists"
else

	# Remove existing version
	if [ -e /mnt/c/srv/installed-packages/php722 ] ; then
		sudo rm -R /mnt/c/srv/installed-packages/php722
	fi

	echo "Downloading $php"
    cd /mnt/c/srv/packages
	wget -O $php.zip $php_path 

	echo ""
	echo "Installing $php"
	# Unpack zip to install location
	unzip $php.zip -d /mnt/c/srv/installed-packages/php722

fi
echo ""


# Downloading and installing Imagick
echo "Looking for $imagick"
if [ -e /mnt/c/srv/packages/$imagick.zip ] ; then
	echo "$imagick already exist"
else

	echo "Downloading: $imagick"
	cd /mnt/c/srv/packages/
	wget -O $imagick.zip $imagick_path


	# Unpack zip
	unzip $imagick.zip -d /mnt/c/srv/packages/

	echo ""
	echo "Installing $imagick"
	/mnt/c/srv/packages/$imagick.exe /NOICONS /SILENT

	# Remove installer
	rm /mnt/c/srv/packages/$imagick.exe

fi
echo ""


# Downloading and installing Imagick
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


# Downloading and installing ffmpeg
echo "Looking for $ffmpeg"
if [ -e /mnt/c/srv/packages/$ffmpeg.zip ] ; then
	echo "$ffmpeg already exist"
else

	# Remove existing version
	if [ -e /mnt/c/srv/installed-packages/ffmpeg ] ; then
		sudo rm -R /mnt/c/srv/installed-packages/ffmpeg
	fi

	echo "Downloading: $ffmpeg"
	cd /mnt/c/srv/packages/
	wget -O $ffmpeg.zip $ffmpeg_path 

	echo ""
	echo "Installing $ffmpeg"
	unzip $ffmpeg.zip -d /mnt/c/srv/installed-packages/ffmpeg

fi
echo ""


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


echo ""
echo "--- Configuring Apache server and PHP ---"
echo ""


# Setting up php.ini
echo "Copying php.ini to php722/php.ini"
cp "/mnt/c/srv/tools/conf/php.ini" "/mnt/c/srv/installed-packages/php722/php.ini"
echo ""


# Setting up php.ini (and required files for CURL)
echo "Copying libeay32.dll and ssleay32.dll to apache24/bin"
cp "/mnt/c/srv/installed-packages/php722/libeay32.dll" "/mnt/c/srv/installed-packages/apache24/bin/libeay32.dll"
cp "/mnt/c/srv/installed-packages/php722/ssleay32.dll" "/mnt/c/srv/installed-packages/apache24/bin/ssleay32.dll"
echo ""


# Setting up httpd.conf
echo "Copying httpd config file to apache24/conf"
cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
echo ""


# Adding SSL cert
echo "Copying cacert.pem to installed-packages"
cp "/mnt/c/srv/tools/conf/cacert.pem" "/mnt/c/srv/installed-packages/cacert.pem"
echo ""


# Setting up apache.conf (only once)
if [ ! -f "/mnt/c/srv/sites/apache/apache.conf" ]; then

	echo "Adding apache config file to sites/apache/"
	echo ""
	cp "/mnt/c/srv/tools/conf/apache.conf" "/mnt/c/srv/sites/apache/apache.conf"

fi



echo ""
echo "Starting apache server"
sudo /mnt/c/Windows/System32/net.exe start Apache2.4 exit 2>/dev/null || echo ""



echo ""
echo "        Server install complete "
echo "---------------------------------------------"
echo ""




