# Sealed Secrets with Bitnami Sealed Secrets Controller

## Requeriments

1. `gcloud` CLI (only for Google Kubernetes Engine) - https://cloud.google.com/sdk/docs/install
2. `kubectl` CLI:
  - Installation: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
  - Config to access to GKE: https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl
3. Bitnami Sealed Secrets Controller and `kubeseal` CLI - https://github.com/bitnami-labs/sealed-secrets#linux
4. A Kubernetes cluster already working in Google Cloud. If you don't have one, all part related to create a secret and sealing are the same.

## Steps

### 1. Install gcloud

```sh
$ sudo apt-get -y install apt-transport-https ca-certificates gnupg
$ echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
$ curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

$ sudo apt-get -y update && sudo apt-get -y install google-cloud-cli

$ gcloud version

Google Cloud SDK 413.0.0
alpha 2023.01.06
beta 2023.01.06
bq 2.0.84
bundled-python3-unix 3.9.12
core 2023.01.06
gcloud-crc32c 1.0.0
gsutil 5.17
```

### 2. Install kubectl

```sh
$ sudo apt-get -y install apt-transport-https ca-certificates curl
$ curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
$ echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
$ sudo apt-get -y update

$ sudo apt-get -y install kubectl

$ kubectl version --client -o yaml

clientVersion:
  buildDate: "2022-12-08T19:58:30Z"
  compiler: gc
  gitCommit: b46a3f887ca979b1a5d14fd39cb1af43e7e5d12d
  gitTreeState: clean
  gitVersion: v1.26.0
  goVersion: go1.19.4
  major: "1"
  minor: "26"
  platform: linux/amd64
kustomizeVersion: v4.5.7
```

### 3. Connecting to Kubernetes (GKE)

> All steps in this **Section 3** only are needed if you want stablish connection to existing Kubernetes Cluster through Google Cloud CLI.
> Once configured and you are able to use `kubectl` to connect to your K8s instance, then you will have a proper `kubeconfig` file already created automatically in your home directory.
> This `kubeconfig` file is the only thing you need to use `kubeseal`.


__Installing Google Cloud Authentication Plugin__

The `kubectl` and other Kubernetes clients require be authenticated against Google Cloud and they can be installed through `gcloud` CLI or using `apt-get`.
```sh
$ gcloud components install gke-gcloud-auth-plugin     ## this cmd didn't work in Ubuntu 22.04

$ sudo apt-get -y install google-cloud-sdk-gke-gcloud-auth-plugin

$ gke-gcloud-auth-plugin --version

Kubernetes v1.25.2-alpha+ae91c1fc0c443c464a4c878ffa2a4544483c6d1f
```

__Login__


Before running any `gcloud` CLI command, you should be authenticated using proper Google credentials, in this case I'll use my emails address, not a google system account:
```sh
$ gcloud auth login

Your browser has been opened to visit:

    https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=32555940.............256


You are now logged in as [roger...@my-domain.info].
Your current project is [None].  You can change this setting by running:
  $ gcloud config set project PROJECT_ID
```

__Connect to existing GKE cluster__

Once authenticated successfully, fetch the Kubernetes Cluster configuration using this command `gcloud container clusters get-credentials CLUSTER_NAME --region=COMPUTE_REGION|--zone=COMPUTE_ZONE --project=PROJECT_ID`:

```sh
$ gcloud container clusters get-credentials aragon-devops --zone europe-west6-a --project aragon-devops-319312
$ gcloud container clusters get-credentials aragon-staging --zone europe-west6-a --project aragon-staging
$ gcloud container clusters get-credentials aragon-prod --zone europe-west6-a --project aragon-prod
```

Now, you will be able to view the `kubeconfig` and the current context and so on:
```sh
$ kubectl config view
$ cat ~/.kube/config
$ kubectl config current-context
$ kubectl config get-context
$ kubectl cluster-info
```

If you execute any `kubectl` command, this will use the default context of last `gcloud container clusters get-credentials <CLUSTER_NAME>` command. For example, next command will show all namespaces in the `aragon-prod` cluster:
```sh
$ kubectl get namespaces
```

__Setup a new connection to GKE cluster (optional)__

We are going to follow this guide [https://cloud.google.com/sdk/docs/configurations](https://cloud.google.com/sdk/docs/configurations) and you should have a proper credentials (email address) and the right permissions to install a Kubernetes Controller. 
In this case I'm going to use as example this email address `chilcano@holisticsecurity.io`.

```sh
$ gcloud config configurations create ara-prod

$ gcloud config configurations list
NAME      IS_ACTIVE  ACCOUNT                       PROJECT      COMPUTE_DEFAULT_ZONE  COMPUTE_DEFAULT_REGION
ara-prod  True
ara-stg   False
default   False      chilcano@holisticsecurity.io  aragon-prod

$ gcloud config set project aragon-prod
Updated property [core/project].

$ gcloud auth login
// or
$ gcloud config set account chilcano@holisticsecurity.io
Updated property [core/account].

$ gcloud config set compute/zone europe-west6-a 
Updated property [compute/zone].

$ gcloud config set compute/region europe-west6
Updated property [compute/region].

// List active config/project
$ gcloud config list

[compute]
region = europe-west6
zone = europe-west6-a
[core]
account = chilcano@holisticsecurity.io
disable_usage_reporting = True
project = aragon-prod
```


Fetch the credentials for the cluster:
```sh
$ gcloud container clusters get-credentials aragon-prod
Fetching cluster endpoint and auth data.
kubeconfig entry generated for aragon-prod.

$ kubectl get namespaces
NAME                     STATUS   AGE
blind-csp                Active   263d
blind-sms-csp            Active   183d
...
vocdoni-external-dns     Active   409d
```

Swithching, updating to other configuration and fetching kubectl config:
```sh
$ gcloud config configurations activate <project>
$ gcloud config set project aragon-staging
$ gcloud config set compute/zone europe-west6-a 
$ gcloud config set compute/region europe-west6

$ gcloud container clusters get-credentials aragon-staging
$ kubectl get namespaces
```

__Note__

A quick way to configure your connection to GKE is copying the connection configuration details from GKE. You should have a valid user and be authenticated.

Example: https://www.bitpoke.io/docs/app-for-wordpress/basic-usage/connect-to-cluster-and-access-k8s-pods/

```sh
$ gcloud container clusters get-credentials aragon-devops --zone europe-west6-a --project aragon-devops-319312
```
Once fetched the config, you will be able to run `kubectl`
```sh
$ kubectl get nodes
NAME                                            STATUS   ROLES    AGE   VERSION
gke-aragon-devops-n2-standard-2f168a49-02ih     Ready    <none>   18d   v1.24.9-gke.3200
gke-aragon-devops-n2-standard-2f168a49-qubg     Ready    <none>   18d   v1.24.9-gke.3200
gke-aragon-devops-smaller-nodes-63cd004d-4iaw   Ready    <none>   18d   v1.24.9-gke.3200
gke-aragon-devops-smaller-nodes-63cd004d-zgjm   Ready    <none>   18d   v1.24.9-gke.3200
```
Finally, check the kubeconfig generated in your local computer. You should view all cluster config you already connected to.
As well, you can rename contexts, users, etc.

```sh
$ kubectl config view
```


__Connecting with `k9s`__

```sh
$ k9s --context aragon_devops_gke
$ k9s --context aragon_stg_gke
$ k9s --context aragon_prod_gke
$ k9s --context aragon_hetzner
```

### 4. Install kubeseal

```sh
# Get last version and remove first character to have the semver value. i.e. 0.24.2
$ KUBESEAL_VERSION=$(curl -s https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest | jq -r -M '.tag_name' | cut -c 2-)
$ wget "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION:?}/kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz"
$ tar -xvzf kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz kubeseal
$ sudo install -m 755 kubeseal /usr/local/bin/kubeseal

# Get version installed
$ kubeseal --version

kubeseal version: 0.24.2
```

### 5. Create a secret in yaml format

We are going to create a secret in yaml format.

* `bar` is the secret value in plain text
* `YmFy` is the secret value encoded in base64 
* `foo` is the secret key name
* `mysecret` is the secret name what K8s will use
* `mynamespace` is namespace that will contain the secret
* Use `-o json` if you want generate a json file instead of yaml.

```sh
$ echo -n bar | kubectl create secret generic mysecret -n mynamespace --dry-run=client --from-file=foo=/dev/stdin -o yaml > mysecret.yaml

$ cat mysecret.yaml 
```
```yaml
apiVersion: v1
data:
  foo: YmFy
kind: Secret
metadata:
  creationTimestamp: null
  name: mysecret
  namespace: mynamespace 
```

You are able to create a secret manifest file using your favorite text editor, if so, you could edit the entire yaml file from the editor and update only the secret with the base64 encoded value. 
In Linux generate you can encode and decode in base64 using these commands:

```sh
$ echo -n mysecretinplaintext | base64
bXlzZWNyZXRpbnBsYWludGV4dA==

$ echo bXlzZWNyZXRpbnBsYWludGV4dA== | base64 --decode
mysecretinplaintext

$ echo -n "generating longer super secret encoded in base64 in only one line" | base64 -w 0
Z2VuZXJhdGluZyBsb25nZXIgc3VwZXIgc2VjcmV0IGVuY29kZWQgaW4gYmFzZTY0IGluIG9ubHkgb25lIGxpbmU=
```

The `-n` flag means `remove break line` and `-w 0` generate the base64 string in one single line. 

__Important:__ 
* Once generated a secret yaml file, you _must_ to update the file with all `annotations` under `metadata`, `namespace` and the name of the key under `data`.
* Once updated, when sealing with `kubeseal` the generated sealed secret yaml file only will be able to be deployed successfully in the already specified `namespace` using the original `annotations` and key name in `data`. Then, make sure using the right values while editing the secret, because once sealed, the sealed secret only will be able unsealed if these values have not been changed.


### 6. Create a yaml sealed-secret

```sh
$ kubeseal <mysecret.yaml >mysealedsecret.yaml

error: invalid configuration: no configuration has been provided, try setting KUBERNETES_MASTER environment variable
```

Once configured the K8s cluster to avoid the above error, run again the command:
```sh
$ kubeseal <mysecret.yaml -o yaml >mysealedsecret.yaml

$ cat mysealedsecret.yaml 
```
```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  creationTimestamp: null
  name: mysecret
  namespace: default
spec:
  encryptedData:
    foo: AgBb6dF9UUfkMXgesX9yTzgCH8it90Z........gzU=
  template:
    metadata:
      creationTimestamp: null
      name: mysecret
      namespace: default
```

### 7. Create a yaml sealed-secret in automated way

I've created a script that seal your K8s secret file using any K8s context available in your `kubeconfig` file.

__The seal_k8s_secrets.sh bash script__

```sh
#!/bin/bash

if [ $# -eq 2 ]; then
  arg_ctx="$1"
  arg_secfile="$2"
  sealed_secfile="${arg_secfile%.*}-sealed.yaml"

  ctx_values=$(kubectl config get-contexts --no-headers | grep $arg_ctx | awk {'print $1"*"$2'})
  if [[ "$ctx_values" != "" ]]; then
    if [[ -f "${arg_secfile}" ]]; then
      IFS="*"
      read -ra ctx_items <<<"$ctx_values"
      printf "> K8s context found: ${ctx_items[0]}\n"
      seal_cmd="kubeseal --context ${ctx_items[0]} --scope cluster-wide --format=yaml"
      eval "${seal_cmd} < ${arg_secfile} > ${sealed_secfile}"
      printf "> K8s sealed secret file created: ${sealed_secfile} \n\n"
      exit 0
    else
      printf "> Error: K8s secret file not found: '${arg_secfile}' \n\n"
      exit 1      
    fi
  else
    printf "> Error: K8s context not found: '${arg_ctx}' \n\n"
    exit 1
  fi 
else
  printf "> Error: Two arguments are needed.\n"
  printf "\tseal_k8s_secrets.sh <devops|staging|prod> <SecretFile>\n\n"
  exit 1
fi
```

__Using the seal_k8s_secrets.sh bash script__

We are going to seal this K8s secret file that contains a base64 encoded secret:
```sh
$ echo -n "generating longer super secret encoded in base64 in only one line" | base64 -w 0
Z2VuZXJhdGluZyBsb25nZXIgc3VwZXIgc2VjcmV0IGVuY29kZWQgaW4gYmFzZTY0IGluIG9ubHkgb25lIGxpbmU=
```

The K8s secret file is `myk8ssecret.yaml` and contains:
```yaml
apiVersion: v1
data:
  key-longer-secret: Z2VuZXJhdGluZyBsb25nZXIgc3VwZXIgc2VjcmV0IGVuY29kZWQgaW4gYmFzZTY0IGluIG9ubHkgb25lIGxpbmU=
kind: Secret
metadata:
  creationTimestamp: null
  name: mysecret
  namespace: mynamespace 
```

Checking the available K8s contexts configured:
```sh
$ kubectl config get-contexts --no-headers | awk {'print $1" - "$2'}

aragon_devops_gke - gke_aragon-devops-319312_europe-west6-a_aragon-devops
aragon_prod_gke - gke_aragon-prod_europe-west6-a_aragon-prod
aragon_stg_gke - gke_aragon-staging_europe-west6-a_aragon-staging
```

Now we are going to seal using the `devops` K8s cluster:
```sh
$ ./seal_k8s_secrets.sh devops myk8ssecret.yaml 

> K8s context found: aragon_devops_gke
> K8s sealed secret file created: myk8ssecret-sealed.yaml 
```

And finally, we have a sealed secret file in `myk8ssecret-sealed.yaml`:

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  annotations:
    sealedsecrets.bitnami.com/cluster-wide: "true"
  creationTimestamp: null
  name: mysecret
  namespace: mynamespace
spec:
  encryptedData:
    key-longer-secret: AgB0MBWCL2fVxgug1YpcA5m7Ual7eY/zwmKcsNT2epMCUl8xcwjq2sBx9sovF6MRaFhlKFOBR4URnUdVfCDZNm/l/p1O/nVb8E1Rbs01NhRWmYDCCI2RpKmIpuro2J+78KB97YOoMbuozH1BRbPY9a2R9MJYj3NweEa7q7rEGua4Fci1TGECt2/L+wbLnDiy2pgBJEd0Z7ljdFU3Py2wpcFIxPeqdHfACDZHzpu6zCh0HqiRJ8ejgHNh6Lg9qV4h+qLC2F/vw631ALgc06AiL0w2y225NbqdJhG87isE4Cxt5kbOD7ZRNL3uwi/B5j5rblU+rgTQGp6xD2FDc7HW+b38eNH+7tBu90LetUosLQMbhukuyH+/d1whMEkg0JG4z70ky/mWX96z51cmMezS+dvv3baxNUo8cFLEk1NFnD4dt9fFU/RUHeqMqHZiClrUevSnrldxRVwFFKstJvLFQBsyEpX3l0tY1T9A02LleHZ+2IOD/sV9eChh7HYHvmSAYi1t1qXXmbaJew/OecEW4lJks9ny0O2AAKMwkBk7H/jyD4WjLvBJEztQojMQ48egDn+3DN4IDIDUUld8WWRMUx9+6agx6gJydbV4zC4c4GyIQCecbkrxY97xkDYoTT3NMZZB7fhxWe6quta1sFfO+RuKE+6S46QZYSt6U8hsLPA3qkYlCW9wmxtps6Eo97vfQK+x5OApU4RRDIgb7jcurR6Mn+8qLTzikjwT/j7hJSZeNKdHtpMGsjwld9fNuin3OqKc8ltkqJAa5DEEcTFEvzdxUQ==
  template:
    metadata:
      annotations:
        sealedsecrets.bitnami.com/cluster-wide: "true"
      creationTimestamp: null
      name: mysecret
      namespace: mynamespace
```
