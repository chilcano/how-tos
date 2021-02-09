#!/bin/bash

echo "##########################################################"
echo "#        Removing Code-Server and config files           #"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

systemctl --user disable --now code-server

printf ">> Uninstalling installed version of 'code-server'. \n"
sudo dpkg -r code-server
sudo apt clean -y && sudo apt autoremove -y
sudo apt -f install
sudo dpkg --configure -a

printf ">> Removing code-server config files. \n"
rm -rf $HOME/.config/code-server 
rm -rf $HOME/.local/share/code-server/

printf ">> VSCode Server was removed successfully. \n"
