#!/bin/bash


project=WORK/source/TUCAN/tags/vmaneuvers
tank=${TANK_PATH}

lastsent=${tank}/${project}/icaro/3D5000/AG200w200_3D_tight_NC320P_LZC04/AG200w200_3D_tight_NC320P_LZC04.0000132.h5frame

while true; do

   resfilename=`getlastfile ${tank}/${project}/icaro/3D5000 AG200w200_3D_tight_NC320P_LZC04 h5frame`

   if ! [ "$resfilename" == "$lastsent" ]; then
       
      echo The file $resfilename is ready, giving 2 minutes for writting
      sleep 120
      rsync -avz $resfilename an5210@uc1:/work/kit/ifh/an5210/${project}/uc1/3D5000/AG200w200_3D_tight_NC320P_LZC04/ && lastsent=$resfilename
      
   else
      ss=`date`
      echo "last file $resfilename, already sent $ss"
   fi
   sleep 60
done

