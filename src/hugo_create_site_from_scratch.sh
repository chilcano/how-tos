#!/bin/bash

unset _GHUSER _GHDESTINATION _HUGOTHEME

declare -a ARRAY_THEMES_REPO=(
"https://github.com/calintat/minimal.git"
"https://github.com/zwbetz-gh/minimal-bootstrap-hugo-theme.git"
"https://github.com/ribice/kiss.git"
"https://github.com/vividvilla/ezhil.git"
"https://github.com/monkeyWzr/hugo-theme-cactus.git"
"https://github.com/rhazdon/hugo-theme-hello-friend-ng.git"
"https://github.com/panr/hugo-theme-terminal.git"
"https://github.com/athul/archie.git"
"https://github.com/nunocoracao/blowfish.git"
"https://github.com/httpsecure/kembang.git"
"https://github.com/canstand/compost.git"
"https://github.com/h-enk/doks.git"
"https://github.com/jpanther/congo.git"
"https://github.com/cyevgeniy/monday-theme.git"
"https://github.com/zerostaticthemes/hugo-whisper-theme.git"
"https://github.com/kimcc/hugo-theme-noteworthy.git"
)

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_create_site_from_scratch.sh)
# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_create_site_from_scratch.sh) -u=chilcano -d=ghpages-waskhar -t=hugo-theme-cactus
# ./hugo_create_site_from_scratch.sh -u=chilcano -d=ghpages-waskhar -t=hugo-theme-cactus

while [ $# -gt 0 ]; do
  case "$1" in
    --ghuser*|-u*)
      if [[ "$1" != *=* ]]; then shift; fi
      _GHUSER="${1#*=}"
      ;;
    --destination*|-d*)
      if [[ "$1" != *=* ]]; then shift; fi
      _GHDESTINATION="${1#*=}"
      ;;
    --hugotheme*|-t*)
      if [[ "$1" != *=* ]]; then shift; fi
      _HUGOTHEME="${1#*=}"
      ;;
    --help|-h)
      printf "Create an initial GitHub Pages site with Hugo."
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument: '$1' \n"
      exit 1
      ;;
  esac
  shift
done

DIR_CURRENT=$PWD

GH_USER_OR_ORG="${_GHUSER:-chilcano}"
GH_REPO_TARGET="${_GHDESTINATION:-ghpages-waskhar}"
DIR_REPO="${DIR_CURRENT}/${GH_REPO_TARGET}"

GH_REPO_URL_TARGET="https://github.com/${GH_USER_OR_ORG}/${GH_REPO_TARGET}.git"

HUGO_SCRIPTS_DIR="ghp-scripts"
HUGO_CONTENT_DIR="ghp-content"
HUGO_CONTENT_BRANCH="${HUGO_CONTENT_DIR}"

HUGO_THEME_NAME="${_HUGOTHEME:-hugo-theme-cactus}"

printf "\n"
echo "####################################################################"
echo " Create GitHub Page Site with Hugo"
echo "####################################################################"

# This command avoids error 'git@github.com: Permission denied ...' when creating repo with hub
printf "==> Setting HTTPS instead of SSH for GitHub clone URLs. \n"
git config --global hub.protocol https


printf "==> Removing existing remote GitHub repo with 'hub'. \n"
echo "yes" | hub delete ${GH_REPO_URL_TARGET}

printf "==> Removing local '${GH_REPO_TARGET}' GitHub repo. \n"
rm -rf ${DIR_REPO}

printf "==> Creating a fresh '${GH_REPO_TARGET}' GitHub repo with 'hub' using current dir as repo's name. \n"
mkdir -p ${DIR_REPO}
cd ${DIR_REPO}
git config --global init.defaultBranch main
git init
hub create -d "GitHub Pages Site to host ${GH_REPO_TARGET}" ${GH_USER_OR_ORG}/${GH_REPO_TARGET}

printf "==> Creating a new Hugo Site locally. \n"
hugo new site ${DIR_REPO}/${HUGO_SCRIPTS_DIR}/

printf "==> Adding '.gitignore' file. \n"
cat << EOF > .gitignore
## Hugo
ghp-content/
*.bak
EOF

printf "==> Adding 'README.md' file. \n"
cat << EOF > README.md
* Website: [https://__${GH_USER_OR_ORG}__.github.io/__${GH_REPO_TARGET}__/](https://${GH_USER_OR_ORG}.github.io/${GH_REPO_TARGET}/) 
* The folder __${HUGO_SCRIPTS_DIR}/__ in __main__ branch of __${GH_REPO_TARGET}__ contains the Hugo scripts, themes and configurations.
EOF

printf "==> Adding hugo_run_locally.sh and hugo_publish_site.sh to main branch. \n"
wget -q https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_publish_site.sh
wget -q https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_run_locally.sh
chmod +x hugo_*.sh
printf "==> Adding a new Hugo configuration file (config.toml) into '${GH_REPO_TARGET}/${HUGO_SCRIPTS_DIR}/'. \n"

cd ${DIR_REPO}/${HUGO_SCRIPTS_DIR}/
rm -rf config.yaml config.yaml.bak config.toml
cat << EOF > config.toml
baseURL = "https://${GH_USER_OR_ORG}.github.io/${GH_REPO_TARGET}/"
languageCode = "en-us"
title = "Waskhar Project"
theme = "hugo-theme-cactus"
publishDir = "../${HUGO_CONTENT_DIR}/docs"
#copyright = "Roger Carhuatocto"
#disqusShortname = "username"
#googleAnalytics = ""
paginate = 10
#summaryLength = 2

[params]
  colortheme = "classic"                      # dark, light, white, or classic
  rss = true                                  # generate rss feed. default value is false
  googleAnalyticsAsync = true                 # use asynchronous tracking. Synchronous tracking by default
  description = "Proyecto de digitalización y mejora de la trazabilidad a lo largo de la cadena de suministro de la Madera."
  #mainSection = "posts"                      # your main section
  showAllPostsOnHomePage = false              # default
  postsOnHomePage = 10                        # this option will be ignored if showAllPostsOnHomePage is set to true
  tagsOverview = true                         # show tags overview by default.
  showProjectsList = false                    # show projects list by default (if projects data file exists).
  projectsUrl = "https://github.com/chilcano" # title link for projects list
  dateFormat = "2006-01-02"
  # Post page settings
  show_updated = false 
  [params.comments]
    enabled = true 
    engine = "disqus"                         # more supported engines will be added.

[[params.social]]
  name = "github"
  link = "https://github.com/waskhar-project"
[[params.social]]
  name = "twitter"
  ink = "https://twitter.com/chilcano"  

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
  url = "/posts/"
  name = "Posts"
  weight = 2
[[menu.main]]
  url = "/tags"
  name = "Tags"
  weight = 3
[[menu.main]]
  url = "/about/"
  name = "About"
  weight = 4

[[menu.icon]]
  url = "https://github.com/waskhar-project/"
  name = "fab fa-github"
  weight = 1
[[menu.icon]]
  url = "https://twitter.com/chilcano/"
  name = "fab fa-twitter"
  weight = 2
EOF

printf "\n"
echo "---------------------------------------------------------------"
echo " Main branch - Loading a Hugo Theme."
echo "---------------------------------------------------------------"

printf "==> Pre-loading ${#ARRAY_THEMES_REPO[@]} Hugo Themes. \n"

for tr_url in "${ARRAY_THEMES_REPO[@]}"; do
  tr_fullname="${tr_url##*/}"
  tr_name="${tr_fullname%.*}"
  git clone ${tr_url} ${DIR_REPO}/${HUGO_SCRIPTS_DIR}/themes/${tr_name} --quiet
  rm -rf ${DIR_REPO}/${HUGO_SCRIPTS_DIR}/themes/${tr_name}/.git
  cp ${DIR_REPO}/${HUGO_SCRIPTS_DIR}/themes/${tr_name}/exampleSite/config.toml config.toml.${tr_name}
done

printf "\n"
echo "---------------------------------------------------------------"
echo " Main branch - First push into GitHub Pages repo"
echo "---------------------------------------------------------------"

printf "==> Changing to '${DIR_REPO}/' as working directory. \n"
cd ${DIR_REPO}/

printf "==> Adding resources to local repo. \n"
git add . 

printf "==> Commit Hugo scripts to local repo. \n"
git commit -m "First commit. Updating Hugo scripts folder." --quiet

printf "==> Creating the 'main' branch. \n"
git branch -M main

printf "==> Pushing to remote repo into 'main' branch. \n"
git push -u origin main --quiet

printf "\n"
echo "---------------------------------------------------------------"
echo " ${HUGO_CONTENT_BRANCH} branch - Configuring branch"
echo "---------------------------------------------------------------"

printf "==> Create the orphan branch on locally and switch to this branch. \n"
git checkout --orphan ${HUGO_CONTENT_BRANCH}

printf "==> Removes everything to its initial state. \n"
git reset --hard

printf "==> Commit an empty orphan branch. \n"
git commit --allow-empty -m "Initializing ${HUGO_CONTENT_BRANCH} folder."

printf "==> Push to remote origin from '${HUGO_CONTENT_BRANCH}' folder. \n"
git push -u origin ${HUGO_CONTENT_BRANCH} --quiet

printf "==> Switching back to 'main' branch. \n"
git checkout main --quiet

printf "\n"
echo "---------------------------------------------------------------"
echo " ${HUGO_CONTENT_BRANCH} branch - First push into branch"
echo "---------------------------------------------------------------"

printf "==> Delete existing Hugo content dir. \n"
rm -rf ${DIR_REPO}/${HUGO_CONTENT_DIR}

printf "==> Worktree allows you to have multiple branches of the same local repo to be checked out in different dirs. \n"
git worktree add -B ${HUGO_CONTENT_BRANCH} ${HUGO_CONTENT_DIR} origin/${HUGO_CONTENT_BRANCH}

printf "==> Generating Hugo content in ${HUGO_CONTENT_DIR}/docs dir according to 'config.toml'. \n"
cd ${DIR_REPO}/${HUGO_SCRIPTS_DIR}/; hugo 

printf "==> Adding 'README.md' file to 'HUGO_CONTENT_BRANCH'. \n"
cat << EOF > README.md
* Website: [https://__${GH_USER_OR_ORG}__.github.io/__${GH_REPO_TARGET}__/](https://${GH_USER_OR_ORG}.github.io/${GH_REPO_TARGET}/) 
* This __${HUGO_CONTENT_BRANCH}__ branch hosts the Hugo content.
EOF
mv -f README.md ${DIR_REPO}/${HUGO_CONTENT_DIR}/.

printf "==> Adding initial Hugo content only to local repo. \n"
cd ../${HUGO_CONTENT_DIR}; git add .

printf "==> Commit Hugo content to local repo. \n"
git commit -m "Publishing Hugo content to ${HUGO_CONTENT_BRANCH}" --quiet; cd ../

# If the changes in your local '${HUGO_CONTENT_BRANCH}' branch look alright, push them to the remote repo.
printf "==> Pushing to remote repo in '${HUGO_CONTENT_BRANCH}' branch. \n"
git push origin ${HUGO_CONTENT_BRANCH} --quiet

printf "==> Switching to 'main' branch. \n"
git checkout main --quiet

printf "\n"
echo "---------------------------------------------------------------"
echo " Generate new content (post)"
echo "---------------------------------------------------------------"
echo "* Switch to main branch: git checkout main --quiet"
echo "* Goto Hugo Scripts folder: ${DIR_REPO}/${HUGO_SCRIPTS_DIR}/"
echo "* Run hugo to create a new post: hugo new posts/post-01.md"
echo "* Run hugo to create a new page: hugo new about.md"

printf "\n"
echo "---------------------------------------------------------------"
echo " Serving the Hugo site over the LAN"
echo "---------------------------------------------------------------"
echo "==> In the root ${DIR_REPO}/ of your repo for main branch, run any of the next commands:"
echo "* hugo server --source ghp-scripts --bind=0.0.0.0 --baseURL=http://<Your-IP-Address>:1313/ -D"
echo "* source hugo_run_locally.sh"

printf "\n"
echo "---------------------------------------------------------------"
echo " Publish the new generated content to GitHub Pages repo"
echo "---------------------------------------------------------------"
echo '* Run the script: source hugo_publish_site.sh -m="New post published"'

printf "\n"
echo "---------------------------------------------------------------"
echo " Enable GitHub Page to serve the Hugo Site"
echo "---------------------------------------------------------------"
printf "==> Enable this Site in GitHub Pages configuration page. Once configurated, wait 5 minutes to refresh changes: \n"
echo "* https://github.com/${GH_USER_OR_ORG}/${GH_REPO_TARGET}/settings/pages \n\n"

printf "==> Getting back to initial directory. \n"
cd ${DIR_CURRENT}
