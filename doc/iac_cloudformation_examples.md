# IaC CloudFormation Examples

## Guides

1. Convert JSON to YAML.  

```sh
ruby -ryaml -rjson -e 'puts YAML.dump(JSON.load(ARGF))' < cloudformation_template_example.json > cloudformation_template_example.yaml
```

2. [Creating an Affordable Remote DevOps Desktop with AWS CloudFormation](https://github.com/chilcano/affordable-remote-desktop/tree/main/resources/cloudformation)

3. [Deploying AWS ECS Networking and Architecture Patterns](https://github.com/chilcano/cfn-samples/tree/master/ECS/README.md)