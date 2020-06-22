## Fancy Prompt in Ubuntu with Fancy GIT

![](fancy_prompt_ubuntu_with_fancy_git.png)

1) Install fonts
```sh
$ sudo apt install -y fonts-powerline fonts-hack-ttf
```

2) Install
```sh
$ curl -sS https://raw.githubusercontent.com/diogocavilha/fancy-git/master/install.sh | sh
```

3) Uninstall
```sh
$ curl -sS https://raw.githubusercontent.com/diogocavilha/fancy-git/master/uninstall.sh | sh
```

4) Load colored style and pattern

* Reload the fancygit script.  
  ```sh
  $ . ~/.bashrc
  ```
* Apply a style.  
  ```sh
  $ fancygit double-line
  $ fancygit dark-col-double-line
```
* Fonts.  
  In above both styles, the Terminal used must load the `SourceCodePro+Powerline+Awesome+Regular.ttf` fonts, these fonts are installed when `fancy-git` is installed. 
  If the fonts were not installed, the Terminal will not able to render the fonts/icons properly and show wrong chars. 
  
  ```sh
  $ ls -la ~/.fancy-git/fonts/SourceCodePro+Powerline+Awesome+Regular.ttf
  -rw-r--r-- 1 pi pi 233984 Jun 22 14:40 /home/pi/.fancy-git/fonts/SourceCodePro+Powerline+Awesome+Regular.ttf
  
  // reinstalling only the fonts
  $ fancygit configure-fonts
  
  // downloading the fonts
  $ wget -q  https://raw.githubusercontent.com/diogocavilha/fancy-git/master/fonts/SourceCodePro+Powerline+Awesome+Regular.ttf
  ```
* Changing fonts.  
  In this case, you don't want or cannot replace the fonts/icons in your system for those your Terminal need, then you could overide for some supported, in this way:
  ```sh
  $ nano $HOME/.fancy-git/config-override.sh
  
  is_git_repo="§"
  has_git_stash=" ∞"
  has_untracked_files=" ≠"
  is_only_local_branch=" ·"
  has_changed_files=" !"
  has_added_files=" +"
  has_unpushed_commits=" ?"
  working_on_venv=" ≤"
  ```
  ![](fancy_prompt_ubuntu_with_fancy_git_updated.png)
  
  If it still doesn't work, then load a text-based fancy prompt:
  ```sh
  $ fancygit human
  $ fancygit human-dark
  $ fancygit simple-double-line
  ``` 
  
5) Apply colored style and pattern
```sh 
$ source $HOME/.bashrc
```

### Reference:
- [https://github.com/diogocavilha/fancy-git](https://github.com/diogocavilha/fancy-git)
