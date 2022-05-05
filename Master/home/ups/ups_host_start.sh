#!/bin/bash

#Получим статут ИБП
ups_state=$(upsc ippon ups.status 2>&1 | grep -v SSL)

logger -i "UPS start script $0"
logger -i "UPS state: ${ups_state}"

#Изменим состояние в Openhab
curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "${ups_state}" "http://192.168.1.3:8080/rest/items/UPS_State"
