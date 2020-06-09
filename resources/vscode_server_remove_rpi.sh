#!/bin/bash

echo "#############################################################"
echo "#  Removing VSCode Server and config files on Raspberry Pi  #"
echo "#############################################################"

export DEBIAN_FRONTEND=noninteractive

systemctl --user stop code-server
systemctl --user disable --now code-server
sudo rm -rf /usr/lib/systemd/user/code-server.service

printf ">> Uninstalling installed version of 'code-server'. \n"
sudo dpkg -r code-server
sudo apt clean -y && sudo apt autoremove -y
sudo apt -f install
sudo dpkg --configure -a
sudo npm uninstall -g code-server protobufjs @google-cloud/logging

printf ">> Removing code-server config files"
rm -rf ~/.config/code-server/

printf ">> VSCode Server was removed successfully. \n"
