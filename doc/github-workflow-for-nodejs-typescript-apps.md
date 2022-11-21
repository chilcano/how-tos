# CI/CD GitHub Workflow for NodeJS and TypeScript 

- NodeJS v16.x on Ubuntu 22.04
- TypeScript guide: https://www.typescriptlang.org/docs/handbook/typescript-tooling-in-5-minutes.html
- Example Applications:
  * [The Ultimate Ethereum Dapp Tutorial (How to Build a Full Stack Decentralized Application Step-By-Step)](https://www.dappuniversity.com/articles/the-ultimate-ethereum-dapp-tutorial)

## Steps

### 1. Setup NodeJS

1. __Install NodeJS__ 

This will install the NodeJS APT repository, according to [NodeJS on Ubuntu 22.x guide](https://github.com/nodesource/distributions/blob/master/README.md#debinstall).

```sh
$ curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
```

You will see this.
```sh
...
## Run `sudo apt-get install -y nodejs` to install Node.js 16.x and npm
## You may also need development tools to build native addons:
     sudo apt-get install gcc g++ make
## To install the Yarn package manager, run:
     curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
     echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
     sudo apt-get update && sudo apt-get install yarn

```
Now, install NodeJS in your system.
```sh
$ sudo apt-get install -y nodejs

$ node -v
v16.18.1
```


2. __Install NodeJS package manager__ 

Now, install the package manager and extra libraries that nodejs requires.
The standard NodeJS package manager `npm` has been installed when NodeJS was installed.
```sh
$ npm -v
8.19.2
```

Now, update `npm`.
```sh
// Latest version
$ sudo npm install npm@latest -g

// Sugested version
$ sudo npm install -g npm@9.1.2
```

But if you want to install another NodeJS package manager such as `Yarn`, follow next steps: 
```sh
$ curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
$ echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
$ sudo apt-get update && sudo apt-get install yarn

// Check yarn
$ yarn -v
1.22.19
```

To complete the installation, install the extra libraries:
```sh
$ sudo apt-get install gcc g++ make
```

3. __Install TypeScript compiler__

```sh
// Required by https://www.typescriptlang.org/download - confirm!
$ npm install typescript --save-dev

// Compiler
$ sudo npm install -g typescript

added 1 package in 1s

// TS Node
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

