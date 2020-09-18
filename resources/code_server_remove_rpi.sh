#!/bin/bash

echo "#############################################################"
echo "#   Removing Code-Server and config files on Raspberry Pi   #"
echo "#############################################################"

export DEBIAN_FRONTEND=noninteractive

systemctl --user stop code-server
systemctl --user disable --now code-server
sudo rm -rf /usr/lib/systemd/user/code-server.service
sudo rm -rf /etc/systemd/system/code-server.service
printf ">> Systemd code-server stopped, disabled and removed. \n\n"

npm uninstall -g code-server
printf ">> Code-Server uninstalled. \n\n"

sudo apt clean -y && sudo apt autoremove -y

npm uninstall -g yarn
nvm unalias default
nvm deactivate
nvm uninstall --lts=erbium 
printf ">> NodeJS, NPM, Yarn were uninstalled. \n\n"

sudo unlink /usr/bin/code-server
sudo unlink /usr/bin/node
printf ">> Removing Code-Server and NodeJS soft links. \n"

rm -rf ~/.config/code-server/
rm -rf ~/.local/share/code-server/
printf ">> Removing code-server config and shared files. \n"

printf ">> Code-Server was removed successfully. \n"
