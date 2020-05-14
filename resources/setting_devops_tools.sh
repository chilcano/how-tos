#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

echo "##########################################################"
echo "####          Install and setup DevOps tools          ####"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

echo "==> Installing Git, awscli, curl, jq, unzip, software-properties-common (apt-add-repository) and gnome-tweaks"
sudo apt update
sudo apt install -y git awscli curl jq unzip software-properties-common sudo apt-transport-https gnome-tweaks
printf ">> Git, awscli, curl, jq, unzip and gnome-tweaks installed OK.\n\n"

echo "==> Installing Ansible"
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
printf ">> Ansible installed OK.\n\n"

echo "==> Installing Java 8, 11 (default) and Oracle Java 11"
sudo apt install -y default-jdk openjdk-8-jdk
##sudo add-apt-repository --yes --update ppa:linuxuprising/java
##sudo apt install -y oracle-java11-installer-local
printf ">> Java installed OK.\n\n"

echo "==> Selecting Java/Javac 8 as default version and auto-mode"
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java 1200
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac 1200
printf "\n\n"

echo "==> Installing Maven"
sudo apt install -y maven
printf ">> Maven installed OK.\n\n"

echo "==> Creating '/etc/profile.d/maven.sh'"
cat <<EOF > maven.sh
#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/default-java
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOF
sudo chown -R root:root maven.sh
sudo chmod +x maven.sh
sudo mv maven.sh /etc/profile.d/maven.sh
. /etc/profile.d/maven.sh
printf ">> Java and Maven configured OK."
mvn -version
printf "\n\n"

echo "==> Installing VS Code"
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo sudo apt-key add -
sudo apt-add-repository --yes --update "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
##sudo apt update
sudo apt install -y code
printf ">> VS Code installed OK.\n\n"

echo "==> Configuring VS Code and installing Extensions"
wget -q https://raw.githubusercontent.com/chilcano/how-tos/master/resources/setup_vscode.sh
chmod +x setup_vscode.sh
. setup_vscode.sh
rm -f setup_vscode.sh
printf ">> VS Code config and extensions installed OK.\n\n"

echo "==> Installing Terraform"
TF_VERSION="0.11.15-oci"
TF_VERSION_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
TF_VERSION="${TF_VERSION:-$TF_VERSION_LATEST}"
TF_BUNDLE="terraform_${TF_VERSION}_linux_amd64.zip"
wget --quiet "https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_BUNDLE}"
unzip "${TF_BUNDLE}"
sudo mv terraform /usr/local/bin/
rm -rf terraf*
printf ">> Terraform ${TF_VERSION} installed OK.\n\n"

echo "==> Installing Packer"
PACKER_VERSION="1.5.5"
PACKER_VERSION_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r -M '.current_version')
PACKER_VERSION="${PACKER_VERSION:-$PACKER_VERSION_LATEST}"
PACKER_BUNDLE="packer_${PACKER_VERSION}_linux_amd64.zip"
wget --quiet "https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_BUNDLE}"
unzip "${PACKER_BUNDLE}"
sudo mv packer /usr/local/bin/
rm -rf packer*
printf ">> Packer installed OK.\n\n"

printf ">> Duration: $((($(date +%s)-${TIME_RUN_DEVOPS}))) seconds.\n\n"
