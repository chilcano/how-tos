#!/bin/bash

unset _GH_USERNAME _GH_EMAIL

while [ $# -gt 0 ]; do
  case "$1" in
    --username*|-u*)
      if [[ "$1" != *=* ]]; then shift; fi
      _GH_USERNAME="${1#*=}"
      ;;
    --email*|-e*)
      if [[ "$1" != *=* ]]; then shift; fi
      _GH_EMAIL="${1#*=}"
      ;;
    *)
      >&2 printf "Error: Invalid argument: '$1' \n"
      exit 1
      ;;
  esac
  shift
done

GITHUB_USERNAME="${_GH_USERNAME:-chilcano}"
GITHUB_EMAIL="${_GH_EMAIL:-chilcano@intix.info}"

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/git_and_hub_setting_in_linux.sh)
# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/git_and_hub_setting_in_linux.sh) -u=Chilcano -e=chilcano@intix.info

printf "\n"
echo "##########################################################"
echo "   Installing and configuring Git and Hub CLI on Ubuntu   "
echo "##########################################################"

printf "\n"
echo "> HitHub's Hub is a wrapper of git CLI useful to automate some git operations, It requires"
echo "> generate a new Personal Access Token (PAT) in the GitHub > Settings > Developer settings" 
echo "> (https://github.com/settings/tokens) anduse it as Password when It's prompted in your"
echo "> Terminal, even if 'git' command is used."

printf "\n"
printf "==> Installing Git CLI and other tools. \n"
sudo apt -yqq install curl wget jq unzip git

printf "==> Installing Hub CLI. \n"
sudo apt -yqq install hub

printf "==> Setting GitHub user.email and user.name. \n"
git config --global user.email "${GITHUB_EMAIL}"
git config --global user.name "${GITHUB_USERNAME}"

printf "==> Setting GitHub to save the credentials permanently. \n"
git config --global credential.helper store

# This command avoids error 'git@github.com: Permission denied ...' when creating repo with hub
printf "==> Setting GitHub HTTPS instead of SSH. \n"
git config --global hub.protocol https

printf "==> Testing Hub CLI - Create a Git repository in GitHub.com. \n"
CURRENT_DIR="${PWD}"
REPO_TMP_DIR="${GITHUB_USERNAME}_testrepo"
rm -rf ${REPO_TMP_DIR}
mkdir -p ${REPO_TMP_DIR}
cd ${REPO_TMP_DIR}
printf "> Initializing '${GITHUB_USERNAME}_test_repo' folder. \n"
git init
printf "> Create a repo on GitHub from an initialized folder. \n"
hub create -d "The repository '${REPO_TMP_DIR}' created!" ${GITHUB_USERNAME}/${REPO_TMP_DIR}
printf "> The '${GITHUB_USERNAME}/${REPO_TMP_DIR}' was created successfully. \n"

printf "==> Testing Hub CLI - Remove a Git repository in GitHub.com. \n"
printf "> Removing remote GitHub repo. \n"
hub delete ${GITHUB_USERNAME}/${REPO_TMP_DIR}
printf "> Going back to initial directory. \n"
cd ${CURRENT_DIR}

printf "==> Testing Hub CLI completed. \n"
printf "> Now can remove created directory. \n"
