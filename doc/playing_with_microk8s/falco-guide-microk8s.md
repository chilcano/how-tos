# Falco

* https://falco.org/docs/getting-started/falco-kubernetes-quickstart/

## 1. Deploy Falco

**01. Install**

```sh
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

helm search repo falcosecurity

NAME                            CHART VERSION   APP VERSION     DESCRIPTION                                       
falcosecurity/event-generator   0.3.4           0.10.0          A Helm chart used to deploy the event-generator...
falcosecurity/falco             6.0.2           0.41.3          Falco                                             
falcosecurity/falco-exporter    0.12.2          0.8.7           DEPRECATED Prometheus Metrics Exporter for Falc...
falcosecurity/falco-talon       0.3.0           0.3.0           React to the events from Falco                    
falcosecurity/falcosidekick     0.10.2          2.31.1          Connect Falco to your ecosystem                   
falcosecurity/k8s-metacollector 0.1.10          0.1.1           Install k8s-metacollector to fetch and distribu...

helm install --replace falco -n falco --create-namespace --set tty=true falcosecurity/falco --version 6.0.2

helm list -n falco

NAME    NAMESPACE       REVISION        UPDATED                                         STATUS          CHART           APP VERSION
falco   falco           1               2025-07-11 19:49:19.399139393 +0200 CEST        deployed        falco-6.0.2     0.41.3
```

**02. Check**

```sh
kubectl get pod,ds,cm,svc -n falco 
```

You should have this:
```sh
NAME              READY   STATUS    RESTARTS   AGE
pod/falco-z9gpl   1/2     Running   0          59s

NAME                   DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/falco   1         1         0       1            0           <none>          59s

NAME                         DATA   AGE
configmap/falco              1      59s
configmap/falco-falcoctl     1      59s
configmap/kube-root-ca.crt   1      59s
```

## 2. Deploy Falcosidekick and Falcosidekick UI


**00. Pre-requisites**

* Redis requires PersistentVolumeClaim enabled in Microk8s. Enable `hostpath-storage` or `storage` (alias) addon.
```sh
microk8s enable hostpath-storage



## You can verify if falcosidekick-ui and redis have been installed successfully
kubectl get pod -n falco

NAME                                      READY   STATUS    RESTARTS   AGE
falco-falcosidekick-55bf9744f5-2qfl8      1/1     Running   0          16m
falco-falcosidekick-55bf9744f5-4zrb4      1/1     Running   0          16m
falco-falcosidekick-ui-7f58c84fdd-b7jxr   1/1     Running   0          16m
falco-falcosidekick-ui-7f58c84fdd-lr8tf   1/1     Running   0          16m
falco-falcosidekick-ui-redis-0            1/1     Running   0          16m
falco-npr28                               2/2     Running   0          16m
```


**01. Install Falcosidekick and add custom rules**

The custom rules are:
```yaml
customRules:
  custom-rules.yaml: |-
    # - rule: Write below etc
    #   desc: An attempt to write to /etc directory
    #   condition: >
    #     (evt.type in (open,openat,openat2) and evt.is_open_write=true and fd.typechar='f' and fd.num>=0)
    #     and fd.name startswith /etc
    #   output: "File below /etc opened for writing (file=%fd.name pcmdline=%proc.pcmdline gparent=%proc.aname[2] ggparent=%proc.aname[3] gggparent=%proc.aname[4] evt_type=%evt.type user=%user.name user_uid=%user.uid user_loginuid=%user.loginuid process=%proc.name proc_exepath=%proc.exepath parent=%proc.pname command=%proc.cmdline terminal=%proc.tty %container.info)"
    #   priority: WARNING
    #   tags: [filesystem, mitre_persistence]    
```

Now, install Falco and enable Falcosidekick and Falcosidekick UI:
```sh
helm upgrade -n falco falco falcosecurity/falco -f falco_custom_rules_cm.yaml --set falcosidekick.enabled=true --set falcosidekick.webui.enabled=true
```

**02. Check**

```sh
kubectl get pod,ds,cm,svc -n falco
```

You should have this:
```sh
NAME                                          READY   STATUS    RESTARTS   AGE
pod/falco-4jlff                               2/2     Running   0          50s
pod/falco-falcosidekick-7855846c65-2dsk7      1/1     Running   0          51s
pod/falco-falcosidekick-7855846c65-99jr5      1/1     Running   0          51s
pod/falco-falcosidekick-ui-6d96c9f75d-jhj5d   1/1     Running   0          51s
pod/falco-falcosidekick-ui-6d96c9f75d-lg24b   1/1     Running   0          51s
pod/falco-falcosidekick-ui-redis-0            1/1     Running   0          51s

NAME                   DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/falco   1         1         1       1            1           <none>          9m33s

NAME                                             DATA   AGE
configmap/falco                                  1      9m33s
configmap/falco-falcoctl                         1      9m33s
configmap/falco-falcosidekick-ui-redis           1      51s
configmap/falco-rules                            1      51s
configmap/falcosidekick-loki-dashboard-grafana   1      51s
configmap/kube-root-ca.crt                       1      9m33s

NAME                                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
service/falco-falcosidekick            ClusterIP   10.152.183.51   <none>        2801/TCP,2810/TCP   51s
service/falco-falcosidekick-ui         ClusterIP   10.152.183.83   <none>        2802/TCP            51s
service/falco-falcosidekick-ui-redis   ClusterIP   10.152.183.99   <none>        6379/TCP            51s
```

**03. Check the custom rules**

```sh
kubectl -n falco get cm falco-rules -o yaml
```

You will see the custom rules, in m case, they are commented:
```yaml
apiVersion: v1
data:
  custom-rules.yaml: |-
    # - rule: Write below etc
    #   desc: An attempt to write to /etc directory
    #   condition: >
    #     (evt.type in (open,openat,openat2) and evt.is_open_write=true and fd.typechar='f' and fd.num>=0)
    #     and fd.name startswith /etc
    #   output: "File below /etc opened for writing (file=%fd.name pcmdline=%proc.pcmdline gparent=%proc.aname[2] ggparent=%proc.aname[3] gggparent=%proc.aname[4] evt_type=%evt.type user=%user.name user_uid=%user.uid user_loginuid=%user.loginuid process=%proc.name proc_exepath=%proc.exepath parent=%proc.pname command=%proc.cmdline terminal=%proc.tty %container.info)"
    #   priority: WARNING
    #   tags: [filesystem, mitre_persistence]
kind: ConfigMap
metadata:
  annotations:
    meta.helm.sh/release-name: falco
    meta.helm.sh/release-namespace: falco
  creationTimestamp: "2025-02-12T12:38:30Z"
  labels:
    app.kubernetes.io/instance: falco
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: falco
    app.kubernetes.io/version: 0.40.0
    helm.sh/chart: falco-4.20.0
  name: falco-rules
  namespace: falco
  resourceVersion: "1610142"
  uid: 202a3188-7aa9-4f7f-8531-9b9ea87d429f
```

## 3. Deploy an Ingress for Falcosidekick UI

```sh
kubectl apply -f falco-ingress.yaml
```

Add DNS to `/etc/hosts` file:
```sh
sudo bash -c 'echo "127.0.0.1 falcosidekick-ui.tawa.local" >> /etc/hosts'
```

Open Falcosidekick URL in your browser: http://falcosidekick-ui.tawa.local/

## 4. Integrate Falco with Prometheus/Grafana

tbc