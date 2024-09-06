#!/bin/sh

#Save script to /jffs 
#Before need create jffs partition
#doc jffs:https://wiki.freshtomato.org/doku.php/admin-jffs2

#Start on Tomato every minute

#Get Mac adres active devices
#eth1 - 2.4GHz
u1=$(wl -i eth1 assoclist | cut -f2 -d' ' | tr '\n' ' ')
#eth2 - 5 GHz
u2=$(wl -i eth2 assoclist | cut -f2 -d' ' | tr '\n' ' ')

#echo $u1 $u2

#Send to OpenHub Mac adres connect devices
curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "${u1}${u2}" "http://192.168.1.3:8080/rest/items/WifiDevicesTomato"
