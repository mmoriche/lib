
function gitpull {
   #githubhey
   git pull
   git submodule foreach --recursive 'git pull | true'
}
