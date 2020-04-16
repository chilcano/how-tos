#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

echo "##########################################################"
echo "####              Setting DevOps Desktop              ####"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

echo "==> Installing git, awscli, curl, jq and unzip"
apt-get update
apt-get install -y git, awscli curl jq unzip software-properties-common apt-transport-https

echo "==> Installing Java"
apt-get install -y openjdk-11-jre-headless

echo "==> Installing VS Code"
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
apt-get update
apt-get install -y code

echo "==> Installing Terraform"
#TF_VERSION=0.12.24
#TF_VERSION="0.11.15-oci"
TF_VERSION_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
TF_BUNDLE="terraform_${TF_VERSION_LATEST}_linux_amd64.zip"
wget --quiet "https://releases.hashicorp.com/terraform/${TF_VERSION_LATEST}/${TF_BUNDLE}"
unzip "${TF_BUNDLE}"
mv terraform /usr/local/bin/
rm -rf terraf*

echo "==> Installing Packer"
PACKER_VERSION_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r -M '.current_version')
PACKER_BUNDLE="packer_${PACKER_VERSION_LATEST}_linux_amd64.zip"
wget --quiet "https://releases.hashicorp.com/packer/${PACKER_VERSION_LATEST}/${PACKER_BUNDLE}"
unzip "${PACKER_BUNDLE}"
mv packer /usr/local/bin/
rm -rf packer*

printf "\n\t** Duration of DevOps Desktop setup: $((($(date +%s)-${TIME_RUN_DEVOPS}))) seconds.\n\n"
