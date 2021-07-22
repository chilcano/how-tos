#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

echo "##########################################################"
echo "####               Remove DevOps tools v3             ####"
echo "##########################################################"

sudo apt -yqq remove git awscli curl jq unzip software-properties-common sudo apt-transport-https  > "/dev/null" 2>&1
printf ">> Git, awscli, curl, jq and unzip removed.\n\n"

echo "==> Removing AWS CLI 2.x installed manually"
awscli_path_to_bin=$(which aws)
sudo rm ${awscli_path_to_bin}
sudo rm ${awscli_path_to_bin}_completer
sudo rm -rf /usr/local/aws-cli
printf ">> AWS CLI v2.x removed.\n\n"

echo "==> Removing Java 8 and 11 (default)"
sudo apt -yqq remove default-jdk openjdk-8-jdk > "/dev/null" 2>&1
printf ">> Java removed.\n\n"

echo "==> Removing Maven"
sudo apt -yqq remove maven > "/dev/null" 2>&1
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
