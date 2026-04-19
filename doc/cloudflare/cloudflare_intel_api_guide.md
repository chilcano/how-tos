# Cloudflare Intel API — Programmatic Threat Intelligence

A practical guide to query Cloudflare's Security Intelligence endpoints programmatically — IP reputation, domain intelligence, WHOIS, passive DNS, and ASN data.

> **Related guides:**
> - [Manage Programmatically DNS through Cloudflare API](cloudflare_api_dns_guide.md)
> - [Cloudflare API Token Management](cloudflare_api_token_management.md)


## 1. Prerequisites

### 1.1 Find your Account ID

The Intel API uses the **Account ID**, not the Zone ID used in the DNS API. These are two different identifiers:

| Identifier | Scope | Used in |
|---|---|---|
| **Zone ID** | A specific domain | DNS record API |
| **Account ID** | The top-level account owning all zones | Intel API, Account-level APIs |

**Option A — Cloudflare Dashboard:**

1. Log in to [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Click on any domain
3. On the **Overview** page, scroll down the right sidebar
4. You will see both **Zone ID** and **Account ID** listed there. Copy the **Account ID**

**Option B — via API** (if you already have a valid token):

```bash
curl -s "https://api.cloudflare.com/client/v4/accounts" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq '.result[] | {id, name}'
```

Example output:
```json
{
  "id": "98f79ac9757589a26bc43be96b35397e",
  "name": "My Cloudflare Account"
}
```

Set it as an environment variable:

```bash
export CF_ACCOUNT_ID="98f79ac9757589a26bc43be96b35397e"
```

### 1.2 Create an API Token with Intel permissions

The DNS token (Edit zone DNS) is **not sufficient** for the Intel API. You need a separate token with Intel read access.

1. Log in with the [Cloudflare Bot Account](cloudflare_api_token_management.md) credentials
2. Go to **My Profile → API Tokens → Create Token**
3. Choose **Create Custom Token**
4. Under **Permissions**, add:
   - `Account` → `Security Insights` → `Read`
5. Under **Account Resources**, select your specific account
6. Click **Continue to summary → Create Token**

> **Note:** The Intel API requires at minimum a **Pro plan**. Some endpoints (domain history, passive DNS, indicator feeds) require **Business or Enterprise**. Queries against the Free Plan will return `403 Forbidden` or empty results for restricted endpoints.

Verify the token:

```bash
curl -s "https://api.cloudflare.com/client/v4/user/tokens/verify" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq '{status: .result.status, id: .result.id}'
```

### 1.3 Set environment variables

```bash
export CF_API_TOKEN="your_api_token_here"
export CF_ACCOUNT_ID="your_account_id_here"
```


## 2. IP Intelligence

Query reputation, threat classification, and ASN information for a given IP address.

```bash
curl -s "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/intel/ip?ipv4=3.136.131.65" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq .
```

Key fields in the response:

```json
{
  "ip": "3.136.131.65",
  "belongs_to_ref": {
    "type": "hosting_provider",
    "country": "US",
    "description": "Amazon Technologies Inc."
  },
  "risk_types": [
    { "name": "Spam" },
    { "name": "Scanner" }
  ]
}
```

| Field | Description |
|---|---|
| `belongs_to_ref` | ASN / organization owning the IP |
| `risk_types` | Known threat categories associated with the IP |
| `ptr_lookup` | Reverse DNS name (if available) |

Query an IPv6 address using the `ipv6` parameter instead:

```bash
curl -s "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/intel/ip?ipv6=2606:4700:4700::1111" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq .
```


## 3. Domain Intelligence

Query risk score, categories, and threat classification for a domain.

```bash
curl -s "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/intel/domain?domain=cloudflare.com" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq .
```

Key fields in the response:

```json
{
  "domain": "cloudflare.com",
  "risk_score": 0,
  "risk_types": [],
  "content_categories": [
    { "name": "Technology" }
  ],
  "additional_information": {
    "suspected_malware_family": ""
  }
}
```

| Field | Description |
|---|---|
| `risk_score` | 0 (clean) to 100 (high risk) |
| `risk_types` | Threat categories (e.g. Phishing, Malware C2) |
| `content_categories` | Content classification of the domain |
| `suspected_malware_family` | Malware family name if identified |


## 4. Domain History

Retrieve the historical registration and hosting data for a domain. Useful to detect recently registered or re-registered domains.

```bash
curl -s "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/intel/domain-history?domain=example.com" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq .
```

> **Plan requirement:** Business or Enterprise plan.


## 5. WHOIS Lookup

Retrieve WHOIS registration data for a domain.

```bash
curl -s "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/intel/whois?domain=cloudflare.com" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq '{registrar, created_date, updated_date, expiration_date, nameservers}'
```

Example output:

```json
{
  "registrar": "MarkMonitor, Inc.",
  "created_date": "2009-02-17",
  "updated_date": "2023-11-13",
  "expiration_date": "2031-02-17",
  "nameservers": ["ns3.cloudflare.com", "ns4.cloudflare.com"]
}
```


## 6. Passive DNS

Query passive DNS records observed for a domain — useful to see historical IP resolutions.

```bash
curl -s "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/intel/dns?domain=cloudflare.com" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq '.result[] | {type, value, first_seen, last_seen}'
```

> **Plan requirement:** Business or Enterprise plan.


## 7. ASN Intelligence

Query threat classification and ownership details for an Autonomous System Number.

```bash
# Replace 13335 with the ASN you want to query
curl -s "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/intel/asn/13335" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq .
```

Example output:

```json
{
  "asn": 13335,
  "description": "CLOUDFLARENET",
  "country": "US",
  "risk_score": 0,
  "type": "hosting_provider"
}
```


## 8. Plan Requirements Summary

| Endpoint | Free | Pro | Business | Enterprise |
|---|---|---|---|---|
| IP Intelligence | No | Yes | Yes | Yes |
| Domain Intelligence | No | Yes | Yes | Yes |
| WHOIS | No | Yes | Yes | Yes |
| ASN Intelligence | No | Yes | Yes | Yes |
| Domain History | No | No | Yes | Yes |
| Passive DNS | No | No | Yes | Yes |

> **Free Plan limitation:** All Intel API endpoints require at minimum a **Pro plan**. Free Plan accounts receive `403 Forbidden` or empty results.


## 9. References

- [Cloudflare Intel API — IP Intelligence](https://developers.cloudflare.com/api/operations/ip-intelligence-get-ip-overview)
- [Cloudflare Intel API — Domain Intelligence](https://developers.cloudflare.com/api/operations/domain-intelligence-get-domain-details)
- [Cloudflare Intel API — WHOIS](https://developers.cloudflare.com/api/operations/whois-record-get-whois-record)
- [Cloudflare Security Center overview](https://developers.cloudflare.com/security-center/)
- [Cloudflare API Token Management](cloudflare_api_token_management.md)
