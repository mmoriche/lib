
function gitci {
   #githubhey
   git submodule foreach --recursive 'git commit -a -m glb | true'
   git commit -a -m glb
}
