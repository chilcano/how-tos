#!/bin/bash

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/hugo_publish_holosec.sh)

# Ref: https://gohugo.io/hosting-and-deployment/hosting-on-github/

# *** THIS SCRIPT MUST BE IN THE ROOT OF REPO ***


printf "\n"
echo "###############################################################"
echo "#             Publishing HoloSec Hugo content                 #"
echo "###############################################################"

CURRENT_DIR="${PWD##*/}"

#GIT_REPO="ghpages-holosecio"
#GIT_PARENT_DIR="${HOME}/gitrepos"

HUGO_SCRIPTS_DIR="ghp-scripts"
HUGO_CONTENT_DIR="ghp-content"
HUGO_CONTENT_BRANCH="${HUGO_CONTENT_DIR}"

#printf "==> Changing to '${GIT_PARENT_DIR}/${GIT_REPO}/' as root working dir. \n"
#cd ${GIT_PARENT_DIR}/${GIT_REPO}

if [ "`git status -s`" ]
then
    printf "==> The working directory is dirty. Please commit any pending changes. \n"
    exit 1;
fi

printf "==> Deleting older content and history of '${HUGO_CONTENT_BRANCH}' \n" 
rm -rf ${HUGO_CONTENT_DIR}
mkdir -p ${HUGO_CONTENT_DIR}
git worktree prune
rm -rf .git/worktrees/${HUGO_CONTENT_DIR}/

printf "==> This worktree will allow us to get all content in '${HUGO_CONTENT_BRANCH}' branch as a dir. \n"
git worktree add -B ${HUGO_CONTENT_BRANCH} ${HUGO_CONTENT_DIR} origin/${HUGO_CONTENT_BRANCH}
printf "==> Deleting older content under '${HUGO_CONTENT_BRANCH}' except CNAME \n" 
#rm -rf ${HUGO_CONTENT_DIR}/docs/*
#find ${GIT_PARENT_DIR}/${GIT_REPO}/${HUGO_CONTENT_DIR}/docs/* ! -name 'CNAME' -exec rm -rf {} +
find ${HUGO_CONTENT_DIR}/docs/* ! -name 'CNAME' -exec rm -rf {} +
#git worktree add -B ghp-content ghp-content origin/ghp-content

printf "==> Regenerating Hugo content in <root>/${HUGO_CONTENT_DIR}/docs dir. \n"
cd ${HUGO_SCRIPTS_DIR}; hugo

printf "==> Updating Hugo content in '${HUGO_CONTENT_BRANCH}' branch. \n"
msg="Published content (hugo_publish_holosec.sh)"
cd ../${HUGO_CONTENT_DIR}; git add .; git commit -m "$msg" --quiet

printf "\n"
printf "==> Run this command to push all changes:  git push --all \n\n"

printf "==> Returning to current dir. \n"
cd ..
