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
