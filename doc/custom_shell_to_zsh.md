# Switching to ZSH and installing Oh My Zsh

## References

- https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
- https://github.com/ohmyzsh/ohmyzsh

## 1. Install ZSH

1. Install `zsh` in Ubuntu

```sh
$ sudo apt -y install zsh


## Verify installation
$ zsh --version

zsh 5.9 (x86_64-ubuntu-linux-gnu

## Make it your default shell
$ chsh -s $(which zsh)
```

2. Log out and log back in again to use your new default shell.

3. Test that it worked with `echo $SHELL`. Expected result: `/bin/zsh` or similar.

## 2. Install and configure Oh My Zsh

1. Install
```sh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

```

2. Configure it. Only select default options.

3. Set you favorite theme

```sh
$ nano ~/.zshrc
```

Below are simples 2 lines themes which don't require install powerline, nerd or any special fonts or glyphs:

Comment the existing one and uncomment you want it:
```
##ZSH_THEME="robbyrussell"

ZSH_THEME="bira"
ZSH_THEME="dstufft"
ZSH_THEME="gnzh"
ZSH_THEME="intheloop"
ZSH_THEME="jispwoso"
ZSH_THEME="juanghurtado"
ZSH_THEME="kphoen"
ZSH_THEME="linuxonly"
ZSH_THEME="mortalscumbag"
ZSH_THEME="pmcgee"
ZSH_THEME="re5et"
ZSH_THEME="refined"
ZSH_THEME="rgm"
ZSH_THEME="steef"
```

Reload the zsh config:
```sh
$ source ~/.zshrc
```

