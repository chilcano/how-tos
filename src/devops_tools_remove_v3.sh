#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

echo "##########################################################"
echo "####               Remove DevOps tools v3             ####"
echo "##########################################################"

sudo apt -yqq remove git awscli curl jq unzip software-properties-common sudo apt-transport-https
printf ">> Git, awscli, curl, jq and unzip removed.\n\n"

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
printf ">> Completed. n\n"

echo "==> Removing Terraform"
sudo rm /usr/local/bin/terraform
printf ">> Terraform removed.\n\n"

echo "==> Removing Packer"
sudo rm /usr/local/bin/packer
printf ">> Packer removed.\n\n"

echo "==> Removing Docker"
sudo apt -yqq remove docker.io > "/dev/null" 2>&1
printf ">> Docker removed.\n\n"

echo "==> Removing NodeJS, NPM and AWS CDK"
sudo npm uninstall --quiet -g aws-cdk > "/dev/null" 2>&1
printf ">> AWS CDK removed.\n\n"
sudo apt -yqq remove nodejs npm > "/dev/null" 2>&1
printf ">> NodeJS and NPM removed.\n\n"

echo "==> Removing Python3, Python3-Pip and Dev tools"
sudo apt -yqq remove python3 python3-pip build-essential libssl-dev libffi-dev python3-dev python3-venv > "/dev/null" 2>&1
printf ">> Python and tools removed.\n\n"

echo "==> APT autoremoving "
sudo apt -yqq autoremove > "/dev/null" 2>&1
printf ">> Final apt autoremove completed.\n\n"

printf ">> Duration: $((($(date +%s)-${TIME_RUN_DEVOPS}))) seconds.\n\n"
