# Bundle a full git repo for sneakernet

function bundle() {
  repo=$1
  git clone --mirror git@bitbucket.org:dsanara/${repo}.git 
  cd ${repo}.git
  git bundle create ../${repo}.bundle --all
  cd ..
}

bundle the-repo
