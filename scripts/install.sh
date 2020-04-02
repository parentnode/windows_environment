#!/bin/bash -e

source /mnt/c/srv/tools/scripts/functions.sh

enableSuperCow

outputHandler "section" "Installing parentNode in windows subsystem for linux"
outputHandler "comment" "DO NOT CLOSE UNTIL INSTALL ARE COMPLETE" "You will see 'Install complete' message once it's done"

. /mnt/c/srv/tools/scripts/pre_install_check.sh

. /mnt/c/srv/tools/scripts/checking_directories.sh

. /mnt/c/srv/tools/scripts/install_software.sh

. /mnt/c/srv/tools/scripts/post_install_setup.sh


outputHandler "comment" "Starting apache server"
sudo /mnt/c/Windows/System32/net.exe start Apache2.4 exit 2>/dev/null || echo ""


outputHandler "comment" "parentNode installed in windows subsystem for linux"
outputHandler "section" "Install complete"





