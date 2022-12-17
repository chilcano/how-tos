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

nmap 7.93 from Maximiliano Bertacchini (maxiberta) installed
```

If you get the following error when testing nmap:
```sh
dnet: Failed to open device <your-device-name> 
QUITTING!
```

Then, run the following command:
```sh
$ sudo snap connect nmap:network-control
```

## Commands

### 1. Looking for Raspberry Pi connected in the LAN

```sh
$ nmap -sn 10.42.0.0/24
```

You can try with these network addresses:
- `10.42.0.0/24` - In this case I have a private class A network.
- `192.168.1.0/24` - Commonly used in private domestic class C network. 

You should see something like this:
```sh
Starting Nmap 7.92 ( https://nmap.org ) at 2021-12-04 00:28 CET
Nmap scan report for inti (10.42.0.1)
Host is up (0.00027s latency).
Nmap scan report for 10.42.0.159
Host is up (0.00057s latency).
Nmap done: 256 IP addresses (2 hosts up) scanned in 2.40 seconds
```

Run it with `sudo` to get hostnames:
```sh
$ sudo nmap -sn 10.42.0.0/24
```

You will see hostnames now:
```sh
Starting Nmap 7.92 ( https://nmap.org ) at 2021-12-09 17:57 CET
Nmap scan report for 10.42.0.159
Host is up (0.00068s latency).
MAC Address: B8:27:EB:1B:CF:C8 (Raspberry Pi Foundation)
Nmap scan report for inti (10.42.0.1)
Host is up.
Nmap done: 256 IP addresses (2 hosts up) scanned in 9.25 seconds
```

### 2. Scan open ports

> Running `nmap` with `sudo` is faster.

__1) Open ports in a host__

```sh
$ nmap api-stg.vocdoni.net

Starting Nmap 7.80 ( https://nmap.org ) at 2022-12-17 18:50 CET
Nmap scan report for api-stg.vocdoni.net (162.55.163.63)
Host is up (0.036s latency).
rDNS record for 162.55.163.63: static.63.163.55.162.clients.your-server.de
Not shown: 995 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
443/tcp  open  https
4001/tcp open  newoak
5001/tcp open  commplex-link
9090/tcp open  zeus-admin

Nmap done: 1 IP address (1 host up) scanned in 0.86 seconds
```

```sh
$ nmap ipfs.eth.aragon.network

Starting Nmap 7.80 ( https://nmap.org ) at 2022-12-17 18:53 CET
Nmap scan report for ipfs.eth.aragon.network (49.12.21.118)
Host is up (0.035s latency).
rDNS record for 49.12.21.118: static.118.21.12.49.clients.your-server.de
Not shown: 998 closed ports
PORT    STATE SERVICE
80/tcp  open  http
443/tcp open  https

Nmap done: 1 IP address (1 host up) scanned in 0.80 seconds
```


__2) Advanced scanning__

```sh
$ sudo nmap -p0- -v -A -T4 api-stg.vocdoni.net

[sudo] password for chilcano: 
Starting Nmap 7.80 ( https://nmap.org ) at 2022-12-17 18:58 CET
NSE: Loaded 151 scripts for scanning.
NSE: Script Pre-scanning.
Initiating NSE at 18:58
Completed NSE at 18:58, 0.00s elapsed
Initiating NSE at 18:58
Completed NSE at 18:58, 0.00s elapsed
Initiating NSE at 18:58
Completed NSE at 18:58, 0.00s elapsed
Initiating Ping Scan at 18:58
Scanning api-stg.vocdoni.net (162.55.163.63) [4 ports]
Completed Ping Scan at 18:58, 0.07s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 18:58
Completed Parallel DNS resolution of 1 host. at 18:58, 0.00s elapsed
Initiating SYN Stealth Scan at 18:58
Scanning api-stg.vocdoni.net (162.55.163.63) [65536 ports]
Discovered open port 443/tcp on 162.55.163.63
Discovered open port 22/tcp on 162.55.163.63
Discovered open port 5001/tcp on 162.55.163.63
Discovered open port 61001/tcp on 162.55.163.63
Discovered open port 4171/tcp on 162.55.163.63
Discovered open port 26656/tcp on 162.55.163.63
Discovered open port 9090/tcp on 162.55.163.63
Discovered open port 4001/tcp on 162.55.163.63
Completed SYN Stealth Scan at 18:58, 14.24s elapsed (65536 total ports)
Initiating Service scan at 18:58
Scanning 8 services on api-stg.vocdoni.net (162.55.163.63)
Completed Service scan at 19:00, 99.52s elapsed (8 services on 1 host)
Initiating OS detection (try #1) against api-stg.vocdoni.net (162.55.163.63)
Retrying OS detection (try #2) against api-stg.vocdoni.net (162.55.163.63)
Initiating Traceroute at 19:00
Completed Traceroute at 19:00, 3.01s elapsed
Initiating Parallel DNS resolution of 6 hosts. at 19:00
Completed Parallel DNS resolution of 6 hosts. at 19:00, 0.04s elapsed
NSE: Script scanning 162.55.163.63.
Initiating NSE at 19:00
Completed NSE at 19:00, 5.20s elapsed
Initiating NSE at 19:00
Completed NSE at 19:00, 0.29s elapsed
Initiating NSE at 19:00
Completed NSE at 19:00, 0.00s elapsed
Nmap scan report for api-stg.vocdoni.net (162.55.163.63)
Host is up (0.033s latency).
rDNS record for 162.55.163.63: static.63.163.55.162.clients.your-server.de
Not shown: 65528 closed ports
PORT      STATE SERVICE            VERSION
22/tcp    open  ssh                OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)
| ssh-hostkey: 
|   2048 29:3a:70:f4:0d:0c:40:49:d0:6a:53:9e:1d:80:9f:6f (RSA)
|   256 65:db:d8:b4:e8:9d:fd:81:c0:08:0b:91:0f:1a:5f:af (ECDSA)
|_  256 41:41:9c:47:ca:e1:f2:8d:72:79:26:c2:01:ff:8d:25 (ED25519)
443/tcp   open  ssl/https
| fingerprint-strings: 
|   FourOhFourRequest, GetRequest: 
|     HTTP/1.0 405 Method Not Allowed
|     Vary: Origin
|     Date: Sat, 17 Dec 2022 17:58:47 GMT
|     Content-Length: 0
|   GenericLines, Help, Kerberos, LDAPSearchReq, LPDString, RTSPRequest, SIPOptions, SSLSessionReq, TLSSessionReq, TerminalServerCookie: 
|     HTTP/1.1 400 Bad Request
|     Content-Type: text/plain; charset=utf-8
|     Connection: close
|     Request
|   HTTPOptions: 
|     HTTP/1.0 200 OK
|     Vary: Origin
|     Date: Sat, 17 Dec 2022 17:58:47 GMT
|_    Content-Length: 0
| http-methods: 
|_  Supported Methods: OPTIONS
|_http-title: Site doesn't have a title.
| ssl-cert: Subject: commonName=api-stg.vocdoni.net
| Subject Alternative Name: DNS:api-stg.vocdoni.net
| Issuer: commonName=R3/organizationName=Let's Encrypt/countryName=US
| Public Key type: ec
| Public Key bits: 256
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2022-12-14T15:29:57
| Not valid after:  2023-03-14T15:29:56
| MD5:   7aa6 9bd5 f519 6f4d 609c 826a 6fa4 7851
|_SHA-1: 105e 2ae6 89f9 b494 7dc8 201e d13f a0ff e65d 7f30
4001/tcp  open  libp2p-multistream libp2p multistream protocol 1.0.0
4171/tcp  open  tcpwrapped
5001/tcp  open  http               Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
|_http-title: Site doesn't have a title (text/plain; charset=utf-8).
9090/tcp  open  ssl/zeus-admin?
| fingerprint-strings: 
|   FourOhFourRequest: 
|     HTTP/1.0 405 Method Not Allowed
|     Vary: Origin
|     Date: Sat, 17 Dec 2022 17:59:19 GMT
|     Content-Length: 0
|   GenericLines, Help, Kerberos, LDAPSearchReq, LPDString, RTSPRequest, SIPOptions, SSLSessionReq, TLSSessionReq, TerminalServerCookie: 
|     HTTP/1.1 400 Bad Request
|     Content-Type: text/plain; charset=utf-8
|     Connection: close
|     Request
|   GetRequest: 
|     HTTP/1.0 405 Method Not Allowed
|     Vary: Origin
|     Date: Sat, 17 Dec 2022 17:58:52 GMT
|     Content-Length: 0
|   HTTPOptions: 
|     HTTP/1.0 200 OK
|     Vary: Origin
|     Date: Sat, 17 Dec 2022 17:58:53 GMT
|_    Content-Length: 0
| ssl-cert: Subject: commonName=api-stg.vocdoni.net
| Subject Alternative Name: DNS:api-stg.vocdoni.net
| Issuer: commonName=R3/organizationName=Let's Encrypt/countryName=US
| Public Key type: ec
| Public Key bits: 256
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2022-12-14T15:29:57
| Not valid after:  2023-03-14T15:29:56
| MD5:   7aa6 9bd5 f519 6f4d 609c 826a 6fa4 7851
|_SHA-1: 105e 2ae6 89f9 b494 7dc8 201e d13f a0ff e65d 7f30
26656/tcp open  unknown
| fingerprint-strings: 
|   HTTPOptions: 
|_    U6&WX
61001/tcp open  http               Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
|_http-title: Site doesn't have a title (text/plain; charset=utf-8).
3 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port443-TCP:V=7.80%T=SSL%I=7%D=12/17%Time=639E0357%P=x86_64-pc-linux-gn
...
SF::\x20text/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x2
SF:0Bad\x20Request");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port9090-TCP:V=7.80%T=SSL%I=7%D=12/17%Time=639E035C%P=x86_64-pc-linux-g
...
SF:e:\x20text/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x
SF:20Bad\x20Request");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port26656-TCP:V=7.80%I=7%D=12/17%Time=639E0352%P=x86_64-pc-linux-gnu%r(
...
SF:\xce\xd1\x18p\xc3z\?\xff\x05\xd5\xb6\xb5\xfe\x14\x07L\xd2\xde\x1d\x11\x
SF:d1\.\xa4\x01\^\r\xf7cR\xab\xb8h");
Aggressive OS guesses: Linux 2.6.32 (96%), Linux 2.6.32 or 3.10 (96%), Linux 4.4 (96%), Linux 2.6.32 - 2.6.35 (94%), Linux 2.6.32 - 2.6.39 (94%), Linux 2.6.32 - 3.0 (93%), Linux 4.0 (92%), Linux 3.11 - 4.1 (92%), Linux 3.2 - 3.8 (92%), Linux 2.6.18 (92%)
No exact OS matches for host (test conditions non-ideal).
Uptime guess: 45.237 days (since Wed Nov  2 13:18:53 2022)
Network Distance: 12 hops
TCP Sequence Prediction: Difficulty=258 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 21/tcp)
HOP RTT      ADDRESS
1   1.16 ms  _gateway (192.168.1.1)
2   4.64 ms  100.101.0.1
3   4.47 ms  10.15.3.57
4   7.09 ms  10.15.3.118
5   ...
6   30.77 ms prs-bb2-link.ip.twelve99.net (62.115.136.120)
7   ... 11
12  30.73 ms static.63.163.55.162.clients.your-server.de (162.55.163.63)

NSE: Script Post-scanning.
Initiating NSE at 19:00
Completed NSE at 19:00, 0.00s elapsed
Initiating NSE at 19:00
Completed NSE at 19:00, 0.00s elapsed
Initiating NSE at 19:00
Completed NSE at 19:00, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 127.02 seconds
           Raw packets sent: 65630 (2.890MB) | Rcvd: 65788 (2.637MB)
```

> __More examples here:__   
> * [How To Use Nmap to Scan for Open Ports](https://www.digitalocean.com/community/tutorials/how-to-use-nmap-to-scan-for-open-ports)

