#!/bin/bash -e
echo "---------------------------------------------"
#echo " ***prior running this script***"

echo ""
echo "        Starting server installation"


echo ""
echo ""

# Setting up git user and email
read -p "Your git username: " git_user
export git_user
echo ""

read -p "Your git email address: " git_email
export git_email
echo ""

# Setting up password
echo ""
echo "Please enter the information required for your install:"
echo ""

read -s -p "Enter new root DB password: " db_root_password
export db_root_password
echo ""

# SETTING DEFAULT GIT USER
echo "Setting up default Git settings"
git config --global core.filemode false
git config --global user.name "$git_user"
git config --global user.email "$git_email"
git config --global credential.helper cache
git config --global push.default simple
git config --global core.autocrlf input


# Setting up bash config
echo "Copying .profile to home dir"
# sudo cp "/mnt/c/srv/tools/_conf/dot_profile" "/home/$SUDO_USER/.profile"
sudo cp "/mnt/c/srv/tools/_conf/dot_profile" "/home/$(whoami)/.profile"
echo ""

# Defining paths and download urls
echo ""
echo "---Checking paths and download links---"
echo ""

echo "Getting c++ compiler path and download link"
echo ""
vc_compiler="VC_redist.x64.exe"
vc_compiler_path="https://aka.ms/vs/15/release/VC_redist.x64.exe"

echo "Getting php path and download link"
echo ""
php="php-7.2.2-Win32-VC15-x64.zip"
php_path="https://phpdev.toolsforresearch.com/php-7.2.2-Win32-VC15-x64.zip"

echo "Getting mariadb path and download link"
echo ""
mariadb="mariadb-10.2.12-winx64.msi"
mariadb_path="https://downloads.mariadb.org/interstitial/mariadb-10.2.12/winx64-packages/mariadb-10.2.12-winx64.msi?serve"

echo "Getting apache path and download link"
echo ""
apache="apachehttpd-2.4.29-Win64-VC15.zip"
apache_path="https://www.apachelounge.com/download/VC15/binaries/httpd-2.4.29-Win64-VC15.zip"

echo "Getting imagemagick path and download link"
echo ""
imagemagick="imagemagick.exe"
imagemagick_path="https://www.imagemagick.org/download/binaries/ImageMagick-7.0.7-22-Q16-x64-dll.exe"

echo "Getting ffmpeg path and download link"
echo ""
ffmpeg="ffmpeg.zip"
ffmpeg_path="https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-20180129-d4967c0-win64-static.zip"

echo ""
echo "---Confirming Windows enviroment---"
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
echo "---Checking Directories---"
echo ""

# Base parentnode project location
if [ -e /mnt/c/srv/sites/parentnode ] ; then
	echo "C:/srv/sites/parentnode already exist"
else
	echo "Create directory C:/srv/sites/parentnode"
    mkdir -p /mnt/c/srv/sites/parentnode;
fi;

# Base apache configuration location
if [ -e /mnt/c/srv/sites/apache/logs ] ; then
	echo "C:/srv/sites/apache/logs already exist"
else
	echo "Create directory C:/srv/sites/apache/logs"
    mkdir -p /mnt/c/srv/sites/apache/logs;
fi;

# Creating packages folder
if [ -e /mnt/c/srv/packages ] ; then
	echo "C:/srv/packages already exist"
else
	echo "Create directory C:/srv/packages"
    mkdir -p /mnt/c/srv/packages;
fi;

# Creating installed-packages folder
if [ -e /mnt/c/srv/installed-packages ] ; then
	echo "C:/srv/installed-packages already exist"
else
	echo "Create directory C:/srv/installed-packages"
    mkdir -p /mnt/c/srv/installed-packages;
fi;

# if [ -e /mnt/c/srv/packages/ffmpeg ] ; then
# 	echo "C:/srv/packages already exist"
# else
# 	echo "create directory C:/srv/packages"
#     mkdir -p /mnt/c/srv/packages/ffmpeg;
# fi;
#

echo ""
echo "---Installing software---"
echo ""

# Install unzip to unpack downloaded packages
echo "Downloading unzip"
echo "|"
sudo apt-get install unzip
echo "|"
echo "Unzip installed in WSL!"
echo ""

# DELETE
/mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\srv\packages\mariadb-10.2.12-winx64.msi" REMOVE=ALL /qn # Remember to delete
rm /mnt/c/srv/packages/mariadb-10.2.12-winx64.msi
# DELETE

# Downloading and installing mariadb
echo "Looking for mariaDB"
if [ -e /mnt/c/srv/packages/$mariadb ] ; then
	echo "C:/srv/packages/$mariadb already exist"
else
	echo "Downloading: $mariadb"
	cd /mnt/c/srv/packages/
#	wget -P /mnt/c/srv/packages -O mariadb-10.2.12-winx64.msi https://downloads.mariadb.org/interstitial/mariadb-10.2.12/winx64-packages/mariadb-10.2.12-winx64.msi?serve
	wget -O $mariadb $mariadb_path

	echo "Installing mariadb"
	# Install MariaDB with password and servicename
	/mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\srv\packages\\"$mariadb PASSWORD="$db_root_password" SERVICENAME="MariaDB" /qn



	#mariadb is .msi not .exe it neds windows msi installer (msiexec.exe) (Octavian)
	# /mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\srv\packages\/"$mariadb /passive

fi;
echo ""

# Downloading and installing c++ compiler
echo "Looking for C++ compiler"
if [ -e /mnt/c/srv/packages/$vc_compiler ] ; then
	echo "C:/srv/packages/$vc_compiler already exist"
else
	cd /mnt/c/srv/packages/
	echo "Downloading c++ compiler"
	wget -O $vc_compiler $vc_compiler_path

	echo "Installing latest C++ compiler"
	/mnt/c/srv/packages/$vc_compiler
fi;
echo ""

# Downloading and installing Apache
echo "Looking for Apache httpd"
if [ -e /mnt/c/srv/packages/$apache ] ; then
	echo "C:/srv/packages/$apache already exist"
else
	cd /mnt/c/srv/packages/
	echo "Downloading: $apache "
	wget -S -O $apache $apache_path --referer="https://www.apachelounge.com/download/" --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.16299"

	echo "Extracting: $apache"
	cd /mnt/c/srv/packages/
	unzip $apache -d /mnt/c/srv/installed-packages/apache24/
fi;
echo ""

# Downloading and installing php
echo "Looking for PHP"
if [ -e /mnt/c/srv/packages/$php ] ; then
	echo "C:/srv/packages/$php already exist"
else
    cd /mnt/c/srv/packages
	echo "Downloading $php VC15 x64 Thread Safe"
	wget -O $php $php_path 

    echo "Extracting: $apache"
	cd /mnt/c/srv/packages/
	unzip $php -d /mnt/c/srv/installed-packages/php722/
fi;
echo ""



echo ""
echo "---Configuring apache server---"
echo ""

echo "Adding server root directory to config"
echo ""
sed -i "s/^ServerRoot\ [a-zA-Z0-9\.\_-\"\\:]\+/ServerRoot\ \"C:\\/srv\\/installed-packages\\/apache24\\/Apache24\"/;" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf"

# Setting up initial apache settings
echo "Setting up localhost"
echo ""
# Checking if servername is configured
install_apache_servername=$(grep -E "^ServerName" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf" || echo "")
if [ -z "$install_apache_servername" ]; then

	# SET SERVERNAME
	echo "ServerName localhost:80" >> "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf"

else

	sed -i "s/^ServerName\ [a-zA-Z0-9\.\_-:]\+/ServerName\ localhost:80/;" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf"

fi

# Adding DocumentRoot to global config
echo "Adding DocumentRoot to config"
sed -i "s/^DocumentRoot\ [a-zA-Z0-9\.\_-\"\\:]\+/DocumentRoot\ \"C:\\/srv\\/sites\"/;" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf"
echo ""

# Adding Self directory to global config
echo "Adding apache install directory to config"
sed -i "s/^<Directory\ \"c:/<Directory\ \"C:\\/srv\\/installed-packages\\/apache24/;" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf"
echo ""

# Adding php support to apache

# Setting up php.ini
echo "Copying php.ini to php722/php.ini"
cp "/mnt/c/srv/tools/_conf/php.ini" "/mnt/c/srv/installed-packages/php722/php.ini"
echo ""

# Checking if php is configured
install_apache_php=$(grep -E "^LoadModule php7_module" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf" || echo "")
if [ -z "$install_apache_php" ]; then

	# Include php module
	echo "Adding php module to global config"
	echo "LoadModule php7_module C:/srv/installed-packages/php722/php7apache2_4.dll" >> "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf"

fi

# Checking if php ini is configured
install_apache_php_ini=$(grep -E "^PHPIniDir" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf" || echo "")
if [ -z "$install_apache_php_ini" ]; then

	# Include PHPIniDir path
	echo "Adding php to global config"
	echo "PHPIniDir  C:/srv/installed-packages/php722" >> "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf"

fi

# Setting up vhosts
echo "Copying vhosts.conf to Apache24/conf/extra"
cp "/mnt/c/srv/tools/_conf/httpd-vhosts.conf" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/extra/httpd-vhosts.conf"
echo ""

# Checking if vhosts is configured
install_apache_vhosts=$(grep -E "^Include conf\\/extra\\/httpd\\-vhosts\\.conf" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf" || echo "")
if [ -z "$install_apache_vhosts" ]; then

	# Include vhosts config
	echo "Adding vhosts config to global config"
	sed -i "s/^#Include conf\\/extra\\/httpd\\-vhosts\\.conf/Include conf\\/extra\\/httpd\\-vhosts\\.conf/" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf"

fi


# Correct file location is srv/sites/apache - not srv/apache
# Copy accessible apache config extender file
if [ -f "/mnt/c/srv/apache/apache.conf" ]; then

	# Move to correct apache folder
	echo "Moving apache.conf to the correct path"
	mv "/mnt/c/srv/apache/apache.conf" "/mnt/c/srv/sites/apache/apache.conf"

fi

# Removing empty leftover apache directory
if [ -d "/mnt/c/srv/apache/" ]; then

	echo ""
	echo "Removing leftover apache directory"
	echo ""
	
	rmdir "/mnt/c/srv/apache/"
fi

# Removing wrong "include" in global apache config
echo "Checking if config extender is already added"
echo ""
install_apache_extender=$(grep -E "^Include \"(c:)?\\/srv\\/apache\\/\\*\\.conf\"" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf" || echo "")
if [ -n "$install_apache_extender" ]; then

	# Include config extender
	echo "Removing incorrect apache path from global apache config"
	echo ""

	sed -i "s/^Include \"[c:]*\\/srv\\/apache\\/\\*\\.conf\"//" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf"

fi

# Copy default apache.conf
if [ ! -f "/mnt/c/srv/sites/apache/apache.conf" ]; then

	echo "Adding apache config file to /srv/sites/apache"
	echo ""

	cp "/mnt/c/srv/tools/_conf/apache.conf" "/mnt/c/srv/sites/apache/apache.conf"

fi

# Add "include" in global apache config
install_apache_extender=$(grep -E "^Include \"(c:)?\\/srv\\/sites\\/apache\\/\\*\\.conf\"" "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf" || echo "")
if [ -z "$install_apache_extender" ]; then

	# Include config extender
	echo "Adding apache config extender to global config"
	echo ""

	echo "Include \"/srv/sites/apache/*.conf\"" >> "/mnt/c/srv/installed-packages/apache24/Apache24/conf/httpd.conf"

fi




# Checking if apache service is installed
echo "Installing apache server"
echo "" 
	sudo /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe -k install exit 2>/dev/null || echo ""

echo "Starting apache server"
echo ""
sudo /mnt/c/Windows/System32/net.exe start apache2.4 exit 2>/dev/null || echo ""

echo "        Server install complete "
echo "---------------------------------------------"



# if [ -e /mnt/c/srv/packages/PHP ] ; then
# 	echo "C:/srv/packages/PHP already exist so $PHP have been extracted  "
# else
# 	echo "Extracting: $PHP VC15 x64 Thread Safe zip"
# 	cd /mnt/c/srv/packages/
# 	unzip $PHP -d /mnt/c/srv/packages/PHP/
# 	echo "Seting enviroment variable for: PHP methode permanent "
#
# # echo "Installing php-7.2.1-VC15-x64"
# # /mnt/c/srv/packages/php-7.2.1-VC15-x64.exe
# fi;
# # WORNING save the original path before cang it with below line
# #/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe   setx php %PHP%; C:\srv\packages\PHP
#
# # echo "seting enviroment variable for PHP methode 2 "
# # /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe  setx php "%PHP%; C:\srv\packages\PHP"
#
# # echo "seting enviroment variable for PHP methode 3 "
# # /mnt/c/Windows/System32/cmd.exe setx php "%PHP%; C:\srv\packages\PHP\"
# # echo "seting enviroment variable for PHP methode 1 "
# # /mnt/c/Windows/System32/cmd.exe set PATH=%PATH%; C:\srv\packages\PHP\
# # /mnt/c/Windows/System32/cmd.exe set PHP=%PHP%; C:\srv\packages\PHP\
# echo "Looking: for $Ffmpeg"
# if [ -e /mnt/c/srv/packages/$Ffmpeg ] ; then
# 		echo "C:/srv/packages/ffmpeg.zip already exist but have not ben extracted"
# else
# 	echo "Downloading: ffmpeg"
# 	cd /mnt/c/srv/packages/
#  	wget -P  /mnt/c/srv/packages/  -O $Ffmpeg $Ffmpeg_path
# fi;
#
# if [ -e /mnt/c/srv/packages/$Ffmpeg ] ; then
# 	echo "C:/srv/packages/$Ffmpeg already exist so have ben extracted"
# else
# 	echo "Extracting: $Ffmpeg"
# 	cd /mnt/c/srv/packages/
# 	unzip $Ffmpeg  -d /mnt/c/srv/packages/ffmpeg/
# 	echo "seting enviroment variable for ffmpeg"
# 	#/mnt/c/Windows/System32/cmd.exe set ffmpeg=%ffmpeg% "C:\srv\packages\ffmpeg"
# 	/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe  setx ffmpeg %ffmpeg% "C:\srv\packages\ffmpeg" #
# fi;
#
#
# # echo "Installing ffmpeg"
# # /mnt/c/srv/packages/ffmpeg.exe
# if [ -e /mnt/c/srv/packages/$Imagemagick ] ; then
# 	echo "C:/srv/packages/imagemagick already exist"
# else
#  echo "Downloading: imagemagick"
#  wget -P  /mnt/c/srv/packages/  -O $Imagemagick $Imagemagick_path
# fi;
#  echo "Installing: imagemagick"
#  /mnt/c/srv/packages/$Imagemagick
# #/mnt/c/ProgramData/chocolatey/bin/choco.exe install -y apache-httpd
#
# #echo "Install mariadb"
# 	#/mnt/c/ProgramData/chocolatey/bin/choco.exe  install -y --force mariadb
# 	#/mnt/c/ProgramData/chocolatey/lib/NuGet.CommandLine/tools/NuGet.exe
# #echo "Upgrde mariadb"
# 	#/mnt/c/ProgramData/chocolatey/bin/choco.exe --force upgrade -y mariadb install -y --force mariadb
#
#
# # if [ -e /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe ] ; then
# # 	echo "mariadb : OK"
# # else
# # 	echo " mariadb  does not exist"
# # 	echo "Install mariadb"
# # 	/mnt/c/ProgramData/chocolatey/bin/choco.exe install -y mariadb
# # 	exit 1
# # fi
#
#
# #cd /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe



