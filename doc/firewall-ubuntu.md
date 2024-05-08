# Configure Firewall in Ubuntu


## 1. The Uncomplicated Firewall (UFW)


### Fresh install and configuration

> If you have a fresh installation of Ubuntu or Debian, you probably have `ufw` already installed and activated with a default rules and policies. Generally, these rules and policies will work for you (Secure Defaults Policy) without problems and will not require be changed. But if you want enhance your configuration or allow access to a new service or protocol running in a specific port, then we recommend follow this guide from beginning to configure `ufw` from scratch. In otherwise, skip the steps 2, 3 and 4.


__1. Install and make sure it is deactivate__

```sh
$ sudo apt install ufw​​​
$ sudo ufw status verbose
$ sudo systemctl status ufw
$ sudo systemctl stop ufw
```

__2. Reset default rules__

> * Don't enable `ufw` without before reviewing the initial rules. This may lock-in your host and don't allow getting accessing into services.
> * We recommend stop and disable `ufw` while it is being configurate fresh rules.


```sh
$ sudo ufw reset

Resetting all rules to installed defaults. Proceed with operation (y|n)? y
Backing up 'user.rules' to '/etc/ufw/user.rules.20240430_100805'
Backing up 'before.rules' to '/etc/ufw/before.rules.20240430_100805'
Backing up 'after.rules' to '/etc/ufw/after.rules.20240430_100805'
Backing up 'user6.rules' to '/etc/ufw/user6.rules.20240430_100805'
Backing up 'before6.rules' to '/etc/ufw/before6.rules.20240430_100805'
Backing up 'after6.rules' to '/etc/ufw/after6.rules.20240430_100805'
```

__3. Set the default policies__

* ` ufw default allow|deny|reject DIRECTION`
  - Where `DIRECTION` is one of `incoming`, `outgoing` or `routed`.

> * The next policies are defining how the traffic is going to be managed by default.

```sh
$ sudo ufw default deny incoming
$ sudo ufw default allow outgoing
```

__4. Adding new rules__

> We do need to know what services (ports and protocol) are going to be exposed or served in this host.

* Next rules configure most common services (SSH and HTTP)

```sh
$ sudo ufw allow ssh
$ sudo ufw allow http
$ sudo ufw allow https
$ sudo ufw deny ftp
```

__5. Reactivate UFW__

```sh
$ sudo systemctl start ufw
$ sudo ufw enable
```

__6. Checking the current status__

```sh
$ sudo ufw status verbose

Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere                  
...   

$ sudo ufw status numbered  

Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere                  
[ 2] 80/tcp                     ALLOW IN    Anywhere                  
[ 3] 443                        ALLOW IN    Anywhere                  
[ 4] 21/tcp                     DENY IN     Anywhere                  
[ 5] 22/tcp (v6)                ALLOW IN    Anywhere (v6)             
[ 6] 80/tcp (v6)                ALLOW IN    Anywhere (v6)             
[ 7] 443 (v6)                   ALLOW IN    Anywhere (v6)             
[ 8] 21/tcp (v6)                DENY IN     Anywhere (v6)
```

__7. Checking if filters are working__

* Install and enable SSH Server to check if `ufw` is filtering.

```sh
$ sudo apt -y install openssh-server
$ sudo systemctl restart ssh
$ sudo systemctl status ssh
```
Check SSH filter:

```sh
$ ssh chilcano@localhost

```
The above command should work.


### Advanced UFW filters

> Enhancing the firewall filters requires sometimes remove and/or update the pre-existing rules.


__1. Allow SSH incoming connection only from local IP (Home LAN)__

* My Local IPv4 and IPv6 are:

```sh
$ ip a s

...
3: wlp0s20f3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 74:3a:f4:00:13:10 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.153/24 brd 192.168.1.255 scope global dynamic noprefixroute wlp0s20f3
       valid_lft 77198sec preferred_lft 77198sec
    inet6 fe80::c3b:d7ed:65e5:4e7d/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

Next rule allow specific IPv4 and IPv6 local IP address to any target for port 22 using ssh:
```sh
$ sudo ufw allow from 192.168.1.153 to any port 22 proto tcp
$ sudo ufw allow from fe80::c3b:d7ed:65e5:4e7d to any port 22 proto tcp
```

Next rule allow local subnet to any target for port 22 using ssh:
```sh
$ sudo ufw allow from 192.168.1.0/24 to any port 22 proto tcp
$ sudo ufw allow from 192.168.1.0/24 to any port 22 proto tcp
```


```sh
$ sudo ufw status numbered

Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere                  
[ 2] 21/tcp                     DENY IN     Anywhere                  
[ 3] 22/tcp                     ALLOW IN    192.168.1.169             
[ 4] 22/tcp (v6)                ALLOW IN    Anywhere (v6)             
[ 5] 21/tcp (v6)                DENY IN     Anywhere (v6)             
[ 6] 22/tcp                     ALLOW IN    fe80::c3b:d7ed:65e5:4e7d  

```

Remove the rule `4` (IPv6) and `1` (IPv4) because they are not needed.
```sh
$ sudo ufw delete 4
$ sudo ufw delete 1
```

Checking again:
```sh
$ sudo ufw status numbered

Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 21/tcp                     DENY IN     Anywhere                  
[ 2] 22/tcp                     ALLOW IN    192.168.1.153             
[ 3] 21/tcp (v6)                DENY IN     Anywhere (v6)             
[ 4] 22/tcp                     ALLOW IN    fe80::c3b:d7ed:65e5:4e7d  
```

From another computer with not allowed IP address, the next command will not work:
```sh
$ ssh chilcano@192.168.1.169
```


__2. UFW is ignored by exposed Docker ports__

> This is an issue with UFW and Docker. UFW can not filter the traffic of exposed Docker ports.

* Issue: https://askubuntu.com/questions/1463476/ufw-port-is-reachable-for-everyone-although-only-certain-ips-are-opened
* Workaround: https://github.com/chaifeng/ufw-docker



### Logging


```sh
$ sudo ufw logging on
$ sudo ufw logging off
```

__1. Levels__

```sh
// Logs all blocked packets not matching the defined policy (with rate limiting), as well as packets matching logged rules.
$ sudo ufw logging low

// Log level low, plus all allowed packets not matching the defined policy, all
// INVALID packets, and all new connections. All logging is done with rate limiting.
$ sudo ufw logging medium

// Log level medium (without rate limiting), plus all packets with rate limiting.
$ sudo ufw logging high

// Log level high without rate limiting
$ sudo ufw logging full
```

Viewing logs:
```sh
$ cat /var/log/ufw.log
$ tail -f /var/log/ufw.log
```


## References:

- https://help.ubuntu.com/community/UFW
- https://help.ubuntu.com/community/Gufw
- https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands