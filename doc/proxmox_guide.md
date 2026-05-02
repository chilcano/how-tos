# Proxmox VE Guide

> Proxmox VE version: **9.1.7**

Tips, tricks, and helpful notes for managing Proxmox VE and its VMs.

---

## Set a static IP on an Ubuntu 24.04 VM

### Proxmox side

In the Proxmox web UI go to the VM → **Hardware** → **Network Device** and confirm the bridge
is `vmbr0`. This is the default bridge over the host's physical NIC — VMs on it appear on the
LAN like physical machines. No change needed if it is already set.

### Ubuntu side

Ubuntu 24.04 uses Netplan for network configuration.

**1. Find the interface name**

```sh
ip link
# look for something like ens18, eth0, enp6s18
```

**2. Edit the Netplan config**

```sh
sudo nano /etc/netplan/00-installer-config.yaml
```

```yaml
network:
  version: 2
  ethernets:
    ens18:              # replace with your interface name
      dhcp4: false
      addresses:
        - 192.168.1.100/24    # static IP you want, must be on your LAN subnet
      routes:
        - to: default
          via: 192.168.1.1    # your router/gateway IP
      nameservers:
        addresses: [1.1.1.1, 8.8.8.8]
```

**3. Fix permissions and apply**

```sh
sudo chmod 600 /etc/netplan/00-installer-config.yaml
sudo netplan apply
```

**4. Verify**

```sh
ip a show ens18
ping 192.168.1.1
```

### Reference values

| Item | How to find it |
|---|---|
| LAN subnet | Check another device: `ip route` or router admin page |
| Gateway IP | Typically `192.168.x.1` — same as router admin IP |
| Free static IP | Pick one outside your router's DHCP range to avoid conflicts |
