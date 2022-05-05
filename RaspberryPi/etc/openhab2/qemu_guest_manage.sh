#!/bin/bash
#USB_1="-vid 0a89 -pid 0025 -usb-port 1-7.1" #Aktiv Rutoken lite
#USB_2="-vid 0529 -pid 0620 -usb-port 1-7.3" #Aladdin Token JC Etoken Велес/Велком
#USB_3="-vid 0529 -pid 0620 -usb-port 1-7.4" #Aladdin Token JC URALSIB ИП
#USB_4="-vid 0529 -pid 0001 -usb-port 1-7.2" #AKS HASP 2.17

if [[ $1 == "ubuntu16srv" ]]
then
        if [[ $2 == "start" ]]
        then
         #Запускаем сервер
         ssh master@192.168.1.18 -tt 'bash -l -c "virsh start ubuntu16srv"'
         #sleep 2
         case "$3" in
            "1")
                ssh master@192.168.1.18 -tt 'bash -l -c "/home/master/manage_usb.sh 1"'
                ;;          
            "2")
                ssh master@192.168.1.18 -tt 'bash -l -c "/home/master/manage_usb.sh 2"'
                ;;          
            "3")
                ssh master@192.168.1.18 -tt 'bash -l -c "/home/master/manage_usb.sh 3"'
                ;;
             *)
                ssh master@192.168.1.18 -tt 'bash -l -c "/home/master/manage_usb.sh 1"'
                ;;          
         esac
         
         #Отключим все USB устройства
         #Aktiv Rutoken lite
         #ssh master@192.168.1.18 -tt 'bash -l -c "usbsrv -unshare -vid 0a89 -pid 0025 -usb-port 1-7.1"'
         #sleep 2
         #Aladdin Token JC 1
         #ssh master@192.168.1.18 -tt 'bash -l -c "usbsrv -unshare -vid 0529 -pid 0620 -usb-port 1-7.3"'
         #sleep 2
         #Aladdin Token JC 2
         #ssh master@192.168.1.18 -tt 'bash -l -c "usbsrv -unshare -vid 0529 -pid 0620 -usb-port 1-7.4"'
         #sleep 2
         #AKS HASP 2.17
         #ssh master@192.168.1.18 -tt 'bash -l -c "usbsrv -unshare -vid 0529 -pid 0001 -usb-port 1-7.2"' 
         #sleep 2

         ##Инициализурем устройства из набора 1 
         #Aktiv Rutoken lite       
         #ssh master@192.168.1.18 -tt 'bash -l -c "usbsrv -share -vid 0a89 -pid 0025 -usb-port 1-7.1"'
         #sleep 2 

         #if [[ $3 == "2" ]]||[[ $3 == "3" ]] #Действия общие для ролей Бухгалтер и Мастер
         #then
                #Инициализурем устройства из набора 2
                #Aladdin Token JC 1
                #ssh master@192.168.1.18 -tt 'bash -l -c "usbsrv -share -vid 0529 -pid 0620 -usb-port 1-7.3"'
                #sleep 2
                #Aladdin Token JC 2
                #ssh master@192.168.1.18 -tt 'bash -l -c "usbsrv -share -vid 0529 -pid 0620 -usb-port 1-7.4"'
                #sleep 2
         #fi

         #if [[ $3 == "3" ]] #Действия для роли Мастер
         #then
                #Инициализиурем устройтсва из набора 3
                #AKS HASP 2.17
                #ssh master@192.168.1.18 -tt 'bash -l -c "usbsrv -share -vid 0529 -pid 0001 -usb-port 1-7.2"' 
         #fi       
        fi

        if [[ $2 == "shutdown" ]]
        then
         ssh master@192.168.1.18 -tt 'bash -l -c "virsh shutdown ubuntu16srv"'
        fi
fi