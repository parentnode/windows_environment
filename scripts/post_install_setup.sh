#!/bin/bash -e

echo "-----------------------------------------"
echo "--- Configuring Apache server and PHP ---"
echo "-----------------------------------------"

echo ""
echo "----------------------------------------------"
echo "Setting up php.ini and required files for CURL"
echo "----------------------------------------------"
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

echo "-----------------------------"
echo "--- Setting up httpd.conf ---"
echo "-----------------------------"

# Setting up httpd.conf
echo "Copying httpd config file to apache24/conf"
cp "/mnt/c/srv/tools/conf/httpd.conf" "/mnt/c/srv/installed-packages/apache24/conf/httpd.conf"
echo ""

echo "-----------------------"
echo "--- Adding SSL cert ---"
echo "-----------------------"

# Adding SSL cert
echo "Copying cacert.pem to installed-packages"
cp "/mnt/c/srv/tools/conf/cacert.pem" "/mnt/c/srv/installed-packages/cacert.pem"
echo ""