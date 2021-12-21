## Custom Prompt in Ubuntu with Fancy GIT

![](imgs/custom_prompt_ubuntu_with_fancy_git_updated3.png)

### 1) Install fonts
```sh
$ sudo apt install -y fonts-powerline fonts-hack-ttf
```

### 2) Install
```sh
$ curl -sS https://raw.githubusercontent.com/diogocavilha/fancy-git/master/install.sh | sh
```

### 3) Uninstall
```sh
$ curl -sS https://raw.githubusercontent.com/diogocavilha/fancy-git/master/uninstall.sh | sh
```

### 4) Load colored style and pattern

#### Reload the fancygit script.  
```sh
$ . ~/.bashrc
```  

#### Apply a style.  
```sh
fancygit --enable-double-line
fancygit --color-scheme-robin
```  
  
  
### 5) Apply colored style and pattern
```sh 
source $HOME/.bashrc

. ~/.bashrc
```

### Reference:
- [https://github.com/diogocavilha/fancy-git](https://github.com/diogocavilha/fancy-git)

### Reported issues

- [Fluent Terminal on Win 10 doesn't render glyphs](https://github.com/diogocavilha/fancy-git/issues/70)