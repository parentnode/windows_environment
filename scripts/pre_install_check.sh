#!/bin/bash -e

# Defining paths and download urls

# Setting c++ compiler name and download link"
vc_compiler="vc_redist-x64"
export vc_compiler
#vc_compiler_path="https://parentnode.dk/download/72/HTML-ikg9m2me/vc_redist-x64.zip"
vc_compiler_path="https://parentnode.dk/download/72/HTMLEDITOR-html-k41fmkh4/vc_redist-x64.zip"
export vc_compiler_path
# Old file is also valid (and should not cause re-install)
vc_compiler_alt="VC_redist.x64.exe"
export vc_compiler_alt
# Setting mariadb name and download link"
mariadb="mariadb-10-2-12-winx64"
export mariadb
#mariadb_path="https://parentnode.dk/download/72/HTML-uwogdi5x/mariadb-10-2-12-winx64.zip"
mariadb_path="https://parentnode.dk/download/72/HTMLEDITOR-html-8yadxckk/mariadb-10-2-12-winx64.zip"
export mariadb_path
# Old file is also valid (and should not cause re-install)
mariadb_alt="mariadb-10.2.12-winx64.msi"
export mariadb_alt
# Setting apache name and download link"
apache="apachehttpd-2-4-33-win64-vc15"
export apache
#apache_path="https://parentnode.dk/download/72/HTML-i59ty49r/apachehttpd-2-4-33-win64-vc15.zip"
apache_path="https://parentnode.dk/download/72/HTMLEDITOR-html-476aartg/apachehttpd-2-4-33-win64-vc15.zip"
export apache_path
# Setting php name and download link"
php="php-7-2-2-win32-vc15-x64-redis-4"
export php
#php_path="https://parentnode.dk/download/72/HTML-aqwla8g3/php-7-2-2-win32-vc15-x64-redis-4.zip"
php_path="https://parentnode.dk/download/72/HTMLEDITOR-html-qxzr9nzg/php-7-2-2-win32-vc15-x64-redis-4.zip"
export php_path
# Getting imagick name and download link"
imagick="imagemagick-6-9-9-37-q16-x64-dll"
export imagick
#imagick_path="https://parentnode.dk/download/72/HTML-940u1z9m/imagemagick-6-9-9-37-q16-x64-dll.zip"
imagick_path="https://parentnode.dk/download/72/HTMLEDITOR-html-j4spicwi/imagemagick-6-9-9-37-q16-x64-dll.zip"
export imagick_path
# Setting redis name and download link"
redis="redis-x64-4-0-2-2"
export redis
#redis_path="https://parentnode.dk/download/72/HTML-wc8evnh2/redis-x64-4-0-2-2.zip"
redis_path="https://parentnode.dk/download/72/HTMLEDITOR-html-7up44f85/redis-x64-4-0-2-2.zip"
export redis_path
# Setting ffmpeg name and download link"
ffmpeg="ffmpeg-20180129-d4967c0-win64"
export ffmpeg
#ffmpeg_path="https://parentnode.dk/download/72/HTML-knnkg3yn/ffmpeg-20180129-d4967c0-win64.zip"
ffmpeg_path="https://parentnode.dk/download/72/HTMLEDITOR-html-f8ocphuu/ffmpeg-20180129-d4967c0-win64.zip"
export ffmpeg_path
# Setting wkhtml name and download link"
wkhtmltopdf="wkhtmltopdf-static-0-12-3"
export wkhtmltopdf
#wkhtmltopdf_path="https://parentnode.dk/download/72/HTML-g2y0tm22/wkhtmltopdf-static-0-12-3.zip"
wkhtmltopdf_path="https://parentnode.dk/download/72/HTMLEDITOR-html-bnyx276m/wkhtmltopdf-static-0-12-3.zip"
export wkhtmltopdf_path

echo ""
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

# tar command available
# TODO: This finds the tar command in bash - we need to check if it exists in CMD
if grep -qE "^bsdtar" tar --version &> /dev/null ; then
    echo "System is updated"
	echo ""
else

    echo "ERROR: Windows has not been fully updated"
    echo "Update Windows and try again"
    exit 1

fi



echo ""
echo "-------------------------------------------------------"
echo "Please enter the information required for your install:"
echo "-------------------------------------------------------"
echo ""

# Setting up git user and email
read -p "Your git username: " git_user
export git_user
echo ""

read -p "Your git email address: " git_email
export git_email
echo ""


# MariaDB not installed, ask for new root password
if [ ! -e /mnt/c/srv/packages/$mariadb.zip ] && [ ! -e /mnt/c/srv/packages/$mariadb_alt]; then
	read -s -p "Enter new root DB password: " db_root_password
	export db_root_password
	echo ""
fi


# SETTING DEFAULT GIT USER
echo "-----------------------------------------"
echo "--- Setting up Git user configuration ---"
echo "-----------------------------------------"
echo ""
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
