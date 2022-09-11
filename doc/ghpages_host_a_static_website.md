# Static website with Jekyll and Hugo and hosted on GiHub Pages

## Jekyll - Guides and scripts

### 1. [Install Jekyll in Linux](src/jekyll_setting_in_linux.sh). Tested in Ubuntu 18.04, above and Raspbian/Raspberry Pi OS.  

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

### 2. [Migration of GitHub Page site from Jekyll to Hugo](migrate_jekyll_to_hugo.md)  

## Hugo - Guides and scripts

### 1. Install Hugo and GitHub tools. 

Installing Hugo extended version:
```sh
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_setting_in_linux.sh) -a=ARM64|64bit -b=tar.gz|deb -d=extended
```   
Installing GitHub Hub:


### 2. Create a Hugo site in GitHub Pages.

#### 2.1. From another existing GitHub Pages repo.

```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/hugo_create_site_from_repo.sh | bash
```

#### 2.2. From scratch and initial pages.

The next script, will:
1. Create empty GitHub repo. 
2. Bootstrap an initial Hugo Site, it will load a Hugo Theme and will create a first post.
3. Create `ghp-script` folder where all Hugo scripts, configuration and theme will be generated.
4. Create `ghp-content` Git branch where all Hugo static content will be generated.
5. Push the code and publish the site to remote GitHub repo.

Two bash util scripts will be added to `main` branch, first one to run and serve the Hugo Site in your local computer and the second one to publish content to GitHub remote repo.

Use this script only one time:
```sh
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/hugo_create_site_from_scratch.sh) -u=chilcano -d=ghpages-waskhar -t=hugo-theme-cactus
```

The above two bash scripts added should be used as many time as you need it:
* Run your local Hugo server.
* Publish new content to your Hugo Site.

### 3. Run Hugo Site locally.

These steps work for any Hugo site hosted in a GitHub repo, only change the `data-plane/ghpages-dpio` for your repository.

1. Download an existing Hugo static website.
```sh
git clone https://github.com/data-plane/ghpages-dpio $HOME/gitrepos/ghpages-dpio/
cd $HOME/gitrepos/ghpages-dpio/
git checkout main
``` 

2. Run locally the downloaded Hugo static website.
```sh
cd ghp-scripts
// replace the IP address with yours
hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/ghpages-dpio/
``` 
Above command will publish the website on `http://192.168.1.59:1313` with `/ghpages-dpio/` as base directory, this means that many links to your static resources such as `/assets/` will not be loaded.  
Then, the recommended way to serve locally the website is running `hugo` without base dir, for example:

```sh
hugo server -D --bind=0.0.0.0 --baseURL=http://192.168.1.59:1313/
```

Other option is place the [hugo_run_locally.sh](../src/hugo_run_locally.sh) in your root dir and run it.
```sh
./hugo_publish_site.sh 
```

### 4. Regenerate the Hugo content.

Generally, the Hugo content is generated executing the `hugo` command from `ghp-scripts` or from directory containing `config.toml`.   
To view or publish a website, the new content should be generated. If you change the Hugo config, also you should re-generated again, to do that, from `ghp-scripts/` you should execute `hugo` command to re-generate the static content under `ghp-content`.

```sh
cd ghp-scripts
ls 
config.toml  content  resources  static  themes

hugo 
Start building sites …

                   | EN
-------------------+------
  Pages            | 174
  Paginator pages  |   2
  Non-page files   |   0
  Static files     | 193
  Processed images |   0
  Aliases          |  74
  Sitemaps         |   1
  Cleaned          |   0

Total in 633 ms
``` 

### 5. Create new content.

All new content must be created under `ghp-scripts/content/` manually or using `hugo` command. Under `ghp-scripts/content/` we will be able to create pages and post and upload its static content such as images, css, javascript etc.

```sh
$ tree . -d -L 4 -I 'ghp-content|blog20*'
.
└── ghp-scripts
    ├── content
    │   └── post
    ├── resources
    │   └── _gen
    │       ├── assets
    │       └── images
    ├── static
    │   ├── assets
    │   │   ├── img
    │   │   └── pages
    │   ├── blog
    │   └── images
    └── themes
        └── hugo-theme-cactus
            ├── exampleSite
            ├── images
            ├── layouts
            └── static

19 directories
```

For example, let's create a new post:
```sh
cd ghp-scripts
hugo new post/my-test-post.md

/home/rogerc/repos/ghpages-holosecio/ghp-scripts/content/post/my-test-post.md created
```

### 6. Publish the new generated content.

Only commit all changes to GitHub pages repository. In this case we have to commit changes to `ghp-scripts` branch to back up changes and commit `ghp-content` to reflect changes in the website. To do that, I've created a bash script to automate this process, feel free to use it:

```sh
cd <root-hugo-repo>
ll

total 32
drwxr-xr-x 5 rogerc rogerc 4096 Jun  4 17:30 ./
drwxr-xr-x 4 rogerc rogerc 4096 Jun  4 14:49 ../
drwxr-xr-x 8 rogerc rogerc 4096 Jun  4 15:17 .git/
-rw-r--r-- 1 rogerc rogerc   27 Jun  4 14:49 .gitignore
-rw-r--r-- 1 rogerc rogerc  186 Jun  4 14:49 README.md
drwxr-xr-x 3 rogerc rogerc 4096 Jun  4 17:30 ghp-content/
drwxr-xr-x 6 rogerc rogerc 4096 Jun  4 15:25 ghp-scripts/
-rwxr-xr-x 1 rogerc rogerc 2119 Jun  4 14:49 hugo_publish_site.sh*

./hugo_publish_site.sh 
```

You can download the script and execute it in root dir of your repo once generated Hugo content in a specific GitHub Pages branch.    
```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/hugo_publish_site.sh | bash
```  

## Other topics

1. Tags - https://www.chuxinhuang.com/blog/noobs-guide-to-hugo/
2. New Laytour and Type - https://discourse.gohugo.io/t/how-does-hugo-know-which-layout-to-use/14069/2
