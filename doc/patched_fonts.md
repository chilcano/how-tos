# Install and configure patched Fonts

## Guides and scripts

1. [Install custom Fonts in Ubuntu](src/install_fonts_in_ubuntu.sh)  

This script will install 3 patched fonts including glyphs to be used in custom Terminal Prompt:  
- [Menlo-for-Powerline](https://github.com/abertsch/Menlo-for-Powerline)
- [SourceCodePro Powerline Awesome Regular](https://github.com/diogocavilha/fancy-git/blob/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf)
- [Droid Sans Mono Nerd Font Complete](https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf)

```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/install_fonts_in_ubuntu.sh | bash
```  

2. Patching Fonts for Code-Server in Raspberry Pi   

This process will patch Code-Server running in Raspberry Pi (installed in `/usr/lib/node_modules/code-server`) to use custom fonts.  
Further info: [https://github.com/cdr/code-server/issues/1374](https://github.com/cdr/code-server/issues/1374)  

```sh
git clone https://github.com/tuanpham-dev/code-server-font-patch
sudo ./code-server-font-patch/patch.sh /usr/lib/node_modules/code-server
systemctl --user restart code-server
```
