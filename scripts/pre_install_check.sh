#!/bin/bash -e
outputHandler "section" "Checking Software Prerequisites are met"
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

outputHandler "comment" "Confirming Windows environment"

# Check if windows environment
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    outputHandler "comment" "Windows 10 Bash: OK"
else

    outputHandler "comment" "ERROR: Linux Bash for Windows does not exist" "Install Linux Bash for Windows and try again"
    exit 1

fi

# tar command available
# TODO: This finds the tar command in bash - we need to check if it exists in CMD
if grep -qE "^bsdtar" tar --version &> /dev/null ; then
    outputHandler "comment" "System is updated"
else

    outputHandler "comment" "ERROR: Windows has not been fully updated" "Update Windows and try again"
    exit 1

fi
outputHandler "comment" "To speed up the process, please select your install options now:"

install_software_array=("[Yn]")
install_software=$(ask "Install Software (Y/n)" "${install_software_array[@]}" "option software")
export install_software

if [ "$install_software" = "Y" ]; then
	install_webserver_conf_array=("[Yn]")
	install_webserver_conf=$(ask "Install Webserver Configuration (Y/n)" "${install_webserver_conf_array[@]}" "option webserver conf")
	export install_webserver_conf

	install_ffmpeg_array=("[Yn]")
	install_ffmpeg=$(ask "Install FFMPEG (Y/n)" "${install_ffmpeg_array[@]}" "option ffmpeg")
	export install_ffmpeg

	install_wkhtml_array=("[Yn]")
	install_wkhtml=$(ask "Install WKHTMLTOPDF (Y/n)" "${install_wkhtml_array[@]}" "option wkhtml")
	export install_wkhtml
fi
# Setting up git user and email
#read -p "Your git username: " git_user
#export git_user
#echo ""
#
#read -p "Your git email address: " git_email
#export git_email
#echo ""





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

outputHandler "comment" "Setting Default GIT User setting"
# SETTING DEFAULT GIT USER

# Checks if git credential are allready set, promts for input if not
if [ -z "$(checkGitCredential "name")" ]; then
	git_username_array=("[A-Za-z0-9[:space:]*]{2,50}")
	git_username=$(ask "Enter git username" "${git_username_array[@]}" "git username")
	export git_username
else
	git_username="$(checkGitCredential "name")"
	export git_username
fi
if [ -z "$(checkGitCredential "email")" ]; then
	git_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
	git_email=$(ask "Enter git email" "${git_email_array[@]}" "git email")
	export git_email
else
	git_email="$(checkGitCredential "email")"
	export git_email
fi

git config --global core.filemode false
outputHandler "comment" "git core.filemode: $(git config --global core.filemode)"
git config --global user.name "$git_username"
outputHandler "comment" "git user name: $(git config --global user.name)"
git config --global user.email "$git_email"
outputHandler "comment" "git user email: $(git config --global user.email)"
git config --global credential.helper cache
outputHandler "comment" "git credential.helper: $(git config --global credential.helper)"
git config --global push.default simple
outputHandler "comment" "git push.default: $(git config --global push.default)"
git config --global core.autocrlf true
outputHandler "comment" "git core.autocrlf: $(git config --global core.autocrlf)"

createOrModifyBashProfile

# MariaDB not installed, ask for new root password
if [ "$install_software" = "Y" ]; then
	if [ "$(checkMariadbPassword)" = "false" ]; then
		password_array=("[A-Za-z0-9\!\@\$\#]{8,30}")
		echo "For security measures the terminal will not display how many characters you input"
		echo ""
		echo "Password format: between 8 and 30 characters, non casesensitive letters, numbers and  # ! @ \$ special characters "
		db_root_password1=$( ask "Enter mariadb password" "${password_array[@]}" "password")
		echo ""
		db_root_password2=$( ask "Confirm mariadb password" "${password_array[@]}" "password")
		echo ""

		# While loop if not a match
		if [  "$db_root_password1" != "$db_root_password2"  ]; then
		    while [ true ]
		    do
		        echo "Password doesn't match"
		        echo
		        #password1=$( ask "Enter mariadb password" "${password_array[@]}" "Password")
		        db_root_password1=$( ask "Enter mariadb password anew" "${password_array[@]}" "password")
		        echo ""
		        db_root_password2=$( ask "Confirm mariadb password" "${password_array[@]}" "password")
		        echo "" 
		        if [ "$db_root_password1" == "$db_root_password2" ];
		        then
		            echo "Password Match"
		            break
		        fi
		        export db_root_password1
		    done
		else
		    echo "Password Match"
			export db_root_password1
		fi
	else 
		outputHandler "comment" "Mariadb password allready set up"
	fi	
fi

#Being done with a symlink allready remove when done
#outputHandler "comment" "Setting Time zone"
#
#look_for_ex_timezone=$(sudo timedatectl status | grep "Time zone: " | cut -d ':' -f2)
#if [ -z "$look_for_ex_timezone" ]; then
#	outputHandler "comment" "Setting Time zone to Europe/Copenhagen"
#	sudo timedatectl set-timezone "Europe/Copenhagen"
#else 
#	outputHandler "comment" "Existing time zone values: $look_for_ex_timezone"
#fi


# Setting up bash config
#echo ""
#echo "Copying .profile to /home/$SUDO_USER"
#sudo cp "/mnt/c/srv/tools/conf/dot_profile" "/home/$SUDO_USER/.profile"
#sudo chown "$SUDO_USER:$SUDO_USER" "/home/$SUDO_USER/.profile"
#echo ""
exit

apache_service_installed=$(/mnt/c/Windows/System32/sc.exe queryex type= service state= all | grep -E "Apache" || echo "")
export apache_service_installed
# Check if Apache is running
apache_service_running=$(/mnt/c/Windows/System32/net.exe start | grep -E "Apache" || echo "")
export apache_service_running
# Apache is running (possibly other version)
if [ ! -z "$apache_service_running" ]; then
	echo ""
	echo "Apache is running. Stopping Apache to continue."
	# Stop Apache before continuing
	sudo /mnt/c/Windows/System32/net.exe stop Apache2.4
	echo ""

fi