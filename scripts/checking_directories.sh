#!/bin/bash -e


# Base parentnode project location
if [ -e /mnt/c/srv/sites/parentnode ] ; then
	echo "C:/srv/sites/parentnode already exists"
else
	echo "Create directory C:/srv/sites/parentnode"
    mkdir -p /mnt/c/srv/sites/parentnode;
fi;

# Base apache configuration location
if [ -e /mnt/c/srv/sites/apache/logs ] ; then
	echo "C:/srv/sites/apache/logs already exists"
else
	echo "Create directory C:/srv/sites/apache/logs"
    mkdir -p /mnt/c/srv/sites/apache/logs;
fi;

# Creating packages folder
if [ -e /mnt/c/srv/packages ] ; then
	echo "C:/srv/packages already exists"
else
	echo "Create directory C:/srv/packages"
    mkdir -p /mnt/c/srv/packages;
fi;

# Creating installed-packages folder
if [ -e /mnt/c/srv/installed-packages ] ; then
	echo "C:/srv/installed-packages already exists"
else
	echo "Create directory C:/srv/installed-packages"
    mkdir -p /mnt/c/srv/installed-packages;
fi;
echo ""

