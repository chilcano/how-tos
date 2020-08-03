#!/bin/bash

echo "+--------------------------------------------------------+"
echo "¦      Exposing VSCode Server over TLS with Caddy        ¦"
echo "+--------------------------------------------------------+"

NOW1=$(date +"%y%m%d.%H%M%S")


## ------------------ install caddy

#echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" | sudo tee -a /etc/apt/sources.list.d/caddy-fury.list
#sudo apt update
#sudo apt install -y caddy
# ...
#Unpacking caddy (2.1.1) ...
#Setting up caddy (2.1.1) ...
#Created symlink /etc/systemd/system/multi-user.target.wants/caddy.service → /lib/systemd/system/caddy.service.
#System has not been booted with systemd as init system (PID 1). Can't operate.
#Failed to connect to bus: Host is down
#System has not been booted with systemd as init system (PID 1). Can't operate.
#Failed to connect to bus: Host is down


## --------------- backup Caddyfile
#sudo chown -R root:root Caddyfile
#sudo mv /etc/caddy/Caddyfile "/etc/caddy/Caddyfile.${NOW1}" 
## copy Caddyfile
#sudo mv Caddyfile /etc/caddy/Caddyfile

# ---------------- this cmd will not work in WSL
#sudo systemctl reload caddy

### -------------- will work in WSL
#caddy reverse-proxy --from :8443 --to 127.0.0.1:8080

#2020/07/13 18:30:06.124 WARN    admin   admin endpoint disabled
#2020/07/13 20:30:06 [INFO][cache:0xc0002012c0] Started certificate maintenance routine
#2020/07/13 18:30:06.130 INFO    tls     cleaned up storage units
#2020/07/13 18:30:06.131 INFO    autosaved config        {"file": "/home/rogerc/.config/caddy/autosave.json"}
#Caddy proxying http://:8443 -> http://127.0.0.1:8080



## ------------------ load caddy.json from cmd, also works in WSL
sudo caddy start
curl localhost:2019/load -X POST -H "Content-Type: application/json" -d @/home/rogerc/gitrepos/how-tos/resources/caddy.json
#curl localhost:2019/load -X POST -H "Content-Type: application/json" -d @/home/pi/gitrepos/how-tos/resources/caddy.json
caddy reverse-proxy --from :8443 --to 127.0.0.1:8080

# ------------------ query the config loaded
# curl localhost:2019/config/ | jq -C

printf ">> VSCode Server is running over TLS. \n"


## Certs created by Caddy

#$ sudo ls -la /var/lib/caddy/.local/share/caddy/pki/authorities/local
#total 24
#drwx------ 2 caddy caddy 4096 Jun 23 18:31 .
#drwx------ 3 caddy caddy 4096 Jun 23 18:31 ..
#-rw------- 1 caddy caddy  680 Jul  1 10:42 intermediate.crt
#-rw------- 1 caddy caddy  227 Jul  1 10:42 intermediate.key
#-rw------- 1 caddy caddy  627 Jun 23 18:31 root.crt
#-rw------- 1 caddy caddy  227 Jun 23 18:31 root.key