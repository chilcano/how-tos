# Solidity Smart Contract Deployment Audit

## 1. Install tools

### 1.1. Install foundry

```sh

curl -L https://foundry.paradigm.xyz | bash
foundryup
foundryup -i nightly

```

### 1.2. Install a python, pipx and deployguard

**1. Install Python**
```sh
$ sudo apt install -y pipx python3-full
$ pipx ensurepath
```

**2. Install DeployGuard**

- https://github.com/0xstormblessed/deployguard

```sh
$ pipx install deployguard

  installed package deployguard 0.1.2, installed using Python 3.12.3
  These apps are now globally available
    - deployguard
done! ✨ 🌟 ✨

$ deployguard --help

Usage: deployguard [OPTIONS] COMMAND [ARGS]...

  DeployGuard - Audit Foundry deployment scripts for security vulnerabilities.

Options:
  --version  Show the version and exit.
  --help     Show this message and exit.

Commands:
  audit   Analyze deployment scripts for security vulnerabilities.
  check   Check test coverage for deployment scripts.
  rules   List all available rules.
  verify  Verify deployed proxy against expected implementation.
```

**3. Audit the SC deployment process**

- The `deployguard` looks for `foundry.toml`.

```sh
$ git clone https://github.com/zama-ai/fhevm

$ cd fhevm

$ find . -type f -name foundry.toml -exec sh -c 'deployguard audit "$(dirname "{}")"' \;

```

