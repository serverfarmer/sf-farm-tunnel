#!/bin/sh

if [ -d /etc/systemd/system ] && [ ! -f /etc/systemd/system/secure-tunnel@.service ]; then
	cp -af /opt/farm/ext/farm-proxy/templates/secure-tunnel@.service /etc/systemd/system
	systemctl daemon-reload
fi
