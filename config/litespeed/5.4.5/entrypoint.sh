#!/bin/bash
wget -P /usr/local/lsws/conf http://license.litespeedtech.com/reseller/trial.key

chown 999:999 /usr/local/lsws/conf -R
chown 999:1000 /usr/local/lsws/admin/conf -R

$@
while true; do
	if ! /usr/local/lsws/bin/lswsctrl status | grep 'litespeed is running with PID *' > /dev/null; then
		break
	fi
	sleep 60
done

