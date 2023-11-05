#!/bin/bash

# Script by @Betonhaus
# code for finding all instances and presenting as a list to choose from
echo "Reading list of arr instances"
x = 0
for files in /opt/swizzin/core/custom/*
do
  list[$x] = "$files"
  sed -n 's/^ *pretty_name *= *//p' /opt/swizzin/core/custom/$files
  echo "$files"
  x++
done
print $x
