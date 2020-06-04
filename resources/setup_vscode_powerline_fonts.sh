#!/bin/bash

## Ref: https://dev.to/mattstratton/making-powerline-work-in-visual-studio-code-terminal-1m7

NOW2=$(date +"%y%m%d.%H%M%S")

printf "==> Installing 'Menlo for Powerline' fonts for VS Code Terminal \n"

if [ -d "${HOME}/.fonts/Menlo-for-Powerline" ]; then
    printf " >> Seems there are fonts in '${HOME}/.fonts/Menlo-for-Powerline/', then backing up the directory.\n"
    tar -zcvf "${HOME}/.fonts/Menlo-for-Powerline.tar.gz.${NOW2}" "${HOME}/.fonts/Menlo-for-Powerline"
    rm -rf "${HOME}/.fonts/.uuid"
    rm -rf "${HOME}/.fonts/Menlo-for-Powerline/"
else
    mkdir -p ${HOME}/.fonts/
fi 
git clone --depth=1 https://github.com/abertsch/Menlo-for-Powerline
rm -rf ./Menlo-for-Powerline/.git
mv "Menlo-for-Powerline" "${HOME}/.fonts/"
printf " >> Fonts updated/installed!!\n"

https://github.com/diogocavilha/fancy-git/blob/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf
