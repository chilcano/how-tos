## Installing Logitech Device Manager (Keyboard adn mice) in Ubuntu with Unifying


### Ref:
- https://github.com/pwr-Solaar/Solaar/blob/master/docs/installation.md
- https://askubuntu.com/questions/608298/logitech-k400r-wireless-keyboard-trackpad-settings-for-ubuntu-14-04


### 1. Install from Python 3 repository

```sh
$ python3 -V
$ sudo apt install -y python3-pip build-essential libssl-dev libffi-dev python-dev python3-venv
$ sudo pip3 install solaar
```sh

To remove:
```sh
$ sudo pip3 uninstall solaar
```

### 2. Install from Ubuntu 

```sh
$ sudo apt install -y solaar
```

It will install its dependencies:
```
python-dbus python-gi python-pyudev
```

If you want to remove it
```sh
$ sudo apt remove -y solaar 
```

### 3. Install from source code

Clone the repository
```sh
$ git clone https://github.com/pwr-Solaar/Solaar.git
$ cd Solaar/
$ sudo bin/solaar
```

Installing Solaar's udev Rule
```sh
$ sudo cp rules.d/42-logitech-unify-permissions.rules /etc/udev/rules.d

// if you want to remove it
$ sudo rm -rf /etc/udev/rules.d
```

Installing Solaar
```sh
$ pip3 install solaar --user solaar
```
