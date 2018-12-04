echo ""
echo "--- Installing software ---"
echo ""

# Clean up
echo ""
echo "Cleaning up:"
sudo apt-get --assume-yes autoremove
echo ""

# Install unzip to unpack downloaded packages
echo ""
echo "Unzip"
echo ""
bash /mnt/c/srv/tools/scripts/install_unzip.sh

# Downloading and installing c++ compiler
echo ""
echo "C++ Compiler"
echo ""
bash /mnt/c/srv/tools/scripts/install_vc_compiler.sh

# Downloading and installing mariaDB
echo ""
echo "MariaDB"
echo ""
bash /mnt/c/srv/tools/scripts/install_mariadb.sh

# Downloading and installing php
echo ""
echo "PHP"
echo ""
bash /mnt/c/srv/tools/scripts/install_php.sh

# Downloading and installing apache
echo ""
echo "Apache"
echo ""
bash /mnt/c/srv/tools/scripts/install_apache.sh

# Downloading and installing imagick
echo ""
echo "ImageMagick"
echo ""
bash /mnt/c/srv/tools/scripts/install_imagick.sh

# Downloading and installing redis
echo ""
echo "Redis"
echo ""
bash /mnt/c/srv/tools/scripts/install_redis.sh

# Downloading and installing ffmpeg
echo ""
echo "FFMPEG"
echo ""
bash /mnt/c/srv/tools/scripts/install_ffmpeg.sh

# Downloading and installing wkhtmltopdf
echo ""
echo "WKHTML to PDF"
echo ""
bash /mnt/c/srv/tools/scripts/install_wkhtmltopdf.sh







