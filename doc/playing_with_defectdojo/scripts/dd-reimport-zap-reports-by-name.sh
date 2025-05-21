#!/bin/bash

set -euo pipefail

REPORT_DIR="${1:-/reports/wrk/out}"
PRODUCT_NAME="${2:-JUICESHOP}"
ENGAGEMENT_NAME="${3:-INTERNAL_PENTESTING}"
PRODUCT_TYPE_NAME="${4:-R&D}"

DD_HOST="${DD_HOST:-defectdojo.tawa.local}"
DD_API_HOST="${DD_API_HOST:-https://defectdojo.tawa.local}"
# DD_API_HOST="${DD_API_HOST:-http://defectdojo-django.defectdojo.svc.cluster.local}"
DD_API_TOKEN="${DD_API_TOKEN:-620dd95...}"

echo "* REPORT_DIR: ${REPORT_DIR}"
echo "* PRODUCT_NAME: ${PRODUCT_NAME}"
echo "* ENGAGEMENT_NAME: ${ENGAGEMENT_NAME}"
echo "* PRODUCT_TYPE_NAME: ${PRODUCT_TYPE_NAME}"
echo "* DD_HOST: ${DD_HOST}"
echo "* DD_API_HOST: ${DD_API_HOST}"

HEADER_AUTH="Authorization: Token ${DD_API_TOKEN}"
HEADER_HOST="Host: ${DD_HOST}"

## Import ZAP XML reports
files_zap=$(find "${REPORT_DIR}" -maxdepth 1 -type f -iregex ".*/out-zap.*${PRODUCT_NAME}.*\.xml")

echo "*************"
echo "$files_zap"
echo "*************"

counter_zap=0
for report in ${files_zap}; do
  counter_zap=$(( counter_zap + 1 ))
  echo "Uploading ZAP report: $report"
#   curl -sk -H "$HEADER_AUTH" -H "$HEADER_HOST" -X POST "${DD_API_HOST}/api/v2/reimport-scan/" \
#     -F "file=@${report};type=application/xml" \
#     -F "scan_type=ZAP Scan" \
#     -F "product_name=${PRODUCT_NAME}" \
#     -F "engagement_name=${ENGAGEMENT_NAME}" \
#     -F "product_type_name=${PRODUCT_TYPE_NAME}" \
#     -F "active=true" \
#     -F "verified=true" \
#     -F "scan_date=$(date +%Y-%m-%d)" \
#     -F "minimum_severity=Low" \
#     -F "auto_create_context=true" \
#     -F "engagement_end_date=$(date -d '+14 days' +%Y-%m-%d)" \
#     -F "deduplication_on_engagement=true" \
#     | jq -c .
done

if [[ $counter_zap -eq 0 ]]; then
  echo "No ZAP XML reports found in ${REPORT_DIR} and nothing was re-imported."
else
  echo "All $counter_zap ZAP XML reports were re-imported successfully."
fi
