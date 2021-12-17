## Disable sleeping when close the laptop lid

#### Tested on:
- Ubuntu 18.04
- Ubuntu 20.04


#### Command line method

1. Add `HandleLidSwitch=ignore`  to `/etc/systemd/logind.conf`:
```sh
$ sudo nano /etc/systemd/logind.conf
```

2. Restart the logind service:
```sh
$ sudo systemctl restart systemd-logind
```

#### Alternative from Gnome GUI

1. Install Gnome Tweak:
```sh
$ sudo apt-get install gnome-tweak-tool
```

2. Disable lid action from Tweak > Power > Turn off (do nothing when lid is closed)


