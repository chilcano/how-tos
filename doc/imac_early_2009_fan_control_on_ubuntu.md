# Install and setup Mac Fan Control on Ubuntu 22.04

- iMac 24" early 2009 (3 fans: HD, CPU and Optical)
- Ubuntu 22.04
- mbpfan - https://github.com/linux-on-mac/mbpfan#ubuntu

## Steps

### 1. Install Mac Fan Control

I'm using [`mbpfan`](https://github.com/linux-on-mac/mbpfan#ubuntu).

```sh
$ sudo apt-get install mbpfan
```

### 2. Install Apple Linux modules

Check if you have them:
```sh
$ lsmod | grep -e applesmc -e coretemp
applesmc               24576  0
coretemp               24576  0
```
If you have above output, then load them at boot time. Only add them to ``
```sh
$ sudo nano /etc/modules

applesmc 
coretemp
```

### 3. Detect how many fans your iMac has

You will see using this:
```sh
$ ls -la /sys/devices/platform/applesmc.768/fan*_max

-r--r--r-- 1 root root 4096 ene 17 19:03 /sys/devices/platform/applesmc.768/fan1_max
-r--r--r-- 1 root root 4096 ene 17 19:03 /sys/devices/platform/applesmc.768/fan2_max
-r--r--r-- 1 root root 4096 ene 17 19:03 /sys/devices/platform/applesmc.768/fan3_max

$ ls -la /sys/devices/platform/applesmc.768/fan*_min
-rw-r--r-- 1 root root 4096 ene 17 19:03 /sys/devices/platform/applesmc.768/fan1_min
-rw-r--r-- 1 root root 4096 ene 17 19:03 /sys/devices/platform/applesmc.768/fan2_min
-rw-r--r-- 1 root root 4096 ene 17 19:03 /sys/devices/platform/applesmc.768/fan3_min
```
That means we have 3 fans and we are able to configure all 3 fans using this file `/etc/mbpfan.conf`.


### 4. Getting min and max fan speed and max temperature

```sh
$ cat /sys/devices/platform/applesmc.768/fan*_min
800
1600
1200

$ cat /sys/devices/platform/applesmc.768/fan*_max
4800
5900
3600

$ cat /sys/devices/platform/coretemp.*/hwmon/hwmon*/temp*_max
105000
105000
```

Now, with these values configure `/etc/mbpfan.conf`.

```sh
$ sudo nano /etc/mbpfan.conf

[general]
# see https://ineed.coffee/3838/a-beginners-tutorial-for-mbpfan-under-ubuntu for the values
# 
# mbpfan will load the max / min speed of from the files produced by the applesmc driver. If these files are not found it will set all fans to the default of min_speed = 2000 and >
# by setting the values for the speeds in this config it will override whatever it finds in:
# /sys/devices/platform/applesmc.768/fan*_min
# /sys/devices/platform/applesmc.768/fan*_max
# or the defaults.
#
# multiple fans can be configured by using the config key of min_fan*_speed and max_fan*_speed
# the number used will correlate to the file number of the fan in the applesmc driver that are used to control the fan speed.
#
#min_fan1_speed = 2000  # put the *lowest* value of "cat /sys/devices/platform/applesmc.768/fan*_min"
#max_fan1_speed = 6200  # put the *highest* value of "cat /sys/devices/platform/applesmc.768/fan*_max"

min_fan1_speed = 800
max_fan1_speed = 5900
min_fan2_speed = 800
max_fan2_speed = 5900
min_fan3_speed = 800
max_fan3_speed = 5900

low_temp = 63                   # try ranges 55-63, default is 63
high_temp = 66                  # try ranges 58-66, default is 66
#max_temp = 86                  # take highest number returned by "cat /sys/devices/platform/coretemp.*/hwmon/hwmon*/temp*_max", divide by 1000
max_temp = 105

polling_interval = 1    # default is 1 seconds
```

### 5. Restart the `mbpfan` service

```sh
$ sudo systemctl restart mbpfan

$ sudo systemctl status mbpfan
● mbpfan.service - A fan manager daemon for MacBook Pro
     Loaded: loaded (/lib/systemd/system/mbpfan.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2023-01-17 19:34:56 CET; 23min ago
   Main PID: 4464 (mbpfan)
      Tasks: 1 (limit: 9150)
     Memory: 208.0K
        CPU: 40ms
     CGroup: /system.slice/mbpfan.service
             └─4464 /usr/sbin/mbpfan -f

ene 17 19:34:56 maccuy systemd[1]: Started A fan manager daemon for MacBook Pro.
```