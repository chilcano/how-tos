#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

echo "##########################################################"
echo "####          Install and setup DevOps tools v1       ####"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

echo "==> Installing Git, awscli, curl, jq, unzip and software-properties-common (apt-add-repository)"
sudo apt update
sudo apt install -y git awscli curl jq unzip software-properties-common sudo apt-transport-https
printf ">> Git, awscli, curl, jq and unzip installed. \n\n"

# Disabled installation of Ansible (Ubuntu 20.04 has issues)
#echo "==> Installing Ansible"
#sudo apt-add-repository --yes --update ppa:ansible/ansible
#sudo apt install -y ansible
#printf ">> Ansible installed.\n\n"

echo "==> Installing Java 8, 11 (default) and Oracle Java 11"
sudo apt install -y default-jdk openjdk-8-jdk
##sudo add-apt-repository --yes --update ppa:linuxuprising/java
##sudo apt install -y oracle-java11-installer-local
printf ">> Java installed.\n\n"

echo "==> Selecting Java/Javac 8 as default version and auto-mode"
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java 1200
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac 1200
printf "\n\n"

echo "==> Installing Maven"
sudo apt install -y maven
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
printf ">> Java and Maven configured."
mvn -version
printf "\n\n"

echo "==> Installing VS Code"
wget -q https://raw.githubusercontent.com/chilcano/how-tos/main/src/vscode_install.sh
chmod +x vscode_install.sh
. vscode_install.sh
rm -f vscode_install.sh
printf ">> VS Code installed.\n\n"

echo "==> Configuring VS Code and installing Extensions"
wget -q https://raw.githubusercontent.com/chilcano/how-tos/main/src/vscode_setup.sh
chmod +x vscode_setup.sh
. vscode_setup.sh
rm -f vscode_setup.sh
printf ">> VS Code config and extensions installed.\n\n"

echo "==> Installing Terraform"
TF_VERSION="0.11.15-oci"
TF_VERSION_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
TF_VERSION="${TF_VERSION:-$TF_VERSION_LATEST}"
TF_BUNDLE="terraform_${TF_VERSION}_linux_amd64.zip"
wget --quiet "https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_BUNDLE}"
unzip "${TF_BUNDLE}"
sudo mv terraform /usr/local/bin/
rm -rf terraf*
printf ">> Terraform ${TF_VERSION} installed.\n\n"

echo "==> Installing Packer"
PACKER_VERSION="1.5.5"
PACKER_VERSION_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r -M '.current_version')
PACKER_VERSION="${PACKER_VERSION:-$PACKER_VERSION_LATEST}"
PACKER_BUNDLE="packer_${PACKER_VERSION}_linux_amd64.zip"
wget --quiet "https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_BUNDLE}"
unzip "${PACKER_BUNDLE}"
sudo mv packer /usr/local/bin/
rm -rf packer*
printf ">> Packer installed.\n\n"

printf "==> Installing Chromium \n"
sudo apt install -yq chromium-browser
printf ">> Chromium installed.\n\n"

printf ">> Duration: $((($(date +%s)-${TIME_RUN_DEVOPS}))) seconds.\n\n"
