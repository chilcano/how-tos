# IDE and DevOps Tools

## Guides and scripts

1. [devops_tools_install_v1.sh](../src/devops_tools_install_v1.sh).

* Install IDE and DevOps tools: Install MS VSCode, extensions, Terraform, Packer, Java, AWS Cli, etc.) in **Ubuntu**.
* Used as post installation script after Terraform provisioning.

```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/devops_tools_install_v1.sh | bash
```  

2. [Install](../src/code_server_install.sh) and [remove](../src/code_server_remove.sh) **Code-Server** in Ubuntu (amd64 and arm64).

```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/code_server_install.sh | bash
curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/code_server_remove.sh | bash
```
2nd method and installation for Ubuntu OS 64 bits on Raspberry Pi 3 b+:
```sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/main/src/code_server_install.sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/main/src/code_server_remove.sh

sudo apt -y install jq

chmod +x code_server_*.sh
. code_server_install.sh --arch=arm
. code_server_remove_rpi.sh
```


3. [Install](../src/code_server_install_rpi.sh) and [remove](../src/code_server_remove_rpi.sh)  **Code-Server** in Raspberry Pi (arm).

```sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/main/src/code_server_install_rpi.sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/main/src/code_server_remove_rpi.sh

chmod +x code_server_*.sh
. code_server_install_rpi.sh
. code_server_remove_rpi.sh
```

4. [Install](../src/code_server_install_wsl2.sh) and [remove](../src/code_server_remove_wsl2.sh) **Code-Server** in WLS2 (Ubuntu 20.04).

```sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/main/src/code_server_install_wsl2.sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/main/src/code_server_remove_wsl2.sh

chmod +x code_server_*.sh
. code_server_install_wsl2.sh
. code_server_remove_wsl2.sh
```

5. [Install](../src/devops_tools_install_v3.sh) and [remove](../src/devops_tools_remove_v3.sh) DevOps tools v3. It works in Ubuntu (amd64), Raspberry Pi (arm) and WSL2 (Ubuntu/amd64).

```sh
. devops_tools_install_v3.sh --arch=[amd|arm] [--tf-ver=0.11.15-oci] [--packer-ver=1.5.5]
```

This example will install on AMD with latest versions of Terraform, Packer, Go, Python, Docker and Java available in on Ubuntu 21.10:
```sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/main/src/devops_tools_install_v3.sh \
        https://raw.githubusercontent.com/chilcano/how-tos/main/src/devops_tools_remove_v3.sh

chmod +x devops_tools_*.sh  
. devops_tools_install_v3.sh 
```
Or using explicit versions and without download the scripts:
```sh
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/devops_tools_install_v3.sh) -a=arm -t=0.11.15-oci -p=1.5.5
```
