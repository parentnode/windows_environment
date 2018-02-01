#!/bin/bash -e
# $shell = New-Object -ComObject shell.application
# $zip = $shell.NameSpace("C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64.zip")
# foreach ($item in $zip.items()) {
#   $shell.Namespace("C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64").CopyHere($item)
# }
# $shell_app=new-object -com shell.application
# $filename = "C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64.zip"
# $zip_file = $shell_app.namespace((Get-Location).Path + "\$filename")
# $destination = $shell_app.namespace((Get-Location).Path)
# $destination.Copyhere($zip_file.items())


# $shell_app=new-object -com shell.application
# $filename = "test.zip"
# $zip_file = $shell_app.namespace((Get-Location).Path + "\$filename")
# $destination = $shell_app.namespace((Get-Location).Path)
# $destination.Copyhere($zip_file.items())

# read -p "Install software 1(Y/n): " install_software
# #$shell_app=New-Object -com shell.application
# $shell_app = New-Object -ComObject shell.application
# #Define Zip file and destination folder
# read -p "Install software 11(Y/n): " install_software
# $zip_file = $shell_app.namespace("C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64.zip")
# read -p "Install software 2 (Y/n): " install_software
# $destination = $shell_app.namespace("C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64") 
# read -p "Install software 3 (Y/n): " install_software
# #Start timer
# #"Start (s)"
# #“$(Get-Date -Uformat %s)"
# $start_time = $(Get-Date -Uformat %s)
# read -p "Install software 4 (Y/n): " install_software
# #Unzip
# $destination.Copyhere($zip_file.items())  #Unzip the files
# read -p "Install software 5 (Y/n): " install_software
# #Stop timer
# #"Finish (s)"
# #“$(Get-Date -Uformat %s)"
# $end_time = $(Get-Date -Uformat %s)
# read -p "Install software 6(Y/n): " install_software
# #Calculate elapsed time
# $elapsed_time = $end_time - $start_time
# read -p "Install software 7 (Y/n): " install_software
# “Elapsed time ($elapsed_time)” 



####
#read -p "Install software 1(Y/n): " install_software
#$zip_file1 = "C:\PHP_zip.zip"

#[System.IO.Compression.ZipFile]::ExtractToDirectory(Get-Item("C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64.zip"), Get-Item("C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64"))
 #Define Zip file and destination folder
read -p "Install software 123(Y/n): " install_software
#Expand-ZIPFile –File “C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64.zip” –Destination “C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64”
#New-Item –Path $Profile –Type File –Force
 

# function Expand-ZIPFile($file, $destination)
# {
# $shell = new-object -com shell.application
# $zip = $shell.NameSpace($file)
# foreach($item in $zip.items())
# {
# $shell.Namespace($destination).copyhere($item)
# }
# }
  #choco install unzip 
  read -p "Install software 2 (Y/n): " install_software
(New-Object Net.WebClient).DownloadFile('http://download.sysinternals.com/Files/SysinternalsSuite.zip','C:\Tools\SysinternalsSuite.zip');
 read -p "Install software 2 (Y/n): " install_software
(new-object -com shell.application).namespace('C:\Tools').CopyHere((new-object -com shell.application).namespace('C:\Tools\SysinternalsSuite.zip').Items(),16)




#$toolsDir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
 read -p "Install software 2 (Y/n): " install_software
#Get-ChocolateyUnzip -FileFullPath "C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64.zip" -Destination $toolsDir
read -p "Install software 3 (Y/n): " install_software
#$zip_file = (Get-Item -force -LiteralPath "C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64.zip").FullName


$destination = Get-Item "C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64.zip"

# #Start timer
# #"Start (s)"
# #“$(Get-Date -Uformat %s)"
# $start_time = $(Get-Date -Uformat %s)
# #Unzip
 #[System.IO.Compression.ZipFile]::ExtractToDirectory((-Path "C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64.zip"), (Get-Item "C:\Users\clevo\AppData\Roaming\php-7.1.11-nts-Win32-VC14-x64")
 [System.IO.Compression.ZipFile]::ExtractToDirectory($zip_file, $destination)

 read -p "Install software 4 (Y/n): " install_software

# #Stop timer
# #"Finish (s)"
# #“$(Get-Date -Uformat %s)"
# $end_time = $(Get-Date -Uformat %s)

# #Calculate elapsed time
# $elapsed_time = $end_time - $start_time
# “Elapsed time ($elapsed_time)" 


read -p "Install software Last one (Y/n): " install_software