#!/bin/sh
#
#usage: spool.sh <job_id> "sys_command"
#set -x
#
#spooldir="/var/spool/torque/spool/"
spooldir="/var/spool/pbs/spool/"
#host=`qstat -n $1 | grep + | head -1 | sed 's/+/ /' | awk '{print $1}'`
host=`qstat -f $1 | grep exec_host | head -1 | sed 's/+/ /' | sed 's/\// /' | awk '{print $3}'`
echo "HOST: "$host
file=`ssh $host ls $spooldir | grep $1 | tail -1`
echo "FILE:" $file
ssh $host cat $spooldir$file | $2
echo " " | awk '{printf "\n"}'
#

