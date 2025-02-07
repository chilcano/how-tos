# Installation of sample applications in MicroK8s

## 01. Configure MicroK8s

### 1. DNS

### 2. Load Balancer

### 3. Ingress



## 02. Install sample Applications

### 1. Weaveworks Scope

* https://github.com/weaveworks/scope/releases/tag/v1.13.2

**01. Install**

```sh
kubectl apply -f https://github.com/weaveworks/scope/releases/download/v1.13.2/k8s-scope.yaml

namespace/weave created
clusterrole.rbac.authorization.k8s.io/weave-scope created
clusterrolebinding.rbac.authorization.k8s.io/weave-scope created
deployment.apps/weave-scope-app created
daemonset.apps/weave-scope-agent created
deployment.apps/weave-scope-cluster-agent created
serviceaccount/weave-scope created
service/weave-scope-app created
```

**02. Check installation**

```sh
kubectl get pod -n weave
```

**03. Get access**

```sh
kubectl get svc -n weave

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
weave-scope-app   ClusterIP   10.152.183.77   <none>        80/TCP    5m19s

## Port Forwarding
kubectl port-forward svc/weave-scope-app -n weave 4041:80
```

### 2. OWASP JuiceShop

* https://owasp.org/www-project-juice-shop/
* https://pwning.owasp-juice.shop/companion-guide/latest/part1/running.html


**01. Install**

```sh
kubectl apply -f k8s-owasp-juiceshop.yaml

namespace/juiceshop created
deployment.apps/owasp-juiceshop created
service/owasp-juiceshop created

```

**02. Check installation**

```sh
kubectl get all -n juiceshop
```

**03. Get access**

```sh
kubectl get svc -n juiceshop

NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
owasp-juiceshop   ClusterIP   10.152.183.179   <none>        3080/TCP   3m24s

## Port Forwarding
kubectl port-forward svc/owasp-juiceshop -n juiceshop 3080:3080
```

### 3. Multi-Juicer (based on OWASP JuiceShop)

* https://pwning.owasp-juice.shop/companion-guide/latest/part4/multi-juicer.html
* https://github.com/juice-shop/multi-juicer/blob/main/guides/k8s/k8s.md

### Install and configuration

**01. Install**

```sh

```

**02. Check installation**

```sh

```

**03. Get access**

```sh

```

