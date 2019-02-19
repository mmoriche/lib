#!/bin/bash


function githubkey { 

if [ -z "${GITHUB_PATH}" ]; then
   echo 
   echo ERROR: ENVIRONMENT VARIALBE GITHUB_PATH MUST BE DEFINED
   echo 
   exit
fi

eval $(ssh-agent)

fnm=${GITHUB_PATH}/keys/github_rsa

if [ -f "${fnm}" ]; then
  ssh-add  ${fnm}
else
  echo
  echo The key file ${fnm} has not been found
  echo
fi
}

function gitci {
   githubhey
   git submodule foreach --recursive 'git commit -a -m glb | true'
   git commit -a -m glb
}

function gitpull {
   githubhey
   git pull
   git submodule foreach --recursive 'git pull | true'
}

function gitpush {
   githubhey
   git submodule foreach --recursive 'git push'
   git push 
}
