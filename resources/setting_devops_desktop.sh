#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

echo "##########################################################"
echo "####              Setting DevOps Desktop              ####"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

echo "==> Installing Git, awscli, curl, jq, unzip and gnome-tweaks"
apt update
apt install -y git awscli curl jq unzip software-properties-common apt-transport-https gnome-tweaks
printf ">> Git, awscli, curl, jq, unzip and gnome-tweaks installed OK.\n\n"

echo "==> Installing Ansible"
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible
printf ">> Ansible installed OK.\n\n"

echo "==> Installing Java"
apt install -y openjdk-11-jre-headless
printf ">> Java installed OK.\n\n"

echo "==> Installing VS Code"
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
apt update
apt install -y code
printf ">> VS Code installed OK.\n\n"

echo "==> Installing Terraform"
#TF_VERSION=0.12.24
#TF_VERSION="0.11.15-oci"
TF_VERSION_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
TF_BUNDLE="terraform_${TF_VERSION_LATEST}_linux_amd64.zip"
wget --quiet "https://releases.hashicorp.com/terraform/${TF_VERSION_LATEST}/${TF_BUNDLE}"
unzip "${TF_BUNDLE}"
mv terraform /usr/local/bin/
rm -rf terraf*
printf ">> Terraform installed OK.\n\n"

echo "==> Installing Packer"
PACKER_VERSION_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r -M '.current_version')
PACKER_BUNDLE="packer_${PACKER_VERSION_LATEST}_linux_amd64.zip"
wget --quiet "https://releases.hashicorp.com/packer/${PACKER_VERSION_LATEST}/${PACKER_BUNDLE}"
unzip "${PACKER_BUNDLE}"
mv packer /usr/local/bin/
rm -rf packer*
printf ">> Packer installed OK.\n\n"

printf ">> Duration of DevOps Desktop setup: $((($(date +%s)-${TIME_RUN_DEVOPS}))) seconds.\n\n"

