# WSO2 API Manager on K8s


## API Manager - Deployment Pattern number 0

- https://apim.docs.wso2.com/en/latest/install-and-setup/setup/kubernetes-deployment/kubernetes/kubernetes-overview/
- https://github.com/wso2/helm-apim/tree/main/docs/am-pattern-0-all-in-one


### 1. Install

```sh
# 1. Clone the official Helm chart repository
git clone https://github.com/wso2/helm-apim.git wso2-helm-apim/

# 2. Download the default values file for pattern 0 (all-in-one)
cp wso2-helm-apim/docs/am-pattern-0-all-in-one/default_values.yaml wso2-am-pattern-0-all-in-one-values.yaml 
```
```sh
# 3. Change hostnames
- am.wso2.com
- gw.wso2.com
- websocket.wso2.com
- websub.wso2.com

- am-wso2-zws-dev
- gw-wso2-zws-dev
- websocket-wso2-zws-dev
- websub-wso2-zws-dev
```

```sh
# 4. Install the Helm chart from the correct directory (all-in-one)
helm install <release-name> <chart-path> -f <values-file> -n <namespace> --create-namespace

helm install wso2am-allinone ./wso2-helm-apim/all-in-one -f ./wso2-am-pattern-0-all-in-one-values.yaml -n wso2-system --create-namespace
```

You will see:
```sh
NAME: wso2am-allinone
LAST DEPLOYED: Wed Jul 30 19:10:04 2025
NAMESPACE: wso2-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing WSO2 API Manager.

Please follow these steps to access API Manager Publisher, DevPortal consoles.

1. Obtain the external IP (`EXTERNAL-IP`) of the API Manager Ingress resources, by listing down the Kubernetes Ingresses.

  kubectl get ing -n wso2-system

  The output under the relevant column stands for the following.

  API Manager Publisher-DevPortal

  - NAME: Metadata name of the Kubernetes Ingress resource (defaults to wso2am-allinone-am-ingress)
  - HOSTS: Hostname of the WSO2 API Manager service (am.wso2.tawa.local)
  - ADDRESS: External IP (`EXTERNAL-IP`) exposing the API Manager service to outside of the Kubernetes environment
  - PORTS: Externally exposed service ports of the API Manager service

  API Manager Gateway

  - NAME: Metadata name of the Kubernetes Ingress resource (defaults to wso2am-allinone-am-gateway-ingress)
  - HOSTS: Hostname of the WSO2 API Manager's Gateway service (gw.wso2.tawa.local)
  - ADDRESS: External IP (`EXTERNAL-IP`) exposing the API Manager's Gateway service to outside of the Kubernetes environment
  - PORTS: Externally exposed service ports of the API Manager' Gateway service


2. Add a DNS record mapping the hostnames (in step 1) and the external IP.

   If the defined hostnames (in step 1) are backed by a DNS service, add a DNS record mapping the hostnames and
   the external IP (`EXTERNAL-IP`) in the relevant DNS service.

   If the defined hostnames are not backed by a DNS service, for the purpose of evaluation you may add an entry mapping the
   hostnames and the external IP in the `/etc/hosts` file at the client-side.

   <EXTERNAL-IP> am.wso2.tawa.local gw.wso2.tawa.local

3. Navigate to the consoles in your browser of choice.

   API Manager Publisher: https://am.wso2.tawa.local/publisher
   API Manager DevPortal: https://am.wso2.tawa.local/devportal

Please refer the official documentation at https://apim.docs.wso2.com/en/latest/ for additional information on WSO2 API Manager.
```

### 2. Update /etc/hosts ()

```sh
echo "127.0.0.1 am.wso2.tawa.local" | sudo tee -a /etc/hosts
echo "127.0.0.1 gw.wso2.tawa.local" | sudo tee -a /etc/hosts
echo "127.0.0.1 websocket.wso2.tawa.local" | sudo tee -a /etc/hosts
echo "127.0.0.1 websub.wso2.tawa.local" | sudo tee -a /etc/hosts
```

### Checking

```sh
kubectl -n wso2-system get deploy,rs,pod,svc,ing,pvc

NAME                                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/wso2am-allinone-am-deployment-1   0/1     1            0           13m

NAME                                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/wso2am-allinone-am-deployment-1-79fd89848c   1         1         0       13m

NAME                                                     READY   STATUS             RESTARTS       AGE
pod/wso2am-allinone-am-deployment-1-79fd89848c-8mc8p   0/1     CrashLoopBackOff   6 (2m3s ago)   13m

NAME                                     TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                                   AGE
service/wso2am-allinone-am-service     ClusterIP   10.152.183.31    <none>        8280/TCP,8243/TCP,9611/TCP,9711/TCP,5672/TCP,9443/TCP,9021/TCP,8021/TCP   13m
service/wso2am-allinone-am-service-1   ClusterIP   10.152.183.250   <none>        8280/TCP,8243/TCP,9611/TCP,9711/TCP,5672/TCP,9443/TCP,9021/TCP,8021/TCP   13m

NAME                                                               CLASS   HOSTS                       ADDRESS     PORTS     AGE
ingress.networking.k8s.io/wso2am-allinone-am-gateway-ingress     nginx   gw.wso2.tawa.local          127.0.0.1   80, 443   13m
ingress.networking.k8s.io/wso2am-allinone-am-ingress             nginx   am.wso2.tawa.local          127.0.0.1   80, 443   13m
ingress.networking.k8s.io/wso2am-allinone-am-websocket-ingress   nginx   websocket.wso2.tawa.local   127.0.0.1   80, 443   13m
ingress.networking.k8s.io/wso2am-allinone-am-websub-ingress      nginx   websub.wso2.tawa.local      127.0.0.1   80, 443   13m
```

### Logs

```sh
$ kubectl -n wso2-system logs -f deployment.apps/wso2am-allinone-am-deployment-1

...
TID: [] Tenant: [] [2025-07-30 17:17:59,710] [] : apim :  INFO {org.apache.synapse.transport.passthru.core.PassThroughListeningIOReactorManager} - Pass-through HTTP Listener started on 0.0.0.0:8280
TID: [] Tenant: [] [2025-07-30 17:17:59,710] [] : apim :  INFO {org.apache.synapse.transport.passthru.PassThroughHttpMultiSSLListener} - Starting Pass-through HTTPS Listener...
TID: [] Tenant: [] [2025-07-30 17:17:59,712] [] : apim :  INFO {org.apache.synapse.transport.passthru.core.PassThroughListeningIOReactorManager} - Pass-through HTTPS Listener started on 0.0.0.0:8243
TID: [] Tenant: [] [2025-07-30 17:17:59,749] [] : apim :  WARN {org.apache.tomcat.util.net.SSLUtilBase} - The trusted certificate with alias [cn_baltimore_cybertrust_root,ou_cybertrust,o_baltimore,c_ie [jdk]] and DN [CN=Baltimore CyberTrust Root, OU=CyberTrust, O=Baltimore, C=IE] is not valid due to [NotAfter: Mon May 12 23:59:00 UTC 2025]. Certificates signed by this trusted certificate WILL be accepted
TID: [] Tenant: [] [2025-07-30 17:17:59,755] [] : apim :  INFO {org.apache.tomcat.util.net.NioEndpoint.certificate} - Connector [https-jsse-nio-9443], TLS virtual host [_default_], certificate type [UNDEFINED] configured from keystore [/home/wso2carbon/wso2am-4.5.0/repository/resources/security/wso2carbon.jks] using alias [wso2carbon] with trust store [/home/wso2carbon/wso2am-4.5.0/repository/resources/security/client-truststore.jks]
```


### Update JAVA heap vars and apply the changes


Update values:
```yaml
...
deployment:
    ...
    resources:
        requests:
            memory: "3Gi"
            cpu: "2000m"
        limits:
            memory: "5Gi"
            cpu: "3000m"
        jvm:
            memory:
            xms: "3072m"
            xmx: "4096m"
...
```

Deploy the changes:
```sh
helm upgrade wso2am-allinone ./wso2-helm-apim/all-in-one -f ./wso2-am-pattern-0-all-in-one-values.yaml -n wso2-system
```

You should see this:
```sh
$ kubectl -n wso2-system get deploy,rs,pod,svc,ing,pvc

NAME                                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/wso2am-allinone-am-deployment-1   1/1     1            1           28m

NAME                                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/wso2am-allinone-am-deployment-1-767dd87b7c   1         1         1       2m33s
replicaset.apps/wso2am-allinone-am-deployment-1-79fd89848c   0         0         0       28m

NAME                                                     READY   STATUS    RESTARTS   AGE
pod/wso2am-allinone-am-deployment-1-767dd87b7c-m9sns   1/1     Running   0          2m33s

NAME                                     TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                                   AGE
service/wso2am-allinone-am-service     ClusterIP   10.152.183.31    <none>        8280/TCP,8243/TCP,9611/TCP,9711/TCP,5672/TCP,9443/TCP,9021/TCP,8021/TCP   28m
service/wso2am-allinone-am-service-1   ClusterIP   10.152.183.250   <none>        8280/TCP,8243/TCP,9611/TCP,9711/TCP,5672/TCP,9443/TCP,9021/TCP,8021/TCP   28m

NAME                                                               CLASS   HOSTS                       ADDRESS     PORTS     AGE
ingress.networking.k8s.io/wso2am-allinone-am-gateway-ingress     nginx   gw.wso2.tawa.local          127.0.0.1   80, 443   28m
ingress.networking.k8s.io/wso2am-allinone-am-ingress             nginx   am.wso2.tawa.local          127.0.0.1   80, 443   28m
ingress.networking.k8s.io/wso2am-allinone-am-websocket-ingress   nginx   websocket.wso2.tawa.local   127.0.0.1   80, 443   28m
ingress.networking.k8s.io/wso2am-allinone-am-websub-ingress      nginx   websub.wso2.tawa.local      127.0.0.1   80, 443   28m
```

### Uninstall

```sh
helm uninstall wso2am-allinone -n wso2-system
kubectl delete ns wso2-system
```