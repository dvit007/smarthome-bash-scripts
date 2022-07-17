#!/bin/bash

#https://community.openhab.org/t/tutorial-restart-binding-from-rule/37047

/usr/bin/ssh -p 8101 -i /home/openhab/karaf_keys/openhab.id_rsa openhab@localhost 'bundle:restart org.openhab.binding.telegram'