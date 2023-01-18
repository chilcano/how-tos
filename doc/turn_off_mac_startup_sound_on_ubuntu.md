# Turn off Macbook/iMac startup sound on Ubuntu

## Steps

```sh
// Install efivar
$ sudo apt install efivar

// List the efi var
$ efivar -l | grep SystemAudioVolume
7c436110-ab2a-4bbb-a880-fe41995c9f82-SystemAudioVolume

// Set to 0 the efi var
$ sudo efivar -n 7c436110-ab2a-4bbb-a880-fe41995c9f82-SystemAudioVolume -p

GUID: 7c436110-ab2a-4bbb-a880-fe41995c9f82
Name: "SystemAudioVolume"
Attributes:
	Non-Volatile
	Boot Service Access
	Runtime Service Access
Value:
00000000  1a                                                |.               |
```


It seems that has not worked. LEt's try other option.

```sh
// Login as root
$ sudo su -

// Make the efi var mmutable
# chattr -i /sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82

// Change the efi var to 0 (muted)
# printf "\x07\x00\x00\x00\x00" > /sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82

// Make efi-var immutable again
# chattr +i /sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82

// Check if that worked
# efivar -n 7c436110-ab2a-4bbb-a880-fe41995c9f82-SystemAudioVolume -p

GUID: 7c436110-ab2a-4bbb-a880-fe41995c9f82
Name: "SystemAudioVolume"
Attributes:
	Non-Volatile
	Boot Service Access
	Runtime Service Access
Value:
00000000  00                                                |.               |           
``` 

You should see this:

```sh
...
Value:
00000000  00                                                |.               |
```

## References

1. How to install `efivar`: https://howtoinstall.co/es/efivar
2. Turn off Macbook startup sound - Linux / gist: https://gist.github.com/0xbb/ae298e2798e1c06d0753
3. How do I disable the Mac startup sound?: https://askubuntu.com/questions/70938/how-do-i-disable-the-mac-startup-sound
4. Mute startup chime - ArchLinux: https://wiki.archlinux.org/title/Mac#Mute_startup_chime
5. Disabling MacBook Startup Sound in Linux: http://atodorov.org/blog/2015/04/27/disabling-macbook-startup-sound-in-linux/
