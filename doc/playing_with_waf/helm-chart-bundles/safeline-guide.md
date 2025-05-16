# SafeLine Helm Chart

## Refs


* Guides:
  - https://dev.to/carrie_luo1/deploying-high-availability-safeline-waf-on-k3spart-1-3iab
  - https://dev.to/carrie_luo1/deploying-high-availability-safeline-waf-on-k3spart-2-219f
  - https://dev.to/carrie_luo1/deploying-high-availability-safeline-waf-on-k3spart-3-12bj
* Resources:
  - https://github.com/jangrui/SafeLine/tree/main/charts/safeline
  - https://github.com/jangrui/SafeLine/blob/main/charts/safeline/values.yaml


## Steps


### 1. From Guides (new)

```sh
helm repo add safeline https://g-otkk6267-helm.pkg.coding.net/Charts/safeline
helm repo update
helm fetch --version 5.2.0 safeline/safeline

helm -n safeline install safeline safeline-5.2.0.tgz --values values-safeline-5.2.0.yaml --create-namespace
helm -n safeline upgrade safeline safeline-5.2.0.tgz --values values-safeline-5.2.0.yaml --create-namespace

$ helm -n safeline install safeline safeline-5.2.0-tgz/ --values values-safeline-5.2.0.yaml --create-namespace

± helm -n safeline install safeline safeline-5.2.0-tgz/ --values values-safeline-5.2.0.yaml --create-namespace
NAME: safeline
LAST DEPLOYED: Thu Feb 27 13:49:22 2025
NAMESPACE: safeline
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Please wait for several minutes for Safeline deployment to complete.
Then you should be able to visit the Safeline managenment at https://safeline-mgt:1443/api/open/publish/server
For more details, please visit https://github.com/chaitin/SafeLine

$ helm -n safeline upgrade safeline safeline-5.2.0-tgz/ --values values-safeline-5.2.0.yaml --create-namespace





helm -n safeline install safeline safeline-7.4.0-tgz/ -f values-safeline-7.4.0.yaml --create-namespace
helm -n safeline upgrade safeline safeline-7.4.0-tgz/ -f values-safeline-7.4.0.yaml --create-namespace

# uninstall
$ helm -n safeline uninstall safeline 

# check installation
$ kubectl get pvc,pod -n safeline
$ kubectl get svc -n safeline

## delete the postgres pvc
$ kubectl delete pvc database-data-safeline-database-0 -n safeline        

## or delete all pvc
$ kubectl delete pvc -l app=safeline -n safeline
$ kubectl delete pvc -n safeline --all


## Get usr/pwd safeline-mgt
$ docker exec safeline-mgt resetadmin

<inside-pod> / # resetadmin

 [SafeLine] Initial username：admin
 [SafeLine] Initial password：by7jGkOk
 [SafeLine] Done



helm -n safeline install safeline safeline-7.1.0-tgz/ --create-namespace
helm -n safeline install safeline safeline-7.3.1-tgz/ --create-namespace


```




### 2. From github repo (old)

```sh
helm repo add jangrui https://github.com/jangrui/SafeLine --force-update
helm -n safeline upgrade -i safeline jangrui/safeline --create-namespace

```



### 0. Pre

```sh
$ kubectl config use-context microk8s  

$ kubectl get nodes -o wide                              
NAME   STATUS   ROLES    AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION     CONTAINER-RUNTIME
tawa   Ready    <none>   40d   v1.31.5   192.168.1.153   <none>        Ubuntu 23.04   6.2.0-39-generic   containerd://1.6.28

$ microk8s status                                    

microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
...

$ helm repo list

NAME                    URL                                                   
aqua                    https://aquasecurity.github.io/helm-charts/           
prometheus-community    https://prometheus-community.github.io/helm-charts    
falcosecurity           https://falcosecurity.github.io/charts                
safeline                https://g-otkk6267-helm.pkg.coding.net/Charts/safeline
```

