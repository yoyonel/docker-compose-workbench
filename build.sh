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

# SSH Tunnel
source data/env.sh
echo "SSH tunnel (on port=$SSH_PORT, with key=$SSH_KEY_FOR_TUNNELING): $LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT with tunnel host on: $TUNNEL_HOST ..."
ssh \
	-o StrictHostKeyChecking=no \
	-i $SSH_KEY_FOR_TUNNELING \
	-N $TUNNEL_HOST \
	-L $LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT \
	-p $SSH_PORT \
	&
echo "SSH tunnel (on port=$SSH_PORT): $LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT with tunnel host on: $TUNNEL_HOST ... done"
PID_SSH_CMD=$!
echo "PID of SSH tunnel=$PID_SSH_CMD"

docker-compose up --build

echo "Kill ssh tunnel with pid=$PID_SSH_CMD ..."
kill -9 $PID_SSH_CMD
echo "Kill ssh tunnel with pid=$PID_SSH_CMD ... done"