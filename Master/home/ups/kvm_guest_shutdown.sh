#!/bin/bash

########################################################################################
### Скрипт реализующий корректное выключение гостевых ОС.                            ###
### Он вызывается из скриптов службы NUT.                                            ###
### Ему передаются параметры:                                                        ###
### --shutdown отключение госетвых машин и выключение Хоста                          ###
### --reboot отклювение гоствых машин и перезагрузка Хоста                           ###
########################################################################################


shutdown_guests(){
LIST_VM=`virsh list | grep running | awk '{print $2}'`
TIMEOUT=90
#DATE=`date -R`
#LOGFILE="/home/master/kvm_guest_shutdown.log"
#if [[ ! -e $LOGFILE ]]; then
#        touch $LOGFILE
        #echo "$LOGFILE created" 1>&2
#elif [[ ! -d $LOGFILE ]]; then
#        echo "$DATE : Start script" >> $LOGFILE
#fi

logger "UPS guest systems shutdown script start"

for activevm in $LIST_VM
do
        PIDNO=`ps ax | grep $activevm | grep kvm | cut -c 1-6 | head -n1`
        logger "UPS shutdown guest OS : $activevm : $PIDNO"
        virsh shutdown $activevm > /dev/null
        sleep 5
        #COUNT=0
        #while [ "$COUNT" -lt "$TIMEOUT" ]
        #do
        #        ps --pid $PIDNO > /dev/null
        #        if [ "$?" -eq "1" ]
        #                then
        #                COUNT=110
        #        else
        #                sleep 5
        #                COUNT=$(($COUNT+5))
        #        fi
        #done
        #if [ $COUNT -lt 110 ]
        #        then
        #        logger "$activevm not successful force shutdown"
        #        #virsh destroy $activevm > /dev/null
        #fi
done
}
note(){
        echo -e "--------------------------------------------------------\n"
        echo -e "\nYou need usage script with arguments: --reboot ot --shutdown:\n\n $0 --shutdown\n"
        exit 1
}
reboot_node(){
        reboot
}

shutdown_node(){
        systemctl poweroff -i
}


if [ $# -ne 1 ]; then
    note
fi

for i in "$@" ; do

    if [[ $i == "--reboot" ]] ; then
        shutdown_guests
        logger "UPS reboot Host OS"
        sleep 15
        reboot_node
        break
    fi

    if [[ $i == "--shutdown" ]] ; then
        shutdown_guests
        logger "UPS shutdown Host OS"
        sleep 15
        shutdown_node
        break
    fi

done
