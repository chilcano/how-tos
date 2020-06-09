#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --vscs-ver*|-v*)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no '=' (3.4.1, 3.4.0)
      _VSCS_VER="${1#*=}"
      ;;
    --help|-h)
      printf "Install VSCode Server on Raspberry Pi." 
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument: '$1' \n"
      exit 1
      ;;
  esac
  shift
done

echo   "##########################################################"
printf "##   Installing VSCode Server on Raspberry Pi ($(uname -m))  ##\n"
echo   "##########################################################"

export DEBIAN_FRONTEND=noninteractive

# NodeJS ver > 12 is mandatory
NODEJS_VER="14"

printf ">> Adding APT NodeJS repo. \n"
curl -sL https://deb.nodesource.com/setup_$NODEJS_VER.x | sudo bash -

##### ref: https://github.com/cdr/code-server/blob/master/doc/npm.md
printf ">> Installing requisites. \n"
sudo apt-get install -y build-essential pkg-config libx11-dev libxkbfile-dev libsecret-1-dev
printf  ">> Requsites such as libs were installed. \n\n"

#### ref: https://linuxize.com/post/how-to-install-node-js-on-raspberry-pi/
printf ">> Installing NodeJS and NPM. \n"
sudo apt install -y nodejs
printf ">> NodeJS $(node -v) and NPM $(npm -v) installed. \n\n"

printf ">> Installing VSCode Server. \n"
if [ -z ${_VSCS_VER+x} ]; then
  VSCS_VER=""
else
  VSCS_VER="@${_VSCS_VER}"
fi
#### To query all versions available: $ npm view code-server versions --json
sudo npm install -g code-server$VSCS_VER --unsafe-perm 
printf ">> VSCode Server installed. \n\n"

printf ">> VSCode Server post-installing. \n"
sudo npm install -g @google-cloud/logging
sudo npm install -g protobufjs
printf ">> Post-installation completed. \n\n"

### VSCode server as a systemd system
### Ref:  https://upcloud.com/community/tutorials/install-code-server-ubuntu-18-04/

#### VSCode server if systemd user doesn't work
#sudo cp /usr/lib/systemd/user/code-server.service /etc/systemd/system
#sudo sed -i 's/\(Restart=always\)/\1\nUser=$USER/' /etc/systemd/system/code-server.service

printf ">> Creating '/usr/lib/systemd/user/code-server.service'. \n"
cat <<EOF > code-server.service
[Unit]
Description=code-server
After=network.target

[Service]
Type=exec
ExecStart=/usr/bin/code-server
Restart=always

[Install]
WantedBy=default.target
EOF
sudo chown -R root:root code-server.service
sudo mv code-server.service /usr/lib/systemd/user/code-server.service
printf ">> code-server.service created. \n\n"

printf ">> Starting '/usr/lib/systemd/user/code-server.service'. \n"
systemctl --user daemon-reload
systemctl --user enable --now code-server
#systemctl --user status code-server
printf ">> code-server.service enabled and started. \n\n"

printf ">> Waiting code-server starts. \n\n"
sleep 5s 

printf ">> Tweaking '~/.config/code-server/config.yaml'. \n"
sed -i.bak 's/auth: password/auth: none/' ~/.config/code-server/config.yaml
sed -i.bak 's/^bind-addr: .*$/bind-addr: 0.0.0.0:8001/' ~/.config/code-server/config.yaml

printf ">> Installing Extension: Shan.code-settings-sync. \n"
code-server --install-extension Shan.code-settings-sync
printf ">> Extension installed. \n\n"

printf ">> Restarting VSCode Server. \n"
systemctl --user restart code-server

printf ">> VSCode Server was installed successfully. \n"
