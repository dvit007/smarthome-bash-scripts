#!/bin/bash

#date_stamp=$(date +%Y%m%d-%Hh%Mm)
date_stamp=$(date +%Y-%m-%d)

#Backup folder
tar -czpf /vm/backup/Host/home_master_$date_stamp.tar.gz /home/master

tar -czpf /vm/backup/Host/etc_$date_stamp.tar.gz /etc/

tar -czpf /vm/backup/Host/opt_$date_stamp.tar.gz /opt/

tar --exclude='/var/log/*' --exclude='/var/tmp/*' --exclude='/var/backups/*' --exclude='/var/lost+found/*' -czpf /vm/backup/Host/var_$date_stamp.tar.gz /var/

#Backup list install pakages
dpkg --get-selections | grep -v deinstall > /vm/backup/Host/list_install_pakages_$date_stamp.txt

#Delete old files
/usr/bin/find /vm/backup/Host/ -type f -mtime +1 -exec rm -rf {} \;