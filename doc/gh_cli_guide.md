# GitHub CLI (`gh`) Guide for Ubuntu

A practical guide to install, configure, and use the GitHub CLI on Ubuntu.


## Installation

### Option 1: APT (Ubuntu 24.04+, recommended)

`gh` is available in the default Ubuntu 24.04 (Noble) universe repository — no extra sources needed:

```bash
sudo apt update && sudo apt install gh -y
```

### Option 2: Official APT repository (Ubuntu 22.04 and older)

For older Ubuntu releases where `gh` is not in the default repos:

```bash
# Install dependencies
sudo apt install -y curl gpg

# Add the GitHub CLI apt repository
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
  https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt update && sudo apt install gh -y
```

### Option 3: Snap

```bash
sudo snap install gh
```

### Verify installation

```bash
gh --version
```


## Authentication

### Login with your GitHub account

```bash
gh auth login
```

Follow the interactive prompts:
- Choose **GitHub.com** (or GitHub Enterprise)
- Select **HTTPS** or **SSH** as the preferred protocol
- Authenticate via browser or paste a token

### Login with a Personal Access Token (non-interactive)

```bash
echo "<YOUR_TOKEN>" | gh auth login --with-token
```

### Check auth status

```bash
gh auth status
```

### Logout

```bash
gh auth logout
```


## Configuration

### Set default editor

```bash
gh config set editor nano       # or vim, code, etc.
```

### Set default git protocol

```bash
gh config set git_protocol ssh  # or https
```

### View current config

```bash
gh config list
```

### Set default repository (avoids typing owner/repo repeatedly)

```bash
gh repo set-default owner/repo-name
```


## Common Use Cases

### Repositories

```bash
# Clone a repository
gh repo clone owner/repo-name

# Create a new repository
gh repo create my-new-repo --public --clone

# Create from current directory
gh repo create --source=. --public --push

# View repository info
gh repo view owner/repo-name

# Fork a repository
gh repo fork owner/repo-name --clone
```


### Pull Requests

```bash
# Create a PR from the current branch
gh pr create --title "My feature" --body "Description of changes"

# Create a PR and open browser to fill in details
gh pr create --web

# Create a draft PR
gh pr create --draft --title "WIP: my feature"

# List open PRs
gh pr list

# View a specific PR
gh pr view 42

# Check out a PR locally
gh pr checkout 42

# Merge a PR
gh pr merge 42 --squash    # or --merge, --rebase

# Review a PR
gh pr review 42 --approve
gh pr review 42 --request-changes --body "Please fix X"

# Add a comment
gh pr comment 42 --body "Looks good to me!"

# Close a PR
gh pr close 42
```


### Issues

```bash
# Create an issue
gh issue create --title "Bug: something broken" --body "Steps to reproduce..."

# List open issues
gh issue list

# Filter by label
gh issue list --label "bug"

# View an issue
gh issue view 10

# Close an issue
gh issue close 10

# Reopen an issue
gh issue reopen 10

# Add a comment
gh issue comment 10 --body "Working on this now."
```


### Workflows & Actions (CI/CD)

```bash
# List workflows
gh workflow list

# Trigger a workflow manually
gh workflow run deploy.yml

# Trigger with inputs
gh workflow run deploy.yml --field environment=staging

# View recent workflow runs
gh run list

# Watch a running workflow in real time
gh run watch

# View logs of a specific run
gh run view <run-id> --log

# Re-run a failed workflow
gh run rerun <run-id>
```


### Releases

```bash
# Create a release
gh release create v1.0.0 --title "v1.0.0" --notes "Initial release"

# Create a release and upload assets
gh release create v1.0.0 ./dist/binary.tar.gz --title "v1.0.0"

# List releases
gh release list

# Download release assets
gh release download v1.0.0
```


### Gists

```bash
# Create a public gist from a file
gh gist create myfile.sh --public

# Create a private gist with a description
gh gist create myfile.sh --desc "My startup script"

# List your gists
gh gist list

# View a gist
gh gist view <gist-id>
```


### SSH Keys

```bash
# Add an SSH key to your GitHub account
gh ssh-key add ~/.ssh/id_ed25519.pub --title "My Ubuntu machine"

# List SSH keys
gh ssh-key list
```


## Useful Tips

### Open anything in the browser

```bash
gh repo view --web
gh pr view 42 --web
gh issue view 10 --web
```

### Use output formats for scripting

```bash
# JSON output
gh pr list --json number,title,state

# Use jq to filter
gh pr list --json number,title --jq '.[].title'
```

### Alias common commands

```bash
gh alias set prl 'pr list'
gh alias set pri 'pr create'
gh alias list
```

### Get help for any command

```bash
gh help
gh pr --help
gh issue create --help
```


## References

- Official docs: https://cli.github.com/manual/
- GitHub CLI repo: https://github.com/cli/cli
