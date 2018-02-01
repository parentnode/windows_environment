$url = ''
Write-Output "---------------------------------------------"
Write-Output ""
Write-Output "        Starting server installation"
Write-Output ""
Write-Output ""

# GET INSTALL USER
install_user=$(whoami)
export install_user


Write-Output
Write-Output "Installing system for $install_user"
 
Write-Output
Write-Output "To speed up the process, please select your install options now:"
Write-Output


read -p "Install software (Y/n): " install_software
export install_software

read -p "Set up Apache/PHP/MariaDB (Y/n): " install_webserver_conf
export install_webserver_conf

# read -p "Install ffmpeg (Y/n): " install_ffmpeg
# export install_ffmpeg

# read -p "Install wkhtmlto (Y/n): " install_wkhtml
# export install_wkhtml


Write-Output
Write-Output
Write-Output "Please enter the information required for your install:"
Write-Output


read -p "Your email address: " install_email
export install_email
Write-Output

# MYSQL ROOT PASSWORD
# if ("$install_webserver_conf" == "Y"){


# 	read -s -p "Enter new root DB password\: " db_root_password
# 	export db_root_password
# 	Write-Output

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
# . "C:\srv\sites\parentnode\windows_environment\_tools\install_software.ps1"

# # # INSTALL WEBSERVER CONFIGURATION
# . "C:\srv\sites\parentnode\windows_environment\_tools\install_webserver_configuration.ps1"



# # # INSTALL FFMPEG
# # . /srv/tools/_tools/install_ffmpeg.sh

# # # INSTALL WKHTMLTO
# # . /srv/tools/_tools/install_wkhtmlto.sh


# Write-Output
# Write-Output "You are done!"
# Write-Output