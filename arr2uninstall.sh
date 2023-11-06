#!/bin/bash

# Script by @ComputerByte modified by @Betonhaus
# For Uninstalling the additional Sonarr instances

# code for finding all instances and presenting as a list to choose from
echo "Reading list of arr instances"
x=-1
for files in /opt/swizzin/core/custom/*
do
if [ ".$(echo "$files"| awk -F. '{print $NF}')" == ".py" ]; then
  x=$(($x + 1))
  list[$x]=$files
  sed -n 's/^ *pretty_name *= *//p' $files | sed 's/"//g' | sed "s/$/: $x/"
fi
done
if [$x == -1]; then
echo "no servers to remove"
exit 1
fi

echo "choose which server to remove (0):"
read x
if test -z "$x" then
    x=0
fi
if test -z "${list[$x]}" then
    echo "invalid option"
    exit 1
fi

arrname=$(sed -n 's/^ *pretty_name *= *//p' ${list[0]} | sed 's/"//g' )
arrsysname=$(sed -n 's/^ *name *= *//p' ${list[0]} | sed 's/"//g')
servsysname=$(sed -n 's/^ *systemd *= *//p' ${list[0]} | sed 's/"//g')




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
