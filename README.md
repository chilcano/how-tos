## How-To's

Repository with technical indications to install, configure any interesting stuff. 

### Resources

1. [FizzBuzz Python test](resources/fizzbuzz1.py)
2. [NewPassword Generator Java test](resources/NewPasswordGenerator.java)
3. [wso2-identity-server-4.5.0-install-config-centos](resources/wso2-identity-server-4.5.0-install-config-centos.md)
4. [Preparing-Python-Dev-Env-Mac-OSX](resources/Preparing-Python-Dev-Env-Mac-OSX.md)
5. [Disabling sleeping when close laptop lid](resources/disable_sleeping_when_close_laptop_lid.md)
6. Install and setup DevOps tools in Ubuntu   
   6.1. [Install and setup DevOps tools](resources/setting_devops_tools.sh)
      ```sh
      $ wget https://raw.githubusercontent.com/chilcano/how-tos/master/resources/setting_devops_tools.sh
      $ chmod +x setting_devops_tools.sh  
      $ . setting_devops_tools.sh
      ```
   6.2. [Customizing VS Code](resources/setup_vscode.sh)
      ```sh
      $ wget https://raw.githubusercontent.com/chilcano/how-tos/master/resources/setup_vscode.sh
      $ chmod +x setup_vscode.sh
      $ . setup_vscode.sh
      ```
   6.3. Customizing the Ubuntu Prompt   
      - [With Synth Shell](resources/fancy_prompt_with_synth_shell.md)   
        ![](resources/fancy_prompt_ubuntu_with_synth_shell.png)  
      - [With Fancy GIT](resources/fancy_prompt_with_fancy_git.md)  
        ![](resources/fancy_prompt_ubuntu_with_fancy_git.png)  
   6.4. [Adding Powerline Fonts to VS Code](resources/setup_vscode_powerline_fonts.sh)  
      ```sh
      $ wget https://raw.githubusercontent.com/chilcano/how-tos/master/resources/setup_vscode_powerline_fonts.sh
      $ chmod +x setup_vscode_powerline_fonts.sh
      $ . setup_vscode_powerline_fonts.sh
      ```  
7. [Installing Jekyll in Ubuntu](resources/setting_jekyll_in_ubuntu.sh)
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
8. GIT guides:
   - [Github - Persisting credentials](resources/git_saving_credentials.md)
   - [Github - Pull Request](resources/git_pull_request_guide.md)
9. [Getting CPU and GPU temperature in Ubuntu 19.04](resources/getting_temperature_cpu_gpu_hd_in_ubuntu.md)
10. [Installing Logitech Unifying (Keyboard adn mice) in Ubuntu 19.04](resources/installing_logitech_unifying_in_ubuntu_19_04.md)
11. [Install and configure Asus MB168b screen in Ubuntu 18.04](resources/install_and_setup_mb168b_in_ubuntu.md)
12. [Working with Tmux](resources/working_with_tmux.md)

