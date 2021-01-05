# Installing and configuring Ardour in Ubuntu 2.04


## Steps

### 1. Install KXStudio repositories

- Ref: https://kx.studio/Repositories

```sh
// Requisites
sudo apt -yqq install apt-transport-https gpgv

// Remove legacy repos
sudo dpkg --purge kxstudio-repos-gcc5

// Download package file
wget -q https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb

// Install
sudo dpkg -i kxstudio-repos_10.0.3_all.deb

// Update package list
sudo apt update
```

### 2. Install Linux Performance Governor

```sh
sudo apt -yqq install indicator-cpufreq
```

### 3. Install Jack2 

#### Installing Jack2

We are going to install the Jack2 packages available for Ubuntu 18.04 which it's valid for 20.04.

```sh
mkdir -p $HOME/Downloads/jack2_pkgs/
cd $HOME/Downloads/jack2_pkgs/
wget -q http://archive.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-gtk2_2.24.0-5.1ubuntu2_amd64.deb
wget -q http://archive.ubuntu.com/ubuntu/pool/main/p/python-pathlib/python-pathlib_1.0.1-2_all.deb
wget -q http://archive.ubuntu.com/ubuntu/pool/universe/e/eyed3/python-eyed3_0.8.4-2_all.deb
wget -q http://archive.ubuntu.com/ubuntu/pool/universe/p/python-cddb/python-cddb_1.4-5.3_amd64.deb
wget -q http://archive.ubuntu.com/ubuntu/pool/universe/j/jack/jack_3.1.1+cvs20050801-29.2_amd64.deb

sudo apt install ./python-eyed3_0.8.4-2_all.deb \
    ./python-gtk2_2.24.0-5.1ubuntu2_amd64.deb \
    ./jack_3.1.1+cvs20050801-29.2_amd64.deb \
    ./python-cddb_1.4-5.3_amd64.deb \
    ./python-pathlib_1.0.1-2_all.deb

// Force the installation
sudo apt install jackd2

// Check installation
jackd --version
jackdmp version 1.9.12 tmpdir /dev/shm protocol 8
```

And We will install [Jack Mixer](https://pkgs.org/download/jack-mixer) available for Ubuntu 18.04 too.
```sh
wget -q http://archive.ubuntu.com/ubuntu/pool/universe/f/fpconst/python-fpconst_0.7.2-6_all.deb
wget -q http://archive.ubuntu.com/ubuntu/ubuntu/pool/universe/j/jack-mixer/jack-mixer_10-1build2_amd64.deb
sudo apt install ./python-fpconst_0.7.2-6_all.deb ./jack-mixer_10-1build2_amd64.deb
```

#### Removing Jack2

```sh
cd $HOME/Downloads/jack2_pkgs/
sudo apt remove ./python-eyed3_0.8.4-2_all.deb \
    ./python-gtk2_2.24.0-5.1ubuntu2_amd64.deb \
    ./jack_3.1.1+cvs20050801-29.2_amd64.deb \
    ./python-cddb_1.4-5.3_amd64.deb \
    ./python-pathlib_1.0.1-2_all.deb

sudo apt -y purge jack jackd2
sudo apt -y autoremove
sudo rm -rf /bin/jack*
```

### 4. Install Tools and Plugins from KXStudio repositories

#### Installing KXStudio tools and plugins

```sh
sudo apt -yqq install kxstudio-default-settings pulseaudio-module-jack cadence carla qjackctl \
    calf-plugins zam-plugins x42-plugins tap-plugins mcp-plugins lsp-plugins fil-plugins dpf-plugins amb-plugins \
    meterbridge cmt caps zynaddsubfx
```

#### Removing KXStudio tools and plugins

```sh
sudo apt -yqq remove kxstudio-default-settings pulseaudio-module-jack cadence carla qjackctl \
    calf-plugins zam-plugins x42-plugins tap-plugins mcp-plugins lsp-plugins fil-plugins dpf-plugins amb-plugins \
    meterbridge cmt caps zynaddsubfx

sudo apt -y autoremove
```

### 5. Ardour

#### Installing Ardour

Download the binary from here: https://ardour.org/

```sh
cmod +x ~/Downloads/Ardour-6.5.0-x86_64-gcc5.run
~/Downloads/Ardour-6.5.0-x86_64-gcc5.run


// Add user to 'audio' Linux group
sudo usermod -a -G audio $USER
```

#### Removing Ardour

Uninstalling ardour6 (remove /opt/Ardour-6.5.0 and config)
```sh
/opt/Ardour-6.5.0.uninstall.sh 
rm -rf ~/.config/ardour6
```


### 6. Configure Jack using Cadence


#### indicator-cpufreq
# https://itsfoss.com/cpufreq-ubuntu/
sudo apt-get remove indicator-cpufreq

### 

# Package jack is not available on Ubuntu 20.04, is it not required?
https://askubuntu.com/questions/1235485/package-jack-is-not-available-on-ubuntu-20-04-is-it-not-required


### install Simple Screen Recorder
sudo apt -y install simplescreenrecorder

# creado para crear un puente de pulse audio a jack (reproducir youtube y ardour simultaneamente)
https://ardour.org/jack-n-pulse.html
nano ~/.asoundrc

sudo apt -y install install pulseaudio pulseaudio-utils pulseaudio-module-jack pavucontrol
sudo apt -y remove install pulseaudio pulseaudio-utils pulseaudio-module-jack pavucontrol


# No mic volume with Zoom call
# How do I route audio to/from generic ALSA-using applications?
https://discourse.ardour.org/t/no-mic-volume-with-zoom-call/105255


# Ref: 
# https://facilitarelsoftwarelibre.blogspot.com/2018/05/instalar-y-configurar-jack-audio.html
# https://salmorejogeek.com/2019/09/01/instalar-y-configurar-jack-y-pulseaudio-bridge-via-cadence-en-debian-y-basadas-ubuntu-mint-extra-ardour/
# https://salmorejogeek.com/2020/05/10/instalar-y-configurar-jack-con-alsa-via-ubuntu-studio-controls-en-ubuntu-kubuntu-xubuntu-y-demas-sabores-oficiales/
