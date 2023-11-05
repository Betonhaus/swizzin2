#!/bin/bash

# Script by @ComputerByte modified by @Betonhaus
# For Uninstalling the additional Sonarr instances

# code for finding all instances and presenting as a list to choose from
#prompt for server type
#code for checking which servers are installed and only presenting them
echo "Please enter which server type you wish to remove.
1. Sonarr
2. Radarr
3. Readarr
4. Lidarr
Enter server number (1):"
read input
case "$input" in
    "1") 
          servname = "Sonarr"
          servsysname = "sonarr";;
    "") 
          servname = "Sonarr"
          servsysname = "sonarr";;
    "2") 
          servname = "Radarr"
          servsysname = "radarr";;
    "3") 
          servname = "Readarr"
          servsysname = "readarr";;
    "4") 
          servname = "Lidarr"
          servsysname = "lidarr";;
    *) 
          echo "invalid input"
          exit 1;;         
esac

#prompt for name of instance to remove
echo "Please enter the following information of the server, ensure there anre no typos"
echo "Proper name for server (${servname} 2):"
read arrname
if test -z "$arrname" then
    arrname = "${servname} 2"
fi
#code here to make lowercase and remove whitespace from input to present as default system name
echo "System name for server (${servsysname}2):"
read arrsysname
if test -z "$arrsysname" then
    arrsysname = "${servsysname}2"
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
sed -e "s/    img = \"${servsysname}\"//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/class ${servsysname}_meta(${servsysname}_meta)://g" -i /opt/swizzin/core/custom/profiles.py
