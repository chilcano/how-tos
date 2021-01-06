#!/bin/bash

printf "\n"
echo "###############################################################"
echo "#          Migrating existing Jekyll site to Hugo             #"
echo "###############################################################"

DIR_CURRENT=$PWD
GIT_USER="chilcano"
DIR_GITREPOS="gitrepos"
DIR_SOURCE_JEKYLL="ghpages-holosec"
DIR_TARGET_HUGO="ghpages-holosecio"

HUGO_THEME_URL="https://github.com/spf13/herring-cove"
HUGO_THEME_NAME="${HUGO_THEME_URL##*/}"

if [ -f "${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL}/README.md" ]; then
    printf "~~> The '${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL}' GitHub repo exists and contains files. Nothing to do. \n"
else 
    printf "~~> Cloning the '${DIR_SOURCE_JEKYLL}' Jekyll GitHub Pages repo. \n"
    mkdir -p ${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL} 
    git clone https://github.com/${GIT_USER}/${DIR_SOURCE_JEKYLL} ${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL}
fi 

printf "~~> Cleaning existing '${DIR_TARGET_HUGO}' Hugo GitHub Pages repo. \n"
rm -rf ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}
mkdir -p ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}/themes/

printf "~~> Importing from Jekyll to Hugo. \n"
hugo import jekyll --force ${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL} ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}

printf "~~> Importing the '${HUGO_THEME_URL}' Hugo Theme. \n"
git clone ${HUGO_THEME_URL} ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}/themes/${HUGO_THEME_NAME}

printf "~~> Serving the Hugo site in the LAN. \n"
cd ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}/
# hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ghpages-dpio/
printf "\t hugo server -D --bind=0.0.0.0 --theme=${HUGO_THEME_NAME} \n"
printf "\t cd ${DIR_CURRENT} \n\n"
