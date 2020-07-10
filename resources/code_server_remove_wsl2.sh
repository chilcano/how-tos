#!/bin/bash

echo   "##########################################################"
printf "##    Removing VSCode Server on WSL2 (Ubuntu 20.04)     ##\n"
echo   "##########################################################"

## remove config files
rm -rf ~/.config/code-server/

## remove binaries
rm -rf ~/.local/lib/code-server-*

## remove extensions, logs, User config
rm -rf ~/.local/share/code-server/
