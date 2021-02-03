#!/bin/bash

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/git_initialize_worktree.sh) newbranch

if [[ -z "$1" ]] || [[ "$1" == *\/* ]] || [[ "$1" == *\\* ]]
then
    printf "==> Please, enter a valid directory name without '/' or '\'. \n"
    exit 1;
fi

BRANCH_NAME="${1:-newbranch}"
BRANCH_DIR="${BRANCH_NAME}"

####echo "${BRANCH_DIR}" >> .gitignore
sed -i "$ a ${BRANCH_DIR}" .gitignore

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
