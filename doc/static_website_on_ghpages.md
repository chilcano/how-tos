# Static website with Jekyll and Hugo and hosted on GiHub Pages

## Guides and scripts


1. [Install **Jekyll** in Linux](src/jekyll_setting_in_linux.sh). Tested in Ubuntu 18.04, above and Raspbian/Raspberry Pi OS.  

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
2. [Migration of GitHub Page site from Jekyll to Hugo](src/migrate_jekyll_to_hugo.md)  


3. Host a site on GitHub Pages and Hugo.  

Install Hugo and GitHub tools:    
```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/hugo_setting_in_linux.sh | bash
```   
Host an existing GitHub Pages repo using Hugo:   
```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/hugo_dpio_create.sh | bash
```  
Publish generated Hugo content in a specific GitHub Pages branch:   
```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/hugo_dpio_update.sh | bash
```  
Run a local Hugo site:  
```sh
git clone https://github.com/data-plane/ghpages-dpio $HOME/gitrepos/ghpages-dpio/
cd $HOME/gitrepos/ghpages-dpio/
git checkout main
cd ghp-scripts
// replace the IP address with yours
hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ghpages-dpio/
``` 
