#!/bin/bash

echo "##########################################################"
echo "####              Installing MS VS Code               ####"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

echo "==> Installing MS VS Code"
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo sudo apt-key add -
sudo apt-add-repository --yes --update "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
##sudo apt update
sudo apt install -y code
printf ">> MS VS Code installed OK.\n\n"
