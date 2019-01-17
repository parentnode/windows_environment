#!/bin/bash -e
echo "Looking for $vc_compiler"
if [ -e /mnt/c/srv/packages/$vc_compiler.zip ] || [ -e /mnt/c/srv/packages/$vc_compiler_alt ]; then
	echo "$vc_compiler already exists"
else

	echo "Downloading $vc_compiler"
	cd /mnt/c/srv/packages/
	wget -O $vc_compiler.zip $vc_compiler_path

	# Unpack zip
	unzip $vc_compiler.zip -d /mnt/c/srv/packages/

	echo ""
	echo "Installing $vc_compiler"
	/mnt/c/srv/packages/$vc_compiler.exe /passive /norestart

	# Remove installer
	rm /mnt/c/srv/packages/$vc_compiler.exe

fi
echo ""