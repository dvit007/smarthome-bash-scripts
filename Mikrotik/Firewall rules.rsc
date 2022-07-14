# jul/12/2022 14:04:10 by RouterOS 6.49.5
# software id = 6XP7-DTY0
#
# model = RouterBOARD 750G r3
/ip firewall address-list
add address=192.168.1.26 comment="Arch linux" list=local_ip_for_vpn
add address=myip.com list=unlocking_hosts
add address=strana.best list=unlocking_hosts
add address=api.openweathermap.org list=unlocking_hosts
add address=play.google.com list=unlocking_hosts
add address=meduza.io list=unlocking_hosts
add address=netflix.com list=unlocking_hosts
add address=nflxso.net list=unlocking_hosts
add address=nflxext.com list=unlocking_hosts
add address=nflxvideo.net list=unlocking_hosts
add address=192.168.1.14 comment="LG TV 1,5" list=local_ip_for_vpn
add address=192.168.1.14 comment="LG TV 1,5" list=vpn_all_traffic
add address=192.168.1.26 comment="Arch linux" list=vpn_partial_traffic
/ip firewall filter
add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input comment="Port scanners to list " \
    protocol=tcp psd=21,3s,3,1
add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input comment="NMAP FIN Stealth scan" \
    protocol=tcp tcp-flags=fin,!syn,!rst,!psh,!ack,!urg
add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input comment="SYN/FIN scan" protocol=tcp \
    tcp-flags=fin,syn
add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input comment="SYN/RST scan" protocol=tcp \
    tcp-flags=syn,rst
add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input comment="FIN/PSH/URG scan" protocol=\
    tcp tcp-flags=fin,psh,urg,!syn,!rst,!ack
add action=accept chain=forward comment="Ipsec vpn disable fasttrack https://f\
    orum.mikrotik.com/viewtopic.php\?t=143990#p825682" dst-address-list=\
    !local_ip_for_vpn src-address-list=local_ip_for_vpn
add action=accept chain=forward dst-address-list=local_ip_for_vpn \
    src-address-list=!local_ip_for_vpn
add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input comment="ALL/ALL scan" protocol=tcp \
    tcp-flags=fin,syn,rst,psh,ack,urg
add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input comment="NMAP NULL scan" protocol=tcp \
    tcp-flags=!fin,!syn,!rst,!psh,!ack,!urg
add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=4w2d chain=input comment=\
    "SSH/RDP/WINBOX ports connect " connection-state=new dst-port=\
    22,3389,8291 in-interface=ether1 protocol=tcp
add action=drop chain=prerouting comment="dropping port scanners" \
    in-interface=ether1 src-address-list="port scanners"
add action=drop chain=input src-address-list="port scanners"
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment="ipsec conf" disabled=yes dst-address=\
    192.168.1.0/24 dst-port=500 in-interface=ether1 protocol=udp
add action=accept chain=input disabled=yes dst-address=192.168.1.0/24 \
    in-interface=ether1 protocol=ipsec-esp
add action=accept chain=input disabled=yes dst-address=192.168.1.0/24 \
    protocol=ipsec-ah
add action=drop chain=input comment="defconf: drop all not coming from LAN" \
    in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    disabled=yes ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    disabled=yes ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="Maks PC" disabled=yes src-mac-address=\
    4C:CC:6A:D9:4D:88 time=0s-7h,sun,mon,tue,wed,thu,fri,sat
add action=drop chain=forward comment="Maks Smartfone" disabled=yes \
    src-mac-address=18:F0:E4:1D:C4:7A time=0s-7h,sun,mon,tue,wed,thu,fri,sat
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
/ip firewall mangle
add action=change-mss chain=forward comment="Ipsec vpn change MSS to 1200 http\
    s://forum.mikrotik.com/viewtopic.php\?t=143990#p824590" dscp=0 new-mss=\
    1200 passthrough=yes protocol=tcp src-address-list=local_ip_for_vpn \
    tcp-flags=syn tcp-mss=!0-1200
/ip firewall nat
add action=src-nat chain=srcnat comment="IPsec vpn all traffic" disabled=yes \
    dst-address-list=!vpn_all_traffic src-address-list=vpn_all_traffic \
    to-addresses=192.168.43.9
add action=src-nat chain=srcnat comment="LG TV 1,5" dst-address=!192.168.1.14 \
    src-address=192.168.1.14 to-addresses=192.168.43.9
add action=dst-nat chain=dstnat comment=\
    "DNS over VPN https://forum.mikrotik.com/viewtopic.php\?t=155718" \
    dst-port=53 protocol=udp src-address-list=vpn_partial_traffic \
    to-addresses=192.168.43.9 to-ports=53
add action=src-nat chain=srcnat comment="IPsec vpn unlocked need sites https:/\
    /pcnews.ru/blogs/ikev2_tunnel_mezdu_mikrotik_i_strongswan_eap_ms_chapv2_i_\
    dostup_k_sajtam-1052312.html" dst-address-list=unlocking_hosts \
    src-address-list=vpn_partial_traffic to-addresses=192.168.43.9
add action=netmap chain=dstnat comment="USB serv VPN" disabled=yes dst-port=\
    1194 protocol=tcp to-addresses=192.168.1.21 to-ports=1194
add action=netmap chain=dstnat comment="OpenVPN on ubuntu16srv" disabled=yes \
    dst-port=1194 protocol=udp to-addresses=192.168.1.21 to-ports=1194
add action=netmap chain=dstnat dst-port=10394 protocol=udp to-addresses=\
    192.168.1.21 to-ports=1194
add action=netmap chain=dstnat comment="USB Redirector on Master" disabled=\
    yes dst-port=32032 protocol=tcp to-addresses=192.168.1.18 to-ports=32032
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
