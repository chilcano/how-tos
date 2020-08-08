#!/bin/bash

NOW2=$(date +"%y%m%d.%H%M%S")
FONTS_DIR="~/.local/share/fonts"

if [ -d "${FONTS_DIR}/chilcano" ]; then
  printf "==> There are fonts in '${FONTS_DIR}/chilcano/', then backing up it.\n\n"
  tar -zcvf "${FONTS_DIR}/chilcano-fonts.${NOW2}" "${FONTS_DIR}/chilcano"
  rm -rf "${FONTS_DIR}/.uuid"
  rm -rf "${FONTS_DIR}/chilcano/"
else
    mkdir -p ${FONTS_DIR}/chilcano/
fi

## Ref: https://dev.to/mattstratton/making-powerline-work-in-visual-studio-code-terminal-1m7
printf "==> Installing 'Menlo for Powerline' fonts. \n"
git clone --depth=1 https://github.com/abertsch/Menlo-for-Powerline
rm -rf ./Menlo-for-Powerline/.git
mv "Menlo-for-Powerline" "${FONTS_DIR}/chilcano/"
printf "Fonts updated/installed. \n\n"

## Ref: https://github.com/diogocavilha/fancy-git
printf "==> Installing 'SourceCode+Powerline+Awesome+Regular' fonts. \n"
wget -q https://github.com/diogocavilha/fancy-git/blob/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf
mv SourceCodePro+Powerline+Awesome+Regular.ttf "${FONTS_DIR}/chilcano/"
printf "Fonts updated/installed. \n\n"

## Ref: https://github.com/ryanoasis/nerd-fonts#option-6-ad-hoc-curl-download
printf "==> Installing 'Droid Sans Mono for Powerline Nerd' fonts. \n"
wget -q https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
mv "'Droid Sans Mono Nerd Font Complete.otf'" "${FONTS_DIR}/chilcano/"
printf "Fonts updated/installed. \n\n"

sudo apt install -y gnome-tweaks
printf "==> Now with Gnome-Tweaks select the patched font to use. \n\n"
