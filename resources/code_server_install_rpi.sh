#!/bin/bash

unset _VSCS_VER

while [ $# -gt 0 ]; do
  case "$1" in
    --vscs-ver*|-v*)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no '=' (3.4.1, 3.4.0)
      _VSCS_VER="${1#*=}"
      ;;
    --help|-h)
      printf "Install Code-Server on Raspberry Pi."
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument: '$1' \n"
      exit 1
      ;;
  esac
  shift
done

echo "##########################################################"
echo "#       Installing Code-Server on Raspberry Pi           #"
echo "##########################################################"

export DEBIAN_FRONTEND=noninteractive

##### ref: https://github.com/cdr/code-server/blob/master/doc/npm.md
printf ">> Installing Libs. \n"
sudo apt install -y build-essential pkg-config libx11-dev libxkbfile-dev libsecret-1-dev git jq
printf  ">> Libs were installed. \n\n"

printf ">> Installing NodeJS, NPM and YARN using NVM. \n"
curl -sS -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
nvm install node			# install latest nodejs
nvm use node
nvm alias default node

# NodeJS > 12 is required to install code-server
NODEJS_VER="12"							# NodeJS 12.18.4 is the LTS
nvm install --lts=erbium --latest-npm	# Install NodeJS LTS and NPM
nvm use --lts=erbium					# Active use of NodeJS LTS
nvm alias default lts/erbium			# Set NodeJS LTS as Default
nvm install-latest-npm					# Attempt to upgrade to latest working NPM in current version NodeJS
npm i -g yarn							# Install Yarn in global mode
printf ">> NVM $(nvm --version), NodeJS $(node -v), NPM $(npm -v) and YARN $(yarn -v) were installed. \n\n"

printf ">> Installing Code-Server. \n"
if [ -z ${_VSCS_VER+x} ]; then
  VSCS_VER=""
else
  VSCS_VER="@${_VSCS_VER}"
fi
npm i -g code-server$VSCS_VER --unsafe-perm
npm i -g @google-cloud/logging@^4.5.2 typescript@^3.0.0 
printf ">> Code-Server installed. \n\n"

printf ">> Creating soft links for NodeJS and Code-Server. \n"
sudo ln -s -f $(npm config get prefix)/bin/node /usr/bin/node
sudo ln -s -f $(npm config get prefix)/bin/code-server /usr/bin/code-server

printf ">> Creating Systemd Code-Server service. \n"
cat << EOF > code-server.service
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
sudo mv -f code-server.service /usr/lib/systemd/user/code-server.service
printf ">> code-server.service created. \n\n"

printf ">> Starting Systemd code-server service. \n"
systemctl --user daemon-reload
systemctl --user enable --now code-server
printf ">> code-server.service enabled and started. \n\n"

printf ">> Waiting code-server starts.... \n\n"
sleep 5s

printf ">> Installing MKCert .\n"
MKCERT_BUNDLE_URL=$(curl -s https://api.github.com/repos/FiloSottile/mkcert/releases/latest | jq -r -M '.assets[].browser_download_url | select(contains("linux-arm"))')
MKCERT_BUNDLE_NAME="${MKCERT_BUNDLE_URL##*/}"

if [ -f "${MKCERT_BUNDLE_NAME}" ]; then
    printf ">> The $MKCERT_BUNDLE_NAME file exists. Nothing to download. \n"
else
    printf ">> The file doesn't exist. Downloading the $MKCERT_BUNDLE_NAME file. \n"
    wget -q $MKCERT_BUNDLE_URL
fi
cp $MKCERT_BUNDLE_NAME mkcert
chmod +x mkcert

printf ">> Generating TLS certs with 'mkcert' for 'Code-Server'.\n"
sudo apt -y install libnss3-tools
./mkcert -install
if [[ -f vscs-rpi.pem ]] && [[ -f vscs-rpi-key.pem ]]; then
  printf ">> The Cert and Key pem files exists. \n"
else
  printf ">> The Cert and Key pem files don't exist. Generating Cert and Key pem files. \n"
  ./mkcert localhost 127.0.0.1 ::1 vscs.rpi 192.168.1.55
  cp localhost+4.pem ~/vscs-rpi.pem
  cp localhost+4-key.pem ~/vscs-rpi-key.pem
fi
printf "\n"

printf ">> Tweaking '~/.config/code-server/config.yaml' to enable TLS. \n"
sed -i.bak 's/^bind-addr: .*$/bind-addr: 0.0.0.0:8443/' ~/.config/code-server/config.yaml
sed -i.bak 's/cert: false/cert: vscs-rpi.pem/' ~/.config/code-server/config.yaml
echo -e 'cert-key: vscs-rpi-key.pem' >> ~/.config/code-server/config.yaml
echo -e 'disable-telemetry: true\n' >> ~/.config/code-server/config.yaml
printf "\n"

printf ">> The '~/.config/code-server/config.yaml' final is: \n"
echo "-----------------------------------------------"
cat ~/.config/code-server/config.yaml
echo "-----------------------------------------------"

printf ">> Trust on the Root CA crt generated by 'mkcert'.\n"
printf ">> You have to install it in your browser as trusted CA and add 'vscs.rpi 192.168.1.55' in you '/etc/hosts' file.\n"
printf ">> You can found the Root CA here: ~/.local/share/mkcert/rootCA.pem \n\n"

printf ">> Installing Extension: Shan.code-settings-sync. \n"
code-server --install-extension Shan.code-settings-sync
printf "\nSettings-Sync extension requires a Gist ID to sync VSCode config:\n"
printf "\t Gist URL: https://gist.github.com/chilcano/b5f88127bd2d89289dc2cd36032ce856 \n"
printf "\t Gist ID: b5f88127bd2d89289dc2cd36032ce856 \n\n"

printf ">> Installing Extension from VSIX: AmazonWebServices.aws-toolkit-vscode. \n"
AWS_TOOLKIT_VSIX_URL=$(curl -s https://api.github.com/repos/aws/aws-toolkit-vscode/releases/latest | jq -r -M '.assets[].browser_download_url')
AWS_TOOLKIT_VSIX_NAME="${AWS_TOOLKIT_VSIX_URL##*/}"
wget -q $AWS_TOOLKIT_VSIX_URL
code-server --install-extension $AWS_TOOLKIT_VSIX_NAME
printf "\n"

printf ">> Restarting Code-Server to apply changes. \n"
systemctl --user restart code-server

printf ">> Code-Server installation process completed successfully. \n"
