# Cloudflare API Token Management

API Tokens on Cloudflare are always owned by a **user account**. If that user leaves the company and their account is removed, the token is invalidated and any automation depending on it breaks.

This guide covers the available approaches to avoid that single-point-of-failure, applicable to teams using the Cloudflare **Free Plan** and above.

> **Related guide:** [Manage Programmatically DNS through Cloudflare API](cloudflare_api_dns_guide.md)


## The Problem

When you create an API Token via **My Profile → API Tokens**, the token is bound to your personal Cloudflare user account. This creates an operational risk:

- Employee leaves → account gets removed → token is invalidated → automation fails
- No audit trail linking the token to a team or service, only to a person
- Token permissions cannot be delegated or transferred to another user


## Options Overview

| Approach | Free Plan | Survives user deletion | Effort |
|---|---|---|---|
| Dedicated Cloudflare Bot Account **(chosen)** | Yes | Yes | Low |
| Token expiration + rotation | Yes | No (mitigates risk only) | Medium |
| Account-owned tokens | No (Enterprise only) | Yes | Low |

---

## Option 1: Dedicated Cloudflare Bot Account (recommended for Free Plan)

> **This is the approach we are using.**

Create a **dedicated Cloudflare Bot Account** tied to a shared team mailbox rather than an individual. The token is then owned by that non-personal account.

### 1.1 Set up the Cloudflare Bot Account

1. Create a mailbox that survives employee turnover, e.g.:
   - `cloudflare-bot@company.com`
   - `infra-automation@company.com`
   - A Google Group or email alias that forwards to the infra team
2. Sign up for a new Cloudflare account using that email at [dash.cloudflare.com](https://dash.cloudflare.com)

### 1.2 Invite the Cloudflare Bot Account to your organization

1. In your main Cloudflare account, go to **Manage Account → Members → Invite**
2. Enter the Cloudflare Bot Account email
3. Assign the **DNS Administrator** role — or use a **custom role** scoped to the specific zone only

> **Principle of least privilege:** grant only `Zone → DNS → Edit` on the target domain. The Cloudflare Bot Account does not need billing, account settings, or other zone access.

### 1.3 Generate the API Token from the Cloudflare Bot Account

1. Log in to Cloudflare with the Cloudflare Bot Account credentials
2. Go to **My Profile → API Tokens → Create Token**
3. Use the **Edit zone DNS** template
4. Scope to the specific zone
5. Optionally set an **expiration date** (see Option 2)
6. Store the token in your secrets manager or CI/CD secrets

```bash
# Verify the token works and shows the Cloudflare Bot Account identity
curl -s "https://api.cloudflare.com/client/v4/user/tokens/verify" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | jq '{status: .result.status, id: .result.id}'
```

### 1.4 Access management going forward

- The Cloudflare Bot Account credentials (email + password) should be stored in a team password manager (e.g. 1Password, Bitwarden)
- Access to the Cloudflare Bot Account is managed separately from individual employees
- When someone leaves, only revoke their access to the password manager entry — the token and automation remain intact

---

## Option 2: Token Expiration and Rotation

This does **not** solve the account ownership problem, but limits the blast radius of an orphaned or compromised token.

### 2.1 Set an expiration date at token creation

When creating a token in the Cloudflare dashboard:

1. **My Profile → API Tokens → Create Token**
2. Expand **TTL** at the bottom of the form
3. Set a start and end date (e.g. valid for 90 or 180 days)

Cloudflare will automatically invalidate the token after the expiration date.

### 2.2 Rotation workflow with GitHub Actions Secrets

Store the token in GitHub Actions secrets and rotate it on a schedule:

```yaml
name: Rotate Cloudflare API Token

on:
  schedule:
    - cron: '0 9 1 */3 *'  # first day of every quarter at 09:00 UTC
  workflow_dispatch:         # allow manual trigger

jobs:
  rotate-token:
    runs-on: ubuntu-latest
    steps:
      - name: Create new API token via Cloudflare API
        id: create-token
        run: |
          # Create a new token (requires an Account-level token with Token:Edit permission)
          NEW_TOKEN=$(curl -s -X POST \
            "https://api.cloudflare.com/client/v4/user/tokens" \
            -H "Authorization: Bearer ${{ secrets.CF_ADMIN_TOKEN }}" \
            -H "Content-Type: application/json" \
            --data '{
              "name": "dns-automation-rotated",
              "policies": [{
                "effect": "allow",
                "resources": {"com.cloudflare.api.account.zone.*": "*"},
                "permission_groups": [{"id": "4755a26eedb94da69e1066d98aa820be"}]
              }]
            }' | jq -r '.result.value')
          echo "::add-mask::$NEW_TOKEN"
          echo "new_token=$NEW_TOKEN" >> "$GITHUB_OUTPUT"

      - name: Update GitHub secret
        env:
          GH_TOKEN: ${{ secrets.GH_TOKEN_WITH_SECRETS_WRITE }}
        run: |
          gh secret set CF_API_TOKEN --body "${{ steps.create-token.outputs.new_token }}"
```

> **Note:** Token rotation via API requires a separate admin-level token with `User → API Tokens → Edit` permission. Store that admin token separately with strict access.

### 2.3 Rotation checklist

- [ ] New token created and verified before the old one is deleted
- [ ] All consumers updated (GitHub Secrets, CI/CD, `.env` files)
- [ ] Old token explicitly revoked in the Cloudflare dashboard
- [ ] Rotation date logged in your runbook

---

## Option 3: Account-Owned Tokens (Enterprise only)

On **Cloudflare Enterprise**, tokens can be created at the **account level** and are not bound to any individual user. These persist regardless of member changes.

- Go to **Manage Account → API Tokens** (not My Profile)
- Tokens created here are owned by the organization account, not a user
- Requires an Enterprise plan — not available on Free, Pro, or Business

If your organization is on Enterprise, prefer account-level tokens over all other approaches.

---

## Comparison and Recommendation

```
Free Plan users:
  └── Use Option 1 (dedicated Cloudflare Bot Account)
      └── Optionally combine with Option 2 (token expiration) for defence-in-depth

Enterprise users:
  └── Use Option 3 (account-owned tokens) directly
```

For most teams on the Free Plan, **Option 1** alone is sufficient and low-effort. The Cloudflare Bot Account approach mirrors the standard pattern used with GitHub bot accounts — automation identity should never be tied to a human identity.

---

## References

- [Cloudflare API Tokens documentation](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
- [Cloudflare Account Members & Roles](https://developers.cloudflare.com/fundamentals/manage-account/account-security/manage-account-members/)
- [Cloudflare Token Permissions reference](https://developers.cloudflare.com/fundamentals/api/reference/permissions/)
- [Cloudflare User Tokens API](https://developers.cloudflare.com/api/operations/user-api-tokens-list-tokens)
