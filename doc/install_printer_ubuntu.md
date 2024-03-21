# Install and configure Printers in Ubuntu

## HP Printer

- https://developers.hp.com/hp-linux-imaging-and-printing/install/manual/distros/ubuntu


### Step 1: Install Dependency Packages

```sh
sudo apt-get install --assume-yes libcups2 cups libcups2-dev cups-bsd cups-client avahi-utils libavahi-client-dev libavahi-core-dev libavahi-common-dev libcupsimage2-dev libdbus-1-dev build-essential gtk2-engines-pixbuf ghostscript openssl libjpeg-dev libatk-adaptor libgail-common libsnmp-dev snmp-mibs-downloader libtool libtool-bin libusb-1.0-0-dev libusb-0.1-4 wget policykit-1 policykit-1-gnome automake1.11 python3-dbus.mainloop.pyqt5 python3-reportlab python3-notify2 python3-pyqt5 python3-dbus python3-gi python3-lxml python3-dev python3-pil python-is-python3 libsane libsane-dev sane-utils xsane


```

### Step 2: Download HPLIP

```sh
wget http://prdownloads.sourceforge.net/hplip/hplip-3.22.6.tar.gz
cd ~/Downloads/
tar xvfz hplip-3.22.6.tar.gz
cd hplip-3.22.6

```

### Step 3: Configure HPLIP for installation

For Ubuntu 20.04, x64 and above distros:
```sh
./configure --with-hpppddir=/usr/share/ppd/HP --libdir=/usr/lib64 --prefix=/usr --enable-network-build --enable-scan-build --enable-fax-build --enable-dbus-build --disable-qt4 --enable-qt5 --disable-class-driver --enable-doc-build --disable-policykit --disable-libusb01_build --disable-udev_sysfs_rules --enable-hpcups-install --disable-hpijs-install --disable-foomatic-ppd-install --disable-foomatic-drv-install --disable-cups-ppd-install --enable-cups-drv-install --enable-apparmor_build --enable-hplip_testing_flag
```

### Step 4: Run Make

```sh
make
```

### Step 5: Run Make Install

```sh
sudo make install

```

### Step 6: Post Installation Step(s)

```sh
sudo usermod -a -G lp $USER
```