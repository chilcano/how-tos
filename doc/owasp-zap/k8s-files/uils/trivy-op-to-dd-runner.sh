#!/bin/bash
set -euo pipefail

REPORT_DIR="${1:-tmp}"
REPORT_DATE=${2:-$(date +%y%m%d-%H%M%S)}
PRODUCT_NAME="${3:-JUICESHOP}"
PRODUCT_K8S_NAMESPACE="${4:-juiceshop}"
CRD_NAME="${5:-vulnerabilityreport}"

./trivy-op-reports-extractor.sh $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $PRODUCT_K8S_NAMESPACE $CRD_NAME

##
REPORT_DIR="${REPORT_DIR}"
REPORT_DATE="${REPORT_DATE}"
PRODUCT_NAME="${PRODUCT_NAME}"
ENGAGEMENT_NAME="${5:-INTERNAL_PENTEST}"
PRODUCT_TYPE_NAME="${6:-R&D}"
export DD_HOST="defectdojo.tawa.local"
export DD_API_HOST="https://defectdojo.tawa.local"
export DD_API_TOKEN="620dd95..."

./trivy-op-reports-reimport-into-dd.sh $REPORT_DIR $REPORT_DATE $PRODUCT_NAME $ENGAGEMENT_NAME $PRODUCT_TYPE_NAME 
