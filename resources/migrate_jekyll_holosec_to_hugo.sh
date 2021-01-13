#!/bin/bash

unset _DESTINATION

while [ $# -gt 0 ]; do
  case "$1" in
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
echo "#           Migrating HoloSec Jekyll site to Hugo             #"
echo "###############################################################"

DIR_CURRENT=$PWD
GIT_USER="chilcano"

GIT_REPO="ghpages-dpio"
DIR_GITREPOS="gitrepos"
DIR_SOURCE_JEKYLL="ghpages-holosec"
DIR_TARGET_HUGO="${_DESTINATION:-ghpages-holosecio}"
HUGO_SCRIPTS_DIR="ghp-scripts"
HUGO_CONTENT_DIR="ghp-content"
HUGO_CONTENT_BRANCH="${HUGO_CONTENT_DIR}"

DIR_SOURCE_PATH="${HOME}/${DIR_GITREPOS}/${DIR_SOURCE_JEKYLL}"
DIR_TARGET_PATH="${HOME}/${DIR_GITREPOS}/${DIR_TARGET_HUGO}"

# This command avoids error 'git@github.com: Permission denied ...' when creating repo with hub
printf "==> Setting HTTPS instead of SSH for GitHub clone URLs. \n"
git config --global hub.protocol https

if [ -f "${DIR_SOURCE_PATH}/_config.yml" ]; then
  printf "==> The source GitHub repo (${DIR_SOURCE_PATH}) exists and contains files. Nothing to do. \n"
else 
  printf "==> Cloning the '${DIR_SOURCE_JEKYLL}' Jekyll GitHub Pages repo. \n"
  git clone https://github.com/${GIT_USER}/${DIR_SOURCE_JEKYLL} ${DIR_SOURCE_PATH}
fi 

printf "==> Creating a fresh '${DIR_TARGET_HUGO}' Hugo GitHub Pages repo locally. \n"
rm -rf ${DIR_TARGET_PATH}
mkdir -p ${DIR_TARGET_PATH}/${HUGO_SCRIPTS_DIR}/themes/
mkdir -p ${DIR_TARGET_PATH}/${HUGO_CONTENT_DIR}/

printf "==> Importing from existing Jekyll to the target GitHub repo (${DIR_TARGET_PATH}). \n"
hugo import jekyll --force ${DIR_SOURCE_PATH} ${DIR_TARGET_PATH}/${HUGO_SCRIPTS_DIR}/

printf "==> Changing to '${DIR_TARGET_PATH}' as working directory. \n"
cd ${DIR_TARGET_PATH}/

printf "==> Initializing '${DIR_TARGET_PATH}' Git repository. \n"
git init

printf "==> Removing remote GitHub repo with 'hub'. \n"
echo "yes" | hub delete ${GIT_USER}/${DIR_TARGET_HUGO}

printf "==> Creating an empty repo on GitHub using current dir as repo's name. \n"
hub create -d "GitHub Pages for HoloSec" ${GIT_USER}/${DIR_TARGET_HUGO}

echo "###############################################################"
echo "#      Main branch - Configuring GitHub Pages repo           #"
echo "###############################################################"

printf ">> Adding '.gitignore' file. \n"
cat << EOF > .gitignore
## Hugo
ghp-content/
*.bak
EOF

printf ">> Adding 'README.md' file. \n"
cat << EOF > README.md
Go to [HolisticSecurity.io](https://holisticsecurity.io) website!  
This '${GIT_USER}/${DIR_TARGET_HUGO}' main branch hosts the Hugo scripts.
EOF

printf "==> Changing to '${DIR_TARGET_PATH}/${HUGO_SCRIPTS_DIR}/' as working directory. \n"
cd ${DIR_TARGET_PATH}/${HUGO_SCRIPTS_DIR}/

printf "==> Adding a new Hugo configuration file (config.toml) into '${DIR_TARGET_HUGO}/${HUGO_SCRIPTS_DIR}/'. \n"

rm -rf config.yaml config.yaml.bak config.toml
cat << EOF > config.toml
baseURL = "http://holisticsecurity.io/"
languageCode = "en-us"
title = "HolisticSecurity.io"
theme = "hugo-theme-cactus"
#disqusShortname = "username"
#googleAnalytics = ""
paginate = 20
publishDir = "../${HUGO_CONTENT_DIR}/docs"
copyright = "Chilcano" 
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

printf "==> Pre-loading ${#ARRAY_THEMES_REPO[@]} Hugo Themes. \n"

declare -a ARRAY_THEMES_REPO=(
"https://github.com/calintat/minimal.git"
"https://github.com/zwbetz-gh/minimal-bootstrap-hugo-theme.git"
"https://github.com/ribice/kiss.git"
"https://github.com/vividvilla/ezhil.git"
"https://github.com/monkeyWzr/hugo-theme-cactus.git"
"https://github.com/rhazdon/hugo-theme-hello-friend-ng.git"
"https://github.com/panr/hugo-theme-terminal.git"
"https://github.com/athul/archie.git"
"https://github.com/colorchestra/smol"
)

for tr_url in "${ARRAY_THEMES_REPO[@]}"; do
  tr_fullname="${tr_url##*/}"
  tr_name="${tr_fullname%.*}"
  printf "\t > Cloning the '${tr_name}' Hugo Theme. \n"
  git clone ${tr_url} ${DIR_TARGET_PATH}/${HUGO_SCRIPTS_DIR}/themes/${tr_name} --quiet
  printf "\t > Copying existing configuration of '${tr_name}' included in the theme. \n"
  cp ${DIR_TARGET_PATH}/${HUGO_SCRIPTS_DIR}/themes/${tr_name}/exampleSite/config.toml config.toml.${tr_name}
done

printf "==> Changing to '${DIR_TARGET_PATH}/' as working directory. \n"
cd ${DIR_TARGET_PATH}/

echo "###############################################################"
echo "#      Main branch - First push into GitHub Pages repo        #"
echo "###############################################################"

printf "==> Adding resources to local repo. \n"
git add . --quiet

printf "==> Commit Hugo scripts to local repo. \n"
git commit -m "Hugo scripts for HoloSec site." --quiet

printf "==> Creating the 'main' branch. \n"
git branch -M main

printf "==> Pushing to remote repo in 'main' branch. \n"
git push -u origin main

printf "\n"
echo "###############################################################"
echo "#      ${HUGO_CONTENT_BRANCH} branch - Configuring branch          #"
echo "###############################################################"

printf "==> Create the orphan branch on local machine and switch in this branch. \n"
git checkout --orphan ${HUGO_CONTENT_BRANCH}

printf "==> Removes everything to its initial state. \n"
git reset --hard

printf "==> Commit an empty orphan branch. \n"
git commit --allow-empty -m "Initializing ${HUGO_CONTENT_BRANCH}"

printf "==> Push to remote origin from '${HUGO_CONTENT_BRANCH}'. \n"
git push origin ${HUGO_CONTENT_BRANCH}

printf "==> Switching to 'main' branch. \n"
git checkout main --quiet

printf "\n"
echo "###############################################################"
echo "#      ${HUGO_CONTENT_BRANCH} branch - First push into branch      #"
echo "###############################################################"

printf "==> Delete existing Hugo content dir. \n"
rm -rf ${DIR_TARGET_PATH}/${HUGO_CONTENT_BRANCH}

printf "==> Worktree allows you to have multiple branches of the same local repo to be checked out in different dirs. \n"
git worktree add -B ${HUGO_CONTENT_BRANCH} ${HUGO_CONTENT_DIR} origin/${HUGO_CONTENT_BRANCH}

printf "==> Changing to '${HUGO_SCRIPTS_DIR}/' dir. \n"
cd ${DIR_TARGET_PATH}/${HUGO_SCRIPTS_DIR}

printf "==> Generating Hugo content in <root>/${HUGO_CONTENT_DIR}/docs dir according to 'config.toml'. \n"
hugo

printf "==> Adding 'README.md' file to 'HUGO_CONTENT_BRANCH'. \n"
cat << EOF > README.md
Go to [HolisticSecurity.io](https://holisticsecurity.io) website!  
This '${HUGO_CONTENT_BRANCH}' branch hosts the Hugo content.
EOF
mv -f README.md ${DIR_TARGET_PATH}/${HUGO_CONTENT_DIR}/.

printf "==> Adding Hugo content only to local repo. \n"
cd ../${HUGO_CONTENT_DIR}; git add .

printf "==> Commit Hugo content to local repo. \n"
git commit -m "Publishing Hugo content to ${HUGO_CONTENT_BRANCH}" --quiet; cd ../

# If the changes in your local '${HUGO_CONTENT_BRANCH}' branch look alright, push them to the remote repo.
printf "==> Pushing to remote repo in '${HUGO_CONTENT_BRANCH}' branch. \n"
git push origin ${HUGO_CONTENT_BRANCH}

printf "==> Switching to 'main' branch. \n"
git checkout main --quiet

printf "\n"
echo "###############################################################"
echo "#              Serving the Hugo site over the LAN             #"
echo "###############################################################"

printf "==> Serving the Hugo site over the LAN from '${DIR_TARGET_PATH}' directory with different pre-installed Themes: \n"

INSTALLED_THEMES_STRING="$(ls -d ${DIR_TARGET_PATH}/${HUGO_SCRIPTS_DIR}/themes/*)"
INSTALLED_THEMES_ARRAY=(${INSTALLED_THEMES_STRING})
for theme in "${INSTALLED_THEMES_ARRAY[@]}"; do
  themename="${theme##*/}"
  printf "\t hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ -t=${themename} \n"
done 

printf "==> Serving the Hugo site using default 'hugo-theme-cactus' Theme: \n"
printf "\t hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ \n"

printf "==> Getting back to initial directory. \n"
printf "\t cd ${DIR_CURRENT} \n\n"
