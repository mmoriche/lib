#!/bin/bash


function githubkey { 

if [ -z "${GITHUB_PATH}" ]; then
   echo 
   echo ERROR: ENVIRONMENT VARIALBE GITHUB_PATH MUST BE DEFINED
   echo 
   exit
fi

eval $(ssh-agent)

#fnm=${GITHUB_PATH}/keys/github_rsa
fnm=/home/mmoriche/.ssh/id_rsa

if [ -f "${fnm}" ]; then
  ssh-add  ${fnm}
else
  echo
  echo The key file ${fnm} has not been found
  echo
fi
}
