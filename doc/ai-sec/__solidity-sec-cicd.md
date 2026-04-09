# Secure CI/CD for Solidity Smart Contracts

## Benefits

This model centralizes:
1. Security standards
2. Deployment governance
3. Contract address registry
4. Multi-repo enforcement


# Security Checks, workflows and specs

## 1. Mandatory Checks (Run on Every PR)

These checks are executed via reusable callable workflows hosted in: 
`contracts-registry/.github/workflows/`

Example:
- `secure-ci-callable-1.yml`
- `secure-ci-callable-2.yml`
- `secure-ci-callable-3.yml`

Each contract repository calls these workflows using `workflow_call`.


### 1. Formatting & Linting

**Tools:**
- `forge fmt`
- `solhint`

**Checks:**
- No formatting violations
- No lint violations


### 2. Deterministic Compilation

**Tools:**
- `forge build`
- `hardhat compile`

**Checks:**
- Exact `solc` version pinned in config (`foundry.toml` or `hardhat.config`)
- Optimizer settings fixed (enabled + runs) in config
- Consistent IR configuration if used (always on or always off, same setting across CI/CD)
- No loose pragma ranges
- Build must be deterministic


### 3. Unit Tests

**Tools:**
- `forge test`
- `hardhat test`

**Checks:**
- All tests pass
- Critical logic validated
- Access control properly tested


### 4. Coverage Gate

**Tools:**
- `forge coverage`
- `solidity-coverage`

**Checks:**
- Minimum coverage threshold enforced
- No untested critical flows


### 5. Static Analysis (SAST)

**Tool:**
- `slither`

**Checks:**
- No high/critical findings
- Medium findings reviewed
- Custom rules enforced (e.g. no `tx.origin`, unsafe `delegatecall`)

### 6. Software Composition Analysis (SCA) / Dependency Integrity

**Tools:**
- `npm audit` / `pnpm audit`
- Lockfile verification

**Checks:**
- No vulnerable dependencies
- Lockfile modifications reviewed


### 7. Quick Fuzzing

**Tool:**
- Foundry invariants / fuzzing (`forge test`)
- Veridise OrCa, Echidna

**Checks:**
- Short fuzz execution
- No invariant violations
- No unexpected reverts


### 8. Upgradeability Safety (if applicable)

**Tools:**
- OpenZeppelin Upgrades Plugin

**Checks:**
- Storage layout compatibility
- Proxy configuration valid
- No storage collisions

### 9. AI-assisted Security Triage

**Tools:**
- Slither (`--json` output)
- LLM reviewer (Claude / ChatGPT) using PR diff + Slither findings

**Checks:**
- Classify each Slither finding as:
  - Action Required
  - Needs Review
  - Benign / False Positive
- Provide short contextual justification (code-aware)
- Suggest missing invariant tests where applicable
- Output:
  - `ai-triage.json` (machine-readable)
  - PR comment / artifact (human-readable)


## 2. Nightly / Extended Security Checks

Executed via scheduled workflows, either centrally in `contracts-registry` or per contract repository.


### 1. Property-Based Testing

**Tool:**
- Foundry invariants / fuzzing (`forge test`)
- Veridise OrCa, Echidna

**Checks:**
- Deep invariant validation
- No invariant violations
- Higher iteration budget
- Edge-case behavior validation


### 2. Symbolic Analysis

**Tool:**
- Mythril, ToB Manticore 

**Checks:**
- Path exploration
- State transition analysis


### 3. Fork-Based Integration Testing

**Tools:**
- Foundry fork mode
- Hardhat mainnet fork

**Checks:**
- Live protocol interaction
- Oracle correctness
- Upgrade simulations


### 4. Bytecode Reproducibility Check

**Checks:**
- Compiled bytecode hash matches artifact
- No environment drift


## 3. Central contracts-registry spec

The central repository follow this structure:
```
contracts-registry/
├── mainnet/
├── testnet/
├── schema.json
└── .github/
    └── workflows/
        ├── secure-ci-callable-1.yml
        ├── secure-ci-callable-2.yml
        ├── secure-ci-callable-3.yml
        ├── secure-cd-mainnet.yml
        └── secure-cd-testnet.yml
```

Each deployment produces a JSON artifact:

```json
{
  "contract": "MyToken",
  "network": "mainnet",
  "address": "0x123...",
  "deploymentCommit": "abc123",
  "bytecodeHash": "0x...",
  "abiHash": "0x...",
  "proxy": {
    "type": "UUPS",
    "implementation": "0x456..."
  },
  "deployer": "0xDeployer...",
  "timestamp": "2026-02-18T10:00:00Z"
}
```

### 1. Registry Validation CI

Triggered when a PR modifies `contracts-registry`. It validates:
1. JSON schema compliance
2. Mainnet immutability (no modification of existing entries)
3. No deletion of historical deployments
4. Network policy enforcement
5. Optional bytecode-on-chain verification
6. Ensure PR author is deployment bot or authorized workflow

## 4. Secure-CI Model (Callable Workflows)

Each contract repository contains a minimal workflow:

```yaml
jobs:
  secure-ci:
    uses: zama-ai/contracts-registry/.github/workflows/secure-ci-callable-1.yml@v1
```

1. All mandatory PR checks
2. Reads `contracts-registry` (read-only)
3. Validates:
    - Contract authorized for deployment
    - Target network allowed
    - Versioning rules respected
    - Proxy type compliant
    - No forbidden hardcoded addresses
4. Validates deterministic build output:
    - Bytecode hash computed in CI must match expected deterministic build
    - No uncommitted artifacts
    - No diff between build outputs across runs
    - Secure-CI does not modify registry data.

Secure-CI does not modify registry data.


## 5. Secure-CD Model (Centralized Deployment)

Deployment workflows are centralized inside `contracts-registry`:

* `secure-cd-testnet.yml`
* `secure-cd-mainnet.yml`

Flow:
1. Triggered after merge or via release event
2. Fetch contract repo artifact
3. Re-run deterministic compilation
4. - Ensure deployed commit SHA matches previously validated commit
5. Deploy contract
6. Verify contract on explorer
7. Compute:
    - Bytecode hash
    - ABI hash
8. Generate deployment metadata JSON
9. Open Pull Request against `contracts-registry`
10. Registry validation CI executes automatically
11. Merge registry PR

Deployment is finalized only after registry update is merged.


## 6. End-to-End Flow

```
Developer → PR (contract repo)
↓
Secure-CI (callable workflow from contracts-registry)
↓
Merge
↓
Secure-CD (centralized workflow in contracts-registry)
↓
Registry update PR
↓
Registry validation CI
↓
Merge
```
