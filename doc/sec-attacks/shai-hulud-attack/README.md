# Scan Repo for vuln npm packages

## Why this?

Because this recently massive attack:

* https://posthog.com/blog/nov-24-shai-hulud-attack-post-mortem
* https://socket.dev/blog/shai-hulud-strikes-again-v2
* https://www.wiz.io/blog/shai-hulud-2-0-ongoing-supply-chain-attack


Then, the next scripts:

- The next scripts only allow to check if your Github repo has been compromised.
- It looks for Indicators of Compromise (IoCs) such as vulnerable npm packages and traces of malicious activity.


## Scripts 

### Running the scripts

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
