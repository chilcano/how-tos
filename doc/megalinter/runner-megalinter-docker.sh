#!/bin/bash

# ************** This is an example ************** #
# This bash can be used locally from your terminal #
# ************************************************ #
# 
# runner-exec-ml-docker.sh <param1> <param2> <param3> <param4> <param5> <param6> <param7> <param8> <param9> <param10> 
# Example:
#   cd $HOME/repos/zama/security-hub/scripts/
#   ./runner-megalinter-docker.sh 

ML_CHILD_REPO_DIR="$HOME/repos/zama/kms-core"
ML_CFG_FILE="$HOME/repos/zama/security-hub/.mega-linter.yml"
ML_OUT_DIR="$HOME/repos/zama/security-hub/temp/megalinter-reports"
## Trivy can scan repo branch, tag or commit 
ML_TRIVY_PARAM_REPO_ATT="--branch main"
## GrafanaCloud
ML_GF_LOKI_URL="https://logs-prod-012.grafana.net/loki/api/v1/push"
ML_GF_LOKI_USR="1082074"
ML_GF_PROM_URL="https://influx-prod-24-prod-eu-west-2.grafana.net/api/v1/push/influx/write"
ML_GF_PROM_USR="1965640"
ML_GF_TOKEN=$GF_CHILCANO_TOKEN_ML
## Trivy report format can be: json|sarif|table
ML_TRIVY_PARAM_REPORT_FORMAT="json"

./exec-megalinter-docker.sh \
    $ML_CHILD_REPO_DIR \
    $ML_CFG_FILE \
    $ML_OUT_DIR \
    "$ML_TRIVY_PARAM_REPO_ATT" \
    $ML_GF_LOKI_URL \
    $ML_GF_LOKI_USR \
    $ML_GF_PROM_URL \
    $ML_GF_PROM_USR \
    $ML_GF_TOKEN \
    $ML_TRIVY_PARAM_REPORT_FORMAT 

