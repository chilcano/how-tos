#!/bin/bash

## source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/import_ssh_pub_key_to_aws_regions.sh)

ALL_AWS_REGIONS="$(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text)"
SSH_KEY_NAME="tmpkey"

# Remove generated previous ssh keys under HOME
rm -rf ${HOME}/.ssh/${SSH_KEY_NAME}*

# Generate new ssh key pair
ssh-keygen -b 2048 -f ${HOME}/.ssh/${SSH_KEY_NAME} -t rsa -q -N ""
SSH_PUB_KEY="${HOME}/.ssh/${SSH_KEY_NAME}.pub"
chmod 0600 ${HOME}/.ssh/${SSH_KEY_NAME}.pub

# Make sure to remove blank space after '\'
for region in ${ALL_AWS_REGIONS}; do
  # Removing previous imported ssh pub keys
  echo "--> Deleting imported SSH Pub Key in '$region' region."
  aws ec2 delete-key-pair \
    --key-name ${SSH_KEY_NAME} \
    --region $region 

  echo "--> Importing SSH Pub Key in '$region' region."
  # Importing new generated ssh pub keys
  aws ec2 import-key-pair \
    --key-name ${SSH_KEY_NAME} \
    --public-key-material fileb://${SSH_PUB_KEY} \
    --region $region
done

echo "--> SSH Pub Key was imported successfully to all AWS Regions."
echo "--> Now, you can use this command to get remote access:"
echo "-->   ssh ubuntu@\$(terraform output -json node_ips | jq -r '.[0]') -i ~/.ssh/${SSH_KEY_NAME}"
echo "-->   ssh ubuntu@\$(terraform output node_fqdn) -i ~/.ssh/${SSH_KEY_NAME}"
