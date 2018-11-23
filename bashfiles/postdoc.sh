#!/bin/bash
#source $POSTDOC_REPOSPATH/lib/bashfiles/mirror.sh
#

function postdoc_repos {

   # get the part of path from the datapath
   EXTRAPATH=${PWD#"${POSTDOC_DATAPATH}"}
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')

   # FIRST CHECK IF THE REPOSITORY EXISTS
   # update that part of the repository
   svn update ${POSTDOC_REPOSPATH}/${EXTRAPATH}
   # if the directory does not exist in the repository, nothing is done
   flag=`svn info ${POSTDOC_REPOSPATH}/${EXTRAPATH} 2> /dev/null | wc -l`
   if [ ${flag} -eq 0 ]; then
      echo
      echo " THERE IS NO REPOSITORY EQUIVALENT  AT "
      echo "  -- $POSTDOC_REPOSPATH/$EXTRAPATH -- "
      echo
      echo
      return 1
   fi
   # CONTINUE IF EXISTS

   flist=`svn list $POSTDOC_REPOSPATH/$EXTRAPATH`
   dateformat=`date +%Y%m%d_%H%M%S`

   echo
   printf "SYNCING REPOSITORY AT %50s\n"  $POSTDOC_REPOSPATH/$EXTRAPATH
   printf "         WITH DATA AT %50s\n"  $POSTDOC_DATAPATH/$EXTRAPATH
   echo

   recursivemirror $POSTDOC_REPOSPATH/$EXTRAPATH \
                   $POSTDOC_DATAPATH/$EXTRAPATH  \
                   $POSTDOC_REPOSPATH/$EXTRAPATH \
                   .
   cd $POSTDOC_DATAPATH/$EXTRAPATH
   echo

   return 0
}

function postdoc_commit {

   # get the part of path from the datapath
   EXTRAPATH=${PWD#"${POSTDOC_DATAPATH}"}
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')

   # FIRST CHECK IF THE REPOSITORY EXISTS
   # update that part of the repository
   svn update ${POSTDOC_REPOSPATH}/${EXTRAPATH}
   # if the directory does not exist in the repository, nothing is done
   flag=`svn info ${POSTDOC_REPOSPATH}/${EXTRAPATH} 2> /dev/null | wc -l`
   if [ ${flag} -eq 0 ]; then
      echo
      echo " THERE IS NO REPOSITORY EQUIVALENT  AT "
      echo "  -- $POSTDOC_REPOSPATH/$EXTRAPATH -- "
      echo
      echo
      return 1
   fi
   # CONTINUE IF EXISTS

   svn ci $POSTDOC_REPOSPATH/$EXTRAPATH 

   return 0
}


#> @author M.Moriche
#  @date 12-02-2018 by M.Moriche \n
#        added directoriies
#  
#  @brief Function to add an item to the repository  
#  
#  
function postdoc_add {

   for i in `seq 1 $#`; do
      fnm=${!i}
      postdoc_add_onefile $fnm
   done

}

#> @author M.Moriche
#  @date 12-02-2018 by M.Moriche \n
#        added directoriies
#  
#  @brief Function to add ONE item to the repository  
#  
#  
function postdoc_add_onefile {

   fnm=$1
 
   if [ -z "$fnm" ]; then
      echo
      echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      echo
      echo A non-empty file must be the argument of postdoc_add
      echo type postdoc_add --help for help
      echo
      echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      echo
      return 1
   elif [ "$fnm" == "--help" ]; then
      echo
      echo
      echo Usage: postdoc_add filename
      echo
      echo Where filename is the file that is to be:
      echo  1 - moved from the data directory to the repository
      echo  2 - Added to the repository, commited
      echo
      echo The repository is postdoced.
      echo
      return 0
   fi

   # get the part of path from the datapath
   EXTRAPATH=${PWD#"${POSTDOC_DATAPATH}"}
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')

   # FIRST CHECK IF THE REPOSITORY EXISTS
   # update that part of the repository
   svn update ${POSTDOC_REPOSPATH}/${EXTRAPATH}
   # if the directory does not exist in the repository, nothing is done
   flag=`svn info ${POSTDOC_REPOSPATH}/${EXTRAPATH} 2> /dev/null | wc -l`
   if [ ${flag} -eq 0 ]; then
      echo
      echo " THERE IS NO REPOSITORY EQUIVALENT  AT "
      echo "  -- $POSTDOC_REPOSPATH/$EXTRAPATH -- "
      echo
      echo
      return 1
   fi

   # CONTINUE IF EXTRAPATH EXISTS IN THE REPOSITORY
   # check if the file exists in the repository
   flag=`svn info ${POSTDOC_REPOSPATH}/${EXTRAPATH}/${fnm} 2> /dev/null | wc -l`
   if ! [ ${flag} -eq 0 ]; then
      echo
      echo " THE FILE "
      echo "  -- $POSTDOC_REPOSPATH/$EXTRAPATH/$fnm -- "
      echo ALREADY EXISTS IN THE REPOSITORY
      echo
      return 1
   fi

   # CONTINUE IF THE FILE IS NOT UNDER SUBVERSION CONTROL

   if [ -d $POSTDOC_DATAPATH/$EXTRAPATH/$fnm ]; then

     # if it is a directory, create it in the repos and commit

     mkdir $POSTDOC_REPOSPATH/$EXTRAPATH/$fnm
     svn add $POSTDOC_REPOSPATH/$EXTRAPATH/$fnm
     #svn ci -m "added $fnm by postdoc_add function" \
     #          $POSTDOC_REPOSPATH/$EXTRAPATH/$fnm
   elif ! [ -f $POSTDOC_DATAPATH/$EXTRAPATH/$fnm ]; then

      # check the file exists in datapath

      echo
      echo The file $fnm does not exist
      echo
      return 1

   else

      # move the file
      mv $POSTDOC_DATAPATH/$EXTRAPATH/$fnm \
         $POSTDOC_REPOSPATH/$EXTRAPATH/$fnm
      # add to the repository
      svn add $POSTDOC_REPOSPATH/$EXTRAPATH/$fnm
      #svn ci -m "added $fnm by postdoc_add function" \
      #          $POSTDOC_REPOSPATH/$EXTRAPATH/$fnm

      # create the linkg
      ln -s $POSTDOC_REPOSPATH/$EXTRAPATH/$fnm \
            $POSTDOC_DATAPATH/$EXTRAPATH/$fnm

   fi

   return 0

}



# @author M.Moriche
# @date 10-06-2016 by M.Moriche \n
#       Created
#
# @brief Gets data from server and updates SVN
#
# @details
#
# Gets the data (which is not under SVN control)
# from the server and updates the repository
#
# If in the local machine a file sync_exclude.dat exists, 
# its contents are excluded from the synchronization
# 
# An example of sync_exclude.dat file:
#
#  +---------------------------------------+
#  |heavy                                  |
#  |heavy/*                                |
#  |frames                                 |
#  |frames/*                               |
#  +---------------------------------------+
function postdoc_get {

sss="------------------------------------------------------"

################################################################################
# 1 extract path
echo $PWD
EXTRAPATH=${PWD#"${POSTDOC_DATAPATH}"}
EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')

################################################################################
# 2 update changes in the repository (if the path exists)
cd $POSTDOC_REPOSPATH
flag=`svn info ${EXTRAPATH} 2> /dev/null | wc -l`
if [ ${flag} -eq 0 ]; then
   echo
   echo -e "\033[7;36m <1a> NO repository ${EXTRAPATH} found\033[0m "
   echo
else
   echo ""
   echo -e "\033[7;36m <1a> Updating repository ${EXTRAPATH}\033[0m "
   echo ""
   svn update $EXTRAPATH
fi
cd $POSTDOC_REPOSPATH/lib

# UPDATE THE LIBRARIES
echo -e "\033[7;36m <1b> Updating libraries \033[0m "
svn update
source $POSTDOC_REPOSPATH/lib/bashfiles/postdoc.sh

# go back
cd $POSTDOC_DATAPATH/$EXTRAPATH

echo ""
echo ""

# 3 rsync unversioned files
echo -e "\033[7;36m     Rgetting not-versioned files ${sss}\033[0m "
echo -e "\033[7;36m     From $POSTDOC_SERVER/$EXTRAPATH/\033[0m "
echo -e "\033[7;36m     To   $POSTDOC_DATAPATH/$EXTRAPATH/\033[0m "
           
echo ""
excludefile=""

if [ -f "sync_get_exclude.dat" ]; then

   excludefile=sync_get_exclude.dat
   excludefiletmp=tmp.rsync

   # excluding thing in all and machine specific
   awk "/all-beg/{flag=1;next}/all-end/{flag=0}flag" $excludefile \
       > $excludefiletmp
   mm=`uname -n`
   awk "/${mm}-beg/{flag=1;next}/${mm}-end/{flag=0}flag" $excludefile \
      >> $excludefiletmp

   echo ""
   echo -e "\033[7;36m <2a> Excluding the following data to sync ${sss}\033[0m "
   echo ""
   cat $excludefiletmp
   echo ""

   rsync -auvz --safe-links                \
           --exclude=".*"                  \
           --exclude-from=$excludefiletmp  \
           $POSTDOC_SERVER/$EXTRAPATH/     \
           $POSTDOC_DATAPATH/$EXTRAPATH/

else

rsync -auvz --safe-links                   \
           --exclude=".*"                  \
           $POSTDOC_SERVER/$EXTRAPATH/     \
           $POSTDOC_DATAPATH/$EXTRAPATH/

fi


# 4 check storage
storage=`du -sh .`
echo ""
echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
echo ""
echo -e "\033[7;35m Project occupies " ${storage} " memory \033[0m "
echo ""
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

postdoc_repos

}


function postdoc_send {

sss="------------------------------------------------------"


# 1 extract path 
EXTRAPATH=${PWD#"${POSTDOC_DATAPATH}"}
EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')

cd $POSTDOC_REPOSPATH

# 2 commit changes
flag=`svn info ${EXTRAPATH} 2> /dev/null | wc -l`
if [ ${flag} -eq 0 ]; then
   echo
   echo -e "\033[7;36m <1a> NO repository ${EXTRAPATH} found\033[0m "
   echo
else
   echo ""
   echo ""
   echo -e "\033[7;36m <1> Committing changes to repository ${sss}\033[0m "
   echo ""
   svn commit $EXTRAPATH -m 'Project  updated'
fi

cd $POSTDOC_REPOSPATH/lib
svn commit -m 'Library files updated'
cd $POSTDOC_DATAPATH/$EXTRAPATH

echo ""
echo ""


# 3 rsync unversioned files
excludefiletmp=""
if [ -f "sync_send_exclude.dat" ]; then
   excludefile=sync_send_exclude.dat
   excludefiletmp=tmp.rsync

   echo -e "\033[7;36m <2> Excluding the following data to sync ${sss}\033[0m "
   echo ""
   mm=`uname -n`
   awk "/all-beg/{flag=1;next}/all-end/{flag=0}flag" $excludefile \
      > $excludefiletmp
   awk "/${mm}-beg/{flag=1;next}/${mm}-end/{flag=0}flag" $excludefile \
      >> $excludefiletmp
   echo ""
   cat $excludefiletmp
   echo ""
fi

echo ""
echo -e "\033[7;36m <3> Rsending not-versioned files ${sss}\033[0m "
echo ""

rsync -auvz --safe-links                   \
           --exclude=".*"                  \
           --exclude-from=$excludefiletmp  \
           $POSTDOC_DATAPATH/$EXTRAPATH/   \
           $POSTDOC_SERVER/$EXTRAPATH/     

if [ -f "tmp.rsync" ]; then
   rm tmp.rsync
fi

# 4 check storage

storage=`du -sh .`
echo ""
echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
echo ""
echo -e "\033[7;35m Project occupies " ${storage} " memory \033[0m "
echo ""
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

# 5 update server
# 5.1 update repository
# 5.2 sync repos with data
# 5.3 sync ipad data
EXTRAPATH=${PWD#"${POSTDOC_DATAPATH}"}
EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')
aa=(${POSTDOC_SERVER/:/ })
ssh ${aa[0]} "postdoc_server ${EXTRAPATH}"
if [ -f $POSTDOC_DATAPATH/$EXTRAPATH/todeleteinserver.list ]; then
   rm todeleteinserver.list
fi
}

function postdoc_get_delete {

EXTRAPATH=${PWD#"${POSTDOC_DATAPATH}"}
EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')

echo 
echo 
echo 
echo -e "\033[7;36m WARNING!! THIS SCRIPT MIGHT DELETE FILES\033[0m "
echo -e "\033[7;36m DO YOU REALLY WANT TO CONTINUE???\033[0m "
echo -e "\033[7;36m TYPE \033[0m \033[7;38m YES \033[0m \033[7;36m TO CONTINUE, OR ANY OTHER KEY TO TERMINATE\033[0m "
echo 
echo 

read flag

if [ "$flag" == "YES" ]; then

   excludefiletmp=""
   if [ -f "sync_get_exclude.dat" ]; then
   
      excludefile=sync_get_exclude.dat
      excludefiletmp=tmp.rsync
   
      mm=`uname -n`
      awk "/all-beg/{flag=1;next}/all-end/{flag=0}flag" $excludefile \
         > $excludefiletmp
      awk "/${mm}-beg/{flag=1;next}/${mm}-end/{flag=0}flag" $excludefile \
         >> $excludefiletmp

      echo ""
      cat $excludefiletmp
      echo ""
   fi

   echo -e "\033[7;36m <2> Rgetting not-versioned files ---------------------------------------\033[0m "
   echo ""
   
   rsync -auvz --delete -b --backup-dir=trash  \
              --safe-links                    \
              --exclude=".*"                  \
              --exclude="sync*"               \
              --exclude-from=$excludefiletmp  \
              $POSTDOC_SERVER/$EXTRAPATH/     \
              $POSTDOC_DATAPATH/$EXTRAPATH/
   
   echo ""
   echo -e "\033[7;36m <3> Updating repository ------------------------------------------------\033[0m "
   echo ""
   cd $POSTDOC_REPOSPATH/$EXTRAPATH
   svn update
   
   # Back to work
   cd $POSTDOC_DATAPATH/$EXTRAPATH
   
   storage=`du -sh .`
   echo ""
   echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
   echo ""
   echo -e "\033[7;35m Project occupies " ${storage} " memory \033[0m "
   echo ""
   echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

fi

}

function postdoc_server {

# this function is run from the external machines to update the configuration
# in the server
# The only argument (mandatory) is the extra path

# updates libraries,
cd $POSTDOC_REPOSPATH/lib
svn update
source $POSTDOC_REPOSPATH/lib/bashfiles/postdoc.sh


datestr=`date +%Y%m%d%H%M%S`
trr=$POSTDOC_DATAPATH/trash/$datestr/$EXTRAPATH/

cd $POSTDOC_DATAPATH/$1
if [ -f todeleteinserver.list ]; then
   echo holaaaaa
   file=todeleteinserver.list
   while IFS= read -r line
   do
           # display $line or do somthing with $line
   	printf '%s\n' "$line"
        fnm="$line"
        if [ -f "$fnm" ]; then
           echo 'server file to delete' $fnm
           if [ -L "$fnm" ]; then
              echo 'the file is a link, removed' 
              rm "$fnm" 
           else
              echo 'the file is hard, moved to trash' 
              mkdir -p $trr
              mv "$fnm" $trr
           fi
        fi
   done <"$file"
   rm todeleteinserver.list
fi

flag=`svn info ${POSTDOC_REPOSPATH}/${1} 2> /dev/null | wc -l`
if [ ${flag} -eq 0 ]; then
   echo
   echo " THERE IS NO REPOSITORY EQUIVALENT  AT "
   echo "  -- $POSTDOC_REPOSPATH/$1 -- "
   echo
   echo
else
   cd $POSTDOC_REPOSPATH
   svn update $1
   cd $POSTDOC_DATAPATH/$1
   postdoc_repos
fi


}

function postdoc_rm {

sss="------------------------------------------------------"

fnm=$1

# 1 extract path 
EXTRAPATH=${PWD#"${POSTDOC_DATAPATH}"}
EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')

frepos=$POSTDOC_REPOSPATH/$EXTRAPATH/$fnm
fdata=$POSTDOC_DATAPATH/$EXTRAPATH/$fnm

echo "$fnm" >> $POSTDOC_DATAPATH/$EXTRAPATH/todeleteinserver.list

# create bin
datestr=`date +%Y%m%d%H%M%S`
trr=$POSTDOC_DATAPATH/trash/$datestr/$EXTRAPATH/

if [ -L "${fdata}" ]; then
   # data file is a link, deleting it
   echo -e "\033[7;36m DAta file is a soft link, removing\033[0m "
   rm ${fdata}
elif [ -f "${fdata}" ]; then
   # data file is a hard file, moving to trash
   echo -e "\033[7;36m DAta file is a hard file, moving to trash\033[0m "
   mkdir -p $trr
   mv "${fdata}" $trr/
fi

if [ -f "${frepos}" ]; then
   flag=`svn info "${frepos}" 2> /dev/null | wc -l`
   if [ ${flag} -eq 0 ]; then
      # Delete the file at the repos, although is not under SVN control
      echo -e "\033[7;36m No repository file found ${frepos}\033[0m "
      mkdir -p $trr
      mv "${frepos}" $trr/
   else
      echo -e "\033[7;36m    repository file found ${frepos}\033[0m "
      svn delete "${frepos}"
   fi
fi

}

# @author M.Moriche
# @date 24-01-2018 by M.Moriche \n
#       Created
# @brief function to identify type of file
#
# @detail
#
# mandatory argument: filename, either absolute or relative
#
#
# OUTPUT: 
#   -1 --> file does not exist
#    0 --> file is a regular file
#    1 --> file is a directory
#    2 --> file is a symbolic link
#   99 --> not handled
function getfiletype {
fnm=$1

if ! [ -e "${fnm}" ]; then
   return -1
else
   if [ -d "${fnm}" ]; then
      return 1
   elif [ -L "${fnm}" ]; then
      return 2
   elif [ -f "${fnm}" ]; then
      return 0
   else
      return 99
   fi
fi
}


function postdoc_ci {

   # get the part of path frmo the datapath
   EXTRAPATH=${PWD#"${POSTDOC_DATAPATH}"}
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')

   svn commit -m 'Library files update' $POSTDOC_REPOSPATH/lib
   svn commit -m 'Mirror update update' $POSTDOC_REPOSPATH/$EXTRAPATH

}

function postdoc_update {

   # get the part of path frmo the datapath
   EXTRAPATH=${PWD#"${POSTDOC_DATAPATH}"}
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:/*$::')
   EXTRAPATH=$(echo $EXTRAPATH | sed 's:^/*::')

   svn update $POSTDOC_REPOSPATH/lib
   svn update $POSTDOC_REPOSPATH/$EXTRAPATH

}




