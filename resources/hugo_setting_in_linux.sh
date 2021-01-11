#!/bin/bash

echo "##########################################################"
echo "#    Installing Hugo binary cross-platform on Ubuntu     #"
echo "##########################################################"

# curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/resources/hugo_setting_in_linux.sh | bash

printf ">> Installing tools. \n\n"
sudo apt -yqq install curl wget jq unzip git

printf ">> Downloading and Installing 'Hugo' binary. \n\n"
#_ARCH="64bit"
#_EXT="deb"
HUGO_PKG="Linux-${_ARCH:-64bit}.${_EXT:-deb}"
HUGO_BUNDLE_URL=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r ".assets[].browser_download_url" | grep ${HUGO_PKG} | grep -v "extended")
HUGO_BUNDLE_NAME="${HUGO_BUNDLE_URL##*/}"

if [ -f "${HUGO_BUNDLE_NAME}" ]; then
    printf "\t * The $HUGO_BUNDLE_NAME file exists. Nothing to download. \n"
else
    printf "\t * Downloading the $HUGO_BUNDLE_NAME file. \n"
    wget -q $HUGO_BUNDLE_URL
fi
printf "\t * Installing the $HUGO_BUNDLE_NAME file. \n"
sudo dpkg -i $HUGO_BUNDLE_NAME
hugo version

printf "\t * Installing 'hub' git wrapper. \n"
sudo apt -yqq install hub