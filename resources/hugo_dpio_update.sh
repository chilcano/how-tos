#!/bin/bash

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/hugo_dpio_update.sh)

# Ref: https://gohugo.io/hosting-and-deployment/hosting-on-github/

printf "\n"
echo "###############################################################"
echo "#             Updating DPio Hugo content                      #"
echo "###############################################################"

CURRENT_DIR=$PWD
GIT_ORG="data-plane"
GIT_REPO="ghpages-dpio"
HUGO_SCRIPTS_DIR="ghp-scripts"
GIT_PARENT_DIR="${HOME}/gitrepos"
HUGO_CONTENT_DIR="ghp-content"
HUGO_CONTENT_BRANCH="${HUGO_CONTENT_DIR}"

printf "==> Changing to '${GIT_PARENT_DIR}/${GIT_REPO}/' as root working dir. \n"
cd ${GIT_PARENT_DIR}/${GIT_REPO}

#printf "==> Switching to 'main' branch. \n"
#git checkout main --quiet

if [ "`git status -s`" ]
then
    printf "==> The working directory is dirty. Please commit any pending changes. \n"
    cd ${CURRENT_DIR}
    exit 1;
fi

printf "==> Deleting older content and history of '${HUGO_CONTENT_BRANCH}' \n" 
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO}/${HUGO_CONTENT_DIR}/
#mkdir -p ${GIT_PARENT_DIR}/${GIT_REPO}/${HUGO_CONTENT_DIR}/
git worktree prune
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO}/.git/worktrees/${HUGO_CONTENT_DIR}/

printf "==> This worktree will allow us to get all content in '${HUGO_CONTENT_BRANCH}' branch as a dir. \n"
git worktree add -B ${HUGO_CONTENT_BRANCH} ${HUGO_CONTENT_DIR} origin/${HUGO_CONTENT_BRANCH}
printf "==> Deleting older content and history under '${HUGO_CONTENT_BRANCH}' except CNAME \n" 
#rm -rf ${HUGO_CONTENT_DIR}/docs/*
find ${GIT_PARENT_DIR}/${GIT_REPO}/${HUGO_CONTENT_DIR}/docs/* ! -name 'CNAME' -exec rm -rf {} +
#git worktree add -B ghp-content ghp-content origin/ghp-content

#printf "==> Forcinf to adding CNAME file in '${HUGO_CONTENT_DIR}/docs/'. \n"
#cat << EOF > CNAME
#data-plane.io
#EOF
#mv -f CNAME ${HUGO_CONTENT_DIR}/docs/.

# no es necesario
#printf "==> Pulling latest changes of Hugo content from '${HUGO_CONTENT_BRANCH}' branch. \n"
#cd ${HUGO_CONTENT_DIR}; git pull; cd ../

printf "==> Regenerating Hugo content in <root>/${HUGO_CONTENT_DIR}/docs dir. \n"
cd ${GIT_PARENT_DIR}/${GIT_REPO}/${HUGO_SCRIPTS_DIR}; hugo

printf "==> Updating Hugo content in '${HUGO_CONTENT_BRANCH}' branch. \n"
msg="hugo_dpio_update.sh > Published content to '${HUGO_CONTENT_BRANCH}' branch ($(date '+%Y%m%d %H:%M:%S'))"
cd ${GIT_PARENT_DIR}/${GIT_REPO}/${HUGO_CONTENT_DIR}; git add .; git commit -m "$msg" --quiet

printf "\n"
printf "==> Run this command to push all changes:  git push --all \n\n"

printf "==> Returning to current dir. \n"
cd ${CURRENT_DIR}
