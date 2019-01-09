#!/bin/bash -e


echo "--------------------------------------------------------------"
echo ""
echo "                 Starting server installation"
echo "           DO NOT CLOSE UNTILL INSTALL IS COMPLETE" 
echo  "You will see 'Server install complete' message once it's done"


# tar command available
# TODO: This finds Out whether Curl or Tar is present 

# Root path for curl and tar 
curl_tar_path="/mnt/c/Windows/System32"

# Testing if the file exists and if the version number is above 7.5
curlversion=$(($curl_tar_path/curl.exe -V) 2>/dev/null | grep -E "^curl (7\.[5-9]+|[8-9]\.[0-9]+)" || echo "")

# Testing if the file exists and if the version number is above 3.3
tarversion=$(($curl_tar_path/tar.exe --help) 2>/dev/null | grep -E "^bsdtar (3\.[3-9]+|[4-9]\.[0-9]+)" || echo "")



# Testing if either conditions for tar or curl are met then you can proceed 
if [ -z "$curlversion" ] || [ -z "$tarversion" ];then
	echo "You seem to be missing curl or tar or running an older version of curl or tar"
	echo "### Please Check you have all available updates ###"
	exit
else
	echo "curl and tar are up to date you are all set"
fi

copyParentNodeGitPromptToFile(){
    read_git_prompt_file=$( < "/mnt/c/srv/tools/conf/dot_profile_git_promt")
	read_dot_bash_profile=$( < "$HOME/.bash_profile")
    #echo "$source_file" | sed -n "/$source_text_start/,/$source_text_start/p" >> "$destination_file"
    ref_prompt=$( echo "$read_git_prompt_file" | sed -n '/# enable git prompt/,/# end enable git prompt/p')
	replace_prompt=$( echo "$read_dot_bash_profile" | sed -n '/# enable git prompt/,/# end enable git prompt/p')
	if [ "$ref_prompt" != "$replace_prompt" ]; 
	then
		echo "Updated version of parentnode prompt available"
		sed -i '/# enable git prompt/,/# end enable git prompt/d' $HOME/.bash_profile
		echo "Deleted old version"
		echo "$ref_prompt" >> $HOME/.bash_profile
		echo "Added new one"
	else
		echo "Allready on newest version"
	fi
}
export -f copyParentNodeGitPromptToFile
copyParentNodePromptToFile(){
    read_prompt_file=$( < "/mnt/c/srv/tools/conf/dot_profile")
	admin_check= $( echo $read_prompt_file | grep -E ^"# ADMIN CHECK WINDOWS ONLY")
	if [ -z "$admin_check"]; 
	then
		echo "$read_prompt_file" | sed -n '/# ADMIN CHECK WINDOWS ONLY/,/# END ADMIN CHECK WINDOWS ONLY/p' >> $HOME/.bash_profile
	fi
	running_bash= $( echo $read_prompt_file | grep -E ^"# if running bash")
	if [ -z "$running_bash"]; 
	then
		echo "$read_prompt_file" | sed -n '/# if running bash/,/# end if running bash/p' >> $HOME/.bash_profile
	fi
	set_path= $( echo $read_prompt_file | grep -E ^"# set PATH so it includes users private bin if it exists")
	if [ -z "$set_path"]; 
	then
		echo "$read_prompt_file" | sed -n '/# set PATH so it includes users private bin if it exists/,/# end set PATH so it includes users private bin if it exists/p' >> $HOME/.bash_profile	
	fi
	
	copyParentNodeGitPromptToFile
}
export -f copyParentNodePromptToFile
#copyParentNodePromptToFile
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

echo "MariaDB Password section"
# MariaDB not installed, ask for new root password
if [ ! -e /mnt/c/srv/packages/$mariadb.zip ] && [ ! -e /mnt/c/srv/packages/$mariadb_alt ]; then
	while [ true ]
	do
    	read -s -p "Enter new root DB password: " db_root_password
    	echo ""
    	read -s -p "Verify new root DB password: " db_root_password2    
    	if [ $db_root_password != $db_root_password2 ]; then
    		echo ""
    		echo "Not same"
    	else 
    		echo ""
    		echo "Same"
    		export $db_root_password
    		break
    	fi	
	done
fi

# Existing .bash_profile can show signs of professional use, if none exist create new and copy parentnode prompt
if [ -e "$HOME/.bash_profile" ];
then 
    echo ".bash_profile found"
    # Optional bash prompt setup
    read -p "Do you wish to setup parentnode prompt Y/N (Pressing N may require experienced users):   " optional_prompt
    export optional_prompt
    echo ""
else
	touch "$HOME/.bash_profile"
    echo ".bash_profile created"
	if [ -e "$HOME/.bash_profile" ];
	then
    	copyParentNodePromptToFile
	fi
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

username=$( echo $SUDO_USER)

trimString()
{
	trim=$1
	echo "${trim}" | sed -e 's/^[ \t]*//'
}
export -f trimString


checkFileContent(){
	#dot_profile
	file=$1
	
	check=$2
	
	statement=$(grep "$check" $file || echo "")

	if [ -n "$statement" ];
	then 
		echo "Found"
    else 
        echo "Not Found"
	fi
		
}
export -f checkFileContent

# If an alias from parentnode exists then this script will update it, else it will parse it
handleAlias(){
    IFS=$'\n'
    read_alias_file=$( < "/mnt/c/srv/tools/conf/dot_profile_alias" )

    # The key komprises of value between the first and second quotation '"'
    default_keys=( $( echo "$read_alias_file" | grep ^\" |cut -d\" -f2) )

    #The value komprises of value between the third, fourth and fifth quotation '"'
    default_values=( $( echo "$read_alias_file" | grep ^\" |cut -d\" -f3,4,5) )
    unset IFS    
    for line in "${!default_keys[@]}"
    do		
        if [ "$(checkFileContent "$HOME/.bash_profile" "${default_keys[line]}")" == "Found" ];
        then
            echo "Updated ${default_values[line]}"
            sed -i -e "s,${default_keys[line]}\=.*,$(trimString "${default_values[line]}"),g" "$HOME/.bash_profile"
        else 
            echo "None or not all parentnode alias present" 
            echo " copying $(trimString "${default_values[line]}") "
            echo "$(trimString "${default_values[line]}")" >> "$HOME/.bash_profile"
        fi
    done

}
export -f handleAlias

# If user want's to set up parentnode prompt else set alias
if test $optional_prompt = "Y" ; then
    echo "Setting up install_prompt"
    bash /mnt/c/srv/tools/scripts/install_prompt.sh
else
    handleAlias
fi



echo ""
echo "--- Checking Directories ---"
echo ""
checkFolderOrCreate(){
	folderName=$1
	if [ -e $folderName ];
	then
		echo "$folderName already exists"
	else 
		echo "Create directory $folderName"
    	mkdir -p $folderName;
	fi

}

# Base parentnode project location
checkFolderOrCreate "/mnt/c/srv/sites/parentnode"
# Base apache configuration location
checkFolderOrCreate "/mnt/c/srv/sites/apache/logs"
# Creating packages folder
checkFolderOrCreate "/mnt/c/srv/packages"
# Creating installed-packages folder
checkFolderOrCreate "/mnt/c/srv/installed-packages"

echo ""


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

# Setting up apache.conf (only once)
if [ ! -f "/mnt/c/srv/sites/apache/apache.conf" ]; then

	echo "Adding apache config file to sites/apache/"
	echo ""
	cp "/mnt/c/srv/tools/conf/apache.conf" "/mnt/c/srv/sites/apache/apache.conf"

fi

# Install software
bash /mnt/c/srv/tools/scripts/install_software.sh


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


# Setting up httpd.conf
echo "Copying httpd config file to apache24/conf"
cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
echo ""


# Adding SSL cert
echo "Copying cacert.pem to installed-packages"
cp "/mnt/c/srv/tools/conf/cacert.pem" "/mnt/c/srv/installed-packages/cacert.pem"
echo ""


echo ""
echo "Starting apache server"
sudo /mnt/c/Windows/System32/net.exe start Apache2.4 exit 2>/dev/null || echo ""



echo ""
echo "        Server install complete "
echo "---------------------------------------------"
echo ""




