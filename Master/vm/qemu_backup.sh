#!/bin/bash

### Script start from Cron

#Источник https://winitpro.ru/index.php/2020/03/04/backup-virtualnyx-mashin-v-kvm/

#Скрипт делает резервные копии виртуалок c их остановой и последюущим запуском
#Если ему передать имя VM, он сделает бэкап этой виртуалки
#Если параметров нет, тогда он делает бэкап всех работающих VM


log_pref="[Qemu backup]"

logger -i "$log_pref Start script"

data=`date +%Y-%m-%d`
backup_dir=/vm/backup
openhab_path=/video/openhab/

if [ $# -eq 0 ]; then
  echo "No arguments. Backup all active domains"
  vm=`virsh list | grep . | awk '{print $2}'| sed 1,2d | tr -s '\n' ' '`
else
 echo "Backup domain $1"
 vm=$1 
fi

for activevm in $vm
do
   vm_state=$(virsh list --all | grep $activevm | awk '{print $3$4}')
   echo "Processing $activevm [$vm_state]"
      
   mkdir -p $backup_dir/$activevm
	
   # Бэкапим конфигурацию XML для виртуальной машины
   virsh dumpxml $activevm > $backup_dir/$activevm/$activevm-$data.xml
	
   # Получаем пути дисков виртуальных машин. Выбираем только которые находятся в /vm/vhdd/
   # диски в других местах не бэкапятся.
   # В первоисточнике выбирались диски котоыре содержат grep vd 
   disk_path=`virsh domblklist $activevm | grep "/vm/vhdd/" | awk '{print $2}'`
	
   # Останавливаем виртуальную машину если она включена
   if [[ $vm_state == "running" ]]
   then
     #echo "Stopping"
     virsh shutdown $activevm
     sleep 5
   fi	
	
   for path in $disk_path
   do
	# Убираем имя файла из пути
	filename=`basename $path`
	# Создаем бэкап диска
        echo "Create backup..."
	logger -i "$log_pref Create backup domain $activevm"
	gzip -c $path > $backup_dir/$activevm/$filename-$data.gz
	sleep 2
  done
  
  #Создим резервную копию Openhab пока выключен сервер SmartHome
  if [[ $activevm == "SmartHome" ]]
  then
    #gzip -c $openhab_path > $backup_dir/$activevm/openhab_backup-$data.gz
    tar -czpf $backup_dir/$activevm/Openhab/openhab_backup-$data.tar.gz $openhab_path
  fi

  #Запускаем виртуальную машину если она была включена
  if [[ $vm_state == "running" ]]
  then
    #echo "Starting"
    virsh start $activevm
    sleep 5
  fi

  #Удаляем лишние копии 
  echo "Remove old files"
  /usr/bin/find $backup_dir/$activevm/ -type f -mtime +1 -exec rm -rf {} \;
  #Удаление лишних файлов с резернвыми копиями Openhab
  /usr/bin/find $backup_dir/$activevm/Openhab/ -type f -mtime +1 -exec rm -rf {} \;  

done

#Удаляем лишнии копии
#echo "Remove old files"

#/usr/bin/find /vm/backup/ -type f -mtime +2 -exec rm -rf {} \;
#/usr/bin/find $backup_dir -type f -mtime +2 -exec rm -rf {} \;

