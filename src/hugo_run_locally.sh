#!/bin/bash

# *** THIS SCRIPT MUST BE IN THE ROOT OF REPO ***

printf "\n"
echo "###############################################################"
echo "#                    Running Hugo locally                     #"
echo "###############################################################"

IP_ADDRESS=""
IP_ADDRESS_ETH0=$(ip a s eth0)

if [ $? == 0 ]; then
    # eth0 exist
    echo "Eth0 exist."
    IP_ADDRESS=$(ip a s eth0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2)
else
    # eth0 doesn't exist
    echo "Eth0 device doesn't exist. Using 'hostname -I'."
    IP_LIST=$(hostname -I)
    IP_LIST_ARRAY=($IP_LIST)
    IP_ADDRESS=${IP_LIST_ARRAY[0]}
fi

hugo server --source ghp-scripts --bind 0.0.0.0 --baseURL http://${IP_ADDRESS}:1313/ -D -v
