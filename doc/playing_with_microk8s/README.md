# Setup Microk8s and deploy of sample applications

## 1. Install and configure

* https://microk8s.io/docs/getting-started

### 1.1. Install Microk8s and addons

```sh
sudo snap install microk8s --classic

sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
chmod 0600 ~/.kube

# You will also need to re-enter the session for the group update to take place:
su - $USER

microk8s status --wait-ready

# Install addons
microk8s enable hostpath-storage dashboard ingress dns helm helm3 metrics-server
```

> * Falcosidekick-UI uses Redis and it requires `hostpath-storage` microk8s addon.
> * Trivy Server requires `hostpath-storage` microk8s addon.


```
# Start, stop, status
microk8s start
microk8s stop
microk8s status
```

**Check what addons have been installed**
```sh
microk8s status
```

You will have this:
```sh
microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:

    dns                  # (core) CoreDNS
    ha-cluster           # (core) Configure high availability on the current node
    helm                 # (core) Helm - the package manager for Kubernetes
    helm3                # (core) Helm 3 - the package manager for Kubernetes

  disabled:
    cert-manager         # (core) Cloud native certificate management
    cis-hardening        # (core) Apply CIS K8s hardening
    community            # (core) The community addons repository
    dashboard            # (core) The Kubernetes dashboard
    gpu                  # (core) Alias to nvidia add-on
    host-access          # (core) Allow Pods connecting to Host services smoothly
    hostpath-storage     # (core) Storage class; allocates storage from host directory
    ingress              # (core) Ingress controller for external access
    kube-ovn             # (core) An advanced network fabric for Kubernetes
    mayastor             # (core) OpenEBS MayaStor
    metallb              # (core) Loadbalancer for your Kubernetes cluster
    metrics-server       # (core) K8s Metrics Server for API access to service metrics
    minio                # (core) MinIO object storage
    nvidia               # (core) NVIDIA hardware (GPU and network) support
    observability        # (core) A lightweight observability stack for logs, traces and metrics
    prometheus           # (core) Prometheus operator for monitoring and logging
    rbac                 # (core) Role-Based Access Control for authorisation
    registry             # (core) Private image registry exposed on localhost:32000
    rook-ceph            # (core) Distributed Ceph storage using Rook
    storage              # (core) Alias to hostpath-storage add-on, deprecated
```

### 1.2. Install Microk8s with specific K8s version


MicroK8s can be installed in Win/macOS, VMs and Ubuntu, and can be installed using a specific K8s version.
If you want to install the latest K8s, run this command:
```sh
$ sudo snap install microk8s --classic --channel=1.32
```

Or if you want to install a stable K8s version, just pick it up your version from the available channel:
```sh
$ snap info microk8s

...
channels:
  1.32/stable:           v1.32.3  2025-04-22 (8148) 172MB classic
  1.32/candidate:        v1.32.3  2025-04-22 (8148) 172MB classic
  1.32/beta:             v1.32.3  2025-04-22 (8148) 172MB classic
  1.32/edge:             v1.32.5  2025-05-15 (8220) 172MB classic
  latest/stable:         v1.32.3  2025-04-07 (7964) 172MB classic
  latest/candidate:      v1.32.3  2025-03-12 (7890) 179MB classic
  latest/beta:           v1.32.3  2025-03-12 (7890) 179MB classic
  latest/edge:           v1.33.1  2025-05-15 (8209) 177MB classic
  1.33/stable:           v1.33.0  2025-04-24 (8205) 177MB classic
  1.33/candidate:        v1.33.0  2025-04-24 (8205) 177MB classic
  1.33/beta:             v1.33.0  2025-04-24 (8205) 177MB classic
  1.33/edge:             v1.33.1  2025-05-15 (8208) 177MB classic
  1.32-strict/stable:    v1.32.4  2025-04-23 (8155) 172MB -
  1.32-strict/candidate: v1.32.4  2025-04-23 (8155) 172MB -
  1.32-strict/beta:      v1.32.4  2025-04-23 (8155) 172MB -
  1.32-strict/edge:      v1.32.5  2025-05-15 (8226) 172MB -
  1.31-strict/stable:    v1.31.7  2025-03-31 (7968) 168MB -
  1.31-strict/candidate: v1.31.7  2025-03-30 (7968) 168MB -
  1.31-strict/beta:      v1.31.7  2025-03-30 (7968) 168MB -
  1.31-strict/edge:      v1.31.9  2025-05-15 (8219) 168MB -
  1.31/stable:           v1.31.7  2025-03-31 (7963) 168MB classic
  1.31/candidate:        v1.31.7  2025-03-28 (7963) 168MB classic
  1.31/beta:             v1.31.7  2025-03-28 (7963) 168MB classic
  1.31/edge:             v1.31.9  2025-05-15 (8216) 168MB classic
  1.30-strict/stable:    v1.30.11 2025-04-01 (7970) 169MB -
  1.30-strict/candidate: v1.30.11 2025-03-30 (7970) 169MB -
  1.30-strict/beta:      v1.30.11 2025-03-30 (7970) 169MB -
  1.30-strict/edge:      v1.30.13 2025-05-15 (8217) 169MB -
  1.30/stable:           v1.30.11 2025-03-31 (7966) 169MB classic
  1.30/candidate:        v1.30.11 2025-03-29 (7966) 169MB classic
  1.30/beta:             v1.30.11 2025-03-29 (7966) 169MB classic
  1.30/edge:             v1.30.13 2025-05-15 (8218) 169MB classic
...
```

```sh
$ sudo snap install microk8s --classic --channel=1.31/beta
```

And if you already installed a specific K8s version and now you want to change, then you can next command.
With this you will change the channel and you will receive updates comming from that channel:

```sh
$ sudo snap refresh microk8s --classic --channel=1.31/stable

$ snap info microk8s | grep tracking

tracking:     1.31/stable
```

### 1.3. Merge all kubeconfigs

```sh
cp ~/.kube/config ~/.kube/config.20250204
microk8s config > ~/.kube/config.microk8s 
export KUBECONFIG=~/.kube/config:~/.kube/config.microk8s
kubectl config view --flatten > all-in-one-kubeconfig.yaml
mv all-in-one-kubeconfig.yaml ~/.kube/config
```
Verify if works
```sh
kubectl config get-clusters
kubectl config get-contexts

CURRENT   NAME                      CLUSTER                                                 AUTHINFO                                                NAMESPACE
 *        microk8s                  microk8s-cluster                                        foo-usr                                                   
          acme-k8s-ctx              acme-k8s-cluster                                        acme-k8s-usr      

kubectl config use-context <my-context>
```


## 2. Configure Microk8s

### 2.1. Install Nginx ingress addon

**Install Ingress**
```sh
microk8s enable ingress
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

### 2.2. Install Certificate-Manager addon

**1. Install and configure Certificate-Manager**

```sh
$ kubectl config use-context microk8s

$ microk8s enable cert-manager
```

Once installed, now you will be able to create a certificate issuer:
```sh
$ cat microk8s-cluster-issuer.yaml
```

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
 name: lets-encrypt
spec:
 acme:
   email: microk8s@intix.info
   server: https://acme-v02.api.letsencrypt.org/directory
   privateKeySecretRef:
     name: lets-encrypt-priviate-key
   solvers:
   - http01:
       ingress:
         class: nginx
```

Once updated properly, run the command:
```sh
$ kubectl apply -f microk8s-cluster-issuer.yaml
```

And to verify that the ClusterIssuer was created successfully:
```sh
$ microk8s kubectl get clusterissuer -o wide

NAME           READY   STATUS                                                 AGE
lets-encrypt   True    The ACME account was registered with the ACME server   11s
```

**2. Generate TLS cert for an Ingress**

> * This only work if domain is a fqdn like `juiceshop.intix.info`
> * Cert-Manager (Let's Encrypt) will perform a challenge to verify `juiceshop.intix.info` and that means that your Ingress or LoadBalancer be configured to accept these challenges.

```sh
$ kubectl apply -f k8s-owasp-juiceshop-ingress-lets-encrypt.yaml
```

Now, it should be reacheable at https://juiceshop.intix.info


## 3. Install sample Applications

### 3.1. Weaveworks Scope

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

Add DNS to `/etc/hosts` file:
```sh
sudo bash -c 'echo "127.0.0.1 scope.tawa.local" >> /etc/hosts'
```

### 3.2. OWASP JuiceShop

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
sudo bash -c 'echo "127.0.0.1 juiceshop.tawa.local" >> /etc/hosts'
```

* The URL is `http://juiceshop.tawa.local`

* The traffic final is:
```
[user] ->   [microk8s]  ->  [ingress] -> [service] -> [pod]
browser -> 127.0.0.1:80 ->      80    ->    3080   -> 3000
```


### 3.3. OWASP bWAPP

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


### 3.4. Prometheus and Grafana


#### 3.4.1 Install and configuration


**01. Install Prometheus stack**

* We will install Prometheus stack from official repo instead of installing Microk8s Observability plugins. This last one installs extra components such as Loki.
* We will follow these instructions: https://aquasecurity.github.io/trivy-operator/v0.27.3/tutorials/grafana-dashboard/

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl config use-context microk8s
kubectl create ns monitoring

helm upgrade --install prom prometheus-community/kube-prometheus-stack -n monitoring --values values-prom-stack.yaml
helm upgrade --install prom prometheus-community/kube-prometheus-stack -n monitoring --values values-prom-stack.yaml --kubeconfig ~/.kube/config.microk8s

helm list -n monitoring
helm list -n monitoring --kubeconfig ~/.kube/config.microk8s

NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                           APP VERSION
prom    monitoring      2               2025-07-12 16:06:05.2923361 +0200 CEST  deployed        kube-prometheus-stack-75.10.0   v0.83.0 
```

**02. Check installation status**
```sh
kubectl -n monitoring get pods,svc,ing

NAME                                                         READY   STATUS    RESTARTS   AGE
pod/alertmanager-prom-kube-prometheus-stack-alertmanager-0   2/2     Running   0          23m
pod/prom-grafana-595c6c9d95-fnrb8                            3/3     Running   0          23m
pod/prom-kube-prometheus-stack-operator-6d996dbb64-5mnpq     1/1     Running   0          23m
pod/prom-kube-state-metrics-796d7cc46b-htdsq                 1/1     Running   0          23m
pod/prom-prometheus-node-exporter-4g7qb                      1/1     Running   0          23m
pod/prometheus-prom-kube-prometheus-stack-prometheus-0       2/2     Running   0          23m

NAME                                              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
service/alertmanager-operated                     ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP   23m
service/prom-grafana                              ClusterIP   10.152.183.251   <none>        80/TCP                       23m
service/prom-kube-prometheus-stack-alertmanager   ClusterIP   10.152.183.246   <none>        9093/TCP,8080/TCP            23m
service/prom-kube-prometheus-stack-operator       ClusterIP   10.152.183.56    <none>        443/TCP                      23m
service/prom-kube-prometheus-stack-prometheus     ClusterIP   10.152.183.240   <none>        9090/TCP,8080/TCP            23m
service/prom-kube-state-metrics                   ClusterIP   10.152.183.178   <none>        8080/TCP                     23m
service/prom-prometheus-node-exporter             ClusterIP   10.152.183.138   <none>        9100/TCP                     23m
service/prometheus-operated                       ClusterIP   None             <none>        9090/TCP                     23m
```

**03. Get Grafana 'admin' user password**
```sh
kubectl -n monitoring get secrets prom-grafana -ojsonpath="{.data.admin-password}" | base64 -d ; echo

prom-operator
```

**04. Check Prometheus and Grafana Services**

Reviewing the services before creating their ingresses:
```sh
$ kubectl -n monitoring get svc prom-kube-prometheus-stack-prometheus -o yaml

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

$ kubectl -n monitoring get svc prom-grafana -o yaml

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

**04. Install Prometheus and Grafana Ingresses**

```sh
kubectl apply -f microk8s-mon-ingress.yaml 
```

Once created, add DNS to your `/etc/hosts` file:
```sh
sudo bash -c 'echo "127.0.0.1 prometheus.tawa.local" >> /etc/hosts'
sudo bash -c 'echo "127.0.0.1 grafana.tawa.local" >> /etc/hosts'
```

Open the next URLs in your browser:
* Prometheus: http://prometheus.tawa.local
* Grafana: http://grafana.tawa.local (admin/prom-operator)


**05. Forward Prometheus and Grafana ports**

If you don't want to create ingresses, you can do port-forwarding:
```sh
kubectl port-forward service/prom-kube-prometheus-stack-prometheus -n monitoring 9090:9090
kubectl port-forward service/prom-grafana -n monitoring 3000:80
```

Open next urls in your browser:  
* Grafana: http://tawa.local:3000 
* Prometheus: http://tawa.local:9090

#### 3.4.2 Uninstall

```sh
helm uninstall prom -n monitoring

## should be empty
kubectl -n monitoring get all
```

### 3.5. Kubernetes Dashboard


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
  name: kubernetes-dashboard
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
---
```

```sh
kubectl apply -f microk8s-dashboard-ingress.yaml
```

Open the next URL: 
* https://dashboard.tawa.local/ (use the token)

### 3.6. Webtop (Linux in a Container)

- https://github.com/linuxserver/docker-webtop
- https://community.veeam.com/kubernetes-korner-90/go-completely-container-crazy-with-linuxserver-io-6517
- Although the Webtop container exposes HTTP (3000) and HTTPS (3001) ports, the HTTPS (3001) port will work only because the container itself will generate a self-signed certificate making HTTP useless. For this reason, the ingress only will work on HTTPS (3001) port.

- **Step 1: Enable required MicroK8s addons**
```sh
microk8s enable dns ingress hostpath-storage
```

- **Step 2: Add domain to your /etc/hosts**
```sh
echo "127.0.0.1 wt.tawa.local" | sudo tee -a /etc/hosts
```

- **Step 3: Apply the YAML**
```sh
k create ns webtop
k -n webtop apply -f k8s-webtop-1-pvc.yaml
k -n webtop apply -f k8s-webtop-2-deploy-ubuntu-xfce.yaml
k -n webtop apply -f k8s-webtop-2-deploy-ubuntu-mate.yaml
```

- **Step 4: Access to webtop**  
* http://wt.tawa.local/ubuntu-mate/
* http://wt.tawa.local/ubuntu-xfce/


- **Step 5: Checking and Logs**

```sh
k -n webtop get deploy,pod,svc,ing,pvc,rs
```
You will have:
```sh
NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/wt-ubuntu-mate   1/1     1            1           20s
deployment.apps/wt-ubuntu-xfce   1/1     1            1           3m29s

NAME                                  READY   STATUS    RESTARTS   AGE
pod/wt-ubuntu-mate-58c8b9cb98-hrwxb   1/1     Running   0          20s
pod/wt-ubuntu-xfce-7bbdfb46cc-f5rqz   1/1     Running   0          3m29s

NAME                         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/wt-svc-ubuntu-mate   ClusterIP   10.152.183.141   <none>        8443/TCP   20s
service/wt-svc-ubuntu-xfce   ClusterIP   10.152.183.76    <none>        8443/TCP   3m29s

NAME                                                 CLASS   HOSTS           ADDRESS     PORTS   AGE
ingress.networking.k8s.io/wt-ing-https-ubuntu-mate   nginx   wt.tawa.local   127.0.0.1   80      20s
ingress.networking.k8s.io/wt-ing-https-ubuntu-xfce   nginx   wt.tawa.local   127.0.0.1   80      3m29s

NAME                               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS        VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/webtop-pvc   Bound    pvc-8432c957-2c16-490e-b7ce-7ec056b11594   5Gi        RWO            microk8s-hostpath   <unset>                 174m

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/wt-ubuntu-mate-58c8b9cb98   1         1         1       20s
replicaset.apps/wt-ubuntu-xfce-7bbdfb46cc   1         1         1       3m29s
```
And logs:
```sh
k -n webtop logs -f deployment.apps/wt-ubuntu-mate
k -n webtop logs -f deployment.apps/wt-ubuntu-xfce
```
You will see errors about certificate verification, that is because certs are generated by webtop container. Once moved to Ingress (NGINX and Let's Encrypt), that could be solved.

```sh
$ k -n webtop logs -f deployment.apps/wt-ubuntu-mate

Error from server: Get "https://192.168.1.226:10250/containerLogs/webtop/wt-ubuntu-mate-58c8b9cb98-sgnxf/webtop?follow=true": tls: failed to verify certificate: x509: certificate is valid for 192.168.1.91, 100.105.136.99, 172.17.0.1, fd7a:115c:a1e0::d801:8865, not 192.168.1.226

$ k -n webtop logs -f deployment.apps/wt-ubuntu-xfce

Error from server: Get "https://192.168.1.226:10250/containerLogs/webtop/wt-ubuntu-xfce-7bbdfb46cc-bxgmt/webtop?follow=true": tls: failed to verify certificate: x509: certificate is valid for 192.168.1.91, 100.105.136.99, 172.17.0.1, fd7a:115c:a1e0::d801:8865, not 192.168.1.226
```

### 3.7. Harbor (Container Registry)

* [Install and configure Harbor](harbor-README.md)

## Troubleshooting

**01. Changing of network**

Error:
```sh
$ kubectl config use-context microk8s

$ kubectl get ns -A

E0512 14:15:38.994839  911386 memcache.go:265] couldn't get current server API group list: Get "https://192.168.1.153:16443/api?timeout=32s": dial tcp 192.168.1.153:16443: connect: no route to host
E0512 14:15:42.066889  911386 memcache.go:265] couldn't get current server API group list: Get "https://192.168.1.153:16443/api?timeout=32s": dial tcp 192.168.1.153:16443: connect: no route to host
E0512 14:15:45.143537  911386 memcache.go:265] couldn't get current server API group list: Get "https://192.168.1.153:16443/api?timeout=32s": dial tcp 192.168.1.153:16443: connect: no route to host
E0512 14:15:48.210815  911386 memcache.go:265] couldn't get current server API group list: Get "https://192.168.1.153:16443/api?timeout=32s": dial tcp 192.168.1.153:16443: connect: no route to host
E0512 14:15:51.282795  911386 memcache.go:265] couldn't get current server API group list: Get "https://192.168.1.153:16443/api?timeout=32s": dial tcp 192.168.1.153:16443: connect: no route to host
Unable to connect to the server: dial tcp 192.168.1.153:16443: connect: no route to host
```

If you are facing this problem, then follow the next steps:

- `02. Update the cluster IP`
- `03. Update Microk8s kubeconfigs` and/or `04. Merge all kubeconfigs`

**02. Update the cluster IP**

According the documentation (https://microk8s.io/docs/configure-host-interfaces), this is not needed, however if you change frequently the IP address and the default network interface, 
well, it's recommended update it to IP loopback.

This optional if you network and ip address change frequently. With that you will use the loopback.
```sh
sudo microk8s stop
nano /var/snap/microk8s/current/args/kube-apiserver

--advertise-address=127.0.0.1
--bind-address=0.0.0.0
--secure-port=16443

sudo microk8s start
```
Where:
- `advertise-address=127.0.0.1` the kubeconfig will have this ip
- `bind-address=0.0.0.0` by default microk8s already binds to all interfaces

**03. Update Microk8s kubeconfig**

```sh
## Generate new kubeconfig
microk8s config > ~/.kube/config.microk8s 
```

**04. Merge all kubeconfigs**

```sh
## Backup
cp ~/.kube/config ~/.kube/config.20250512

## Remove context and cluster from existing kubeconfig
kubectl config delete-context microk8s
kubectl config delete-cluster microk8s-cluster

## Generate new kubeconfig
microk8s config > ~/.kube/config.microk8s

export KUBECONFIG=~/.kube/config:~/.kube/config.microk8s
kubectl config view --flatten > ~/.kube/config.flatten
mv ~/.kube/config.flatten ~/.kube/config
```

Verify if works:
```sh
kubectl config get-clusters
kubectl config get-contexts

CURRENT   NAME                      CLUSTER                                                 AUTHINFO                                                NAMESPACE
 *        microk8s                  microk8s-cluster                                        foo-usr                                                   
          acme-k8s-ctx              acme-k8s-cluster                                        acme-k8s-usr      

kubectl config use-context <my-context>
```

### 2. Error with ingress (nginx) after changing network

* Error in ingress controller:
```sh
$ k -n ingress logs daemonset/nginx-ingress-microk8s-controller
Error from server: Get "https://192.168.1.91:10250/containerLogs/ingress/nginx-ingress-microk8s-controller-bzxkw/nginx-ingress-microk8s": tls: failed to verify certificate: x509: certificate is valid for 192.168.1.226, 100.105.136.99, 172.17.0.1, fd7a:115c:a1e0::d801:8865, not 192.168.1.91
```
* Error 504 Gateway Time-out when opening an exposed pod through ingress 

**Fix**
```sh
$ microk8s stop
[sudo] password for chilcano: 
Stopped.
Stopped.

$ sudo microk8s refresh-certs

$ microk8s start

## Check the certificates
$ sudo ls -la /var/snap/microk8s/current/certs/
```

### 3. Remove and re-install Microk8s

```sh
## Optional - reset all plugins
sudo microk8s reset

## Remove
sudo snap remove microk8s --purge
## Install
sudo snap install microk8s --classic

## Install the plugins
microk8s enable dns ingress hostpath-storage

## Make sure you have these plugins installed
microk8s status

microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:
    dns                  # (core) CoreDNS
    ha-cluster           # (core) Configure high availability on the current node
    helm                 # (core) Helm - the package manager for Kubernetes
    helm3                # (core) Helm 3 - the package manager for Kubernetes
    hostpath-storage     # (core) Storage class; allocates storage from host directory
    ingress              # (core) Ingress controller for external access
  disabled:
    cert-manager         # (core) Cloud native certificate management
    cis-hardening        # (core) Apply CIS K8s hardening
    community            # (core) The community addons repository
    dashboard            # (core) The Kubernetes dashboard
    gpu                  # (core) Alias to nvidia add-on
    host-access          # (core) Allow Pods connecting to Host services smoothly
    kube-ovn             # (core) An advanced network fabric for Kubernetes
    mayastor             # (core) OpenEBS MayaStor
    metallb              # (core) Loadbalancer for your Kubernetes cluster
    metrics-server       # (core) K8s Metrics Server for API access to service metrics
    minio                # (core) MinIO object storage
    nvidia               # (core) NVIDIA hardware (GPU and network) support
    observability        # (core) A lightweight observability stack for logs, traces and metrics
    prometheus           # (core) Prometheus operator for monitoring and logging
    rbac                 # (core) Role-Based Access Control for authorisation
    registry             # (core) Private image registry exposed on localhost:32000
    rook-ceph            # (core) Distributed Ceph storage using Rook

## Generate new kubeconfig
microk8s config > ~/.kube/config.microk8s
```