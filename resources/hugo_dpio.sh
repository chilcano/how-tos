#!/bin/bash

echo "##########################################################"
echo "#           Creating a website with Hugo                 #"
echo "##########################################################"

# https://gohugo.io/hosting-and-deployment/hosting-on-github/
# https://migueluza.github.io/data-plane/
# https://github.com/migueluza/data-plane

echo "==> Cloning the GitHub Page site and moving to project directory"
CURRENT_DIR=$PWD
GIT_USER="chilcano"
GIT_ORG="data-plane"
GIT_REPO="ghp-dpio"
GIT_PARENT_DIR="${HOME}/gitrepos"

GIT_REPO_SOURCE="https://github.com/migueluza/data-plane"
GIT_REPO_TARGET="https://github.com/data-plane/ghp-dpio"

printf "\t * Removing preview '~/gitrepos/ghp-dpio/' directory. \n"
rm -rf ~/gitrepos/ghp-dpio/
mkdir -p ~/gitrepos/ghp-dpio/ 
printf "\t * Cloning source repo. \n"
git clone ${GIT_REPO_SOURCE} ~/gitrepos/ghp-dpio

printf "\t * Removing preview '~/gitrepos/ghp-dpio/.git' dir. \n"
rm -rf ~/gitrepos/ghp-dpio/.git

cd ${GIT_PARENT_DIR}/${GIT_REPO}

printf "\t * Initializing local GitHub repo. \n"
git init; git add .; git commit -m "And so, DPio begins."
printf "\t * Creating a new repo on GitHub with the name of the current directory. \n"
hub create
printf "\t * Pushing to remote repo on GitHub. \n"
git push -u origin HEAD

cd ${CURRENT_DIR}
