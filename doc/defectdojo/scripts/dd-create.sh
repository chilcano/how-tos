#!/bin/bash

set -e

PRODUCT_NAME="${1:-JUICESHOP}"
ENGAGEMENT_NAME="${2:-INTERNAL_PENTESTING}"
PROD_TYPE_ID="${3:-}"
PROD_DESC="${4:-Product ${PRODUCT_NAME}}"

DD_HOST="${5:-https://defectdojo.tawa.local}"
DD_API_TOKEN="${6:-620dd95db61d44de8a92213e0ddb487ffdb38f51}"

echo "* PRODUCT_NAME: ${PRODUCT_NAME}"
echo "* ENGAGEMENT_NAME: ${ENGAGEMENT_NAME}"

AUTH_HEADER="Authorization: Token ${DD_API_TOKEN}"
JSON_HEADER="Content-Type: application/json"

if ! command -v jq &>/dev/null; then
  echo "jq not found. Install it for proper JSON parsing."
fi

# Select the id of 1st product_type
if [[ -z "$PROD_TYPE_ID" ]]; then
  PROD_TYPE_ID=$(curl -sk -H "$AUTH_HEADER" -H "$JSON_HEADER" ${DD_HOST}/api/v2/product_types/ | jq -r '.results[0].id')
fi

# Create the product
resp_product=$(curl -sk -X POST -H "$AUTH_HEADER" -H "$JSON_HEADER" ${DD_HOST}/api/v2/products/ \
  -d "{\"name\":\"${PRODUCT_NAME}\",\"prod_type\":${PROD_TYPE_ID},\"description\":\"${PROD_DESC}\"}")

id_product=$(echo "$resp_product" | jq -r '.id // empty')

if [[ -z "$id_product" ]]; then
  error_name=$(echo "$resp_product" | jq -r '.name[0] // empty')
  if [[ "$error_name" == *"already exists."* ]]; then
    existing_product=$(curl -sk -H "$AUTH_HEADER" -H "$JSON_HEADER" "${DD_HOST}/api/v2/products/?name=${PRODUCT_NAME}" | jq '.results[0]')
    id_product=$(echo "$existing_product" | jq -r '.id')
    echo "Product ${PRODUCT_NAME} already exists. ID=${id_product}"
  else
    echo "$resp_product" | jq .
    exit 1
  fi
else
  echo "Product created. ID=${id_product}, NAME=${PRODUCT_NAME}"
fi

START_DATE=$(date +%Y-%m-%d)
END_DATE=$(date -d '+7 days' +%Y-%m-%d)

existing_engs=$(curl -sSk -H "$AUTH_HEADER" -H "$JSON_HEADER" "${DD_HOST}/api/v2/engagements/?product=${id_product}&name=${ENGAGEMENT_NAME}")
existing_count=$(echo "$existing_engs" | jq -r '.count')

if (( existing_count > 0 )); then
  existing_engagement=$(echo "$existing_engs" | jq '.results[0]')
  id_engagement=$(echo "$existing_engagement" | jq -r '.id')
  echo "Engagement ${ENGAGEMENT_NAME} already exists. ID=${id_engagement}"
else
  resp_engagement=$(curl -sk -X POST -H "$AUTH_HEADER" -H "$JSON_HEADER" ${DD_HOST}/api/v2/engagements/ \
    -d "{\"name\":\"${ENGAGEMENT_NAME}\",\"product\":${id_product},\"target_start\":\"${START_DATE}\",\"target_end\":\"${END_DATE}\"}")
  id_engagement=$(echo "$resp_engagement" | jq -r '.id // empty')
  if [[ -z "$id_engagement" ]]; then
    echo "$resp_engagement" | jq .
    exit 1
  fi
  echo "Engagement created. ID=${id_engagement}, NAME=${ENGAGEMENT_NAME}"
fi

echo "Process completed (Product ${PRODUCT_NAME}/${id_product} and Engagement ${ENGAGEMENT_NAME}/${id_engagement})"
