#!/bin/bash


function fullname {
  #1. package
  #2. version
  local  packagename="$1-$2"
  echo "$packagename"
}

package=hdf5
version=1.8.21

DOWNLOADSDIR=${TANK_PATH}/WORK/lib/${package}/Downloads
OPT=/opt

# decompress

fullpackage=`fullname ${package} ${version}`
cd ${DOWNLOADSDIR}
ifnm=${fullpackage}.tar.gz


tar -xvzf ${ifnm}
cd ${fullpackage}

./configure --enable-fortran --prefix=${OPT}
make -j 4

# as superuser
echo enter as superuser and type: make install


