#!/bin/bash

set -euo pipefail

echo "********** Upload Trivy Operator Reports to DefectDojo"

REPORT_DIR="${1:-../out}"
REPORT_DATE=${2:-$(date +%y%m%d-%H%M%S)}
PRODUCT_NAME="${3:-JUICESHOP}"
ENGAGEMENT_NAME="${4:-INTERNAL_PENTEST}"
PRODUCT_TYPE_NAME="${5:-R&D}"
DD_HOST="${6:-${DD_HOST:-defectdojo.tawa.local}}"
DD_API_HOST="${7:-${DD_API_HOST:-http://defectdojo-django.defectdojo.svc.cluster.local}}"
DD_API_TOKEN="${8:-${DD_API_TOKEN:?Token is mandatory}}"

echo "* REPORT_DIR: ${REPORT_DIR}"
echo "* REPORT_DATE: ${REPORT_DATE}"
echo "* PRODUCT_NAME: ${PRODUCT_NAME}"
echo "* ENGAGEMENT_NAME: ${ENGAGEMENT_NAME}"
echo "* PRODUCT_TYPE_NAME: ${PRODUCT_TYPE_NAME}"
echo "* DD_HOST: ${DD_HOST}"
echo "* DD_API_HOST: ${DD_API_HOST}"

HEADER_AUTH="Authorization: Token ${DD_API_TOKEN}"
HEADER_HOST="Host: ${DD_HOST}"

# Get all Trivy Operator JSONreports by product name
files_zap=$(find "${REPORT_DIR}" -maxdepth 1 -type f -iregex ".*/out-trivy-op.*${PRODUCT_NAME}.*\.json")
echo "Matched Trivy Operator JSON reports filtered by $REPORT_DATE:"
files_zap_matched=()
for f in $files_zap; do
  if [[ $f == *"$REPORT_DATE"* && $f != *".imported"* && $f != *".failed"* ]]; then
    files_zap_matched+=("$f")
  fi
done
printf "%s\n" "${files_zap_matched[@]}"

# Upload to DefectDojo allTrivy Operator JSON reports that weren't imported or failed
counter_zap=0
count_success=0
count_fail=0

for report in "${files_zap_matched[@]}"; do
  counter_zap=$(( counter_zap + 1 ))
  echo "Uploading $report Trivy Operator report to DefectDojo"

  # Capture response body and HTTP status
  http_code=$(curl -sk -H "$HEADER_AUTH" -H "$HEADER_HOST" \
    -X POST "${DD_API_HOST}/api/v2/reimport-scan/" \
    -F "file=@${report};type=application/json" \
    -F "scan_type=Trivy Operator Scan" \
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
    -o ${REPORT_DIR}/dd_response.json)

  # Read response body (if JSON) or raw
  detail=$(jq -r '.detail // .message // empty' ${REPORT_DIR}/dd_response.json 2>/dev/null)

  if [[ "$http_code" =~ ^2 ]]; then
    count_success=$(( count_success + 1 ))
    newname="${report%.json}.imported.json"
    mv -- "$report" "$newname"
    echo "✓ Re-import succeeded, renamed to $newname"
  else
    count_fail=$(( count_fail + 1 ))
    newname="${report%.json}.failed.json"
    mv -- "$report" "$newname"
    if [[ -n "$detail" ]]; then
      echo "✗ Re-import failed (HTTP $http_code): $detail, renamed to $newname"
    else
      echo "✗ Re-import failed (HTTP $http_code), renamed to $newname"
    fi
  fi
done

if (( count_success == 0 )); then
  echo "No Trivy Operator JSON reports were re-imported successfully."
elif (( count_success == 1 )); then
  echo "Just one Trivy Operator JSON report was re-imported successfully."
else
  echo "All $count_success Trivy Operator JSON reports were re-imported successfully."
fi
