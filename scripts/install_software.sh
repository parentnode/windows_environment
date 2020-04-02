#!/bin/bash -e

outputHandler "section" "SOFTWARE"


# Clean up
outputHandler "comment" "Cleaning up:"
sudo apt-get --assume-yes autoremove

if [ "$install_software" = "Y" ]; then 
    # Install unzip to unpack downloaded packages
    outputHandler "comment" "Checking unzip:"
    install_unzip=$(unzip --version | grep ^"UnZip" || echo "")
    if [ "$install_unzip" = "" ]; then
    	sudo apt-get --assume-yes install unzip
    else
    	outputHandler "comment" "unzip is installed"
    fi
    # Prepare for download
    wget --spider --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --save-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" https://parentnode.dk

    # Custom parameters for wget download from parentNode website
    wget_params='--user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies cookies.txt --header="Referer: https://parentnode.dk"'


    # Downloading and installing c++ compiler
    outputHandler "comment" "Looking for $vc_compiler"
    if [ -e /mnt/c/srv/packages/$vc_compiler.zip ]; then
    	outputHandler "comment" "$vc_compiler already exists"
    else

    	outputHandler "comment" "Downloading $vc_compiler"
    	cd /mnt/c/srv/packages/
    	wget -O $vc_compiler.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $vc_compiler_path
        unzip $vc_compiler.zip -d /mnt/c/srv/packages/
    fi

    # Downloading
    outputHandler "comment" "Looking for $mariadb"
    if [ -e /mnt/c/srv/packages/$mariadb.zip ]; then
    	outputHandler "comment" "$mariadb already exists"
    else

    	outputHandler "comment" "Downloading: $mariadb"
    	cd /mnt/c/srv/packages/
    	wget -O $mariadb.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $mariadb_path
        unzip $mariadb.zip -d /mnt/c/srv/packages/
    fi

    # Downloading and installing Apache
    outputHandler "comment" "Looking for $apache"
    if [ -e /mnt/c/srv/packages/$apache.zip ] ; then
    	outputHandler "comment" "$apache already exists"
    else
        # Uninstall existing service
	    if [ ! -z "$apache_service_installed" ]; then

	    	outputHandler "comment" "APACHE IS RUNNING"

	    	# Old path
	    	if [ -e /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe ] ; then
	    		outputHandler "comment" "OLD PATH"
	    		sudo /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe -k uninstall
	    	# New path
	    	else
	    		outputHandler "comment" "NEW PATH"
	    		sudo /mnt/c/srv/installed-packages/apache24/bin/httpd.exe -k uninstall
	    	fi

	    fi

	    # Remove existing version
	    if [ -e /mnt/c/srv/installed-packages/apache24 ] ; then
	    	sudo rm -R /mnt/c/srv/installed-packages/apache24
	    fi


	    outputHandler "comment" "Downloading: $apache"
	    #cd /mnt/c/srv/packages/
	    wget -O /mnt/c/srv/packages/$apache.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $apache_path
        unzip /mnt/c/srv/packages/$apache.zip -d /mnt/c/srv/installed-packages/apache24
    fi

    outputHandler "comment" "Looking for $php"
    if [ -e /mnt/c/srv/packages/$php.zip ] ; then
    	outputHandler "comment" "$php already exists"
    else

    	# Remove existing version
    	if [ -e /mnt/c/srv/installed-packages/php722 ] ; then
    		sudo rm -R /mnt/c/srv/installed-packages/php722
    	fi
    	outputHandler "comment" "Downloading $php"
        cd /mnt/c/srv/packages
    	wget -O $php.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $php_path 
        unzip $php.zip -d /mnt/c/srv/installed-packages/php722
    fi
    
    
    outputHandler "comment" "Looking for $imagick"
    if [ -e /mnt/c/srv/packages/$imagick.zip ] ; then
    	outputHandler "comment" "$imagick already exist"
    else
    	outputHandler "comment" "Downloading: $imagick"
    	cd /mnt/c/srv/packages/
    	wget -O $imagick.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $imagick_path
        unzip $imagick.zip -d /mnt/c/srv/packages/
    fi
    
    
    outputHandler "comment" "Looking for $redis"
    if [ -e /mnt/c/srv/packages/$redis.zip ] ; then
    	outputHandler "comment" "$redis already exist"
    else

    	outputHandler "comment" "Downloading: $redis"
    	cd /mnt/c/srv/packages/
    	wget -O $redis.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $redis_path
        unzip $redis.zip -d /mnt/c/srv/packages/
    fi


	if [ "$install_ffmpeg" = "Y" ]; then
    	outputHandler "comment" "Looking for $ffmpeg"
    	if [ -e /mnt/c/srv/packages/$ffmpeg.zip ] ; then
    		outputHandler "comment" "$ffmpeg already exist"
    	else

    		# Remove existing version
    		if [ -e /mnt/c/srv/installed-packages/ffmpeg ] ; then
    			sudo rm -R /mnt/c/srv/installed-packages/ffmpeg
    		fi

    		outputHandler "comment" "Downloading: $ffmpeg"
    		cd /mnt/c/srv/packages/
    		wget -O $ffmpeg.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $ffmpeg_path 
    	    unzip $ffmpeg.zip -d /mnt/c/srv/installed-packages/ffmpeg
    	fi
	else
		outputHandler "comment" "Skipping FFMPEG installation"
	fi
	if [ "$install_wkhtml" = "Y" ]; then 
		outputHandler "comment" "Looking for $wkhtmltopdf"
    	if [ -e /mnt/c/srv/packages/$wkhtmltopdf.zip ] ; then
    		outputHandler "comment" "$wkhtmltopdf already exist"
    	else

    		# Remove existing version
    		if [ -e /mnt/c/srv/installed-packages/wkhtmltopdf ] ; then
    			sudo rm -R /mnt/c/srv/installed-packages/wkhtmltopdf
    		fi

    		outputHandler "comment" "Downloading: $wkhtmltopdf"
    		cd /mnt/c/srv/packages/
    		wget -O $wkhtmltopdf.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $wkhtmltopdf_path 
    	    unzip $wkhtmltopdf.zip -d /mnt/c/srv/installed-packages/wkhtmltopdf
    	fi
	else
		outputHandler "comment" "Skipping WKHTMLTOPDF installation"
	fi
    
	outputHandler "comment" "Installing $vc_compiler"
	/mnt/c/srv/packages/$vc_compiler.exe /passive /norestart
	# Remove installer
	rm /mnt/c/srv/packages/$vc_compiler.exe

	if [ "$install_webserver_conf" = "Y" ]; then 
		outputHandler "comment" "Installing $mariadb"
		sudo /mnt/c/Windows/System32/msiexec.exe /i "C:\\srv\\packages\\$mariadb.msi" /qn ACCEPT_EULA=1 PASSWORD="$db_root_password1" SERVICENAME="MariaDB"
		# Remove installer
		rm /mnt/c/srv/packages/$mariadb.msi

		# Copy default apache config, before installing service to avoid error
		sudo rm "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
		sudo cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
		if [ ! -f "/mnt/c/srv/sites/apache/apache.conf" ]; then
		   outputHandler "comment" "Adding apache config file to sites/apache/"
		   cp "/mnt/c/srv/tools/conf/apache.conf" "/mnt/c/srv/sites/apache/apache.conf"
		fi
		sudo /mnt/c/srv/installed-packages/apache24/bin/httpd.exe -k install
	else 
		outputHandler "comment" "Skipping Webserver installation"
	fi
	
	outputHandler "comment" "Installing $imagick"
	/mnt/c/srv/packages/$imagick.exe /NOICONS /SILENT
	# Remove installer
	rm /mnt/c/srv/packages/$imagick.exe


	outputHandler "comment" "Installing $redis"
	sudo /mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\\srv\\packages\\$redis.msi" ADD_FIREWALL_RULE=1 /qn
	
	# Remove installer
	rm /mnt/c/srv/packages/$redis.msi


else 

	outputHandler "comment" "Skipping Software installation"
fi



