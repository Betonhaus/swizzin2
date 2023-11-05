#!/bin/bash

# Script by @ComputerByte modified by @Betonhaus
# For Uninstalling the additional Sonarr instances

# code for finding all instances and presenting as a list to choose from

#prompt for name of instance to remove
echo "Please enter the following information of the server, ensure there anre no typos"
echo "Proper name for server (Sonarr 4K):"
read arrname
if test -z "$arrname" then
    arrname = "Sonarr 4K"
fi
#code here to make lowercase and remove whitespace from input to present as default system name
echo "System name for server (sonarr4k):"
read arrsysname
if test -z "$arrsysname" then
    arrsysname = "sonarr4k"
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

sed -e "s/class $arrsysname_meta://g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    name = \"$arrsysname\"//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    pretty_name = \"$arrname\"//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    baseurl = \"\/$arrsysname\"//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    systemd = \"$arrsysname\"//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    check_theD = True//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    img = \"sonarr\"//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/class sonarr_meta(sonarr_meta)://g" -i /opt/swizzin/core/custom/profiles.py
