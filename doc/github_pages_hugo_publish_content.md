# Publish on GiHub Pages new content with Hugo

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

## Publish content to existing Hugo site in GitHub Pages.

### 1. Clone existing Hugo site.

```
git clone https://github.com/<github-user-org>/<hugo-repo-name>.git
```

### 2. Run Hugo Site locally.

If you used above bash script (step 2.2.), then you will have this new bash script [hugo_run_locally.sh](../src/hugo_run_locally.sh) which it will allow run your site in your computer. 

```sh
cd <hugo-repo-name>/
source hugo_publish_site.sh 
```

This script will launch the hugo server where you will be able to review your changes and the new content created before upload it to GitHub.

### 3. Create new content.

All new content must be created under `ghp-scripts/content/` manually or using `hugo` command. Under `ghp-scripts/content/` we will be able to create pages and posts and upload its static content such as images, css, javascript etc.

For example, let's create a new post:
```sh
cd <hugo-repo-name>/ghp-scripts/

hugo new posts/my-test-post.md
Content "/home/chilcano/repos/ghp-web/ghp-scripts/content/posts/my-test-post.md" created

hugo new about.md
Content "/home/chilcano/repos/ghp-web/ghp-scripts/content/about.md" created
```
In this case, `<hugo-repo-name>` is `ghp-web`.

Note that Hugo will create the post and the page in `draft` status, which means they are visible if run hugo server locally, but not if you publish the content in GitHub. If you have completed both contents, then you have to remove, set to `false` or comment that line `draft: true`. 

```
---
title: "My Test Post"
date: 2022-09-15T11:11:11+02:00
#draft: true
---

text text text ....
....
```

### 4. Publish the new generated content.

If you used above bash script (step 2.2.), then you will have this new bash script [hugo_publish_site.sh](../src/hugo_publish_site.sh) which it will allow push all changes in `ghp-scripts` folder and `ghp-content` branch to your GitHub repository. 

Execute the bash script in your root dir of your repo.    
```sh
source hugo_publish_site.sh -m="New content added"
```  

## Other topics

1. Tags - https://www.chuxinhuang.com/blog/noobs-guide-to-hugo/
2. New Laytour and Type - https://discourse.gohugo.io/t/how-does-hugo-know-which-layout-to-use/14069/2
