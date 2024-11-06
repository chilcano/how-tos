# Enable WIFI in Ubuntu Recovery Mode

## Steps

1. Boot in recovery mode

* Bios -> `[ESC]` key
* Prompt -> `[ESC]` key 2 times
* Recovery Mode
  - Mount all partitions
  - Enable network (something it doesn't work)

2. Open root terminal, there run these commands:

```sh
// mount
mount -o remount,rw /
mount --all

// list wireless interfaces to get interface name
ip a

// check if wireless device is up
nmcli -o radio
iwconfig

// activate wifi id it is down
ip link set <WIFI-INTERFACE-NAME> up

// scan for avalable wireless networks
nmcli device wifi list

// connect to a password protected wireless network
nmcli device wifi connect <SSID> password <PASSWORD>
```
