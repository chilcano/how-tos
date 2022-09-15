# Host on GiHub Pages static website with Hugo

## Prerequisites 

### Installing Git and GitHub Hub

```sh
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/git_and_hub_setting_in_linux.sh)
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/git_and_hub_setting_in_linux.sh) -u=Chilcano -e=chilcano@intix.info
```

* The bash script by default will install Git and GitHub Hub tools. Both will allow create repositories and upload changes.
* The `-u=Chilcano` and `-e=chilcano@intix.info` parameters will allow configure your GitHub in your local computer.

### Installing Hugo extended version

This script will remove previous `hugo` installation and will install the extended version of `hugo`.
```sh
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_setting_in_linux.sh)
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_setting_in_linux.sh) -a=64bit -b=deb -d=extended
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_setting_in_linux.sh) -a=ARM64 -b=tar.gz -d=extended
```  

## Create a Hugo site in GitHub Pages.

We have 2 ways to build an initial Hugo site and host it on GitHub:
 
### 1. From another existing GitHub Pages repo.

The first one takes existing GitHub Page created with Hugo and publish in another GitHub repository. 
```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/hugo_create_site_from_repo.sh | bash
```

### 2. From scratch and initial pages.

The second one create a fresh Hugo site and hosts it on GitHub Page in a new repository.
The next script, will:

1. Create empty GitHub repo. 
2. Bootstrap an initial Hugo Site, it will load a Hugo Theme and will create a first post.
3. Create `ghp-script` folder where all Hugo scripts, configuration and theme will be generated.
4. Create `ghp-content` Git branch where all Hugo static content will be generated.
5. Push the code and publish the site to remote GitHub repo.

Run this script with these parameters:
```sh
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/hugo_create_site_from_scratch.sh) -u=chilcano -d=ghpages-waskhar -t=hugo-theme-cactus
```

* `-u=chilcano`: It represents the GitHub user or Organization name
* `-d=ghpages-waskhar`: It represents the GitHub repository what will host the Hugo site and all content.
* `-t=hugo-theme-cactus`: It is the Hugo Theme to be downloaded and applied to Hugo site.

This is the single task to be performed only one time. 

## Other topics

1. Tags - https://www.chuxinhuang.com/blog/noobs-guide-to-hugo/
2. New Laytour and Type - https://discourse.gohugo.io/t/how-does-hugo-know-which-layout-to-use/14069/2
