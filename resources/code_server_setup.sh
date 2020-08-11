#!/bin/bash

echo "##########################################################"
echo "#    Setting Code-Server and installing extensions       #"
echo "##########################################################"

NOW=$(date +"%y%m%d.%H%M%S")
VSCS_USER_DIR="${HOME}/.local/share/code-server/User"
printf "\n==> Look&Feel and config \n"

echo ">> Getting 'settings.json' and copying to '$VSCS_USER_DIR/settings.json'"
wget -q https://raw.githubusercontent.com/chilcano/how-tos/master/resources/vscode/dot_config/Code/User/settings.json
if [ -f "${VSCS_USER_DIR}/settings.json" ]; then
    printf ">> Making a backup of '${VSCS_USER_DIR}/settings.json'\n"
    mv ${VSCS_USER_DIR}/settings.json ${VSCS_USER_DIR}/settings.json.bak.${NOW} 
fi 
printf ">> Copying 'settings.json' to '${VSCS_USER_DIR}/'\n"
cp settings.json $VSCS_USER_DIR/.
rm -f settings.json

printf "\n==> Extensions\n"

## https://marketplace.visualstudio.com/items?itemName=usernamehw.indent-one-space
code-server --install-extension usernamehw.indent-one-space

## https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
code-server --install-extension yzhang.markdown-all-in-one

## https://marketplace.visualstudio.com/items?itemName=mauve.terraform (deprecated)
#code-server --install-extension mauve.terraform
#code-server --uninstall-extension mauve.terraform
## https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform (start on version 2.0, work TF >= 1.2)
#code-server --install-extension HashiCorp.terraform
wget -q https://github.com/hashicorp/vscode-terraform/releases/download/v2.0.1/terraform-2.0.1.vsix
code-server --install-extension terraform-2.0.1.vsix 
rm -rf terraform-2.0.1.vsix

## https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode
######code-server --install-extension VisualStudioExptTeam.vscodeintellicode

## https://marketplace.visualstudio.com/items?itemName=redhat.java
code-server --install-extension redhat.java

## https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-maven
code-server --install-extension vscjava.vscode-maven

## https://marketplace.visualstudio.com/items?itemName=ms-python.python
code-server --install-extension ms-python.python

## https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker
code-server --install-extension ms-azuretools.vscode-docker

## https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml
code-server --install-extension redhat.vscode-yaml

## https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools
code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools

## https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh
######code-server --install-extension ms-vscode-remote.remote-ssh

## https://marketplace.visualstudio.com/items?itemName=ballerina.ballerina
code-server --install-extension ballerina.ballerina

## https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync
code-server --install-extension Shan.code-settings-sync

echo ">> Restarting VSCode Server."
systemctl --user restart code-server
