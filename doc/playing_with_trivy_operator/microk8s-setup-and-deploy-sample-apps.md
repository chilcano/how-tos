# Setup Microk8s and deploy of sample applications

## 01. Configure Microk8s

Install all Microk8s addons required.
```sh
microk8s enable ingress

Infer repository core for addon ingress
Enabling Ingress
ingressclass.networking.k8s.io/public created
ingressclass.networking.k8s.io/nginx created
namespace/ingress created
serviceaccount/nginx-ingress-microk8s-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-microk8s-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-microk8s-role created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
configmap/nginx-load-balancer-microk8s-conf created
configmap/nginx-ingress-tcp-microk8s-conf created
configmap/nginx-ingress-udp-microk8s-conf created
daemonset.apps/nginx-ingress-microk8s-controller created
Ingress is enable
```

The Microk8s Ingress exposes the HTTP (80) and HTTPS (443) ports by default:
```sh
kubectl -n ingress describe daemonset.apps/nginx-ingress-microk8s-controller 

...
Pod Template:
  Labels:           name=nginx-ingress-microk8s
  Service Account:  nginx-ingress-microk8s-serviceaccount
  Containers:
   nginx-ingress-microk8s:
    Image:       registry.k8s.io/ingress-nginx/controller:v1.11.2
    Ports:       80/TCP, 443/TCP, 10254/TCP
    Host Ports:  80/TCP, 443/TCP, 10254/TCP
...
```

To check what microk8s addons have been installed, run this:
```sh
microk8s is running

high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:
    dashboard            # (core) The Kubernetes dashboard
    dns                  # (core) CoreDNS
    ha-cluster           # (core) Configure high availability on the current node
    helm                 # (core) Helm - the package manager for Kubernetes
    helm3                # (core) Helm 3 - the package manager for Kubernetes
    hostpath-storage     # (core) Storage class; allocates storage from host directory
    ingress              # (core) Ingress controller for external access
    metrics-server       # (core) K8s Metrics Server for API access to service metrics
    storage              # (core) Alias to hostpath-storage add-on, deprecated
  disabled:
    cert-manager         # (core) Cloud native certificate management
    cis-hardening        # (core) Apply CIS K8s hardening
    community            # (core) The community addons repository
    gpu                  # (core) Alias to nvidia add-on
    host-access          # (core) Allow Pods connecting to Host services smoothly
    kube-ovn             # (core) An advanced network fabric for Kubernetes
    mayastor             # (core) OpenEBS MayaStor
    metallb              # (core) Loadbalancer for your Kubernetes cluster
    minio                # (core) MinIO object storage
    nvidia               # (core) NVIDIA hardware (GPU and network) support
    observability        # (core) A lightweight observability stack for logs, traces and metrics
    prometheus           # (core) Prometheus operator for monitoring and logging
    rbac                 # (core) Role-Based Access Control for authorisation
    registry             # (core) Private image registry exposed on localhost:32000
    rook-ceph            # (core) Distributed Ceph storage using Rook
```


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

**03. Get access using port-forwarding**

```sh
kubectl get svc -n weave

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
weave-scope-app   ClusterIP   10.152.183.77   <none>        80/TCP    5m19s

## Port Forwarding
kubectl port-forward svc/weave-scope-app -n weave 4041:80
```

**04. Get access using ingress**


* Describe weave service:
```sh
kubectl get svc weave-scope-app -n weave -o yaml
apiVersion: v1
kind: Service
...
spec:
  clusterIP: 10.152.183.77
  clusterIPs:
  - 10.152.183.77
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: app
    port: 80
    protocol: TCP
    targetPort: 4040
...
```

The traffic is routed in this way:
```
[user] ->   [microk8s]  ->  [ingress] -> [service] -> [pod]
browser -> 127.0.0.1:80 ->      80    ->     80    -> 4040
```

```sh
kubectl apply -f k8s-weaveworks-scope-ingress.yaml
```

### 2. OWASP JuiceShop

* https://owasp.org/www-project-juice-shop/
* https://pwning.owasp-juice.shop/companion-guide/latest/part1/running.html

Use next links if you want to install Multi-Juicer (based on OWASP JuiceShop), suitable for CTF:
* https://pwning.owasp-juice.shop/companion-guide/latest/part4/multi-juicer.html
* https://github.com/juice-shop/multi-juicer/blob/main/guides/k8s/k8s.md


**01. Install**

```sh
kubectl apply -f k8s-owasp-juiceshop.yaml

namespace/juiceshop created
deployment.apps/juiceshop created
service/juiceshop-svc created
ingress.networking.k8s.io/juiceshop-ing created
```

**02. Check installation**

```sh
kubectl get pod,svc,ing -n juiceshop
```

**03. Get access using port-forwarding**

```sh
kubectl get svc -n juiceshop

NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
owasp-juiceshop   ClusterIP   10.152.183.179   <none>        3080/TCP   3m24s

## Port Forwarding
kubectl port-forward svc/owasp-juiceshop -n juiceshop 3080:3080
```

**04. Get access using ingress**

* Juiceshop service:
```sh
± kubectl get svc juiceshop-svc -n juiceshop -o yaml
apiVersion: v1
kind: Service
...
spec:
  clusterIP: 10.152.183.72
  clusterIPs:
  - 10.152.183.72
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: http
    port: 3080
    protocol: TCP
    targetPort: 3000
...
```

* Add `juiceshop.<hostname>` to `/etc/hosts` file.
```sh
cat /etc/hosts

127.0.0.1   juiceshop.tawa.local
```

* The URL is `http://juiceshop.<hostname>`

* The traffic final is:
```
[user] ->   [microk8s]  ->  [ingress] -> [service] -> [pod]
browser -> 127.0.0.1:80 ->      80    ->    3080   -> 3000
```


### 3. OWASP bWAPP

**Step : Deploy bWAPP** 

```sh
kubectl apply -f k8s-owasp-bwapp.yaml
```

**Step 1: Run Install** 
- http://bwapp.tawa.local/install.php

**Step 2: Create user in bWAPP**
- http://bwapp.tawa.local/user_new.php

**Step 3: Login and play** 
- http://bwapp.tawa.local/login.php


### 4. Prometheus and Grafana

```sh
± kubectl get svc,ing -n monitoring 
NAME                                              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
service/alertmanager-operated                     ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP   5d23h
service/prom-grafana                              ClusterIP   10.152.183.152   <none>        80/TCP                       5d23h
service/prom-kube-prometheus-stack-alertmanager   ClusterIP   10.152.183.76    <none>        9093/TCP,8080/TCP            5d23h
service/prom-kube-prometheus-stack-operator       ClusterIP   10.152.183.201   <none>        443/TCP                      5d23h
service/prom-kube-prometheus-stack-prometheus     ClusterIP   10.152.183.130   <none>        9090/TCP,8080/TCP            5d23h
service/prom-kube-state-metrics                   ClusterIP   10.152.183.146   <none>        8080/TCP                     5d23h
service/prom-prometheus-node-exporter             ClusterIP   10.152.183.107   <none>        9100/TCP                     5d23h
service/prometheus-operated                       ClusterIP   None             <none>        9090/TCP                     5d23h
```

#### 4.1 Install and configuration

The services are:
```sh
± kubectl get svc prom-kube-prometheus-stack-prometheus -n monitoring -o yaml

...
spec:
  clusterIP: 10.152.183.130
  clusterIPs:
  - 10.152.183.130
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: http-web
    port: 9090
    protocol: TCP
    targetPort: 9090
  - appProtocol: http
    name: reloader-web
    port: 8080
    protocol: TCP
    targetPort: reloader-web
...

± kubectl get svc prom-grafana -n monitoring -o yaml

...
spec:
  clusterIP: 10.152.183.152
  clusterIPs:
  - 10.152.183.152
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: http-web
    port: 80
    protocol: TCP
    targetPort: 3000
...
```


**01. Install**

```sh
± kubectl apply -f microk8s-mon-ingress.yaml 

ingress.networking.k8s.io/prometheus-ing created
ingress.networking.k8s.io/grafana-ing created
```

**02. Get access**

Open the next URLs in your browser:

* Prometheus: http://prometheus.tawa.local
* Grafana: http://grafana.tawa.local (admin/prom-operator)


### 5. Kubernetes Dashboard


**01. Dashboard installation**

```sh
microk8s enable dashboard 
```

**02. Checking installation**

```sh
± kubectl get svc kubernetes-dashboard -n kube-system -o yaml

...
spec:
  clusterIP: 10.152.183.21
  clusterIPs:
  - 10.152.183.21
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - port: 443
    protocol: TCP
    targetPort: 8443
...

token=$(kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
kubectl -n kube-system describe secret $token

```

**03. Accessing through port-forwarding**

```sh
kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443
```

Open the next URL: https://tawa.local:10443/ (use the token)


**04. Accessing through ingress**

```sh
cat  microk8s-dashboard-ingress.yaml
```
Note the annotation is important:
```yaml
---
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: dashboard-ing
  namespace: kube-system
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS  # This is important, otherwise we get a 400 bad request
spec:
  # ingressClassName: public
  ingressClassName: nginx
  rules:
  - host: dashboard.tawa.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kubernetes-dashboard
            port:
              number: 443

```

```sh
kubectl apply -f microk8s-dashboard-ingress.yaml
```

Open the next URL: 
* https://dashboard.tawa.local/ (use the token)

