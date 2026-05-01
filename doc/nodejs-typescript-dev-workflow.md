# NodeJS and TypeScript - Development Workflow

- NodeJS v24 on Ubuntu 24.04

## Steps

### 1. Setup NodeJS

1. __Install NodeJS__ 

This will install the NodeJS APT repository, according to NodeJS on Ubuntu 24.x guide: https://github.com/nodesource/distributions/blob/master/README.md#debinstall

```sh
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -

sudo apt -y install nodejs

node -v
v24.15.0
```

2. __Install NodeJS package manager__ 

```sh
npm -v
11.13.0
```

Now, update `npm`.
```sh
# Latest version
sudo npm install npm@latest -g

# Sugested version
sudo npm install -g npm@9.1.2
```

But if you want to install another NodeJS package manager such as `Yarn`, follow next steps: 
```sh
$ curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
$ echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
$ sudo apt-get update && sudo apt-get install yarn

# Check yarn
$ yarn -v
1.22.19
```

To complete the installation, install the extra libraries:
```sh
sudo apt-get install gcc g++ make
```

3. __Install TypeScript compiler__

```sh
# Required by https://www.typescriptlang.org/download - confirm!
$ npm install typescript --save-dev

# Compiler
$ sudo npm install -g typescript

added 1 package in 1s

# TS Node
$ sudo npm install -g ts-node

added 19 packages in 3s

$ tsc -v
Version 4.9.3

$ ts-node -v
v10.9.1
```

### 2. Run an example NodeJS Application

TBC


### 3. Run an example TypeScript Application

TBC

Clone the TypeScript sample application:
```sh
$ git clone https://github.com/xyz/pqr
$ cd pqr
$ npm install
```

Once executed `npm install` to install all dependencies, if the NodeJS detects that there are some dependencies with vulnerabilities, then NodeJS will give the chance to fix them. This command will update the `package-lock.json` file.
```sh
$ npm audit fix

$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   package-lock.json

no changes added to commit (use "git add" and/or "git commit -a")
```

Update the `.env` file with the right values:
```sh
...
```

Now, run the TypeScript application:
```sh
$ ts-node index.ts
```


### 4. Implement a CI/CD GitHub workflow

TBC

### 5. Troubleshooting

#### 1. Use nvm


```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash


...
* (HEAD detached at FETCH_HEAD)
  master
=> Compressing and cleaning up git repository

=> Appending nvm source string to /home/chilcano/.zshrc
=> Appending bash_completion source string to /home/chilcano/.zshrc
=> You currently have modules installed globally with `npm`. These will no
=> longer be linked to the active version of Node when you install a new node
=> with `nvm`; and they may (depending on how you construct your `$PATH`)
=> override the binaries of modules installed with `nvm`:

/usr/local/lib
├── @fleekhq/fleek-cli@0.1.8
├── ts-node@10.9.2
└── typescript@5.3.3
=> If you wish to uninstall them at a later point (or re-install them under your
=> `nvm` Nodes), you can remove them from the system Node as follows:

     $ nvm use system
     $ npm uninstall -g a_module

=> Close and reopen your terminal to start using nvm or run the following to use it now:

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

```



#### 2. Incompatibles packages

tbc