# Using Trivy-Dojo-Report Operator


* https://github.com/telekom-mms/trivy-dojo-report-operator


## 1. Install patched Operator in a local MicroK8s

Since I'm using a local MicroK8s where I am not exposing any service to Internet, then DefectDojo running in this MicroK8s doesn't have a TLS certificate valid (verificable), thus Trivy-Dojo-Report Operator will not work because can not connect to DefectDojo to import the reports.

However, the changes in the [PR-77]( https://github.com/telekom-mms/trivy-dojo-report-operator/pull/77) fixes the issue.
Well, I'll patch the Operator and generate an updated Helm Chart to use in this guide.

* https://github.com/telekom-mms/trivy-dojo-report-operator/pull/77

```sh
## 1. clone the pr-77
git clone https://github.com/telekom-mms/trivy-dojo-report-operator.git
cd trivy-dojo-report-operator
git fetch origin pull/77/head:pr-77
git checkout pr-77

## 2. enable local microk8s registry
microk8s enable registry

## 3. build the docker image and load locally (--load only publish in local docker registry)
docker build --load -t localhost:32000/docker-trivy-dojo-operator:0.8.8-pr-77 .

## 4. push it into microk8s registry
docker push localhost:32000/docker-trivy-dojo-operator:0.8.8-pr-77

## 5. update the values yaml
operator.trivyDojoReportOperator.image.repository: localhost:32000/docker-trivy-dojo-operator
operator.trivyDojoReportOperator.image.tag: 0.8.8-pr-77
defectDojoApiCredentials.verifySSL: false

## 6. produces trivy-dojo-report-operator-0.8.8-pr77.tgz (for example)
helm package charts                          

## 7. apply the updated chart, values yaml and docker image
helm upgrade --install trivy-dojo-operator ./trivy-dojo-report-operator-*.tgz \
  -n defectdojo --reset-values -f ../trivy-dojo-report-operator-values.yaml

## 8. instead of generaing and using chart tgz, we can use the chart source code
helm upgrade --install trivy-dojo-operator ./charts \
  -n defectdojo --reset-values -f ../trivy-dojo-report-operator-values.yaml

## 9. get applied values
helm get values trivy-dojo-operator -n defectdojo
```

# 2. Install official Operator

```sh
$ helm repo add trivy-dojo-report-operator https://telekom-mms.github.io/trivy-dojo-report-operator/

$ helm repo update

## install 
$ helm upgrade --install trivy-dojo-operator trivy-dojo-report-operator/trivy-dojo-report-operator \
  -n defectdojo --create-namespace -f trivy-dojo-report-operator-values.yaml

$ helm install trivy-dojo-operator trivy-dojo-report-operator/trivy-dojo-report-operator \
  -n defectdojo --create-namespace -f trivy-dojo-report-operator-values.yaml

## verify
$ helm list -n defectdojo

NAME                    NAMESPACE       REVISION        UPDATED                                         STATUS          CHART                                   APP VERSION
defectdojo              defectdojo      2               2025-05-12 19:36:59.096643701 +0200 CEST        deployed        defectdojo-1.6.187                      2.46.2     
trivy-dojo-operator     defectdojo      1               2025-05-19 20:37:59.160067925 +0200 CEST        deployed        trivy-dojo-report-operator-0.8.8        0.8.8 

## update
$ helm upgrade trivy-dojo-operator trivy-dojo-report-operator/trivy-dojo-report-operator \
  -n defectdojo --create-namespace -f trivy-dojo-report-operator-values.yaml

## uninstall
$ helm uninstall trivy-dojo-operator -n defectdojo

## get logs
$ kubectl -n defectdojo logs -f deployment.apps/trivy-dojo-operator-trivy-dojo-report-operator-operator
```