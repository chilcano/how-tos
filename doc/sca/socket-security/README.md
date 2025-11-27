# Playing with Socket Security

## 1. Rust, NodeJS, Python env setup

### 1.1. Install Rust env

```sh
# rust env setup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# This installs:
# * cargo → build & package manager
# * rustc → Rust compiler
# * rustup → toolchain updater

$ cargo -V
cargo 1.91.1 (ea2d97820 2025-10-10)

$ rustc -V
rustc 1.91.1 (ed61e7d7e 2025-11-07)

$ rustup -V
rustup 1.28.2 (e4f3ad6f8 2025-04-28)
info: This is the version for the rustup toolchain manager, not the rustc compiler.
info: The currently active `rustc` version is `rustc 1.91.1 (ed61e7d7e 2025-11-07)`

```

## 2. Free Socket Firewall

* https://socket.dev/blog/introducing-socket-firewall
* https://docs.socket.dev/docs/socket-firewall-free

### 2.1. Install

```sh
curl -L -o sfw https://github.com/SocketDev/sfw-free/releases/latest/download/sfw-free-linux-x86_64
chmod +x sfw
sudo mv sfw /usr/local/bin/

sfw -v

Socket Firewall Free, version 1.1.1
```

### 2.2. Running the tool against a repo nodejs and rust

```sh
cd /home/chilcano/repos/zama-ai/console/apps/back

# npm 
npm cache clean --force # force to clean local cache
sfw pnpm install

# cargo
cargo clean gc # clear only unused packages (unstable channel)
rm -fr ~/.cargo/registry ~/.cargo/git # clear all cached packages
sfw cargo fetch
```

## 3. Socket CLI

* https://github.com/SocketDev/socket-cli
* https://docs.socket.dev/docs/socket-cli

### 3.1. Install

```sh
$ pnpm install -g socket
 WARN  1 deprecated subdependencies found: path-match@1.2.4
Packages: +1
+
Progress: resolved 253, reused 233, downloaded 1, added 1, done

/home/chilcano/.local/share/pnpm/global/5:
+ socket 1.1.38

╭ Warning ──────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                               │
│   Ignored build scripts: esbuild.                                                             │
│   Run "pnpm approve-builds -g" to pick which dependencies should be allowed to run scripts.   │
│                                                                                               │
╰───────────────────────────────────────────────────────────────────────────────────────────────╯

Done in 1s using pnpm v10.12.4
```

And apply the changes:
```sh
$ socket --version
   _____         _       _        /---------------
  |   __|___ ___| |_ ___| |_      | CLI: v1.1.38
  |__   | . |  _| '_| -_|  _|     | token: (not set), org: (not set)
  |_____|___|___|_,_|___|_|.dev   | Command: `socket`, cwd: ~/repos/me/how-tos
```

### 3.2. Remove

If you installed using next command, then remove it following next steps:
```sh
## install
$ curl -fsSL https://raw.githubusercontent.com/SocketDev/socket-cli/main/install.sh | bash


## remove
$ which socket
/home/chilcano/.local/bin/socket

$ ls -la /home/chilcano/.local/bin/socket

lrwxrwxrwx 1 chilcano chilcano 111 Nov 27 09:17 /home/chilcano/.local/bin/socket -> /home/chilcano/.socket/_dlx/b9635a1465bdf16e999fda0114a7d002ef2e16eafc19486fd063d8af0f853b98/package/bin/socket

$ rm -rf /home/chilcano/.local/bin/socket
$ rm -rf /home/chilcano/.socket/
```

### 3.3. Use

* Unfortunately, useless features are available in Socket CLI and scanning and view reports requires be connected to Socket Dev Portal through an API Token.
* However, you can open a free account in Socket Dev, connect it to your Github account. With that you can scan your repos from UI or Terminal using Socket CLI.
* Once created your Socket Dev free account, create an API Token to be used with `socker login` command.

```sh
$ socket login
   _____         _       _        /---------------
  |   __|___ ___| |_ ___| |_      | CLI: v1.1.38
  |__   | . |  _| '_| -_|  _|     | token: (not set), org: (not set)
  |_____|___|___|_,_|___|_|.dev   | Command: `socket login`, cwd: ~/repos/zama-ai/console/apps/front

✔ Enter your Socket.dev API token (​https://docs.socket.dev/docs/api-keys​) (leave blank to use a limited public token)
✔ Received Socket API response (after requesting token verification).
✔ API token verified: intix
✔ Would you like to install bash tab completion? Yes

Setting up tab completion...
✔ Tab completion will be enabled after restarting your terminal
✔ API credentials set
```
Now scan your repo from your local PC:
```
$ cd my/repo/dir

$ socket scan create .
   _____         _       _        /---------------
  |   __|___ ___| |_ ___| |_      | CLI: v1.1.38
  |__   | . |  _| '_| -_|  _|     | token: 0_dlI*** (config), org: intix (config)
  |_____|___|___|_,_|___|_|.dev   | Command: `socket scan create`, cwd: ~/repos/zama-ai/console

✔ Received Socket API response (after requesting supported scan file types).
✔ Found 23 files to include in scan.
✔ Found 23 local files
✔ Received Socket API response (after requesting to create a scan).
⠴ 
✔ Scan completed successfully!
View report at: https://socket.dev/dashboard/org/intix/sbom/1c08e122-beea-4cf2-a487-ec8e18b40e99 (​https://socket.dev/dashboard/org/intix/sbom/1c08e122-beea-4cf2-a487-ec8e18b40e99​)
✔ Would you like to open it in your browser? No

$ socket scan list

$ socket scan view <myreportid>

$ socket scan view <myreportid> ./myreport.txt

$ socket scan view <myreportid> ./myreport.json --json
```