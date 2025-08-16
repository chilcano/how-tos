# helm-apim
This repo will be used to maintain APIM related helm charts

## Prerequisites

- WSO2 Product Docker images required for the deployment.  - It is recommended to push your own images to the cloud provider's container registry (ACR, ECR, etc.) as a best practice. Refer [U2 documentation](https://updates.docs.wso2.com/en/latest/updates/how-to-use-docker-images-to-receive-updates/) for any additional information. 
    
    Note that you need a valid WSO2 subscription to obtain the U2 updated docker images from the WSO2 private registry.

- A running Kubernetes cluster (AKS, EKS, etc.)

- Ingress controller for routing traffic. The recommendation is to use [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/) suitable for your cloud environment. Some sample annotations that could be used with the ingress resources are as follows.

  > The ingress class should be set to `nginx` in the ingress resource if you are using the NGINX Ingress Controller.

  ```
  nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
  nginx.ingress.kubernetes.io/affinity: "cookie"
  nginx.ingress.kubernetes.io/session-cookie-name: "route"
  nginx.ingress.kubernetes.io/session-cookie-hash: "sha1"
  nginx.ingress.kubernetes.io/proxy-buffering: "on"
  nginx.ingress.kubernetes.io/proxy-buffer-size: "8k"
  ```

  However, if you are deploying the charts in AWS, you can use the [AWS ALB Ingress Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main) as well. If you are using ACM to manage the certificates, using this controller over the nginx ingress controller would be more convenient.

  > Note that the current tested version of the controller is 2.6.x.
  
  > The ingress class should be set to `alb` in the ingress resource if you are using the AWS ALB Ingress Controller.

  If the controller is not already available in your cluster, you can [configure the relevent IAM service account](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.6/deploy/installation/#configure-iam) and [deploy the controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.6/deploy/installation/#add-controller-to-cluster) in the cluster by following the instructions in the respective documentation.

  You need the following annotations for ingress resources if you are using the AWS ALB Ingress Controller.

  ```
  alb.ingress.kubernetes.io/group.name: <group_name>
  alb.ingress.kubernetes.io/scheme: internet-facing
  alb.ingress.kubernetes.io/target-type: ip
  alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
  alb.ingress.kubernetes.io/certificate-arn: <CERTIFICATE_ARN>
  alb.ingress.kubernetes.io/backend-protocol: HTTPS
  ```

  If the `group.name` annotation is not used, multiple loadbalancers will be created for each ingress resource. Furthermore, if the `certificate-arn` is not specified, the controller will look for available certificated in ACM based on the Common Name (CN) of the certificate. Additionally, including health-check related annotation might be useful to avoid any issues with the product throwing errors due to random probles.

  ```
  alb.ingress.kubernetes.io/healthcheck-protocol: 'HTTPS'
  alb.ingress.kubernetes.io/healthcheck-port: '9443'
  alb.ingress.kubernetes.io/healthcheck-path: /services/Version
  alb.ingress.kubernetes.io/healthcheck-interval-seconds: '10'
  alb.ingress.kubernetes.io/healthcheck-timeout-seconds: '5'
  alb.ingress.kubernetes.io/success-codes: '200'
  alb.ingress.kubernetes.io/healthy-threshold-count: '2'
  alb.ingress.kubernetes.io/unhealthy-threshold-count: '2'
  ```

  Please refer the [documentation](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.6/guide/ingress/annotations/) to get more information on these annotations and other annotations that might be useful.

- If you are enabling secure vault configurations for the product, you need to configure the secret manager service of the respective cloud provider. Since the secrets are encrypted using the internal keystore password, that password should be included in the key vault so that it can be resolved using a CSI driver when the helm charts are deployed.

    For AWS, you need to deploy the `secrets-store-csi-driver-provider` and create the necessary IAM policies, OIDC providers, and IAM service accounts. Please refer the [documentation](https://github.com/aws/secrets-store-csi-driver-provider-aws) for more information and steps to follow.

- If you are enabling solr indexing in your setup, you need to mount the carbon database and solr indexed data to a persistent storage location.

    For AWS, the recommended solution would be EFS. To connect your cluster with EFS, you need to setup the `aws-efs-cs--driver` in your cluster. Refer to the [documentation](https://github.com/kubernetes-sigs/aws-efs-csi-driver/tree/master) to setup the driver and set necessary permissions (policy) to the IAM service account. Make sure that you have created the necessary access points in EFS with the required user permissions. The UIDs should match those of the user inside the container.

- Make sure the RDS is up and running. You need to create the relevant databases in the RDS system before deploying the chart. Also, it is recommended to include the database JDBC driver in your Docker image so that APIM can connect to the databases without any issues. If you are not adding the driver to the image itself, you might have to modify the helm charts and mount the driver to the deplyoments.

## Sample Configurations

The helm charts inlude cloud provider specific blocks. The parameters in those blocks can be used to configure services that are specific for each cloud provider.

```yaml
aws:
  enabled: true
  efs:
    capacity: "50Gi"
    directoryPerms: "0777"
    fileSystemId: "fs-12345678"
    accessPoints:
        carbonDb: "fsap-12345678"
        solr: "fsap-12345678"
  region: ""
  secretsManager:
    secretProviderClass: "wso2am-am-secret-provider-class"
    secretIdentifiers:
      internalKeystorePassword:
        secretName: "<secret_name>"
        secretKey: "<secret_key>"
  serviceAccountName: ""
```

For example, if the enabled attribute is set to true under aws, then it is assumed that the helm charts will be deployed in EKS and will be using other AWS services. Refer the [README](all-in-one/README.md) of the charts to get more information on the parameters.