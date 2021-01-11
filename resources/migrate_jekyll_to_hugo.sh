#!/bin/bash

unset _THEME_URL _DESTINATION

while [ $# -gt 0 ]; do
  case "$1" in
    --theme*|-t*)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no '=' 
      _THEME_URL="${1#*=}"
      ;;
    --destination*|-d*)
      if [[ "$1" != *=* ]]; then shift; fi
      _DESTINATION="${1#*=}"
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
DIR_TARGET_HUGO="${_DESTINATION:-ghpages-holosecio}"
HUGO_THEME_URL_DEFAULT="https://github.com/calintat/minimal.git"
## Hugo themes:
# https://themes.gohugo.io/minimal - https://github.com/calintat/minimal.git
# https://themes.gohugo.io/kiss - https://github.com/ribice/kiss.git
# https://themes.gohugo.io/ezhil - https://github.com/vividvilla/ezhil.git
# https://themes.gohugo.io/hugo-theme-cactus/ - https://github.com/monkeyWzr/hugo-theme-cactus.git
# https://themes.gohugo.io/minimal-bootstrap-hugo-theme/ - https://github.com/zwbetz-gh/minimal-bootstrap-hugo-theme.git

DIR_SOURCE_PATH="${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL}"
DIR_TARGET_PATH="${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}"
HUGO_THEME_URL="${_THEME_URL:-$HUGO_THEME_URL_DEFAULT}"
HUGO_THEME_FULLNAME="${HUGO_THEME_URL##*/}"
HUGO_THEME_NAME="${HUGO_THEME_FULLNAME%.*}"

if [ -f "${DIR_SOURCE_PATH}/_config.yml" ]; then
  printf "==> The source GitHub repo (${DIR_SOURCE_PATH}) exists and contains files. Nothing to do. \n"
else 
  printf "==> Cloning the '${DIR_SOURCE_JEKYLL}' Jekyll GitHub Pages repo. \n"
  git clone https://github.com/${GIT_USER}/${DIR_SOURCE_JEKYLL} ${DIR_SOURCE_PATH}
fi 

if [ -f "${DIR_TARGET_PATH}/config.toml" ] || [ -f "${DIR_TARGET_PATH}/config.yaml" ] || [ -f "${DIR_TARGET_PATH}/config.yaml.bak" ]; then
  printf "==> The target GitHub repo (${DIR_TARGET_PATH}) exists and contains files. Nothing to do. \n"
else 
  printf "==> Creating a clean '${DIR_TARGET_HUGO}' Hugo GitHub Pages repo. \n"
  rm -rf ${DIR_TARGET_PATH}
  mkdir -p ${DIR_TARGET_PATH}/themes/
fi 

printf "==> Importing from existing Jekyll to the target GitHub repo (${DIR_TARGET_PATH}). \n"
hugo import jekyll --force ${DIR_SOURCE_PATH} ${DIR_TARGET_PATH}

printf "==> Getting into '${DIR_TARGET_PATH}' directory and initializing as Git repository. \n"
cd ${DIR_TARGET_PATH}
git init
mv config.yaml config.yaml.bak

printf "==> Importing and configuring the '${HUGO_THEME_URL}' Hugo Theme. \n"

case "$HUGO_THEME_NAME" in
  minimal | minimal-bootstrap-hugo-theme)
    printf "\t > Using the Hugo Theme as Submodule. \n"
    git submodule add ${HUGO_THEME_URL} themes/${HUGO_THEME_NAME} --quiet
    git submodule init
    #git submodule update
    git submodule update --remote --merge
    ;;
  ezhil | kiss | hugo-theme-cactus)
    printf "\t > Using the Hugo Theme as Repository. \n"
    git clone ${HUGO_THEME_URL} themes/${HUGO_THEME_NAME}
    ;;
  *)
    printf "\t > The Hugo Theme '$HUGO_THEME_NAME' doesn't require custom configuration. \n"
    ;;
esac
cp themes/${HUGO_THEME_NAME}/exampleSite/config.toml .

printf "==> Getting back to initial directory. \n"
cd ${DIR_CURRENT}

printf "==> Serving the Hugo site over the LAN from '${DIR_TARGET_PATH}' directory. \n"
printf "\t hugo server -D --bind=0.0.0.0 --theme=${HUGO_THEME_NAME} --baseURL=http://192.168.1.59:1313/${DIR_TARGET_HUGO}/ \n\n"
printf "\t hugo server -D --bind=0.0.0.0 --theme=${HUGO_THEME_NAME} --baseURL=http://192.168.1.59:1313/${DIR_TARGET_HUGO}/ --destination=${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}_docs/  \n\n"
