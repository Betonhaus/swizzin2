#!/bin/bash

# Script by @Betonhaus
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
echo ${list[0]}
arrname=$(sed -n 's/^ *pretty_name *= *//p' ${list[0]} | sed 's/"//g' )
echo "server name is $arrname"
arrsysname=$(sed -n 's/^ *name *= *//p' ${list[0]} | sed 's/"//g')
echo "system name is $arrsysname"
