
function getextrapath {
   CONTAINER=$1 
   # get the part of path from the datapath
   EXTRAPATH=${PWD#"${CONTAINER}"}
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')
   echo ${EXTRAPATH}
}
