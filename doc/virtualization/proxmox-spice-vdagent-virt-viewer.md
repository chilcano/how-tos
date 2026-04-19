# SPICE and vdagent on Proxmox to get better remote Ubuntu Desktop experience

## Overview

Replace the Proxmox noVNC console with a SPICE connection for bidirectional clipboard, dynamic resolution, and better performance. Works with Ubuntu 24.04 (GNOME/XFCE) and also tested on Fedora and Windows guests, with Linux, macOS, and Windows clients.

## Prerequisites

**Proxmox host:**
- Proxmox VE 7.x or 8.x
- VM already created and running Ubuntu 24.04 with a desktop environment

**Client machine (the machine you connect _from_):**
- Linux (Ubuntu/Debian, Fedora, Arch, etc.) — Windows and macOS clients also exist but are less straightforward
- `virt-viewer` package installed (see Step 3)
- Network access to the Proxmox host (same LAN or VPN)

## Step 1 — Configure the VM in Proxmox

### Enable QEMU Guest Agent

1. In the Proxmox web UI, select your VM.
2. Go to **Options** → **QEMU Guest Agent**.
3. Check **Enabled** → **OK**.

### Set display to SPICE

1. Go to **Hardware** → double-click **Display**.
2. Change the display type to **SPICE**.
3. Optionally set **Max Resolution** (e.g. 1920x1080).
4. Click **OK**.

> If you do not see a Display entry, add one via **Add → Display Device**.

## Step 2 — Install required packages inside the VM

Connect to the VM via noVNC or SSH, then run:

```bash
sudo apt update
sudo apt install -y qemu-guest-agent spice-vdagent xserver-xorg-video-qxl
```

> `xserver-xorg-video-qxl` is the display driver required for SPICE rendering. Without it, the remote-viewer window connects but shows a blank screen.

**Reboot the VM** to apply the Proxmox configuration changes and activate the agents:

```bash
sudo reboot
```

After reboot, confirm the guest agent is working by checking the Proxmox web UI: the VM **Summary** tab should show the guest IP address.

## Step 3 — Install a SPICE client on the client machine

### Linux (Ubuntu/Debian)

```bash
sudo apt install -y virt-viewer
```

### Linux (Fedora/RHEL)

```bash
sudo dnf install -y virt-viewer
```

### Windows

Download latest [Virt Viewer for Windows - virt-viewer-x64-11.0-1.0.msi](https://gitlab.com/virt-viewer/virt-viewer/-/releases) from the official Virt Manager releases page. 

### macOS

```bash
brew install virt-viewer
```

## Step 4 — Connect via SPICE

1. In the Proxmox web UI, select your VM.
2. Click **Console** → **SPICE**.
3. A `.vv` connection file is downloaded automatically.
4. Open it with `remote-viewer`:

```bash
remote-viewer ~/Downloads/pve-spice.vv
```

Or double-click the `.vv` file if your file manager opens it with `remote-viewer`.

> The `.vv` file contains a one-time token — open it promptly after downloading.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Proxmox VM Summary does not show guest IP after reboot | Ensure QEMU Guest Agent is enabled under VM → Options and the `qemu-guest-agent` package is installed in the guest |
| Clipboard still does not work | Log out and back into the desktop session to restart `spice-vdagent`, or reinstall the package |
| Blank screen with "Connected to graphic server" | Install the QXL driver in the guest: `sudo apt install xserver-xorg-video-qxl` then reboot |
| Black screen when connecting via SPICE | Reboot the VM after setting the display to SPICE in Proxmox |
| `.vv` file opens but connection is refused | Allow the SPICE port range (TCP 5900+) in the Proxmox host firewall |
| Resolution does not resize | Ensure `spice-vdagent` is installed in the guest and a desktop session is active |
| `remote-viewer` not found | Install `virt-viewer` on the client machine |

## Resources

- [Proxmox VE — SPICE documentation](https://pve.proxmox.com/wiki/SPICE)
- [Virt Viewer project (remote-viewer)](https://gitlab.com/virt-viewer/virt-viewer)
- [spice-vdagent on freedesktop](https://gitlab.freedesktop.org/spice/linux/vd_agent)
- [QEMU Guest Agent — Proxmox wiki](https://pve.proxmox.com/wiki/Qemu-guest-agent)
