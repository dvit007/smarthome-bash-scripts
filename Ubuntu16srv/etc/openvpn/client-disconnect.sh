#!/bin/bash

LOG_PREF="[OpenVPN script]:"

logger "${LOG_PREF} Start script ${0}"

message="$(echo -e "${LOG_PREF} Event [${common_name} disconnected      to: ${HOSTNAME} \\nRemote:  
${untrusted_ip} \\nVirtual: ${ifconfig_pool_remote_ip}]")"

logger $message

#Отключаем доступ в локальную сеть для всех пользователей
if [[ ${common_name} == "dvn" ]]
then
    /usr/bin/sudo /sbin/iptables -A FORWARD -j DROP
    logger "${LOG_PREF} System firewall change [denied access to the local network of server]"
fi

#echo $message

exit 0