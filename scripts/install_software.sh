echo ""
echo "--- Installing software ---"
echo ""

# Clean up
echo ""
echo "Cleaning up:"
sudo apt-get --assume-yes autoremove
echo ""

# Install unzip to unpack downloaded packages
bash /mnt/c/srv/tools/scripts/install_unzip.sh

# Downloading and installing c++ compiler
bash /mnt/c/srv/tools/scripts/install_vc_compiler.sh

# Downloading and installing mariaDB
bash /mnt/c/srv/tools/scripts/install_mariadb.sh

# Downloading and installing php
bash /mnt/c/srv/tools/scripts/install_php.sh

# Downloading and installing apache
bash /mnt/c/srv/tools/scripts/install_apache.sh


