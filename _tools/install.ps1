

echo "---------------------------------------------"
echo 
echo "        Starting server installation"
echo 
echo

# GET INSTALL USER
install_user=$(whoami)
export install_user


echo
echo "Installing system for $install_user"

echo
echo "To speed up the process, please select your install options now:"
echo


read -p "Install software (Y/n): " install_software
export install_software

read -p "Set up Apache/PHP/MariaDB (Y/n): " install_webserver_conf
export install_webserver_conf

# read -p "Install .htaccess (Y/n): " install_htpassword_for_user
# export install_htpassword_for_user

# read -p "Install ffmpeg (Y/n): " install_ffmpeg
# export install_ffmpeg

# read -p "Install wkhtmlto (Y/n): " install_wkhtml
# export install_wkhtml

# read -p "Install mail (Y/n): " install_mail
# export install_mail




echo
echo
echo "Please enter the information required for your install:"
echo


read -p "Your email address: " install_email
export install_email
echo

# HTACCESS PASSWORD
# if  ("$install_htpassword_for_user" = "Y") {



# 	read -s -p "HTACCESS password for $install_user\: " install_htaccess_password

# 	export install_htaccess_password
# 	echo
# 	echo

# }
Invoke-WebRequest -Uri "http://windows.php.net/downloads/releases/php-devel-pack-7.1.12-nts-Win32-VC14-x64.zip" -OutFile "C:\srv\downloads\php-7.1.12-nts-Win32-VC14-x64.zip"
(New-Object Net.WebClient).DownloadFile( "http://windows.php.net/downloads/releases/php-devel-pack-7.1.12-nts-Win32-VC14-x64.zip", "C:\srv\downloads\php-7.1.12-nts-Win32-VC14-x64.zip");

# $client = New-Object System.Net.WebClient 
# 	$client.DownloadFile("http://windows.php.net/downloads/releases/php-devel-pack-7.1.12-nts-Win32-VC14-x64.zip","C:\srv\downloads\php-7.1.12-nts-Win32-VC14-x64.zip");
# # MYSQL ROOT PASSWORD
# if ("$install_webserver_conf" == "Y"){


# 	read -s -p "Enter new root DB password\: " db_root_password
# 	export db_root_password
# 	echo

# }




# # SETTING DEFAULT GIT USER
# git config --global core.filemode false
# git config --global user.name "$install_user"
# git config --global user.email "$install_email"
# git config --global credential.helper cache



# # MAKE SITES FOLDER
# if [ ! -d "C:\srv\sites" ]; then
# 	mkdir "C:\srv\sites"
# fi

# # MAKE CONF FOLDER
# if [ ! -d "C:\srv\conf" ]; then
# 	mkdir "C:\srv\conf"
# fi

# # MAKE downloads FOLDER
# if [ ! -d "C:\srv\downloads" ]; then
# 	mkdir "C:\srv\downloads"
# fi

# # MAKE packages FOLDER
# if [ ! -d "C:\srv\packages" ]; then
# 	mkdir "C:\srv\packages"
# fi


# # INSTALL SOFTWARE
# # . c:\srv\tools\_tools\install_software.sh
# . "C:\srv\sites\parentnode\windows_environment\_tools\install_software.sh"

# # # INSTALL WEBSERVER CONFIGURATION
# . "C:\srv\sites\parentnode\windows_environment\_tools\install_webserver_configuration.sh"

# # # INSTALL HTACCESS PASSWORD
# # . /srv/tools/_tools/install_htaccess.sh

# # # INSTALL FFMPEG
# # . /srv/tools/_tools/install_ffmpeg.sh

# # # INSTALL WKHTMLTO
# # . /srv/tools/_tools/install_wkhtmlto.sh

# # # INSTALL MAIL
# # . /srv/tools/_tools/install_mail.sh



# echo
# echo
# echo "Copying terminal configuration"
# echo
# # ADD COMMANDS ALIAS'


# # GET CURRENT PORT NUMBER AND IP ADDRESS
# # port_number=$(grep -E "^Port\ ([0-9]+)$" /etc/ssh/sshd_config | sed "s/Port //;")
# # ip_address=$(dig +short myip.opendns.com @resolver1.opendns.com)

# echo
# echo
# echo "Login command:"
# echo
# echo "ssh -p $port_number $install_user@$ip_address"
# echo 
# echo
# echo "You are done!"
# echo
# echo "Reboot the server (sudo reboot)"
# echo "and log in again (ssh -p $port_number $install_user@$ip_address)"
# echo
# echo
# echo "See you in a bit "
# echo	
	#read -s -p "HTACCESS password for $install_user: " install_htaccess_password
