#!/bin/bash -e
echo "Test of getting username"
source /mnt/c/srv/sites/parentnode/windows_environment/scripts/functions.sh
#if $SUDO_USER is root the script will exit
username="$(getUsername)"
if [ $username = "root" ];then
    echo "Current user can not be $username"
    echo "Exiting"
    exit 1
else
    echo "Current user is: $username"
fi
