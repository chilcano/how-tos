# Setup a Development Python environment in Linux

This guide will work on Ubuntu > 20.x

## 1. Install Python3, Pip and dev tools


If you want to install a minimum packages and dependencies, then install python and pip only.
```sh
$ sudo apt -yqq install python3 python3-pip 
```

But if you want full python installation, then run this:
```sh
$ sudo apt -yqq install python3 python3-pip build-essential libssl-dev libffi-dev python3-dev python3-venv 
```


Let's check packages and modules in a minimum python installation.
```sh
$ python3 -V
Python 3.11.4

$ pip -V
pip 23.0.1 from /usr/lib/python3/dist-packages/pip (python 3.11)

$ pip list | wc -l
13
```

## 2. Working with Pip and virtual environments


### 2.1. virtualenv, venv and pipx?

```sh
$ pip install virtualenv

error: externally-managed-environment

× This environment is externally managed
╰─> To install Python packages system-wide, try apt install
    python3-xyz, where xyz is the package you are trying to
    install.
    
    If you wish to install a non-Debian-packaged Python package,
    create a virtual environment using python3 -m venv path/to/venv.
    Then use path/to/venv/bin/python and path/to/venv/bin/pip. Make
    sure you have python3-full installed.
    
    If you wish to install a non-Debian packaged Python application,
    it may be easiest to use pipx install xyz, which will manage a
    virtual environment for you. Make sure you have pipx installed.
    
    See /usr/share/doc/python3.11/README.venv for more information.

note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.
```

* The above error means that we __can not__ install any python app and because that is mixing `apt` provided packages and `pip` provided packages.
* If you wat to go for it, you have 2 options: 
  1. Install `virtualenv` or `venv` and python will create something like `.venv` dirs in your repo.
  2. Install `pipx` and python will manage `.venv` in `~/.local/pipx/venvs` for you automatically. Recommended if app will be used in many places.


### 2.2. Working with venv instead of virtualenv


__1. Install venv__

- We will use `python3 -m venv path/to/.venv` instead of `python3 -m virtualenv path/to/venv`. 
- The `venv` should be instaled using this command `apt install python3-venv` or `apt install python3.11-venv`.
- According the above error `python3-full` should be installed.

```sh
$ sudo apt -y install python3-venv python3-full
```

In a current empty directory create a virtual environment.
```sh
$ python3 -m venv .venv
```

__2. Activate the virtual environment__

Activate the virtualenv before updating or installing modules.
```sh
$ source .venv/bin/activate
```
And if you want to disable, just run `deactivate`.   

__3. Install packages in virtual env__

Now, install any module you want in the project directory.
```sh
$ pip install flask
```

Check how many modules you have now.
```sh
$ pip list | wc -l
13

$ pip list 
Package            Version
------------------ -------
click              8.1.3
Flask              2.1.2
importlib-metadata 4.11.4
itsdangerous       2.1.2
Jinja2             3.1.2
MarkupSafe         2.1.1
pip                22.1.2
setuptools         62.3.4
Werkzeug           2.1.2
wheel              0.37.1
zipp               3.8.0
```

Get the module details that you installed.
```sh
$ pip show flask
```

__4. Add the virtual environment folder to your existing git ignore file__

```sh
$ echo ".venv" >> .gitignore
```

__5. Freezing the modules for your specific python project__

```sh
$  pip freeze > requirements.txt
```
Checking what modules were included in our `requirements.txt`.

```sh
$ cat requirements.txt 

click==8.1.3
Flask==2.1.2
importlib-metadata==4.11.4
itsdangerous==2.1.2
Jinja2==3.1.2
MarkupSafe==2.1.1
Werkzeug==2.1.2
zipp==3.8.0
```

__6. Installing the modules from requirements file__

```sh
$  pip -q install -r requirements.txt
```

__7. List and update outdated modules__

```sh
$  pip list --outdated
``` 
In this example, you will see:
```sh
Package    Version Latest Type
---------- ------- ------ -----
setuptools 62.3.4  62.6.0 wheel
```

Now, you can update those modules:
```sh
$ pip install -U setuptools
```

Or using the `requirements.txt` file:
```sh
$ pip install -U -r requirements.txt
```

Once updated, generate an updated `requirements.txt` file.
```sh
$ pip freeze > requirements.txt
```

__8. Check for missing dependencies__

```sh
$ python -m pip check
``` 

### 2.3. Working with pipx

**1. Install pipx**

- The `venv` and `ensurepip` are required by `pipx`.
- According the above error `python3-full` should be installed as well.

```sh
$ sudo apt install -y pipx python3-full
$ pipx ensurepath

/home/chilcano/.local/bin is already in PATH.

⚠️  All pipx binary directories have been added to PATH. If you are sure you want to proceed, try again with the '--force' flag.

Otherwise pipx is ready to go! ✨ 🌟 ✨
```

**2. Install a python applications using pipx**

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

## 3. Configuring VS Code to work with Python

Recommended extensions:

1. xxx
2. yyy
3. zzzz

