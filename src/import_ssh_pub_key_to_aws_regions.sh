#!/bin/bash

## export AWS_PROFILE=es
## AWS_ACCESS_KEY_ID
## AWS_SECRET_ACCESS_KEY
## AWS_DEFAULT_REGION
## source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/master/src/import_ssh_pub_key_to_aws_regions.sh) 

SSH_KEY_NAME="tmpkey"

if [ -z ${AWS_PROFILE+x} ]; then 
  echo "=> AWS_PROFILE is unset" 
  if [ -z ${AWS_ACCESS_KEY_ID+x} || -z ${AWS_SECRET_ACCESS_KEY+x} || -z ${AWS_DEFAULT_REGION+x} ]; then 
    echo "=> AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY or AWS_DEFAULT_REGION are unset." 
    # It will use all aws profiles
    # AWS CLI v2.x is needed
    AWS_PROFILES="$(aws configure list-profiles)"
    gen_and_upload_ssh_keys_by_profile
  else 
    echo "=> AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY or AWS_DEFAULT_REGION have been defined."
    # It will use the defined AWS_XYZ env vars
    gen_and_upload_ssh_keys_by_envvars
  fi
else 
  echo "=> AWS_PROFILE is set to '$AWS_PROFILE'"
  # It will use the AWS_PROFILE env var
  AWS_PROFILES="${AWS_PROFILE}"
  gen_and_upload_ssh_keys_by_profile
fi

#####################################################

gen_and_upload_ssh_keys_by_profile(){
  PROFILE_PARAM=""
  # Remove generated previous ssh keys under HOME
  rm -rf ${HOME}/.ssh/${SSH_KEY_NAME}*

  # Generate new ssh key pair
  ssh-keygen -b 2048 -f ${HOME}/.ssh/${SSH_KEY_NAME} -t rsa -q -N ""
  SSH_PUB_KEY="${HOME}/.ssh/${SSH_KEY_NAME}.pub"
  chmod 0600 ${HOME}/.ssh/${SSH_KEY_NAME}.pub

  # AWS Profiles to be used
  echo "=> AWS Named Profiles to be used: ${AWS_PROFILES}" | tr '\n' ' ' 

  for profile in ${AWS_PROFILES}; do
    printf "\n"
    echo "=> Using '${profile}' AWS Named Profile."
    printf "\n"
    PROFILE_PARAM="--profile ${profile}"
    # Get all regions
    ALL_AWS_REGIONS="$(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text ${PROFILE_PARAM})"

    # Make sure to remove blank space after '\'
    for region in ${ALL_AWS_REGIONS}; do
      # Removing previous imported ssh pub keys
      echo " --> Deleting imported SSH Pub Key in '$region' region."
      aws ec2 delete-key-pair \
        --key-name ${SSH_KEY_NAME} \
        --region $region \
        ${PROFILE_PARAM}

      echo " --> Importing SSH Pub Key in '$region' region."
      # Importing new generated ssh pub keys
      aws ec2 import-key-pair \
        --key-name ${SSH_KEY_NAME} \
        --public-key-material fileb://${SSH_PUB_KEY} \
        --region $region \
        --output text \
        ${PROFILE_PARAM}
    done
  done

  printf "\n"
  echo "=> SSH Pub Key was imported successfully to all AWS Regions in all AWS Profiles configured."
  echo "=> Now, you can use this command to get remote access:"
  echo "   ssh ubuntu@\$(terraform output -json node_ips | jq -r '.[0]') -i ~/.ssh/${SSH_KEY_NAME}"
  echo "   ssh ubuntu@\$(terraform output node_fqdn) -i ~/.ssh/${SSH_KEY_NAME}"  
}

#####################################################

gen_and_upload_ssh_keys_by_envvars(){
  # Remove generated previous ssh keys under HOME
  rm -rf ${HOME}/.ssh/${SSH_KEY_NAME}*

  # Generate new ssh key pair
  ssh-keygen -b 2048 -f ${HOME}/.ssh/${SSH_KEY_NAME} -t rsa -q -N ""
  SSH_PUB_KEY="${HOME}/.ssh/${SSH_KEY_NAME}.pub"
  chmod 0600 ${HOME}/.ssh/${SSH_KEY_NAME}.pub

  # Make sure to remove blank space after '\'
  for region in ${ALL_AWS_REGIONS}; do
    # Removing previous imported ssh pub keys
    echo " --> Deleting imported SSH Pub Key in '$region' region."
    aws ec2 delete-key-pair \
      --key-name ${SSH_KEY_NAME} \
      --region $region

    echo " --> Importing SSH Pub Key in '$region' region."
    # Importing new generated ssh pub keys
    aws ec2 import-key-pair \
      --key-name ${SSH_KEY_NAME} \
      --public-key-material fileb://${SSH_PUB_KEY} \
      --region $region \
      --output text
  done

  printf "\n"
  echo "=> SSH Pub Key was imported successfully to all AWS Regions in all AWS Profiles configured."
  echo "=> Now, you can use this command to get remote access:"
  echo "   ssh ubuntu@\$(terraform output -json node_ips | jq -r '.[0]') -i ~/.ssh/${SSH_KEY_NAME}"
  echo "   ssh ubuntu@\$(terraform output node_fqdn) -i ~/.ssh/${SSH_KEY_NAME}"  
}
