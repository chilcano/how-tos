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
```sh
$ fancygit double-line
$ fancygit dark-col-double-line
```
In both styles, the Terminal used must load the `SourceCodePro+Powerline+Awesome+Regular.ttf` fonts, if so, the Terminal will not able to render the fonts/icons properly.
In this case, you could replace the fonts/icons for fonts supported for your Terminal.
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
