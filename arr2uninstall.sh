#!/bin/bash

# Script by @ComputerByte modified by @Betonhaus
# For Uninstalling the additional Sonarr instances
#prompt for name of instance to remove
echo "Please enter the following information of the server, ensure there are no typos"
echo "Proper name for server (Sonarr 2):"
read arrname
if test -z "$arrname" then
    arrname="Sonarr 2"
fi
#code here to make lowercase and remove whitespace from input to present as default system name
echo "System name for server (sonarr2):"
read arrsysname
if test -z "$arrsysname" then
    arrsysname="sonarr2"
fi
    
echo "removing $arrname ($arrsysname). Are you sure? y/(n):"
read input
if "$input"!="y" then
  echo "exiting."
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

echo "do you want to automatically remove $arrname from /opt/swizzin/core/custom/profiles.py?"
echo "this may corrupt the file if the entry does not have exactly ten lines. y/(n):"
read input
if "$input"!="y" then
  echo "exiting."
    exit 1
fi

sed -e '/class ${arrsysname}_meta:/,+10d' /opt/swizzin/core/custom/profiles.py
