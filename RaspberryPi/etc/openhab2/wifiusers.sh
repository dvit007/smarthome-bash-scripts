#!/bin/sh
u1=$(ssh pi@192.168.1.2 /interface wireless registration-table print terse | cut -f3 -d'=' | cut -f1 -d' ' | tr '\n' ' ')
u2=$(ssh pi@192.168.1.7 /interface wireless registration-table print terse | cut -f3 -d'=' | cut -f1 -d' ' | tr '\n' ' ')
echo $u1
echo $u2
#echo "Test"
