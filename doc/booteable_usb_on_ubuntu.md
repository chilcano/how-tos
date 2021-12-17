# Creating a Booteable Linux on USB

## 1. Using Bakena Etcher Application

Download [Etcher](https://www.balena.io/etcher/).

### Balena Etcher GUI

Open Etcher App and follow the steps.

### Balena Etcher from Terminal

1. Open Etcher from a Terminal.  
```sh
$ ./balenaEtcher-1.5.113-x64.AppImage
```

2. If you get errors, install required libs.  
```sh
$ sudo apt install libgconf-2-4
```

3. Follow the steps in Etcher GUI.  

## 2. Using dd from Terminal

1. Insert the USB drive and open terminal.
2. Use `lsblk` to find the USB device.
```sh
$ lsblk | grep -vE "loop"

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 238,5G  0 disk 
├─sda1   8:1    0   512M  0 part 
├─sda2   8:2    0     1M  0 part 
├─sda3   8:3    0   513M  0 part /boot/efi
└─sda4   8:4    0 237,5G  0 part /
sdb      8:16   1   233G  0 disk 
└─sdb1   8:17   1   233G  0 part /media/roger/Transcend
sdc      8:32   1  30,1G  0 disk 
├─sdc1   8:33   1   2,6G  0 part 
└─sdc2   8:34   1   3,9M  0 part 
sdd      8:48   1  58,9G  0 disk 
├─sdd1   8:49   1   3,5G  0 part 
└─sdd2   8:50   1   3,9M  0 part 
``` 

** Also you can use `sudo fdisk -l` to find the USB.

3. So in our case it is `/dev/sdc`.

4. Unmount the device. 
```sh
$ umount /dev/sdc1
```

5. Assuming the `.iso` file is in your current working folder, type the below command and wait for it to finish.
```sh
$ dd bs=4M if=ubuntu-20.04.1-desktop-amd64.iso of=/dev/sdc conv=fdatasync  status=progress
```

** For MacOSX
```sh
$ sudo dd if=inputfile.img of=/dev/disk<?> bs=4m && sync
```

## References:

* https://askubuntu.com/questions/372607/how-to-create-a-bootable-ubuntu-usb-flash-drive-from-terminal