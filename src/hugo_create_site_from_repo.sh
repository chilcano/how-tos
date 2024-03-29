#!/bin/bash

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_create_site_from_repo.sh)

printf "\n"
echo "###############################################################"
echo "#   Create a website with Hugo from existing GitHub repo      #"
echo "###############################################################"

# Ref: 
# https://gohugo.io/hosting-and-deployment/hosting-on-github/

CURRENT_DIR=$PWD
GIT_PARENT_DIR="${HOME}/gitrepos"

GIT_REPO_URL_SOURCE="https://github.com/migueluza/data-plane"
GIT_ORG_TARGET="data-plane"
GIT_REPO_TARGET="ghpages-dpio"

HUGO_SCRIPTS_DIR="ghp-scripts"
HUGO_CONTENT_DIR="ghp-content"
HUGO_CONTENT_BRANCH="${HUGO_CONTENT_DIR}"

# This command avoids error 'git@github.com: Permission denied ...' when creating repo with hub
printf "==> Setting HTTPS instead of SSH for GitHub clone URLs. \n"
git config --global hub.protocol https

printf "==> Removing previous local dir. \n"
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/

printf "==> Removing remote GitHub repo with 'hub'. \n"
echo "yes" | hub delete ${GIT_ORG_TARGET}/${GIT_REPO_TARGET}

printf "==> Creating a fresh dir. \n"
mkdir -p ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/${HUGO_SCRIPTS_DIR} 

printf "==> Cloning source repo into fresh dir. \n"
git clone ${GIT_REPO_URL_SOURCE} ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/${HUGO_SCRIPTS_DIR}

printf "==> Removing older '.git/' dir, Hugo 'docs/' dir and .gitignore file. \n"
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/${HUGO_SCRIPTS_DIR}/.git
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/${HUGO_SCRIPTS_DIR}/docs
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/${HUGO_SCRIPTS_DIR}/.gitignore
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/${HUGO_CONTENT_BRANCH}

printf "==> Changing working dir. \n"
cd ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}

printf "==> Initializing local repo. \n"
git init

printf "==> Creating an empty repo on GitHub using current dir as repo's name. \n"
hub create -d "GitHub Pages for DPio" ${GIT_ORG_TARGET}/${GIT_REPO_TARGET}

echo "###############################################################"
echo "#       Configuring GitHub Pages repo (main branch)           #"
echo "###############################################################"

printf ">> Adding '.gitignore' file. \n"
cat << EOF > .gitignore
## Hugo
ghp-content/
*.bak
EOF

printf "==> Adding 'README.md' file. \n"
cat << EOF > README.md
[https://${GIT_ORG_TARGET}.github.io/${GIT_REPO_TARGET}](https://${GIT_ORG_TARGET}.github.io/${GIT_REPO_TARGET}) 

This '${GIT_ORG_TARGET}/${GIT_REPO_TARGET}' main branch hosts the Hugo scripts.
EOF

printf "==> Tweaking 'config.toml'. \n"
sed -i.bak 's/^baseURL = .*$/baseURL = "https\:\/\/data-plane.github.io\/ghpages-dpio\/"/' ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/${HUGO_SCRIPTS_DIR}/config.toml
sed -i.bak 's/^publishDir = "docs"$/publishDir = "..\/ghp-content\/docs"/' ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/${HUGO_SCRIPTS_DIR}/config.toml

printf "==> Adding resources to local repo. \n"
git add .

printf "==> Commit Hugo scripts to local repo. \n"
git commit -m "Hugo scripts for DPio site." --quiet

printf "==> Creating the 'main' branch. \n"
git branch -M main

printf "==> Pushing to remote repo in 'main' branch. \n"
git push -u origin main

printf "\n"
echo "###############################################################"
echo "#       Configuring GitHub Pages repo ($HUGO_CONTENT_BRANCH branch)    #"
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
echo "#            First updating of '$HUGO_CONTENT_BRANCH' branch           #"
echo "###############################################################"

printf "==> Delete Hugo content dir. \n"
rm -rf ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/${HUGO_CONTENT_BRANCH}

printf "==> Worktree allows you to have multiple branches of the same local repo to be checked out in different dirs. \n"
printf "==> Creating . \n"
git worktree add -B ${HUGO_CONTENT_BRANCH} ${HUGO_CONTENT_DIR} origin/${HUGO_CONTENT_BRANCH} 

printf "==> Generating Hugo content in <root>/${HUGO_CONTENT_DIR}/docs dir. \n"
cd ${HUGO_SCRIPTS_DIR}; hugo

#printf ">> Setting a custom Domain adding 'CNAME' file under 'docs/' dir. \n"
#cat << EOF > CNAME
#data-plane.io
#EOF

## configure a CNAME record with your DNS provider (gandi.net)
## https://holisticsecurity.io/2019/10/14/migrating-wordpress-com-blog-to-github-pages-with-jekyll-part1

printf "==> Adding 'README.md' file to 'HUGO_CONTENT_BRANCH'. \n"
cat << EOF > README.md
[https://${GIT_ORG_TARGET}.github.io/${GIT_REPO_TARGET}](https://${GIT_ORG_TARGET}.github.io/${GIT_REPO_TARGET}) 

This '${GIT_ORG_TARGET}/${GIT_REPO_TARGET}' __${HUGO_CONTENT_BRANCH}__ branch hosts the Hugo content.
EOF
mv -f README.md ${GIT_PARENT_DIR}/${GIT_REPO_TARGET}/${HUGO_CONTENT_DIR}/.

printf "==> Adding Hugo content only to local branch. \n"
cd ../${HUGO_CONTENT_DIR}; git add .

printf "==> Commit Hugo content to local branch. \n"
git commit -m "Publishing Hugo content to ${HUGO_CONTENT_BRANCH}" --quiet; cd ../

# If the changes in your local '${HUGO_CONTENT_BRANCH}' branch look alright, push them to the remote repo.
printf "==> Pushing to remote repo in remote '${HUGO_CONTENT_BRANCH}' branch. \n"
git push origin ${HUGO_CONTENT_BRANCH}

# hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ghpages-dpio/

printf "==> Switching to 'main' branch. \n"
git checkout main --quiet

printf "==> Returning to current dir. \n"
cd ${CURRENT_DIR}
