#!/bin/bash

echo   "##########################################################"
echo   "##   Installing VSCode Server on WSL2 (Ubuntu 20.04)    ##"
echo   "##########################################################"

mkdir -p ~/.local/lib ~/.local/bin
curl -fL https://github.com/cdr/code-server/releases/download/v3.4.1/code-server-3.4.1-linux-amd64.tar.gz \
  | tar -C ~/.local/lib -xz
mv ~/.local/lib/code-server-3.4.1-linux-amd64 ~/.local/lib/code-server-3.4.1
ln -s ~/.local/lib/code-server-3.4.1/bin/code-server ~/.local/bin/code-server

printf ">> Start Code-Server executing this command:\n"
printf "\t code-server --auth none \n\n"

printf ">> Installing Extension: Shan.code-settings-sync. \n"
code-server --install-extension Shan.code-settings-sync

printf "\nGet a trusted Gist ID to restore extensions and configuration through Settings-Sync extension:\n"
printf "\t https://gist.github.com/chilcano/b5f88127bd2d89289dc2cd36032ce856 \n"
printf "Installation of Code-Server completed.\n"
