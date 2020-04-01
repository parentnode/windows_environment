#!/bin/bash -e
#echo "---------------------------"
#echo "--- Installing software ---"
#echo "---------------------------"
#echo ""
#
## Clean up
#echo "------------"
#echo "Cleaning up:"
#sudo apt-get --assume-yes autoremove
#echo "------------"
#echo ""
#
## Install unzip to unpack downloaded packages
#echo "-----"
#echo "Unzip"
#echo "-----"
#bash /mnt/c/srv/tools/scripts/install_unzip.sh
#echo ""
#
## Downloading and installing c++ compiler
#echo "------------"
#echo "C++ Compiler"
#echo "------------"
#bash /mnt/c/srv/tools/scripts/install_vc_compiler.sh
#echo ""
#
## Downloading and installing mariaDB
#echo "-------"
#echo "MariaDB"
#echo "-------"
#bash /mnt/c/srv/tools/scripts/install_mariadb.sh
#echo ""
#
## Downloading and installing php
#echo "---"
#echo "PHP"
#echo "---"
#bash /mnt/c/srv/tools/scripts/install_php.sh
#echo ""
#
## Downloading and installing apache
#echo "------"
#echo "Apache"
#echo "------"
#bash /mnt/c/srv/tools/scripts/install_apache.sh
#echo ""
#
## Downloading and installing imagick
#echo "-----------"
#echo "ImageMagick"
#echo "-----------"
#bash /mnt/c/srv/tools/scripts/install_imagick.sh
#echo ""
#
## Downloading and installing redis
#echo "-----"
#echo "Redis"
#echo "-----"
#bash /mnt/c/srv/tools/scripts/install_redis.sh
#echo ""
#
## Downloading and installing ffmpeg
#echo "------"
#echo "FFMPEG"
#echo "------"
#bash /mnt/c/srv/tools/scripts/install_ffmpeg.sh
#echo ""
#
## Downloading and installing wkhtmltopdf
#echo "-------------"
#echo "WKHTML to PDF"
#echo "-------------"
#bash /mnt/c/srv/tools/scripts/install_wkhtmltopdf.sh
#echo ""

outputHandler "section" "SOFTWARE"

#echo ""
#echo "--- Installing software ---"
#echo ""
# Clean up
echo ""
echo "Cleaning up:"
sudo apt-get --assume-yes autoremove
echo ""
if [ "$install_software" = "Y" ]; then 
    # Install unzip to unpack downloaded packages
    echo "Checking unzip:"
    install_unzip=$(unzip --version | grep ^"UnZip" || echo "")
    if [ "$install_unzip" = "" ]; then
    	sudo apt-get --assume-yes install unzip
    else
    	echo "unzip is installed"
    fi
    # Prepare for download
    wget --spider --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --save-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" https://parentnode.dk

    # Custom parameters for wget download from parentNode website
    wget_params='--user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies cookies.txt --header="Referer: https://parentnode.dk"'


    # Downloading and installing c++ compiler
    echo "Looking for $vc_compiler"
    if [ -e /mnt/c/srv/packages/$vc_compiler.zip ]; then
    	echo "$vc_compiler already exists"
    else

    	echo "Downloading $vc_compiler"
    	cd /mnt/c/srv/packages/
    	wget -O $vc_compiler.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $vc_compiler_path
        unzip $vc_compiler.zip -d /mnt/c/srv/packages/
    fi

    # Downloading
    echo "Looking for $mariadb"
    if [ -e /mnt/c/srv/packages/$mariadb.zip ]; then
    	echo "$mariadb already exists"
    else

    	echo "Downloading: $mariadb"
    	cd /mnt/c/srv/packages/
    	wget -O $mariadb.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $mariadb_path
        unzip $mariadb.zip -d /mnt/c/srv/packages/
    fi
    echo ""
    # Downloading and installing Apache
    echo "Looking for $apache"
    if [ -e /mnt/c/srv/packages/$apache.zip ] ; then
    	echo "$apache already exists"
    else
        # Uninstall existing service
	    if [ ! -z "$apache_service_installed" ]; then

	    	echo "APACHE IS RUNNING"

	    	# Old path
	    	if [ -e /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe ] ; then
	    		echo "OLD PATH"
	    		sudo /mnt/c/srv/installed-packages/apache24/Apache24/bin/httpd.exe -k uninstall
	    	# New path
	    	else
	    		echo "NEW PATH"
	    		sudo /mnt/c/srv/installed-packages/apache24/bin/httpd.exe -k uninstall
	    	fi

	    fi

	    # Remove existing version
	    if [ -e /mnt/c/srv/installed-packages/apache24 ] ; then
	    	sudo rm -R /mnt/c/srv/installed-packages/apache24
	    fi


	    echo "Downloading: $apache"
	    #cd /mnt/c/srv/packages/
	    wget -O /mnt/c/srv/packages/$apache.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $apache_path
        unzip /mnt/c/srv/packages/$apache.zip -d /mnt/c/srv/installed-packages/apache24
    fi

    echo "Looking for $php"
    if [ -e /mnt/c/srv/packages/$php.zip ] ; then
    	echo "$php already exists"
    else

    	# Remove existing version
    	if [ -e /mnt/c/srv/installed-packages/php722 ] ; then
    		sudo rm -R /mnt/c/srv/installed-packages/php722
    	fi
    	echo "Downloading $php"
        cd /mnt/c/srv/packages
    	wget -O $php.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $php_path 
        unzip $php.zip -d /mnt/c/srv/installed-packages/php722
    fi
    
    
    echo "Looking for $imagick"
    if [ -e /mnt/c/srv/packages/$imagick.zip ] ; then
    	echo "$imagick already exist"
    else
    	echo "Downloading: $imagick"
    	cd /mnt/c/srv/packages/
    	wget -O $imagick.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $imagick_path
        unzip $imagick.zip -d /mnt/c/srv/packages/
    fi
    
    
    echo "Looking for $redis"
    if [ -e /mnt/c/srv/packages/$redis.zip ] ; then
    	echo "$redis already exist"
    else

    	echo "Downloading: $redis"
    	cd /mnt/c/srv/packages/
    	wget -O $redis.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $redis_path
        unzip $redis.zip -d /mnt/c/srv/packages/
    fi


	if [ "$install_ffmpeg" = "Y" ]; then
    	echo "Looking for $ffmpeg"
    	if [ -e /mnt/c/srv/packages/$ffmpeg.zip ] ; then
    		echo "$ffmpeg already exist"
    	else

    		# Remove existing version
    		if [ -e /mnt/c/srv/installed-packages/ffmpeg ] ; then
    			sudo rm -R /mnt/c/srv/installed-packages/ffmpeg
    		fi

    		echo "Downloading: $ffmpeg"
    		cd /mnt/c/srv/packages/
    		wget -O $ffmpeg.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $ffmpeg_path 
    	    unzip $ffmpeg.zip -d /mnt/c/srv/installed-packages/ffmpeg
    	fi
	else
		echo "Skipping FFMPEG installation"
	fi
	if [ "$install_wkhtml" = "Y" ]; then 
		echo "Looking for $wkhtmltopdf"
    	if [ -e /mnt/c/srv/packages/$wkhtmltopdf.zip ] ; then
    		echo "$wkhtmltopdf already exist"
    	else

    		# Remove existing version
    		if [ -e /mnt/c/srv/installed-packages/wkhtmltopdf ] ; then
    			sudo rm -R /mnt/c/srv/installed-packages/wkhtmltopdf
    		fi

    		echo "Downloading: $wkhtmltopdf"
    		cd /mnt/c/srv/packages/
    		wget -O $wkhtmltopdf.zip --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" --load-cookies "/mnt/c/srv/cookies.txt" --header="Referer: https://parentnode.dk" $wkhtmltopdf_path 
    	    unzip $wkhtmltopdf.zip -d /mnt/c/srv/installed-packages/wkhtmltopdf
    	fi
	else
		echo "Skipping WKHTMLTOPDF installation"
	fi
    
	echo "Installing $vc_compiler"
	/mnt/c/srv/packages/$vc_compiler.exe /passive /norestart
	# Remove installer
	rm /mnt/c/srv/packages/$vc_compiler.exe

	if [ "$install_webserver_conf" = "Y" ]; then 
		echo "Installing $mariadb"
		sudo /mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\\srv\\packages\\$mariadb.msi" PASSWORD="$db_root_password" SERVICENAME="MariaDB" /qn
		# Remove installer
		rm /mnt/c/srv/packages/$mariadb.msi

		# Copy default apache config, before installing service to avoid error
		sudo rm "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
		sudo cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
		if [ ! -f "/mnt/c/srv/sites/apache/apache.conf" ]; then
		   echo "Adding apache config file to sites/apache/"
		   echo ""
		   cp "/mnt/c/srv/tools/conf/apache.conf" "/mnt/c/srv/sites/apache/apache.conf"
		fi
		sudo /mnt/c/srv/installed-packages/apache24/bin/httpd.exe -k install
	else 
		echo "Skipping Webserver installation"
	fi

	echo "Installing $imagick"
	/mnt/c/srv/packages/$imagick.exe /NOICONS /SILENT
	# Remove installer
	rm /mnt/c/srv/packages/$imagick.exe


	echo "Installing $redis"
	sudo /mnt/c/Windows/SysWOW64/msiexec.exe /i "C:\\srv\\packages\\$redis.msi" ADD_FIREWALL_RULE=1 /qn
	
	# Remove installer
	rm /mnt/c/srv/packages/$redis.msi


else 

	echo "Skipping Software installation"
fi



