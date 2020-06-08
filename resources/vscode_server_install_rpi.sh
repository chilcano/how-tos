#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --arch*|-a*)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no `=`
      _ARCH="${1#*=}"
      ;;
    --vscs-ver*|-v*)
      if [[ "$1" != *=* ]]; then shift; fi
      _VSCS_VER="${1#*=}"
      ;;
    --help|-h)
      printf "Install VSCode Server." 
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument. \n"
      exit 1
      ;;
  esac
  shift
done

echo "##########################################################"
echo "####    Installing VS Code Server on Raspberry Pi     ####"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive
NODEJS_VER="14"

curl -sL https://deb.nodesource.com/setup_$NODEJS_VER.x | sudo bash -

## Run `sudo apt-get install -y nodejs` to install Node.js 14.x and npm
## You may also need development tools to build native addons:
#     sudo apt-get install gcc g++ make
## To install the Yarn package manager, run:
#     curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
#     sudo apt-get update && sudo apt-get install yarn



##### ref: https://github.com/cdr/code-server/blob/master/doc/npm.md
printf ">> Installing requisites. \n"
sudo apt-get install -y build-essential pkg-config libx11-dev libxkbfile-dev libsecret-1-dev


#### ref: https://linuxize.com/post/how-to-install-node-js-on-raspberry-pi/
printf ">> Installing NodeJS and NPM"
sudo apt install nodejs
printf "NodeJS $(node -v) and NPM $(npm -v) installed. \n\n"

printf ">> Installing VSCode Server"
sudo npm install -g code-server --unsafe-perm

printf ">> VSCode Server postinstalling"
sudo npm install -g @google-cloud/logging
sudo npm install -g protobufjs

#pi@raspberrypi:~ $ code-server
#info  Wrote default config file to ~/.config/code-server/config.yaml
#info  Using config file ~/.config/code-server/config.yaml
#info  Using user-data-dir ~/.local/share/code-server
#info  code-server 3.4.1 48f7c2724827e526eeaa6c2c151c520f48a61259
#info  HTTP server listening on http://127.0.0.1:8080
#info      - Using password from ~/.config/code-server/config.yaml
#info      - To disable use `--auth none`
#info    - Not serving HTTPS


### Ref:  https://upcloud.com/community/tutorials/install-code-server-ubuntu-18-04/

# create systemctl
# config
# run


echo ">> Starting systemd service."
systemctl --user enable --now code-server
#echo ">> Now visit http://127.0.0.1:8080. Your password is in ~/.config/code-server/config.yaml"


echo ">> Tweaking '~/.config/code-server/config.yaml'"
sed -i.bak 's/auth: password/auth: none/' ~/.config/code-server/config.yaml
sed -i.bak 's/^bind-addr: .*$/bind-addr: 0.0.0.0:8001/' ~/.config/code-server/config.yaml

echo ">> Restarting VSCode Server."
systemctl --user restart code-server

printf ">> VSCode Server $VSCS_VER was installed successfully. \n"
