#!/bin/bash

unset _THEME_URL

while [ $# -gt 0 ]; do
  case "$1" in
    --theme*|-t*)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no '=' 
      _THEME_URL="${1#*=}"
      ;;
    --help|-h)
      printf "Migrate Jekyll GitHub Pages site to Hugo."
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
echo "#          Migrating existing Jekyll site to Hugo             #"
echo "###############################################################"

DIR_CURRENT=$PWD
GIT_USER="chilcano"
DIR_GITREPOS="gitrepos"
DIR_SOURCE_JEKYLL="ghpages-holosec"
DIR_TARGET_HUGO="ghpages-holosecio"
HUGO_THEME_URL_DEFAULT="https://github.com/calintat/minimal"
## Minimal themes:
# https://themes.gohugo.io/minimal - https://github.com/calintat/minimal.git
# https://themes.gohugo.io/hugo-researcher
# https://themes.gohugo.io/hugo_theme_pickles
# https://themes.gohugo.io/hugo-theme-console
# https://themes.gohugo.io/etch
# https://themes.gohugo.io/kiss - https://github.com/ribice/kiss
# https://themes.gohugo.io/ezhil - https://github.com/vividvilla/ezhil.git

HUGO_THEME_URL="${_THEME_URL:-$HUGO_THEME_URL_DEFAULT}"
HUGO_THEME_NAME="${HUGO_THEME_URL##*/}"

if [ -f "${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL}/README.md" ]; then
    printf "==> The '${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL}' GitHub repo exists and contains files. Nothing to do. \n"
else 
    printf "==> Cloning the '${DIR_SOURCE_JEKYLL}' Jekyll GitHub Pages repo. \n"
    mkdir -p $HOME/$DIR_GITREPOS/$DIR_SOURCE_JEKYLL 
    git clone https://github.com/${GIT_USER}/${DIR_SOURCE_JEKYLL} ${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL}
fi 

printf "==> Cleaning existing '${DIR_TARGET_HUGO}' Hugo GitHub Pages repo. \n"
rm -rf $HOME/$DIR_GITREPOS/$DIR_TARGET_HUGO
mkdir -p $HOME/$DIR_GITREPOS/$DIR_TARGET_HUGO/themes/

printf "==> Importing from Jekyll to Hugo. \n"
hugo import jekyll --force ${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL} ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}

printf "==> Importing the '${HUGO_THEME_URL}' Hugo Theme. \n"
git clone ${HUGO_THEME_URL} ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}/themes/${HUGO_THEME_NAME}

printf "==> Serving the Hugo site over the LAN. \n"
cd $HOME/$DIR_GITREPOS/$DIR_TARGET_HUGO
printf "\t cd ${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO} \n\n"
printf "\t hugo server -D --bind=0.0.0.0 --theme=${HUGO_THEME_NAME} --baseURL=http://192.168.1.59:1313/${DIR_TARGET_HUGO}/ \n"
printf "\t cd ${DIR_CURRENT} \n\n"
