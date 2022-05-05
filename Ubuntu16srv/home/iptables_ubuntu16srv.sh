#!/bin/bash

########################################################################################
### Скрипт настривает правила встроеного файервола Net filters. Через него удобней   ###
### это сделать. Потому что не надо по отдельности вводит каждый вызов iptables.     ###
### Он запускается пользователем вручную командовй ./iptables_ubuntu16srv.sh         ###
### Параметры ему не передаются                                                      ###
########################################################################################



export IPT="iptables"

# Внешний интерфейс
#export WAN=ens18
#export WAN_IP=10.20.1.38

# Локальная сеть
export LAN1=ens3
export LAN1_IP_RANGE=192.168.1.0/24

$IPT -F
$IPT -F -t nat
$IPT -F -t mangle
$IPT -X
$IPT -t nat -X
$IPT -t mangle -X

# Разрешаем все соединения. Закрывать их будем отдельным правилом в самом конце
$IPT -P INPUT ACCEPT
$IPT -P OUTPUT ACCEPT
$IPT -P FORWARD ACCEPT


# Разрешаем localhost и локалку
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A INPUT -i $LAN1 -j ACCEPT
#$IPT -A OUTPUT -o lo -j ACCEPT
#$IPT -A OUTPUT -o $LAN1 -j ACCEPT

# Рзрешаем пинги
$IPT -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type echo-request -j ACCEPT


# Разрешаем установленные подключения
$IPT -A INPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A OUTPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p all -m state --state ESTABLISHED,RELATED -j ACCEPT

# Отбрасываем неопознанные пакеты
$IPT -A INPUT -m state --state INVALID -j DROP
$IPT -A FORWARD -m state --state INVALID -j DROP

# Отбрасываем нулевые пакеты
$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Закрываемся от syn-flood атак
$IPT -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
$IPT -A OUTPUT -p tcp ! --syn -m state --state NEW -j DROP


# Разрешаем доступ из сети клиента в локальную сеть vpn
#$IPT -A FORWARD -i tun0 -s 10.8.0.0/24 -d 192.168.1.0/24 -j ACCEPT
# Разрешаем доступ в локальную сеть только к USB Redirecor
$IPT -A FORWARD -i tun0 -p tcp -s 10.8.0.0/24 -d 192.168.1.18 --dport 32032 -j ACCEPT

# Логировать пакеты со статусом INVALID:
#$IPT -A INPUT -m state --state INVALID -j LOG --log-prefix "Iptables: Invalid packet: "
# Логировать INPUT пакеты, которые не попали ни в одно правило:
#$IPT -A INPUT -m limit --limit 3/minute --limit-burst 3 -j LOG --log-prefix "Iptables: INPUT packet died: "
# Логировать FORWARD пакеты, которые не попали ни в одно правило:
#$IPT -A FORWARD -m limit --limit 3/minute --limit-burst 3 -j LOG --log-prefix "Iptables: FORWARD packet died: "


# Включаем NAT
$IPT -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE

# открываем доступ к SSH из локальной сети
$IPT -A INPUT -i $LAN1 -p tcp --dport 22 -j ACCEPT

# Открываем порт для openvpn
$IPT -A INPUT -p udp --dport 1194 -j ACCEPT

#Открываем порт для USB Redirecor
$IPT -A INPUT -p tcp --dport 32032 -j ACCEPT


#Запрещаем остальной входящий трафик, который дошел до этого правила
$IPT -A INPUT -j DROP
#Запрещаем остальной транзитный трафик, который дощел до этого правила
$IPT -A FORWARD -j DROP

# Сохраняем правила
/sbin/iptables-save  > /etc/iptables/rules.v4
