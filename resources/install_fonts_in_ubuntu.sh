#!/bin/bash

unset NOW2 FONTS_DIR1 FONTS_DIR2 FONT_NAME FONT_BUNDLE_URL FONT_BUNDLE_NAME
while [ $# -gt 0 ]; do
  case "$1" in
    --fn*|-f*)
      if [[ "$1" != *=* ]]; then shift; fi # if no value then 'DroidSansMono'. Other values: SourceCodePro, Noto)
      _FONT_NAME="${1#*=}"
      ;;
    --help|-h)
      printf "Install NerdFonts." 
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument: '$1' \n"
      exit 1
      ;;
  esac
  shift
done

NOW2=$(date +"%y%m%d.%H%M%S")
FONTS_DIR1="${HOME}/.fonts"                   # legacy
FONTS_DIR2="${HOME}/.local/share/fonts"       # new
if [ -d "${FONTS_DIR1}/chilcano" ]; then
  printf "\n==> There are fonts in '${FONTS_DIR1}/chilcano/'. Backing up it.\n\n"
  tar -zcvf "${FONTS_DIR1}/chilcanofonts.${NOW2}" "${FONTS_DIR1}/chilcano"
  rm -rf ${FONTS_DIR2}/chilcano/ 
fi
mkdir -p ${FONTS_DIR1}/chilcano/ ${FONTS_DIR2}/chilcano/
printf "\n"

## Ref: https://github.com/diogocavilha/fancy-git
printf "==> Installing 'SourceCode+Powerline+Awesome+Regular' fonts. \n"
wget -q https://github.com/diogocavilha/fancy-git/raw/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf
mv "SourceCodePro+Powerline+Awesome+Regular.ttf" ${FONTS_DIR1}/chilcano/
printf "Fonts updated/installed. \n\n"

## Ref: https://github.com/ryanoasis/nerd-fonts#option-2-release-archive-download
FONT_NAME="${_FONT_NAME:-DroidSansMono}"
printf "==> Installing '${FONT_NAME}' fonts. \n"
FONT_BUNDLE_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r -M '.assets[].browser_download_url' | grep $FONT_NAME)
FONT_BUNDLE_NAME="${FONT_BUNDLE_URL##*/}"
if [ -f "${FONT_BUNDLE_NAME}" ]; then
    printf ">> The $FONT_BUNDLE_NAME file exists. Nothing to download. \n"
else
    printf ">> The file doesn't exist. Downloading the $FONT_BUNDLE_NAME file. \n"
    wget -q $FONT_BUNDLE_URL
fi
unzip -q ${FONT_BUNDLE_NAME} -d ${FONTS_DIR1}/chilcano/${FONT_NAME}
printf "Fonts ${FONT_NAME} updated/installed. \n\n"

### Copy fonts to FONTS_DIR2 
cp -r ${FONTS_DIR1}/chilcano/ ${FONTS_DIR2}/

sudo apt install -y gnome-tweaks
printf "==> Now with Gnome-Tweaks select the patched font to use. \n\n"

printf "==> Font caching and cleaning up."
fc-cache -fv
printf "\n"
