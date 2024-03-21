# Kubernetes Ops guide


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

Once configured K8s in your local computer, select the context and run the `kubectl` to establish a connection.

```sh
$ kubectl config get-contexts                                                                                                                           
CURRENT   NAME           CLUSTER                                                 AUTHINFO                                                NAMESPACE
          gke_ara_dops   gke_aragon-devops-319312_europe-west6-a_aragon-devops   gke_aragon-devops-319312_europe-west6-a_aragon-devops   
*         gke_ara_prod   gke_aragon-prod_europe-west6-a_aragon-prod              gke_aragon-prod_europe-west6-a_aragon-prod              
          gke_ara_stg    gke_aragon-staging_europe-west6-a_aragon-staging        gke_aragon-staging_europe-west6-a_aragon-staging  

$ kubectl config use-context gke_ara_dops

$ kubectl exec <pod-name> -n <namespace> -c <container-name> -- ls


$ kubectl get pods -n apisix             
NAME                                      READY   STATUS    RESTARTS   AGE
devops-apisix-8696769d48-2xmrp            1/1     Running   0          18m
devops-apisix-8696769d48-dktjp            1/1     Running   0          19m
devops-apisix-8696769d48-xl8ck            1/1     Running   0          20m
devops-apisix-dashboard-9854b546c-zpl72   1/1     Running   0          6d18h
devops-apisix-etcd-0                      1/1     Running   0          17m
devops-apisix-etcd-1                      1/1     Running   0          18m
devops-apisix-etcd-2                      1/1     Running   0          19m


$ kubectl exec devops-apisix-8696769d48-2xmrp -n apisix -- ls
$ kubectl exec --stdin --tty devops-apisix-8696769d48-2xmrp -n apisix -- /bin/bash
```

Using `/bin/bash` instead of `/bin/sh` will allow activate arrow up/down and other features available in `bash`.
