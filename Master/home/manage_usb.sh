#!/bin/bash

########################################################################################
### Скрипт реализующий доступ к USB устройствам в зависимости от ролей пользователей ###
### Он вызывается из сервера OpenHab. Ему надо передать один параметр - Роль пользов.###
### Роль "1" - для всех неавторизванных пользователей                                ###
### Роль "2" - Бухгалтер. Роль "3" - Мастре ему доступны все устройства              ###
### Роли настраиваюся в правилах OpenHab                                             ###
########################################################################################

USB_1="-vid 0a89 -pid 0025 -usb-port 1-7.1" #Aktiv Rutoken lite FNS IP/Velkom
USB_2="-vid 0a89 -pid 0025 -usb-port 5-2"   #Aktiv Rutoken lite FNS Veles KAU
USB_3="-vid 0a89 -pid 0030 -usb-port 1-7.4" #Aktiv Rutoken ESP URALSIB IP/Velkom/Veles KAU

USB_4="-vid 0a89 -pid 0030 -usb-port 1-7.3" #Aktiv Rutoken ESP URALSIB IP/Velkom DVN

#USB_5="-vid 0529 -pid 0001 -usb-port 1-7.2" #AKS HASP 2.17


#Отключаем все устройства
usbsrv -unshare $USB_1
usbsrv -unshare $USB_2
usbsrv -unshare $USB_3
usbsrv -unshare $USB_4
#usbsrv -unshare $USB_5

#Подключаем устройства доступные всем
usbsrv -share $USB_1
usbsrv -share $USB_2
usbsrv -share $USB_3

#Подключаем устройства доступные для роли Бухгалтер
if [[ $1 == "2"  ]] || [[ $1 == "3" ]]
then
    usbsrv -share $USB_4
    #usbsrv -share $USB_3
    #usbsrv -share $USB_5
fi

#Подключаем оставшиеся устройства доступные для роли Мастер
#if [[ $1 == "3" ]]
#then
    #usbsrv -share $USB_5
#fi
