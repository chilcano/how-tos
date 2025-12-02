#!/usr/bin/env python3
import os
import sys
import json
import re
import subprocess
from pathlib import Path

RED="\033[31m"; YELLOW="\033[33m"; BLUE="\033[34m"; BOLD="\033[1m"; GREEN="\033[32m"; RESET="\033[0m"

def print_usage():
    print("Usage:")
    print("  python3 scan_iocs_local_repo.py <org/repo> [branch] <ioc_rules.json>")
    print("  python3 scan_iocs_local_repo.py <local-path> <ioc_rules.json>")
    print("Examples:")
    print("  python3 scan_iocs_local_repo.py zama-ai/fhevm main iocs.json")
    print("  python3 scan_iocs_local_repo.py zama-ai/fhevm iocs.json")
    print("  python3 scan_iocs_local_repo.py ./repo iocs.json")

def run(cmd, cwd=None, silent=True):
    try:
        if silent:
            r = subprocess.check_output(cmd, cwd=cwd, stderr=subprocess.DEVNULL)
        else:
            r = subprocess.check_output(cmd, cwd=cwd)
        return r.decode().strip()
    except:
        return None

def safe_update_branch(repo_path, branch):
    run(["git", "fetch", "origin", branch], cwd=repo_path, silent=False)
    exists = run(["git", "rev-parse", "--verify", branch], cwd=repo_path)
    if exists is None:
        if run(["git","checkout","-b",branch,f"origin/{branch}"],cwd=repo_path,silent=False) is None:
            print(f"{RED}ERROR: cannot create local branch '{branch}'{RESET}")
            sys.exit(1)
    else:
        if run(["git","checkout",branch],cwd=repo_path,silent=False) is None:
            print(f"{RED}ERROR: cannot checkout '{branch}'{RESET}")
            sys.exit(1)
    run(["git","reset","--hard",f"origin/{branch}"],cwd=repo_path,silent=False)

def clone_to_cache(repo_full, branch):
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        print(f"{RED}ERROR: GITHUB_TOKEN not set{RESET}"); sys.exit(1)

    cache_branch = branch if branch else "default"
    cache_dir = Path.home()/".cache"/"iocscan"/repo_full/cache_branch
    cache_dir_str = str(cache_dir)
    safe_url = f"https://github.com/{repo_full}.git"
    auth_url = f"https://{token}:x-oauth-basic@github.com/{repo_full}.git"

    if not cache_dir.exists():
        cache_dir.mkdir(parents=True, exist_ok=True)
        print(f"Cloning fresh repository into cache: $HOME/.cache/iocscan/{repo_full}/{cache_branch}")
        cmd=["git","clone","--depth","1"]
        if branch: cmd+=["--branch",branch]
        cmd+=[auth_url,cache_dir_str]
        try:
            subprocess.run(cmd,check=True,stdout=subprocess.DEVNULL,stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
            print(f"{RED}ERROR: clone failed{RESET}"); print(e.stderr.decode()); sys.exit(1)
        if branch: safe_update_branch(cache_dir_str, branch)
        return cache_dir_str

    print(f"Using cached repository: $HOME/.cache/iocscan/{repo_full}/{cache_branch}")

    if not (cache_dir/".git").exists():
        subprocess.call(["rm","-rf",cache_dir_str])
        return clone_to_cache(repo_full, branch)

    remote = run(["git","remote","get-url","origin"],cwd=cache_dir_str)
    if remote and repo_full not in remote:
        subprocess.call(["rm","-rf",cache_dir_str])
        return clone_to_cache(repo_full, branch)

    if branch:
        safe_update_branch(cache_dir_str, branch)
    else:
        run(["git","fetch"],cwd=cache_dir_str,silent=False)
        run(["git","pull"],cwd=cache_dir_str,silent=False)

    return cache_dir_str

def get_git_metadata(repo_path, fallback=None):
    remote = run(["git","remote","get-url","origin"],cwd=repo_path)
    repo_full=None
    if remote and "github.com" in remote:
        part=remote.split("github.com/")[-1]
        if part.endswith(".git"): part=part[:-4]
        repo_full=part.strip()
    if not repo_full: repo_full=fallback

    branch=run(["git","rev-parse","--abbrev-ref","HEAD"],cwd=repo_path,silent=False)
    if not branch or branch=="HEAD":
        head=run(["git","symbolic-ref","refs/remotes/origin/HEAD"],cwd=repo_path)
        if head and "origin/" in head: branch=head.split("origin/")[-1]
        else: branch="unknown"

    commit=run(["git","rev-parse","HEAD"],cwd=repo_path,silent=False)
    if not commit: commit="unknown"

    return repo_full, branch, commit

def load_ioc_rules(path):
    with open(path,"r") as f: data=json.load(f)
    return data["ioc_rules"],data.get("metadata",{})

def build_github_urls(repo, branch, commit, rel, line):
    b=branch if branch!="unknown" else "main"
    u1=f"https://github.com/{repo}/blob/{b}/{rel}#L{line}"
    u2=f"https://github.com/{repo}/blob/{commit}/{rel}#L{line}" if commit!="unknown" else None
    return u1,u2

def scan_file_for_iocs(path, rules, ctx=2, max_len=200):
    out=[]
    try:
        with open(path,"r",encoding="utf-8",errors="ignore") as f:
            content=f.read()
    except:
        return out
    if not content: return out

    lines=content.splitlines(keepends=True)
    starts=[]; off=0
    for ln in lines:
        starts.append(off); off+=len(ln)

    def line_of(p):
        for i,s in enumerate(starts):
            if i+1<len(starts) and s<=p<starts[i+1]: return i
        return len(starts)-1

    for r in rules:
        pat=re.compile(r["regex"],re.IGNORECASE|re.MULTILINE|re.DOTALL)
        for m in pat.finditer(content):
            s,e=m.start(),m.end()
            idx=line_of(s)
            ln=idx+1
            snip=content[s:e].replace("\n","\\n")
            if len(snip)>max_len: snip=snip[:max_len]+"..."
            cs=max(0,idx-ctx); ce=min(len(lines),idx+ctx+1)
            ctx_block="".join(lines[cs:ce]).rstrip("\n")
            out.append({"rule_id":r["id"],"description":r["description"],"line":ln,"snippet":snip,"context":ctx_block})
    return out

def scan_repo(path, rules):
    results=[]; count=0
    for root,dirs,files in os.walk(path):
        if ".git" in dirs: dirs.remove(".git")
        for f in files:
            count+=1
            full=os.path.join(root,f)
            rel=os.path.relpath(full,path)
            det=scan_file_for_iocs(full,rules)
            if det: results.append({"file":rel,"matches":det})
    return results,count

def main():
    if len(sys.argv)<3 or len(sys.argv)>4:
        print_usage(); sys.exit(1)

    target=sys.argv[1]
    ioc_json=sys.argv[-1]

    rules,meta=load_ioc_rules(ioc_json)
    print(f"Using IOC file: {ioc_json} ({len(rules)} rules)")
    print(f"Campaign: {meta.get('campaign','N/A')}")
    print(f"Date:     {meta.get('date','N/A')}")
    print("")

    branch=None
    if os.path.isdir(target):
        repo_path=target
        repo_full=None
    else:
        if "/" not in target:
            print(f"{RED}ERROR: repo must be org/repo{RESET}"); sys.exit(1)
        repo_full=target
        branch=sys.argv[2] if len(sys.argv)==4 else None
        repo_path=clone_to_cache(repo_full,branch)

    repo_full,branch_name,commit_hash=get_git_metadata(repo_path,fallback=repo_full)

    print("Scanning Local Repository")
    print(f"Repo:   https://github.com/{repo_full}")
    print(f"Branch: {branch_name}")
    print(f"Commit: {commit_hash}")
    print(f"GitHub: https://github.com/{repo_full}")
    print("")

    results,count=scan_repo(repo_path,rules)
    print(f"Total files scanned: {count}")

    if not results:
        print(f"{GREEN}No IOCs detected.{RESET}")
        return

    print(f"{BOLD}{RED}=== IOCs Detected ==={RESET}")
    for r in results:
        print(f"\n{BOLD}File:{RESET} {r['file']}")
        for m in r["matches"]:
            print(f"  {RED}- Rule:{RESET} {m['rule_id']} {YELLOW}({m['description']}){RESET}")
            print(f"    Line: {m['line']}")
            print(f"    Matched: {YELLOW}{m['snippet']}{RESET}")
            print("    Context:")
            for line in m["context"].splitlines():
                print(f"      {line}")
            b,c=build_github_urls(repo_full,branch_name,commit_hash,r["file"],m["line"])
            print(f"    {BLUE}GitHub (branch):{RESET} {b}")
            if c: print(f"    {BLUE}GitHub (commit):{RESET} {c}")

    print("\nScan completed.")

if __name__=="__main__":
    main()
