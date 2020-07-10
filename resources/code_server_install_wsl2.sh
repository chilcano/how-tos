#!/bin/bash

echo   "##########################################################"
printf "##   Installing VSCode Server on WSL2 (Ubuntu 20.04)    ##\n"
echo   "##########################################################"

mkdir -p ~/.local/lib ~/.local/bin
curl -fL https://github.com/cdr/code-server/releases/download/v3.4.1/code-server-3.4.1-linux-amd64.tar.gz \
  | tar -C ~/.local/lib -xz
mv ~/.local/lib/code-server-3.4.1-linux-amd64 ~/.local/lib/code-server-3.4.1
ln -s ~/.local/lib/code-server-3.4.1/bin/code-server ~/.local/bin/code-server

## not needed because in WSL2 ~/.profile includes ~/.locals/bin
#nano ~/.bashrc
#PATH=~/.local/bin:$PATH

printf ">> Start Code-Server running this command:\n"
printf "\t code-server --auth none \n"

printf ">> Installing Extension: Shan.code-settings-sync. \n"
code-server --install-extension Shan.code-settings-sync

## install settings-sync extension
