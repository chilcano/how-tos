# Migrate existing Jekyll site to Hugo 


## Requisites

1. Install and configure Git CLI and Hub CLI
```sh
# Install git, hub, configure git and authentication, test hub, etc
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/git_and_hub_setting_in_linux.sh) -u=Chilcano -e=chilcano@intix.info
```
2. Hugo CLI
```sh
# Install latest Hugo binary
curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_setting_in_linux.sh | bash
```

## Steps

1. Clone/download existing Jekyll GitHub Pages site

2. Import existing downloaded site using Hugo CLI

3. Run the site locally using Hugo CLI

4. Migrate existing Jekyll theme or download new Hugo theme

5. Re-run the site locally using Hugo CLI

6. Publish the Hugo site on a GitHub Pages new repository

7. Configure the published GitHub Pages Hugo site

8. Check everything!


But if you don't want to wait, I've created a bash script, only run below commands:

```sh
// Running the script in this way, we will run the bash in the current shell context which allow us to change directory
// This script also will publish the imported site to GitHub in Hugo format
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/migrate_jekyll_to_hugo.sh) --help
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/migrate_jekyll_to_hugo.sh) --ghuser=<github_usr> --source_url=https://github.com/<usr>/<jekyll_repo> --destination=<dir> --theme=<hugo_theme>
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/migrate_jekyll_to_hugo.sh) -u=chilcano -s=https://github.com/chilcano/ghpages-holosec.git -d=site01 -t=hugo-theme-cactus

// Check the Site locally
hugo server -D --bind=0.0.0.0 --baseURL=http://<your_hugo_ip_address>:1313/
```

## References:
1. [Migrating from Jekyll to Hugo - 2020/Apr/29](https://chenhuijing.com/blog/migrating-from-jekyll-to-hugo/)
2. [Migrating from Jekyll+Github Pages to Hugo+Netlify - 2017/Jun/6](https://www.sarasoueidan.com/blog/jekyll-ghpages-to-hugo-netlify/)
3. [Hugo vs Jekyll: an epic battle of static site generator themes - 2020/April/27](https://victoria.dev/blog/hugo-vs-jekyll-an-epic-battle-of-static-site-generator-themes/)
4. [Migrate from jekyll to gohugo - 2019/Nov/12](https://haefelfinger.ch/posts/2019/2019-11-12-Migrate-from-jekyll-to-hugo/)
