## Installing Logitech Device Manager (Keyboard and mice) in Ubuntu with Unifying


### Ref:
- https://github.com/pwr-Solaar/Solaar/blob/master/docs/installation.md
- https://askubuntu.com/questions/608298/logitech-k400r-wireless-keyboard-trackpad-settings-for-ubuntu-14-04


### Install from Linux repo


These steps have been tested on Ubuntu 20.x, 22.x and 23.x.

1. Add the repo.
```sh
sudo add-apt-repository ppa:solaar-unifying/stable
sudo apt -y update

sudo apt -y install solaar
```

2. Plug the USB receiver. Solaar will launch automatically or run manually.
```sh
sudo solaar
```
3. Turn on the keyboard and from Solaar pair a new device.

4. If you want to remove it
```sh
sudo apt remove -y solaar 
```

More info: 
- https://pwr-solaar.github.io/Solaar/

