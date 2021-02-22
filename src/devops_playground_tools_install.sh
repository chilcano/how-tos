#!/bin/bash

# source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/devops_playground_tools_install.sh) 

echo "##########################################################"
echo "####         Install DevOps Playground tools          ####"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive
ARCH="amd"

echo "==> Installing Git, awscli, curl, jq, unzip, software-properties-common and tree"
sudo apt -yqq update
sudo apt -yqq upgrade
sudo apt -yqq install git awscli curl jq unzip software-properties-common sudo apt-transport-https tree > "/dev/null" 2>&1
printf ">> Git, awscli, curl, jq and unzip installed.\n\n"

echo "==> Installing Java 8 and 11 (default)"
sudo apt -yqq install default-jdk openjdk-8-jdk > "/dev/null" 2>&1
printf ">> Java installed.\n\n"

echo "==> Selecting the Java/Javac 11 as default version"
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-11-openjdk-amd64/bin/java 1111
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-11-openjdk-amd64/bin/javac 1111
printf ">> Java 11 selected. \n\n"

echo "==> Installing Maven"
sudo apt -yqq install maven > "/dev/null" 2>&1
printf ">> Maven installed.\n\n"

echo "==> Creating '/etc/profile.d/maven.sh'"
cat << 'EOF' > maven.sh
#!/bin/bash

JAVA_HOME=/usr/lib/jvm/default-java
M2_HOME=/opt/maven
MAVEN_HOME=/opt/maven
## removed 'export' and replaced '${xyz}' for '$xyz'
PATH=$M2_HOME/bin:$PATH
EOF
sudo chown -R root:root maven.sh
sudo chmod +x maven.sh
sudo mv maven.sh /etc/profile.d/maven.sh
. /etc/profile.d/maven.sh
printf ">> Java and Maven configured.\n"
mvn -version
printf "\n\n"

echo "==> Installing Golang"
sudo apt -yqq install golang > "/dev/null" 2>&1
printf ">> Golang ($(go version)) installed.\n\n"

echo "==> Installing Terraform"
TF_VER_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
TF_BUNDLE="terraform_${TF_VER_LATEST}_linux_${ARCH}64.zip"
wget --quiet "https://releases.hashicorp.com/terraform/${TF_VER_LATEST}/${TF_BUNDLE}"
unzip -q "${TF_BUNDLE}"
sudo mv terraform /usr/local/bin/
rm -rf terraf*
printf ">> $(terraform version) installed.\n\n"

echo "==> Installing Packer"
PACKER_VER_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r -M '.current_version')
PACKER_BUNDLE="packer_${PACKER_VER_LATEST}_linux_${ARCH}64.zip"
wget --quiet "https://releases.hashicorp.com/packer/${PACKER_VER_LATEST}/${PACKER_BUNDLE}"
unzip -q "${PACKER_BUNDLE}"
sudo mv packer /usr/local/bin/
rm -rf packer*
printf ">> $(packer version) installed.\n\n"

echo "==> Installing NodeJS, NPM and AWS CDK"
sudo apt -yqq install nodejs npm > "/dev/null" 2>&1
sudo npm install --quiet -g aws-cdk > "/dev/null" 2>&1
printf ">> NodeJS $(npm -v node), NPM $(npm -v npm) and AWS CDK $(cdk --version) installed.\n\n"

echo "==> Installing Python3, Python3-Pip and Dev tools"
sudo apt -yqq install python3 python3-pip build-essential libssl-dev libffi-dev python3-dev python3-venv > "/dev/null" 2>&1
printf ">> $(python3 --version) installed.\n\n"

printf ">> End!! \n\n"
