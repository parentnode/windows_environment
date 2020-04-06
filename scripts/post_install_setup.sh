#!/bin/bash -e
outputHandler "section" "Setting up configuration files for the webserver"
outputHandler "comment"  "Configuring Apache server and PHP"

outputHandler "comment" "Setting up php.ini and required files for CURL"
# Setting up php.ini
outputHandler "comment" "Copying php.ini to php722/php.ini"
cp "/mnt/c/srv/tools/conf/php.ini" "/mnt/c/srv/installed-packages/php722/php.ini"



# Setting up php.ini (and required files for CURL)
outputHandler "comment" "Copying libeay32.dll and ssleay32.dll to apache24/bin"
cp "/mnt/c/srv/installed-packages/php722/libeay32.dll" "/mnt/c/srv/installed-packages/apache24/bin/libeay32.dll"
cp "/mnt/c/srv/installed-packages/php722/ssleay32.dll" "/mnt/c/srv/installed-packages/apache24/bin/ssleay32.dll"

outputHandler "comment" "Setting up httpd.conf"
# Setting up httpd.conf
#outputHandler "comment" "Copying httpd config file to apache24/conf"
#cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
cp -r "/mnt/c/srv/tools/conf/ssl" "/mnt/c/srv/sites/apache/"
outputHandler "comment" "Adding SSL cert"

# Adding SSL cert
outputHandler "comment" "Copying cacert.pem to installed-packages"
cp "/mnt/c/srv/tools/conf/cacert.pem" "/mnt/c/srv/installed-packages/cacert.pem"