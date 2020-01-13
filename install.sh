#!/bin/bash
. /opt/farm/scripts/init

remoteport=22
if [ "$6" != "" ]; then
	remoteport=$6
fi

if [ "$5" = "" ]; then
	echo "usage: $0 <local-port> <target-alias> <target-user> <target-key> <target-ip> [target-port]"
	exit 1
elif [ ! -d /etc/systemd/system ]; then
	echo "error: $OSVER is not supported"
	exit 1
elif ! [[ $1 =~ ^[0-9]+$ ]]; then
	echo "error: parameter 1 not numeric"
	exit 1
elif ! [[ $remoteport =~ ^[0-9]+$ ]]; then
	echo "error: parameter 6 not numeric"
	exit 1
elif ! [[ $2 =~ ^[a-z0-9-]+$ ]]; then
	echo "error: parameter 2 not conforming host alias format"
	exit 1
elif ! [[ $3 =~ ^[a-z0-9.-]+$ ]]; then
	echo "error: parameter 3 not conforming user format"
	exit 1
elif ! [[ $5 =~ ^[0-9.]+$ ]]; then
	echo "error: parameter 5 not conforming ip address format"
	exit 1
elif [ ! -f $4 ]; then
	echo "error: ssh key $4 not found"
	exit 1
elif [ -f /etc/default/secure-tunnel@$2 ]; then
	echo "error: tunnel for $2 already created"
	exit 1
fi

echo "TARGET=$5
LOCAL_ADDR=0.0.0.0
LOCAL_PORT=$1
REMOTE_PORT=$remoteport
REMOTE_USER=$3
KEY_FILE=$4
" >/etc/default/secure-tunnel@$2

systemctl start secure-tunnel@$2.service
sleep 1
systemctl enable secure-tunnel@$2.service
