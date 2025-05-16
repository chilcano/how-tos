#!/bin/bash
set -euo pipefail

# Default configuration (can be overridden via environment)
DD_HOST="${1:-https://defectdojo.tawa.local}"
DD_API_TOKEN="${2:-620dd95db61d44de8a92213e0ddb487ffdb38f51}"

AUTH_HEADER="Authorization: Token ${DD_API_TOKEN}"
JSON_HEADER="Content-Type: application/json"

# Function to call an endpoint and pretty-print the response
list_endpoint() {
  local endpoint=$1
  echo -e "\n🔎 Listing ${endpoint^}..."
  curl -sSk -H "${AUTH_HEADER}" -H "${JSON_HEADER}" "${DD_HOST}/api/v2/${endpoint}/" | jq .
}

list_engagements_by_prod_id_and_eng_name() {
  local prod_id=$1
  local eng_name=$2
  echo -e "\n🔎 Listing engagements by prod_id=${prod_id}, eng_name=${eng_name}"
  curl -sSk -H "${AUTH_HEADER}" -H "${JSON_HEADER}" "${DD_HOST}/api/v2/engagements/?product=${prod_id}&name=${eng_name}" | jq .
}

# List Products and Engagements
list_endpoint product_types
list_endpoint products
list_endpoint engagements

list_engagements_by_prod_id_and_eng_name 2 INT_PENTEST
list_engagements_by_prod_id_and_eng_name 3 INTERNAL_PENTEST
