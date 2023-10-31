# Kubernetes Ops guide


Tags:
- k8s
- k9s

## K9s

* Ref: https://k9scli.io/topics/commands/

```sh
sudo snap install k9s
sudo snap remove k9s
curl -sS https://webinstall.dev/k9s | bash
```

* Info: https://github.com/derailed/k9s

### 1. Connect to K8s
```sh
k9s --context coolCtx
```

```sh
$ k9s --context aragon_devops_gke
$ k9s --context aragon_stg_gke
$ k9s --context aragon_prod_gke
$ k9s --context aragon_hetzner
```

### 2. k9s commands

- `/`: xxx
- `?`: list of keys

## Connect to a POD

### 1. From Google Cloud Shell

```sh
$ gcloud container clusters get-credentials aragon-prod --zone europe-west6-a --project aragon-prod \
>  && kubectl exec be-ipfs-db-cache-prod-7575cc7b88-2m9k5 --namespace be-ipfs-db-cache -c be-ipfs-db-cache-prod -- ls
```

### 2. From local Terminal






## -----------------------------------------------

```yaml
el:
  image:
    repository: nethermind/nethermind
    tag: 1.19.3

cl:
  image:
    repository: sigp/lighthouse
    tag: v4.2.0
```

```sh
argocd-image-updater.argoproj.io/consensus.helm.image-tag = cl.image.tag
argocd-image-updater.argoproj.io/consensus.update-strategy = semver
argocd-image-updater.argoproj.io/execution.helm.image-tag = el.image.tag
argocd-image-updater.argoproj.io/execution.update-strategy = semver

argocd-image-updater.argoproj.io/image-list = execution=nethermind/nethermind:1.x, consensus=sigp/lighthouse:v4.x
argocd-image-updater.argoproj.io/image-list = execution=nethermind/nethermind:1.19.x, consensus=sigp/lighthouse:v4.2.x

```


## Monitoring through ELK

* URL: https://kibana-monitoring.aragon.org/app/logs/stream
* Queries: 
  - kubernetes.labels.app_kubernetes_io/name : "gnosischain-node"
  - kubernetes.labels.aragon_org/node-layer-type : "execution" 

  In order to prepare queries, we need to know the `matchLabels` configured in the `kind: Deployment`.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/instance: gnosischain-xdai
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: gnosischain-node
    helm.sh/chart: gnosischain-node-1.0.0
  name: gnosischain-consensus
  namespace: gnosischain-xdai
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/instance: gnosischain-xdai
      app.kubernetes.io/name: gnosischain-node
      aragon.org/node-layer-cli: lighthouse
      aragon.org/node-layer-net: gnosis
      aragon.org/node-layer-type: consensus
  strategy:
...
```