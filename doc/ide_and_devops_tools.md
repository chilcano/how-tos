# IDE and DevOps Tools

## Guides and scripts

1. [devops_tools_install_v1.sh](src/devops_tools_install_v1.sh).

* Install IDE and DevOps tools: Install MS VSCode, extensions, Terraform, Packer, Java, AWS Cli, etc.) in **Ubuntu**.
* Used as post installation script after Terraform provisioning.

```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/devops_tools_install_v1.sh | bash
```  


2. [Install](src/code_server_install.sh) and [remove](src/code_server_remove.sh) **Code-Server** in Ubuntu (amd64).

```sh
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/code_server_install.sh | bash
curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/code_server_remove.sh | bash
```

3. [Install](src/code_server_install_rpi.sh) and [remove](src/code_server_remove_rpi.sh)  **Code-Server** in Raspberry Pi (arm).

```sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/src/code_server_install_rpi.sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/src/code_server_remove_rpi.sh

chmod +x code_server_*.sh
. code_server_install_rpi.sh
. code_server_remove_rpi.sh
```

4. [Install](src/code_server_install_wsl2.sh) and [remove](src/code_server_remove_wsl2.sh) **Code-Server** in WLS2 (Ubuntu 20.04).

```sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/src/code_server_install_wsl2.sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/src/code_server_remove_wsl2.sh

chmod +x code_server_*.sh
. code_server_install_wsl2.sh
. code_server_remove_wsl2.sh
```

5. [Install](src/devops_tools_install_v3.sh) and [remove](src/devops_tools_remove_v2.sh) DevOps tools v3. It works in Ubuntu (amd64), Raspberry Pi (arm) and WSL2 (Ubuntu/amd64).

```sh
wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/src/devops_tools_install_v3.sh \
        https://raw.githubusercontent.com/chilcano/how-tos/master/src/devops_tools_remove_v3.sh

chmod +x devops_tools_*.sh  
. devops_tools_install_v3.sh --arch=[amd|arm] [--tf-ver=0.11.15-oci] [--packer-ver=1.5.5]
```
