# How-To's

Repository with technical indications to install, configure any interesting stuff. 

## Resources

1. [FizzBuzz Python test](resources/fizzbuzz1.py)
2. [NewPassword Generator Java test](resources/NewPasswordGenerator.java)
3. [wso2-identity-server-4.5.0-install-config-centos](resources/wso2-identity-server-4.5.0-install-config-centos.md)
4. [Preparing-Python-Dev-Env-Mac-OSX](resources/Preparing-Python-Dev-Env-Mac-OSX.md)
5. [Config-JackRabbit-con-MySQL-para-Liferay-DocLib](resources/config_jackrabbit_con_mysql_para_liferay_doclib.md)
6. [Setup a DevOps Desktop](resources/setting_devops_desktop.sh)
   ```sh
   $ wget https://raw.githubusercontent.com/chilcano/how-tos/master/resources/setting_devops_desktop.sh
   $ chmod +x setting_devops_desktop.sh  
   $ . setting_devops_desktop.sh
   ```
7. [Install and configure Asus MB168b screen in Ubuntu 18.04](resources/install_and_setup_mb168b_in_ubuntu.md)
8. [Customizing VS Code](resources/setup_vscode.sh)
   ```sh
   $ wget https://raw.githubusercontent.com/chilcano/how-tos/master/resources/setup_vscode.sh
   $ chmod +x setup_vscode.sh
   $ . setup_vscode.sh
   ```
9. [Installing Jekyll in Ubuntu](resources/setting_jekyll_in_ubuntu.sh)
   ```sh
   $ wget https://raw.githubusercontent.com/chilcano/how-tos/master/resources/setting_jekyll_in_ubuntu.sh
   $ chmod +x setting_jekyll_in_ubuntu.sh
   $ . setting_jekyll_in_ubuntu.sh
   ```
10. Fancy Linux Prompt
   ```sh
   // Reference:
   // https://yalneb.blogspot.com/2018/01/fancy-bash-promt.html

   $ sudo apt install fonts-powerline
   $ git clone --recursive https://github.com/andresgongora/synth-shell.git
   $ chmod +x synth-shell/setup.sh
   $ synth-shell/setup.sh
   ```
11. Persisting GIT credentials
   ```sh
   $ git config --global user.email "chilcano@intix.info"
   $ git config --global user.name "Chilcano"
   
   // Save the credentials permanently
   $ git config --global credential.helper store
   
   // Save the credentials for a session
   $ git config --global credential.helper cache
   
   // Also set a timeout for the above setting
   $ git config --global credential.helper 'cache --timeout=600'
   ```
