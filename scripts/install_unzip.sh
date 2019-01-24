#!/bin/bash -e
# Install unzip to unpack downloaded packages
echo ""
echo "---Checking unzip---"
echo ""
install_unzip=$(unzip || echo "")
if [ "$install_unzip" = "" ]; then
	sudo apt-get --assume-yes install unzip
else
	echo ""
	echo "---unzip is installed---"
	echo ""
fi
echo ""
