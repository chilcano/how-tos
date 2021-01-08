# Migrate existing Jekyll site to Hugo 

## References:
1. [Migrating from Jekyll to Hugo - 2020/Apr/29](https://chenhuijing.com/blog/migrating-from-jekyll-to-hugo/)
2. [Migrating from Jekyll+Github Pages to Hugo+Netlify - 2017/Jun/6](https://www.sarasoueidan.com/blog/jekyll-ghpages-to-hugo-netlify/)
3. [Hugo vs Jekyll: an epic battle of static site generator themes - 2020/April/27](https://victoria.dev/blog/hugo-vs-jekyll-an-epic-battle-of-static-site-generator-themes/)
4. [Migrate from jekyll to gohugo - 2019/Nov/12](https://haefelfinger.ch/posts/2019/2019-11-12-Migrate-from-jekyll-to-hugo/)

## Requisites

1. Git CLI
2. GitHub Hub CLI (a GIT CLI wrapper)
3. Hugo CLI

## Steps

1. Clone/download existing Jekyll GitHub Pages site

2. Import existing downloaded site using Hugo CLI

3. Run the site locally using Hugo CLI

4. Migrate existing Jekyll theme or download new Hugo theme

5. Re-run the site locally using Hugo CLI

6. Publish the Hugo site on a GitHub Pages new repository

7. Configure the published GitHub Pages Hugo site

8. Check everything!


But if you don't want to wait, I've created a bash script, just run below commands:

```sh
// cloning jekyll repo and import it as Hugo repo
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/migrate_jekyll_to_hugo.sh | bash
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/migrate_jekyll_to_hugo.sh | bash -s -- -t=https://github.com/vividvilla/ezhil
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/migrate_jekyll_to_hugo.sh | bash -s -- --theme=https://github.com/ribice/kiss

// check it locally

// publish it to GitHub
 
``` 
