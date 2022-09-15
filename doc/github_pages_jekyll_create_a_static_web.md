# Host on GiHub Pages static website with Jekyll 

## 1. [Install Jekyll in Linux](src/jekyll_setting_in_linux.sh). 

Tested in Ubuntu 18.04, above and Raspbian/Raspberry Pi OS.  
It will install also Ruby, Ruby-dev, build-essential, zlib1g-dev, Gem, Bundler, etc.  
```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/jekyll_setting_in_linux.sh | bash
```   

Running Jekyll:   
```sh
JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch
JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch --host=0.0.0.0
JEKYLL_ENV=production bundle exec jekyll serve --watch --drafts
RUBYOPT=-W0 JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch 
```

## 2. [Migration of GitHub Page site from Jekyll to Hugo](migrate_jekyll_to_hugo.md)  
