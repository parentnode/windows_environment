#!/bin/bash -e


# Defining paths and download urls

# Setting c++ compiler name and download link"
vc_compiler="vc_redist-x64"
vc_compiler_path="https://parentnode.dk/download/72/HTML-ikg9m2me/vc_redist-x64.zip"

# Setting mariadb name and download link"
mariadb="mariadb-10-2-12-winx64"
mariadb_path="https://parentnode.dk/download/72/HTML-uwogdi5x/mariadb-10-2-12-winx64.zip"

# Setting apache name and download link"
apache="apachehttpd-2-4-33-win64-vc15"
apache_path="https://parentnode.dk/download/72/HTML-i59ty49r/apachehttpd-2-4-33-win64-vc15.zip"

# Setting php name and download link"
php="php-7-2-2-win32-vc15-x64"
php_path="https://parentnode.dk/download/72/HTML-i58uiisu/php-7-2-2-win32-vc15-x64.zip"


# Getting imagick name and download link"
imagick="imagemagick-6-9-9-37-q16-x64-dll"
imagick_path="https://parentnode.dk/download/72/HTML-940u1z9m/imagemagick-6-9-9-37-q16-x64-dll.zip"

# Setting ffmpeg name and download link"
ffmpeg="ffmpeg-20180129-d4967c0-win64"
ffmpeg_path="https://parentnode.dk/download/72/HTML-knnkg3yn/ffmpeg-20180129-d4967c0-win64.zip"

# Setting wkhtml name and download link"
wkhtml="ffmpeg-20180129-d4967c0-win64-static.zip"
wkhtml_path="https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-20180129-d4967c0-win64-static.zip"



echo "--------------------------------------------------------------"
echo ""
echo "                 Starting server installation"
echo "           DO NOT CLOSE UNTILL INSTALL IS COMPLETE" 
echo  "You will see 'Server install complete' message once it's done"



echo ""
echo "--- Confirming Windows environment ---"
echo ""
echo ""

# Check if windows environment
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo "Windows 10 Bash: OK"
	echo ""
else

    echo "ERROR: Linux Bash for Windows does not exist"
    echo "Install Linux Bash for Windows and try again"
    exit 1

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


# MariaDB not installed, ask for new root password
if [ ! -e /mnt/c/srv/packages/$mariadb.zip ] ; then
	read -s -p "Enter new root DB password: " db_root_password
	export db_root_password
	echo ""
fi


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


# Setting up bash config
echo ""
echo "Copying .profile to /home/$SUDO_USER"
sudo cp "/mnt/c/srv/tools/conf/dot_profile" "/home/$SUDO_USER/.profile"
sudo chown "$SUDO_USER:$SUDO_USER" "/home/$SUDO_USER/.profile"
echo ""



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


apache_service_installed=$(/mnt/c/Windows/System32/sc.exe queryex type= service state= all | grep -E "Apache" || echo "")
if [ ! -z "$apache_service_installed" ]; then

	echo ""
	echo "Apache is installed. Stopping Apache to continue."

else
	echo "Apache is not installed"
	
fi

exit


# Check if Apache is running
apache_service_running=$(/mnt/c/Windows/System32/net.exe start | grep -E "Apache" || echo "")
# Apache is running (possibly other version)
if [ ! -z "$apache_service_running" ]; then

	echo ""
	echo "Apache is running. Stopping Apache to continue."
	# Stop Apache before continuing
	sudo /mnt/c/Windows/System32/net.exe stop apache2.4
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
if [ -e /mnt/c/srv/packages/$vc_compiler.zip ] ; then
	echo "$vc_compiler already exists"
else

	echo "Downloading $vc_compiler"
	cd /mnt/c/srv/packages/
	wget -O $vc_compiler.zip $vc_compiler_path

	# Unpack zip
	unzip $vc_compiler.zip -d /mnt/c/srv/packages/

	echo ""
	echo "Installing $vc_compiler"
	/mnt/c/srv/packages/$vc_compiler.exe /passive

	# Remove installer
	rm /mnt/c/srv/packages/$vc_compiler.exe

fi
echo ""


# Downloading and installing mariadb
echo "Looking for $mariadb"
if [ -e /mnt/c/srv/packages/$mariadb.zip ] ; then
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
	if [ ! -z "$apache_service_running" ]; then

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


# Downloading and installing Imagick
echo "Looking for Imagick"
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


# Setting up vhosts
echo "Copying vhosts.conf to apache24/conf/extra"
cp "/mnt/c/srv/tools/conf/httpd-vhosts.conf" "/mnt/c/srv/installed-packages/apache24/conf/extra/httpd-vhosts.conf"
echo ""


# Setting up httpd.conf
echo "Copying httpd config file to apache24/conf"
cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
echo ""


# Setting up apache.conf (only once)
if [ ! -f "/mnt/c/srv/sites/apache/apache.conf" ]; then

	echo "Adding apache config file to sites/apache/"
	echo ""
	cp "/mnt/c/srv/tools/conf/apache.conf" "/mnt/c/srv/sites/apache/apache.conf"

fi



echo ""
echo "Starting apache server"
sudo /mnt/c/Windows/System32/net.exe start apache2.4 exit 2>/dev/null || echo ""



echo ""
echo "        Server install complete "
echo "---------------------------------------------"
echo ""




