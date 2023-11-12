#!/bin/bash

# Script by @ComputerByte modified by @Betonhaus
# For Uninstalling the additional Sonarr instances
#prompt for name of instance to remove
echo "Please enter the following information of the server, ensure there are no typos"
echo "System (url) name for server (sonarr2):"
read arrsysname
if [ -z "$arrsysname" ]
then    arrsysname="sonarr2"
fi

    
echo "removing $arrsysname. Are you sure? y/(n):"
read input
if [ "$input" != "y" ] 
then  echo "exiting."
    exit 1
fi


# Log to Swizzin.log
export log=/root/logs/swizzin.log
touch $log

systemctl disable --now -q $arrsysname
rm /etc/systemd/system/$arrsysname.service
systemctl daemon-reload -q

if [[ -f /install/.nginx.lock ]]; then
    rm /etc/nginx/apps/$arrsysname.conf
    systemctl reload nginx
fi

rm /install/.$arrsysname.lock

sed -i.bak -e '/class ${arrsysname}_meta:/,+9d' /opt/swizzin/core/custom/profiles.py
