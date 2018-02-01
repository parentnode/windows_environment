#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "               SOFTWARE"
echo
echo


if test "$install_software" = "Y"; then

#$toolsDir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
#Get-ChocolateyUnzip -FileFullPath "c:\PHP_zip.zip" -Destination $toolsDir
#set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"
#sz x  -o"c:\PHP_zip.zip"  "c:\PHP_zip" -r

#$env:ProgramFiles\7-Zip\7z.exe

#. 'C:\Program Files\7-Zip\7z.exe x c:\PHP_zip.zip -r -o c:\PHP_zip '
#. 'C:\Program Files\7-Zip\7z.exe' x 'c:\PHP_zip.zip' -r -o 'C:\PHP_test'
	echo
	echo "Installing software"
	echo

	# install chocolatey
	Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))


	# INSTALL SYS-INFO
	# aptitude install landscape-client landscape-common

	# INSTALL APACHE
	 #install -y apache2 apache2-utils 
	choco install 7zip.install 
	choco install -y apache-httpd 

# instaling some aditions tools for finds commands and more 
	choco install -y pscx 
	choco install -y grepwin 


	#Invoke-WebRequest -Uri "http://windows.php.net/downloads/releases/php-devel-pack-7.1.12-nts-Win32-VC14-x64.zip" -OutFile "C:\srv\downloads\php-7.1.12-nts-Win32-VC14-x64.zip"

	#(New-Object Net.WebClient).DownloadFile('http://download.sysinternals.com/Files/SysinternalsSuite.zip','C:\Tools\SysinternalsSuite.zip');
	# INSTALL PHP5.5
#	sudo apt install -y libapache2-mod-php5 php5 php5-cli php5-common php5-curl php5-dev php5-imagick php5-mcrypt php5-memcached php5-mysqlnd php5-xmlrpc memcached
	#(new-object System.Net.WebClient).DownloadFile( "http://windows.php.net/downloads/releases/php-devel-pack-7.1.12-nts-Win32-VC14-x64.zip", "C:\srv\downloads\php-7.1.12-nts-Win32-VC14-x64.zip")
	#(New-Object Net.WebClient).DownloadFile( "http://windows.php.net/downloads/releases/php-devel-pack-7.1.12-nts-Win32-VC14-x64.zip", "C:\srv\downloads\php-7.1.12-nts-Win32-VC14-x64.zip");
	$client = New-Object System.Net.WebClient 
	$client.DownloadFile("http://windows.php.net/downloads/releases/php-devel-pack-7.1.12-nts-Win32-VC14-x64.zip","C:\srv\downloads\php-7.1.12-nts-Win32-VC14-x64.zip");
	#(New-Object Net.WebClient).DownloadFile('http://download.sysinternals.com/Files/SysinternalsSuite.zip','C:\Tools\SysinternalsSuite.zip')
	. 'C:\Program Files\7-Zip\7z.exe' x 'C:\srv\downloads\php-7.1.12-nts-Win32-VC14-x64.zip' -r -o'C:\srv\packages'
	# For coming Ubuntu 16.04 install (when Memcached issues have been resolved)
	#sudo add-apt-repository -y ppa:ondrej/php
	#sudo apt update -y
	#sudo apt install pkg-config build-essential libmemcached-dev
	#choco uninstall  php
	# INSTALL PHP7.0
	#sudo apt install -y libapache2-mod-php php7.0 php7.0-cli php7.0-common php7.0-curl php7.0-dev php-imagick php-igbinary php-msgpack php7.0-mcrypt php7.0-mbstring php7.0-zip php-memcached php7.0-mysql php7.0-xmlrpc memcached
	#choco install php -y "/ThreadSafe”
	#choco install -y php 
	#choco install php --params "/ThreadSafe”
	
#choco install devbox-unzip
	# INSTALL PHP7.1
	#sudo apt install -y --allow-unauthenticated libapache2-mod-php php7.1 php7.1-cli php7.1-common php7.1-curl php7.1-dev php-imagick php-igbinary php-msgpack php7.1-mcrypt php7.1-mbstring php7.1-zip php-memcached php7.1-mysql php7.1-xmlrpc memcached
	#sudo apt install libapache2-mod-php php7.1 php7.1-cli php7.1-common php7.1-curl php7.1-dev php-imagick php-igbinary php-msgpack php7.1-mcrypt php7.1-mbstring php7.1-zip php-memcached php7.1-mysql php7.1-xmlrpc memcached
	#(new-object System.Net.WebClient).DownloadFile( "http://windows.php.net/downloads/releases/php-devel-pack-7.1.12-nts-Win32-VC14-x64.zip", "C:\Users\clevo\AppData\Roaming\php-7.1.12-nts-Win32-VC14-x64.zip")
	# Expand-Archive -Path C:/php-7.1.11-nts-Win32-VC14-x64.zip -DestinationPath C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64

	# Get-ChocolateyUnzip `
 #  [-FileFullPath <String>] `
 #  -Destination <String> `
 #  [-SpecificFolder <String>] `
 #  [-PackageName <String>] `
 #  [-FileFullPath64 <String>] `
 #  [-IgnoredArguments <Object[]>] [<CommonParameters>]


#   # Path to the folder where the script is executing
# choco install unzip 
# $toolsDir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
# Get-ChocolateyUnzip -FileFullPath "c:\someFile.zip" -Destination $toolsDir

# PARAM (
#     [string] $ZipFilesPath = "X:\Somepath\Full\Of\Zipfiles",
#     [string] $UnzipPath = "X:\Somepath\to\extract\to"
# )
 
# $Shell = New-Object -com Shell.Application
# $Location = $Shell.NameSpace($UnzipPath)
 
# $ZipFiles = Get-Childitem $ZipFilesPath -Recurse -Include *.ZIP
 
# $progress = 1
# foreach ($ZipFile in $ZipFiles) {
#     Write-Progress -Activity "Unzipping to $($UnzipPath)" -PercentComplete (($progress / ($ZipFiles.Count + 1)) * 100) -CurrentOperation $ZipFile.FullName -Status "File $($Progress) of $($ZipFiles.Count)"
#     $ZipFolder = $Shell.NameSpace($ZipFile.fullname)
 
 
#     $Location.Copyhere($ZipFolder.items(), 1040) # 1040 - No msgboxes to the user - http://msdn.microsoft.com/en-us/library/bb787866%28VS.85%29.aspx
#     $progress++
# }


# PARAM (
#     [string] $ZipFilesPath = "X:\Somepath\Full\Of\Zipfiles",
#     [string] $UnzipPath = "X:\Somepath\to\extract\to"
# )
 
# $Shell = New-Object -com Shell.Application
# $Location = $Shell.NameSpace($UnzipPath)
 
# $ZipFiles = Get-Childitem $ZipFilesPath -Recurse -Include *.ZIP
 
# $progress = 1
# foreach ($ZipFile in $ZipFiles) {
#     Write-Progress -Activity "Unzipping to $($UnzipPath)" -PercentComplete (($progress / ($ZipFiles.Count + 1)) * 100) -CurrentOperation $ZipFile.FullName -Status "File $($Progress) of $($ZipFiles.Count)"
#     $ZipFolder = $Shell.NameSpace($ZipFile.fullname)
 
 
#     $Location.Copyhere($ZipFolder.items(), 1040) # 1040 - No msgboxes to the user - http://msdn.microsoft.com/en-us/library/bb787866%28VS.85%29.aspx
#     $progress++
# }

	# INSTALL PHP5.6
	# sudo apt install -y libapache2-mod-php php5.6 php5.6-cli php5.6-common php5.6-curl php5.6-dev php-imagick php5.6-mcrypt php5.6-mbstring php5.6-zip php-memcached php5.6-mysql php5.6-xmlrpc memcached

	# INSTALL ZIP, LOG ROTATION, CURL
	#sudo apt install -y zip logrotate curl

	# INSTALL mariaDB
	# Avoid password prompt - password will be set in install_webserver_configuration (NOT NEEDED FOR UBUNTU 16.14)
	# export DEBIAN_FRONTEND=noninteractive
	# debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password password temp"
	# debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password_again password temp"

	#sudo -E apt install -q -y mariadb-server

	choco install mariadb 
	echo
	echo

else

	echo
	echo "Skipping software"
	echo
	echo

fi