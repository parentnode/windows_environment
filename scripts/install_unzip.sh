#!/bin/bash -e
# Install unzip to unpack downloaded packages
echo "Checking unzip:"
install_unzip=$(unzip || echo "")
if [ "$install_unzip" = "" ]; then
	sudo apt-get --assume-yes install unzip
else
	echo "unzip is installed"
fi

