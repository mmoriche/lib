#!/bin/bash

# arguments:
#  1: basenm
#  2: path
#  3: extension

function getlastfile {
path=$1
basenm=$2
ext=$3
uu=`ls ${path}/${basenm} | grep "$basenm\.\([0-9]*\)\.${ext}.*" | sed "s/$basenm\.\([0-9]*\)\.${ext}.*/\1/"`
for u in $uu; do 
   ifr=$u
done
lastfile=${path}/${basenm}/${basenm}.${ifr}.${ext}
echo ${lastfile}
}
