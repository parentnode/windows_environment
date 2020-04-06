#!/bin/bash -e
source /mnt/c/srv/sites/parentnode/windows_environment/scripts/functions.sh
echo ""
echo "Get username test"
echo ""

username="$(getUsername)"
echo "Current user is: $username"