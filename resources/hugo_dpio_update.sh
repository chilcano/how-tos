#!/bin/bash

echo "###############################################################"
echo "#   Updating a website with Hugo from existing GitHub repo    #"
echo "###############################################################"

GIT_SOURCE_REPO_URL="https://github.com/migueluza/data-plane"
CURRENT_DIR=$PWD
GIT_ORG="data-plane"
GIT_REPO="ghpages-dpio"
GIT_HUGO_SCRIPTS_DIR="ghp-scripts"
GIT_PARENT_DIR="${HOME}/gitrepos"
GIT_HUGO_CONTENT_DIR="ghp-content"

printf "==> Changing working dir. \n"
cd ${GIT_PARENT_DIR}/${GIT_REPO}

printf "==> Switching to 'main' branch. \n"
git checkout main

printf "==> Updating 'baseURL' in 'config.toml'. \n"
sed -i.bak 's/^baseURL = .*$/baseURL = "https\:\/\/data-plane.io\/"/' ${GIT_PARENT_DIR}/${GIT_REPO}/${GIT_HUGO_SCRIPTS_DIR}/config.toml

printf "==> Pushing Hugo scripts changes. \n"
git add .; git commit -m "Hugo config.toml updated with FQDN." --quiet; git push 

echo "###############################################################"
echo "#       Updating GitHub Pages repo ($GIT_HUGO_CONTENT_DIR branch)      #"
echo "###############################################################"

git worktree add -B ${GIT_HUGO_CONTENT_DIR} main upstream/${GIT_HUGO_CONTENT_DIR}
git worktree add -B ghp-content main upstream/${GIT_HUGO_CONTENT_DIR}

#printf "==> Switching to '${GIT_HUGO_CONTENT_DIR}' branch. \n"
#git checkout ${GIT_HUGO_CONTENT_DIR}

#printf "==> Pulling the '${GIT_HUGO_CONTENT_DIR}' branch. \n"
#git pull

printf "==> Regenerating Hugo content in <root>/docs dir. \n"
cd ${GIT_HUGO_SCRIPTS_DIR}; hugo; cd ../

printf "==> Pushing Hugo content changes. \n"
git add .; git commit -m "Hugo content updated." --quiet; git push upstream ${GIT_HUGO_CONTENT_DIR}

printf "==> Returning to current dir. \n"
cd ${CURRENT_DIR}
