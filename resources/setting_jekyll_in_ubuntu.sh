#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

echo "##########################################################"
echo "####              Setting Jekyll                      ####"
echo "##########################################################"

echo "==> Installing Ruby"
sudo apt-get update
sudo apt -y install ruby ruby-dev build-essential zlib1g-dev

echo "==> Configuring Ruby Gems into Linux Home"
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
printf "\t Ruby version: $(ruby -v)\n"
printf "\t Gem version: $(gem -v)\n"

echo "==> Installing Jekyll with Bundler"
gem install bundler

echo "==> Cloning the GitHub Page site and moving to project directory"
GIT_USER="chilcano"
GIT_REPO="ghpages-holosec"
GIT_PARENT_DIR="${HOME}/gitrepos"
mkdir -p ${GIT_PARENT_DIR}; cd ${GIT_PARENT_DIR}
git clone https://github.com/${GIT_USER}/${GIT_REPO} 

echo "==> Setting Gems local repository"
###bundle install --path vendor/bundle
bundle config set path vendor/bundle

echo "==> Installing Jekyll and all Gems present in Gemfile"
bundle install

echo "==> Checking if Jekyll was installed properly. You should see 'jekyll 4.0.0'"
bundle exec jekyll -v

echo "==> Serving a site with Jekyll"

printf "\t If you are using Google Analytics:"
printf "\t $ JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch \n"

printf "\t If you have posts in draft (place your posts in <site>\_drafts\ folder without 'date' and 'permalink' in the front-matter):"
printf "\t $ JEKYLL_ENV=production bundle exec jekyll serve --watch --drafts \n"

printf "\n\t** Duration of process: $((($(date +%s)-${TIME_RUN_DEVOPS}))) seconds **\n\n"
