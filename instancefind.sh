#!/bin/bash

# Script by @Betonhaus
# code for finding all instances and presenting as a list to choose from
echo "Reading list of arr instances"
x=0
for files in /opt/swizzin/core/custom/*
do
echo "add to list"
  list[$x]='$files'
  echo "run sed"
  sed -n 's/^ *pretty_name *= *//p' $files
  echo "print fi8lename"
  echo "$files"
  echo "increment"
  x=$(($x + 1))
done
print "x is $x"
