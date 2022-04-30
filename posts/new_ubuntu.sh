# Add to .profile

export DOCKER_BUILDKIT=1

alias dev="cd /mnt/c/_dev ; ls -1"
sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/ssh
alias tunnels="echo 'Starting tunnels' ; pkill ssh ; ssh tunnels -N &"
alias docker='podman'

function build_and_push() {
  local REPO_NAME=$1
  local AWS_ACCOUNT_NUMBER=162518272639
  local AWS_REGION=us-east-2
  local COMMIT=$(git rev-parse --short HEAD)
  local BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
  docker image build --tag ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:latest .
  aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com
  docker push ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}
  docker image tag ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:latest ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:$COMMIT
  docker push ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:$COMMIT
  docker image tag ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:latest ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:$BRANCH
  docker push ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:$BRANCH
} # End function build_and_push


# Add to .vimrc
colorscheme desert
syntax on


# Add to ~wsl.conf
[network]
generateResolvConf = false


# Add NOPASSWORD with visudo
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install python3


