#!/bin/bash

logger -i "UPS start script:<$0>  with param:[$1] "

case $1 in
      commbad)
      logger -i "UPS communications failure"
      #Изменим состояние в Openhab
      curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "4" "http://192.168.1.3:8080/rest/items/UPS_State"
      ;;
      commok)
      logger  -i "UPS communications restored"
      #Изменим состояние в Openhab
      curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "1" "http://192.168.1.3:8080/rest/items/UPS_State"
      ;;
      nocomm)
      logger  -i "UPS communications cannot be established"
      #Изменим состояние в Openhab
      curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "4" "http://192.168.1.3:8080/rest/items/UPS_State"
      ;;
      powerout)
      logger -i "UPS on battery. Shutdown in 2 minute"
      #Изменим состояния в Openhab
      curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "2" "http://192.168.1.3:8080/rest/items/UPS_State"
      #upscmd -u upsmonitor -p UPSPASS ippon@localhost shutdown.return
      ;;
      shutdownnow)
      logger -i "UPS has been on battery 2 minute. Starting orderly shutdown"
      #Чтобы скрипт работал, его надо запускать от имени root. 
      #Чтобы делать это без пароля надо добавить разрешение в /etc/sodoers.d/100-nut.conf 
      sudo /home/master/ups/kvm_guest_shutdown.sh --shutdown
      #logger "UPS Guest systems off"
      sleep 5
      logger -i "UPS Host start shutdown"
      #Изменим состояние в Openhab
      curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "0" "http://192.168.1.3:8080/rest/items/UPS_State"
      #upscmd -u upsmonitor -p UPSPASS ippon@localhost shutdown.return
      #sudo systemctl poweroff -i
      #sudo /sbin/shutdown -h now
      upsmon -c fsd
      ;;
      powerup)
      logger -i "UPS on line. Shutdown aborted."
      #Изменим состояние в Openhab
      curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "1" "http://192.168.1.3:8080/rest/items/UPS_State"
      upscmd -u upsmonitor -p UPSPASS ippon@localhost shutdown.stop
      ;;
      #replbatt)
      #logger -i "UPS warning. Battery needs to be replaced"
      #curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "5" "http://192.168.1.3:8080/rest/items/UPS_State"
      #;;
      #shutdownstart)
      #logger -i "UPS shutdown now"
      #curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "0" "http://192.168.1.3:8080/rest/items/UPS_State"
      #;;
      *)
      logger -i "UPS unrecognized command:$1"
      ;;
esac