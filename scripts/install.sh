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
copyParentNodepromptToFile(){
    read_prompt_file=$( < "/mnt/c/srv/tools/conf/dot_profile")
    #echo "$source_file" | sed -n "/$source_text_start/,/$source_text_start/p" >> "$destination_file"
    echo "$read_prompt_file" | sed -n '/# ADMIN CHECK/,/export PS1/p' >> "$HOME/.bash_profile"
    echo "Copied to file"
}

if [ -e "$HOME/.bash_profile"];
then 
    echo ".bash_profile found"
else 
    touch "$HOME/.bash_profile"
    echo ".bash_profile created"
fi

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

if [ "$(checkFileContent "$HOME/.bash_profile" "alias")" == "Found" ];
then
    echo "Previous alias statement(s)"
        if [ "$(checkFileContent "$HOME/.bash_profile" "git_prompt ()")" == "Found" ];
        then
            echo ""
            echo "Seems like you have installed parentnode prompt"
            echo ""
        else 
            echo ""
            echo "Seems like you haven't installed parentnode prompt"
            echo ""
            echo "Installing"
            copyParentNodepromptToFile
            echo ""
        fi
    #sudo chown "$username:$username" "$HOME/.profile"
    handleAlias 
    
else
    
    if [ "$(checkFileContent "$HOME/.bash_profile" "git_prompt ()")" == "Found" ];
    then
        echo "You allready have parentNode Configuration"
    else 
        echo "Copying parentNode Configuration"
        copyParentNodepromptToFile
        
    fi
    handleAlias    
fi


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




