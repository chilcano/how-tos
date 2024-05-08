# Minecraft Server & Client


## Server

### 1. CasaOS - Manage your Local Docker containers from Web

If you don't like run Docker CLI commands to manage your docker instances in your computer, well, CasaOS is a cool tool to do that.
Check it out here: https://casaos.io/


### 2. Crafty 

- Search for Crafty on CasaOS and install it.
- Once installed, configure your Crafty Docker instance.
- Change the admin credentials:
  * Go to `app/config/default-creds.txt` and edit the file from a terminal.

### 3. Create Minecraft Server

Setup your server:

* Minecraft-Java
* RAM 1GB to 5GB/(8GB)
* Port: 25565 (default)

...build


### 4. Launch server

- Click on it from CasaOS

### 5. Check ports

```sh
$ sudo nmap -p- 192.168.1.169

Starting Nmap 7.93 ( https://nmap.org ) at 2024-04-30 13:16 CEST
Nmap scan report for 192.168.1.169
Host is up (0.018s latency).
Not shown: 65426 filtered tcp ports (no-response), 102 closed tcp ports (reset)
PORT      STATE SERVICE
22/tcp    open  ssh
5080/tcp  open  onscreen
5433/tcp  open  pyrrho
8111/tcp  open  skynetflow
9000/tcp  open  cslistener
12379/tcp open  unknown
25565/tcp open  minecraft
MAC Address: 4C:E1:73:4A:EC:23 (Ieee Registration Authority)

Nmap done: 1 IP address (1 host up) scanned in 110.49 seconds
```
Or scan specific ports `sudo nmap -p 22,5080,5433,8111,9000,12379,25565 192.168.1.169`

You will see the Minecraft port `25565` is opened.


## Client

__1. Install__

* Ref: 
- https://datawookie.dev/blog/2023/12/minecraft-client-on-ubuntu/
- https://www.minecraft.net/en-us/download


```sh
$ wget https://launcher.mojang.com/download/Minecraft.deb
$ sudo dpkg -i Minecraft.deb
```

If there are errors about dependencies then fix them.
```sh
$ sudo apt --fix-broken install -y
```

__2. Uninstall__

```sh
$ dpkg -l | grep minecraft
ii  minecraft-launcher                               1.1.26                                    amd64        Official Minecraft Launcher

$ sudo dpkg -r minecraft-launcher
(Reading database ... 308096 files and directories currently installed.)
Removing minecraft-launcher (1.1.26) ...
Processing triggers for hicolor-icon-theme (0.17-2) ...
Processing triggers for mailcap (3.70+nmu1ubuntu1) ...
Processing triggers for gnome-menus (3.36.0-1.1ubuntu1) ...
Processing triggers for desktop-file-utils (0.26-1ubuntu5) ...

```

__3. Run client__

```sh
$ minecraft-launcher
```

__4. Log in__

The Launcher will ask for your Minecraft or Microsoft credentials if you want to play in your local Minecraft Server, even if you are running it in multiplayer mode.
As well, if you want to connect without restrictions in remote Minecraft server, then, It is worthy to get a valid account from Microsoft.
In my case, I bought many years ago an Minecraft Mojang account that could migrate to Microsoft.



