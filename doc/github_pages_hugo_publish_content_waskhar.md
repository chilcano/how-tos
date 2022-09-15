# Publishing content to Waskhar Web hosted on GitHub Pages

## Requirements

1. A Hugo site already created and hosted in GitHub using `hugo_create_site_from_scratch.sh` script. Below an example:

```
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_create_site_from_scratch.sh) -u=chilcano -d=ghpages-waskhar1 -t=hugo-theme-cactus
```

* `-u=chilcano`: It represents the GitHub user or Organization
* `-d=ghpages-waskhar1`: It represents the GitHub repository what will host the Hugo site and all content.
* `-t=hugo-theme-cactus`: It is the Hugo Theme to be downloaded and applied to Hugo site.

This is the single task to be performed only one time. The next points 2 and 3 and all Tasks must be accomplished by the content publishers as many times as the contents are published.

2. GitHub account with 2FA activated.

3. A computer with:

- Internet access.
- A Text Editor: Notepad++ (Windows), Notepadqq (Linux), or VSCode (Windows/Linux).
- A Terminal (Windows or Linux Terminal) where we can execute Git commands and Bash scripts. If you are going to use VSCode, then you don't need a Terminal.
- Git and GitHub Hub if you are going to create Web sites from scratch.
- Hugo. Install Hugo in Linux using this script:
```
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_setting_in_linux.sh) -a=64bit -b=deb -d=extended
```

## Tasks


### 1. Download existing Waskhar Web

```
git clone https://github.com/<github-user-org>/<hugo-repo-name>.git
```

### 2. Add new content in your local copy

```
cd <hugo-repo-name>/ghp-scripts/

# Run hugo to create a new post
hugo new posts/post-01.md

# Run hugo to create a new page
hugo new about.md
```

### 3. Check added content in your computer by running Hugo server

```
cd <hugo-repo-name>/
source hugo_run_locally.sh
```

### 4. Publish your added content to public Waskhar Web

```
source hugo_publish_site.sh -m="New content added"
```


