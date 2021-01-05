#!/bin/bash

printf "\n"
echo "###############################################################"
echo "#          Migrating existing Jekyll site to Hugo             #"
echo "###############################################################"

DIR_GITREPOS="gitrepos"
DIR_SOURCE_JEKYLL="ghpages-holosec"
DIR_TARGET_HUGO="ghpages-holosecio"
DIR_CURRENT=$PWD

HUGO_THEME_URL="https://github.com/spf13/herring-cove.git"
HUGO_THEME_NAME="${HUGO_THEME_URL##*/}"

rm -rf ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}
mkdir -p ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}/themes/
hugo import jekyll ${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL} ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}

git clone ${HUGO_THEME_URL} ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}/themes/${HUGO_THEME_NAME}

cd ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}/

# hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ghpages-dpio/
hugo server -D --bind=0.0.0.0 --theme=${HUGO_THEME_NAME}
