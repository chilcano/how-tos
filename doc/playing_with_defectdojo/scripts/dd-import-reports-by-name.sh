#!/usr/bin/env bash
set -euo pipefail

REPORT_DIR="${1:-/reports/wrk/out}"
PRODUCT_NAME="${2:-JUICESHOP}"
ENGAGEMENT_NAME="${3:-INTERNAL_PENTESTING}"
PRODUCT_TYPE_NAME="${4:-R&D}"

DD_HOST="${DD_HOST:-https://defectdojo.tawa.local}"
DD_API_TOKEN="${DD_API_TOKEN:-620dd95...}"

echo "* REPORT_DIR: ${REPORT_DIR}"
echo "* PRODUCT_NAME: ${PRODUCT_NAME}"
echo "* ENGAGEMENT_NAME: ${ENGAGEMENT_NAME}"
echo "* PRODUCT_TYPE_NAME: ${PRODUCT_TYPE_NAME}"

AUTH_HEADER="Authorization: Token ${DD_API_TOKEN}"
JSON_HEADER="Content-Type: application/json"

# Import ZAP XML reports
counter_zap=0
for report in "${REPORT_DIR}"/out-zap.*.xml; do
  [[ -e "$report" ]] || continue
  counter_zap=$((counter_zap+1))
  echo "Uploading ZAP report: $report"
  curl -sk -H "$AUTH_HEADER" -X POST "${DD_HOST}/api/v2/import-scan/" \
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
    -F "close_old_findings=true" \
    -F "close_old_findings_product_scope=true" \
  | jq .
done

if [[ $counter_zap -eq 0 ]]; then
  echo "No ZAP XML reports found in ${REPORT_DIR}."
else
  echo "All $counter_zap ZAP XML reports were imported successfully."
fi

# Import Trivy JSON reports
counter_trivy=0
for report in "${REPORT_DIR}"/out-trivy.*.json; do
  [[ -e "$report" ]] || continue
  counter_trivy=$((counter_trivy+1))
  echo "Uploading Trivy report: $report"
  curl -sk -H "$AUTH_HEADER" -X POST "${DD_HOST}/api/v2/import-scan/" \
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
    -F "close_old_findings=true" \
    -F "close_old_findings_product_scope=true" \
  | jq .
done

if [[ $counter_trivy -eq 0 ]]; then
  echo "No Trivy JSON reports found in ${REPORT_DIR}."
else
  echo "All $counter_trivy Trivy JSON reports were imported successfully."
fi
