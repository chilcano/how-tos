#!/usr/bin/env python3
import os
import sys
import json
import base64
import urllib.request
import urllib.error

# ---------------------------------------------------------
# Usage helper
# ---------------------------------------------------------

def print_usage():
    print("Usage:")
    print("  python3 scan_vuln_pkgs_in_repo.py <owner/repo> <vulnerable_packages.json> [scan-mode]")
    print("")
    print("Scan modes:")
    print("  --root-only        (default) scans ONLY the root package.json")
    print("  --recursive        scans ALL package.json files in the repo")
    print("  --workspace        detects Yarn/Pnpm workspace definitions")
    print("  --lockfile-only    scans dependencies from lockfiles only")
    print("")
    print("Examples:")
    print("  python3 scan_vuln_pkgs_in_repo.py vercel/next.js vulns.json")
    print("  python3 scan_vuln_pkgs_in_repo.py vercel/next.js vulns.json --recursive")
    print("")


# ---------------------------------------------------------
# Load vulnerable packages JSON
# ---------------------------------------------------------

def load_vulnerable_packages(path: str):
    if not os.path.exists(path):
        raise FileNotFoundError(f"Vulnerability file not found: {path}")

    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)

    if "packages" not in data:
        raise ValueError("Invalid JSON: missing 'packages' field")

    pkgs = data["packages"]

    unique = len(pkgs)
    total_vuln_versions = sum(len(v) for v in pkgs.values())

    print(f"Using {path} ({unique} unique packages, {total_vuln_versions} total vulnerable versions)")

    # Metadata (optional but recommended)
    meta = data.get("metadata", {})
    if meta:
        print(f"Source:   {meta.get('source', 'N/A')}")
        print(f"Campaign: {meta.get('campaign', 'N/A')}")
        print(f"Date:     {meta.get('date', 'N/A')}")
        print("")

    return pkgs


GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")


# ---------------------------------------------------------
# GitHub API wrapper
# ---------------------------------------------------------

def github_api(url: str):
    req = urllib.request.Request(url)
    req.add_header("Accept", "application/vnd.github+json")

    if GITHUB_TOKEN:
        req.add_header("Authorization", f"token {GITHUB_TOKEN}")

    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        errmsg = e.read().decode("utf-8")
        raise RuntimeError(f"GitHub API Error {e.code}: {errmsg}")


# ---------------------------------------------------------
# List all repository files (recursive tree API)
# ---------------------------------------------------------

def list_repo_files(repo):
    url = f"https://api.github.com/repos/{repo}/git/trees/HEAD?recursive=1"
    data = github_api(url)
    return [item["path"] for item in data.get("tree", [])]


# ---------------------------------------------------------
# Fetch a file from repo
# ---------------------------------------------------------

def fetch_file(repo, path):
    url = f"https://api.github.com/repos/{repo}/contents/{path}"
    data = github_api(url)
    if "content" not in data:
        raise RuntimeError(f"Missing 'content' for file: {path}")
    return base64.b64decode(data["content"]).decode("utf-8")


# ---------------------------------------------------------
# Version normalization
# ---------------------------------------------------------

def normalize_version(v: str) -> str:
    for t in ["^", "~", ">=", "<=", " "]:
        v = v.replace(t, "")
    return v.strip()


# ---------------------------------------------------------
# Scan package.json
# ---------------------------------------------------------

def scan_package_json(content, vulnerable_pkgs, filename):
    pkg = json.loads(content)
    deps = pkg.get("dependencies", {})
    dev = pkg.get("devDependencies", {})
    combined = {**deps, **dev}

    print(f"\nScanning {filename}")
    print("-----------------------------------------------")

    found_vuln = False

    for name, bad_versions in vulnerable_pkgs.items():
        if name not in combined:
            continue

        installed = normalize_version(combined[name])
        print(f"Found: {name}@{installed}")

        if installed in bad_versions:
            found_vuln = True
            print(f">>> 🚨 VULNERABLE VERSION DETECTED: {name}@{installed}")
        else:
            print(">>> ⚠️ Present but NOT vulnerable (safe version)")

        print()

    if not found_vuln:
        print("No vulnerable versions detected in this file.")


# ---------------------------------------------------------
# Scan lockfiles (lightweight string matching)
# ---------------------------------------------------------

def scan_lockfile(content, vulnerable_pkgs, filename):
    print(f"\nScanning lockfile: {filename}")
    print("-----------------------------------------------")

    found_any = False
    for package in vulnerable_pkgs:
        if package in content:
            found_any = True
            print(f"Found package in lockfile (string match): {package}")

    if not found_any:
        print("No vulnerable packages present in lockfile.")


# ---------------------------------------------------------
# Main scan handler
# ---------------------------------------------------------

def run_scan(repo, vuln_file, mode):
    vulnerable_pkgs = load_vulnerable_packages(vuln_file)

    files = list_repo_files(repo)

    # MODE: root-only
    if mode == "--root-only":
        if "package.json" not in files:
            print("ERROR: repo has NO root package.json")
            return
        content = fetch_file(repo, "package.json")
        scan_package_json(content, vulnerable_pkgs, "package.json")
        return

    # MODE: recursive
    if mode == "--recursive":
        json_files = [f for f in files if f.endswith("package.json")]
        if not json_files:
            print("No package.json files found in repo.")
            return
        for fpath in json_files:
            content = fetch_file(repo, fpath)
            scan_package_json(content, vulnerable_pkgs, fpath)
        return

    # MODE: workspace
    if mode == "--workspace":
        if "package.json" not in files:
            print("ERROR: root package.json missing.")
            return

        root = json.loads(fetch_file(repo, "package.json"))
        ws_patterns = root.get("workspaces", [])
        if not ws_patterns:
            print("No workspaces found.")
            return

        matched = []
        for ws in ws_patterns:
            ws = ws.replace("/*", "")
            for f in files:
                if f.startswith(ws) and f.endswith("package.json"):
                    matched.append(f)

        for fpath in matched:
            content = fetch_file(repo, fpath)
            scan_package_json(content, vulnerable_pkgs, fpath)
        return

    # MODE: lockfile-only
    if mode == "--lockfile-only":
        lockfiles = [f for f in files if f in ("package-lock.json", "yarn.lock", "pnpm-lock.yaml")]
        if not lockfiles:
            print("No lockfiles found.")
            return

        for lf in lockfiles:
            content = fetch_file(repo, lf)
            scan_lockfile(content, vulnerable_pkgs, lf)
        return

    print(f"ERROR: Unknown scan mode: {mode}")
    print_usage()


# ---------------------------------------------------------
# Entry
# ---------------------------------------------------------

def main():
    if len(sys.argv) < 3:
        print("ERROR: incorrect number of arguments.\n")
        print_usage()
        sys.exit(1)

    repo = sys.argv[1]
    vuln_file = sys.argv[2]
    mode = "--root-only" if len(sys.argv) < 4 else sys.argv[3]

    run_scan(repo, vuln_file, mode)


if __name__ == "__main__":
    main()
