
function tkcp {
   
   fnm=$1

   CONTAINER=$GITHUB_PATH
   DESTINY=$TANK_PATH

   # get the part of path from the datapath
   EXTRAPATH=${PWD#"${CONTAINER}"}
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')
   echo cp $fnm $DESTINY/${EXTRAPATH}/
   cp $fnm $DESTINY/${EXTRAPATH}/
}
