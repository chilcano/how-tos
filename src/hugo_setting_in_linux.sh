#!/bin/bash

unset _ARCH _BIN _DIST

echo "##########################################################"
echo "#    Installing Hugo binary cross-platform on Ubuntu     #"
echo "##########################################################"

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/hugo_setting_in_linux.sh) -a=ARM64|64bit -b=tar.gz|deb -d=extended
# ./hugo_setting_in_linux.sh -a=64bit -b=tar.gz -d=extended
# curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/hugo_setting_in_linux.sh | bash

while [ $# -gt 0 ]; do
  case "$1" in
    --arch*|-a*)
      if [[ "$1" != *=* ]]; then shift; fi
      _ARCH="${1#*=}"
      ;;
    --binary*|-b*)
      if [[ "$1" != *=* ]]; then shift; fi
      _BIN="${1#*=}"
      ;;
    --distribution*|-d*)
      if [[ "$1" != *=* ]]; then shift; fi
      _DIST="${1#*=}"
      ;;
    --help|-h)
      printf "Install Hugo binary in Linux."
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument: '$1' \n"
      exit 1
      ;;
  esac
  shift
done

printf ">> Installing tools. \n\n"
sudo apt -yqq install curl wget jq unzip git

printf "\n"
printf ">> Removing installed 'Hugo' binary. \n\n"
sudo dpkg -r hugo

printf "\n"
printf ">> Downloading and installing a new 'Hugo' binary. \n\n"
HUGO_PKG="Linux-${_ARCH:-64bit}.${_EXT:-deb}"

if [[ "${_DIST}" == "extended" ]]; then
    HUGO_BUNDLE_URL=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r ".assets[].browser_download_url" | grep -i ${HUGO_PKG} | grep -i "extended")
else
    HUGO_BUNDLE_URL=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r ".assets[].browser_download_url" | grep -i ${HUGO_PKG} | grep -v "extended")
fi
HUGO_BUNDLE_NAME="${HUGO_BUNDLE_URL##*/}"

if [ -f "${HUGO_BUNDLE_NAME}" ]; then
    printf "* The $HUGO_BUNDLE_NAME file exists. Nothing to download. \n"
else
    printf "* Downloading the $HUGO_BUNDLE_NAME file. \n"
    wget -q $HUGO_BUNDLE_URL
fi
printf "\t * Installing the $HUGO_BUNDLE_NAME file. \n"
sudo dpkg -i $HUGO_BUNDLE_NAME
hugo version
