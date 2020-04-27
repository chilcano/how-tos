#!/bin/bash

echo "##########################################################"
echo "####              Setting VS Code                     ####"
echo "##########################################################"


echo "==> Look&Feel"
echo "> Getting 'settings.json'"
wget -q https://raw.githubusercontent.com/chilcano/how-tos/master/resources/vscode/dot_config/Code/User/settings.json
cp settings.json $HOME/.config/Code/User/.

echo "==> Extensions"
echo "> Installing https://marketplace.visualstudio.com/items?itemName=usernamehw.indent-one-space"
code --install-extension usernamehw.indent-one-space

echo "> Installing https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one"
code --install-extension yzhang.markdown-all-in-one

echo "> Installing https://marketplace.visualstudio.com/items?itemName=mauve.terraform"
code --install-extension mauve.terraform

