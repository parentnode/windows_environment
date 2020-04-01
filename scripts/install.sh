#!/bin/bash -e

source /mnt/c/srv/tools/scripts/functions.sh

enableSuperCow
## Defining paths and download urls
#
## Setting c++ compiler name and download link"
#vc_compiler="vc_redist-x64"
#export vc_compiler
##vc_compiler_path="https://parentnode.dk/download/72/HTML-ikg9m2me/vc_redist-x64.zip"
#vc_compiler_path="https://parentnode.dk/download/72/HTMLEDITOR-html-k41fmkh4/vc_redist-x64.zip"
#export vc_compiler_path
## Old file is also valid (and should not cause re-install)
#vc_compiler_alt="VC_redist.x64.exe"
#export vc_compiler_alt
## Setting mariadb name and download link"
#mariadb="mariadb-10-2-12-winx64"
#export mariadb
##mariadb_path="https://parentnode.dk/download/72/HTML-uwogdi5x/mariadb-10-2-12-winx64.zip"
#mariadb_path="https://parentnode.dk/download/72/HTMLEDITOR-html-8yadxckk/mariadb-10-2-12-winx64.zip"
#export mariadb_path
## Old file is also valid (and should not cause re-install)
#mariadb_alt="mariadb-10.2.12-winx64.msi"
#export mariadb_alt
## Setting apache name and download link"
#apache="apachehttpd-2-4-33-win64-vc15"
#export apache
##apache_path="https://parentnode.dk/download/72/HTML-i59ty49r/apachehttpd-2-4-33-win64-vc15.zip"
#apache_path="https://parentnode.dk/download/72/HTMLEDITOR-html-476aartg/apachehttpd-2-4-33-win64-vc15.zip"
#export apache_path
## Setting php name and download link"
#php="php-7-2-2-win32-vc15-x64-redis-4"
#export php
##php_path="https://parentnode.dk/download/72/HTML-aqwla8g3/php-7-2-2-win32-vc15-x64-redis-4.zip"
#php_path="https://parentnode.dk/download/72/HTMLEDITOR-html-qxzr9nzg/php-7-2-2-win32-vc15-x64-redis-4.zip"
#export php_path
## Getting imagick name and download link"
#imagick="imagemagick-6-9-9-37-q16-x64-dll"
#export imagick
##imagick_path="https://parentnode.dk/download/72/HTML-940u1z9m/imagemagick-6-9-9-37-q16-x64-dll.zip"
#imagick_path="https://parentnode.dk/download/72/HTMLEDITOR-html-j4spicwi/imagemagick-6-9-9-37-q16-x64-dll.zip"
#export imagick_path
## Setting redis name and download link"
#redis="redis-x64-4-0-2-2"
#export redis
##redis_path="https://parentnode.dk/download/72/HTML-wc8evnh2/redis-x64-4-0-2-2.zip"
#redis_path="https://parentnode.dk/download/72/HTMLEDITOR-html-7up44f85/redis-x64-4-0-2-2.zip"
#export redis_path
## Setting ffmpeg name and download link"
#ffmpeg="ffmpeg-20180129-d4967c0-win64"
#export ffmpeg
##ffmpeg_path="https://parentnode.dk/download/72/HTML-knnkg3yn/ffmpeg-20180129-d4967c0-win64.zip"
#ffmpeg_path="https://parentnode.dk/download/72/HTMLEDITOR-html-f8ocphuu/ffmpeg-20180129-d4967c0-win64.zip"
#export ffmpeg_path
## Setting wkhtml name and download link"
#wkhtmltopdf="wkhtmltopdf-static-0-12-3"
#export wkhtmltopdf
##wkhtmltopdf_path="https://parentnode.dk/download/72/HTML-g2y0tm22/wkhtmltopdf-static-0-12-3.zip"
#wkhtmltopdf_path="https://parentnode.dk/download/72/HTMLEDITOR-html-bnyx276m/wkhtmltopdf-static-0-12-3.zip"
#export wkhtmltopdf_path


echo "--------------------------------------------------------------"
echo ""
echo "Installing parentNode in windows subsystem for linux"
echo "DO NOT CLOSE UNTIL INSTALL ARE COMPLETE" 
echo "You will see 'Install complete' message once it's done"
echo ""
echo ""



#echo ""
#echo ""
#echo "--- Confirming Windows environment ---"
#echo ""
#echo ""
#
## Check if windows environment
#if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
#    echo "Windows 10 Bash: OK"
#	echo ""
#else
#
#    echo "ERROR: Linux Bash for Windows does not exist"
#    echo "Install Linux Bash for Windows and try again"
#    exit 1
#
#fi
#
## tar command available
## TODO: This finds the tar command in bash - we need to check if it exists in CMD
#if grep -qE "^bsdtar" tar --version &> /dev/null ; then
#    echo "System is updated"
#	echo ""
#else
#
#    echo "ERROR: Windows has not been fully updated"
#    echo "Update Windows and try again"
#    exit 1
#
#fi
#
#
#
#echo ""
#echo "-------------------------------------------------------"
#echo "Please enter the information required for your install:"
#echo "-------------------------------------------------------"
#echo ""
#
## Setting up git user and email
#read -p "Your git username: " git_user
#export git_user
#echo ""
#
#read -p "Your git email address: " git_email
#export git_email
#echo ""
#
#
## MariaDB not installed, ask for new root password
#if [ ! -e /mnt/c/srv/packages/$mariadb.zip ] && [ ! -e /mnt/c/srv/packages/$mariadb_alt]; then
#	read -s -p "Enter new root DB password: " db_root_password
#	export db_root_password
#	echo ""
#fi
#
#
## SETTING DEFAULT GIT USER
#echo "-----------------------------------------"
#echo "--- Setting up Git user configuration ---"
#echo "-----------------------------------------"
#echo ""
#git config --global core.filemode false
#git config --global user.name "$git_user"
#git config --global user.email "$git_email"
#git config --global credential.helper cache
#git config --global push.default simple
#git config --global core.autocrlf true
#
#
## Setting up bash config
#echo ""
#echo "Copying .profile to /home/$SUDO_USER"
#sudo cp "/mnt/c/srv/tools/conf/dot_profile" "/home/$SUDO_USER/.profile"
#sudo chown "$SUDO_USER:$SUDO_USER" "/home/$SUDO_USER/.profile"
#echo ""

. /mnt/c/srv/tools/scripts/pre_install_check.sh
#echo ""
#echo "----------------------------"
#echo "--- Checking Directories ---"
#echo "----------------------------"
#echo ""
. /mnt/c/srv/tools/scripts/checking_directories.sh
#
## Base parentnode project location
#if [ -e /mnt/c/srv/sites/parentnode ] ; then
#	echo "C:/srv/sites/parentnode already exists"
#else
#	echo "Create directory C:/srv/sites/parentnode"
#    mkdir -p /mnt/c/srv/sites/parentnode;
#fi;
#
## Base apache configuration location
#if [ -e /mnt/c/srv/sites/apache/logs ] ; then
#	echo "C:/srv/sites/apache/logs already exists"
#else
#	echo "Create directory C:/srv/sites/apache/logs"
#    mkdir -p /mnt/c/srv/sites/apache/logs;
#fi;
#
## Creating packages folder
#if [ -e /mnt/c/srv/packages ] ; then
#	echo "C:/srv/packages already exists"
#else
#	echo "Create directory C:/srv/packages"
#    mkdir -p /mnt/c/srv/packages;
#fi;
#
## Creating installed-packages folder
#if [ -e /mnt/c/srv/installed-packages ] ; then
#	echo "C:/srv/installed-packages already exists"
#else
#	echo "Create directory C:/srv/installed-packages"
#    mkdir -p /mnt/c/srv/installed-packages;
#fi;
#echo ""
#

# Check if Apache is installed
#apache_service_installed=$(/mnt/c/Windows/System32/sc.exe queryex type= service state= all | grep -E "Apache" || echo "")
#
## Check if Apache is running
#apache_service_running=$(/mnt/c/Windows/System32/net.exe start | grep -E "Apache" || echo "")
## Apache is running (possibly other version)
#if [ ! -z "$apache_service_running" ]; then
#	echo ""
#	echo "Apache is running. Stopping Apache to continue."
#	# Stop Apache before continuing
#	sudo /mnt/c/Windows/System32/net.exe stop Apache2.4
#	echo ""
#
#fi



echo ""
echo "--- Installing software ---"
echo ""

#
## Install unzip to unpack downloaded packages
#echo "Checking unzip:"
#install_unzip=$(unzip || echo "")
#if [ "$install_unzip" = "" ]; then
#	sudo apt-get --assume-yes install unzip
#else
#	echo "unzip is installed"
#fi
#
#
## Clean up
#echo ""
#echo "Cleaning up:"
#sudo apt-get --assume-yes autoremove
#echo ""
#
#
## Prepare for download
#wget --spider --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --save-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" https://parentnode.dk
#
## Custom parameters for wget download from parentNode website
#wget_params='--user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies cookies.txt --header="Referer: https://parentnode.dk"'
#
#
## Downloading and installing c++ compiler
#echo "Looking for $vc_compiler"
#if [ -e /mnt/c/srv/packages/$vc_compiler.zip ] || [ -e /mnt/c/srv/packages/$vc_compiler_alt ]; then
#	echo "$vc_compiler already exists"
#else
#
#	echo "Downloading $vc_compiler"
#	cd /mnt/c/srv/packages/
#	wget -O $vc_compiler.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $vc_compiler_path
#
#	# Unpack zip
#	unzip $vc_compiler.zip -d /mnt/c/srv/packages/
#
#	echo ""
#	echo "Installing $vc_compiler"
#	/mnt/c/srv/packages/$vc_compiler.exe /passive /norestart
#
#	# Remove installer
#	rm /mnt/c/srv/packages/$vc_compiler.exe
#
#fi
#echo ""
#
#
## Downloading and installing mariadb
#echo "Looking for $mariadb"
#if [ -e /mnt/c/srv/packages/$mariadb.zip ] || [ -e /mnt/c/srv/packages/$mariadb_alt ] ; then
#	echo "$mariadb already exists"
#else
#
#	echo "Downloading: $mariadb"
#	cd /mnt/c/srv/packages/
#	wget -O $mariadb.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $mariadb_path
#
#	# Unpack zip
#	unzip $mariadb.zip -d /mnt/c/srv/packages/
#
#	echo ""
#	echo "Installing $mariadb"
#	# Install MariaDB with password and servicename
#	sudo /mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\\srv\\packages\\$mariadb.msi" PASSWORD="$db_root_password" SERVICENAME="MariaDB" /qn
#
#	# Remove installer
#	rm /mnt/c/srv/packages/$mariadb.msi
#
#fi
#echo ""
#
#
## Downloading and installing Apache
#echo "Looking for $apache"
#if [ -e /mnt/c/srv/packages/$apache.zip ] ; then
#	echo "$apache already exists"
#else
#
#	# Uninstall existing service
#	if [ ! -z "$apache_service_installed" ]; then
#
#		echo "APACHE IS RUNNING"
#
#		# Old path
#		if [ -e /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe ] ; then
#			echo "OLD PATH"
#			sudo /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe -k uninstall
#		# New path
#		else
#			echo "NEW PATH"
#			sudo /mnt/c/srv/installed-packages/apache24/bin/httpd.exe -k uninstall
#		fi
#
#	fi
#
#	# Remove existing version
#	if [ -e /mnt/c/srv/installed-packages/apache24 ] ; then
#		sudo rm -R /mnt/c/srv/installed-packages/apache24
#	fi
#
#
#	echo "Downloading: $apache"
#	cd /mnt/c/srv/packages/
#	wget -O $apache.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $apache_path
#
#	echo ""
#	echo "Installing $apache"
#	# Unpack zip to install location
#	unzip $apache.zip -d /mnt/c/srv/installed-packages/apache24
#
#	# Copy default apache config, before installing service to avoid error
#	cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
#
#	# Install service
#	sudo /mnt/c/srv/installed-packages/apache24/bin/httpd.exe -k install
#
#fi
#echo ""
#
#
## Downloading and installing php
#echo "Looking for $php"
#if [ -e /mnt/c/srv/packages/$php.zip ] ; then
#	echo "$php already exists"
#else
#
#	# Remove existing version
#	if [ -e /mnt/c/srv/installed-packages/php722 ] ; then
#		sudo rm -R /mnt/c/srv/installed-packages/php722
#	fi
#
#	echo "Downloading $php"
#    cd /mnt/c/srv/packages
#	wget -O $php.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $php_path 
#
#	echo ""
#	echo "Installing $php"
#	# Unpack zip to install location
#	unzip $php.zip -d /mnt/c/srv/installed-packages/php722
#
#fi
#echo ""
#
#
## Downloading and installing Imagick
#echo "Looking for $imagick"
#if [ -e /mnt/c/srv/packages/$imagick.zip ] ; then
#	echo "$imagick already exist"
#else
#
#	echo "Downloading: $imagick"
#	cd /mnt/c/srv/packages/
#	wget -O $imagick.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $imagick_path
#
#
#	# Unpack zip
#	unzip $imagick.zip -d /mnt/c/srv/packages/
#
#	echo ""
#	echo "Installing $imagick"
#	/mnt/c/srv/packages/$imagick.exe /NOICONS /SILENT
#
#	# Remove installer
#	rm /mnt/c/srv/packages/$imagick.exe
#
#fi
#echo ""
#
#
## Downloading and installing Imagick
#echo "Looking for $redis"
#if [ -e /mnt/c/srv/packages/$redis.zip ] ; then
#	echo "$redis already exist"
#else
#
#	echo "Downloading: $redis"
#	cd /mnt/c/srv/packages/
#	wget -O $redis.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $redis_path
#
#
#	# Unpack zip
#	unzip $redis.zip -d /mnt/c/srv/packages/
#
#	echo ""
#	echo "Installing $redis"
#	sudo /mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\\srv\\packages\\$redis.msi" ADD_FIREWALL_RULE=1 /qn
#
#	# Remove installer
#	rm /mnt/c/srv/packages/$redis.msi
#
#fi
#echo ""
#
#
## Downloading and installing ffmpeg
#echo "Looking for $ffmpeg"
#if [ -e /mnt/c/srv/packages/$ffmpeg.zip ] ; then
#	echo "$ffmpeg already exist"
#else
#
#	# Remove existing version
#	if [ -e /mnt/c/srv/installed-packages/ffmpeg ] ; then
#		sudo rm -R /mnt/c/srv/installed-packages/ffmpeg
#	fi
#
#	echo "Downloading: $ffmpeg"
#	cd /mnt/c/srv/packages/
#	wget -O $ffmpeg.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $ffmpeg_path 
#
#	echo ""
#	echo "Installing $ffmpeg"
#	unzip $ffmpeg.zip -d /mnt/c/srv/installed-packages/ffmpeg
#
#fi
#echo ""
#
#
## Downloading and installing wkhtmltopdf
#echo "Looking for $wkhtmltopdf"
#if [ -e /mnt/c/srv/packages/$wkhtmltopdf.zip ] ; then
#	echo "$wkhtmltopdf already exist"
#else
#
#	# Remove existing version
#	if [ -e /mnt/c/srv/installed-packages/wkhtmltopdf ] ; then
#		sudo rm -R /mnt/c/srv/installed-packages/wkhtmltopdf
#	fi
#
#	echo "Downloading: $wkhtmltopdf"
#	cd /mnt/c/srv/packages/
#	wget -O $wkhtmltopdf.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $wkhtmltopdf_path 
#
#	echo ""
#	echo "Installing $wkhtmltopdf"
#	unzip $wkhtmltopdf.zip -d /mnt/c/srv/installed-packages/wkhtmltopdf
#
#fi
#echo ""
#
#
#

. /mnt/c/srv/tools/scripts/install_software.sh

. /mnt/c/srv/tools/scripts/post_install_setup.sh
#echo "-----------------------------------------"
#echo "--- Configuring Apache server and PHP ---"
#echo "-----------------------------------------"
#
#echo ""
#echo "----------------------------------------------"
#echo "Setting up php.ini and required files for CURL"
#echo "----------------------------------------------"
#echo ""
## Setting up php.ini
#echo "Copying php.ini to php722/php.ini"
#cp "/mnt/c/srv/tools/conf/php.ini" "/mnt/c/srv/installed-packages/php722/php.ini"
#echo ""
#
#
## Setting up php.ini (and required files for CURL)
#echo "Copying libeay32.dll and ssleay32.dll to apache24/bin"
#cp "/mnt/c/srv/installed-packages/php722/libeay32.dll" "/mnt/c/srv/installed-packages/apache24/bin/libeay32.dll"
#cp "/mnt/c/srv/installed-packages/php722/ssleay32.dll" "/mnt/c/srv/installed-packages/apache24/bin/ssleay32.dll"
#echo ""
#
#echo "-----------------------------"
#echo "--- Setting up httpd.conf ---"
#echo "-----------------------------"
#
## Setting up httpd.conf
#echo "Copying httpd config file to apache24/conf"
#cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
#echo ""
#
#echo "-----------------------"
#echo "--- Adding SSL cert ---"
#echo "-----------------------"
#
## Adding SSL cert
#echo "Copying cacert.pem to installed-packages"
#cp "/mnt/c/srv/tools/conf/cacert.pem" "/mnt/c/srv/installed-packages/cacert.pem"
#echo ""


# Setting up apache.conf (only once)
#if [ ! -f "/mnt/c/srv/sites/apache/apache.conf" ]; then
#
#	echo "Adding apache config file to sites/apache/"
#	echo ""
#	cp "/mnt/c/srv/tools/conf/apache.conf" "/mnt/c/srv/sites/apache/apache.conf"
#
#fi



echo ""
echo "Starting apache server"
sudo /mnt/c/Windows/System32/net.exe start Apache2.4 exit 2>/dev/null || echo ""



echo ""
echo "parentNode installed in windows subsystem for linux "
echo ""
echo "Install complete"
echo "--------------------------------------------------------------"
echo ""




