#!/bin/bash

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/git_worktree_remove.sh) mybranch

if [[ -z "$1" ]] || [[ "$1" == *\/* ]] || [[ "$1" == *\\* ]]
then
    printf "==> Please, enter a valid directory name without '/' or '\'. \n"
    exit 1;
fi

BRANCH_DIR="${1}"

# https://askubuntu.com/questions/76808/how-do-i-use-variables-in-a-sed-command
sed -i '/'"${BRANCH_DIR}"'/d' .gitignore

git worktree remove ${BRANCH_DIR} --force
git branch -D ${BRANCH_DIR} 
git push origin --delete ${BRANCH_DIR}
