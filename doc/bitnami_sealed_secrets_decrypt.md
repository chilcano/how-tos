# Decrypt Bitname Sealed Secrets

## Requeriments

1. `kubectl` CLI - https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl
2. Bitnami Sealed Secrets Controller and `kubeseal` CLI - https://github.com/bitnami-labs/sealed-secrets#linux
3. A Kubernetes cluster already working in Google Cloud. If you don't have one, all part related to create a secret and sealing are the same.

## Steps

- https://stackoverflow.com/questions/75812591/how-can-i-locally-decrypt-already-sealed-secrets
- https://github.com/bitnami-labs/sealed-secrets#will-you-still-be-able-to-decrypt-if-you-no-longer-have-access-to-your-cluster

```sh
## check the context
$ kubectl config current-context

aragon_devops_gke

## get all  sealedsecrets in context
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


$ kubectl get secret -n sealed-secrets -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > sealed-secrets-key.yaml
$ kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets < /tmp/sealed-secret.yaml --recovery-unseal --recovery-private-key sealed-secrets-key.yaml -o yaml


## once identified the sealedsecret to decrypt, download the sealedsecret keys
$ kubectl get secret -n devops-server -l sealedsecret.bitnami.com/devops-server-secret -o yaml > ss.yaml

## decrypt the sealedsecret keys file
$ kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets < ss-decrypted.yaml --recovery-unseal --recovery-private-key ss.yaml -o yaml

```

