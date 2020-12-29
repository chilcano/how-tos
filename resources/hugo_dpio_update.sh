#!/bin/bash

printf "\n"
echo "###############################################################"
echo "#             Discrete Hugo content updating                  #"
echo "###############################################################"

# Ref: 
# https://gohugo.io/hosting-and-deployment/hosting-on-github/

CURRENT_DIR=$PWD
GIT_ORG="data-plane"
GIT_REPO="ghpages-dpio"
GIT_HUGO_SCRIPTS_DIR="ghp-scripts"
GIT_PARENT_DIR="${HOME}/gitrepos"
GIT_HUGO_CONTENT_DIR="ghp-content"
GIT_HUGO_CONTENT_BRANCH="${GIT_HUGO_CONTENT_DIR}"

printf "==> Changing to '${GIT_PARENT_DIR}/${GIT_REPO}/' as working dir. \n"
cd ${GIT_PARENT_DIR}/${GIT_REPO}

printf "==> Switching to 'main' branch. \n"
git checkout main --quiet

if [ "`git status -s`" ]
then
    printf "==> The working directory is dirty. Please commit any pending changes. \n"
    exit 1;
fi

#printf "==> Deleting old Hugo content from '${GIT_HUGO_CONTENT_DIR}'. \n"
#rm -rf ${GIT_HUGO_CONTENT_DIR}

#printf "==> Removes info about (non-locked) worktree '${GIT_HUGO_CONTENT_BRANCH}' which no longer exists. \n"
#git worktree prune
#rm -rf .git/worktrees/${GIT_HUGO_CONTENT_BRANCH}/

#printf "==> Checking out 'GIT_HUGO_CONTENT_BRANCH' into 'GIT_HUGO_CONTENT_DIR'. \n"
#git worktree add -B ${GIT_HUGO_CONTENT_BRANCH} ${GIT_HUGO_CONTENT_DIR} origin/${GIT_HUGO_CONTENT_BRANCH}

#printf "==> Deleting only Hugo content from '${GIT_HUGO_CONTENT_DIR}'. \n"
#rm -rf ${GIT_HUGO_CONTENT_DIR}/*

printf "==> Pulling latest changes of Hugo content from '${GIT_HUGO_CONTENT_BRANCH}' branch. \n"
cd ${GIT_HUGO_CONTENT_DIR}; git pull; cd ../

printf "==> Regenerating Hugo content in <root>/${GIT_HUGO_CONTENT_DIR}/docs dir. \n"
cd ${GIT_HUGO_SCRIPTS_DIR}; hugo

printf "==> Updating Hugo content in '${GIT_HUGO_CONTENT_BRANCH}' branch. \n"
cd ../${GIT_HUGO_CONTENT_DIR}; git add .

printf "==> Commit Hugo content in '${GIT_HUGO_CONTENT_BRANCH}' branch. \n"
msg="Published Hugo content to '${GIT_HUGO_CONTENT_BRANCH}' branch ($(date '+%Y%m%d %H:%M:%S'))"
git commit -m "$msg" --quiet

# hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ghpages-dpio/

printf "==> Pushing '${GIT_HUGO_CONTENT_DIR}' dir. \n"
git push

printf "==> Returning to current dir. \n"
cd ${CURRENT_DIR}
