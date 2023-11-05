#!/bin/bash

# Script by @Betonhaus
# code for finding all instances and presenting as a list to choose from
echo "Reading list of arr instances"
x=0
for files in /opt/swizzin/core/custom/*
do
if [ $files != '/opt/swizzin/core/custom/__pycache__' ]; then
  list[$x]='$files'
  echo "${sed -n 's/^ *pretty_name *= *//p' $files}: $x"
  echo "$files"
  x=$(($x + 1))
fi
done
echo "$x instances found"
echo "$list[$x]"
