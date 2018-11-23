#!/bin/bash
function recursivemirror {

item=$1
dest=$2
originalpath=$3
# is the last one because is an accumulative, auxiliar one
relpath=$4

orig=$originalpath/$relpath

if [ -f $item ]; then

   # the dest accumulated is a file
   if ! [ -f $dest ]; then
      if ! [ -L $dest ]; then
         # DOES NOT EXIST, neither file, neither link --> CREATE LINK 
         printf "Creating - %s \n         |- orig %s\n         |- dest %s\n" \
                $item $orig $dest
         ln -s $orig $dest
      else
         # DOES NOT EXIST, neither file, neither link --> CREATE LINK 
         printf "\n\n\n Hard file does not exist, but there is a link" 
         printf " Deleting the link and creating a new one"
                #$item $orig $dest
         rm $dest
         printf "Creating - %s \n         |- orig %s\n         |- dest %s\n" \
                $item $orig $dest
         ln -s $orig $dest
      fi
   elif ! [ -L $dest ]; then
      # EXISTS, BUT IT IS NOT A LINK  --> move to hard file *.<datestr>
      #                                   and replace by soft link
      datestr=`date +%Y%m%d%H%M%S`
      printf  "\n\n\nHard file exists, moving to $dest.CHECKDELETE.$datestr\n\n"
      printf "Creating - %s \n         |- orig %s\n         |- dest %s\n" \
             $item $orig $dest
      mv $dest $dest.CHECKDELETE.$datestr
      ln -s $orig $dest
   fi

elif [ -d $item ]; then

   cd $item
   flist=(`ls`)
   for fnm in ${flist[@]}; do

      # the dest accumulated is a directory
      # CREATE DIR (IF IT DOES NOT EXIST)
      if ! [ -d $dest ]; then
         echo 
         echo "  ---- new diretctory $item"
         echo 
         mkdir $dest
      elif [ -L $dest ]; then
         # EXISTS, BUT IT IS A LINK  --> move to hard file *.<datestr>
         #                               and replace by hard directory
         datestr=`date +%Y%m%d%H%M%S`
         mylink=`readlink $dest`
         if [ "$mylink" == "$orig" ]; then

            printf  "\n\n\nSoft link of DIR esists, moving to $dest.$datestr\n\n"
            mv $dest $dest.CHECKDELETE.$datestr

            echo 
            echo "  ---- new diretctory $item"
            echo 
            mkdir $dest
         else
            echo
            echo "Soft link $dest, pointing outside, so it is KEPT!!"
            echo
         fi
      fi

      dest=$dest/$fnm
      if [ $relpath == "." ]; then
         relpath=$fnm
      else
         relpath=$relpath/$fnm
      fi

      recursivemirror $fnm $dest $originalpath $relpath

      dest=`dirname $dest`
      relpath=`dirname $relpath`
   done
   cd ..

fi
}
