#!/bin/bash

echo "###############################################################"
echo "#   Creating a website with Hugo from existing GitHub repo    #"
echo "###############################################################"

# https://gohugo.io/hosting-and-deployment/hosting-on-github/
# https://migueluza.github.io/data-plane/
# https://github.com/migueluza/data-plane

GIT_SOURCE_REPO_URL="https://github.com/migueluza/data-plane"
CURRENT_DIR=$PWD
GIT_ORG="data-plane"
GIT_REPO="ghpages-dpio"
GIT_HUGO_SCRIPTS_DIR="ghp-scripts"
GIT_PARENT_DIR="${HOME}/gitrepos"
GIT_HUGO_CONTENT_DIR="ghp-content"

# this command avoids error 'git@github.com: Permission denied ...' when creating repo with hub
printf "==> Setting HTTPS instead of SSH for GitHub clone URLs. \n"
git config --global hub.protocol https

printf "==> Removing previous local dir. \n"
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO}/

printf "==> Removing remote GitHub repo with 'hub'. \n"
echo "yes" | hub delete ${GIT_ORG}/${GIT_REPO}

printf "==> Creating a fresh dir. \n"
mkdir -p ${GIT_PARENT_DIR}/${GIT_REPO}/${GIT_HUGO_SCRIPTS_DIR} 

printf "==> Cloning source repo into fresh dir. \n"
git clone ${GIT_SOURCE_REPO_URL} ${GIT_PARENT_DIR}/${GIT_REPO}/${GIT_HUGO_SCRIPTS_DIR}

printf "==> Removing older '.git/' dir, Hugo 'docs/' dir and .gitignore file. \n"
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO}/${GIT_HUGO_SCRIPTS_DIR}/.git
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO}/${GIT_HUGO_SCRIPTS_DIR}/docs
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO}/${GIT_HUGO_SCRIPTS_DIR}/.gitignore

printf "==> Changing working dir. \n"
cd ${GIT_PARENT_DIR}/${GIT_REPO}

printf "==> Initializing local repo. \n"
git init

printf "==> Creating an empty repo on GitHub using current dir as repo's name. \n"
hub create -d "GitHub Pages for DPio"  ${GIT_ORG}/${GIT_REPO}

echo "###############################################################"
echo "#       Configuring GitHub Pages repo (main branch)           #"
echo "###############################################################"

printf ">> Setting a custom Domain adding 'CNAME' file. \n"
cat <<EOF > CNAME
data-plane.io
EOF

## configure a CNAME record with your DNS provider (gandi.net)
## https://holisticsecurity.io/2019/10/14/migrating-wordpress-com-blog-to-github-pages-with-jekyll-part1

printf ">> Adding '.gitignore' file. \n"
cat <<EOF > .gitignore
_posts/*.html
_site
.sass-cache
.jekyll-cache
.jekyll-metadata
vendor
*.csv
.vscode
.bundle
Gemfile.lock
## Hugo
docs/
*.bak
EOF
#mv -f .gitignore ${GIT_PARENT_DIR}/${GIT_REPO}/.gitignore

printf ">> Adding 'README.md' file. \n"
cat <<EOF > README.md
data-plane.io website
EOF
#mv -f README.md ${GIT_PARENT_DIR}/${GIT_REPO}/README.md

printf "==> Tweaking 'config.toml'. \n"
sed -i.bak 's/^baseURL = .*$/baseURL = "https\:\/\/data-plane.github.io\/ghpages-dpio\/"/' ${GIT_PARENT_DIR}/${GIT_REPO}/${GIT_HUGO_SCRIPTS_DIR}/config.toml
sed -i.bak 's/^publishDir = "docs"$/publishDir = "..\/docs"/' ${GIT_PARENT_DIR}/${GIT_REPO}/${GIT_HUGO_SCRIPTS_DIR}/config.toml

printf "==> Adding resources to local repo. \n"
git add .

printf "==> Commit Hugo scripts to local repo. \n"
git commit -m "Hugo scripts for DPio site." --quiet

printf "==> Creating the 'main' branch. \n"
git branch -M main

printf "==> Pushing to remote repo in 'main' branch. \n"
git push -u origin main

echo "###############################################################"
echo "#       Configuring GitHub Pages repo ($GIT_HUGO_CONTENT_DIR branch)    #"
echo "###############################################################"

printf "==> Create the branch on local machine and switch in this branch. \n"
git checkout -b ${GIT_HUGO_CONTENT_DIR}

printf "==> Generating Hugo content in <root>/docs dir. \n"
cd ${GIT_HUGO_SCRIPTS_DIR}; hugo; cd ../

printf "==> Updating .gitignore file. \n"
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO}/.gitignore
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO}/${GIT_HUGO_SCRIPTS_DIR}
cat <<EOF > .gitignore
_posts/*.html
_site
.sass-cache
.jekyll-cache
.jekyll-metadata
vendor
*.csv
.vscode
.bundle
Gemfile.lock
## Hugo
${GIT_HUGO_SCRIPTS_DIR}/
*.bak
EOF

printf "==> Adding Hugo content only to local repo. \n"
git add .

printf "==> Commit Hugo content to local repo. \n"
git commit -m "Hugo content for DPio site." --quiet

printf "==> Pushing to remote repo in '${GIT_HUGO_CONTENT_DIR}' branch. \n"
git push -u origin ${GIT_HUGO_CONTENT_DIR}

# hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ghpages-dpio/

printf "==> Switching to 'main' branch. \n"
git checkout main

printf "==> Returning to current dir. \n"
cd ${CURRENT_DIR}
