#!/bin/bash

unset _CLEAN _DESTINATION

while [ $# -gt 0 ]; do
  case "$1" in
    --clean*|-c*)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no '=' 
      _CLEAN="${1#*=}"
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

DIR_SOURCE_PATH="${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL}"
DIR_TARGET_PATH="${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}"

if [ -f "${DIR_SOURCE_PATH}/_config.yml" ]; then
  printf "==> The source GitHub repo (${DIR_SOURCE_PATH}) exists and contains files. Nothing to do. \n"
else 
  printf "==> Cloning the '${DIR_SOURCE_JEKYLL}' Jekyll GitHub Pages repo. \n"
  git clone https://github.com/${GIT_USER}/${DIR_SOURCE_JEKYLL} ${DIR_SOURCE_PATH}
fi 

if [ -z "${_CLEAN+x}" ]; then
  printf "==> The target GitHub repo (${DIR_TARGET_PATH}) exists and contains files. Nothing to do. \n"
else 
  printf "==> Creating a cleaned '${DIR_TARGET_HUGO}' Hugo GitHub Pages repo. \n"
  rm -rf ${DIR_TARGET_PATH}
  mkdir -p ${DIR_TARGET_PATH}/ghp-scripts/themes/
fi 

printf "==> Importing from existing Jekyll to the target GitHub repo (${DIR_TARGET_PATH}). \n"
hugo import jekyll --force ${DIR_SOURCE_PATH} ${DIR_TARGET_PATH}/ghp-scripts/

printf "==> Getting into '${DIR_TARGET_PATH}' directory and initializing as Git repository. \n"
cd ${DIR_TARGET_PATH}
git init
cd ${DIR_TARGET_PATH}/ghp-scripts/
mv config.yaml config.yaml.bak

## Preloading Hugo themes:

declare -a ARRAY_THEMES_MODU=(
"https://github.com/calintat/minimal.git"
"https://github.com/zwbetz-gh/minimal-bootstrap-hugo-theme.git"
)

declare -a ARRAY_THEMES_REPO=(
"https://github.com/ribice/kiss.git"
"https://github.com/vividvilla/ezhil.git"
"https://github.com/monkeyWzr/hugo-theme-cactus.git"
"https://github.com/rhazdon/hugo-theme-hello-friend-ng.git"
"https://github.com/panr/hugo-theme-terminal.git"
"https://github.com/athul/archie.git"
"https://github.com/colorchestra/smol"
)

printf "==> Importing the ${#ARRAY_THEMES_MODU[@]} + ${#ARRAY_THEMES_REPO[@]} Hugo Themes. \n"

for tm_url in "${ARRAY_THEMES_MODU[@]}"; do
  tm_fullname="${tm_url##*/}"
  tm_name="${tm_fullname%.*}"
  printf "\t > Adding the '${tm_name}' Hugo Theme as submodule. \n"
  git submodule add ${tm_url} themes/${tm_name} --quiet
  git submodule init  --quiet
  #git submodule update
  git submodule update --remote --merge  --quiet
  printf "\t > Copying existing configuration of '${tm_name}' included in the theme. \n"
   cp themes/${tm_name}/exampleSite/config.toml  config.toml.${tm_name}
done

for tr_url in "${ARRAY_THEMES_REPO[@]}"; do
  tr_fullname="${tr_url##*/}"
  tr_name="${tr_fullname%.*}"
  printf "\t > Adding the '${tr_name}' Hugo Theme as repository. \n"
  git clone ${tr_url} themes/${tr_name}  --quiet
  printf "\t > Copying existing configuration of '${tr_name}' included in the theme. \n"
  cp themes/${tr_name}/exampleSite/config.toml config.toml.${tr_name}
done

printf "==> Configuring a general configuration (config.toml) to the Hugo site. \n"

cat << EOF > config.toml
baseURL = "http://holisticsecurity.io/"
languageCode = "en-us"
title = "HolisticSecurity.io"
theme = "minimal"
#disqusShortname = "username"
#googleAnalytics = ""
paginate = 20
publishDir = "../ghp-content/docs"

copyright = "Roger Carhuatocto" 
#summaryLength = 2

[params]
  colortheme = "white"            # dark, light, white, or classic
  rss = true                      # generate rss feed. default value is false
  googleAnalyticsAsync = true     # use asynchronous tracking. Synchronous tracking by default
  description = "The Systems Thinking Methodology and IT Security."
  #mainSection = "posts"          # your main section
  showAllPostsOnHomePage = false  # default
  postsOnHomePage = 10            # this option will be ignored if showAllPostsOnHomePage is set to true
  tagsOverview = true             # show tags overview by default.
  showProjectsList = false        # show projects list by default (if projects data file exists).
  projectsUrl = "https://github.com/chilcano" # title link for projects list
  dateFormat = "2006-01-02"
  # Post page settings
  show_updated = false 
  [params.comments]
    enabled = true 
    engine = "disqus"             # more supported engines will be added.

[[params.social]]
  name = "github"
  link = "https://github.com/chilcano"
[[params.social]]
  name = "linkedin"
  link = "https://www.linkedin.com/in/chilcano/"
[[params.social]]
  name = "twitter"
  link = "chilcano" 

[markup]
  [markup.tableOfContents]
    endLevel = 4
    ordered = false
    startLevel = 2

[[menu.main]]
  url = "/"
  name = "Home"
  weight = 1
[[menu.main]]
  url = "/about/"
  name = "About"
  weight = 2
[[menu.main]]
  url = "/post/"
  name = "Posts"
  weight = 3
[[menu.main]]
  url = "/tags"
  name = "Tags"
  weight = 4

[[menu.icon]]
  url = "https://github.com/chilcano/"
  name = "fab fa-github"
  weight = 1
[[menu.icon]]
  url = "https://twitter.com/chilcano/"
  name = "fab fa-twitter"
  weight = 2
[[menu.icon]]
  url = "https://www.linkedin.com/in/chilcano/"
  name = "fab fa-linkedin"
  weight = 3
EOF

printf "==> Serving the Hugo site over the LAN from '${DIR_TARGET_PATH}' directory with different pre-installed Themes: \n"

INSTALLED_THEMES_STRING="$(ls -d ${DIR_TARGET_PATH}/ghp-scripts/themes/*)"
INSTALLED_THEMES_ARRAY=(${INSTALLED_THEMES_STRING})
for theme in "${INSTALLED_THEMES_ARRAY[@]}"; do
  themename="${theme##*/}"
  printf "\t hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ -t=${themename} \n"
done 

printf "==> Serving the Hugo site over the LAN from '${DIR_TARGET_PATH}' directory with 'hugo-theme-cactus' Theme: \n"
printf "\t hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ \n"

printf "==> Getting back to initial directory. \n"
printf "\t cd ${DIR_CURRENT} \n\n"
