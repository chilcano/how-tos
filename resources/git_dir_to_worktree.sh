#!/bin/bash

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/git_dir_to_worktree.sh) code-server-ec2


if [[ "$1" == *\/* ]] || [[ "$1" == *\\* ]]
then
    printf "==> Please, enter a valid directory name without '/' or '\' . \n"
    exit 1;
fi

## we have to be in the project root
CURRENT_DIR=${PWD}
BRANCH_NAME="${1:-code-server-ec2}"
BRANCH_DIR="${BRANCH_NAME}"

echo "${BRANCH_DIR}" >> .gitignore
git checkout --orphan ${BRANCH_NAME}
git reset --hard
git commit --allow-empty -m "Initializing '${BRANCH_NAME}' branch"
git push origin ${BRANCH_NAME}
# switch to main branch
git checkout main

# cleaning admin files in root 
git worktree prune
rm -rf .git/worktrees/${BRANCH_DIR}/
# make a copy
mv ${BRANCH_DIR} ../.
# ${BRANCH_DIR} can be empty or it shouldn't exist
git worktree add -B ${BRANCH_NAME} ${BRANCH_DIR} origin/${BRANCH_NAME}
#git worktree add -B code-server-ec2 code-server-ec2 origin/code-server-ec2
#cp -R ../${BRANCH_DIR}/* ${BRANCH_DIR}/.
# copy all files, even .gitignore and .npmignore
cp -R ../${BRANCH_DIR}/. ${BRANCH_DIR}/.
cd ${BRANCH_DIR} && git add --all && git commit -m "All content moved" && cd ..
git push origin ${BRANCH_NAME}
#git push origin code-server-ec2