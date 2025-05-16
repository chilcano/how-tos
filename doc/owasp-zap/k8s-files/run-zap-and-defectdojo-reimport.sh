#!/bin/bash

set -euo pipefail

## ZAP params
PATH_TO_SCAN_PLAN="${1:-/zap/wrk/scan-plan-test2.yaml}"  ## Must be absolute path (test1=juiceshop, test2=cyberchef)
REPORT_DIR="${2:-../out}"  ## Should be relative to /zap/wrk or absolute path
REPORT_DATE=${3:-$(date +%y%m%d-%H%M%S)}
## DefectDojo params
PRODUCT_NAME="${4:-JUICESHOP}"
ENGAGEMENT_NAME="${5:-INTERNAL_PENTEST}"
PRODUCT_TYPE_NAME="${6:-R&D}"
## DefectDojo params or env vars
DD_HOST="${7:-${DD_HOST:defectdojo.tawa.local}}"
DD_API_HOST="${8:-${DD_API_HOST:-http://defectdojo-django.defectdojo.svc.cluster.local}}"
DD_API_TOKEN="${9:-${DD_API_TOKEN:?Token is mandatory}}"

# Print params
echo "* PATH_TO_SCAN_PLAN: ${PATH_TO_SCAN_PLAN}"
echo "* REPORT_DIR: ${REPORT_DIR}"
echo "* REPORT_DATE: ${REPORT_DATE}"
echo "* PRODUCT_NAME: ${PRODUCT_NAME}"
echo "* ENGAGEMENT_NAME: ${ENGAGEMENT_NAME}"
echo "* PRODUCT_TYPE_NAME: ${PRODUCT_TYPE_NAME}"
echo "* DD_HOST: ${DD_HOST}"
echo "* DD_API_HOST: ${DD_API_HOST}"

echo "********** Trigger ZAP scan and generate Report"

REPORT_DIR=${REPORT_DIR} REPORT_DATE=${REPORT_DATE} PRODUCT_NAME=${PRODUCT_NAME} zap.sh -cmd -autorun ${PATH_TO_SCAN_PLAN} 

echo "********** Upload ZAP Reports to DefectDojo"

HEADER_AUTH="Authorization: Token ${DD_API_TOKEN}"
HEADER_HOST="Host: ${DD_HOST}"

# Get all ZAP XML reports by product name
files_zap=$(find "${REPORT_DIR}" -maxdepth 1 -type f -iregex ".*/out-zap.*${PRODUCT_NAME}.*\.xml")
echo "Matched ZAP XML reports filtered by $REPORT_DATE:"
files_zap_matched=()
for f in $files_zap; do
  if [[ $f == *"$REPORT_DATE"* && $f != *".imported"* && $f != *".failed"* ]]; then
    files_zap_matched+=("$f")
  fi
done
printf "%s\n" "${files_zap_matched[@]}"

# Upload to DefectDojo all ZAP XML reports that weren't imported or failed
counter_zap=0
count_success=0
count_fail=0

for report in "${files_zap_matched[@]}"; do
  counter_zap=$(( counter_zap + 1 ))
  echo "Uploading $report ZAP report to DefectDojo"

  # Capture response body and HTTP status
  http_code=$(curl -sk -H "$HEADER_AUTH" -H "$HEADER_HOST" \
    -X POST "${DD_API_HOST}/api/v2/reimport-scan/" \
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
    -w '%{http_code}' \
    -o /tmp/dd_response.json)

  # Read response body (if JSON) or raw
  detail=$(jq -r '.detail // .message // empty' /tmp/dd_response.json 2>/dev/null)

  if [[ "$http_code" =~ ^2 ]]; then
    count_success=$(( count_success + 1 ))
    newname="${report%.xml}.imported.xml"
    mv -- "$report" "$newname"
    echo "✓ Re-import succeeded, renamed to $newname"
  else
    count_fail=$(( count_fail + 1 ))
    newname="${report%.xml}.failed.xml"
    mv -- "$report" "$newname"
    if [[ -n "$detail" ]]; then
      echo "✗ Re-import failed (HTTP $http_code): $detail, renamed to $newname"
    else
      echo "✗ Re-import failed (HTTP $http_code), renamed to $newname"
    fi
  fi
done

if (( count_success == 0 )); then
  echo "No ZAP XML reports were re-imported successfully."
elif (( count_success == 1 )); then
  echo "Just one ZAP XML report was re-imported successfully."
else
  echo "All $count_success ZAP XML reports were re-imported successfully."
fi
