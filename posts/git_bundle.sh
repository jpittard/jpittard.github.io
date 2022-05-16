# Do a complete, portable extract of git repos and history
mkdir ~/bundles
cd ~/bundles

function bundle() {
  repo=$1
  echo $repo
  git clone --mirror git@bitbucket.org:drms-middleware/${repo}.git 
  cd ${repo}.git
  git bundle create ../${repo}.bundle --all
  cd ~/bundles
}

declare -a -x repos=(
alf_metadata_migration
test-pipeline
and-so-forth
)

printf "%s\n" "${repos[@]}"
for repo in ${repos[@]}; do
  echo "${repo}"
  bundle "${repo}"
done

zip --encrypt drms_git_bundles.zip *.bundle
