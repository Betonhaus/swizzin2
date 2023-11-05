#!/bin/bash

# Script by @Betonhaus
# code for finding all instances and presenting as a list to choose from
echo "Reading list of arr instances"
x=-1
for files in /opt/swizzin/core/custom/*
do
if [ $files != '/opt/swizzin/core/custom/__pycache__' ]; then
  x=$(($x + 1))
  list[$x]=$files
  sed -n 's/^ *pretty_name *= *//p' $files
  echo "$files"
fi
done
echo ${list[0]}
echo "version 12"
