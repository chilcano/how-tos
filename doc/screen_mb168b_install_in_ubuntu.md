# Asus USB Portable Monitor (MB168b) in Ubuntu



1. Download [https://www.displaylink.com/downloads/ubuntu](https://www.displaylink.com/downloads/ubuntu) the MB168b DisplayLink drivers and unzip it:

```sh
$ unzip "DisplayLink USB Graphics Software for Ubuntu 5.2.zip"
```

2. Install it:

```sh
chilcano@tayta:~/Downloads/$ sudo ./displaylink-driver-5.2.14.run 

[sudo] password for chilcano: 
Verifying archive integrity...  100%   All good.
Uncompressing DisplayLink Linux Driver 5.2.14  100%  
DisplayLink Linux Software 5.2.14 install script called: install
Distribution discovered: Ubuntu 18.04.4 LTS
Unsatisfied dependencies. Missing component: DKMS.
This is a fatal error, cannot install DisplayLink Linux Software.

```

3. Install required packages (optional).

If you have the previous error `Unsatisfied dependencies. Missing component: DKMS.` and 
`This is a fatal error, cannot install DisplayLink Linux Software.`, then you should install required packages:


```sh
chilcano@tayta:~/Downloads/$ sudo apt-get install -y dkms
```

4. Once finished, try it again:

```sh
chilcano@tayta:~/Downloads/$ sudo ./displaylink-driver-5.2.14.run 

Verifying archive integrity...  100%   All good.
Uncompressing DisplayLink Linux Driver 5.2.14  100%  
DisplayLink Linux Software 5.2.14 install script called: install
Distribution discovered: Ubuntu 18.04.4 LTS
Installing
Configuring EVDI DKMS module
Registering EVDI kernel module with DKMS
Building EVDI kernel module with DKMS
Installing EVDI kernel module to kernel tree
EVDI kernel module built successfully
Installing x64-ubuntu-1604/DisplayLinkManager
Installing libraries
Installing firmware packages
Installing licence file
Adding udev rule for DisplayLink DL-3xxx/4xxx/5xxx/6xxx devices

Please read the FAQ
http://support.displaylink.com/knowledgebase/topics/103927-troubleshooting-ubuntu
Installation complete!
```

5. Reboot the system;
    
6. In the Setting menu, You can set your new display now, and it works well.


## Troubleshooting

1. Install the [Display-Debian scripts](https://github.com/AdnanHodzic/displaylink-debian)' 2nd method. It install EVDI and DKM in Ubuntu 20.04:
```sh
$ wget https://raw.githubusercontent.com/AdnanHodzic/displaylink-debian/master/displaylink-debian.sh 
$ wget https://raw.githubusercontent.com/AdnanHodzic/displaylink-debian/master/displaylink.sh 
$ wget https://raw.githubusercontent.com/AdnanHodzic/displaylink-debian/master/evdi.sh
$ chmod +x displaylink-debian.sh displaylink-debian.sh evdi.sh && sudo ./displaylink-debian.sh
```

2. Debugging:
```sh
$ systemctl list-units | grep Display
  displaylink-driver.service                                          loaded active     running   DisplayLink Driver Service                                                          
  gdm.service                                                         loaded active     running   GNOME Display Manager

$ systemctl status displaylink-driver -l
● displaylink-driver.service - DisplayLink Driver Service
     Loaded: loaded (/lib/systemd/system/displaylink-driver.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2020-04-27 17:41:47 CEST; 15min ago
    Process: 4263 ExecStartPre=/bin/sh -c modprobe evdi || (dkms install evdi/5.2.14 && modprobe evdi) (code=exited, status=0/SUCCESS)
   Main PID: 4266 (DisplayLinkMana)
      Tasks: 35 (limit: 4464)
     Memory: 8.5M
     CGroup: /system.slice/displaylink-driver.service
             └─4266 /opt/displaylink/DisplayLinkManager

abr 27 17:41:47 supay systemd[1]: Starting DisplayLink Driver Service...
abr 27 17:41:47 supay systemd[1]: Started DisplayLink Driver Service.

$ dmesg -w

```

## References:

* https://www.displaylink.com/downloads/ubuntu
* http://codingstruggles.com/using-the-asus-mb158b-with-ubuntu-15-10.html
* https://askubuntu.com/questions/744364/displaylink-asus-mb168b-issues
* https://github.com/AdnanHodzic/displaylink-debian

