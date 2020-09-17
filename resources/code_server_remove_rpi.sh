#!/bin/bash

echo "#############################################################"
echo "#   Removing Code-Server and config files on Raspberry Pi   #"
echo "#############################################################"

export DEBIAN_FRONTEND=noninteractive

systemctl --user stop code-server
systemctl --user disable --now code-server
sudo rm -rf /usr/lib/systemd/user/code-server.service
sudo rm -rf /etc/systemd/system/code-server.service 

printf ">> Uninstalling 'code-server' ($(code-server -v)). \n"
sudo dpkg -r code-server
sudo apt clean -y && sudo apt autoremove -y
sudo apt -f install
sudo dpkg --configure -a
sudo npm uninstall -g code-server protobufjs @google-cloud/logging
printf ">> Code-Server uninstalled. \n\n"

printf ">> Uninstalling NodeJS. \n"
sudo apt remove nodejs -y
printf ">> NodeJS uninstalled. \n\n"

printf ">> Removing code-server config files. \n"
rm -rf ~/.config/code-server/

printf ">> Code-Server was removed successfully. \n"
