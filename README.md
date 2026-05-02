# How-To's  

Repository with technical indications to install, configure any interesting stuff. 

## Resources

### General guides

1. [NewPassword Generator Java test](src/NewPasswordGenerator.java)
2. [Python guides and samples](doc/python_docs_samples.md)
3. [Customizing/styling a Windows and Linux Prompt](doc/styled_win_linux_prompt.md) 
4. [Install patched fonts (with glyphs) required for styled Win/Linux Prompts and modern Terminals](doc/patched_fonts.md)
5. [Working with TMux](doc/working_with_tmux.md)
6. Git guides
  * [Github - Frequent commands](doc/git_frequent_commands.md)
  * [Github - Authentication, Tokens and Credential Manager](doc/git_auth_guide.md)
  * [GitHub's Hub wrapper - Install and configure](src/git_and_hub_setting_in_linux.sh)
  * [Create new Git repo from sub-folder of existing repo preserving history](doc/git_subfolder_to_repository.md)
  * Install Git and Bash emulator in Windows:  
    - [Git for Windows](https://gitforwindows.org/)
    - Download `Git-<version>-64-bit.exe` from [https://github.com/git-for-windows/git/releases/](https://github.com/git-for-windows/git/releases/) or [https://git-scm.com/download/win](https://git-scm.com/download/win), execute it and follow all instructions.
  * Install GitHub Hub for Windows:  
    - [GitHub Hub](https://hub.github.com/) is a extension to Git CLI that helps to manage GitHub from your Terminal.
    - Download `hub-windows-amd64-<version>.zip` from [https://github.com/github/hub/releases](https://github.com/github/hub/releases), unzip it and install it in your system.
  * [Signing Git commits and tags with GPG and SSH keys](doc/git_signing.md)
  * [GitHub CLI (gh) - Install, configure and common use cases](doc/gh_cli_guide.md)
7. [Install Logitech Unifying (Keyboard and mice) in Ubuntu](doc/install_logi_unifying_in_ubuntu.md)
8. Screen Tools:
  - [Take screenshots silently in Ubuntu with xfce4-screenshooter](doc/screen_shooter_silent.md)
  - [Change the brightness level of a screen](doc/screen_change_brightness_level.md)
  - [Screenshot and annotation Tools](doc/screenshot_annotation_tools.md) 
9. [Configure Printers in Ubuntu](doc/install_printer_ubuntu.md)
10. [File sharing through Samba(SMB)](doc/install_and_config_samba.md)
11. Cloud and Infrastructure as Code (IaC) examples:
  - [Terraforms examples](doc/iac_terraform_examples.md)
  - [CloudFormation examples](doc/iac_cloudformation_examples.md)
12. [Create booteable USB Ubuntu](doc/booteable_usb_on_ubuntu.md)  
13. [Google Drive on Ubuntu with XFCE](doc/google_drive_on_linux.md)  
14. [Regex examples in VSCode and Bash](doc/regex_examples.md)
15. [Generate and import SSH Pub Key to all AWS Regions](doc/import_ssh_keys_to_aws_regions.md)
16. [Disabling sleeping when close laptop lid](doc/disable_sleeping_when_close_laptop_lid.md)
17. Docker & Docker Compose  
  - [Docker install and commands](doc/docker_install_and_commands.md)
  - [Docker Compose install and example](doc/docker_compose_install.md)
18. Raspberry Pi - Guides
  - [Install Raspbian OS and Ubuntu 64bits on Raspberry Pi 3B+ in headless mode](doc/raspberry_pi_getting_started.md)
  - [Install Code-Server on RPi](doc/install_code_server_on_headless_rpi.md)
  - [Install Pi-Hole on RPi](doc/pi_hole_guide.md)
19. [Issue Certificates with MKCert](doc/issue_certs_with_mkcert.md)
20. GitHub Pages - Building static website with Hugo:
  - [Create static web with Hugo](doc/github_pages_hugo_create_a_static_web.md)
  - [Publish new content with Hugo](doc/github_pages_hugo_publish_content.md)
  - [Publish new content on Waskhar Project](doc/github_pages_hugo_publish_content_waskhar.md)
21. [Installing and using NMAP](doc/nmap_commands.md)
22. [Installing and uninstalling IDE and DevOps Tools for multiple platforms](doc/ide_and_devops_tools.md)
23. [Installing and running IPFS Cluster CLI](doc/ipfs_cluster_ctl_commands.md)
24. [Kubernetes Ops guide](doc/kubernetes_ops_guide.md)
25. [CI/CD GitHub workflows for NodeJS and TypeScript applications](doc/github-workflow-for-nodejs-typescript-apps.md)
26. [Getting a NodeJS development setup](doc/nodejs-typescript-dev-workflow.md) - tbc
27. [Install your own Minecraft Server](doc/minecraft-server.md)
28. [Firewalling in Linux with UFW](doc/firewall-ubuntu.md)
29. [Immich, a self-hosted Google Photos alternative](doc/immich-self-hosted-google-photos-alt/)
30. [Docker Management with Portainer](doc/portainer_install.md)
31. [Prime Numbers in Python](src/python_challenges/prime_numbers)
32. [Enable WIFI in Ubuntu Recovery Mode](doc/enable_wifi_in_ubuntu_recovery_mode.md)
33. Virtualization & Proxmox
  - [KVM Virtualization with Virt](doc/virtualization/kvm-virt-manager-guide.md)
  - [Kali Linux in QEMU/KVM-Virt](doc/virtualization/qemu-kvm-kali-linux.md)
  - [SPICE and vdagent on Proxmox to get better remote Ubuntu Desktop experience](doc/virtualization/proxmox-spice-vdagent-virt-viewer.md)
  - [Proxmox VE Guide — tips, tricks and helpful notes](doc/proxmox_guide.md)
34. Cloudflare
  - [Cloudflare API - Token Management](doc/cloudflare/cloudflare_api_token_management.md)
  - [Cloudflare API - Threat Intelligence](doc/cloudflare/cloudflare_intel_api_guide.md)
  - [Cloudflare API - DNS Management](doc/cloudflare/cloudflare_api_dns_guide.md)

### Security guides

1. [RESTful API - Generating Documentation and OpenAPI specs from Golang API](doc/api_rest_in_golang_generate_oas_and_docs.md)
2. [RESTful API - Security checking using Spectral Linter](doc/api_security_checks.md)
3. [DAST - Project Discovery Nuclei - Vulnerability scanner](src/hacktools/project-discovery-nuclei.md)
4. [DAST - OWASP ZAP - Vulnerability scanner](doc/owasp-zap/)
5. [Testing FHE with Python](doc/ecosystems-architectures/01-pyfhel-salary-processing.py)
6. [MicroK8s Guide](doc/playing_with_microk8s/README.md)
7. [Trivy - Security Dependencies Checking](doc/sca/trivy_security_dependencies_checking.md)
8. [Trivy Operator - Security Dependencies Checking in Kubernetes](doc/playing_with_trivy_operator/trivy-operator-guide-README.md)
9. [DefectDojo - Application Security Posture Management (ASPM) and Vulnerability Management](doc/playing_with_defectdojo/defectdojo-guide-README.md)
10. [Web3, dApp and Blockchain Secure SDLC](doc/dapp-sec/)

### Security attacks mitigation tools

1. [20251126 - Shai Hulud Attack V2](doc/sec-attacks/shai-hulud-attack/)

---

## Outdated

> Guides and scripts moved here because they reference end-of-life operating systems, deprecated tools, or significantly outdated software versions. Kept for historical reference.

### Guides (`outdated/doc/`)

- [Install Ardour in Ubuntu 20.04](outdated/doc/ardour_in_ubuntu_20.04.md) — Ubuntu 20.04 (EOL Apr 2025), Ardour v6.5 (current: v8.x)
- [Install Asus MB168b DisplayLink screen in Ubuntu 18.04](outdated/doc/screen_mb168b_install_in_ubuntu.md) — Ubuntu 18.04 (EOL Apr 2023)
- [Getting CPU and GPU temperature in Ubuntu 19.04](outdated/doc/getting_temperature_cpu_gpu_hd_in_ubuntu.md) — Ubuntu 19.04 (EOL Jan 2020)
- [Install AutoFirma Java App in Ubuntu 19.10](outdated/doc/install_autofirma_app_in_ubuntu19.10.md) — Ubuntu 19.10 (EOL Jul 2020), Java 14-ea
- [Installation of WSO2 MB, Apache Qpid, RabbitMQ and Apache ActiveMQ on CentOS](outdated/doc/install_wso2mb_qpid_rabbitmq_activemq.md) — CentOS (EOL Dec 2021)
- [Bitnami Sealed Secrets on Google Kubernetes Engine](outdated/doc/bitnami_sealed_secrets_on_gke_guide.md) — kubectl v1.26 (2022), gcloud SDK 413.0.0
- [Bitnami Decrypt Sealed Secrets](outdated/doc/bitnami_sealed_secrets_decrypt.md) — companion to the GKE guide above
- [Install TightVNC on Ubuntu 20.04](outdated/doc/install_tightvnc.md) — Ubuntu 20.04 (EOL Apr 2025)
- [Install Apache Guacamole on Ubuntu 20.04](outdated/doc/install_apache_guacamole.md) — Ubuntu 20.04 (EOL Apr 2025)
- [Create static web with Jekyll](outdated/doc/github_pages_jekyll_create_a_static_web.md) — Old Ruby/Jekyll toolchain targeting Ubuntu 18.04
- [Setting iMac (early 2009) fan control for Ubuntu](outdated/doc/imac_early_2009_fan_control_on_ubuntu.md) — iMac 2009 hardware
- [Turn off Macbook/iMac startup sound on Ubuntu](outdated/doc/turn_off_mac_startup_sound_on_ubuntu.md) — Old iMac/Mac hardware

### Scripts (`outdated/src/`)

- [Proxmox v2.x - Resize VM LVM2](outdated/src/proxmox-v.2.x-resize-vm-lvm2.txt) — Proxmox 2.x
- [Proxmox v3.3 - Resize VM LVM2](outdated/src/proxmox-v3.3-resize-vm-lvm2.txt) — Proxmox 3.3
- [Proxmox - Disk/RAID management (Spanish)](outdated/src/gestion-discos-raid-proxmox.txt) — Old Proxmox RAID guide
- [Proxmox - Install VirtualBox in a Proxmox VM](outdated/src/install_virtualbox_in_a_proxmox_vm.txt) — Old Proxmox guide
- [Ardour install log](outdated/src/ardourd_install_log.txt) — Companion to Ardour Ubuntu 20.04 guide
- [TightVNC install script](outdated/src/vnc_install.sh) — Companion to TightVNC guide
- [Guacamole install script](outdated/src/guacamole_install.sh) — Companion to Apache Guacamole guide
- [Jekyll setup script for Linux](outdated/src/jekyll_setting_in_linux.sh) — Companion to Jekyll guide
- [Jekyll-to-Hugo migration script (Holosec)](outdated/src/migrate_jekyll_holosec_to_hugo.sh) — Old Jekyll-to-Hugo migration
