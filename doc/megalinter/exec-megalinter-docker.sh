#!/bin/bash

## Script for testing purposes. If you want to use it, then update the GrafanaCloud variables.

_CHILD_REPO_DIR=${1:-$HOME/repos/zama/kms-core}
_ML_CFG_FILE=${2:-$HOME/repos/zama/security-hub/.mega-linter.yml}
_ML_OUT_DIR=${3:-$HOME/repos/zama/security-hub/temp/megalinter-reports}
## Trivy branch or tag value
_TRIVY_PARAM_REPO_ATT=${4}
## GrafanaCloud
_GF_LOKI_URL=${5:-https://logs-prod-012.grafana.net/loki/api/v1/push}
_GF_LOKI_USR=${6:-1082074}
_GF_PROM_URL=${7:-https://influx-prod-24-prod-eu-west-2.grafana.net/api/v1/push/influx/write}
_GF_PROM_USR=${8:-1965640}
_GF_TOKEN=${9:-$GF_CHILCANO_TOKEN_ML}
## Trivy report format can be: json|sarif|table
_TRIVY_PARAM_REPORT_FORMAT=${10:-table}

start=$(date +%s)

## The first time that 'docker run' executes, it will pull the corresponding docker image and keep it in local.
## If you want it, you can do it manually. Only uncomment any of both below lines.
#docker pull oxsecurity/megalinter:v8.3.0
#docker pull oxsecurity/megalinter-ci_light:v8.3.0

## This 'docker run' will use the Megalinter light flavor.
## More flavors: https://megalinter.io/8.3.0/flavors/
## REPOSITORY_TRIVY_ARGUMENTS should use 'repo' in order to be able to switch to branch, tag or commit
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock:rw \
  -v $_CHILD_REPO_DIR:/tmp/lint:rw \
  -v $_ML_CFG_FILE:/tmp/lint/.mega-linter.yml \
  -v $_ML_OUT_DIR:/tmp/lint/megalinter-reports \
  -e VALIDATE_ALL_CODEBASE=true \
  -e PRINT_ALPACA=false \
  -e REPOSITORY_TRIVY_COMMAND_REMOVE_ARGUMENTS="fs --scanners vuln,misconfig --exit-code 1" \
  -e REPOSITORY_TRIVY_ARGUMENTS="repo --scanners vuln,misconfig --exit-code 1 -f ${_TRIVY_PARAM_REPORT_FORMAT} --quiet ${_TRIVY_PARAM_REPO_ATT}" \
  -e JSON_REPORTER=true \
  -e JSON_REPORTER_OUTPUT_DETAIL=simple \
  -e API_REPORTER=true \
  -e API_REPORTER_URL=$_GF_LOKI_URL \
  -e API_REPORTER_BASIC_AUTH_USERNAME=$_GF_LOKI_USR \
  -e API_REPORTER_BASIC_AUTH_PASSWORD=$_GF_TOKEN \
  -e API_REPORTER_METRICS_URL=$_GF_PROM_URL \
  -e API_REPORTER_METRICS_BASIC_AUTH_USERNAME=$_GF_PROM_USR \
  -e API_REPORTER_METRICS_BASIC_AUTH_PASSWORD=$_GF_TOKEN \
  -e API_REPORTER_DEBUG=false \
  oxsecurity/megalinter-ci_light:v8.3.0 

end=$(date +%s)
run_time_total=$((end - start))

## List all docker tarballs generated
printf "\n\n*** Total running time: ${run_time_total} seconds. \n"
