# ThinkPad P15v Gen3 (21D8)

## Ref

- Question on Lenovo forum: https://forums.lenovo.com/t5/Ubuntu/HDMI-doesn-t-work-on-Ubuntu-23-04
- Lenovo official specs: https://psref.lenovo.com/Product/ThinkPad/ThinkPad_P15v_Gen_3_Intel?MT=21D8

## Info

```sh

○ cat /proc/driver/nvidia/version 
NVRM version: NVIDIA UNIX x86_64 Kernel Module  535.113.01  Tue Sep 12 19:41:24 UTC 2023
GCC version:  


○ lspci -k | grep -A 2 -i "VGA"   
00:02.0 VGA compatible controller: Intel Corporation Alder Lake-P Integrated Graphics Controller (rev 0c)
	Subsystem: Lenovo Alder Lake-P Integrated Graphics Controller
	Kernel driver in use: i915


○ sudo ubuntu-drivers list --gpgpu
 
nvidia-driver-535-server-open, (kernel modules provided by linux-modules-nvidia-535-server-open-generic-hwe-22.04)
nvidia-driver-535-open, (kernel modules provided by linux-modules-nvidia-535-open-generic-hwe-22.04)
nvidia-driver-535-server, (kernel modules provided by linux-modules-nvidia-535-server-generic-hwe-22.04)
nvidia-driver-535, (kernel modules provided by linux-modules-nvidia-535-generic-hwe-22.04)

nvidia-driver-525-server, (kernel modules provided by linux-modules-nvidia-525-server-generic-hwe-22.04)
nvidia-driver-525-open, (kernel modules provided by linux-modules-nvidia-525-open-generic-hwe-22.04)
nvidia-driver-525, (kernel modules provided by linux-modules-nvidia-525-generic-hwe-22.04)

nvidia-driver-470-server, (kernel modules provided by linux-modules-nvidia-470-server-generic-hwe-22.04)
nvidia-driver-470, (kernel modules provided by linux-modules-nvidia-470-generic-hwe-22.04)

```

### 1. Update BIOS firmware

From Update Ubuntu Software GUI.
![Update from  1.18 to 1.19]()

From CLI.

```sh
○ fwupdmgr get-devices
LENOVO 21D8CTO1WW
│
├─12th Gen Intel Core™ i7-12700H:
│     Device ID:          4bde70ba4e39b28f9eab1628f9dd6e6244c03027
│     Current version:    0x0000042c
│     Vendor:             Intel
│     GUIDs:              b9a2dd81-159e-5537-a7db-e7101d164d3f ← cpu
│                         30249f37-d140-5d3e-9319-186b1bd5cac3 ← CPUID\PRO_0&FAM_06
│                         ab855c04-4ff6-54af-8a8a-d8193daa0cd8 ← CPUID\PRO_0&FAM_06&MOD_9A
│                         3ebbde86-d03e-549a-a8fd-02ebf9aa537a ← CPUID\PRO_0&FAM_06&MOD_9A&STP_3
│     Device Flags:       • Internal device
│   
├─Alder Lake-P Integrated Graphics Controller:
│     Device ID:          5792b48846ce271fab11c4a545f7a3df0d36e00a
│     Current version:    0c
│     Vendor:             Intel Corporation (PCI:0x8086)
│     GUIDs:              eaad9970-8e4d-56da-88ab-41a8c1e2811f ← PCI\VEN_8086&DEV_46A6
│                         ed0b9458-c2f1-54c5-9063-dea8f75b4039 ← PCI\VEN_8086&DEV_46A6&REV_0C
│                         2f8c21a3-2b64-5d23-9099-fc13754a2f47 ← PCI\VEN_8086&DEV_46A6&SUBSYS_17AA22F7
│                         3cc51380-2757-5a8f-81f9-9fd0c4ae69d1 ← PCI\VEN_8086&DEV_46A6&SUBSYS_17AA22F7&REV_0C
│                         c4625510-a985-517c-8800-0ecfc6f68c8f ← PCI\VEN_8086&DEV_46A6&REV_00
│                         d3396887-686f-5ee4-8f02-fb2d76c78f0a ← PCI\VEN_8086&DEV_46A6&SUBSYS_17AA22F7&REV_00
│     Device Flags:       • Internal device
│                         • Cryptographic hash verification is available

...

└─UEFI Device Firmware:
      Device ID:          a083ebc5138e5e071ef7270cc9a8280722cc7adf
      Summary:            UEFI ESRT device
      Current version:    18548864
      Minimum Version:    1
      Vendor:             DMI:LENOVO
      Update State:       Success
      GUID:               da6451ea-f4f7-4a81-b603-b62b9eea2401
      Device Flags:       • Internal device
                          • Updatable
                          • System requires external power source
                          • Needs a reboot after installation
                          • Device is usable for the duration of the update
    
────────────────────────────────────────────────
Devices that have been updated successfully:
 • Prometheus (10.01.3273255 → 10.01.3478575)
 • System Firmware (0.1.18 → 0.1.19)
 • Intel Management Engine (1.25.1932 → 1.27.2176)

```
And to update:
```sh
○ fwupdmgr get-updates

Devices with no available firmware updates: 
 • Integrated Camera
 • UEFI Device Firmware
 • UEFI Device Firmware
 • UEFI Device Firmware
 • UEFI Device Firmware
 • UEFI Device Firmware
 • UEFI Device Firmware
 • UEFI Device Firmware
 • UEFI Device Firmware
 • UEFI Device Firmware
 • UEFI dbx
Devices with the latest available firmware version:
 • Embedded Controller
 • Intel Management Engine
 • Micron MTFDKBA1T0TFK
 • Prometheus
 • Prometheus IOTA Config
 • System Firmware
 • TPM

```
