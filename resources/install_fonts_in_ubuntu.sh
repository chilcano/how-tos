#!/bin/bash

NOW=$(date +"%y%m%d.%H%M%S")
FONTS_DIR1="${HOME}/.fonts"                   # terminal
FONTS_DIR2="${HOME}/.local/share/fonts"       # chrome ?

if [ -d "${FONTS_DIR1}/chilcano" ]; then
  printf "\n==> There are fonts in '${FONTS_DIR1}/chilcano/'. Backing up it.\n\n"
  tar -zcvf "${FONTS_DIR1}/chilcano-fonts.${NOW}" "${FONTS_DIR1}/chilcano"
  rm -rf "${FONTS_DIR1}/.uuid" "${FONTS_DIR1}/chilcano/"
  rm -rf "${FONTS_DIR2}/.uuid" "${FONTS_DIR2}/chilcano/" 
else
    mkdir -p ${FONTS_DIR1}/chilcano/
    mkdir -p ${FONTS_DIR2}/chilcano/
fi
fc-cache -fv
printf "\n"

## Ref: https://dev.to/mattstratton/making-powerline-work-in-visual-studio-code-terminal-1m7
#printf "==> Installing 'Menlo for Powerline' fonts. \n"
#git clone --depth=1 https://github.com/abertsch/Menlo-for-Powerline
#rm -rf ./Menlo-for-Powerline/.git
#mv "Menlo-for-Powerline" "${FONTS_DIR1}/chilcano/"
#printf "Fonts updated/installed. \n\n"

## Ref: https://github.com/diogocavilha/fancy-git
printf "==> Installing 'SourceCode+Powerline+Awesome+Regular' fonts. \n"
wget -q https://github.com/diogocavilha/fancy-git/blob/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf
mv "SourceCodePro+Powerline+Awesome+Regular.ttf" "${FONTS_DIR1}/chilcano/"
printf "Fonts updated/installed. \n\n"

## Ref: https://github.com/ryanoasis/nerd-fonts#option-2-release-archive-download
FONT_NAME="DroidSansMono"
FONT_NAME="SourceCodePro"
printf "==> Installing '${FONT_NAME}' fonts. \n"
FONT_BUNDLE_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r -M '.assets[].browser_download_url' | grep $FONT_NAME)
FONT_BUNDLE_NAME="${FONT_BUNDLE_URL##*/}"
if [ -f "${FONT_BUNDLE_NAME}" ]; then
    printf ">> The $FONT_BUNDLE_NAME file exists. Nothing to download. \n"
else
    printf ">> The file doesn't exist. Downloading the $FONT_BUNDLE_NAME file. \n"
    wget -q $FONT_BUNDLE_URL
fi
unzip -q "${FONT_BUNDLE_NAME}" -d "${FONTS_DIR1}/chilcano/${FONT_NAME}"
printf "Fonts ${FONT_NAME} updated/installed. \n\n"

### Copy all fonts to FONTS_DIR2="${HOME}/.local/share/fonts" 
cp -r "${FONTS_DIR1}/chilcano/" "${FONTS_DIR2}/chilcano/"

sudo apt install -y gnome-tweaks
printf "==> Now with Gnome-Tweaks select the patched font to use. \n\n"

printf "==> Font caching and cleaning up."
fc-cache -fv
printf "\n"
