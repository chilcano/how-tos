## How-To's  

Repository with technical indications to install, configure any interesting stuff. 

### Resources

1. [FizzBuzz Python test](resources/fizzbuzz1.py)
2. [NewPassword Generator Java test](resources/NewPasswordGenerator.java)
3. [Preparing-Python-Dev-Env-Mac-OSX](resources/preparing_python_dev_env_mac_osx.md)
4. [Disabling sleeping when close laptop lid](resources/disable_sleeping_when_close_laptop_lid.md)
5. [Install IDE and DevOps tools](resources/devops_tools_install_v1.sh) (MS VSCode, extensions, Terraform, Packer, Java, AWS Cli, etc.) in **Ubuntu**
   ```sh
    wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/devops_tools_install_v1.sh
    chmod +x devops_tools_install_v1.sh  
    . devops_tools_install_v1.sh
   ```  
6. Install IDE and DevOps tools:  
   * [Install](resources/code_server_install.sh)/[remove](resources/code_server_remove.sh) only **Code-Server** in Ubuntu (amd64):
      ```sh
       wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/code_server_install.sh
       wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/code_server_remove.sh
       chmod +x code_server_install.sh code_server_remove.sh
       . code_server_install.sh
       . code_server_remove.sh
      ```
   * [Install](resources/code_server_install_rpi.sh)/[remove](resources/code_server_remove_rpi.sh) only **Code-Server** in Raspberry Pi (arm):
      ```sh
       wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/code_server_install_rpi.sh
       wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/code_server_remove_rpi.sh
       chmod +x code_server_install_rpi.sh code_server_remove_rpi.sh
       . code_server_install_rpi.sh
       . code_server_remove_rpi.sh
      ```
   * [Install](resources/code_server_install_wsl2.sh)/[remove](resources/code_server_remove_wsl2.sh) only **Code-Server** in WLS2 (Ubuntu 20.04):
      ```sh
       wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/code_server_install_wsl2.sh
       wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/code_server_remove_wsl2.sh
       chmod +x code_server_install_wsl2.sh code_server_remove_wsl2.sh
       . code_server_install_wsl2.sh
       . code_server_remove_wsl2.sh
      ```
   * [Install](resources/devops_tools_install_v2.sh)[Remove](resources/devops_tools_remove_v2.sh) DevOps tools v2. It works in Ubuntu (amd64), Raspberry Pi (arm) and WSL2 (Ubuntu/amd64).
      ```sh
       wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/devops_tools_install_v2.sh \
                https://raw.githubusercontent.com/chilcano/how-tos/master/resources/devops_tools_remove_v2.sh
       chmod +x devops_tools_install_v2.sh devops_tools_remove_v2.sh 
       . devops_tools_install_v2.sh --arch=[amd|arm] [--tf-ver=0.11.15-oci] [--packer-ver=1.5.5]
      ```
7. Customizing the Ubuntu Prompt  
   - [With Synth Shell](resources/custom_prompt_with_synth_shell.md)  
   - [With Fancy GIT](resources/custom_prompt_with_fancy_git.md)  
   - [With Powerline-Go](resources/custom_prompt_with_powerline_go.md)  

8. [Install custom Fonts in Ubuntu](resources/install_fonts_in_ubuntu.sh)  
   This script will install 3 patched fonts including glyphs to be used in custom Terminal Prompt:  
   - [Menlo-for-Powerline](https://github.com/abertsch/Menlo-for-Powerline)
   - [SourceCodePro Powerline Awesome Regular](https://github.com/diogocavilha/fancy-git/blob/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf)
   - [Droid Sans Mono Nerd Font Complete](https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf)
   ```sh
    wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/install_fonts_in_ubuntu.sh
    chmod +x install_fonts_in_ubuntu.sh
    . install_fonts_in_ubuntu.sh
   ```  
9. Patching Fonts in Code-Server in Raspberry Pi   
   This process will patch Code-Server running in Raspberry Pi (installed in `/usr/lib/node_modules/code-server`) to use custom fonts.  
   Further info: [https://github.com/cdr/code-server/issues/1374](https://github.com/cdr/code-server/issues/1374)  
   ```sh
    git clone https://github.com/tuanpham-dev/code-server-font-patch
    sudo ./code-server-font-patch/patch.sh /usr/lib/node_modules/code-server
    systemctl --user restart code-server
   ```  
10. [Install **Jekyll** in Linux](resources/setting_jekyll_in_linux.sh). Tested in Ubuntu 18.04, above and Raspbian/Raspberry Pi OS.  
   It will install also Ruby, Ruby-dev, build-essential, zlib1g-dev, Gem, Bundler, etc.  
   ```sh
    wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/setting_jekyll_in_linux.sh
    chmod +x setting_jekyll_in_linux.sh
    . setting_jekyll_in_linux.sh
   ```
   Running Jekyll:   
   ```sh
    JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch
    JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch --host=0.0.0.0
    JEKYLL_ENV=production bundle exec jekyll serve --watch --drafts
    RUBYOPT=-W0 JEKYLL_ENV=production bundle exec jekyll serve --incremental --watch 
   ```
11. GIT guides:
   - [Github - Persisting credentials](resources/git_saving_credentials.md)
   - [Github - Pull Request](resources/git_pull_request_guide.md)
12. [Getting CPU and GPU temperature in Ubuntu 19.04](resources/getting_temperature_cpu_gpu_hd_in_ubuntu.md)
13. [Installing Logitech Unifying (Keyboard adn mice) in Ubuntu 19.04](resources/installing_logitech_unifying_in_ubuntu_19_04.md)
14. [Install and configure Asus MB168b screen in Ubuntu 18.04](resources/install_and_setup_mb168b_in_ubuntu.md)
15. [Working with Tmux](resources/working_with_tmux.md)
16. [File sharing through Samba(SMB)](resources/install_and_config_samba.md)
17. [Terraforms samples - where is the issue?](aws-terraform-where-is-the-issue/) 
18. AWS CloudFormation samples:  
   - Convert JSON to YAML.  
     ```sh
      ruby -ryaml -rjson -e 'puts YAML.dump(JSON.load(ARGF))' < cloudformation_template_example.json > cloudformation_template_example.yaml
     ```
   - [Creating an Affordable Remote DevOps Desktop with AWS CloudFormation](https://github.com/chilcano/affordable-remote-desktop/tree/master/resources/cloudformation)
   - [Deploying AWS ECS Networking and Architecture Patterns](https://github.com/chilcano/cfn-samples/tree/master/ECS/README.md)
19. [Install Apache Guacamole](https://raw.githubusercontent.com/chilcano/how-tos/master/resources/guacamole_install.sh) (web-based remote access) on Ubuntu 20.04
   ```sh
    wget -qN https://raw.githubusercontent.com/chilcano/how-tos/master/resources/guacamole_install.sh
    chmod +x guacamole_install.sh  
    . guacamole_install.sh
   ```
  