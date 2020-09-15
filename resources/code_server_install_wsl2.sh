#!/bin/bash

unset _VSCS_TAG

while [ $# -gt 0 ]; do
  case "$1" in
    --vscs-tag*|-t*)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no '=' (3.4.1, 3.4.0, v3.4.0)
      _VSCS_TAG="${1#*=}"
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
echo "#      Installing Code-Server on WSL2 (Ubuntu 20.04)     #"
echo "##########################################################"

if [ -z ${_VSCS_TAG+x} ]; then
  # getting the latest tag_name
  VSCS_TAG="$(curl -s https://api.github.com/repos/cdr/code-server/releases/latest | jq -r -M '.tag_name')"
else
  VSCS_TAG="${_VSCS_TAG}"
fi
VSCS_VER="${VSCS_TAG//v/}"
## download URL format
# https://github.com/cdr/code-server/releases/download/3.4.0/code-server-3.4.0-linux-amd64.tar.gz
# https://github.com/cdr/code-server/releases/download/v3.4.0/code-server-3.4.0-linux-amd64.tar.gz
VSCS_BUNDLE_URL="https://github.com/cdr/code-server/releases/download/${VSCS_TAG}/code-server-${VSCS_VER}-linux-amd64.tar.gz"
VSCS_BUNDLE_NAME="${VSCS_BUNDLE_URL##*/}"

printf ">> Downloading and unzipping Code-Server.\n"
mkdir -p ~/.local/lib ~/.local/bin

curl -fL ${VSCS_BUNDLE_URL} | tar -C ~/.local/lib -xz
mv ~/.local/lib/code-server-${VSCS_VER}-linux-amd64 ~/.local/lib/code-server-${VSCS_VER}
ln -s ~/.local/lib/code-server-${VSCS_VER}/bin/code-server ~/.local/bin/code-server

printf ">> Installing Extension: Shan.code-settings-sync. \n"
code-server --install-extension Shan.code-settings-sync
printf "\nGet a trusted Gist ID to restore extensions and configurations through Settings-Sync extension:\n"
printf "\t URL: https://gist.github.com/chilcano/b5f88127bd2d89289dc2cd36032ce856 \n"
printf "\t Gist ID: b5f88127bd2d89289dc2cd36032ce856 \n\n"

printf ">> Installing 'mkcert' (https://github.com/FiloSottile/mkcert) .\n"
MKCERT_BUNDLE_URL=$(curl -s https://api.github.com/repos/FiloSottile/mkcert/releases/latest | jq -r -M '.assets[].browser_download_url | select(contains("linux-amd"))')
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
mkcert -install

if [[ -f localhost+2.pem ]] && [[ -f localhost+2-key.pem ]]; then
  printf ">> The Cert and Key pem files exists. \n"
else
  printf ">> The Cert and Key pem files don't exist. Generating Cert and Key pem files. \n"
  mkcert localhost 127.0.0.1 ::1
fi

printf ">> Trust on the Root CA crt generated by 'mkcert'.\n"
printf ">> E.g. You can install it in your browser as trusted CA.\n"
printf ">> You can found the Root CA here: /home/<WLS2_USER>/.local/share/mkcert/rootCA.pem \n"

printf ">> Installation of 'Code-Server', 'mkcert' completed and TLS certs generated.\n"
printf ">> Now you can start 'Code-Server' executing these commands:\n"
printf "\t code-server                                    # starts using default config (~/.config/code-server/config.yaml) \n"
printf "\t code-server --auth none  --disable-telemetry   # starts without authn, in port 8080 and without telemetry \n"
printf "\t code-server --disable-telemetry --bind-addr 127.0.0.1:8443 --cert localhost+2.pem --cert-key localhost+2-key.pem   # uses created TLS certs \n\n"

