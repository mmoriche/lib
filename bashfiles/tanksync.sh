#!/bin/bash
#
#
# Example of CASEDATA file when keys are available
# Note that the variable at remote can be changed w/o need to update value here
#
#  localtank    ::           $TANK_PATH
#  remote       ::           taifun:$TANK_PATH
#  bring_flags  ::          --exclude="uvwp*"
#  send_flags   ::
#
# If remote has no keys, might be better to give the path explicitely, although
# we will need to update its value every time it changes in the remote
#
#  localtank    ::           $TANK_PATH
#  remote       ::           taifun:/data5/guerrero
#  bring_flags  ::          --exclude="uvwp*"
#  send_flags   ::
#
#
# In adition to the get/send flag, a string with additional flags for the rsync can be given
#
#
#
function tanksync {
direction=$1
[ -z $2 ] && casefile=CASEDATA || casefile=CASEDATA-$2 

DATADIR=$PWD
CASEDATA=${DATADIR}/${casefile}
while ! [ -f "${CASEDATA}" ]; do 
   DATADIR=${DATADIR%/*} 
   CASEDATA=${DATADIR}/${casefile}
   if [ -z ${DATADIR} ]; then
      echo "I need the file CASE data with the info to move data"
      echo "----------------------------------------------------"
      echo localtank    ::       $TANK_PATH
      echo remote       ::       icaro:$TANK_PATH
      echo bring_flags  ::       -auvz 
      echo send_flags   ::       -auvz
      echo "----------------------------------------------------"
      return 1
   fi
done
if [ "$direction" == "edit" ]; then
   vi $CASEDATA
   return
fi
echo data file : $CASEDATA
echo ---------------------------------
cat $CASEDATA
echo ---------------------------------

localtank=`cat  $CASEDATA | grep '^localtank'   | sed 's|^localtank *:: *\(.*\)|\1|g'`
remote=`cat     $CASEDATA | grep '^remote'      | sed 's|^remote *:: *\(.*\)|\1|g'`
bflags=`cat     $CASEDATA | grep '^bring_flags' | sed 's|^bring_flags *:: *\(.*\)|\1|g'`
sflags=`cat     $CASEDATA | grep '^send_flags'  | sed 's|^send_flags *:: *\(.*\)|\1|g'`
aa=(${remote//:/ })
remotemachine=${aa[0]}
remotetank=${aa[1]}

# get local tank
aa=${localtank:0:1}
if [ "${aa}" == "$" ]; then
   echo local tank given by variable ${localtank}
   bb=${localtank:1}
   TANK=${!bb}
else
   TANK=${localtank}
fi

# get remote tank
aa=${remotetank:0:1}
if [ "${aa}" == "$" ]; then
   echo remote tank given by variable ${remotetank}
   bb=${remotetank:1}
   RTANK=`ssh ${remotemachine} "echo ${remotetank}"`
else
   RTANK=${remotetank}
fi

echo " localtank=${localtank} --> ${TANK}"
echo " remotemachine=${remotemachine} "
echo " remotetank=${remotetank} --> ${RTANK}"
echo " bflags=${bflags}"
echo " sflags=${sflags}"

# GET EXTRAPATH
EX=`getextrapath ${TANK}`
echo $EX


if [ "$direction" == "get" ]; then
   echo 
   echo "Getting files from remote"
   echo 
   echo rsync ${bflags}  --exclude="CASEDATA*" --exclude="${casefile}" ${remotemachine}:${RTANK}/${EX}/ ${TANK}/${EX}/
   echo 
   eval rsync ${bflags}  --exclude="CASEDATA*" --exclude="${casefile}" ${remotemachine}:${RTANK}/${EX}/ ${TANK}/${EX}/
elif [ "$direction" == "dryget" ]; then
   echo 
   echo "Checking files to get from remote"
   echo 
   echo rsync ${bflags} --dry-run --exclude="CASEDATA*" --exclude="${casefile}" ${remotemachine}:${RTANK}/${EX}/ ${TANK}/${EX}/
   echo 
   eval rsync ${bflags} --dry-run --exclude="CASEDATA*" --exclude="${casefile}" ${remotemachine}:${RTANK}/${EX}/ ${TANK}/${EX}/
elif [ "$direction" == "send" ]; then
   echo 
   echo "Sending files to remote"
   echo 
   echo rsync ${sflags}  --exclude="CASEDATA*" --exclude="${casefile}" ${TANK}/${EX}/ ${remotemachine}:${RTANK}/${EX}/
   echo                              
   eval rsync ${sflags}  --exclude="CASEDATA*" --exclude="${casefile}" ${TANK}/${EX}/ ${remotemachine}:${RTANK}/${EX}/
elif [ "$direction" == "drysend" ]; then
   echo 
   echo "Checking files to send to remote"
   echo 
   echo rsync ${sflags} --dry-run --exclude="CASEDATA*" --exclude="${casefile}" ${TANK}/${EX}/ ${remotemachine}:${RTANK}/${EX}/
   echo                              
   eval rsync ${sflags} --dry-run --exclude="CASEDATA*" --exclude="${casefile}" ${TANK}/${EX}/ ${remotemachine}:${RTANK}/${EX}/
else
   echo "Either get or send should be specified"
   echo "  ... or dry versions (dryget, drysend)"
   echo "  ... or edit"
   return 1
fi
return 0
}
