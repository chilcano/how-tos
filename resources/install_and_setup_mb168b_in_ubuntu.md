# MB168b in Ubuntu

1. Download the MB168b DisplayLink drivers and unzip it:

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

3. Install required packages:

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
    
6. In the Setting menu, I can set my display now, and it works well.


## References:

https://www.displaylink.com/downloads/ubuntu
http://codingstruggles.com/using-the-asus-mb158b-with-ubuntu-15-10.html
https://askubuntu.com/questions/744364/displaylink-asus-mb168b-issues


