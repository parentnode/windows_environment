#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "          SET UP APACHE/PHP/MARIADB"
echo
echo
echo

#"C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf"

if test "$install_webserver_conf" = "Y"; then

	echo
	echo "Configuring Apache and PHP"
	echo
	echo


	install_apache_servername=$(grep -E "^ServerName" "C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf" || echo "")
	if [ -z "$install_apache_servername" ]; then

		# SET SERVERNAME
		echo "ServerName $HOSTNAME" >> "C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf"


	else

		sed -i "s/^ServerName\ [a-zA-Z0-9\.\_-]\+/ServerName\ $HOSTNAME/;" "C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf"


	fi

	# remove path (slashes) from output to avoid problem with testing string
	#install_parentnode_includes=$(grep "^IncludeOptional \/srv\/conf\/\*\.conf" "C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf" | sed "s/\/srv\/conf\/\*\.conf//;" || echo "")
	# TODO: match does not work in windows
	install_parentnode_includes=$(grep "^IncludeOptional C\:\\srv\\conf\\*\.conf" "C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf" | sed "s/\/srv\/conf\/\*\.conf//;" || echo "")
	if test -z "$install_parentnode_includes"; then

		# ADD GIT CONF SETUP
		echo "IncludeOptional C:\srv\conf\*.conf" >> "C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf" 

	fi

	# PHP handler in Apache conf
	install_PHP_handler=$(grep "^AddHandler application\/x-httpd-php \.php" || echo "")
	if test -z "$install_PHP_handler"; then

		# ADD GIT CONF SETUP
		echo "AddHandler application/x-httpd-php .php" >> "C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf" 
		echo "AddType application/x-httpd-php .php" >> "C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf" 
		echo "LoadModule php7_module \"C:/tools/php71/php7apache2_4.dll\"" >> "C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf" 
		echo "PHPIniDir \"C:/tools/php71\"" >> "C:\Users\clevo\AppData\Roaming\Apache24\conf\httpd.conf" 

	fi

	# # ADD DEFAULT APACHE CONF
	# cat /srv/tools/_conf/default.conf > /etc/apache2/sites-available/default.conf
	# # REPLACE EMAIL WITH PREVIOUSLY STATED EMAIL
	# sed -i "s/webmaster@localhost/$install_email/;" /etc/apache2/sites-available/default.conf
	

	# # ADD APACHE MODULES
	# a2enmod ssl
	# a2enmod rewrite
	# a2enmod headers

	# # ENABLE DEFAULT SITE
	# a2ensite default
	# # DISABLE ORG DEFAULT SITE
	# a2dissite 000-default


	# # UPDATE PHP CONF
	# # PHP 5
	# #cat /srv/tools/_conf/php-apache2.ini > /etc/php5/apache2/php.ini
	# #cat /srv/tools/_conf/php-cli.ini > /etc/php5/cli/php.ini

	# # PHP 7.0
	# cat /srv/tools/_conf/php-apache2.ini > /etc/php/7.0/apache2/php.ini
	# cat /srv/tools/_conf/php-cli.ini > /etc/php/7.0/cli/php.ini

	# # PHP 7.1
	# #cat /srv/tools/_conf/php-apache2.ini > /etc/php/7.1/apache2/php.ini
	cat "C:\srv\sites\parentnode\windows_environment\_conf\php.ini" > "C:\tools\php71\php.ini"



	# echo
	# echo "Restarting Apache"
	# echo
	# echo

	# # RESTART APACHE
	# service apache2 restart

Restart-Service Apache
	# echo
	# echo "Configuring MariaDB"
	# echo
	# echo


	# # Do we have root password
	# if [ -n "$db_root_password" ]; then

	# 	# Checking mysql login - trying to log in without password (UBUNTU 16.04)
	# 	dbstatus=$(sudo mysql --user=root -e exit 2>/dev/null || echo 1)

	# 	# Checking mysql login - trying to log in with temp password (UBUNTU 14.04)
	# 	#dbstatus=$(sudo mysql --user=root --password=temp -e exit 2>/dev/null || echo 1)

	# 	# Login was successful - it means that DB was not set up yet
	# 	if [ -z "$dbstatus" ]; then

	# 		# set login mode (mysql_native_password) and password for root account
	# 		#echo "UPDATE mysql.user SET plugin = '', password = PASSWORD('$db_root_password') WHERE user = 'root'; FLUSH PRIVILEGES;" | sudo mysql -u root -ptemp

	# 		# FOR UBUNTU 16.04/MariaDB 10
	# 		echo "UPDATE mysql.user SET plugin = 'mysql_native_password', password = PASSWORD('$db_root_password') WHERE user = 'root'; FLUSH PRIVILEGES;" | sudo mysql -u root

	# 		# REPLACE PASSWORD FOR MAINTANENCE ACCOUNT
	# 		sudo sed -i "s/password = .\*/password = $db_root_password/;" /etc/mysql/debian.cnf

	# 		echo "DB Root access configured"

	# 	fi

	# fi


	echo
	echo



else

	echo
	echo "Skipping Webserver configuration"
	echo
	echo

fi
