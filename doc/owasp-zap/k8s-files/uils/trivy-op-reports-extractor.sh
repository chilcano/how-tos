#!/bin/bash
set -euo pipefail

echo "********** Split Trivy Operator Reports by CRD and Namespaces"

REPORT_DIR="${1:-/sec-reports/trivy-op}"
REPORT_DATE=${2:-$(date +%y%m%d-%H%M%S)}
PRODUCT_NAME="${3:-JUICESHOP}"
PRODUCT_K8S_NAMESPACE="${4:-juiceshop}"
CRD_NAME="${5:-vulnerabilityreport}"

mkdir -p "$REPORT_DIR"

echo "* NAMESPACE: $PRODUCT_K8S_NAMESPACE"
echo "* PRODUCT_NAME: $PRODUCT_NAME"
echo "* REPORT_DATE: $REPORT_DATE"
echo "* OUTPUT DIR: $REPORT_DIR"

# 1) Export from K8s
tmpfile="$(mktemp)"
kubectl -n "${PRODUCT_K8S_NAMESPACE}" get "${CRD_NAME}" -o json > "$tmpfile"

# 2) Dump and save each item
echo "Splitting $(jq '.items | length' "$tmpfile") report(s) into individual files..."
jq -c '.items[]' "$tmpfile" | while read -r item; do
  # VulnerabilityReport
  kind=$(jq -r '.kind' <<<"$item")
  # replicaset-juiceshop-784878964d-juiceshop
  name=$(jq -r '.metadata.name' <<<"$item")
  # 2025-05-19T13:55:49Z
  ts_raw=$(jq -r '.metadata.creationTimestamp' <<<"$item")
  # Convert ISO8601 to yymmdd-hhmmss (%Y = 2025, %y = 25) 
  ts_fmt=$(date -u -d "$ts_raw" +"%y%m%d-%H%M%S")
  outfile="${REPORT_DIR}/out-trivy-op.${PRODUCT_NAME}.${REPORT_DATE}.${kind}.${name}.json"
  echo "$item" > "$outfile"
  echo " → $outfile"
done

# 3) Clean
rm "$tmpfile"
echo "Done."
