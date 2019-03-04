
function gitpush {
   #githubhey
   git submodule foreach --recursive 'git push'
   git push 
}
