# Wotking with NMAP

## Install from Ubuntu repositories

```sh
$ sudo apt -y install nmap

$ nmap -v

Nmap version 7.80 ( https://nmap.org )
Platform: x86_64-pc-linux-gnu
Compiled with: liblua-5.3.3 openssl-1.1.1j nmap-libssh2-1.8.2 libz-1.2.11 libpcre-8.39 libpcap-1.10.0 nmap-libdnet-1.12 ipv6
Compiled without:
Available nsock engines: epoll poll select

```

## Install using SNAP

### Reference
- [Install nmap 7.9 on Ubuntu 21.04](https://unix.stackexchange.com/questions/662450/nmap-7-8-assertion-failed-htn-toclock-running-true)

### Installation

```sh
$ sudo apt install snapd
$ sudo snap install nmap
```

Check your new `nmap` version:
```sh
$ sudo nmap -v

Starting Nmap 7.92 ( https://nmap.org ) at 2021-12-17 20:00 CET
Read data files from: /snap/nmap/2536/bin/../share/nmap
WARNING: No targets were specified, so 0 hosts scanned.
Nmap done: 0 IP addresses (0 hosts up) scanned in 0.04 seconds
           Raw packets sent: 0 (0B) | Rcvd: 0 (0B)
```

If you get the following error when testing nmap:
```sh
dnet: Failed to open device <your-device-name> 
QUITTING!
```

then, run the following command:
```sh
$ sudo snap connect nmap:network-control
```

## Commands

### 1. Looking for Raspberry Pi connected in the LAN

```sh
$ sudo nmap -sn 192.168.1.0/24

```