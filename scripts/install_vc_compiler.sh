#!/bin/bash -e
echo ""
echo "---Looking for $vc_compiler---"
echo ""
if [ -e /mnt/c/srv/packages/$vc_compiler.zip ] || [ -e /mnt/c/srv/packages/$vc_compiler_alt ]; then
	echo ""
	echo "---$vc_compiler already exists---"
	echo ""
else
	echo ""
	echo "---Downloading $vc_compiler---"
	echo ""
	cd /mnt/c/srv/packages/
	wget -O $vc_compiler.zip $vc_compiler_path
	echo ""
	# Unpack zip
	unzip $vc_compiler.zip -d /mnt/c/srv/packages/
	echo ""
	echo ""
	echo "---Installing $vc_compiler---"
	echo ""
	/mnt/c/srv/packages/$vc_compiler.exe /passive /norestart
	echo ""
	echo ""
	echo "---Removing installer for $vc_compiler---"
	echo ""
	# Remove installer
	rm /mnt/c/srv/packages/$vc_compiler.exe
	echo ""
fi
echo ""