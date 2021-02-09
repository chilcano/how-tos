# Google Drive on Linux

This has been tested on Ubuntu 20.04 with XFCE.

## Refs:
- https://www.linuxuprising.com/2018/07/mounting-google-drive-on-xfce-or-mate.html

## Steps

1. Install Gnome Control Center and Gnome Online Accounts.
```sh
sudo apt -yqq install gnome-control-center gnome-online-accounts
```
2. Run Gnome Control Center and configure Gnome Online Accounts.  
Once opened Gnome Control Center, go to Gnome Online Accounts to configure your google account. 
```sh
XDG_CURRENT_DESKTOP=GNOME gnome-control-center
```
Once completed the configuration, you will see yhe google drive account configured in your File Manager Application.

