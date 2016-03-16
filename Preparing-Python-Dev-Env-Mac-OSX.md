# Preparing the Python development environment in Mac OSX


__References:__

- [Python Development Environment on Mac OS X Yosemite 10.10](https://hackercodex.com/guide/python-development-environment-on-mac-osx)


__1) Pre-installed Python in Mac OSX__

```
$ ll /System/Library/Frameworks/Python.framework/Versions
total 24
drwxr-xr-x   7 root  wheel  238 Oct 29 09:12 ./
drwxr-xr-x   6 root  wheel  204 Oct 29 09:12 ../
lrwxr-xr-x   1 root  wheel    3 Oct 29 09:11 2.3@ -> 2.6
lrwxr-xr-x   1 root  wheel    3 Oct 29 09:11 2.5@ -> 2.6
drwxr-xr-x  11 root  wheel  374 Dec 21 19:51 2.6/
drwxr-xr-x  11 root  wheel  374 Jan 29 10:17 2.7/
lrwxr-xr-x   1 root  wheel    3 Oct 29 09:11 Current@ -> 2.7
```

```
$ python -V
Python 2.7.10
```

__2) Install Python2 and Python3__

```bash
$ sudo brew install python

...
==> Caveats
Pip and setuptools have been installed. To update them
  pip install --upgrade pip setuptools

You can install Python packages with
  pip install <package>

They will install into the site-package directory
  /usr/local/lib/python2.7/site-packages

See: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Homebrew-and-Python.md

.app bundles were installed.
Run `brew linkapps python` to symlink these to /Applications.
==> Summary
🍺  /usr/local/Cellar/python/2.7.11: 6,221 files, 84M, built in 1 minute 57 seconds
```
Now, update Pip and create symlinks.
```bash
$ pip install --upgrade pip setuptools
$ brew linkapps python
````


And Python3.
```bash
$ sudo brew install python3

...
Pip and setuptools have been installed. To update them
  pip3 install --upgrade pip setuptools

You can install Python packages with
  pip3 install <package>

They will install into the site-package directory
  /usr/local/lib/python3.5/site-packages

See: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Homebrew-and-Python.md

.app bundles were installed.
Run `brew linkapps python3` to symlink these to /Applications.
==> Summary
🍺  /usr/local/Cellar/python3/3.5.1: 7,642 files, 106.7M, built in 1 minute 45 seconds
```


__3) Check Python and Pip and install Virtualenv__

```
$ python -V
Python 2.7.11

$ python3 -V
Python 3.5.1

$ pip -V
pip 8.0.2 from /usr/local/lib/python2.7/site-packages (python 2.7)

$ pip3 -V
pip 8.0.2 from /usr/local/lib/python3.5/site-packages (python 3.5)
```

__4) Update Pip, Pip3, Setuptools and Virtualenv__

```bash
$ sudo pip install --upgrade pip setuptools

The directory '/Users/Chilcano/Library/Caches/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/Users/Chilcano/Library/Caches/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Requirement already up-to-date: pip in /usr/local/lib/python2.7/site-packages
Collecting setuptools
  Downloading setuptools-20.0-py2.py3-none-any.whl (472kB)
    100% |████████████████████████████████| 475kB 759kB/s
Installing collected packages: setuptools
  Found existing installation: setuptools 19.4
    Uninstalling setuptools-19.4:
      Successfully uninstalled setuptools-19.4
Successfully installed setuptools-20.0
```

```bash
$ sudo pip3 install --upgrade pip setuptools
The directory '/Users/Chilcano/Library/Caches/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/Users/Chilcano/Library/Caches/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Requirement already up-to-date: pip in /usr/local/lib/python3.5/site-packages
Collecting setuptools
  Downloading setuptools-20.0-py2.py3-none-any.whl (472kB)
    100% |████████████████████████████████| 475kB 1.2MB/s
Installing collected packages: setuptools
  Found existing installation: setuptools 19.4
    Uninstalling setuptools-19.4:
      Successfully uninstalled setuptools-19.4
Successfully installed setuptools-20.0
```

```bash
$ sudo pip install virtualenv
The directory '/Users/Chilcano/Library/Caches/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/Users/Chilcano/Library/Caches/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Collecting virtualenv
  Downloading virtualenv-14.0.6-py2.py3-none-any.whl (1.8MB)
    100% |████████████████████████████████| 1.8MB 304kB/s
Installing collected packages: virtualenv
Successfully installed virtualenv-14.0.6

$ sudo pip3 install virtualenv
The directory '/Users/Chilcano/Library/Caches/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/Users/Chilcano/Library/Caches/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Collecting virtualenv
  Downloading virtualenv-14.0.6-py2.py3-none-any.whl (1.8MB)
    100% |████████████████████████████████| 1.8MB 322kB/s
Installing collected packages: virtualenv
Successfully installed virtualenv-14.0.6
```

Now, GIT.
```bash
$ git --version
git version 2.2.1

$ source ~/.bash_profile

$ git --version
git version 2.7.1
```

__5) Creating a sample Python development environment___

Just select your work directory and the Python version to be used.
```bash
$ mkdir -p my-python-sample
$ cd my-python-sample

$ pip -V
pip 8.0.2 from /usr/local/lib/python2.7/site-packages (python 2.7)
```
Now, let's create the Python Dev Env with `VirtualEnv`.
```bash
$ virtualenv -p python2.7 venv-my-sample
Running virtualenv with interpreter /usr/local/bin/python2.7
New python executable in /Users/Chilcano/PycharmProjects/venv/bin/python2.7
Not overwriting existing python script /Users/Chilcano/PycharmProjects/venv/bin/python (you must use /Users/Chilcano/PycharmProjects/venv/bin/python2.7)
Installing setuptools, pip, wheel...done.
(venv)
```
We need to activate the recently created `VirtualEnv`:
```bash
$ source venv-my-sample/bin/activate
(venv-my-sample)

```


If your Python project requires a new Python module, you can add it to your current development environment, for example, if your need `request` module, then add it as shown below:

```bash
$ sudo pip install request

Collecting request
  Downloading request-0.0.2.tar.gz
Building wheels for collected packages: request
  Running setup.py bdist_wheel for request ... done
  Stored in directory: /Users/Chilcano/Library/Caches/pip/wheels/68/e9/10/2fee22f14dafa6ed966700e9178e8f6e81b1b499891a44298d
Successfully built request
Installing collected packages: request
Successfully installed request-0.0.2
(venv-my-sample)
```
