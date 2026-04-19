# Manage Programmatically DNS through Cloudflare API

A practical guide to create, list, update, and delete DNS records on Cloudflare programmatically — using the REST API, Python SDK, and GitHub Actions.

Use case: create subdomains on demand, e.g. `userX.my-domain.com → instanceX.cloud-provider.com`, from the Cloudflare **Free Plan**.


## 1. Prerequisites

### 1.1 Find your Zone ID

1. Log in to [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Click on your domain
3. On the **Overview** page, scroll down the right sidebar
4. There, you will see Zone ID and Account ID. Copy the **Zone ID** value

### 1.2 Create an API Token

This token must be generated from a **[Cloudflare Bot Account](cloudflare_api_token_management.md)** — a dedicated non-personal Cloudflare account owned by the team — not from an individual's account. See [Option 1: Dedicated Cloudflare Bot Account](cloudflare_api_token_management.md#option-1-dedicated-cloudflare-bot-account-recommended-for-free-plan) for setup instructions.

1. Log in with the Cloudflare Bot Account credentials
2. Go to **My Profile → API Tokens → Create API Token**
3. Use the **Edit zone DNS** template
4. Under **Zone Resources**, select **Specific zone** and select the domain from the listbox
5. Under **TTL**, define how long this token will stay active. I's unlimited if not defined
6. Click **Continue to summary → Create API Token**
7. Copy the token immediately — it is shown only once

Once generated the token, Cloudflare gives a curl command to verify such token like this:
```sh
export CF_API_TOKEN=<PASTE_HERE_YOUR_GENERATED_TOKEN>
curl "https://api.cloudflare.com/client/v4/user/tokens/verify" \
  -H "Authorization: Bearer ${CF_API_TOKEN}"
```

And you should got something like this:
```json
{
  "result": {
    "id": "f0f50de3319fe75bc4325f1937f9ea1e",
    "status": "active"
  },
  "success": true,
  "errors": [],
  "messages": [
    {
      "code": 10000,
      "message": "This API Token is valid and active",
      "type": null
    }
  ]
}
```

### 1.3 Set environment variables

```bash
export CF_API_TOKEN="your_api_token_here"
export CF_ZONE_ID="your_zone_id_here"
```

> **Note:** Store these in a `.env` file or secrets manager. Never commit them to source control.


## 2. Cloudflare REST API

All examples below use the environment variables from Section 1.

### 2.1 Create a DNS Record

> **One call is enough.** Pick the record type that matches your backend target — A or CNAME, not both.

**Option A — A record:** subdomain pointing to an **IP address**:

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data '{
    "type": "A",
    "name": "user1.my-domain.com",
    "content": "1.2.3.4",
    "ttl": 1,
    "proxied": true }' \
  | jq '.result.id'
```

**Option B — CNAME record:** subdomain pointing to a **hostname** (e.g. a cloud backend):

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data '{
    "type": "CNAME",
    "name": "user2.my-domain.com",
    "content": "instance2.cloud-provider.com",
    "ttl": 1,
    "proxied": true }' \
  | jq '.result.id'
```

| Field | Description |
|---|---|
| `name` | Full subdomain or `@` for root |
| `content` | Target IP (A) or hostname (CNAME) |
| `ttl` | `1` = auto (required when `proxied: true`) |
| `proxied` | `true` routes through Cloudflare; `false` is DNS-only |

### 2.2 List DNS Records

```bash
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq '.result[] | {id, name, type, content}'
```

Filter by name:

```bash
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records?name=user1.my-domain.com" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq '.result[] | {id, name, type, content}'
```

### 2.3 Update a DNS Record

Get the record ID from the list command above, then:

```bash
RECORD_ID="your_record_id_here"

curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${RECORD_ID}" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data '{
    "type": "CNAME",
    "name": "user1.my-domain.com",
    "content": "new-instance.cloud-provider.com",
    "ttl": 1,
    "proxied": true
  }'
```

### 2.4 Delete a DNS Record

You can get the RECORD_ID listing all DNS records
```bash
RECORD_ID="12345678......"

curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${RECORD_ID}" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" -s \
  | jq .
```


## 3. Python SDK

### 3.1 Install

```bash
# pip
pip install cloudflare

# uv
uv add cloudflare
```

### 3.2 Create records

```python
import os
import cloudflare

client = cloudflare.Cloudflare(api_token=os.environ["CF_API_TOKEN"])
zone_id = os.environ["CF_ZONE_ID"]

# Create a single CNAME record
record = client.dns.records.create(
    zone_id=zone_id,
    type="CNAME",
    name="user1.my-domain.com",
    content="instance1.cloud-provider.com",
    proxied=True,
    ttl=1,
)
print(f"Created: {record.name} -> {record.content}  (id: {record.id})")
```

### 3.3 Create N subdomains in bulk

```python
import os
import cloudflare

client = cloudflare.Cloudflare(api_token=os.environ["CF_API_TOKEN"])
zone_id = os.environ["CF_ZONE_ID"]

N = 5  # number of users/instances

for i in range(1, N + 1):
    record = client.dns.records.create(
        zone_id=zone_id,
        type="CNAME",
        name=f"user{i}.my-domain.com",
        content=f"instance{i}.cloud-provider.com",
        proxied=True,
        ttl=1,
    )
    print(f"Created: {record.name}  (id: {record.id})")
```

### 3.4 List records

```python
records = client.dns.records.list(zone_id=zone_id)

for r in records:
    print(f"{r.id}  {r.name}  {r.type}  {r.content}")
```

### 3.5 Delete a record by name

```python
# Find the record ID first
records = client.dns.records.list(zone_id=zone_id)
target_name = "user1.my-domain.com"

for r in records:
    if r.name == target_name:
        client.dns.records.delete(zone_id=zone_id, dns_record_id=r.id)
        print(f"Deleted: {r.name}")
        break
```


## 4. GitHub Actions — On-Demand Automation

Trigger subdomain creation manually via `workflow_dispatch` with user-provided inputs.

### 4.1 Workflow: create a subdomain on demand

Create `.github/workflows/create-subdomain.yml`:

```yaml
name: Create Cloudflare Subdomain

on:
  workflow_dispatch:
    inputs:
      username:
        description: "Subdomain prefix (e.g. user1)"
        required: true
      backend_host:
        description: "Target backend hostname (e.g. instance1.cloud-provider.com)"
        required: true

jobs:
  create-dns:
    runs-on: ubuntu-latest
    steps:
      - name: Create CNAME record
        run: |
          curl -s -X POST \
            "https://api.cloudflare.com/client/v4/zones/${{ secrets.CF_ZONE_ID }}/dns_records" \
            -H "Authorization: Bearer ${{ secrets.CF_API_TOKEN }}" \
            -H "Content-Type: application/json" \
            --data "{
              \"type\": \"CNAME\",
              \"name\": \"${{ inputs.username }}.my-domain.com\",
              \"content\": \"${{ inputs.backend_host }}\",
              \"ttl\": 1,
              \"proxied\": true
            }"
```

Store `CF_API_TOKEN` and `CF_ZONE_ID` in **Settings → Secrets and variables → Actions**.

> **Tip:** Add a second workflow `delete-subdomain.yml` with the same `workflow_dispatch` pattern using a GET to find the record ID, then a DELETE call.


## 5. Free Plan Limitations & Tips

| Topic | Detail |
|---|---|
| **Wildcard CNAME proxying** | `*.my-domain.com` can be created as a DNS record but Cloudflare **will not proxy** wildcard CNAMEs on Free Plan. Proxying requires Pro+. Individual records like `user1.my-domain.com` proxy fine. |
| **Rate limits** | 1200 API requests per 5 minutes per token — sufficient for bulk on-demand creation. |
| **TTL when proxied** | Must set `ttl: 1` (auto) when `proxied: true`. The actual TTL is controlled by Cloudflare. |
| **Propagation** | DNS-only records (`proxied: false`) respect the TTL you set (minimum 60 s on Free Plan). |
| **Max records** | Free Plan supports up to 1000 DNS records per zone. |


## 6. References

- [Cloudflare DNS Records API](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records)
- [Cloudflare Python SDK](https://github.com/cloudflare/cloudflare-python)
- [Cloudflare API Tokens](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
- [Cloudflare Intel API — Threat Intelligence Guide](cloudflare_intel_api_guide.md)
