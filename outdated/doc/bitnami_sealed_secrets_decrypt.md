# Decrypt Bitname Sealed Secrets

## Requeriments

1. `kubectl` CLI - https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl
2. Bitnami Sealed Secrets Controller and `kubeseal` CLI - https://github.com/bitnami-labs/sealed-secrets#linux
3. A Kubernetes cluster already working in Google Cloud. If you don't have one, all part related to create a secret and sealing are the same.

## Steps

- https://stackoverflow.com/questions/75812591/how-can-i-locally-decrypt-already-sealed-secrets
- https://github.com/bitnami-labs/sealed-secrets#will-you-still-be-able-to-decrypt-if-you-no-longer-have-access-to-your-cluster


### Step 01. Select the K8s context and check if exist sealed secrets

```sh
## list all k8s contexts
$ kubectl config get-contexts --no-headers                                            
      gke_ara_dops      gke_aragon-devops-319312_europe-west6-a_aragon-devops   gke_aragon-devops-319312_europe-west6-a_aragon-devops   
      gke_ara_prod      gke_aragon-prod_europe-west6-a_aragon-prod              gke_aragon-prod_europe-west6-a_aragon-prod              
      gke_ara_stg       gke_aragon-staging_europe-west6-a_aragon-staging        gke_aragon-staging_europe-west6-a_aragon-staging        
      hetzner_cp0_ara   hetzner-cp0                                             hetzner-usr                                             
*     hetzner_cp2_ara   hetzner-cp2  

## select the right context
$ kubectl config use-context gke_ara_dops
Switched to context "gke_ara_dops".

$ kubectl config current-context
gke_ara_dops

## get all  sealedsecrets in specified context
$ kubectl get sealedsecrets -A

NAMESPACE         NAME                                 AGE
argocd            argocd-image-updater-secret          654d
argocd            argocd-secret                        660d
argocd            ghcr-pull-secret                     433d
authentik         authentik-secret                     316d
awx               awx-admin-password                   588d
awx               awx-postgres-configuration           588d
devops-server     devops-server-google-secret          379d
devops-server     devops-server-pull-secret            379d
devops-server     devops-server-secret                 379d
external-dns      cloudflare-apikey                    92d
kube-monitoring   auth-google-oauth-secret             92d
kube-monitoring   grafana-admin                        92d
kube-monitoring   grafana-discord-notifier             92d
kube-monitoring   grafana-elastic-datasource           92d
kube-system       fluentd-elastic-secret               660d
kube-system       metricbeat-elastic-certificate-pem   637d
kube-system       metricbeat-elastic-credentials       637d
```

### Step 02. Get a backup of sealed secret keys

This will get the controller's public and private keys and should be kept safe!.

```sh
$ kubectl get secret -n kube-system -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > ss-keys.yaml
```

Where:
- `kube-system`: namespace where sealed secret lives
- `sealed-secrets-key`: label used to fetch the controller keys
- `ss-keys.yaml`: backup file containing the keys 

### Step 03. Decrypt a sealed secret

The `ss-my.json` It is sealed secret that is in your version control system, but if you have not at hand, you can get from K8s using this:

```sh
$ kubectl get sealedsecrets -n apisix -o jsonpath='{.items[]}' > ss-my.json                                                                                 
```

Once completed, decrypt it using this:
```sh
$ kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets < ss-my.json --recovery-unseal --recovery-private-key ss-keys.yaml -o yaml
```

Finally, you should base64 decoder:

```sh
$ echo -n "my-encoded-secret" | base64 -d
```

