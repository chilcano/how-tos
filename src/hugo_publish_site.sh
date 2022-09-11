#!/bin/bash

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_publish_site.sh)

# Ref: https://gohugo.io/hosting-and-deployment/hosting-on-github/

# *** THIS SCRIPT MUST BE IN THE ROOT OF REPO ***

unset _COMMIT_MSG
while [ $# -gt 0 ]; do
  case "$1" in
    --commit_msg*|-m*)
      _COMMIT_MSG="${1#*=}"
      ;;
    --help|-h)
      printf "Publish Hugo content."
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument: '$1' \n"
      exit 1
      ;;
  esac
  shift
done

printf "\n"
echo "###############################################################"
echo "#            Publishing Website / Hugo content                #"
echo "###############################################################"

CURRENT_DIR="${PWD##*/}"

HUGO_SCRIPTS_DIR="ghp-scripts"
HUGO_CONTENT_DIR="ghp-content"
HUGO_CONTENT_BRANCH="${HUGO_CONTENT_DIR}"

if [ -z ${_COMMIT_MSG+x} ]; then
    if [ "`git status -s`" ]; then
        printf "==> The working directory is dirty. Please commit any pending changes or re-run this script with '--commit_msg' or '-m' params. \n"
        exit 1;
    fi
else
    printf "==> Pushing previous changes.\n"
    git add .; git commit -m "Published content: ${_COMMIT_MSG}"; git push
fi

printf "==> Deleting older content and history of '${HUGO_CONTENT_BRANCH}' \n"
rm -rf ${HUGO_CONTENT_DIR}
mkdir -p ${HUGO_CONTENT_DIR}
git worktree prune
rm -rf .git/worktrees/${HUGO_CONTENT_DIR}/

printf "==> This worktree will allow us to get all content in '${HUGO_CONTENT_BRANCH}' branch as a dir. \n"
git worktree add -B ${HUGO_CONTENT_BRANCH} ${HUGO_CONTENT_DIR} origin/${HUGO_CONTENT_BRANCH}
printf "==> Deleting older content under '${HUGO_CONTENT_BRANCH}' except CNAME \n"

find ${HUGO_CONTENT_DIR}/docs/* ! -name 'CNAME' -exec rm -rf {} +

printf "==> Regenerating Hugo content in <root>/${HUGO_CONTENT_DIR}/docs dir. \n"
cd ${HUGO_SCRIPTS_DIR}; hugo

printf "==> Updating Hugo content in '${HUGO_CONTENT_BRANCH}' branch. \n"
msg="Published content (hugo_publish_site.sh)"
cd ../${HUGO_CONTENT_DIR}; git add .; git commit -m "$msg" --quiet

printf "\n"
printf "==> Publishing fresh hugo content with 'git push --all' \n\n"
git push --all

printf "==> Returning to current dir. \n"
cd ../

