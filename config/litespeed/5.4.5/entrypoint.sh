#!/bin/bash
rm -f /usr/local/lsws/conf/trial.key*
wget -P /usr/local/lsws/conf http://license.litespeedtech.com/reseller/trial.key
chown 999:999 /usr/local/lsws/conf -R
chown 999:1000 /usr/local/lsws/admin/conf -R
/usr/local/lsws/bin/lswsctrl stop
/usr/local/lsws/bin/lswsctrl start
/usr/local/lsws/bin/lswsctrl status