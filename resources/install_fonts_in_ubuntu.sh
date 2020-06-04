#!/bin/bash

NOW2=$(date +"%y%m%d.%H%M%S")

## Ref: https://dev.to/mattstratton/making-powerline-work-in-visual-studio-code-terminal-1m7
printf "==> Installing 'Menlo for Powerline' fonts. \n"
if [ -d "${HOME}/.fonts/Menlo-for-Powerline" ]; then
  printf ">> There are fonts in '${HOME}/.fonts/Menlo-for-Powerline/', then backing up it.\n"
  tar -zcvf "${HOME}/.fonts/Menlo-for-Powerline.tar.gz.${NOW2}" "${HOME}/.fonts/Menlo-for-Powerline"
  rm -rf "${HOME}/.fonts/.uuid"
  rm -rf "${HOME}/.fonts/Menlo-for-Powerline/"
else
    mkdir -p ${HOME}/.fonts/
fi
git clone --depth=1 https://github.com/abertsch/Menlo-for-Powerline
rm -rf ./Menlo-for-Powerline/.git
mv "Menlo-for-Powerline" "${HOME}/.fonts/"
printf ">> The 'Menlo for Powerline' fonts updated/installed. \n\n"

## Ref: https://github.com/diogocavilha/fancy-git
printf "==> Installing 'SourceCode+Powerline+Awesome+Regular' fonts. \n"
if [ -f "${HOME}/.fonts/SourceCodePro+Powerline+Awesome+Regular.ttf" ]; then
  printf ">> There are fonts in '${HOME}/.fonts/', then backing up it.\n"
  tar -zcvf "${HOME}/.fonts/SourceCodePro+Powerline+Awesome+Regular.ttf.${NOW2}" "${HOME}/.fonts/SourceCodePro+Powerline+Awesome+Regular.ttf"
  rm -rf "${HOME}/.fonts/.uuid"
  rm -rf "${HOME}/.fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf"
else
  mkdir -p ${HOME}/.fonts/
fi
wget -q https://github.com/diogocavilha/fancy-git/blob/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf
mv SourceCodePro+Powerline+Awesome+Regular.ttf "${HOME}/.fonts/"
printf ">> The 'SourceCode+Powerline+Awesome+Regular' fonts updated/installed. \n\n"
