#!/bin/bash

# *** THIS SCRIPT MUST BE IN THE ROOT OF REPO ***

printf "\n"
echo "###############################################################"
echo "#                    Running Hugo locally                     #"
echo "###############################################################"

IP_ADDRESS_ETH0=$(ip a s eth0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2)

hugo server --source ghp-scripts --bind 0.0.0.0 --baseURL http://${IP_ADDRESS_ETH0}:1313/ -D -v
