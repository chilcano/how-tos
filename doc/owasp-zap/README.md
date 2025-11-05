# OWASP ZAP Guide

![](owasp-zap-hla-map.png)

## 1. Deploy ZAP, Report Viewer and Scan CronJob

```sh
# install zap-scan
kubectl create namespace dast
kubectl -n dast apply -f sec-reports-pvc.yaml
kubectl -n dast apply -f 'zap-scan-configmap-*.yaml'
kubectl -n dast apply -f zap-scan-deployment.yaml
# install sec-reports-viewer
kubectl -n dast apply -f sec-reports-viewer-configmap.yaml
kubectl -n dast apply -f sec-reports-viewer-deployment.yaml
# install cronjob (optional) to schedule scans
kubectl -n dast apply -f zap-scan-cronjob.yaml

## check
kubectl -n dast get all 
kubectl -n dast get deploy,sts,pod,cm,svc,ing,pvc,cronjob

## remove zap-scan
kubectl -n dast delete -f 'zap-scan-configmap-*.yaml'
kubectl -n dast delete -f zap-scan-deployment.yaml
## remove sec-reports-viewer
kubectl -n dast delete -f sec-reports-viewer-configmap.yaml
kubectl -n dast delete -f sec-reports-viewer-deployment.yaml
## remove cronjob, pvc and ns (optional)
kubectl -n dast delete -f zap-scan-cronjob.yaml
kubectl -n dast delete -f sec-reports-pvc.yaml
kubectl delete namespace dast
```

## 2. Access to ZAP scan pod

```sh
kubectl exec -it -n dast deploy/zap-scan -- bash

# zap help, version
kubectl exec -it -n dast deploy/zap-scan -- zap.sh -h
kubectl exec -it -n dast deploy/zap-scan -- zap.sh -version

# check plans
kubectl exec -it -n dast deploy/zap-scan -- ls -la /zap/wrk/plans-sample/
kubectl exec -it -n dast deploy/zap-scan -- cat /zap/wrk/plans-sample/scan-plan-test1.yaml

# zap policies
kubectl exec -it -n dast deploy/zap-scan -- ls -la /root/.ZAP/policies/
kubectl exec -it -n dast deploy/zap-scan -- ls -la /home/zap/.ZAP/policies/

# check reports generated and size (vol 4Gi)
kubectl exec -it -n dast deploy/zap-scan -- ls -la /sec-reports/zap/
kubectl exec -it -n dast deploy/zap-scan -- sh -c 'du -sh /sec-reports/zap/*'
kubectl exec -it -n dast deploy/zap-scan -- sh -c 'du -sh /sec-reports/zap/* | sort -h'

# delete reports
kubectl exec -it -n dast deploy/zap-scan -- sh -c 'rm -rf /sec-reports/zap/out-zap.*'
```

### 2.1. Run ZAP scan

> Update the ZAP Addons before scanning

```sh
kubectl exec -it -n dast deploy/zap-scan -- bash -c "zap.sh -cmd -addonupdate"
```

**Scan by running zap.sh from local kubectl**
```sh
## test1=juiceshop, test2=cyberchef
kubectl exec -it -n dast deploy/zap-scan -- sh -c 'REPORT_DIR=/sec-reports/zap PRODUCT_NAME=JUICESHOP REPORT_DATE=$(date +%y%m%d-%H%M%S) zap.sh -cmd -autorun /zap/wrk/plans-sample/scan-plan-test1.yaml'
kubectl exec -it -n dast deploy/zap-scan -- bash -c "REPORT_DIR=/sec-reports/zap PRODUCT_NAME=CYBERCHEF REPORT_DATE=$(date +%y%m%d-%H%M%S) zap.sh -cmd -autorun /zap/wrk/plans-sample/scan-plan-test2.yaml"

## 01=FRONT, 02=BACK
kubectl exec -it -n dast deploy/zap-scan -- sh -c 'REPORT_DIR=/sec-reports/zap PRODUCT_NAME=FRONT REPORT_DATE=$(date +%y%m%d-%H%M%S) zap.sh -cmd -autorun /zap/wrk/plans-extra/scan-plan-01-front.yaml'
kubectl exec -it -n dast deploy/zap-scan -- bash -c "REPORT_DIR=/sec-reports/zap PRODUCT_NAME=BACK REPORT_DATE=$(date +%y%m%d-%H%M%S) zap.sh -cmd -autorun /zap/wrk/plans-extra/scan-plan-02-back.yaml"
```

**Scan by running zap.sh from pod**
```sh
## test1=juiceshop, test2=cyberchef
REPORT_DIR=/sec-reports/zap PRODUCT_NAME=JUICESHOP REPORT_DATE=$(date +%y%m%d-%H%M%S) zap.sh -cmd -autorun /zap/wrk/plans-sample/scan-plan-test1.yaml
REPORT_DIR=/sec-reports/zap PRODUCT_NAME=CYBERCHEF REPORT_DATE=$(date +%y%m%d-%H%M%S) zap.sh -cmd -autorun /zap/wrk/plans-sample/scan-plan-test2.yaml

## 01=FRONT, 02=BACK
REPORT_DIR=/sec-reports/zap PRODUCT_NAME=FRONT REPORT_DATE=$(date +%y%m%d-%H%M%S) zap.sh -cmd -autorun /zap/wrk/plans-extra/scan-plan-01.yaml
REPORT_DIR=/sec-reports/zap PRODUCT_NAME=BACK REPORT_DATE=$(date +%y%m%d-%H%M%S) zap.sh -cmd -autorun /zap/wrk/plans-extra/scan-plan-02.yaml
```

### 2.2. View ZAP scan logs

```sh
kubectl exec -it -n dast deploy/zap-scan -- tail -f -n 1000 /home/zap/.ZAP/zap.log
```

## 3. Access to Security Report Viewer pod

```sh
kubectl exec -it -n dast deploy/sec-reports-viewer -- sh
kubectl exec -it -n dast deploy/sec-reports-viewer -- ls -la /usr/share/nginx/html/
kubectl exec -it -n dast deploy/sec-reports-viewer -- ls -la /usr/share/nginx/html/sec-reports/

# view size of vol
kubectl exec -it -n dast deploy/sec-reports-viewer -- sh -c 'du -sh /usr/share/nginx/html/sec-reports/* | sort -h'

# get shell
kubectl exec -it -n dast deploy/sec-reports-viewer -- sh
# delete reports from shell
/ # ls -la /usr/share/nginx/html/sec-reports/zap/
/ # rm -rf /usr/share/nginx/html/sec-reports/zap/out-zap.*
```

## 4. Send ZAP reports to DefectDojo

**Requirements:**

1. ZAP reports should be in XML format.
2. We provide a ZAP pod with all bash scripts to perform this task: get a new ZAP report and DD importer.
3. DefectDojo should be up and running, with that we should get an API Token and corresponding _internal k8s service URI_.

### 4.1. Scan and send JuiceShop and CyberChef XML reports

**Step 1: Get access to pod**

```sh
kubectl exec -it -n dast deploy/zap-scan -- bash
```

**Step 2: Set params and vars that script will use**

```sh
PATH_TO_SCAN_PLAN="/zap/wrk/plans-sample/scan-plan-test1.yaml"
REPORT_DIR="/sec-reports/zap"
REPORT_DATE="$(date +%y%m%d-%H%M%S)"
PRODUCT_NAME="JUICESHOP"
ENGAGEMENT_NAME="INTERNAL_PENTEST"
PRODUCT_TYPE_NAME="R&D"
DD_HOST="defectdojo.tawa.local"
DD_API_HOST="http://defectdojo-django.defectdojo.svc.cluster.local"
DD_API_TOKEN="620dd95...."
```

**Step 3: Run the script**

```sh
## Using '.' to run script
. /zap/wrk/run-zap-and-defectdojo-reimport.sh $PATH_TO_SCAN_PLAN $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $ENGAGEMENT_NAME $PRODUCT_TYPE_NAME $DD_HOST $DD_API_HOST $DD_API_TOKEN

## Or using 'source' to run script
source /zap/wrk/run-zap-and-defectdojo-reimport.sh $PATH_TO_SCAN_PLAN $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $ENGAGEMENT_NAME $PRODUCT_TYPE_NAME $DD_HOST $DD_API_HOST $DD_API_TOKEN
```

### 4.2. Scan and send Console-FRONT and Console-BACK XML reports

Like we are doing for sample applications such as CyberChef and JuiceShop, we can do for Console stack. Only get access to pod, update and set the env vars and run the bash script.

**Step 1: Get access to pod**

```sh
kubectl exec -it -n dast deploy/zap-scan -- bash
```

**Step 2: Set param and run the scripts**

```sh
## Set params a vars that script will use
REPORT_DIR="/sec-reports/zap"
REPORT_DATE="$(date +%y%m%d-%H%M%S)"
ENGAGEMENT_NAME="INTERNAL_PENTEST"
PRODUCT_TYPE_NAME="R&D"
DD_HOST="defectdojo.tawa.local"
DD_API_HOST="http://defectdojo-django.defectdojo.svc.cluster.local"
DD_API_TOKEN="620dd95...."

## Run the script

PATH_TO_SCAN_PLAN="/zap/wrk/plans-extra/scan-plan-01.yaml"
PRODUCT_NAME="FRONT"

. /zap/wrk/run-zap-and-defectdojo-reimport.sh $PATH_TO_SCAN_PLAN $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $ENGAGEMENT_NAME $PRODUCT_TYPE_NAME $DD_HOST $DD_API_HOST $DD_API_TOKEN


PATH_TO_SCAN_PLAN="/zap/wrk/plans-extra/scan-plan-02.yaml"
PRODUCT_NAME="BACK"

. /zap/wrk/run-zap-and-defectdojo-reimport.sh $PATH_TO_SCAN_PLAN $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $ENGAGEMENT_NAME $PRODUCT_TYPE_NAME $DD_HOST $DD_API_HOST $DD_API_TOKEN
```

## 5. Send Trivy-Operator reports to DefectDojo

**Requirements:**

1. Trivy-Operator up and running.
2. Trivy-Operator reports should be extracted from K8s namespaces and splitted by K8s resources.
3. We provide a Trivy-Op pod with all bash scripts to perform these tasks: extractor, splitter and DD importer.
4. DefectDojo should be up and running, with that we should get an API Token and corresponding _internal k8s service URI_.

### 5.1. Extract and send JuiceShop and CyberChef JSON reports

**Step 1: Get access to pod**

```sh
kubectl exec -it -n dast deploy/trivy-op-reports-exporter -- bash
```

**Step 2: Run the scripts**
```sh
## Check the scripts
ls -la scripts

total 0
lrwxrwxrwx. 1 root 1000 36 May 23 10:23 trivy-op-reports-extractor.sh -> ..data/trivy-op-reports-extractor.sh
lrwxrwxrwx. 1 root 1000 43 May 23 10:23 trivy-op-reports-reimport-into-dd.sh -> ..data/trivy-op-reports-reimport-into-dd.sh
lrwxrwxrwx. 1 root 1000 31 May 23 10:23 trivy-op-to-dd-runner.sh -> ..data/trivy-op-to-dd-runner.sh

## Split Trivy-Operator Reports by CRD and Namespaces

now=$(date +%y%m%d-%H%M%S)
REPORT_DATE=${now}
REPORT_DIR="/sec-reports/trivy-op"
CRD_NAME="vulnerabilityreport"
PRODUCT_NAME="JUICESHOP"
PRODUCT_K8S_NAMESPACE="juiceshop"

./scripts/trivy-op-reports-extractor.sh $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $PRODUCT_K8S_NAMESPACE $CRD_NAME

PRODUCT_NAME="CYBERCHEF"
PRODUCT_K8S_NAMESPACE="test-waf-cf"

./scripts/trivy-op-reports-extractor.sh $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $PRODUCT_K8S_NAMESPACE $CRD_NAME

## Import Trivy-Operator to DefectDojo
## (make sure defectdojo is up and running!!)

REPORT_DIR="/sec-reports/trivy-op"
REPORT_DATE=${now}
PRODUCT_NAME="CYBERCHEF"
ENGAGEMENT_NAME="INTERNAL_PENTEST"
PRODUCT_TYPE_NAME="R&D"
export DD_HOST="defectdojo.tawa.local"
export DD_API_HOST="https://defectdojo.tawa.local"
export DD_API_TOKEN="620dd95..."

./scripts/trivy-op-reports-reimport-into-dd.sh $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $ENGAGEMENT_NAME $PRODUCT_TYPE_NAME 
```

### 5.2. Extract and send CONSOLE (All inside of Console namespace) JSON reports

```sh
## Step 1: Split Trivy-Operator Reports by CRD and Namespaces

now=$(date +%y%m%d-%H%M%S)
REPORT_DATE=${now}
REPORT_DIR="/sec-reports/trivy-op"
CRD_NAME="vulnerabilityreport"
PRODUCT_NAME="CONSOLE"
PRODUCT_K8S_NAMESPACE="console"

./scripts/trivy-op-reports-extractor.sh $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $PRODUCT_K8S_NAMESPACE $CRD_NAME

## Step 2: Import Trivy-Operator to DefectDojo
## (make sure defectdojo is up and running!!)

REPORT_DIR="/sec-reports/trivy-op"
REPORT_DATE=${now}
PRODUCT_NAME="CONSOLE"
ENGAGEMENT_NAME="INTERNAL_PENTEST"
PRODUCT_TYPE_NAME="R&D"
export DD_HOST="defectdojo.tawa.local"
export DD_API_HOST="https://defectdojo.tawa.local"
export DD_API_TOKEN="620dd95..."

./scripts/trivy-op-reports-reimport-into-dd.sh $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $ENGAGEMENT_NAME $PRODUCT_TYPE_NAME 
```
