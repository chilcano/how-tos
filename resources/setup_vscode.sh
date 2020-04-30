#!/bin/bash

echo "##########################################################"
echo "####              Setting VS Code                     ####"
echo "##########################################################"

NOW=$(date +"%y%m%d.%H%M%S")

printf "\n==> Look&Feel and config \n"

echo "> Getting 'settings.json' and copying to '$HOME/.config/Code/User/settings.json'"
wget -q https://raw.githubusercontent.com/chilcano/how-tos/master/resources/vscode/dot_config/Code/User/settings.json
if [ -f "${HOME}/.config/Code/User/settings.json" ]; then
    printf "\t Making a backup of '${HOME}/.config/Code/User/settings.json'\n"
    mv ${HOME}/.config/Code/User/settings.json ${HOME}/.config/Code/User/settings.json.bak.${NOW} 
fi 
printf "\t Copying 'settings.json' to '${HOME}/.config/Code/User/'\n"
cp settings.json $HOME/.config/Code/User/.
rm -f settings.json

printf "\n==> Extensions\n"

## https://marketplace.visualstudio.com/items?itemName=usernamehw.indent-one-space
code --install-extension usernamehw.indent-one-space

## https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
code --install-extension yzhang.markdown-all-in-one

## https://marketplace.visualstudio.com/items?itemName=mauve.terraform
code --install-extension mauve.terraform

## https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode
code --install-extension VisualStudioExptTeam.vscodeintellicode

## https://marketplace.visualstudio.com/items?itemName=redhat.java
code --install-extension redhat.java

## https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-maven
code --install-extension vscjava.vscode-maven

## https://marketplace.visualstudio.com/items?itemName=ms-python.python
code --install-extension ms-python.python

## https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker
code --install-extension ms-azuretools.vscode-docker

## https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml
code --install-extension redhat.vscode-yaml

## https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools

## https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh
code --install-extension ms-vscode-remote.remote-ssh

## https://marketplace.visualstudio.com/items?itemName=ballerina.ballerina
code --install-extension ballerina.ballerina
