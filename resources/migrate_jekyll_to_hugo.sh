#!/bin/bash

unset _GHUSER _GHSOURCE _GHDESTINATION _HUGOTHEME

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
 
# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/migrate_jekyll_to_hugo.sh)
# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/migrate_jekyll_to_hugo.sh) -d=site01
# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/migrate_jekyll_to_hugo.sh) -u=chilcano -s=https://github.com/chilcano/ghpages-holosec.git -d=site02 -t=hugo-theme-cactus

while [ $# -gt 0 ]; do
  case "$1" in
    --ghuser*|-u*)
      if [[ "$1" != *=* ]]; then shift; fi
      _GHUSER="${1#*=}"
      ;;
    --source_url*|-s*)
      if [[ "$1" != *=* ]]; then shift; fi
      _GHSOURCE_URL="${1#*=}"
      ;;
    --destination*|-d*)
      if [[ "$1" != *=* ]]; then shift; fi
      _GHDESTINATION="${1#*=}"
      ;;
    --hugotheme*|-t*)
      if [[ "$1" != *=* ]]; then shift; fi
      _HUGOTHEME="${1#*=}"
      for _url in "${ARRAY_THEMES_REPO[@]}"; do
        _fullname="${_url##*/}"
        _name="${_fullname%.*}"
        if [ $_name == $_HUGOTHEME ]; then shift; fi
      done
      ;;
    --help|-h)
      printf "Migrate Jekyll GitHub Pages site to Hugo. \n"
      printf "migrate_jekyll_to_hugo.sh -u=chilcano -s=https://github.com/chilcano/ghpages-holosec.git -d=ghpages-holosecio -t=hugo-theme-cactus \n"
      printf " --ghuser | -u \n"
      printf " --source_url | -s \n"
      printf " --destination | -d \n"
      printf " --hugotheme | -t : minimal, minimal-bootstrap-hugo-theme, kiss, ezhil, hugo-theme-cactus, hugo-theme-hello-friend-ng, hugo-theme-terminal, archie, smol \n"
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
GH_ROOT_DIR="gitrepos"
GH_USER="${_GHUSER:-chilcano}"
GHREPO_SOURCE_JEKYLL_URL="${_GHSOURCE_URL:-https://github.com/chilcano/ghpages-holosec.git}"
_GHREPOFULLNAME="${GHREPO_SOURCE_JEKYLL_URL##*/}"
_GHREPONAME="${_GHREPOFULLNAME%.*}"
REPONAME_SOURCE_JEKYLL="${_GHREPONAME:-ghpages-holosec}"
REPONAME_TARGET_HUGO="${_GHDESTINATION:-ghpages-holosecio}"
HUGO_SCRIPTS_DIR="ghp-scripts"
HUGO_CONTENT_DIR="ghp-content"
HUGO_SITE_TITLE="Holistic Security"
HUGO_CONTENT_BRANCH="${HUGO_CONTENT_DIR}"
PATH_SOURCE_REPO="${HOME}/${GH_ROOT_DIR}/${REPONAME_SOURCE_JEKYLL}"
PATH_TARGET_REPO="${HOME}/${GH_ROOT_DIR}/${REPONAME_TARGET_HUGO}"
HUGO_THEME_NAME="${_HUGOTHEME:-hugo-theme-cactus}"

printf "\n"
echo "####################################################################"
echo " Migrating '${GH_USER}/${REPONAME_SOURCE_JEKYLL}' Jekyll Site to Hugo"
echo "####################################################################"

# This command avoids error 'git@github.com: Permission denied ...' when creating repo with hub
printf "==> Setting HTTPS instead of SSH for GitHub clone URLs. \n"
git config --global hub.protocol https

printf "\n"
echo "---------------------------------------------------------------"
echo "  Clone/download existing Jekyll GitHub Pages site"
echo "---------------------------------------------------------------"

if [ -f "${PATH_SOURCE_REPO}/_config.yml" ]; then
  printf "==> The source GitHub repo (${PATH_SOURCE_REPO}) exists and contains files. Nothing to do. \n"
else 
  printf "==> Cloning the '${REPONAME_SOURCE_JEKYLL}' Jekyll GitHub Pages repo. \n"
  git clone ${GHREPO_SOURCE_JEKYLL_URL} ${PATH_SOURCE_REPO}
fi 

printf "==> Creating a fresh '${REPONAME_TARGET_HUGO}' Hugo GitHub Pages repo locally. \n"
rm -rf ${PATH_TARGET_REPO}
mkdir -p ${PATH_TARGET_REPO}/${HUGO_SCRIPTS_DIR}/
mkdir -p ${PATH_TARGET_REPO}/${HUGO_CONTENT_DIR}/

printf "==> Importing from existing Jekyll repo (${PATH_SOURCE_REPO}) to the target GitHub repo (${PATH_TARGET_REPO}/${HUGO_SCRIPTS_DIR}). \n"
hugo import jekyll --force ${PATH_SOURCE_REPO} ${PATH_TARGET_REPO}/${HUGO_SCRIPTS_DIR}/

printf "==> Changing to '${PATH_TARGET_REPO}' as working directory. \n"
cd ${PATH_TARGET_REPO}/

printf "==> Initializing '${PATH_TARGET_REPO}' Git repository. \n"
git init

printf "==> Removing remote GitHub repo with 'hub'. \n"
echo "yes" | hub delete ${GH_USER}/${REPONAME_TARGET_HUGO}

printf "==> Creating an empty repo on GitHub using current dir as the repository name. \n"
hub create -d "GitHub Pages for HoloSec" ${GH_USER}/${REPONAME_TARGET_HUGO}

printf "\n"
echo "---------------------------------------------------------------"
echo " Main branch - Configuring GitHub Pages repo"
echo "---------------------------------------------------------------"

printf "==> Adding '.gitignore' file. \n"
cat << EOF > .gitignore
## Hugo
ghp-content/
*.bak
EOF

printf "==> Adding 'README.md' file. \n"
cat << EOF > README.md
Website [https://__${GH_USER}__.github.io/__${REPONAME_TARGET_HUGO}__/](https://${GH_USER}.github.io/${REPONAME_TARGET_HUGO}/) !  

This '${GH_USER}/${REPONAME_TARGET_HUGO}' main branch hosts the Hugo scripts.
EOF

printf "==> Changing to '${PATH_TARGET_REPO}/${HUGO_SCRIPTS_DIR}/' as working directory. \n"
cd ${PATH_TARGET_REPO}/${HUGO_SCRIPTS_DIR}/

printf "==> This scripts can install ${#ARRAY_THEMES_REPO[@]} Hugo Themes, but only one can be used. \n"
printf "> Removing existing Hugo configuration file. \n"
rm -rf config.yaml config.yaml.bak config.toml

for tr_url in "${ARRAY_THEMES_REPO[@]}"; do
  tr_fullname="${tr_url##*/}"
  tr_name="${tr_fullname%.*}"
  if [ $tr_name == $HUGO_THEME_NAME ]; then
    printf "> Cloning the '${tr_name}' Hugo Theme. \n"
    git clone ${tr_url} themes/${tr_name} --quiet
    printf "> Removing '.git/', '.github/' and '.gitignore' of '${tr_name}'. \n"
    rm -rf themes/${tr_name}/.git
    printf "> Copying existing configuration of '${tr_name}' included in the theme. \n"
    cp themes/${tr_name}/exampleSite/config.toml config.toml
  fi
done

printf "==> Tweaking the new Hugo configuration file '${REPONAME_TARGET_HUGO}/${HUGO_SCRIPTS_DIR}/config.toml'. \n"
sed -i.bak "s|^baseURL = .*$|baseURL = \"https://${GH_USER}.github.io/${REPONAME_TARGET_HUGO}/\"|" config.toml
sed -i.bak "s|^title = .*$|title = \"${HUGO_SITE_TITLE}\"|" config.toml
sed -i.bak "s|^theme = .*$|theme = \"${HUGO_THEME_NAME}\"|" config.toml

# if publishDir exist, then update it else add it after theme
# sed -e '/^\(option=\).*/{s//\1value/;:a;n;ba;q}' -e '$aoption=value' filename
# grep -q '^option' file && sed -i 's/^option.*/option=value/' file || echo 'option=value' >> file
grep -q '^publishDir' config.toml && sed -i "s|^publishDir = .*$|publishDir = \"../${HUGO_CONTENT_DIR}/docs\"|" config.toml || sed -i "s|^\(theme = .*\)$|\1\npublishDir = \"../${HUGO_CONTENT_DIR}/docs\"|" config.toml

if [[ "${GHREPO_SOURCE_JEKYLL_URL,,}" =~  .*"github.com/chilcano/ghpages-holosec".* ]]; then
  printf "\n"
  echo "---------------------------------------------------------------"
  echo " Main branch - Removing unused files "
  echo " (only for https://github.com/chilcano/ghpages-holosec.git)"
  echo "---------------------------------------------------------------"
  rm -rf static/wp_export/
  rm -rf static/CNAME
  rm -rf static/assets/fonts/
  rm -rf static/assets/main.scss
  find static/assets/ -maxdepth 1 -type f -name '*.png' -o -name '*.jpg' -o -name '*.pdf' -exec rm -rf {} \;
  rm -rf static/assets/blog
  rm -rf static/assets/blog201*
  find content/post -maxdepth 1 -type f -name '200[7-9]*' -exec rm -rf {} \;
  find content/post -maxdepth 1 -type f -name '201[0-8]*' -exec rm -rf {} \;
fi

printf "==> Changing to '${PATH_TARGET_REPO}/' as working directory. \n"
cd ${PATH_TARGET_REPO}/

printf "\n"
echo "---------------------------------------------------------------"
echo " Main branch - First push into GitHub Pages repo"
echo "---------------------------------------------------------------"

printf "==> Adding resources to local repo. \n"
git add . 

printf "==> Commit Hugo scripts to local repo. \n"
git commit -m "Hugo scripts for HoloSec site." --quiet

printf "==> Creating the 'main' branch. \n"
git branch -M main

printf "==> Pushing to remote repo in 'main' branch. \n"
git push -u origin main

printf "\n"
echo "---------------------------------------------------------------"
echo " Content branch - Initializing '${HUGO_CONTENT_BRANCH}' branch"
echo "---------------------------------------------------------------"

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
echo "---------------------------------------------------------------"
echo " Content branch - First push into ' ${HUGO_CONTENT_BRANCH}' branch"
echo "---------------------------------------------------------------"

printf "==> Delete existing Hugo content dir. \n"
rm -rf ${PATH_TARGET_REPO}/${HUGO_CONTENT_BRANCH}

printf "==> Worktree allows you to have multiple branches of the same local repo to be checked out in different dirs. \n"
git worktree add -B ${HUGO_CONTENT_BRANCH} ${HUGO_CONTENT_DIR} origin/${HUGO_CONTENT_BRANCH}

printf "==> Changing to '${HUGO_SCRIPTS_DIR}/' dir. \n"
cd ${PATH_TARGET_REPO}/${HUGO_SCRIPTS_DIR}/

printf "==> Generating Hugo content in <root>/${HUGO_CONTENT_DIR}/docs dir according to 'config.toml'. \n"
hugo

printf "==> Adding 'README.md' file to 'HUGO_CONTENT_BRANCH'. \n"
cat << EOF > README.md
Website [https://__${GH_USER}__.github.io/__${REPONAME_TARGET_HUGO}__/](https://${GH_USER}.github.io/${REPONAME_TARGET_HUGO}/) !  

This '${HUGO_CONTENT_BRANCH}' branch hosts the Hugo content.
EOF
mv -f README.md ${PATH_TARGET_REPO}/${HUGO_CONTENT_DIR}/.

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
echo "---------------------------------------------------------------"
echo " Serving the Hugo site over the LAN"
echo "---------------------------------------------------------------"
printf "==> Changing to '${HUGO_SCRIPTS_DIR}/' dir. \n"
cd ${PATH_TARGET_REPO}/${HUGO_SCRIPTS_DIR}/

printf "==> Serving the Hugo site using the '${HUGO_THEME_NAME}' theme: \n"
printf "> hugo server -D --bind=0.0.0.0 \n"
printf "> hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ \n"
printf "> cd ${DIR_CURRENT} \n\n"
