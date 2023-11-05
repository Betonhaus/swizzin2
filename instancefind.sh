#!/bin/bash

# Script by @Betonhaus
# code for finding all instances and presenting as a list to choose from
echo "Reading list of arr instances"
x = 0
for files in /opt/swizzin/core/custom/*
do
echo "add to list"
  list[$x] = "$files"
  echo "run sed"
  sed -n 's/^ *pretty_name *= *//p' /opt/swizzin/core/custom/$files
  echo "print fi8lename"
  echo "$files"
  Echo "increment"
  $x++
done
print "x is $x"
