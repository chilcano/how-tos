# Generate and import SSH Pub Key to all AWS Regions


In order to execute this script, you should set the AWS credentials as System Environment Variables.
```sh
source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/import_ssh_pub_key_to_aws_regions.sh)
```

But if you don't want expose these credentials as System Environment Variables, and if you already have configured the [AWS Named Profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html), then before execute the bash script selecting the predetermined profile.
```sh
export AWS_PROFILE=es

source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/import_ssh_pub_key_to_aws_regions.sh)
```

