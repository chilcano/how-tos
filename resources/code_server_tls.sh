#!/bin/bash

echo "+--------------------------------------------------------+"
echo "¦             Exposing VSCode Server over TLS            ¦"
echo "+--------------------------------------------------------+"

NOW1=$(date +"%y%m%d.%H%M%S")

#cat <<EOF > Caddyfile
#:443

#reverse_proxy 127.0.0.1:8001
#EOF
#sudo chown -R root:root Caddyfile
#sudo mv /etc/caddy/Caddyfile "/etc/caddy/Caddyfile.${NOW1}" 
#sudo mv Caddyfile /etc/caddy/Caddyfile
#sudo systemctl reload caddy

curl localhost:2019/load \
	-X POST \
	-H "Content-Type: application/json" \
	-d @/home/pi/gitrepos/how-tos/resources/caddy.json


# query the config
# curl localhost:2019/config/ | jq -C

printf ">> VSCode Server is running over TLS. \n"
