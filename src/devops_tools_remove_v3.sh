#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

echo "##########################################################"
echo "####               Remove DevOps tools v3             ####"
echo "##########################################################"

sudo apt -yqq install git awscli curl jq unzip software-properties-common sudo apt-transport-https
printf ">> Git, awscli, curl, jq and unzip installed.\n\n"

echo "==> Removing Java 8, 11 (default) and Oracle Java 11"
sudo apt -yqq remove default-jdk openjdk-8-jdk
##sudo add-apt-repository --yes --update ppa:linuxuprising/java
##sudo apt install -y oracle-java11-installer-local
printf ">> Java removed.\n\n"

echo "==> Removing Maven"
sudo apt -yqq remove maven
printf ">> Maven removed.\n\n"

echo "==> Removing '/etc/profile.d/maven.sh'"
sudo rm /etc/profile.d/maven.sh
printf "\n\n"

echo "==> Removing Terraform"
sudo rm /usr/local/bin/terraform
printf ">> Terraform removed.\n\n"

echo "==> Removing Packer"
sudo rm /usr/local/bin/packer
printf ">> Packer removed.\n\n"

echo "==> Removing Docker"
sudo apt -yqq remove docker.io
printf ">> Docker removed.\n\n"

echo "==> Removing NodeJS, NPM and AWS CDK"
sudo npm uninstall --quiet -g aws-cdk
sudo apt -yqq remove nodejs npm

echo "==> Removing Python3, Python3-Pip and Dev tools"
sudo apt -yqq remove python3 python3-pip build-essential libssl-dev libffi-dev python3-dev python3-venv

printf ">> Duration: $((($(date +%s)-${TIME_RUN_DEVOPS}))) seconds.\n\n"
