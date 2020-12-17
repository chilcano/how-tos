#!/bin/bash

echo "##########################################################"
echo "#                Installing VNC on Ubuntu                #"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

##### ref: https://linuxconfig.org/vnc-server-on-ubuntu-20-04-focal-fossa-linux
sudo apt -yqq update

## Install XFCE4 Windows Manager in Ubuntu Server 20.04 (it hasn't a WM)
printf ">> Installing XFCE4 as only Windows Manager \n\n"

printf "==> Removing all Display Managers except 'lightdm' \n"
sudo apt -yqq remove gdm3 sddm 
sudo apt -yqq autoremove

printf "==> Forcing installation of 'lightdm' as default Display Manager \n"
sudo rm -rf /etc/X11/default-display-manager
echo "/usr/sbin/lightdm" | sudo tee /etc/X11/default-display-manager
sudo apt -yqq install lightdm
sudo apt-mark hold lightdm

printf "==> Installing XFCE4 \n"
sudo apt -yqq install xfce4 xfce4-goodies gnome-icon-theme
sudo apt-mark hold xfce4
printf "==> Once finished the XFCE4 installation we recommed to reboot the host or restart Display Manager 'lightdm' \n"

printf ">> Installing Tight VNC Server \n\n"
sudo apt -yqq install tightvncserver

printf ">> Configuring Tight VNC Server \n\n"

printf "==> Creating a VNC password for current user \n"
rm -rf $HOME/.vnc/passwd*
VNC_PWD_RND=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
echo $VNC_PWD_RND > $HOME/.vnc/passwd_plain
## VNC_PWD_RND="changeme"                                 # only for testing
echo $VNC_PWD_RND | vncpasswd -f > $HOME/.vnc/passwd
## vncpasswd -f <<< $VNC_PWD_RND > "$HOME/.vnc/passwd"    # alternative option
chmod -R 0600 $HOME/.vnc/passwd*
printf "\t VNC (non-user) password created: ${VNC_PWD_RND} \n"

printf "==> Configure VNC Server to start the XFCE4 \n"
cat <<EOF > xstartup
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4 &
EOF
chmod +x xstartup
mv -f xstartup $HOME/.vnc/xstartup

printf "==> Starting VNC Server using vncserver command \n"
vncserver -kill :1
vncserver
printf "==> Checking if VNC Server is running on 5901 port \n"
ss -ltn | grep '590.'

## creating VNC Server systemd startup script
printf ">> Ceating VNC Server systemd startup script \n\n"
cat <<EOF > vncserver@.service
[Unit]
Description=Systemd VNC Server startup script for Ubuntu 20.04
After=syslog.target network.target

[Service]
Type=forking
User=${USER}
ExecStartPre=-/usr/bin/vncserver -kill :%i &> /dev/null
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1024x800 :%i
PIDFile=/${HOME}/.vnc/%H:%i.pid
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOF
sudo chown -R root:root vncserver@.service
sudo mv -f vncserver@.service /etc/systemd/system/vncserver@.service
sudo systemctl daemon-reload

## Enabling and starting VNC Server for DISPLAY NUMBER 1
printf "==> Enabling and starting VNC Server systemd service with DISPLAY NUMBER 1 \n"
## getting error when using sudo because the 'vncserver@.service' is for 'chilcano' user only
## meantime remove 'sudo' and makes it for any user (todo)
##sudo systemctl enable vncserver@1
##sudo systemctl start vncserver@1 

systemctl enable vncserver@1
systemctl start vncserver@1

## VNC Server commands:
## vncserver     // starts vnc server
## vncserver -kill :<DISPLAY-NUMBER>

printf ">> VNC Server was installed successfully. \n"
