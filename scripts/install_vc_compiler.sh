# Setting c++ compiler name and download link"
vc_compiler="vc_redist-x64"
vc_compiler_path="https://parentnode.dk/download/72/HTML-ikg9m2me/vc_redist-x64.zip"
# Old file is also valid (and should not cause re-install)
vc_compiler_alt="VC_redist.x64.exe"
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