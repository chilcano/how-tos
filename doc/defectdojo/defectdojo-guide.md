# DefectDojo - Application Security Posture Management (ASPM) & Vulnerability Management

* https://github.com/DefectDojo/django-DefectDojo
* https://docs.defectdojo.com/en/about_defectdojo/about_docs/


## 1. Install DefectDojo using Docker Compose

* https://github.com/DefectDojo/django-DefectDojo/blob/master/readme-docs/DOCKER.md

These commands only will install DefectDojo using available docker images in DockerHub.

```sh
$ git clone https://github.com/DefectDojo/django-defectdojo
$ cd django-defectdojo

# start 
$ DD_TLS_PORT=7443 DD_PORT=7080 ./dc-up.sh

# start with detached mode
$ DD_TLS_PORT=7443 DD_PORT=7080 ./dc-up-d.sh
```

### 1.1. Get password

**Check if admin password has been created**

```sh
$ docker compose logs initializer | grep -E "Admin" 

initializer-1  | Admin user: admin
initializer-1  | Admin password: Initialization detected that the admin user admin already exists in your database.

$ docker logs -f django-defectdojo-initializer-1

...
Admin user: admin
[07/Nov/2024 09:18:27] INFO [dojo.models:4589] enabling audit logging
Admin password: Initialization detected that the admin user admin already exists in your database.
If you don't remember the admin password, you can create a new superuser with:
$ docker compose exec uwsgi /bin/bash -c 'python manage.py createsuperuser'
Creating Announcement Banner
[07/Nov/2024 09:18:28] INFO [dojo.models:4589] enabling audit logging
...
```

### 1.2. Create a super user

```sh
$ docker compose exec uwsgi /bin/bash -c 'python manage.py createsuperuser'
```

### 1.3. Browse DefectDojo

* Be aware we changed the HTTP and HTTPS ports. The new ones are `7080` and `7443`.
* Open [http://tawa.local:7080](http://tawa.local:7080)


## 2. Install DefectDojo using helm chart

* https://github.com/DefectDojo/django-DefectDojo/blob/master/readme-docs/KUBERNETES.md

### 2.1. Set helm chart and install it


**1. Set the chart**

```sh
$ kubectl config use-context microk8s

$ helm repo add defectdojo https://raw.githubusercontent.com/DefectDojo/django-DefectDojo/helm-charts

$ helm repo update

$ helm search repo defectdojo

NAME                    CHART VERSION   APP VERSION     DESCRIPTION                                      
defectdojo/defectdojo   1.6.187         2.46.2          A Helm chart for Kubernetes to install DefectDojo
```


**2. Create a values yaml to customize the installation**

```sh
$ cat values-defectdojo.yaml 
```

```yaml
---
# Global settings
# create defectdojo specific secret
createSecret: true
# create redis secret in defectdojo chart, outside of redis chart
createRedisSecret: true
# create postgresql secret in defectdojo chart, outside of postgresql chart
createPostgresqlSecret: true

host: defectdojo.tawa.local

django:
  ingress:
    enabled: true
    ingressClassName: nginx
    activateTLS: true

admin:
  user: admin
  password:
  firstName: Administrator
  lastName: User
  mail: admin@defectdojo.local
```

**3. Install**

```sh
## install
$ helm install defectdojo defectdojo/defectdojo -n defectdojo --create-namespace --version 1.6.187 -f ./values-defectdojo.yaml 

NAME: defectdojo
LAST DEPLOYED: Mon May 12 19:21:20 2025
NAMESPACE: defectdojo
STATUS: deployed
REVISION: 1
NOTES:
DefectDojo has been installed.

To use it, go to <https://defectdojo.default.minikube.local>.
Log in with username admin.
To find out the password, run the following command:

    echo "DefectDojo admin password: $(kubectl \
      get secret defectdojo \
      --namespace=defectdojo \
      --output jsonpath='{.data.DD_ADMIN_PASSWORD}' \
      | base64 --decode)"
...

## update
$ helm upgrade defectdojo defectdojo/defectdojo -n defectdojo --create-namespace --version 1.6.187 -f ./values-defectdojo.yaml
```

### 2.2. Check the installation

```sh
$ helm list -n defectdojo

NAME            NAMESPACE       REVISION        UPDATED                                         STATUS          CHART                   APP VERSION
defectdojo      defectdojo      1               2025-05-12 19:21:20.030458979 +0200 CEST        deployed        defectdojo-1.6.187      2.46.2 

## list all resources installed
$ kubectl -n defectdojo get pod,svc,deploy,ing           

NAME                                            READY   STATUS    RESTARTS   AGE
pod/defectdojo-celery-beat-8f6958b5c-xc5wj      1/1     Running   5          4d
pod/defectdojo-celery-worker-86d59d7f7c-j8brb   1/1     Running   5          4d
pod/defectdojo-django-95c685b97-d8v9s           2/2     Running   10         4d
pod/defectdojo-postgresql-0                     1/1     Running   5          4d
pod/defectdojo-redis-master-0                   1/1     Running   5          4d

NAME                                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/defectdojo-django           ClusterIP   10.152.183.41   <none>        80/TCP     4d
service/defectdojo-postgresql       ClusterIP   10.152.183.68   <none>        5432/TCP   4d
service/defectdojo-postgresql-hl    ClusterIP   None            <none>        5432/TCP   4d
service/defectdojo-redis-headless   ClusterIP   None            <none>        6379/TCP   4d
service/defectdojo-redis-master     ClusterIP   10.152.183.58   <none>        6379/TCP   4d

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/defectdojo-celery-beat     1/1     1            1           4d
deployment.apps/defectdojo-celery-worker   1/1     1            1           4d
deployment.apps/defectdojo-django          1/1     1            1           4d

NAME                                   CLASS   HOSTS                   ADDRESS     PORTS     AGE
ingress.networking.k8s.io/defectdojo   nginx   defectdojo.tawa.local   127.0.0.1   80, 443   4d
```

### 2.3. Browse and access to it

* Get the Ingress URL.
```sh
$ kubectl -n defectdojo describe ingress.networking.k8s.io/defectdojo
```
* To use it, go to [https://defectdojo.tawa.local](https://defectdojo.tawa.local)
* Log in with username `admin`, and to find out the password, run the following command:
```sh
$ echo "DefectDojo admin password: $(kubectl get secret defectdojo -n defectdojo -o jsonpath='{.data.DD_ADMIN_PASSWORD}' | base64 --decode)"

DefectDojo admin password: Kx33in1lHb3Tbc69kxomBY
```

## 3. Using DefectDojo


### 3.1. WeaveWorks SockShop (import reports into DefectDojo manually)

* WeaveWorks SockShop is composed of a set of microservices.
* I've forked the demo repo: https://github.com/chilcano/microservices-demo/
* All microservices used in this applications have independent repositories and have different docker containers:
  - Repos:
    1. https://github.com/microservices-demo/front-end/
    2. https://github.com/microservices-demo/edge-router/
    3. https://github.com/microservices-demo/catalogue/
    4. https://github.com/microservices-demo/carts/
    5. https://github.com/microservices-demo/orders/
    6. https://github.com/microservices-demo/shipping/
    7. https://github.com/microservices-demo/queue-master/
    8. https://github.com/microservices-demo/payment/
    9. https://github.com/microservices-demo/user/
  - Docker Images:
    1. front-end
      * weaveworksdemos/front-end:0.3.12
    2. edge-router
      * weaveworksdemos/edge-router:0.1.1
    3. catalogue
      * weaveworksdemos/catalogue:0.3.5
    4. catalogue-db
      * weaveworksdemos/catalogue-db:0.3.0
    5. carts
      * weaveworksdemos/carts:0.4.8 
    6. carts-db
      * mongo:3.4
    7. orders
      * weaveworksdemos/orders:0.4.7
    8. orders-db
      * mongo:3.4
    9. shipping
      * weaveworksdemos/shipping:0.4.8
    10. queue-master
      * weaveworksdemos/queue-master:0.3.1
    11. rabbitmq
      * rabbitmq:3.6.8
    12. payment
      * weaveworksdemos/payment:0.4.3
    13. user
      * weaveworksdemos/user:0.4.4
    14. user-db
      * weaveworksdemos/user-db:0.4.0
    15. user-sim
      * weaveworksdemos/load-test:0.1.1

**Step 1. Generate Trivy reports**

```sh
## scan remote repo and get JSON report
$ trivy repo -f json --pkg-types os,library --scanners vuln,secret,misconfig https://github.com/microservices-demo/front-end -o out-trivy.front-end.repo.json

## scan remote docker image and get JSON report
$ trivy image -f json --pkg-types os,library --scanners vuln,secret,misconfig weaveworksdemos/front-end:0.3.12 -o out-trivy.front-end.0.3.12.image.json
```

Repeat this process for all components (repos and docker images) of SockShop.

**Step 2. Generate ZAP reports**

* Launch OWASP ZAP GUI and point to SockShop entrypoint (Front-End URL), scan it and generate a XML report.
* Once created the ZAP XML report of SockShop, import it following the below steps.

**Step 3. Import all reports manually**

* Follow this blog post: https://pvs-studio.com/en/docs/manual/6686/
* In brief, the manual process is:
  1. Create a Product: 
    - [http://tawa.local:7080/product/add](http://tawa.local:7080/product/add)
  2. Create an Engagement: 
    - Go to the created Product, there click on Engagements > Add New Interactive Engagement.
  3. Import Trivy reports:
    - Go to the created Engagement, there click on Findings > Import Scan Results.
    - Once imported, click in the 3-dots icon and select Edit option. Update the title, service, tags, version of the imported findings.

![](../img/defectdojo-trivy-1.png)


### 3.2. JuiceShop (import reports into DefectDojo through its REST API)

* JuiceShop is installed in my local microk8s and it's being exposed at [http://juiceshop.tawa.local](http://juiceshop.tawa.local) and over HTTPS.

**Step 1. Generate Trivy reports**

```sh
$ trivy repo -q --scanners vuln,misconfig,secret https://github.com/juice-shop/juice-shop -f json -o out-trivy.JUICESHOP.repo.json
$ trivy image -q --scanners vuln,misconfig,secret docker.io/bkimminich/juice-shop:v17.1.1 -f json -o out-trivy.JUICESHOP.image.json

$ ls -la

out-trivy.JUICESHOP.repo.json
out-trivy.JUICESHOP.image.json
```

**Step 2. Generate ZAP reports**

* I'll use OWASP ZAP from terminal by running `Automation Framework`.
* This is the ZAP Scan Plan to be use with `Automation Framework`, It'll generate HTML and XML reports.
```sh
$ cat scan-plan-test1.yaml

env:
    contexts:
    - name: app-ctx
        urls:
        - http://juiceshop.tawa.local/
        includePaths:
        - https?://juiceshop.tawa.local/.*
        technology:
        exclude: [HypersonicSQL, Oracle, ASP, Windows, IIS]
    parameters:
    failOnError: true
    failOnWarning: false
    continueOnFailure: false
    progressToStdout: true
jobs:
    - type: passiveScan-config
    parameters:
        maxAlertsPerRule: 10
        scanOnlyInScope: true
    - type: spiderAjax
    parameters:
        context: app-ctx
        maxDuration: 0
        maxCrawlDepth: 10
        runOnlyIfModern: false
        inScopeOnly: true
        browserId: firefox-headless
        clickDefaultElems: true
        clickElemsOnce: true
        maxCrawlStates: 0
    - type: passiveScan-wait
    parameters:
        maxDuration: 30
    - type: report
    parameters:
        template: traditional-html
        reportDir: ${REPORT_DIR}
        reportFile: out-zap.${PRODUCT_NAME}.${REPORT_DATE}
        reportTitle: JuiceShop Findings
        reportDescription: Runs SpiderAjax & PassiveScan [ JuiceShop ]
    - type: report
    parameters:
        template: traditional-xml
        reportDir: ${REPORT_DIR}
        reportFile: out-zap.${PRODUCT_NAME}.${REPORT_DATE}
```
* Execute OWASP ZAP Automation Framework
```sh
$ REPORT_DIR=. PRODUCT_NAME=JUICESHOP REPORT_DATE=$(date +%y%m%d-%H%M%S) zap.sh -cmd -autorun scan-plan-test1.yaml

$ ls -la

out-zap.JUICESHOP.20250516-120000.html
out-zap.JUICESHOP.20250516-120000.html
```

**Step 3. Import all reports using DefectDojo REST API**

* You will need to get from DefectDojo an API Token.
* DefectDojo is running in my local microk8s and it's exposed at [https://defectdojo.tawa.local](https://defectdojo.tawa.local)
* I've created a bash scripts that create a PRODUCT, ENGAGEMENT and take these reports and import them automatically.
```sh
$ cat dd-reimport-reports-by-name.sh

#!/usr/bin/env bash
set -euo pipefail

REPORT_DIR="${1:-/reports/wrk/out}"
PRODUCT_NAME="${2:-JUICESHOP}"
ENGAGEMENT_NAME="${3:-INTERNAL_PENTESTING}"
PRODUCT_TYPE_NAME="${4:-R&D}"
DD_HOST="${DD_HOST:-https://defectdojo.tawa.local}"
DD_API_TOKEN="${DD_API_TOKEN:-620dd95.....}"

echo "* REPORT_DIR: ${REPORT_DIR}"
echo "* PRODUCT_NAME: ${PRODUCT_NAME}"
echo "* ENGAGEMENT_NAME: ${ENGAGEMENT_NAME}"
echo "* PRODUCT_TYPE_NAME: ${PRODUCT_TYPE_NAME}"

AUTH_HEADER="Authorization: Token ${DD_API_TOKEN}"

## Import ZAP XML reports
counter_zap=0
for report in "${REPORT_DIR}"/out-zap.*.xml; do
  [[ -e "$report" ]] || continue
  counter_zap=$((counter_zap+1))
  echo "Uploading ZAP report: $report"
  curl -sk -H "$AUTH_HEADER" -X POST "${DD_HOST}/api/v2/reimport-scan/" \
    -F "file=@${report};type=application/xml" \
    -F "scan_type=ZAP Scan" \
    -F "product_name=${PRODUCT_NAME}" \
    -F "engagement_name=${ENGAGEMENT_NAME}" \
    -F "product_type_name=${PRODUCT_TYPE_NAME}" \
    -F "active=true" \
    -F "verified=true" \
    -F "scan_date=$(date +%Y-%m-%d)" \
    -F "minimum_severity=Low" \
    -F "auto_create_context=true" \
    -F "engagement_end_date=$(date -d '+14 days' +%Y-%m-%d)" \
    -F "deduplication_on_engagement=true" \
  | jq .
done

if [[ $counter_zap -eq 0 ]]; then
  echo "No ZAP XML reports found in ${REPORT_DIR} and nothing was re-imported."
else
  echo "All $counter_zap ZAP XML reports were re-imported successfully."
fi

## Import Trivy JSON reports
counter_trivy=0
for report in "${REPORT_DIR}"/out-trivy.*.json; do
  [[ -e "$report" ]] || continue
  counter_trivy=$((counter_trivy+1))
  echo "Uploading Trivy report: $report"
  curl -sk -H "$AUTH_HEADER" -X POST "${DD_HOST}/api/v2/reimport-scan/" \
    -F "file=@${report};type=application/json" \
    -F "scan_type=Trivy Scan" \
    -F "product_name=${PRODUCT_NAME}" \
    -F "engagement_name=${ENGAGEMENT_NAME}" \
    -F "product_type_name=${PRODUCT_TYPE_NAME}" \
    -F "active=true" \
    -F "verified=true" \
    -F "scan_date=$(date +%Y-%m-%d)" \
    -F "minimum_severity=Low" \
    -F "auto_create_context=true" \
    -F "engagement_end_date=$(date -d '+14 days' +%Y-%m-%d)" \
    -F "deduplication_on_engagement=true" \
  | jq .
done

if [[ $counter_trivy -eq 0 ]]; then
  echo "No Trivy JSON reports found in ${REPORT_DIR} and nothing was re-imported."
else
  echo "All $counter_trivy Trivy JSON reports were re-imported successfully."
fi
```

* Import the Trivy and ZAP reports.
```sh

$ REPORT_DIR="." ; PRODUCT_NAME="JUICESHOP" ; ENGAGEMENT_NAME="INTERNAL_PENTEST}" ; PRODUCT_TYPE_NAME="RESEARCH"
$ export DD_HOST="https://defectdojo.tawa.local" ; export DD_API_TOKEN="620dd95....."

$ dd-reimport-reports-by-name.sh $REPORT_DIR $PRODUCT_NAME $ENGAGEMENT_NAME $PRODUCT_TYPE_NAME
```

**Step 4. Verify if reports were imported under PRODUCT and ENGAGEMENT**

1. Go to DefectDojo web
2. Go to PRODUCTS, select JUICESHOP
3. Go to ALL ENGAGEMENT and select INTERNAL_PENTEST
4. Go to `All Findings`, there you will see all imported reports.
