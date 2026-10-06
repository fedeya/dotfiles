#!/bin/sh
# created by s4vitar #
# adapted by fedeya
 
vpntun=$(/usr/sbin/ifconfig | grep tun0 -A1 | grep inet | awk '{print $2}' | tr -d ":")
 
if [ "$vpntun" != "" ]; then
    printf '{"text": "%s", "alt": "", "tooltip": "", "class": "live"}'  "$vpntun"
else
    printf '{"text": "Disconnected", "alt": "", "tooltip": "", "class": "dead"}'
fi
