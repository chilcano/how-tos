# Setup a Development Python environment in Linux

This guide will work on Ubuntu > 20.x

## 1. Install Python3, Pip and dev tools


If you want to installa minimum packages and dependencies, then install python and pip.
```sh
$ sudo apt -yqq install python3 python3-pip 
```


```sh
$ sudo apt -yqq install python3 python3-pip build-essential libssl-dev libffi-dev python3-dev python3-venv 
```

Check installed packages and modules.
```sh
$ python3 -V
Python 3.9.7

$ pip -V
pip 20.3.4 from /usr/lib/python3/dist-packages/pip (python 3.9)

$ pip list | wc -l
13
```



## 2. Working with Pip and virtual environments


### 2.1. Install virtualenv module globally

```sh
$ pip install virtualenv
...
  WARNING: The script virtualenv is installed in '/home/chilcano/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
Successfully installed distlib-0.3.4 filelock-3.7.1 platformdirs-2.5.2 virtualenv-20.14.1
```

Checking how many modules were installed.
```sh
$ pip list | wc -l
15
```
In this case `virtualenv` and `six` were installed.


### 2.2. Create a virtual environment 

In a current empty directory create a virtualenv.
```sh
$ python3 -m virtualenv .venv
```

Checking what folders were created.
```sh
$ tree . -a -L 3
.
└── .venv
    ├── bin
    │   ├── activate
    │   ├── activate.csh
    │   ├── activate.fish
    │   ├── activate.nu
    │   ├── activate.ps1
    │   ├── activate_this.py
    │   ├── deactivate.nu
    │   ├── pip
    │   ├── pip3
    │   ├── pip-3.9
    │   ├── pip3.9
    │   ├── python -> /usr/bin/python3
    │   ├── python3 -> python
    │   ├── python3.9 -> python
    │   ├── wheel
    │   ├── wheel3
    │   ├── wheel-3.9
    │   └── wheel3.9
    ├── .gitignore
    ├── lib
    │   └── python3.9
    └── pyvenv.cfg

4 directories, 20 files
```

List all modules installed globally.
```sh
$ pip list | wc -l
80
```

### 2.3. Activate the virtual environment 

Activate the virtualenv before updating or installing modules.
```sh
$ source .venv/bin/activate
```
And if you want to disable, just run `deactivate`.   

Now, install a specific module in the project directory.
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

### 2.4. Add the virtual environment folder to your existing git ignore file

```sh
$ echo ".venv" >> .gitignore
```

### 2.5. Freezing the modules for your specific python project

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

## 3. Configuring VS Code to work with Python

Recommended extensions:

1. xxx
2. yyy
3. zzzz


