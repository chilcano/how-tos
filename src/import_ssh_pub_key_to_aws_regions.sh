#!/bin/bash

## requires export AWS_PROFILE=es
## source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/import_ssh_pub_key_to_aws_regions.sh) 

SSH_KEY_NAME="tmpkey"
PROFILE_PARAM=""

# Remove generated previous ssh keys under HOME
rm -rf ${HOME}/.ssh/${SSH_KEY_NAME}*

# Generate new ssh key pair
ssh-keygen -b 2048 -f ${HOME}/.ssh/${SSH_KEY_NAME} -t rsa -q -N ""
SSH_PUB_KEY="${HOME}/.ssh/${SSH_KEY_NAME}.pub"
chmod 0600 ${HOME}/.ssh/${SSH_KEY_NAME}.pub

# Get list of configured profiles
# AWS CLI v2.x is needed
ALL_AWS_PROFILES="$(aws configure list-profiles)"
echo "=> AWS Named Profiles found: ${ALL_AWS_PROFILES}"

for profile in ${ALL_AWS_PROFILES}; do
  echo "=> Using '${profile}' AWS Named Profile."
  PROFILE_PARAM="--profile ${profile}"
  # Get all regions
  ALL_AWS_REGIONS="$(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text ${PROFILE_PARAM})"

  # Make sure to remove blank space after '\'
  for region in ${ALL_AWS_REGIONS}; do
    # Removing previous imported ssh pub keys
    echo "--> Deleting imported SSH Pub Key in '$region' region."
    aws ec2 delete-key-pair \
      --key-name ${SSH_KEY_NAME} \
      --region $region \
      ${PROFILE_PARAM}

    echo "--> Importing SSH Pub Key in '$region' region."
    # Importing new generated ssh pub keys
    aws ec2 import-key-pair \
      --key-name ${SSH_KEY_NAME} \
      --public-key-material fileb://${SSH_PUB_KEY} \
      --region $region \
      ${PROFILE_PARAM}
  done
done

echo "=> SSH Pub Key was imported successfully to all AWS Regions in all AWS Profiles configured."
echo "=> Now, you can use this command to get remote access:"
echo "   ssh ubuntu@\$(terraform output -json node_ips | jq -r '.[0]') -i ~/.ssh/${SSH_KEY_NAME}"
echo "   ssh ubuntu@\$(terraform output node_fqdn) -i ~/.ssh/${SSH_KEY_NAME}"
