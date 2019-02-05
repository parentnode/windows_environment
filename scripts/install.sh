#!/bin/bash -e

echo "--------------------------------------------------------------"
echo ""
echo "Installing parentNode in windows subsystem for linux"
echo "DO NOT CLOSE UNTIL INSTALL ARE COMPLETE" 
echo "You will see 'Install complete' message once it's done"
echo ""
echo ""


echo "--------------------"
echo "--- Curl and Tar ---"
echo "--------------------"
echo ""
# Root path for curl and tar 
curl_tar_path="/mnt/c/Windows/System32"

# Testing if the file exists and if the version number is above 7.5
curlversion=$(($curl_tar_path/curl.exe -V) 2>/dev/null | grep -E "^curl (7\.[5-9]+|[8-9]\.[0-9]+)" || echo "")

# Testing if the file exists and if the version number is above 3.3
tarversion=$(($curl_tar_path/tar.exe --help) 2>/dev/null | grep -E "^bsdtar (3\.[3-9]+|[4-9]\.[0-9]+)" || echo "")

echo ""
username=$( echo $SUDO_USER)
export username

# Testing if either conditions for tar or curl are met then you can proceed 
if [ -z "$curlversion" ] || [ -z "$tarversion" ];then
	echo "You seem to be missing curl or tar or running an older version of curl or tar"
	echo "### Please Check you have all available updates ###"
	exit
else
	echo ""
	echo "curl and tar are up to date you are all set"
	echo ""
fi

# Including the functions we need for the installation
source /mnt/c/srv/tools/scripts/functions.sh
# Including the names and links used in install_software.sh
source /mnt/c/srv/tools/conf/download_name_link.sh

echo ""
echo "-------------------------------------------------------"
echo "Please enter the information required for your install:"
echo "-------------------------------------------------------"
echo ""

echo "------------------------"
echo "--- Mariadb Password ---"
echo "------------------------"
echo ""
# MariaDB not installed, ask for new root password
if [ ! -e /mnt/c/srv/packages/$mariadb.zip ] && [ ! -e /mnt/c/srv/packages/$mariadb_alt ]; then
	while [ true ]
	do
    	echo "Passwords can only start with a letter and only contain letters and numbers"
		echo ""
		read -s -p "Enter mariaDB password: " db_root_password
		echo ""
    	read -s -p "Verify mariaDB password: " db_root_password2
		echo ""    
    	if [ $db_root_password != $db_root_password2 ]; then
    		echo ""
    		echo "Not same"
			echo ""
    	else 
    		echo ""
    		echo "Same"
			echo ""
    		export db_root_password
    		break
    	fi	
	done
fi

echo ""
echo "------------------------"
echo "Parentnode .bash_profile"
echo "------------------------"
echo ""

# Existing .bash_profile can show signs of professional use, if none exist create new and copy parentnode prompt
if [ -e "$HOME/.bash_profile" ];
then 
    echo ".bash_profile found"
    # Optional bash prompt setup
    echo ""
	echo "----------------------------------------------------------------------"
	echo "	Setting up parentnode prompt replaces existing .bash_profile file   "
	echo "	This is optional but be aware choosing 'N' 'should' only be done  	"
	echo "				by people who know what they are doing!					"
	echo "----------------------------------------------------------------------"
	echo ""
	read -p "Do you wish to setup parentnode prompt Y/N? :   " optional_prompt
    export optional_prompt
    echo ""
else
	echo ".bash_profile not found"
	sudo touch "$HOME/.bash_profile"
	sudo chmod 777 "$HOME/.bash_profile"
	read_dot_profile=$( < "/mnt/c/srv/tools/conf/dot_profile")
	read_dot_profile_git_prompt=$( < "/mnt/c/srv/tools/conf/dot_profile_git_promt")
	read_dot_profile_alias=$( < "/mnt/c/srv/tools/conf/dot_profile_alias")
	echo "$read_dot_profile" >> $HOME/.bash_profile
	echo "" >> $HOME/.bash_profile
	echo "$read_dot_profile_git_prompt" >> $HOME/.bash_profile
	echo "" >> $HOME/.bash_profile
	handleAlias
	echo ""
	echo "--------------------------------------"
	echo "Parentnode .bash_profile are installed"
	echo "--------------------------------------"
	echo ""
fi


# SETTING DEFAULT GIT USER
echo "-----------------------------------------"
echo "--- Setting up Git user configuration ---"
echo "-----------------------------------------"
echo ""
git config --global core.filemode false

# Checks if git credential are allready set, promts for input if not
git_configured "name"
git_configured "email"

git config --global credential.helper cache
git config --global push.default simple
git config --global core.autocrlf true





# If user want's to set up parentnode prompt else set alias
if test "$optional_prompt" = "Y" ; then
    echo "Setting up install_prompt"
    bash /mnt/c/srv/tools/scripts/install_prompt.sh
else
    handleAlias
fi


echo ""
echo "----------------------------"
echo "--- Checking Directories ---"
echo "----------------------------"
echo ""

# Base parentnode project location
checkFolderOrCreate "/mnt/c/srv/sites/parentnode"
# Base apache configuration location
checkFolderOrCreate "/mnt/c/srv/sites/apache/logs"
# Creating packages folder
checkFolderOrCreate "/mnt/c/srv/packages"
# Creating installed-packages folder
checkFolderOrCreate "/mnt/c/srv/installed-packages"

echo ""


echo "------------------------------"
echo "--- Stop Apache if running ---"
echo "------------------------------"

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
echo "-----------------------------"
echo "	 Setting up apache.conf    "
echo "You only need to do this once"
echo "-----------------------------"
echo ""

# Setting up apache.conf (only once)
if [ ! -f "/mnt/c/srv/sites/apache/apache.conf" ]; then

	echo "Adding apache config file to sites/apache/"
	echo ""
	cp "/mnt/c/srv/tools/conf/apache.conf" "/mnt/c/srv/sites/apache/apache.conf"

fi

# Install software
bash /mnt/c/srv/tools/scripts/install_software.sh


echo "-----------------------------------------"
echo "--- Configuring Apache server and PHP ---"
echo "-----------------------------------------"

echo ""
echo "----------------------------------------------"
echo "Setting up php.ini and required files for CURL"
echo "----------------------------------------------"
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

echo "-----------------------------"
echo "--- Setting up httpd.conf ---"
echo "-----------------------------"

# Setting up httpd.conf
echo "Copying httpd config file to apache24/conf"
cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
echo ""

echo "-----------------------"
echo "--- Adding SSL cert ---"
echo "-----------------------"

# Adding SSL cert
echo "Copying cacert.pem to installed-packages"
cp "/mnt/c/srv/tools/conf/cacert.pem" "/mnt/c/srv/installed-packages/cacert.pem"
echo ""

echo "------------------------------"
echo "--- Starting apache server ---"
echo "------------------------------"
sudo /mnt/c/Windows/System32/net.exe start Apache2.4 exit 2>/dev/null || echo ""



echo ""
echo "parentNode installed in windows subsystem for linux "
ehco ""
echo "Install complete"
echo "--------------------------------------------------------------"
echo ""




