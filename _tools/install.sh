#!/bin/bash -e
echo "---------------------------------------------"
#echo " ***prior running this script***"

echo ""
echo "        Starting server installation"


echo ""
echo ""
RedistributableVisualStudio2017="VC_redist.x64.exe"
RedistributableVisualStudio2017_path="https://aka.ms/vs/15/release/VC_redist.x64.exe"
PHP="php-7.2.2-VC15-x64"
PHP_path="http://windows.php.net/downloads/releases/php-7.2.2-Win32-VC15-x64.zip"
echo $PHP "instalation with Thread Safe"

MariaDB="mariadb-10.2.12-winx64.msi"
MariaDB_path="https://downloads.mariadb.org/interstitial/mariadb-10.2.12/winx64-packages/mariadb-10.2.13-winx64.msi?serve"
echo $MariaDB "installation version"
Apache="apachehttpd-2.4.29-Win64-VC15.zip"
Apache_path="http://www.apachelounge.com/download/VC15/binaries/httpd-2.4.29-Win64-VC15.zip" 
Imagemagick="imagemagick.exe" 
Imagemagick_path="https://www.imagemagick.org/download/binaries/ImageMagick-7.0.7-22-Q16-x64-dll.exe"
Ffmpeg="ffmpeg.zip"
Ffmpeg_path="https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-20180129-d4967c0-win64-static.zip"
#cd /mnt/c/srv/sites/parentnode/windows_environment/_tools
#./install.sh
# Check for the pre
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo "Windows 10 Bash: OK"
else

    echo "ERROR: Linux Bash for Windows does not exist"
    echo "Install Linux Bash for Windows and try again"
    exit 1

fi

if [ -e /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe ] ; then 
	echo "WindowsPowerShell: OK"
else
	echo "ERROR: WindowsPowerShell does not exist"
	echo "Install WindowsPowerShell v1.0 or higher and try again"
	exit 1
fi




if [ -e /mnt/c/ProgramData/chocolatey/bin/choco.exe ] ; then 
	echo "Chocolatey: OK"
else
	echo "ERROR: Chocolatey does not exist"
	echo "must be installed the chocolatey "
	echo "Installing the chocolatey by executing the executing the folowing script line" 
	echo "(Copy and paste in Powershell opened in admin mod) "
	echo "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'"

	echo " Powershell eleveated with administrator privilege" 
	echo "(run as admin by click right on the program icon)"
	exit 1
fi


echo "Checking Directories"

if [ -e /mnt/c/srv/sites/parentnode ] ; then
	echo "C:/srv/sites/parentnode alredy exist"
else
	echo "create directory C:/srv/sites/parentnode"
    mkdir -p /mnt/c/srv/sites/parentnode;
fi;

if [ -e /mnt/c/srv/tools ] ; then
	echo "C:/srv/tools alredy exist"
else
	echo "create directory C:/srv/tools"
    mkdir -p /mnt/c/srv/tools;
fi;

if [ -e /mnt/c/srv/packages ] ; then
	echo "C:/srv/packages alredy exist"
else
	echo "create directory C:/srv/packages"
    mkdir -p /mnt/c/srv/packages;
fi;
if [ -e /mnt/c/srv/packages/ffmpeg ] ; then
	echo "C:/srv/packages alredy exist"
else
	echo "create directory C:/srv/packages"
    mkdir -p /mnt/c/srv/packages/ffmpeg;
fi;

#/mnt/c/srv/sites/parentnode/windows_environment/_tools
echo ""
echo "Installing software"
echo""
hash unzip 2>/dev/null || { echo >&2 "Install: Unzip in Ubuntu enviroment"; sudo apt-get install unzip ;}
echo "Skip: unzip in Ubuntu  exist"
#sudo apt-get install unzip
# hash zip 2>/dev/null || { echo >&2 "Install: zip in Ubuntu enviroment"; sudo apt-get install zip ;}
# echo "Skip: zip in Ubuntu  exist"
#sudo apt install zip

#echo "Installing Chocolatey Server (Simple)"
#/mnt/c/ProgramData/chocolatey/bin/choco.exe install -y chocolatey.server
#/mnt/c/ProgramData/chocolatey/bin/choco.exe uninstall -y chocolatey.server

#echo "Installing nuget.commandline"
#/mnt/c/ProgramData/chocolatey/bin/choco.exe uninstall -y nuget.commandline
cd /mnt/c/srv/packages/
if [ -e /mnt/c/srv/packages/$MariaDB ] ; then
	echo "C:/srv/packages/$MariaDB alredy exist"
else
	echo "Downloading: $MariaDB"
	cd /mnt/c/srv/packages/
	wget  -P  /mnt/c/srv/packages/ -O $MariaDB  MariaDB_path
	echo "install mariadb"
	/mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\srv\packages\/"$MariaDB /passive
fi;

echo "Cechking: for Visual studio 17 C++ exist VC_redist.x64.exe alredy exist"
if [ -e /mnt/c/srv/packages/VC_redist.x64.exe ] ; then
	echo "C:/srv/packages/VC_redist.x64.exe alredy exist"
else
	cd /mnt/c/srv/packages/
	echo "Download latest C++ Redistributable Visual Studio 2017"
	wget -P  /mnt/c/srv/packages/  -O $RedistributableVisualStudio2017 $RedistributableVisualStudio2017_path

	echo "Installing latest C++ Redistributable Visual Studio 2017"
	/mnt/c/srv/packages/$RedistributableVisualStudio2017
fi;
echo "Looking: for Apache httpd"
if [ -e /mnt/c/srv/packages/$Apache ] ; then
	echo "C:/srv/packages/$Apache alredy exist"
else
	cd /mnt/c/srv/packages/
	echo "Downloading: $Apache "
	wget -P  /mnt/c/srv/packages/  -O $Apache Apache_pat

	echo "Extracting: $Apache"
	cd /mnt/c/srv/packages/
	unzip $Apache -d /mnt/c/srv/packages/apache/	
fi;

echo "Looking: for PHP"
if [ -e /mnt/c/srv/packages/$PHP ] ; then
	echo "C:/srv/packages/$PHP alredy exist"
else
	echo "Downloading:  $PHP VC15 x64 Thread Safe"
	wget -P  /mnt/c/srv/packages/  -O $PHP $PHP_path
fi;
if [ -e /mnt/c/srv/packages/PHP ] ; then
	echo "C:/srv/packages/PHP alredy exist so $PHP have ben extracted  "
else
	echo "Extracting: $PHP VC15 x64 Thread Safe zip"
	cd /mnt/c/srv/packages/
	unzip $PHP -d /mnt/c/srv/packages/PHP/ 
	echo "Seting enviroment variable for: PHP methode permanent "
	
# echo "Installing php-7.2.1-VC15-x64"
# /mnt/c/srv/packages/php-7.2.1-VC15-x64.exe
fi;
# WORNING save the original path before cang it with below line 
#/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe   setx php %PHP%; C:\srv\packages\PHP 

# echo "seting enviroment variable for PHP methode 2 " 
# /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe  setx php "%PHP%; C:\srv\packages\PHP"

# echo "seting enviroment variable for PHP methode 3 "
# /mnt/c/Windows/System32/cmd.exe setx php "%PHP%; C:\srv\packages\PHP\"
# echo "seting enviroment variable for PHP methode 1 "
# /mnt/c/Windows/System32/cmd.exe set PATH=%PATH%; C:\srv\packages\PHP\
# /mnt/c/Windows/System32/cmd.exe set PHP=%PHP%; C:\srv\packages\PHP\
echo "Looking: for $Ffmpeg"
if [ -e /mnt/c/srv/packages/$Ffmpeg ] ; then
		echo "C:/srv/packages/ffmpeg.zip alredy exist but have not ben extracted"
else
	echo "Downloading: ffmpeg"
	cd /mnt/c/srv/packages/
 	wget -P  /mnt/c/srv/packages/  -O $Ffmpeg $Ffmpeg_path
fi;

if [ -e /mnt/c/srv/packages/$Ffmpeg ] ; then
	echo "C:/srv/packages/$Ffmpeg alredy exist so have ben extracted"
else
	echo "Extracting: $Ffmpeg"
	cd /mnt/c/srv/packages/
	unzip $Ffmpeg  -d /mnt/c/srv/packages/ffmpeg/
	echo "seting enviroment variable for ffmpeg"
	#/mnt/c/Windows/System32/cmd.exe set ffmpeg=%ffmpeg% "C:\srv\packages\ffmpeg"
	/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe  setx ffmpeg %ffmpeg% "C:\srv\packages\ffmpeg" # 
fi;


# echo "Installing ffmpeg"
# /mnt/c/srv/packages/ffmpeg.exe
if [ -e /mnt/c/srv/packages/$Imagemagick ] ; then
	echo "C:/srv/packages/imagemagick alredy exist"
else
 echo "Downloading: imagemagick"
 wget -P  /mnt/c/srv/packages/  -O $Imagemagick $Imagemagick_path
fi;
 echo "Installing: imagemagick"
 /mnt/c/srv/packages/$Imagemagick
#/mnt/c/ProgramData/chocolatey/bin/choco.exe install -y apache-httpd

#echo "Install mariadb"
	#/mnt/c/ProgramData/chocolatey/bin/choco.exe  install -y --force mariadb 
	#/mnt/c/ProgramData/chocolatey/lib/NuGet.CommandLine/tools/NuGet.exe
#echo "Upgrde mariadb"
	#/mnt/c/ProgramData/chocolatey/bin/choco.exe --force upgrade -y mariadb install -y --force mariadb
	

# if [ -e /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe ] ; then 
# 	echo "mariadb : OK"
# else
# 	echo " mariadb  does not exist"
# 	echo "Install mariadb"
# 	/mnt/c/ProgramData/chocolatey/bin/choco.exe install -y mariadb 
# 	exit 1
# fi


#cd /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe
