#!/bin/bash

#Скрипт копирует резервные копии на второй диск сервера 

#rm -r /backup/partial/Host/
#rm -r /backup/partial/SmartHome/
#rm -r /backup/partial/ubuntu16srv/
#rm -r /backup/partial/win7pro/

#rsync -ra /vm/backup/ /backup/partial/

#cp -rp /vm/backup/. /backup/partial/


#Copy files to /backup/partial/
rsync -a -r --quiet /vm/backup/ /backup/partial/

#Копия из которой удалены файлы, отсутствующие в Источнике
#rsync -a -r --delete --quiet /vm/backup/ /backup/partial/

#Delete files older 14 days
days=13
/usr/bin/find /backup/partial/Host/ -type f -mtime +$days -exec rm -rf {} \;
/usr/bin/find /backup/partial/SmartHome/ -type f -mtime +$days -exec rm -rf {} \;
/usr/bin/find /backup/partial/ubuntu16srv/ -type f -mtime +$days -exec rm -rf {} \;
#/usr/bin/find /backup/partial/win7pro/ -type f -mtime +$days -exec rm -rf {} \;
/usr/bin/find /backup/partial/SmartHome/Openhab/ -type f -mtime +$days -exec rm -rf {} \;


#https://wiki.archlinux.org/title/Rsync_(Русский)


#TO-DO
#Add this script in crontab -e of Master 