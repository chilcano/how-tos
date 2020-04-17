#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

echo "##########################################################"
echo "####              Setting Jekyll                      ####"
echo "##########################################################"

echo "==> Installing Ruby"
apt-get update
apt-get install -y ruby-full build-essential zlib1g-dev

echo "==> Configuring Ruby Gems into Linux Home"
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo "==> Installing Jekyll with Bundler"
gem install bundler

echo "==> Downloading existing GitHub Page site"
GIT_USER="chilcano"
GIT_REPO="ghpages-holosec"
GIT_HOME_DIR="~/gitrepos"
git clone https://github.com/${GIT_USER}/${GIT_REPO} ${GIT_HOME_DIR}/${GIT_REPO}/
cd ${GIT_REPO}

echo "==> Setting gems local repository"
#bundle install --path vendor/bundle
bundle config set path 'vendor/bundle'

echo "==> Installing Jekyll and all Gems present in Gemfile"
bundle

echo "==> Checking if Jekyll was installed properly"
bundle exec jekyll -v

echo "==> Running Jekyll"

echo "  If you are using Google Analytics:"
echo "  $ JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch"

echo "  If you have posts in draft (place your posts in <site>\_drafts\ folder without 'date' and 'permalink' in the front-matter):"
echo "  $ JEKYLL_ENV=production bundle exec jekyll serve --watch --drafts"

printf "\n\t** Duration of process: $((($(date +%s)-${TIME_RUN_DEVOPS}))) seconds.\n\n"
