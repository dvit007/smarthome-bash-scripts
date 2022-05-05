#!/bin/bash

if [[ $1 == "status" ]]
then
    u1=$(ssh master@192.168.1.18 -o LogLevel=QUIET -tt 'bash -l -c "upsc ippon ups.status 2>&1 | grep -v SSL"')
fi

if [[ $1 == "battery" ]]
then
    u1=$(ssh master@192.168.1.18 -o LogLevel=QUIET -tt 'bash -l -c "upsc ippon battery.charge 2>&1 | grep -v SSL"')
fi

if [[ $1 == "voltage" ]]
then
    u1=$(ssh master@192.168.1.18 -o LogLevel=QUIET -tt 'bash -l -c "upsc ippon input.voltage 2>&1 | grep -v SSL"')
fi


echo $u1