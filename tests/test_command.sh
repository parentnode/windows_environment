#!/bin/bash -e
source /mnt/c/srv/sites/parentnode/windows_environment/scripts/functions.sh
# Check if program/service are installed
echo "Testing testCommand"
echo 
valid_status=("Running" "Stopped")
echo "Checking Apache2.4 status: "
testCommand "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe Get-Service Apache2.4" "${valid_status[@]}"
echo
echo "Checking Redis status: "
testCommand "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe Get-Service Redis" "${valid_status[@]}"
echo
echo "Checking unzip version: "
valid_version=("^UnZip ([6\.[0-9])")
testCommand "unzip -v" "${valid_version[@]}"

# Usage: returns a true if a program or service are located in the installed services or programs
# P1: kommando
# P2: array of valid responses
