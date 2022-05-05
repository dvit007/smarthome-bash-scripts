#!/bin/bash

LOG_PREF="[OpenVPN script]:"

logger "${LOG_PREF} Start script ${0}"

message="$(echo -e "${LOG_PREF} Event [${common_name} connected      to: ${HOSTNAME} \\nRemote:  
${untrusted_ip} \\nVirtual: ${ifconfig_pool_remote_ip}]")"

logger $message

#Разрешим пользователю с именем dvn доступ в локальную сеть сервера vpn
if [[ ${common_name} == "dvn" ]]
then
    /usr/bin/sudo /sbin/iptables -D FORWARD -j DROP
    logger "${LOG_PREF} System firewall change [allowed access to the local network of server]"
fi

#echo $message

exit 0