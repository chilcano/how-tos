#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

echo "##########################################################"
echo "####              Setting Jekyll in Linux             ####"
echo "##########################################################"

printf "==> Installing Ruby \n"
sudo apt -qq update
sudo apt -yqq install ruby ruby-dev build-essential zlib1g-dev

printf "==> Configuring Ruby Gems into Linux Home \n"
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
printf "\t Ruby version: $(ruby -v)\n"
printf "\t Gem version: $(gem -v)\n"

printf "==> Installing Jekyll with Bundler \n"
gem install bundler

printf "==> Cloning the GitHub Page site and moving to project directory \n"
CURRENT_DIR=$PWD
GIT_USER="chilcano"
GIT_REPO="ghpages-holosec"
GIT_PARENT_DIR="${HOME}/gitrepos"
if [ -f "${GIT_PARENT_DIR}/${GIT_REPO}/README.md" ]; then
    printf "\t The '${GIT_PARENT_DIR}/${GIT_REPO}' GitHub repo exists and contains files. Nothing to do. \n"
else 
    printf "\t Cloning the '${GIT_REPO}' GitHub repo.\n"
    mkdir -p ${GIT_PARENT_DIR}; cd ${GIT_PARENT_DIR} 
    git clone https://github.com/${GIT_USER}/${GIT_REPO} 
fi 
cd ${GIT_PARENT_DIR}/${GIT_REPO}

printf "==> Setting Gems local repository \n"
###bundle install --path vendor/bundle
bundle config set path vendor/bundle

printf "==> Installing Jekyll and all Gems present in Gemfile in '${GIT_PARENT_DIR}/${GIT_REPO}' \n"
bundle install --quiet

printf "\n==> Checking if Jekyll was installed properly. You should see 'jekyll 4.0.0' \n"
bundle exec jekyll -v

printf "\n==> Serving a site with Jekyll \n"
cd $CURRENT_DIR

printf "\t If you are using Google Analytics uses 'JEKYLL_ENV=production': \n"
printf "\t $ JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch \n\n"

printf "\t Running with 'JEKYLL_ENV=production' and listening on '0.0.0.0':\n"
printf "\t $ JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch --host=0.0.0.0 \n\n"

printf "\t If you have posts in draft (place your posts in '<site>\_drafts\' folder without 'date' and 'permalink' in the front-matter): \n"
printf "\t $ JEKYLL_ENV=production bundle exec jekyll serve --watch --drafts \n\n"

printf "\t If you want run Jekyll without warnings: \n"
printf "\t $ RUBYOPT=-W0 JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch \n\n"

printf "\n\t** Duration of process: $((($(date +%s)-${TIME_RUN_DEVOPS}))) seconds **\n\n"
