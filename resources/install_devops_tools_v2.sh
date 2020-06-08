#!/bin/bash

TIME_RUN_DEVOPS=$(date +%s)

while [ $# -gt 0 ]; do
  case "$1" in
    --arch*|-a*)                           # amd | arm 
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no `=`
      _ARCH="${1#*=}"
      ;;
    --vscs-ver*|-v*)
      if [[ "$1" != *=* ]]; then shift; fi
      _VSCS_VER="${1#*=}"
      ;;
    --tf-ver*|-t*)
      if [[ "$1" != *=* ]]; then shift; fi
      _TF_VER="${1#*=}"
      ;;
    --packer-ver*|-p*)
      if [[ "$1" != *=* ]]; then shift; fi
      _PACKER_VER="${1#*=}"
      ;; 
    --help|-h)
      printf "Install VSCode Server and other DevOps tools. \n"
      printf "Examples: \n"
      printf "\t . install_devops_tools_v2.sh --arch=amd --vscs-ver=3.4.0 \n"
      printf "\t . install_devops_tools_v2.sh --arch=arm --vscs-ver=3.4.1 --tf-ver=0.11.15-oci \n"
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
echo "####         Install and setup DevOps tools v2        ####"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

echo "==> Installing Git, awscli, curl, jq, unzip and software-properties-common (apt-add-repository)"
sudo apt update
sudo apt install -y git awscli curl jq unzip software-properties-common sudo apt-transport-https
printf ">> Git, awscli, curl, jq and unzip installed.\n\n"

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
if [[ "$_ARCH" = "arm" ]]; then
  sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-armhf/jre/bin/java 1200
  sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-8-openjdk-armhf/bin/javac 1200
else 
  sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java 1200
  sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac 1200
fi
printf "\n\n"

echo "==> Installing Maven"
sudo apt install -y maven
printf ">> Maven installed.\n\n"

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
printf ">> Java and Maven configured."
mvn -version
printf "\n\n"

echo "==> Installing VS Code Server"

if [[ "$_ARCH" = "arm" ]]; then
  
  curl -fsSL https://code-server.dev/install.sh | sh
else
  wget -q https://raw.githubusercontent.com/chilcano/how-tos/master/resources/vscode_server_install.sh
  chmod +x vscode_server_install.sh 
  . vscode_server_install.sh --arch=$_ARCH --vscs-ver=$_VSCS_VER
  rm -f vscode_server_install.sh 
  printf ">> VS Code Server installed.\n\n"
fi

echo "==> Loading VS Code Server' settings and installing extensions"
#wget -q https://raw.githubusercontent.com/chilcano/how-tos/master/resources/vscode_server_setup.sh
#chmod +x vscode_server_setup.sh
#. vscode_server_setup.sh
#rm -f vscode_server_setup.sh
#printf ">> VS Code Server configured and extensions installed.\n\n"
printf ">> The settings.json and extensions will be loaded from GIST through SettingsSync Extensions"

echo "==> Installing Terraform"
#_TF_VER="0.11.15-oci"
TF_VER_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
TF_VER="${_TF_VER:-$TF_VER_LATEST}"
if [[ "$_ARCH" =  "arm" ]]; then
  TF_BUNDLE="terraform_${TF_VER}_linux_${_ARCH}.zip"
else
  TF_BUNDLE="terraform_${TF_VER}_linux_${_ARCH}64.zip"
fi
wget --quiet "https://releases.hashicorp.com/terraform/${TF_VER}/${TF_BUNDLE}"
unzip "${TF_BUNDLE}"
sudo mv terraform /usr/local/bin/
rm -rf terraf*
printf ">> Terraform ${TF_VER} installed.\n\n"

echo "==> Installing Packer"
#PACKER_VER="1.5.5"
PACKER_VER_LATEST=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r -M '.current_version')
PACKER_VER="${_PACKER_VER:-$PACKER_VER_LATEST}"
if [[ "$_ARCH" = "arm" ]]; then
  PACKER_BUNDLE="packer_${PACKER_VER}_linux_${_ARCH}.zip"
else
  PACKER_BUNDLE="packer_${PACKER_VER}_linux_${_ARCH}64.zip"
fi
wget --quiet "https://releases.hashicorp.com/packer/${PACKER_VER}/${PACKER_BUNDLE}"
unzip "${PACKER_BUNDLE}"
sudo mv packer /usr/local/bin/
rm -rf packer*
printf ">> Packer installed.\n\n"

### Chromium isn't needed and Ubuntu 20.04 it uses other installation way
#printf "==> Installing Chromium \n"
#sudo apt install -yq chromium-browser
#printf ">> Chromium installed.\n\n"

printf ">> Duration: $((($(date +%s)-${TIME_RUN_DEVOPS}))) seconds.\n\n"
