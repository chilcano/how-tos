#!/usr/bin/env bash
set -euo pipefail

REPORT_DIR="${1:-/reports/wrk/out}"
PRODUCT_NAME="${2:-JUICESHOP}"
ENGAGEMENT_NAME="${3:-INTERNAL_PENTESTING}"

DD_HOST="${DD_HOST:-https://defectdojo.tawa.local}"
DD_API_TOKEN="${DD_API_TOKEN:-620dd95...}"

echo "* REPORT_DIR: ${REPORT_DIR}"
echo "* PRODUCT_NAME: ${PRODUCT_NAME}"
echo "* ENGAGEMENT_NAME: ${ENGAGEMENT_NAME}"

AUTH_HEADER="Authorization: Token ${DD_API_TOKEN}"
JSON_HEADER="Content-Type: application/json"

prod_id=$(curl -sk -H "$AUTH_HEADER" -H "$JSON_HEADER" "${DD_HOST}/api/v2/products/?name=${PRODUCT_NAME}" | jq -r '.results[0].id // empty')
[[ -n "$prod_id" ]] || { echo "ERROR: Product '${PRODUCT_NAME}' not found"; exit 1; }

eng_id=$(curl -sk -H "$AUTH_HEADER" -H "$JSON_HEADER" "${DD_HOST}/api/v2/engagements/?product=${prod_id}&name=${ENGAGEMENT_NAME}" | jq -r '.results[0].id // empty')
[[ -n "$eng_id" ]] || { echo "ERROR: Engagement '${ENGAGEMENT_NAME}' not found"; exit 1; }

echo "Using Product ID=${prod_id}, Engagement ID=${eng_id}"

# Import ZAP XML reports
for report in "${REPORT_DIR}"/out-zap.*.xml; do
  [[ -e "$report" ]] || continue
  echo "Uploading ZAP report: $report"
  curl -sk -H "$AUTH_HEADER" -X POST "${DD_HOST}/api/v2/import-scan/" \
    -F "file=@${report};type=application/xml" \
    -F "scan_type=ZAP Scan" \
    -F "engagement=${eng_id}" \
    -F "active=true" \
    -F "verified=true" \
    -F "scan_date=$(date +%Y-%m-%d)" \
    -F "minimum_severity=Low" \
    -F "auto_create_context=false" \
    -F "create_finding_groups_for_all_findings=false" \
  | jq .
done

# Import Trivy JSON reports
for report in "${REPORT_DIR}"/out-trivy.*.json; do
  [[ -e "$report" ]] || continue
  echo "Uploading Trivy report: $report"
  curl -sk -H "$AUTH_HEADER" -X POST "${DD_HOST}/api/v2/import-scan/" \
    -F "file=@${report};type=application/json" \
    -F "scan_type=Trivy Scan" \
    -F "engagement=${eng_id}" \
    -F "active=true" \
    -F "verified=true" \
    -F "scan_date=$(date +%Y-%m-%d)" \
    -F "minimum_severity=Low" \
    -F "auto_create_context=false" \
    -F "create_finding_groups_for_all_findings=false" \
  | jq .
done

echo "All uploads finished."
