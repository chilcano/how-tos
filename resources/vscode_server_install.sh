#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --arch*|-a*)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no `=`
      _ARCH="${1#*=}"
      ;;
    --vscs-ver*|-v*)
      if [[ "$1" != *=* ]]; then shift; fi
      _VSCS_VER="${1#*=}"
      ;;
    --help|-h)
      printf "Install VSCode Server." 
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument. \n"
      exit 1
      ;;
  esac
  shift
done

echo "##########################################################"
echo "####            Installing VS Code Server             ####"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

#VSCS_VER="3.3.1"
VSCS_PKG="${_ARCH}64.deb"
VSCS_VER_LATEST=$(curl -s https://api.github.com/repos/cdr/code-server/releases/latest | jq -r -M '.tag_name')
VSCS_VER="${_VSCS_VER:-$VSCS_VER_LATEST}"

#printf ">> Uninstalling previous version of 'code-server'. \n"
#sudo dpkg -r code-server
##sudo apt clean -y && sudo apt autoremove -y
##sudo apt -f install
#sudo dpkg --configure -a

VSCS_BUNDLE=$(curl -s https://api.github.com/repos/cdr/code-server/releases | jq -r "[.[].assets[].name | select(. | contains(\"${VSCS_VER}\") and contains(\"${VSCS_PKG}\"))][0]")
#VSCS_BUNDLE=$(curl -s https://api.github.com/repos/cdr/code-server/releases | jq -r ".[].assets[].name" | grep -m 1 $VSCS_VER.$VSCS_PKG | head -1)

if [ -f "${VSCS_BUNDLE}" ]; then
    printf ">> The $VSCS_BUNDLE file exists. Nothing to download. \n"
else
    printf ">> The $VSCS_BUNDLE doesn't exist. Downloading the DEB file. \n"
    #VSCS_URL=$(curl -s https://api.github.com/repos/cdr/code-server/releases | jq -r "[.[].assets[].browser_download_url | select(. | contains(\"${VSCS_VER}\") and contains(\"${VSCS_PKG}\"))][0]")
    VSCS_URL=$(curl -s https://api.github.com/repos/cdr/code-server/releases | jq -r ".[].assets[].browser_download_url" | grep -m 1 $VSCS_VER.$VSCS_PKG | head -1)
    wget -q $VSCS_URL
fi

echo ">> Installing DEB file."
sudo dpkg -i $VSCS_BUNDLE

echo ">> Starting systemd service."
systemctl --user enable --now code-server
#echo ">> Now visit http://127.0.0.1:8080. Your password is in ~/.config/code-server/config.yaml"

echo ">> Deleting DEB file."
rm -rf code-server*

echo ">> Tweaking '~/.config/code-server/config.yaml'"
sed -i.bak 's/auth: password/auth: none/' ~/.config/code-server/config.yaml
sed -i.bak 's/^bind-addr: .*$/bind-addr: 0.0.0.0:8001/' ~/.config/code-server/config.yaml

echo ">> Restarting VSCode Server."
systemctl --user restart code-server

printf ">> VSCode Server $VSCS_VER was installed successfully. \n"
