#!/bin/bash

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/git_worktree_initialize.sh) newbranch

if [[ -z "$1" ]] || [[ "$1" == *\/* ]] || [[ "$1" == *\\* ]]
then
    printf "==> Please, enter a valid directory name without '/' or '\'. \n"
    exit 1;
fi

BRANCH_NAME="${1}"
BRANCH_DIR="${1}"

# echo "${BRANCH_DIR}" >> .gitignore (doesn't work with source <())
# https://askubuntu.com/questions/76808/how-do-i-use-variables-in-a-sed-command
sed -i -e '$a'"${BRANCH_DIR}"'' .gitignore

git checkout --orphan ${BRANCH_NAME}
git reset --hard
git commit --allow-empty -m "Initializing  branch"
git push origin ${BRANCH_NAME}
git checkout main

git worktree prune
rm -rf .git/worktrees/${BRANCH_DIR}/
rm -rf ${BRANCH_DIR}
git worktree add -B ${BRANCH_NAME} ${BRANCH_DIR} origin/${BRANCH_NAME}
cd ${BRANCH_DIR} 
