# Sealed Secrets in Google Kubernetes Engine

## Requeriments

1. `gcloud` CLI - https://cloud.google.com/sdk/docs/install
2. `kubectl` CLI - https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl
3. Bitnami Sealed Secrets Controller and `kubeseal` CLI - https://github.com/bitnami-labs/sealed-secrets#linux
4. A Kubernetes cluster already working in Google Cloud. If you don't have one, all part related to create a secret and sealing are the same.

## Steps

### 1. Install gcloud

```sh
$ sudo apt-get -y install apt-transport-https ca-certificates gnupg
$ echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
$curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

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
$ sudo apt-get install -y kubectl

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

The `kubectl` and other Kubernetes clients require be authenticated against Google Cloud and they can be installed through `gcloud` CLI or using `apt-get`.
```sh
$ gcloud components install gke-gcloud-auth-plugin     ## this cmd didn't work in Ubuntu 22.04

$ sudo apt-get -y install google-cloud-sdk-gke-gcloud-auth-plugin
$ gke-gcloud-auth-plugin --version

Kubernetes v1.25.2-alpha+ae91c1fc0c443c464a4c878ffa2a4544483c6d1f
```

__Setting a GKE configuration__

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
```
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
```
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

Connecting with `k9s`.

```sh
$ k9s --context gke_aragon_devops
$ k9s --context gke_aragon_stg
$ k9s --context gke_aragon_prods

```



### 3. Install kubeseal

```
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/<release-tag>/kubeseal-<version>-linux-amd64.tar.gz
tar -xvzf kubeseal-<version>-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal

wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.19.3/kubeseal-0.19.3-linux-amd64.tar.gz
tar -xvzf kubeseal-0.19.3-linux-amd64.tar.gz 
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
```

### 4. Create a secret in yaml format


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

$ echo bXlzZWNyZXRpbnBsYWludGV4dA== | base64 --decode
mysecretinplaintext
```

The `-n` flag means `remove break line`.

__Important:__ 
* Once generated a secret yaml file, you _must_ to update the file with all `annotations` under `metadata`, `namespace` and the name of the key under `data`.
* Once updated, when sealing with `kubeseal` the generated sealed secret yaml file only will be able to be deployed successfully in the already specified `namespace` using the original `annotations` and key name in `data`. Then, make sure using the right values while editing the secret, because once sealed, the sealed secret only will be able unsealed if these values have not been changed.


### 5. Create a yaml sealed-secret

```
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
