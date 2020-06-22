## How-To's

Repository with technical indications to install, configure any interesting stuff. 

### Resources

1. [FizzBuzz Python test](resources/fizzbuzz1.py)
2. [NewPassword Generator Java test](resources/NewPasswordGenerator.java)
3. [Preparing-Python-Dev-Env-Mac-OSX](resources/preparing_python_dev_env_mac_osx.md)
4. [Disabling sleeping when close laptop lid](resources/disable_sleeping_when_close_laptop_lid.md)
5. [Install and setup DevOps tools (includes MS VSCode, config and extensions) in Ubuntu](resources/devops_tools_install_v1.sh)
   ```sh
   $ wget https://raw.githubusercontent.com/chilcano/how-tos/master/resources/devops_tools_install_v1.sh
   $ chmod +x devops_tools_install_v1.sh  
   $ . devops_tools_install_v1.sh
   ```  
6. Install and setup DevOps tools  
   * [DevOps tools in Ubuntu (amd64) or Raspberry Pi (arm)](resources/devops_tools_install_v2.sh)  
      ```sh
      $ wget https://raw.githubusercontent.com/chilcano/how-tos/master/resources/devops_tools_install_v2.sh
      $ chmod +x devops_tools_install_v2.sh 
      $ . devops_tools_install_v2.sh --arch=[amd|arm] [--tf-ver=0.11.15-oci] [--packer-ver=1.5.5]
      ```
   * Code-Server in Ubuntu (amd64)
      - [code_server_install.sh](resources/code_server_install.sh)  
      - [code_server_remove.sh](resources/code_server_remove.sh)
   * Code-Server Raspberry Pi (arm)
      - [code_server_install_rpi.sh](resources/code_server_install_rpi.sh)
      - [code_server_remove_rpi.sh](resources/code_server_remove_rpi.sh)
7. Customizing the Ubuntu Prompt  
   - [With Synth Shell](resources/fancy_prompt_with_synth_shell.md)   
      ![](resources/fancy_prompt_ubuntu_with_synth_shell.png)  
   - [With Fancy GIT](resources/fancy_prompt_with_fancy_git.md)  
      ![](resources/fancy_prompt_ubuntu_with_fancy_git.png) 

8. [Install custom Fonts in Ubuntu](resources/install_fonts_in_ubuntu.sh)  
   ```sh
   $ wget https://raw.githubusercontent.com/chilcano/how-tos/master/resources/install_fonts_in_ubuntu.sh
   $ chmod +x install_fonts_in_ubuntu.sh
   $ . install_fonts_in_ubuntu.sh
   ```  
9. [Installing Jekyll in Ubuntu](resources/setting_jekyll_in_ubuntu.sh)
   ```sh
   $ wget https://raw.githubusercontent.com/chilcano/how-tos/master/resources/setting_jekyll_in_ubuntu.sh
   $ chmod +x setting_jekyll_in_ubuntu.sh
   $ . setting_jekyll_in_ubuntu.sh
   ```
   Running Jekyll:   
   ```sh
   $ JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch
   $ JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch --host=0.0.0.0
   $ JEKYLL_ENV=production bundle exec jekyll serve --watch --drafts
   ```
10. GIT guides:
   - [Github - Persisting credentials](resources/git_saving_credentials.md)
   - [Github - Pull Request](resources/git_pull_request_guide.md)
11. [Getting CPU and GPU temperature in Ubuntu 19.04](resources/getting_temperature_cpu_gpu_hd_in_ubuntu.md)
12. [Installing Logitech Unifying (Keyboard adn mice) in Ubuntu 19.04](resources/installing_logitech_unifying_in_ubuntu_19_04.md)
13. [Install and configure Asus MB168b screen in Ubuntu 18.04](resources/install_and_setup_mb168b_in_ubuntu.md)
14. [Working with Tmux](resources/working_with_tmux.md)
15. [File sharing through Samba(SMB)](resources/install_and_config_samba.md)

