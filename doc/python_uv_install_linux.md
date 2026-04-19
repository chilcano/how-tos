# Switching to `uv` on Ubuntu 24.04

> **Target version:** `uv` 0.11.6 (latest stable)

---

## 1. Install `uv` (pinned to 0.11.6)

```bash
curl -LsSf https://astral.sh/uv/install.sh | UV_VERSION=0.11.6 sh
```

Then reload your shell:

```bash
source ~/.bashrc   # or ~/.zshrc if using zsh
```

Verify the installed version:

```bash
uv --version
# Expected: uv 0.11.6
```

---

## 2. What changes

Ubuntu 24.04 ships Python 3.12 system-wide (`/usr/bin/python3`). With `uv`, you stop relying on that for your projects — `uv` manages its own Python versions and per-project virtual environments automatically. The system Python is left completely untouched.

`uv` operates independently under `~/.local/share/uv/`.

---

## 3. Install a Python version via `uv`

```bash
uv python install 3.12   # or 3.11, 3.13, etc.
uv python list           # see all available/installed versions
```

---

## 4. Core workflow

### Create a new project

```bash
uv init my-project
cd my-project
```

This creates a `pyproject.toml`, a `.python-version` file, and a ready-to-use project layout.

### Create a virtual environment

```bash
uv venv                        # creates .venv in current directory
source .venv/bin/activate
```

### Add dependencies

```bash
uv add requests pandas    # replaces: pip install requests pandas
```

This updates `pyproject.toml` and `uv.lock` automatically.

### Run a script or tool

```bash
uv run main.py            # replaces: python main.py
```

`uv run` ensures the venv is up to date before running — no manual `activate` needed.

### Sync dependencies

```bash
uv sync                   # replaces: pip install -r requirements.txt
```

---

## 5. Practical examples

### Replace a one-off `pip install` + script run

```bash
# Before
python3 -m venv .venv && source .venv/bin/activate
pip install httpx
python3 fetch.py

# After
uv run --with httpx fetch.py   # no venv setup, no activation
```

### Pin a specific Python version per project

```bash
uv init my-api
cd my-api
uv python pin 3.11        # writes .python-version → 3.11
uv run app.py             # always uses 3.11
```

### Run a CLI tool without installing it globally

```bash
uv tool run ruff check .      # replaces: pipx run ruff check .
uv tool run black .
```

### Convert an existing project with `requirements.txt`

```bash
cd existing-project
uv init --no-readme          # adds pyproject.toml
uv add $(cat requirements.txt | grep -v '#' | tr '\n' ' ')
```

---

## 6. Optional: alias for muscle memory

If you keep typing `pip`, add this to your `~/.bashrc`:

```bash
alias pip="uv pip"
```

`uv pip` is a drop-in compatible interface — `uv pip install`, `uv pip freeze`, etc. all work as expected.

---

## 7. Command reference

| Old habit | `uv` equivalent |
|---|---|
| `python3 -m venv .venv` + `source .venv/bin/activate` | `uv sync` or `uv run` (auto-managed) |
| `pip install X` | `uv add X` |
| `pip install -r requirements.txt` | `uv sync` |
| `python script.py` | `uv run script.py` |
| `pipx run tool` | `uv tool run tool` |

---

## 8. Upgrading `uv` later

When a new version is released, update with:

```bash
uv self update
```

To pin to a specific version again:

```bash
curl -LsSf https://astral.sh/uv/install.sh | UV_VERSION=<new-version> sh
```

---

## 9. Troubleshooting: `uv pip install` — no virtual environment found

Running `uv pip install <package>` will error if no venv is active. Three ways to fix it:

**A — Activate your venv first (recommended)**
```bash
source .venv/bin/activate
uv pip install <package>
```

**B — Install system-wide**
```bash
uv pip install <package> --system
```

**C — Use `uv add` (idiomatic, inside a project)**
```bash
uv add <package>   # updates pyproject.toml + uv.lock automatically
```

> Prefer `uv add` for project dependencies, `uv tool install` for global CLI tools, and `--system` only for quick one-offs.

---

*Guide based on uv 0.11.6 — Ubuntu 24.04*

Configuration file(s) changed: Dockerfile-fw-proxy, devcontainer.json. The container might need to be rebuilt to apply the changes.

