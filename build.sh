#!/bin/bash

# X11 authentication
mkdir -p ./tmp
chmod 777 ./tmp
export XAUTH=./tmp/.docker.xauth resources
if [ ! -e $XAUTH ] ; then
	echo "Creating authentication file ${XAUTH}"
	touch $XAUTH
	chmod 777 $XAUTH
else
	echo "using X11 authentication file ${XAUTH}"
fi
echo "Granting X11 permissions"
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# sharing data (for export)
mkdir -p ./data
chmod 777 data

docker-compose up --build