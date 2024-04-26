#!/bin/bash

# *** THIS SCRIPT MUST BE IN THE ROOT OF REPO ***

function launch_hugo() {
    IP_ADDRESS=""
    IP_ADDRESS_ETH0=$(ip a s eth0)

    if [ $? -eq 0 ]; then
        # eth0 exist
        printf "Eth0 NIC exists. \n"
        IP_ADDRESS=$(ip a s eth0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2)
    else
        # eth0 doesn't exist
        printf "Eth0 NIC doesn't exist. Then, using 'hostname -I' to get list of IP addresses. \n"
        IP_LIST=$(hostname -I)
        # IP_LIST_ARRAY=($IP_LIST)              ## work only on bash
        IP_LIST_ARRAY=(`echo ${IP_LIST}`)       ## work on zsh and bash
        # IP_ADDRESS=${IP_LIST_ARRAY[0]}        ## work only on bash because index starts in 0 while zsh starts in 1
        IP_ADDRESS=${IP_LIST_ARRAY[@]:0:1}      ## works on zsh and bash because it iterates with items, not index
    fi
    printf "Launching Hugo locally. \n\n"
    hugo server --source ghp-scripts --bind 0.0.0.0 --baseURL http://${IP_ADDRESS}:1313/ -D --logLevel info
    return
}

printf "\n"
echo "###############################################################"
echo "#                    Running Hugo locally                     #"
echo "###############################################################"

launch_hugo
